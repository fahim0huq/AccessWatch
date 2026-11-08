"""Compact routing graph: nodes and edges from road_conditions, with connectivity and route-replay gates."""
import heapq
from collections import Counter, defaultdict

import numpy as np

from .common import gate

EDGE_FIELDS = ["u", "v", "length_m", "depth_class", "flags", "risk_cost", "travel_time_min"]
STRIDE = len(EDGE_FIELDS)
U, V, LENGTH, DEPTH, FLAGS, RISK, TIME = range(STRIDE)
FLAG_BITS = {"normal_vehicle": 1, "high_clearance": 2, "foot": 4, "bridge": 8, "bridge_uncertain": 16}
SOURCE_FLAGS = {"normal_vehicle": "access_normal_vehicle", "high_clearance": "access_high_clearance",
                "foot": "access_foot", "bridge": "is_bridge", "bridge_uncertain": "bridge_uncertain"}
# Which roads each access mode may use. Boats follow the flooded roads, so they may use any road.
MODE_BITS = {"normal_vehicle": 1, "high_clearance_truck": 2, "on_foot": 4, "boat": None}
ROUTE_KM_TOLERANCE = 0.03
# The depot can sit off the road with two nodes almost equally near; the notebook may
# snap to either. The routes' start must be no more than this much farther than the nearest.
DEPOT_SNAP_SLACK_M = 5.0
RISK_TOLERANCE = 0.001


def build_graph(features):
    """Features -> graph dict. Road pieces carry no node ids, so nodes come from their end points."""
    index, lons, lats, edges = {}, [], [], []
    dropped = 0

    def node(coord):
        key = (round(coord[0], 5), round(coord[1], 5))
        if key not in index:
            index[key] = len(lons)
            lons.append(key[0])
            lats.append(key[1])
        return index[key]

    for f in features:
        coords, p = f["geometry"]["coordinates"], f["properties"]
        u, v = node(coords[0]), node(coords[-1])
        if u == v:  # both ends rounded onto the same point
            dropped += 1
            continue
        flags = sum(bit for name, bit in FLAG_BITS.items() if p[SOURCE_FLAGS[name]])
        edges.append([u, v, round(p["length_m"], 1), p["depth_class"], flags,
                      round(p["risk_cost"], 2), p["travel_time_min"]])
    return {"lon": lons, "lat": lats, "edges": edges, "index": index, "self_loops_dropped": dropped}


def to_document(graph):
    """graph.json: flat arrays, EDGE_FIELDS repeated once per edge."""
    return {"edge_fields": EDGE_FIELDS, "flag_bits": FLAG_BITS, "lon": graph["lon"], "lat": graph["lat"],
            "edges": [value for edge in graph["edges"] for value in edge]}


def component_labels(node_count, edges, keep=None):
    parent = list(range(node_count))

    def find(x):
        while parent[x] != x:
            parent[x] = parent[parent[x]]
            x = parent[x]
        return x

    for edge in edges:
        if keep is None or keep(edge):
            parent[find(edge[U])] = find(edge[V])
    return [find(i) for i in range(node_count)]


def _summary(labels):
    sizes = Counter(labels)
    return {"components": len(sizes), "largest": max(sizes.values())}


def connectivity(graph):
    """Connected-components check, in total and for each way of travelling."""
    n, edges = len(graph["lon"]), graph["edges"]
    out = {"all": _summary(component_labels(n, edges))}
    gate(out["all"]["components"] == 1, f"road graph splits into {out['all']['components']} components")
    for name, bit in (("normal_vehicle", 1), ("high_clearance", 2), ("foot", 4)):
        out[name] = _summary(component_labels(n, edges, lambda e, b=bit: e[FLAGS] & b))
    out["dry"] = _summary(component_labels(n, edges, lambda e: e[DEPTH] == 0))
    return out


