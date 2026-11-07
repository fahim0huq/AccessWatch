"""Build accesswatch_mobile/assets/bundle/ from the notebook outputs and the EMS product.

Usage:  python tools/build_bundle.py            (dependencies: tools/requirements.txt)
Every check is a gate: on any failure the existing bundle is left untouched.
"""
import hashlib
import re
import shutil
import sys
from collections import Counter
from datetime import datetime, timezone

from bundle import ems as ems_mod
from bundle import graph as graph_mod
from bundle import layers, quality, services
from bundle.common import MAX_BUNDLE_BYTES, OUT, SRC, GateError, gate, read_json, write_json
from bundle.depth_ranges import build_depth_classes

SCENE_TIME = re.compile(r"_(\d{8}T\d{6})_")
MANIFEST = "manifest.json"
SCHEMA_VERSION = 1


def scene_time(scene):
    return datetime.strptime(SCENE_TIME.search(scene).group(1), "%Y%m%dT%H%M%S").replace(tzinfo=timezone.utc)


def iso(moment):
    return moment.strftime("%Y-%m-%dT%H:%M:%SZ")


def file_table(folder):
    table = {}
    for path in sorted(folder.iterdir()):
        table[path.name] = {"sha256": hashlib.sha256(path.read_bytes()).hexdigest(), "size": path.stat().st_size}
    return table


def build(out):
    report = read_json(SRC / "validation_report.json")
    sources = read_json(SRC / "DATA_SOURCES.json")
    gate(report["synthetic_demo"] is False, "notebook outputs are synthetic demo data")

    mask = layers.read_raster("flood_mask.tif")
    raster_box = layers.wgs84_bounds(mask)
    bounds = layers.outward_5dp(*raster_box)

    flood = layers.build_flood(mask)
    baseline, _ = layers.build_baseline()
    depth = layers.build_depth_zones()
    depth_classes = build_depth_classes(report, sources, layers.read_raster("depth.tif").data,
                                        layers.read_raster("depth_class.tif").data)
    pockets, pocket_geoms = layers.build_pockets()
    routes = layers.build_routes()
    pocket_ids = [pid for pid, _ in pocket_geoms]
    missions = layers.build_missions(pocket_ids)

    ems = ems_mod.load_ems(raster_box)
    compare = ems_mod.build_compare(out / "compare.png", mask, ems, report, bounds)

    roads = read_json(SRC / "network" / "road_conditions.geojson")["features"]
    graph = graph_mod.build_graph(roads)
    links = graph_mod.connectivity(graph)
    raw_services = read_json(SRC / "network" / "services.geojson")["features"]
    raw_depot = read_json(SRC / "network" / "aid_depot.geojson")["features"]
    gate(len(raw_depot) == 1, "expected exactly one aid depot")
    replay = graph_mod.replay_routes(graph, routes["features"], raw_depot[0]["geometry"]["coordinates"])
    service_fc = services.build_services(raw_services, raw_depot, graph, pocket_geoms)

    scenes = sources["NISAR GCOV"]["scenes"]
    before, after = scene_time(scenes["before"]), scene_time(scenes["after"])
    gap_hours = round((ems["image_time"] - after).total_seconds() / 3600, 1)
    ems_info = {
        "product": ems["product"], "layer": ems["layer"], "image_sensor": ems["sensor"],
        "image_time": iso(ems["image_time"]), "hours_after_nisar_after": gap_hours,
        "aoi_share_of_bounds": round(ems["aoi_share_of_bounds"], 3),
    }
    notes = quality.data_notes(raster_box, [f["properties"] for f in pockets["features"]], pocket_geoms,
                               routes["features"], roads, raw_services)
    quality_doc = quality.build_quality(report, sources, missions["cards"], ems_info, notes)

    outputs = {
        "flood.geojson": flood, "flood_baseline.geojson": baseline, "flood_ems.geojson": ems_mod.build_ems_geojson(ems),
        "depth_zones.geojson": depth, "pockets.geojson": pockets, "routes.geojson": routes,
        "services.geojson": service_fc, "missions.json": missions, "graph.json": graph_mod.to_document(graph),
        "quality.json": quality_doc,
    }
    for name, doc in outputs.items():
        write_json(out / name, doc)

    all_box = layers.geometry_bounds([flood["features"], pockets["features"], routes["features"], roads, service_fc["features"]])
    props = [f["properties"] for f in pockets["features"]]
    manifest = {
        "schema_version": SCHEMA_VERSION,
        "event": missions["event"],
        "synthetic_demo": missions["synthetic_demo"],
        "bounds": bounds,
        "bounds_all": layers.outward_5dp(*all_box),
        "dates": {"nisar_before": iso(before), "nisar_after": iso(after), "ems_image": iso(ems["image_time"]),
                  "ems_hours_after_nisar": gap_hours, "notebook_generated": missions["generated"]},
        "quality_flags": quality_doc["flags"],
        "depth_classes": depth_classes,
        "compare": compare,
        "graph": {"nodes": len(graph["lon"]), "edges": len(graph["edges"]),
                  "self_loops_dropped": graph["self_loops_dropped"], "connectivity": links, **replay},
        "stats": {
            "flood_area_km2": round(float((mask.data == 1).sum()) * mask.pixel_m2 / 1e6, 2),
            "pockets": len(props), "population_estimate": sum(p["population"] for p in props),
            "pockets_by_access_mode": dict(Counter(p["access_mode"] for p in props)),
            "flooded_road_pieces": graph_mod.flooded_edge_counts(graph),
            "clinic_status": services.status_counts(service_fc),
        },
        "files": file_table(out),
    }
    write_json(out / MANIFEST, manifest)
    total = sum(p.stat().st_size for p in out.iterdir())
    gate(total < MAX_BUNDLE_BYTES, f"bundle is {total:,} bytes, over the limit")
    return manifest, total


def main():
    work = OUT.with_name(".bundle_build")
    if work.exists():
        shutil.rmtree(work)
    work.mkdir(parents=True)
    try:
        manifest, total = build(work)
    except GateError as e:
        shutil.rmtree(work)
        print(f"GATE FAILED, bundle not changed: {e}", file=sys.stderr)
        return 1
    except Exception:
        shutil.rmtree(work)
        raise
    if OUT.exists():
        shutil.rmtree(OUT)
    work.rename(OUT)
    for name, info in manifest["files"].items():
        print(f"{info['size']:>9,}  {name}")
    print(f"{total:>9,}  TOTAL (including {MANIFEST})")
    return 0


if __name__ == "__main__":
    sys.exit(main())
