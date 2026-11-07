"""services.geojson: services and the depot, with clinic_status on each clinic."""
from collections import Counter

from shapely.geometry import Point

from .common import feature, feature_collection, round_coords
from .graph import main_dry_nodes, nearest_node

REACHABLE, ACCESS_FLOODED, INSIDE_POCKET = "reachable", "access_flooded", "inside_pocket"


def clinic_status(point, node, pockets, dry_nodes):
    """First match wins. Measured from the dry network, so it does not depend on the auto-selected depot."""
    for pocket_id, geom in pockets:
        if geom.contains(point):
            return INSIDE_POCKET, pocket_id
    if node not in dry_nodes:
        return ACCESS_FLOODED, None
    return REACHABLE, None


def build_services(services, depot, graph, pockets):
    dry_nodes = main_dry_nodes(graph)
    feats = []
    for i, f in enumerate(services, start=1):
        props, coords = f["properties"], f["geometry"]["coordinates"]
        out = {"service_id": f"S{i:02d}", "type": props["type"], "name": props["name"], "on_network": props["on_network"]}
        if props["type"] == "clinic":
            node = nearest_node(graph, coords[0], coords[1])
            out["clinic_status"], out["pocket_id"] = clinic_status(Point(coords), node, pockets, dry_nodes)
        feats.append(feature(out, {"type": "Point", "coordinates": round_coords(coords)}))
    for i, f in enumerate(depot, start=1):
        props = {"service_id": f"D{i:02d}", "type": "aid_depot", "name": f["properties"]["name"]}
        feats.append(feature(props, {"type": "Point", "coordinates": round_coords(f["geometry"]["coordinates"])}))
    return feature_collection(feats)


def status_counts(collection):
    return dict(Counter(f["properties"]["clinic_status"] for f in collection["features"] if "clinic_status" in f["properties"]))
