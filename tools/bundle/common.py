"""Paths, gates and 5-decimal GeoJSON helpers shared by the bundle modules."""
import json
from pathlib import Path

import shapely
from shapely.geometry import MultiPolygon

REPO = Path(__file__).resolve().parents[2]
SRC = REPO / "data_sample" / "notebook_outputs"
EMS_ZIP = REPO / "Data" / "EMSR857_products" / "EMSR857_AOI01_DEL_PRODUCT_v1.zip"
OUT = REPO / "accesswatch_mobile" / "assets" / "bundle"
MAX_BUNDLE_BYTES = 8 * 1024 * 1024
DECIMALS = 5


class GateError(RuntimeError):
    """A build check failed: the bundle must not be published."""


def gate(ok, message):
    if not ok:
        raise GateError(message)


def read_json(path):
    return json.loads(Path(path).read_text(encoding="utf-8"))


def write_json(path, obj):
    text = json.dumps(obj, separators=(",", ":"), ensure_ascii=False, allow_nan=False)
    Path(path).write_text(text, encoding="utf-8", newline="")


def round_coords(value):
    if isinstance(value, (list, tuple)):
        return [round_coords(v) for v in value]
    return round(float(value), DECIMALS)


def polygon_parts(geom):
    """Keep only the polygon parts: repairing or clipping can leave stray lines and points."""
    if geom.geom_type in ("Polygon", "MultiPolygon"):
        return geom
    polys = []
    for part in getattr(geom, "geoms", []):
        if part.geom_type in ("Polygon", "MultiPolygon"):
            found = polygon_parts(part)
            polys.extend(found.geoms if found.geom_type == "MultiPolygon" else [found])
    return MultiPolygon(polys)


def polygon_to_geojson(geom):
    """Valid polygon GeoJSON on the 5-decimal grid, or None if nothing remains."""
    grid = 10.0 ** -DECIMALS
    snapped = polygon_parts(shapely.set_precision(shapely.make_valid(geom), grid))
    if snapped.is_empty:
        return None
    gate(snapped.is_valid, "polygon is invalid after rounding to 5 decimals")
    out = json.loads(shapely.to_geojson(snapped))
    out["coordinates"] = round_coords(out["coordinates"])
    return out


def line_to_geojson(coords):
    """LineString on 5 decimals; drops consecutive vertices that rounding made identical."""
    out = []
    for lon, lat in (round_coords(c[:2]) for c in coords):
        if not out or out[-1] != [lon, lat]:
            out.append([lon, lat])
    return {"type": "LineString", "coordinates": out}


def feature(properties, geometry):
    return {"type": "Feature", "properties": properties, "geometry": geometry}


def feature_collection(features):
    return {"type": "FeatureCollection", "features": features}
