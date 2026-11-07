import 'enums.dart';
import 'geo.dart';

/// A feature of `flood.geojson` or `flood_baseline.geojson`.
class FloodArea {
  final double areaHa;
  final List<GeoPolygon> polygons;

  const FloodArea(this.areaHa, this.polygons);

  static List<FloodArea> listFromJson(Map<String, dynamic> collection) => [
        for (final f in featuresOf(collection))
          FloodArea(
            ((f['properties'] as Map<String, dynamic>)['area_ha'] as num).toDouble(),
            polygonsFromGeometry(f['geometry'] as Map<String, dynamic>),
          ),
      ];
}

/// A feature of `depth_zones.geojson`. The depth class is an estimate.
class DepthZone {
  final DepthClass depthClass;
  final List<GeoPolygon> polygons;

  const DepthZone(this.depthClass, this.polygons);

  static List<DepthZone> listFromJson(Map<String, dynamic> collection) => [
        for (final f in featuresOf(collection))
          DepthZone(
            DepthClass.fromCode((f['properties'] as Map<String, dynamic>)['depth_class'] as int),
            polygonsFromGeometry(f['geometry'] as Map<String, dynamic>),
          ),
      ];
}

/// `flood_ems.geojson`: official EMS flood polygons and the area EMS mapped.
class EmsLayer {
  final List<GeoPolygon> flood, mappedArea;

  const EmsLayer(this.flood, this.mappedArea);

  factory EmsLayer.fromJson(Map<String, dynamic> collection) {
    List<GeoPolygon> layer(String name) {
      final feature = featuresOf(collection).firstWhere(
        (f) => (f['properties'] as Map<String, dynamic>)['layer'] == name,
      );
      return polygonsFromGeometry(feature['geometry'] as Map<String, dynamic>);
    }

    return EmsLayer(layer('flood'), layer('aoi'));
  }
}
