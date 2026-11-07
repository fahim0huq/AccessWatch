
import 'package:accesswatch_mobile/data/bundle_repository.dart';
import 'package:accesswatch_mobile/data/models/enums.dart';
import 'package:accesswatch_mobile/data/models/road_graph.dart';
import 'package:accesswatch_mobile/data/routing.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

const _bits = {'normal_vehicle': 1, 'high_clearance': 2, 'foot': 4, 'bridge': 8, 'bridge_uncertain': 16};
const _all = 7;

/// A small hand-made graph. Edges: (u, v, length m, depth class, flags, risk, minutes).
RoadGraph handGraph(List<(int, int, double, int, int, double, double)> edges, int nodes) => RoadGraph(
      lon: Float64List.fromList([for (var i = 0; i < nodes; i++) 33.0 + i * 0.001]),
      lat: Float64List.fromList(List.filled(nodes, -24.5)),
      u: Int32List.fromList([for (final e in edges) e.$1]),
      v: Int32List.fromList([for (final e in edges) e.$2]),
      lengthM: Float64List.fromList([for (final e in edges) e.$3]),
      depthClass: Uint8List.fromList([for (final e in edges) e.$4]),
      flags: Uint8List.fromList([for (final e in edges) e.$5]),
      riskCost: Float64List.fromList([for (final e in edges) e.$6]),
      travelTimeMin: Float64List.fromList([for (final e in edges) e.$7]),
      flagBits: _bits,
    );

