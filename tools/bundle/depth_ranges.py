"""Depth class limits for manifest.json.

Read from notebook config values in the source files when present, otherwise from
docs/SCHEMA.md, then checked against the rasters so a wrong limit stops the build.
"""
import re

import numpy as np

from .common import REPO, gate

SCHEMA = REPO / "docs" / "SCHEMA.md"
SCHEMA_ROW = re.compile(r"`depth_class\.tif`.*?shallow \(<\s*([\d.]+)\s*m\).*?medium \(<\s*([\d.]+)\s*m\)")
CONFIG_KEY = re.compile(r"^(?:depth_)?(shallow|medium)_?(?:depth_)?(?:max|limit|thresh|threshold)(?:_m)?$", re.I)
# depth.tif is stored as float32 and classed from unrounded values.
RASTER_TOLERANCE_M = 0.001


def _walk(node):
    if isinstance(node, dict):
        for key, value in node.items():
            yield key, value
            yield from _walk(value)
    elif isinstance(node, list):
        for value in node:
            yield from _walk(value)


def limits_from_config(*documents):
    """{'shallow': m, 'medium': m} if a source document holds both limits, else None."""
    found = {}
    for document in documents:
        for key, value in _walk(document):
            match = CONFIG_KEY.match(str(key))
            if match and isinstance(value, (int, float)):
                found[match.group(1).lower()] = float(value)
    return found if {"shallow", "medium"} <= found.keys() else None


def limits_from_schema(text):
    match = SCHEMA_ROW.search(text)
    gate(match is not None, "depth limits not found in the depth_class.tif row of docs/SCHEMA.md")
    return {"shallow": float(match.group(1)), "medium": float(match.group(2))}


def check_against_rasters(limits, depth, classes):
    """Every pixel of depth.tif must fall inside the limits of its class in depth_class.tif."""
    gate(0 < limits["shallow"] < limits["medium"], f"depth limits are out of order: {limits}")
    finite = np.isfinite(depth)
    tol = RASTER_TOLERANCE_M
    for code, low, high in ((1, None, limits["shallow"]),
                            (2, limits["shallow"], limits["medium"]),
                            (3, limits["medium"], None)):
        values = depth[finite & (classes == code)]
        if not values.size:
            continue
        if low is not None:
            gate(values.min() >= low - tol, f"depth class {code} holds {values.min():.3f} m, below its limit {low}")
        if high is not None:
            gate(values.max() <= high + tol, f"depth class {code} holds {values.max():.3f} m, above its limit {high}")


def build_depth_classes(report, sources, depth, classes):
    """manifest.depth_classes: each class's limits in metres, and where they came from."""
    limits = limits_from_config(report, sources)
    source = "notebook config"
    if limits is None:
        limits = limits_from_schema(SCHEMA.read_text(encoding="utf-8"))
        source = "docs/SCHEMA.md"
    check_against_rasters(limits, depth, classes)
    return {
        "source": source,
        "shallow": {"max_m": limits["shallow"]},
        "medium": {"min_m": limits["shallow"], "max_m": limits["medium"]},
        "deep": {"min_m": limits["medium"]},
    }
