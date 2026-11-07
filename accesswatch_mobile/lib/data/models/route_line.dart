import 'package:latlong2/latlong.dart';

import 'enums.dart';
import 'geo.dart';

double _d(Object? v) => (v as num).toDouble();

/// A feature of `routes.geojson`: there are two per pocket.
class RouteLine {
  final String pocketId;
  final int rank;
  final RouteType routeType;
  final AccessMode accessMode;
  final double distanceKm, estimatedTimeMin;
  final DepthClass maxDepthClass;
  final double kmShallow, kmMedium, kmDeep, boatLegKm;
  final int uncertainBridges;
  final double riskScore;
  final RiskLevel riskLevel;
  final List<LatLng> points;

  const RouteLine({
    required this.pocketId,
    required this.rank,
    required this.routeType,
    required this.accessMode,
    required this.distanceKm,
    required this.estimatedTimeMin,
    required this.maxDepthClass,
    required this.kmShallow,
    required this.kmMedium,
    required this.kmDeep,
    required this.boatLegKm,
    required this.uncertainBridges,
    required this.riskScore,
    required this.riskLevel,
    required this.points,
  });

  factory RouteLine.fromFeature(Map<String, dynamic> feature) {
    final p = feature['properties'] as Map<String, dynamic>;
    return RouteLine(
      pocketId: p['pocket_id'] as String,
      rank: p['rank'] as int,
      routeType: RouteType.parse(p['route_type']),
      accessMode: AccessMode.parse(p['access_mode']),
      distanceKm: _d(p['distance_km']),
      estimatedTimeMin: _d(p['estimated_time_min']),
      maxDepthClass: DepthClass.parse(p['max_depth_class']),
      kmShallow: _d(p['km_shallow']),
      kmMedium: _d(p['km_medium']),
      kmDeep: _d(p['km_deep']),
      boatLegKm: _d(p['boat_leg_km']),
      uncertainBridges: p['uncertain_bridges'] as int,
      riskScore: _d(p['risk_score']),
      riskLevel: RiskLevel.parse(p['risk_level']),
      points: lineFromGeometry(feature['geometry'] as Map<String, dynamic>),
    );
  }

  static List<RouteLine> listFromJson(Map<String, dynamic> collection) =>
      [for (final f in featuresOf(collection)) RouteLine.fromFeature(f)];
}
