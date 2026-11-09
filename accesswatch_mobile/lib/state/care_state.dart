import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart' show Distance, LatLng;

import '../data/models/enums.dart';
import '../data/models/service_point.dart';
import '../data/my_spot.dart';
import '../data/routing.dart';
import 'location.dart';
import 'providers.dart';

/// Runs the router in an isolate. Widget tests swap in a direct call, because a
/// fake test clock cannot wait for another isolate.
final careRouteRunnerProvider = Provider<Future<Map<CareMode, Map<int, GraphRoute>>> Function(CareRouteRequest)>(
  (ref) => (request) => compute(careRoutes, request),
);

final routeCriterionProvider = StateProvider<RouteCriterion>((ref) => RouteCriterion.fastest);

/// A clinic the user picked; null means the nearest one for each mode.
final targetClinicIdProvider = StateProvider<String?>((ref) => null);

final mySpotProvider = Provider<MySpot?>((ref) {
  final position = ref.watch(locationControllerProvider).position;
  return position == null ? null : analyzeSpot(ref.watch(loadedBundleProvider), position);
});

/// The sample spot of Find care: a real market in the data, dry and close
/// enough to a road to route from, and the farthest such market from the aid
/// depot (so the routes are not zero-length). Null if the data has none.
final sampleSpotProvider = Provider<ServicePoint?>((ref) {
  final bundle = ref.watch(loadedBundleProvider);
  final depot = [for (final s in bundle.services) if (s.type == ServiceType.aidDepot) s.point];
  if (depot.isEmpty) return null;
  const distance = Distance();
  final markets = [
    for (final s in bundle.services)
      if (s.type == ServiceType.market)
        if (analyzeSpot(bundle, s.point) case final spot when spot.usable && !spot.inFlood) s,
  ]..sort((a, b) => distance(b.point, depot.first).compareTo(distance(a.point, depot.first)));
  return markets.isEmpty ? null : markets.first;
});

/// Road node of each clinic.
final clinicNodesProvider = Provider<Map<String, int>>((ref) {
  final bundle = ref.watch(loadedBundleProvider);
  return {for (final c in bundle.clinics) c.id: nearestNode(bundle.graph, c.point).$1};
});

class ClinicRoute {
  final ServicePoint clinic;
  final GraphRoute route;

  const ClinicRoute(this.clinic, this.route);
}

/// For every mode, each clinic it can reach, best first. A missing clinic has no route.
class CareRoutes {
  final Map<CareMode, List<ClinicRoute>> byMode;

  const CareRoutes(this.byMode);

  ClinicRoute? forMode(CareMode mode, String? clinicId) {
    final routes = byMode[mode]!;
    if (clinicId == null) return routes.isEmpty ? null : routes.first;
    for (final r in routes) {
      if (r.clinic.id == clinicId) return r;
    }
    return null;
  }

  /// No mode reaches the clinic (or any clinic, for null): it needs a boat.
  bool needsBoat(String? clinicId) => CareMode.values.every((m) => forMode(m, clinicId) == null);
}

/// Routing runs in an isolate, again only when the start node or the criterion changes.
final careRoutesProvider = FutureProvider<CareRoutes?>((ref) async {
  final node = ref.watch(mySpotProvider.select((spot) => spot?.node));
  if (node == null) return null;
  final criterion = ref.watch(routeCriterionProvider);
  final bundle = ref.watch(loadedBundleProvider);
  final clinicNodes = ref.watch(clinicNodesProvider);
  final result = await ref.read(careRouteRunnerProvider)(CareRouteRequest(bundle.graph, node, clinicNodes.values.toSet().toList(), criterion));
  double cost(GraphRoute r) =>
      criterion == RouteCriterion.fastest ? r.timeMin + r.lengthM * 1e-6 : r.riskCost;
  return CareRoutes({
    for (final mode in CareMode.values)
      mode: [
        for (final clinic in bundle.clinics)
          if (result[mode]![clinicNodes[clinic.id]] case final route?) ClinicRoute(clinic, route),
      ]..sort((a, b) => cost(a.route).compareTo(cost(b.route))),
  });
});

/// A route the user sent to the map.
class CareRouteOnMap {
  final List<LatLng> points;
  final ClinicRoute clinicRoute;
  final CareMode mode;

  const CareRouteOnMap(this.points, this.clinicRoute, this.mode);
}

final careRouteOnMapProvider = StateProvider<CareRouteOnMap?>((ref) => null);
