"""Official Copernicus EMS flood layer: image date, clip to our bounds, and compare.png."""
import re
import zipfile
from datetime import datetime, timezone

import geopandas as gpd
import numpy as np
import shapely
from PIL import Image
from rasterio.transform import from_bounds
from rasterio.warp import Resampling, calculate_default_transform, reproject
from shapely.geometry import box

from emsr857_dates import dates_in

from .common import EMS_ZIP, feature, feature_collection, gate, polygon_parts, polygon_to_geojson
from .layers import to_mask

# compare.png palette index -> (legend name, RGB). Index 0 is transparent: "not compared".
COMPARE_CLASSES = {
    1: ("both", (34, 170, 85)),
    2: ("only_ours", (214, 40, 40)),
    3: ("only_ems", (40, 90, 214)),
}
# Allowed distance from the notebook's own validation of the same comparison.
MAX_IOU_DRIFT = 0.005
MAX_COUNT_DRIFT = 0.01


def _layer(zip_path, name):
    prefix = re.sub(r"_v\d+$", "", zip_path.stem)
    return gpd.read_file(f"/vsizip/{zip_path.as_posix()}/{prefix}_{name}")


def resolve_image_time(sources, flood_source_ids):
    """Acquisition time of the image behind the flood polygons, as an aware UTC datetime.

    The zip also holds pre-event source dates and a production date, so the time has to
    come from the source row that the polygons point to through dmg_src_id.
    """
    ids = {int(i) for i in flood_source_ids}
    gate(len(ids) == 1, f"EMS flood polygons come from several images: {sorted(ids)}")
    rows = sources[sources["src_id"].astype(int) == ids.pop()]
    gate(len(rows) == 1, "EMS source table has no single row for the flood polygons")
    row = rows.iloc[0]
    gate(row["eventphase"] == "Post-event", f"EMS flood image is not post-event: {row['eventphase']}")
    stamp = datetime.strptime(f"{row['src_date']} {row['source_tm']}", "%d/%m/%Y T%H:%M:%SZ")
    return stamp.replace(tzinfo=timezone.utc), str(row["source_nam"])


def _check_against_helper(zip_path, image_time):
    """The date must also be one of those tools/emsr857_dates.py finds in the same source file."""
    with zipfile.ZipFile(zip_path) as zf:
        name = next(n for n in zf.namelist() if n.lower().endswith("_source_v1.dbf"))
        found = dates_in(zf.read(name).decode("latin-1", "ignore"))
    gate(image_time.strftime("%Y-%m-%d") in found, f"EMS image date not among the helper's dates {found}")


def load_ems(raster_box, zip_path=EMS_ZIP):
    """Flood polygons and AOI clipped to the raster box, plus the image time."""
    sources = _layer(zip_path, "source_v1.dbf")
    observed = _layer(zip_path, "observedEventA_v1.shp").to_crs("EPSG:4326")
    aoi = _layer(zip_path, "areaOfInterestA_v1.shp").to_crs("EPSG:4326").union_all()
    image_time, sensor = resolve_image_time(sources, observed["dmg_src_id"])
    _check_against_helper(zip_path, image_time)

    bbox = box(*raster_box)
    flood = polygon_parts(shapely.make_valid(shapely.union_all(shapely.make_valid(observed.geometry.values))))
    return {
        "flood": polygon_parts(flood.intersection(bbox)),
        "aoi": polygon_parts(aoi.intersection(bbox)),
        "aoi_share_of_bounds": aoi.intersection(bbox).area / bbox.area,
        "image_time": image_time,
        "sensor": sensor,
        "product": zip_path.stem,
        "layer": f"{re.sub(r'_v[0-9]+$', '', zip_path.stem)}_observedEventA_v1",
    }


def build_ems_geojson(ems):
    """flood_ems.geojson: one dissolved flood feature and the mapped-area outline."""
    gate(not ems["flood"].is_empty, "EMS flood layer is empty inside our bounds")
    return feature_collection([
        feature({"layer": "flood"}, polygon_to_geojson(ems["flood"])),
        feature({"layer": "aoi"}, polygon_to_geojson(ems["aoi"])),
    ])


def classify_compare(ours, ems, aoi):
    """Palette indices: 1 both, 2 only ours, 3 only EMS, 0 outside the EMS mapped area or dry in both."""
    out = np.zeros(ours.shape, "uint8")
    out[ours & ems & aoi] = 1
    out[ours & ~ems & aoi] = 2
    out[~ours & ems & aoi] = 3
    return out


def compare_stats(classes, pixel_m2, ours, aoi):
    counts = {name: int((classes == idx).sum()) for idx, (name, _) in COMPARE_CLASSES.items()}
    total = sum(counts.values())
    return {
        "pixels": counts,
        "pixel_area_m2": pixel_m2,
        "iou": round(counts["both"] / total, 4) if total else None,
        "our_flood_pixels_outside_ems_area": int((ours & ~aoi).sum()),
    }


def check_against_report(stats, report):
    """Gate: this comparison must reproduce the notebook's new_flood_vs_reference."""
    ref = report["new_flood_vs_reference"]
    gate(abs(stats["iou"] - ref["IoU"]) <= MAX_IOU_DRIFT, f"compare IoU {stats['iou']} vs report {ref['IoU']}")
    pairs = (("both", "tp_px"), ("only_ours", "fp_px"), ("only_ems", "fn_px"))
    for name, key in pairs:
        ours, theirs = stats["pixels"][name], ref[key]
        gate(abs(ours - theirs) <= MAX_COUNT_DRIFT * theirs, f"compare {name} {ours} vs report {key} {theirs}")


def write_compare_png(path, classes, raster, bounds):
    """Regrid (nearest) onto the exact manifest bounds in EPSG:4326 and save as a palette PNG."""
    height, width = classes.shape
    _, w, h = calculate_default_transform(raster.crs, "EPSG:4326", width, height, *raster.bounds)
    dst = np.zeros((h, w), "uint8")
    target = from_bounds(bounds["west"], bounds["south"], bounds["east"], bounds["north"], w, h)
    reproject(classes, dst, src_transform=raster.transform, src_crs=raster.crs,
              dst_transform=target, dst_crs="EPSG:4326", resampling=Resampling.nearest)
    image = Image.fromarray(dst)
    image.putpalette([0, 0, 0] + [c for idx in sorted(COMPARE_CLASSES) for c in COMPARE_CLASSES[idx][1]])
    image.save(path, format="PNG", optimize=True, transparency=0)
    return {"width": w, "height": h}


def build_compare(path, mask_raster, ems, report, bounds):
    ours = mask_raster.data == 1
    ems_px = to_mask([ems["flood"]], mask_raster)
    aoi_px = to_mask([ems["aoi"]], mask_raster)
    classes = classify_compare(ours, ems_px, aoi_px)
    stats = compare_stats(classes, mask_raster.pixel_m2, ours, aoi_px)
    check_against_report(stats, report)
    stats["image"] = write_compare_png(path, classes, mask_raster, bounds)
    stats["colors"] = {name: "#%02X%02X%02X" % rgb for name, rgb in COMPARE_CLASSES.values()}
    return stats
