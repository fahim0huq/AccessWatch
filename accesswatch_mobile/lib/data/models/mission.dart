import 'package:latlong2/latlong.dart';

import 'enums.dart';

double _d(Object? v) => (v as num).toDouble();

class LostService {
  final ServiceLink service;

  /// Travel time before the flood; null for the depot link.
  final int? previousMinutes;

  const LostService(this.service, this.previousMinutes);

  factory LostService.fromJson(Map<String, dynamic> j) =>
      LostService(ServiceLink.parse(j['service']), j['previous_minutes'] as int?);
}

class MissionRoute {
  final double distanceKm, timeMin, riskScore;
  final DepthClass maxDepthClass;
  final RiskLevel riskLevel;
  final int uncertainBridges;

  const MissionRoute({
    required this.distanceKm,
    required this.timeMin,
    required this.riskScore,
    required this.maxDepthClass,
    required this.riskLevel,
    required this.uncertainBridges,
  });

  factory MissionRoute.fromJson(Map<String, dynamic> j) => MissionRoute(
        distanceKm: _d(j['distance_km']),
        timeMin: _d(j['time_min']),
        riskScore: _d(j['risk_score']),
        maxDepthClass: DepthClass.parse(j['max_depth_class']),
        riskLevel: RiskLevel.parse(j['risk_level']),
        uncertainBridges: j['uncertain_bridges'] as int,
      );

  bool sameAs(MissionRoute other) => distanceKm == other.distanceKm && riskScore == other.riskScore;
}

class PriorityTerms {
  final double popNorm, serviceLossNorm, difficultyNorm;

  const PriorityTerms(this.popNorm, this.serviceLossNorm, this.difficultyNorm);

  factory PriorityTerms.fromJson(Map<String, dynamic> j) =>
      PriorityTerms(_d(j['pop_norm']), _d(j['service_loss_norm']), _d(j['difficulty_norm']));
}

/// A card of `missions.json`, sorted by rank. It holds no ready-made text:
/// the app builds all visible text from these fields in the current language.
class Mission {
  final int rank;
  final String pocketId;
  final LatLng location;
  final String nearestPlace, directionFromPlace;
  final int population;
  final PocketStatus accessStatus;
  final AccessMode accessMode;
  final double boatLegKm;
  final List<LostService> lostServices;
  final List<ServiceLink> limitedServices;
  final ServiceAccess clinic, market, shelter, aidDepot;
  final MissionRoute safest, shortest;
  final DepthClass maxDepthClass;
  final RiskLevel riskLevel;
  final Confidence confidence;
  final bool verificationRequired, shortWaterCrossing, depotAutoSelected;
  final double priorityScore;
  final PriorityTerms priorityTerms;
  final double stability;
  final AccessMode worstCaseMode;

  const Mission({
    required this.rank,
    required this.pocketId,
    required this.location,
    required this.nearestPlace,
    required this.directionFromPlace,
    required this.population,
    required this.accessStatus,
    required this.accessMode,
    required this.boatLegKm,
    required this.lostServices,
    required this.limitedServices,
    required this.clinic,
    required this.market,
    required this.shelter,
    required this.aidDepot,
    required this.safest,
    required this.shortest,
    required this.maxDepthClass,
    required this.riskLevel,
    required this.confidence,
    required this.verificationRequired,
    required this.shortWaterCrossing,
    required this.depotAutoSelected,
    required this.priorityScore,
    required this.priorityTerms,
    required this.stability,
    required this.worstCaseMode,
  });

  factory Mission.fromJson(Map<String, dynamic> j) {
    final location = j['location'] as Map<String, dynamic>;
    final access = j['service_access'] as Map<String, dynamic>;
    final routes = j['routes'] as Map<String, dynamic>;
    return Mission(
      rank: j['rank'] as int,
      pocketId: j['pocket_id'] as String,
      location: LatLng(_d(location['lat']), _d(location['lon'])),
      nearestPlace: location['nearest_place'] as String,
      directionFromPlace: location['direction_from_place'] as String,
      population: j['population'] as int,
      accessStatus: PocketStatus.parse(j['access_status']),
      accessMode: AccessMode.parse(j['access_mode']),
      boatLegKm: _d(j['boat_leg_km']),
      lostServices: [
        for (final s in j['lost_services'] as List<dynamic>) LostService.fromJson(s as Map<String, dynamic>),
      ],
      limitedServices: [for (final s in j['limited_services'] as List<dynamic>) ServiceLink.parse(s)],
      clinic: ServiceAccess.parse(access['clinic']),
      market: ServiceAccess.parse(access['market']),
      shelter: ServiceAccess.parse(access['shelter']),
      aidDepot: ServiceAccess.parse(access['aid_depot']),
      safest: MissionRoute.fromJson(routes['safest'] as Map<String, dynamic>),
      shortest: MissionRoute.fromJson(routes['shortest'] as Map<String, dynamic>),
      maxDepthClass: DepthClass.parse(j['max_depth_class']),
      riskLevel: RiskLevel.parse(j['risk_level']),
      confidence: Confidence.parse(j['confidence']),
      verificationRequired: j['verification_required'] as bool,
      shortWaterCrossing: j['short_water_crossing'] as bool,
      depotAutoSelected: j['depot_auto_selected'] as bool,
      priorityScore: _d(j['priority_score']),
      priorityTerms: PriorityTerms.fromJson(j['priority_terms'] as Map<String, dynamic>),
      stability: _d(j['stability']),
      worstCaseMode: AccessMode.parse(j['worst_case_mode']),
    );
  }

  static List<Mission> listFromJson(Map<String, dynamic> doc) => [
        for (final c in doc['cards'] as List<dynamic>) Mission.fromJson(c as Map<String, dynamic>),
      ];
}
