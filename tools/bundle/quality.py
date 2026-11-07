"""quality.json: machine-readable flags that drive ARB warnings, plus the source reports verbatim."""
from itertools import combinations

import geopandas as gpd
from shapely.geometry import box

from .common import gate

# Each source flag maps to a boolean; the app shows its own translated text for each boolean.
KNOWN_FLAGS = {
    "NISAR scenes are BETA": "nisar_beta",
    "aid depot is auto-selected": "depot_auto_selected",
    "validation map chosen by product order": "validation_chosen_by_product_order",
    "flood map = classifier calibrated": "classifier_calibrated_on_ems",
}
CLINIC_NEAR_M = 100


def parse_flags(source_flags):
    """A flag we cannot name would have no warning in the app, so it stops the build."""
    out = {name: False for name in KNOWN_FLAGS.values()}
    for text in source_flags:
        match = [name for prefix, name in KNOWN_FLAGS.items() if text.startswith(prefix)]
        gate(len(match) == 1, f"unknown quality flag, add it to KNOWN_FLAGS and the ARB files: {text!r}")
        out[match[0]] = True
    return out


def rank_population_inversions(pockets):
    """Pockets with equal service and difficulty terms that rank above a pocket with more people."""
    out = []
    ordered = sorted(pockets, key=lambda p: p["rank"])
    for a, b in combinations(ordered, 2):
        same_terms = a["service_loss_norm"] == b["service_loss_norm"] and a["difficulty_norm"] == b["difficulty_norm"]
        if same_terms and a["population"] < b["population"]:
            out.append([a["pocket_id"], b["pocket_id"]])
    return out


def data_notes(raster_box, pocket_props, pocket_geoms, routes, road_features, services):
    """Things a reader of the source files should know, counted from the data."""
    bbox = box(*raster_box)
    west, south, east, north = raster_box
    outside = [f for f in road_features
               if any(not (west <= x <= east and south <= y <= north) for x, y in f["geometry"]["coordinates"])]

    by_pocket = {}
    for f in routes:
        by_pocket.setdefault(f["properties"]["pocket_id"], set()).add(f["properties"]["distance_km"])

    clinics = [f for f in services if f["properties"]["type"] == "clinic"]
    utm = gpd.GeoSeries(gpd.points_from_xy(*zip(*(f["geometry"]["coordinates"] for f in clinics))), crs="EPSG:4326").to_crs(32736)
    near = sum(a.distance(b) <= CLINIC_NEAR_M for a, b in combinations(utm, 2))

    return {
        "road_pieces_outside_raster": len(outside),
        "road_pieces_outside_raster_labelled_dry": sum(f["properties"]["depth_class"] == 0 for f in outside),
        "pocket_share_outside_raster": {pid: round(1 - g.intersection(bbox).area / g.area, 4)
                                        for pid, g in pocket_geoms if g.intersection(bbox).area / g.area < 0.9995},
        "pockets_where_safest_differs_in_routes": sum(len(v) > 1 for v in by_pocket.values()),
        "rank_population_inversions": rank_population_inversions(pocket_props),
        "clinic_records": len(clinics),
        "clinic_record_pairs_within_100m": int(near),
    }


def build_quality(report, sources, cards, ems_info, notes):
    source_flags = sources["quality_flags"]
    flags = parse_flags(source_flags)
    # The depot warning must never be lost: the cards and the sources can each raise it.
    flags["depot_auto_selected"] = (flags["depot_auto_selected"] or any(c.get("depot_auto_selected") for c in cards)
                                    or str(sources.get("Aid depot", "")).startswith("AUTO-SELECTED"))
    return {
        "flags": flags,
        "source_flags": source_flags,
        "ems": ems_info,
        "notes": notes,
        "report": report,
        "sources": {k: v for k, v in sources.items() if k != "quality_flags"},
    }
