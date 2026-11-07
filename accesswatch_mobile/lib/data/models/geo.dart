import 'package:latlong2/latlong.dart';

/// One polygon: an outer ring and any holes.
class GeoPolygon {
  final List<LatLng> outer;
  final List<List<LatLng>> holes;

  const GeoPolygon(this.outer, this.holes);
}

LatLng latLngFromCoord(List<dynamic> coord) =>
    LatLng((coord[1] as num).toDouble(), (coord[0] as num).toDouble());

List<LatLng> _ring(List<dynamic> ring) =>
    [for (final c in ring) latLngFromCoord(c as List<dynamic>)];

GeoPolygon _polygon(List<dynamic> rings) => GeoPolygon(
      _ring(rings.first as List<dynamic>),
      [for (final hole in rings.skip(1)) _ring(hole as List<dynamic>)],
    );

/// A GeoJSON Polygon or MultiPolygon as a flat list of polygons.
List<GeoPolygon> polygonsFromGeometry(Map<String, dynamic> geometry) {
  final coords = geometry['coordinates'] as List<dynamic>;
  switch (geometry['type']) {
    case 'Polygon':
      return [_polygon(coords)];
    case 'MultiPolygon':
      return [for (final p in coords) _polygon(p as List<dynamic>)];
    default:
      throw FormatException('Expected polygon geometry, got ${geometry['type']}');
  }
}

List<LatLng> lineFromGeometry(Map<String, dynamic> geometry) {
  if (geometry['type'] != 'LineString') {
    throw FormatException('Expected LineString, got ${geometry['type']}');
  }
  return _ring(geometry['coordinates'] as List<dynamic>);
}

LatLng pointFromGeometry(Map<String, dynamic> geometry) {
  if (geometry['type'] != 'Point') {
    throw FormatException('Expected Point, got ${geometry['type']}');
  }
  return latLngFromCoord(geometry['coordinates'] as List<dynamic>);
}

List<Map<String, dynamic>> featuresOf(Map<String, dynamic> collection) =>
    (collection['features'] as List<dynamic>).cast<Map<String, dynamic>>();