void main() {
  group('hand-made graph', () {
    // 0 -1- 1 -1- 3 is quick but risky; 0 -2- 2 -2- 3 is slower and safe.
    // 3 -- 4 is deep water that every flag allows; 4 -- 5 is foot only.
    final g = handGraph([
      (0, 1, 100, 1, _all, 50, 1),
      (1, 3, 100, 1, _all | 16, 50, 1),
      (0, 2, 200, 0, _all, 20, 3),
      (2, 3, 200, 0, _all, 20, 3),
      (3, 4, 100, 3, _all, 999, 1),
      (4, 5, 100, 0, 4, 10, 1),
    ], 6);

    test('fastest uses travel time, safest uses risk cost', () {
      final fast = findRoutes(g, 0, [3], CareMode.car, RouteCriterion.fastest)[3]!;
      expect(fast.nodes, [0, 1, 3]);
      expect(fast.timeMin, 2);
      expect(fast.shallowM, 200);
      expect(fast.uncertainBridges, 1);
      final safe = findRoutes(g, 0, [3], CareMode.car, RouteCriterion.safest)[3]!;
      expect(safe.nodes, [0, 2, 3]);
      expect(safe.riskCost, 40);
      expect(safe.lengthM, 400);
      expect(safe.uncertainBridges, 0);
    });

    test('car and truck never cross deep water, even when a flag allows it', () {
      for (final mode in [CareMode.car, CareMode.truck]) {
        expect(findRoutes(g, 0, [4], mode, RouteCriterion.fastest), isEmpty, reason: mode.name);
      }
      expect(findRoutes(g, 0, [5], CareMode.foot, RouteCriterion.fastest)[5]!.nodes, [0, 1, 3, 4, 5]);
    });

    test('each mode follows its own flag', () {
      expect(findRoutes(g, 4, [5], CareMode.car, RouteCriterion.safest), isEmpty);
      expect(findRoutes(g, 4, [5], CareMode.foot, RouteCriterion.safest), contains(5));
    });

    test('an unreachable target is absent, never a straight line', () {
      final island = handGraph([(0, 1, 10, 0, _all, 1, 1), (2, 3, 10, 0, _all, 1, 1)], 4);
      for (final mode in CareMode.values) {
        expect(findRoutes(island, 0, [1, 3], mode, RouteCriterion.fastest).keys, [1]);
      }
    });

    test('equal times break by length', () {
      final tie = handGraph([(0, 1, 500, 0, _all, 1, 0), (1, 2, 500, 0, _all, 1, 0), (0, 2, 50, 0, _all, 1, 0)], 3);
      expect(findRoutes(tie, 0, [2], CareMode.car, RouteCriterion.fastest)[2]!.nodes, [0, 2]);
    });

    test('a start at the target is a route of length 0', () {
      final route = findRoutes(g, 2, [2], CareMode.car, RouteCriterion.fastest)[2]!;
      expect(route.nodes, [2]);
      expect(route.lengthM, 0);
    });

    test('runs in an isolate through compute', () async {
      final result = await compute(careRoutes, CareRouteRequest(g, 0, [3, 5], RouteCriterion.safest));
      expect(result[CareMode.foot]!.keys, containsAll([3, 5]));
      expect(result[CareMode.car]!.keys, [3]);
    });
  });

  group('real graph', () {
    late AppBundle bundle;

    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      bundle = await BundleRepository().load();
    });

    test('connected components (printed), matching the manifest', () {
      final g = bundle.graph;
      final rows = {
        'all roads': components(g, (_) => true),
        'car': components(g, (e) => passable(g, e, CareMode.car)),
        'high-clearance truck': components(g, (e) => passable(g, e, CareMode.truck)),
        'on foot': components(g, (e) => passable(g, e, CareMode.foot)),
        'dry roads only': components(g, (e) => g.depthClass[e] == 0),
      };
      // ignore: avoid_print
      print('graph: ${g.nodeCount} nodes, ${g.edgeCount} edges');
      for (final entry in rows.entries) {
        // ignore: avoid_print
        print('  ${entry.key.padRight(22)} ${entry.value.$1} components, largest ${entry.value.$2} nodes');
      }
      final c = bundle.manifest.graph.connectivity;
      expect(rows['all roads']!, (c['all']!.components, c['all']!.largest));
      expect(rows['car']!, (c['normal_vehicle']!.components, c['normal_vehicle']!.largest));
      expect(rows['high-clearance truck']!, (c['high_clearance']!.components, c['high_clearance']!.largest));
      expect(rows['on foot']!, (c['foot']!.components, c['foot']!.largest));
      expect(rows['dry roads only']!, (c['dry']!.components, c['dry']!.largest));
    });

    test('no mode of the app can use a deep piece in the real data', () {
      final g = bundle.graph;
      for (var e = 0; e < g.edgeCount; e++) {
        if (g.depthClass[e] == 3) {
          for (final mode in CareMode.values) {
            expect(passable(g, e, mode), isFalse);
          }
        }
      }
    });

    test('reproduces the published safest truck routes: distance and uncertain bridges', () {
      final g = bundle.graph;
      int nodeAt(double lat, double lon) {
        var best = 0;
        var bestD = double.infinity;
        for (var i = 0; i < g.nodeCount; i++) {
          final d = (g.lat[i] - lat) * (g.lat[i] - lat) + (g.lon[i] - lon) * (g.lon[i] - lon);
          if (d < bestD) {
            bestD = d;
            best = i;
          }
        }
        return best;
      }

      final depot = bundle.services.firstWhere((s) => s.type == ServiceType.aidDepot).point;
      final source = nodeAt(depot.latitude, depot.longitude);
      final truckRoutes = bundle.routes
          .where((r) => r.routeType == RouteType.safest && r.accessMode == AccessMode.highClearanceTruck);
      expect(truckRoutes, isNotEmpty);
      for (final published in truckRoutes) {
        final end = nodeAt(published.points.last.latitude, published.points.last.longitude);
        final found = findRoutes(g, source, [end], CareMode.truck, RouteCriterion.safest)[end]!;
        expect(found.lengthM / 1000, closeTo(published.distanceKm, 0.03), reason: published.pocketId);
        expect(found.uncertainBridges, published.uncertainBridges, reason: published.pocketId);
      }
    });
  });
}
