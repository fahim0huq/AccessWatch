"""Average and highest estimated water depth on each area's way in.

Definition (also written to manifest.water_depth): flood/depth.tif is sampled every
SAMPLE_STEP_M metres along the area's safest route in routes.geojson. Samples that fall
on flooded pixels (a finite depth above 0) are kept. mean_depth_m is their mean and
max_depth_m their highest value, both rounded to 0.1 m. Both are null when the route
crosses no flooded pixel.

Why the route: it is the water a team actually has to get through to reach the area.
The area itself is mostly dry land cut off by water, and "cells around it" would need
a buffer size that the data does not give.
"""
import math

import numpy as np
from pyproj import Transformer
from rasterio.transform import rowcol
from shapely.geometry import LineString

from .common import gate

SAMPLE_STEP_M = 10.0
DECIMALS = 1
DEFINITION = (
    "Estimated depth (flood/depth.tif, from a 30 m terrain model) sampled every 10 m along the "
    "area's safest route; mean and highest of the samples on flooded pixels, rounded to 0.1 m. "
    "A guide, not a measurement."
)


def sample_line(coords_wgs84, raster, step_m=SAMPLE_STEP_M):
    """Depth values on flooded pixels along a WGS84 line, every step_m metres."""
    to_raster = Transformer.from_crs("EPSG:4326", raster.crs, always_xy=True)
    line = LineString([to_raster.transform(lon, lat) for lon, lat in coords_wgs84])
    count = max(1, math.ceil(line.length / step_m))
    rows, cols = raster.data.shape
    values = []
    for i in range(count + 1):
        point = line.interpolate(min(i * step_m, line.length))
        row, col = rowcol(raster.transform, point.x, point.y)
        if 0 <= row < rows and 0 <= col < cols:
            value = float(raster.data[row, col])
            if math.isfinite(value) and value > 0:
                values.append(value)
    return values


def summarise(values):
    """(mean_m, max_m) rounded to 0.1 m, or (None, None) when nothing is flooded."""
    if not values:
        return None, None
    return round(float(np.mean(values)), DECIMALS), round(float(np.max(values)), DECIMALS)


def add_water_depth(cards, routes_fc, raster):
    """Adds mean_depth_m and max_depth_m to every mission card, from its safest route."""
    safest = {}
    for f in routes_fc["features"]:
        if f["properties"]["route_type"] == "safest":
            gate(f["properties"]["pocket_id"] not in safest, f"two safest routes for {f['properties']['pocket_id']}")
            safest[f["properties"]["pocket_id"]] = f["geometry"]["coordinates"]
    finite = raster.data[np.isfinite(raster.data)]
    ceiling = float(finite.max()) if finite.size else 0.0
    for card in cards:
        pid = card["pocket_id"]
        gate(pid in safest, f"no safest route for {pid}, so its water depth cannot be estimated")
        mean_m, max_m = summarise(sample_line(safest[pid], raster))
        if mean_m is not None:
            gate(0 < mean_m <= max_m <= round(ceiling, DECIMALS) + 0.05, f"{pid}: depth {mean_m}/{max_m} m is out of range")
        card["mean_depth_m"] = mean_m
        card["max_depth_m"] = max_m
    return {"definition": DEFINITION, "sample_step_m": SAMPLE_STEP_M, "source": "flood/depth.tif"}
