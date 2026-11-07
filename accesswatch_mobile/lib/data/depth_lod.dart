// Prepares depth zones for smooth drawing: simplified copies at several detail
// levels, largest patches first. Runs in the isolate that parses the file.
// The full-detail patches stay in the top level, and in AppBundle.depthZones.
import 'dart:math' as math;

import 'package:latlong2/latlong.dart' show LatLng;

import 'models/enums.dart';
import 'models/geo.dart';
import 'models/layers.dart';

const _metresPerDegree = 111320.0;

/// A detail level: used from [minZoom] up to the next level's [minZoom].
class DepthLodLevel {
  final double minZoom;

  /// Largest patches drawn at this level; null draws them all.
  final int? maxPolygons;

  /// Corner smoothing in metres; 0 keeps the exact 20 m pixel edges.
  final double toleranceM;

  const DepthLodLevel(this.minZoom, this.maxPolygons, this.toleranceM);
}

const depthLodLevels = [
  DepthLodLevel(0, 150, 30),
  DepthLodLevel(13.5, 400, 12),
  DepthLodLevel(15, null, 0),
];

class DepthPatch {
  final DepthClass depthClass;
  final GeoPolygon polygon;

  const DepthPatch(this.depthClass, this.polygon);
}

/// [levels] matches [depthLodLevels] by index.
class DepthLod {
  final List<List<DepthPatch>> levels;

  const DepthLod(this.levels);

  List<DepthPatch> forZoom(double zoom) => levels[levelIndexForZoom(zoom)];

  static int levelIndexForZoom(double zoom) {
    var index = 0;
    for (var i = 0; i < depthLodLevels.length; i++) {
      if (zoom >= depthLodLevels[i].minZoom) index = i;
    }
    return index;
  }
}

/// Ground area in square metres (outer ring minus holes).
double polygonAreaM2(GeoPolygon polygon) {
  final area = _ringArea(polygon.outer) - polygon.holes.fold<double>(0, (sum, hole) => sum + _ringArea(hole));
  return math.max(area, 0);
}

double _ringArea(List<LatLng> ring) {
  if (ring.length < 3) return 0;
  final squeeze = math.cos(ring.first.latitude * math.pi / 180);
  var twice = 0.0;
  for (var i = 0; i < ring.length - 1; i++) {
    twice += ring[i].longitude * ring[i + 1].latitude - ring[i + 1].longitude * ring[i].latitude;
  }
  return (twice / 2).abs() * squeeze * _metresPerDegree * _metresPerDegree;
}

/// Douglas-Peucker on a closed ring (first point repeated last). Returns the
/// ring unchanged if simplifying would collapse it.
List<LatLng> simplifyRing(List<LatLng> ring, double toleranceM) {
  if (toleranceM <= 0 || ring.length < 5) return ring;
  final squeeze = math.cos(ring.first.latitude * math.pi / 180);
  final x = [for (final p in ring) p.longitude * squeeze * _metresPerDegree];
  final y = [for (final p in ring) p.latitude * _metresPerDegree];

  // A closed ring has no baseline, so split it at the point farthest from its start.
  var far = 0;
  var farDistance = -1.0;
  for (var i = 1; i < ring.length - 1; i++) {
    final dx = x[i] - x[0], dy = y[i] - y[0];
    final d = dx * dx + dy * dy;
    if (d > farDistance) {
      farDistance = d;
      far = i;
    }
  }

  final keep = List<bool>.filled(ring.length, false);
  keep[0] = keep[far] = keep[ring.length - 1] = true;
  final stack = <(int, int)>[(0, far), (far, ring.length - 1)];
  final limit = toleranceM * toleranceM;
  while (stack.isNotEmpty) {
    final (start, end) = stack.removeLast();
    var best = -1;
    var bestDistance = limit;
    final bx = x[end] - x[start], by = y[end] - y[start];
    final length = bx * bx + by * by;
    for (var i = start + 1; i < end; i++) {
      final px = x[i] - x[start], py = y[i] - y[start];
      final t = length == 0 ? 0.0 : ((px * bx + py * by) / length).clamp(0.0, 1.0);
      final dx = px - t * bx, dy = py - t * by;
      final d = dx * dx + dy * dy;
      if (d > bestDistance) {
        bestDistance = d;
        best = i;
      }
    }
    if (best != -1) {
      keep[best] = true;
      stack
        ..add((start, best))
        ..add((best, end));
    }
  }
  final out = [
    for (var i = 0; i < ring.length; i++)
      if (keep[i]) ring[i],
  ];
  return out.length >= 4 ? out : ring;
}

GeoPolygon _simplify(GeoPolygon polygon, double toleranceM) {
  if (toleranceM <= 0) return polygon;
  return GeoPolygon(
    simplifyRing(polygon.outer, toleranceM),
    [
      for (final hole in polygon.holes)
        // A hole smaller than the smoothing distance cannot be seen at this level.
        if (_ringArea(hole) > toleranceM * toleranceM) simplifyRing(hole, toleranceM),
    ],
  );
}

DepthLod buildDepthLod(List<DepthZone> zones) {
  final patches = [
    for (final zone in zones)
      for (final polygon in zone.polygons) (zone.depthClass, polygon, polygonAreaM2(polygon)),
  ]..sort((a, b) => b.$3.compareTo(a.$3));

  return DepthLod([
    for (final level in depthLodLevels)
      [
        for (final (depthClass, polygon, _) in patches.take(level.maxPolygons ?? patches.length))
          DepthPatch(depthClass, _simplify(polygon, level.toleranceM)),
      ],
  ]);
}