def main_dry_nodes(graph):
    """Nodes of the largest network that can be travelled with no flooded road."""
    labels = component_labels(len(graph["lon"]), graph["edges"], lambda e: e[DEPTH] == 0)
    largest = Counter(labels).most_common(1)[0][0]
    return {i for i, label in enumerate(labels) if label == largest}


def nearest_node(graph, lon, lat):
    lons, lats = np.asarray(graph["lon"]), np.asarray(graph["lat"])
    dx = (lons - lon) * np.cos(np.radians(lat))
    return int(np.argmin(dx * dx + (lats - lat) ** 2))


def node_distance_m(graph, node, lon, lat):
    dx = (graph["lon"][node] - lon) * np.cos(np.radians(lat)) * 111320
    dy = (graph["lat"][node] - lat) * 111320
    return float(np.hypot(dx, dy))


def _adjacency(edges):
    adj = defaultdict(list)
    for edge in edges:
        adj[edge[U]].append((edge[V], edge))
        adj[edge[V]].append((edge[U], edge))
    return adj


def dijkstra(adj, start, cost_field, mode_bit=None):
    best, queue = {start: 0.0}, [(0.0, start)]
    while queue:
        dist, x = heapq.heappop(queue)
        if dist > best[x]:
            continue
        for y, edge in adj[x]:
            if mode_bit is not None and not edge[FLAGS] & mode_bit:
                continue
            nd = dist + edge[cost_field]
            if nd < best.get(y, float("inf")):
                best[y] = nd
                heapq.heappush(queue, (nd, y))
    return best


def replay_routes(graph, routes, depot_lonlat):
    """Gate: the graph must reproduce every published route, or in-app routing would disagree with them."""
    adj, index = _adjacency(graph["edges"]), graph["index"]
    pairs = {frozenset((e[U], e[V])): e for e in graph["edges"]}
    first = {index.get(tuple(f["geometry"]["coordinates"][0])) for f in routes}
    gate(len(first) == 1 and None not in first, "published routes do not share one start node")
    depot = first.pop()
    nearest = nearest_node(graph, *depot_lonlat)
    extra = node_distance_m(graph, depot, *depot_lonlat) - node_distance_m(graph, nearest, *depot_lonlat)
    gate(extra <= DEPOT_SNAP_SLACK_M, f"routes start {extra:.1f} m farther from the depot than its nearest road node")
    by_length = dijkstra(adj, depot, LENGTH)
    by_risk = {m: dijkstra(adj, depot, RISK, bit) for m, bit in MODE_BITS.items()}
    for f in routes:
        p, coords = f["properties"], f["geometry"]["coordinates"]
        label = f"{p['pocket_id']} {p['route_type']}"
        nodes = [index.get(tuple(c)) for c in coords]
        gate(None not in nodes, f"{label}: route leaves the graph")
        gate(nodes[0] == depot, f"{label}: route does not start at the depot")
        used = [pairs.get(frozenset(pair)) for pair in zip(nodes, nodes[1:])]
        gate(None not in used, f"{label}: route uses a road that is not in the graph")
        km = sum(e[LENGTH] for e in used) / 1000
        gate(abs(km - p["distance_km"]) <= ROUTE_KM_TOLERANCE, f"{label}: {km:.2f} km vs published {p['distance_km']}")
        if p["route_type"] == "shortest":
            found = by_length[nodes[-1]] / 1000
            gate(abs(found - p["distance_km"]) <= ROUTE_KM_TOLERANCE, f"{label}: graph finds {found:.2f} km")
        else:
            risk, found = sum(e[RISK] for e in used), by_risk[p["access_mode"]][nodes[-1]]
            gate(abs(risk - found) <= RISK_TOLERANCE * found, f"{label}: graph finds risk {found:.0f}, route has {risk:.0f}")
    return {"routes_replayed": len(routes)}


def flooded_edge_counts(graph):
    counts = Counter(e[DEPTH] for e in graph["edges"])
    return {"shallow": counts[1], "medium": counts[2], "deep": counts[3]}
