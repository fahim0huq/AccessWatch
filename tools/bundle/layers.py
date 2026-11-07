"""Flood, baseline, depth, pocket, route and mission layers."""
import math
from dataclasses import dataclass

import geopandas as gpd
import numpy as np
import rasterio
import shapely
from rasterio.features import rasterize, shapes
from rasterio.warp import transform_bounds
from shapely.geometry import shape

from .common import SRC, feature, feature_collection, gate, line_to_geojson, polygon_to_geojson, read_json

MIN_PIXEL_AGREEMENT = 0.999
# Removed from mission cards: the app builds all visible text itself from the fields (ARB).
CARD_TEXT_FIELDS = {"title", "summary", "alert_text", "verify_notes", "population_note", "data"}


@dataclass
class Raster:
    data: np.ndarray
    transform: object
    crs: object
    bounds: object
    pixel_m2: float


def read_raster(name):
    with rasterio.open(SRC / "flood" / name) as r:
        return Raster(r.read(1), r.transform, r.crs, r.bounds, abs(r.res[0] * r.res[1]))


def wgs84_bounds(raster):
    """Exact raster box in EPSG:4326 as (west, south, east, north)."""
    return transform_bounds(raster.crs, "EPSG:4326", *raster.bounds)


def outward_5dp(west, south, east, north):
    scale = 10 ** 5
    return {
        "west": math.floor(west * scale) / scale,
        "south": math.floor(south * scale) / scale,
        "east": math.ceil(east * scale) / scale,
        "north": math.ceil(north * scale) / scale,
    }


def to_mask(geoms, raster, crs="EPSG:4326"):
    """Burn geometries onto the raster grid (pixel centre rule)."""
    projected = gpd.GeoSeries(geoms, crs=crs).to_crs(raster.crs)
    return rasterize(projected, out_shape=raster.data.shape, transform=raster.transform,
                     fill=0, default_value=1, dtype="uint8").astype(bool)


def check_agreement(geojson_geoms, pixels, raster, label):
    burned = to_mask([shape(g) for g in geojson_geoms], raster)
    union = (burned | pixels).sum()
    iou = (burned & pixels).sum() / union if union else 1.0
    gate(iou >= MIN_PIXEL_AGREEMENT, f"{label}: polygons match their raster only at IoU {iou:.4f}")


def polygonize(raster, value):
    """Exact pixel-edge polygons of one raster value, in EPSG:4326, with area_ha from the UTM grid."""
    pixels = raster.data == value
    geoms = [shape(g) for g, _ in shapes(raster.data, mask=pixels, transform=raster.transform, connectivity=4)]
    series = gpd.GeoSeries(geoms, crs=raster.crs)
    areas = series.area / 10_000
    return list(zip(series.to_crs("EPSG:4326"), areas))


def build_flood(mask):
    """flood.geojson: the notebook's polygons, repaired (some have self-intersecting rings)."""
    src = read_json(SRC / "flood" / "flood_polygons.geojson")["features"]
    feats = []
    for f in src:
        geom = polygon_to_geojson(shape(f["geometry"]))
        if geom:
            feats.append(feature({"area_ha": f["properties"]["area_ha"]}, geom))
    check_agreement([f["geometry"] for f in feats], mask.data == 1, mask, "flood.geojson")
    return feature_collection(feats)


def build_baseline():
    raster = read_raster("flood_baseline_threshold.tif")
    feats = []
    for geom, area_ha in polygonize(raster, 1):
        out = polygon_to_geojson(geom)
        if out:
            feats.append(feature({"area_ha": round(float(area_ha), 2)}, out))
    check_agreement([f["geometry"] for f in feats], raster.data == 1, raster, "flood_baseline.geojson")
    return feature_collection(feats), raster


def build_depth_zones():
    """depth_zones.geojson: one feature per connected patch of depth class 1, 2 or 3."""
    raster = read_raster("depth_class.tif")
    feats = []
    for cls in (1, 2, 3):
        cls_geoms = []
        for geom, _ in polygonize(raster, cls):
            out = polygon_to_geojson(geom)
            if out:
                cls_geoms.append(out)
                feats.append(feature({"depth_class": cls}, out))
        if cls_geoms:
            check_agreement(cls_geoms, raster.data == cls, raster, f"depth_zones class {cls}")
    return feature_collection(feats)


def build_pockets():
    """pockets.geojson: every source field unchanged; geometry and lon/lat on 5 decimals."""
    src = read_json(SRC / "pockets" / "pockets.geojson")["features"]
    feats = []
    for f in src:
        props = dict(f["properties"])
        props["lon"], props["lat"] = round(props["lon"], 5), round(props["lat"], 5)
        feats.append(feature(props, polygon_to_geojson(shape(f["geometry"]))))
    return feature_collection(feats), [(f["properties"]["pocket_id"], shape(f["geometry"])) for f in src]


def build_routes():
    src = read_json(SRC / "routes" / "routes.geojson")["features"]
    return feature_collection([feature(f["properties"], line_to_geojson(f["geometry"]["coordinates"])) for f in src])


def build_missions(pocket_ids):
    """missions.json: mission cards without their ready-made English text."""
    src = read_json(SRC / "mission_cards.json")
    cards = []
    for card in src["cards"]:
        out = {k: v for k, v in card.items() if k not in CARD_TEXT_FIELDS}
        out["location"] = {**card["location"], "lat": round(card["location"]["lat"], 5),
                           "lon": round(card["location"]["lon"], 5)}
        cards.append(out)
    gate({c["pocket_id"] for c in cards} == set(pocket_ids), "mission cards and pockets name different pockets")
    return {"event": src["event"], "synthetic_demo": src["synthetic_demo"],
            "generated": src["generated"], "cards": cards}


def geometry_bounds(collections):
    """Box around several GeoJSON collections (features or plain shapely geometries)."""
    geoms = []
    for items in collections:
        geoms.extend(shape(f["geometry"]) if isinstance(f, dict) else f for f in items)
    return shapely.total_bounds(np.array(geoms, dtype=object))
