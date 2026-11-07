// What the data says about one position: in the flood or not, the depth class,
// the nearest flooded road and the road node to route from.
import 'dart:math' as math;

import 'package:latlong2/latlong.dart' show LatLng;

import 'bundle_repository.dart';
import 'models/enums.dart';
import 'models/geo.dart';
import 'models/road_graph.dart';

/// Farther than this from any road, the app does not route from the position.
const maxSnapMetres = 400.0;
const _metresPerDegree = 111320.0;

bool _insideRing(LatLng p, List<LatLng> ring) {
  var inside = false;
  for (var i = 0, j = ring.length - 1; i < ring.length; j = i++) {
    final a = ring[i], b = ring[j];
    if ((a.latitude > p.latitude) != (b.latitude > p.latitude) &&
        p.longitude < (b.longitude - a.longitude) * (p.latitude - a.latitude) / (b.latitude - a.latitude) + a.longitude) {
      inside = !inside;
    }
  }
  return inside;
}

bool insidePolygon(LatLng p, GeoPolygon polygon) =>
    _insideRing(p, polygon.outer) && !polygon.holes.any((hole) => _insideRing(p, hole));

/// Metres on a local flat projection, plenty for distances of a few km.
(double, double) _local(LatLng origin, double lat, double lon) => (
      (lon - origin.longitude) * math.cos(origin.latitude * math.pi / 180) * _metresPerDegree,
      (lat - origin.latitude) * _metresPerDegree,
    );

/// Nearest node and its distance in metres.
(int, double) nearestNode(RoadGraph g, LatLng p) {
  var best = -1;
  var bestSq = double.infinity;
  for (var i = 0; i < g.nodeCount; i++) {
    final (x, y) = _local(p, g.lat[i], g.lon[i]);
    final d = x * x + y * y;
    if (d < bestSq) {
      bestSq = d;
      best = i;
    }
  }
  return (best, math.sqrt(bestSq));
}

double _toSegment(double ax, double ay, double bx, double by) {
  final dx = bx - ax, dy = by - ay;
  final length = dx * dx + dy * dy;
  final t = length == 0 ? 0.0 : ((-ax * dx - ay * dy) / length).clamp(0.0, 1.0);
  final x = ax + t * dx, y = ay + t * dy;
  return math.sqrt(x * x + y * y);
}

class MySpot {
  /// False outside manifest.bounds or too far from any road: nothing else is set then.
  final bool usable;
  final bool insideBounds;
  final int? node;
  final double? snapMetres;
  final bool inFlood;
  final DepthClass? depthClass;
  final double? nearestFloodedRoadMetres;

  const MySpot({
    required this.usable,
    required this.insideBounds,
    this.node,
    this.snapMetres,
    this.inFlood = false,
    this.depthClass,
    this.nearestFloodedRoadMetres,
  });
}

MySpot analyzeSpot(AppBundle bundle, LatLng p) {
  final b = bundle.manifest.bounds;
  final inBounds = p.latitude >= b.south && p.latitude <= b.north && p.longitude >= b.west && p.longitude <= b.east;
  if (!inBounds) return const MySpot(usable: false, insideBounds: false);
  final g = bundle.graph;
  final (node, snap) = nearestNode(g, p);
  if (node < 0 || snap > maxSnapMetres) return const MySpot(usable: false, insideBounds: true);

  final inFlood = bundle.flood.any((area) => area.polygons.any((polygon) => insidePolygon(p, polygon)));
  DepthClass? depth;
  for (final zone in bundle.depthZones) {
    if (zone.polygons.any((polygon) => insidePolygon(p, polygon))) {
      depth = zone.depthClass;
      break;
    }
  }
  double? nearestFlooded;
  for (var e = 0; e < g.edgeCount; e++) {
    if (g.depthClass[e] == 0) continue;
    final (ax, ay) = _local(p, g.lat[g.u[e]], g.lon[g.u[e]]);
    final (bx, by) = _local(p, g.lat[g.v[e]], g.lon[g.v[e]]);
    final d = _toSegment(ax, ay, bx, by);
    if (nearestFlooded == null || d < nearestFlooded) nearestFlooded = d;
  }
  return MySpot(
    usable: true,
    insideBounds: true,
    node: node,
    snapMetres: snap,
    inFlood: inFlood,
    depthClass: depth,
    nearestFloodedRoadMetres: nearestFlooded,
  );
}
