// Which published routes the map shows: all, one area's, or a single route.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/route_line.dart';

/// A single route chosen in the routes panel. While set, the map shows only it.
final selectedRouteProvider = StateProvider<RouteLine?>((ref) => null);

/// A route tapped on the map among several: drawn on top, wider.
final highlightedRouteProvider = StateProvider<RouteLine?>((ref) => null);

/// Set by "Show on map" on an area page: the Map opens the routes panel on it.
final routesPanelRequestProvider = StateProvider<String?>((ref) => null);

bool sameRoute(RouteLine? a, RouteLine? b) =>
    a != null && b != null && a.pocketId == b.pocketId && a.routeType == b.routeType;
