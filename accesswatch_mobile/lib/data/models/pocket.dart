import 'package:latlong2/latlong.dart';

import 'enums.dart';
import 'geo.dart';

double _d(Object? v) => (v as num).toDouble();

List<ServiceLink> _links(Object? csv) {
  final text = csv as String;
  return text.isEmpty ? const [] : [for (final s in text.split(',')) ServiceLink.parse(s.trim())];
}

/// A feature of `pockets.geojson`. `population` is a modelled estimate.
class Pocket {
  final String id;
  final int rank;
  final double priorityScore;
  final int population;
  final PocketStatus status;
  final AccessMode accessMode;
  final double boatLegKm;
  final ServiceAccess clinicAccess, marketAccess, shelterAccess, aidDepotAccess;
  final List<ServiceLink> lostServices, limitedServices;
  final RiskLevel riskLevel;
  final DepthClass maxDepthClass;
  final Confidence confidence;
  final double stability, modeStability;
  final AccessMode worstCaseMode;
  final String nearestPlace, placeDirection;
  final int placeDistanceM;
  final double popNorm, serviceLossNorm, difficultyNorm;
  final double routeShortestKm;
  final DepthClass routeShortestMaxDepth;
  final double routeSafestKm, routeSafestMin;
  final int routeSafestUncertainBridges;
  final LatLng point;
  final List<GeoPolygon> polygons;

  const Pocket({
    required this.id,
    required this.rank,
    required this.priorityScore,
    required this.population,
    required this.status,
    required this.accessMode,
    required this.boatLegKm,
    required this.clinicAccess,
    required this.marketAccess,
    required this.shelterAccess,
    required this.aidDepotAccess,
    required this.lostServices,
    required this.limitedServices,
    required this.riskLevel,
    required this.maxDepthClass,
    required this.confidence,
    required this.stability,
    required this.modeStability,
    required this.worstCaseMode,
    required this.nearestPlace,
    required this.placeDirection,
    required this.placeDistanceM,
    required this.popNorm,
    required this.serviceLossNorm,
    required this.difficultyNorm,
    required this.routeShortestKm,
    required this.routeShortestMaxDepth,
    required this.routeSafestKm,
    required this.routeSafestMin,
    required this.routeSafestUncertainBridges,
    required this.point,
    required this.polygons,
  });

  factory Pocket.fromFeature(Map<String, dynamic> feature) {
    final p = feature['properties'] as Map<String, dynamic>;
    return Pocket(
      id: p['pocket_id'] as String,
      rank: p['rank'] as int,
      priorityScore: _d(p['priority_score']),
      population: p['population'] as int,
      status: PocketStatus.parse(p['status']),
      accessMode: AccessMode.parse(p['access_mode']),
      boatLegKm: _d(p['boat_leg_km']),
      clinicAccess: ServiceAccess.parse(p['clinic_access']),
      marketAccess: ServiceAccess.parse(p['market_access']),
      shelterAccess: ServiceAccess.parse(p['shelter_access']),
      aidDepotAccess: ServiceAccess.parse(p['aid_depot_access']),
      lostServices: _links(p['lost_services']),
      limitedServices: _links(p['limited_services']),
      riskLevel: RiskLevel.parse(p['risk_level']),
      maxDepthClass: DepthClass.parse(p['max_depth_class']),
      confidence: Confidence.parse(p['confidence']),
      stability: _d(p['stability']),
      modeStability: _d(p['mode_stability']),
      worstCaseMode: AccessMode.parse(p['worst_case_mode']),
      nearestPlace: p['nearest_place'] as String,
      placeDirection: p['place_direction'] as String,
      placeDistanceM: p['place_distance_m'] as int,
      popNorm: _d(p['pop_norm']),
      serviceLossNorm: _d(p['service_loss_norm']),
      difficultyNorm: _d(p['difficulty_norm']),
      routeShortestKm: _d(p['route_shortest_km']),
      routeShortestMaxDepth: DepthClass.parse(p['route_shortest_max_depth']),
      routeSafestKm: _d(p['route_safest_km']),
      routeSafestMin: _d(p['route_safest_min']),
      routeSafestUncertainBridges: p['route_safest_uncertain_bridges'] as int,
      point: LatLng(_d(p['lat']), _d(p['lon'])),
      polygons: polygonsFromGeometry(feature['geometry'] as Map<String, dynamic>),
    );
  }

  static List<Pocket> listFromJson(Map<String, dynamic> collection) =>
      [for (final f in featuresOf(collection)) Pocket.fromFeature(f)];
}
