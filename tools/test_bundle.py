"""Tests for the bundle builder. Run:  python tools/test_bundle.py

clinic_status tests use fixtures, because the current data only produces `reachable`.
"""
import hashlib
import json
import unittest

import numpy as np
import pandas as pd
from shapely.geometry import Point, box

from bundle import depth_ranges, ems, graph, quality, services
from bundle.common import MAX_BUNDLE_BYTES, OUT, GateError, line_to_geojson, polygon_to_geojson


def road(a, b, depth=0, flags=None):
    allowed = depth == 0 if flags is None else flags
    return {"geometry": {"coordinates": [a, b]}, "properties": {
        "length_m": 50.0, "depth_class": depth, "risk_cost": 50.0, "travel_time_min": 0.1,
        "access_normal_vehicle": allowed, "access_high_clearance": allowed, "access_foot": allowed,
        "is_bridge": False, "bridge_uncertain": False}}


class ClinicStatus(unittest.TestCase):
    pockets = [("P01", box(0, 0, 1, 1))]

    def test_inside_pocket_names_the_pocket(self):
        self.assertEqual(services.clinic_status(Point(0.5, 0.5), 1, self.pockets, {1}), ("inside_pocket", "P01"))

    def test_inside_pocket_wins_over_flooded_access(self):
        self.assertEqual(services.clinic_status(Point(0.5, 0.5), 9, self.pockets, {1})[0], "inside_pocket")

    def test_access_flooded_when_not_on_main_dry_network(self):
        self.assertEqual(services.clinic_status(Point(5, 5), 9, self.pockets, {1}), ("access_flooded", None))

    def test_reachable(self):
        self.assertEqual(services.clinic_status(Point(5, 5), 1, self.pockets, {1}), ("reachable", None))

    def test_end_to_end_on_small_network(self):
        # Long dry road 0-1-2, flooded link 2-3, and short dry stub 3-4 beyond the water.
        roads = [road((0, 0), (0, .1)), road((0, .1), (0, .2)), road((0, .2), (0, .3), depth=3),
                 road((0, .3), (0, .4))]
        g = graph.build_graph(roads)
        self.assertEqual(graph.main_dry_nodes(g), {0, 1, 2})
        clinics = [{"properties": {"type": "clinic", "name": n, "on_network": True},
                    "geometry": {"type": "Point", "coordinates": c}}
                   for n, c in (("dry", [0, .1]), ("cut", [0, .4]))]
        depot = [{"properties": {"name": "d"}, "geometry": {"coordinates": [0, 0]}}]
        out = services.build_services(clinics, depot, g, [])["features"]
        self.assertEqual([f["properties"].get("clinic_status") for f in out], ["reachable", "access_flooded", None])
        self.assertEqual(out[-1]["properties"]["type"], "aid_depot")


class Graph(unittest.TestCase):
    def test_nodes_are_shared_and_self_loops_dropped(self):
        g = graph.build_graph([road((0, 0), (1, 1)), road((1, 1), (2, 2)), road((3, 3), (3.000001, 3))])
        self.assertEqual(len(g["edges"]), 2)
        self.assertEqual(g["self_loops_dropped"], 1)
        self.assertEqual(g["edges"][0][graph.V], g["edges"][1][graph.U])

    def test_split_network_fails_the_gate(self):
        with self.assertRaises(GateError):
            graph.connectivity(graph.build_graph([road((0, 0), (1, 1)), road((5, 5), (6, 6))]))

    def test_mode_counts(self):
        g = graph.build_graph([road((0, 0), (1, 1)), road((1, 1), (2, 2), depth=3)])
        links = graph.connectivity(g)
        self.assertEqual(links["all"], {"components": 1, "largest": 3})
        self.assertEqual(links["dry"], {"components": 2, "largest": 2})

    def test_replay_rejects_a_route_off_the_graph(self):
        g = graph.build_graph([road((0, 0), (0, .001))])
        route = {"properties": {"pocket_id": "P", "route_type": "shortest", "distance_km": .05, "access_mode": "boat"},
                 "geometry": {"coordinates": [[0, 0], [9, 9]]}}
        with self.assertRaises(GateError):
            graph.replay_routes(g, [route], [0, 0])


class Compare(unittest.TestCase):
    def test_classes_and_outside_aoi_is_not_compared(self):
        ours = np.array([[1, 1, 0, 0, 1]], bool)
        other = np.array([[1, 0, 1, 0, 0]], bool)
        aoi = np.array([[1, 1, 1, 1, 0]], bool)
        classes = ems.classify_compare(ours, other, aoi)
        self.assertEqual(classes.tolist(), [[1, 2, 3, 0, 0]])
        stats = ems.compare_stats(classes, 400, ours, aoi)
        self.assertEqual(stats["pixels"], {"both": 1, "only_ours": 1, "only_ems": 1})
        self.assertEqual(stats["our_flood_pixels_outside_ems_area"], 1)

    def test_drift_from_the_report_fails(self):
        stats = {"iou": .7, "pixels": {"both": 7, "only_ours": 2, "only_ems": 1}}
        report = {"new_flood_vs_reference": {"IoU": .8, "tp_px": 7, "fp_px": 2, "fn_px": 1}}
        with self.assertRaises(GateError):
            ems.check_against_report(stats, report)


class EmsDate(unittest.TestCase):
    table = pd.DataFrame([
        {"src_id": 994, "src_date": "17/01/2026", "source_tm": "Not Applicable", "eventphase": "Pre-event", "source_nam": "OSM"},
        {"src_id": 4, "src_date": "18/01/2026", "source_tm": "T14:55:00Z", "eventphase": "Post-event", "source_nam": "Radar"},
        {"src_id": 3, "src_date": "06/05/2024", "source_tm": "T00:00:00Z", "eventphase": "Pre-event", "source_nam": "Base"},
    ])

    def test_uses_the_image_the_polygons_point_to(self):
        moment, sensor = ems.resolve_image_time(self.table, [4, 4])
        self.assertEqual((moment.isoformat(), sensor), ("2026-01-18T14:55:00+00:00", "Radar"))

    def test_rejects_mixed_images_and_pre_event(self):
        for ids in ([4, 3], [3]):
            with self.assertRaises(GateError):
                ems.resolve_image_time(self.table, ids)


class Quality(unittest.TestCase):
    def test_unknown_flag_stops_the_build(self):
        with self.assertRaises(GateError):
            quality.parse_flags(["a brand new warning"])

    def test_known_flags_and_depot_fallback(self):
        doc = quality.build_quality({}, {"quality_flags": ["NISAR scenes are BETA (x)"]},
                                    [{"depot_auto_selected": True}], {}, {})
        self.assertTrue(doc["flags"]["nisar_beta"])
        self.assertTrue(doc["flags"]["depot_auto_selected"])
        self.assertFalse(doc["flags"]["classifier_calibrated_on_ems"])

    def test_rank_inversions(self):
        p = [{"pocket_id": a, "rank": r, "population": n, "service_loss_norm": .8, "difficulty_norm": 1.0}
             for a, r, n in (("A", 1, 10), ("B", 2, 30), ("C", 3, 5))]
        self.assertEqual(quality.rank_population_inversions(p), [["A", "B"]])


class DepthRanges(unittest.TestCase):
    row = "| `depth_class.tif` | 0 dry, 1 shallow (<0.4 m), 2 medium (<0.9 m), 3 deep, 4 unknown |"
    limits = {"shallow": 0.3, "medium": 0.8}

    def test_reads_the_schema_row(self):
        self.assertEqual(depth_ranges.limits_from_schema(self.row), {"shallow": 0.4, "medium": 0.9})

    def test_missing_schema_row_fails(self):
        with self.assertRaises(GateError):
            depth_ranges.limits_from_schema("no limits here")

    def test_config_values_are_found_at_any_level(self):
        doc = {"flood_method": {"depth_shallow_max_m": 0.25, "medium_threshold": 0.7}}
        self.assertEqual(depth_ranges.limits_from_config(doc), {"shallow": 0.25, "medium": 0.7})

    def test_config_is_ignored_unless_both_limits_exist(self):
        self.assertIsNone(depth_ranges.limits_from_config({"shallow_max": 0.25}, {"km_shallow": 1.0}))

    def test_rasters_that_match_pass(self):
        depth = np.array([0.1, 0.5, 2.0, np.nan])
        depth_ranges.check_against_rasters(self.limits, depth, np.array([1, 2, 3, 0]))

    def test_pixel_outside_its_class_fails(self):
        for values, classes in (([0.5], [1]), ([0.2], [2]), ([0.9], [2]), ([0.5], [3])):
            with self.assertRaises(GateError):
                depth_ranges.check_against_rasters(self.limits, np.array(values), np.array(classes))


class Rounding(unittest.TestCase):
    def test_line_drops_vertices_rounded_together(self):
        line = line_to_geojson([[1.000001, 2.0], [1.000002, 2.0], [1.5, 2.0]])
        self.assertEqual(line["coordinates"], [[1.0, 2.0], [1.5, 2.0]])

    def test_self_intersecting_polygon_is_repaired(self):
        from shapely.geometry import Polygon, shape
        geom = polygon_to_geojson(Polygon([(0, 0), (1, 1), (1, 0), (0, 1)]))
        self.assertTrue(shape(geom).is_valid)


@unittest.skipUnless((OUT / "manifest.json").exists(), "bundle not built yet")
class BuiltBundle(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.manifest = json.loads((OUT / "manifest.json").read_text(encoding="utf-8"))

    def test_hashes_and_sizes_match(self):
        for name, info in self.manifest["files"].items():
            data = (OUT / name).read_bytes()
            self.assertEqual((hashlib.sha256(data).hexdigest(), len(data)), (info["sha256"], info["size"]), name)

    def test_every_file_is_listed_and_total_under_limit(self):
        on_disk = {p.name for p in OUT.iterdir()}
        self.assertEqual(on_disk - {"manifest.json"}, set(self.manifest["files"]))
        self.assertLess(sum(p.stat().st_size for p in OUT.iterdir()), MAX_BUNDLE_BYTES)

    def test_coordinates_have_at_most_five_decimals(self):
        def walk(v):
            if isinstance(v, list):
                for x in v:
                    walk(x)
            else:
                self.assertEqual(v, round(v, 5))
        for name in ("flood", "flood_baseline", "flood_ems", "depth_zones", "pockets", "routes", "services"):
            doc = json.loads((OUT / f"{name}.geojson").read_text(encoding="utf-8"))
            for f in doc["features"]:
                walk(f["geometry"]["coordinates"])

    def test_no_english_card_text_shipped(self):
        doc = json.loads((OUT / "missions.json").read_text(encoding="utf-8"))
        for card in doc["cards"]:
            self.assertFalse({"alert_text", "summary", "verify_notes", "title"} & set(card))

    def test_each_clinic_has_a_valid_status(self):
        doc = json.loads((OUT / "services.geojson").read_text(encoding="utf-8"))
        clinics = [f["properties"] for f in doc["features"] if f["properties"]["type"] == "clinic"]
        self.assertTrue(clinics)
        for c in clinics:
            self.assertIn(c["clinic_status"], {"reachable", "access_flooded", "inside_pocket"})
            self.assertEqual(c["clinic_status"] == "inside_pocket", c["pocket_id"] is not None)


if __name__ == "__main__":
    unittest.main()
