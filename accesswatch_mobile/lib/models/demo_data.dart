import 'dart:ui';

enum DepthClass { shallow, medium, deep, dry }

extension DepthClassExtension on DepthClass {
  String get label {
    switch (this) {
      case DepthClass.shallow:
        return 'SHALLOW';
      case DepthClass.medium:
        return 'MEDIUM';
      case DepthClass.deep:
        return 'DEEP';
      case DepthClass.dry:
        return 'DRY';
    }
  }

  String get rangeLabel {
    switch (this) {
      case DepthClass.shallow:
        return '< 0.3 m';
      case DepthClass.medium:
        return '0.3 – 0.8 m';
      case DepthClass.deep:
        return '> 0.8 m';
      case DepthClass.dry:
        return '0.0 m';
    }
  }
}

class RouteDetail {
  final double distanceKm;
  final int durationMin;
  final double estimatedMaxDepthMeters;
  final DepthClass depthClass;
  final String depth;
  final String risk; // 'HIGH', 'MEDIUM', 'LOW'
  final List<Offset> pathPoints; // percentage [0-100, 0-100]

  const RouteDetail({
    required this.distanceKm,
    required this.durationMin,
    required this.estimatedMaxDepthMeters,
    required this.depthClass,
    required this.depth,
    required this.risk,
    required this.pathPoints,
  });
}

class PocketRoutes {
  final RouteDetail shortest;
  final RouteDetail safest;

  const PocketRoutes({
    required this.shortest,
    required this.safest,
  });
}

class Pocket {
  final String id;
  final int rank;
  final String name;
  final String status; // 'CUT OFF', 'ISOLATED', 'HIGH RISK'
  final int population;
  final List<int> popRange;
  final List<String> servicesLost;
  final String accessMode; // 'BOAT', 'HIGH-CLEARANCE TRUCK', 'VEHICLE', 'ON FOOT'
  final double maxEstimatedDepthMeters;
  final DepthClass depthClass;
  final String waterDepth; // 'SHALLOW', 'MEDIUM', 'DEEP'
  final String confidence; // 'HIGH', 'MEDIUM', 'LOW'
  final String whyFlagged;
  final List<String> recommendedEquipment;
  final PocketRoutes routes;
  final Offset coordinates; // percentage [0-100, 0-100]

  const Pocket({
    required this.id,
    required this.rank,
    required this.name,
    required this.status,
    required this.population,
    required this.popRange,
    required this.servicesLost,
    required this.accessMode,
    required this.maxEstimatedDepthMeters,
    required this.depthClass,
    required this.waterDepth,
    required this.confidence,
    required this.whyFlagged,
    required this.recommendedEquipment,
    required this.routes,
    required this.coordinates,
  });
}

class ServicePoint {
  final String id;
  final String name;
  final String type; // 'CLINIC', 'MARKET', 'SHELTER', 'AID_DEPOT'
  final Offset coordinates; // percentage [0-100, 0-100]
  final String status; // 'OPERATIONAL', 'FLOODED', 'INACCESSIBLE'

  const ServicePoint({
    required this.id,
    required this.name,
    required this.type,
    required this.coordinates,
    required this.status,
  });
}

class RoadSegment {
  final String id;
  final String name;
  final String status; // 'OPEN', 'FLOODED', 'BLOCKED'
  final DepthClass depthClass;
  final double estimatedDepthMeters;
  final String? depth;
  final List<Offset> points;

  const RoadSegment({
    required this.id,
    required this.name,
    required this.status,
    required this.depthClass,
    required this.estimatedDepthMeters,
    this.depth,
    required this.points,
  });
}

class FloodZone {
  final String id;
  final String depth; // 'SHALLOW', 'MEDIUM', 'DEEP'
  final List<Offset> polygon;

  const FloodZone({
    required this.id,
    required this.depth,
    required this.polygon,
  });
}

class DemoDataset {
  final String scenarioName;
  final String locationName;
  final String lastUpdated;
  final String satelliteSource;
  final Map<String, dynamic> kpis;
  final List<Pocket> pockets;
  final List<ServicePoint> services;
  final List<RoadSegment> roads;
  final List<FloodZone> floodZones;

  const DemoDataset({
    required this.scenarioName,
    required this.locationName,
    required this.lastUpdated,
    required this.satelliteSource,
    required this.kpis,
    required this.pockets,
    required this.services,
    required this.roads,
    required this.floodZones,
  });
}

const DEMO_DATA = DemoDataset(
  scenarioName: 'Illustrative Flood Scenario — Licungo Basin',
  locationName: 'Zambezia Province, Mozambique',
  lastUpdated: '2026-10-07 08:30 UTC',
  satelliteSource: 'NISAR L-band SAR + NASADEM',
  kpis: {
    'floodedAreaKm2': 42.7,
    'isolatedPockets': 8,
    'peopleAffectedEstimate': 3060,
    'boatsRecommended': 3,
    'trucksRecommended': 2,
    'shallowSegmentsCount': 14,
    'mediumSegmentsCount': 9,
    'deepSegmentsCount': 5,
  },
  services: [
    ServicePoint(id: 'c1', name: 'Central Rural Clinic', type: 'CLINIC', coordinates: Offset(18, 45), status: 'OPERATIONAL'),
    ServicePoint(id: 'c2', name: 'North Bank Health Post', type: 'CLINIC', coordinates: Offset(40, 22), status: 'INACCESSIBLE'),
    ServicePoint(id: 'c3', name: 'East Delta Medical Hub', type: 'CLINIC', coordinates: Offset(85, 38), status: 'OPERATIONAL'),
    ServicePoint(id: 'c4', name: 'South Highway Clinic', type: 'CLINIC', coordinates: Offset(52, 82), status: 'OPERATIONAL'),

    ServicePoint(id: 'm1', name: 'Main Regional Market', type: 'MARKET', coordinates: Offset(22, 50), status: 'OPERATIONAL'),
    ServicePoint(id: 'm2', name: 'Canal Produce Hub', type: 'MARKET', coordinates: Offset(58, 44), status: 'FLOODED'),
    ServicePoint(id: 'm3', name: 'Lowland Grain Depot', type: 'MARKET', coordinates: Offset(72, 70), status: 'FLOODED'),
    ServicePoint(id: 'm4', name: 'North River Market', type: 'MARKET', coordinates: Offset(35, 18), status: 'INACCESSIBLE'),
    ServicePoint(id: 'm5', name: 'East Boundary Market', type: 'MARKET', coordinates: Offset(88, 55), status: 'OPERATIONAL'),

    ServicePoint(id: 's1', name: 'St. Jude Emergency Shelter', type: 'SHELTER', coordinates: Offset(28, 65), status: 'OPERATIONAL'),
    ServicePoint(id: 's2', name: 'High School Evac Site', type: 'SHELTER', coordinates: Offset(78, 25), status: 'OPERATIONAL'),

    ServicePoint(id: 'a1', name: 'UN Humanitarian Staging Depot', type: 'AID_DEPOT', coordinates: Offset(15, 75), status: 'OPERATIONAL'),
  ],
  pockets: [
    Pocket(
      id: 'pocket-01',
      rank: 1,
      name: 'Riverbend North',
      status: 'CUT OFF',
      population: 520,
      popRange: [420, 640],
      servicesLost: ['Clinic', 'Market'],
      accessMode: 'BOAT',
      maxEstimatedDepthMeters: 1.18,
      depthClass: DepthClass.deep,
      waterDepth: 'DEEP',
      confidence: 'MEDIUM',
      whyFlagged: 'Floodwater has completely severed Riverbend North from the nearest clinic and market. The primary access road has an estimated deep-water submergence of 1.18 meters.',
      recommendedEquipment: [
        'Boat and trained crew (Rigid Inflatable Boat)',
        'Life jackets (minimum 15 units)',
        'VHF Radio & Satellite phone',
        'Emergency medical supply kit (peds + trauma)',
        'Clean drinking water & high-energy rations (3-day batch)'
      ],
      routes: PocketRoutes(
        shortest: RouteDetail(
          distanceKm: 8.4,
          durationMin: 31,
          estimatedMaxDepthMeters: 1.18,
          depthClass: DepthClass.deep,
          depth: '1.18 m',
          risk: 'HIGH',
          pathPoints: [Offset(15, 75), Offset(22, 50), Offset(32, 42), Offset(42, 35), Offset(46, 28)],
        ),
        safest: RouteDetail(
          distanceKm: 10.2,
          durationMin: 39,
          estimatedMaxDepthMeters: 0.56,
          depthClass: DepthClass.medium,
          depth: '0.56 m',
          risk: 'LOW',
          pathPoints: [Offset(15, 75), Offset(12, 60), Offset(18, 30), Offset(30, 20), Offset(42, 22), Offset(46, 28)],
        ),
      ),
      coordinates: Offset(46, 28),
    ),
    Pocket(
      id: 'pocket-02',
      rank: 2,
      name: 'Low Fields East',
      status: 'CUT OFF',
      population: 340,
      popRange: [280, 410],
      servicesLost: ['Market', 'Shelter'],
      accessMode: 'HIGH-CLEARANCE TRUCK',
      maxEstimatedDepthMeters: 0.62,
      depthClass: DepthClass.medium,
      waterDepth: 'MEDIUM',
      confidence: 'HIGH',
      whyFlagged: 'Surrounding agricultural fields are inundated. Secondary access road is submerged in medium depth water (0.62 m), blocking standard vehicles.',
      recommendedEquipment: [
        'High-clearance 4x4 Heavy Duty Truck',
        'Self-recovery electric winch & recovery tracks',
        'Satellite comms unit',
        'Emergency shelter tarps & hygiene packs'
      ],
      routes: PocketRoutes(
        shortest: RouteDetail(
          distanceKm: 6.2,
          durationMin: 22,
          estimatedMaxDepthMeters: 1.05,
          depthClass: DepthClass.deep,
          depth: '1.05 m',
          risk: 'HIGH',
          pathPoints: [Offset(15, 75), Offset(28, 65), Offset(45, 68), Offset(64, 62)],
        ),
        safest: RouteDetail(
          distanceKm: 9.1,
          durationMin: 30,
          estimatedMaxDepthMeters: 0.24,
          depthClass: DepthClass.shallow,
          depth: '0.24 m',
          risk: 'LOW',
          pathPoints: [Offset(15, 75), Offset(20, 85), Offset(48, 88), Offset(68, 75), Offset(64, 62)],
        ),
      ),
      coordinates: Offset(64, 62),
    ),
    Pocket(
      id: 'pocket-03',
      rank: 3,
      name: 'Mill Road Cluster',
      status: 'CUT OFF',
      population: 610,
      popRange: [500, 750],
      servicesLost: ['Clinic', 'Aid Depot'],
      accessMode: 'BOAT',
      maxEstimatedDepthMeters: 1.62,
      depthClass: DepthClass.deep,
      waterDepth: 'DEEP',
      confidence: 'HIGH',
      whyFlagged: 'Major river embankment breach flooded the main causeway. Community is stranded on elevated alluvial mound with standing water reaching 1.62 m.',
      recommendedEquipment: [
        'Shallow-draft motorized boat',
        'Life jackets & throw ropes',
        'Portable water purification filtration units',
        'Basic oral rehydration & antimalarial medicine'
      ],
      routes: PocketRoutes(
        shortest: RouteDetail(
          distanceKm: 11.5,
          durationMin: 45,
          estimatedMaxDepthMeters: 1.62,
          depthClass: DepthClass.deep,
          depth: '1.62 m',
          risk: 'HIGH',
          pathPoints: [Offset(15, 75), Offset(35, 60), Offset(55, 50), Offset(72, 45)],
        ),
        safest: RouteDetail(
          distanceKm: 14.8,
          durationMin: 52,
          estimatedMaxDepthMeters: 0.72,
          depthClass: DepthClass.medium,
          depth: '0.72 m',
          risk: 'LOW',
          pathPoints: [Offset(15, 75), Offset(18, 45), Offset(40, 22), Offset(65, 26), Offset(72, 45)],
        ),
      ),
      coordinates: Offset(72, 45),
    ),
    Pocket(
      id: 'pocket-04',
      rank: 4,
      name: 'Canal Hamlet',
      status: 'CUT OFF',
      population: 290,
      popRange: [230, 350],
      servicesLost: ['Market'],
      accessMode: 'HIGH-CLEARANCE TRUCK',
      maxEstimatedDepthMeters: 0.48,
      depthClass: DepthClass.medium,
      waterDepth: 'MEDIUM',
      confidence: 'MEDIUM',
      whyFlagged: 'Irrigation canal overflow blocked the northern bypass bridge. Access is restricted with estimated maximum depth of 0.48 m.',
      recommendedEquipment: [
        'All-terrain 4x4 SUV / Pickup',
        'Tow straps & tire deflation kit',
        'Solar charging power banks',
        'Dry bags for documents and supplies'
      ],
      routes: PocketRoutes(
        shortest: RouteDetail(
          distanceKm: 4.8,
          durationMin: 18,
          estimatedMaxDepthMeters: 0.79,
          depthClass: DepthClass.medium,
          depth: '0.79 m',
          risk: 'MEDIUM',
          pathPoints: [Offset(15, 75), Offset(28, 65), Offset(38, 52), Offset(52, 48)],
        ),
        safest: RouteDetail(
          distanceKm: 7.0,
          durationMin: 25,
          estimatedMaxDepthMeters: 0.18,
          depthClass: DepthClass.shallow,
          depth: '0.18 m',
          risk: 'LOW',
          pathPoints: [Offset(15, 75), Offset(22, 82), Offset(38, 78), Offset(52, 65), Offset(52, 48)],
        ),
      ),
      coordinates: Offset(52, 48),
    ),
    Pocket(
      id: 'pocket-05',
      rank: 5,
      name: 'School Junction',
      status: 'CUT OFF',
      population: 480,
      popRange: [390, 580],
      servicesLost: ['Clinic', 'Shelter'],
      accessMode: 'ON FOOT',
      maxEstimatedDepthMeters: 0.28,
      depthClass: DepthClass.shallow,
      waterDepth: 'SHALLOW',
      confidence: 'HIGH',
      whyFlagged: 'Collapsed culvert prevents motorized vehicle crossing. Foot teams can cross shallow waters (0.28 m max) via elevated railway embankment.',
      recommendedEquipment: [
        'Foot team with chest waders & poles',
        'Folding stretchers for medical evacuation',
        'VHF radios & headlamps',
        'First aid & emergency thermal blankets'
      ],
      routes: PocketRoutes(
        shortest: RouteDetail(
          distanceKm: 3.5,
          durationMin: 40,
          estimatedMaxDepthMeters: 0.35,
          depthClass: DepthClass.medium,
          depth: '0.35 m',
          risk: 'MEDIUM',
          pathPoints: [Offset(15, 75), Offset(22, 50), Offset(28, 38), Offset(34, 38)],
        ),
        safest: RouteDetail(
          distanceKm: 5.2,
          durationMin: 55,
          estimatedMaxDepthMeters: 0.12,
          depthClass: DepthClass.shallow,
          depth: '0.12 m',
          risk: 'LOW',
          pathPoints: [Offset(15, 75), Offset(18, 45), Offset(25, 32), Offset(34, 38)],
        ),
      ),
      coordinates: Offset(34, 38),
    ),
    Pocket(
      id: 'pocket-06',
      rank: 6,
      name: 'Hilltop Houses',
      status: 'ISOLATED',
      population: 180,
      popRange: [140, 230],
      servicesLost: ['Market'],
      accessMode: 'ON FOOT',
      maxEstimatedDepthMeters: 0.22,
      depthClass: DepthClass.shallow,
      waterDepth: 'SHALLOW',
      confidence: 'MEDIUM',
      whyFlagged: 'Settlement on ridge remains dry, but lowland connecting road is waterlogged with shallow mud and standing water (0.22 m).',
      recommendedEquipment: [
        'Standard 4x4 Utility vehicle',
        'Chainsaw for brush clearing',
        'Emergency food supply boxes'
      ],
      routes: PocketRoutes(
        shortest: RouteDetail(
          distanceKm: 7.8,
          durationMin: 28,
          estimatedMaxDepthMeters: 0.28,
          depthClass: DepthClass.shallow,
          depth: '0.28 m',
          risk: 'MEDIUM',
          pathPoints: [Offset(15, 75), Offset(35, 80), Offset(58, 78), Offset(78, 72)],
        ),
        safest: RouteDetail(
          distanceKm: 8.9,
          durationMin: 32,
          estimatedMaxDepthMeters: 0.05,
          depthClass: DepthClass.shallow,
          depth: '0.05 m',
          risk: 'LOW',
          pathPoints: [Offset(15, 75), Offset(42, 85), Offset(68, 85), Offset(78, 72)],
        ),
      ),
      coordinates: Offset(78, 72),
    ),
    Pocket(
      id: 'pocket-07',
      rank: 7,
      name: 'West Embankment',
      status: 'CUT OFF',
      population: 410,
      popRange: [330, 500],
      servicesLost: ['Clinic', 'Market', 'Shelter'],
      accessMode: 'BOAT',
      maxEstimatedDepthMeters: 1.34,
      depthClass: DepthClass.deep,
      waterDepth: 'DEEP',
      confidence: 'LOW',
      whyFlagged: 'L-band radar indicates broad water coverage across coastal levee with max depth of 1.34 m. Direct land route destroyed.',
      recommendedEquipment: [
        'Outboard motor craft',
        'Heavy mooring anchors & ropes',
        'Waterproof emergency tents',
        'Pediatric medical & nutrition kits'
      ],
      routes: PocketRoutes(
        shortest: RouteDetail(
          distanceKm: 9.3,
          durationMin: 38,
          estimatedMaxDepthMeters: 1.34,
          depthClass: DepthClass.deep,
          depth: '1.34 m',
          risk: 'HIGH',
          pathPoints: [Offset(15, 75), Offset(52, 82), Offset(68, 70), Offset(84, 60)],
        ),
        safest: RouteDetail(
          distanceKm: 12.1,
          durationMin: 46,
          estimatedMaxDepthMeters: 0.57,
          depthClass: DepthClass.medium,
          depth: '0.57 m',
          risk: 'LOW',
          pathPoints: [Offset(15, 75), Offset(52, 82), Offset(78, 85), Offset(88, 72), Offset(84, 60)],
        ),
      ),
      coordinates: Offset(84, 60),
    ),
    Pocket(
      id: 'pocket-08',
      rank: 8,
      name: 'Farm Cooperative',
      status: 'ISOLATED',
      population: 230,
      popRange: [180, 290],
      servicesLost: ['Aid Depot'],
      accessMode: 'HIGH-CLEARANCE TRUCK',
      maxEstimatedDepthMeters: 0.42,
      depthClass: DepthClass.medium,
      waterDepth: 'MEDIUM',
      confidence: 'HIGH',
      whyFlagged: 'Feeder road is submerged by flash runoff (0.42 m max depth). Passable only by elevated chassis vehicles.',
      recommendedEquipment: [
        'High-clearance truck',
        'Water purification tablet containers',
        'Heavy-duty dry sacks'
      ],
      routes: PocketRoutes(
        shortest: RouteDetail(
          distanceKm: 5.1,
          durationMin: 20,
          estimatedMaxDepthMeters: 0.72,
          depthClass: DepthClass.medium,
          depth: '0.72 m',
          risk: 'MEDIUM',
          pathPoints: [Offset(15, 75), Offset(30, 30), Offset(55, 20), Offset(62, 22)],
        ),
        safest: RouteDetail(
          distanceKm: 6.8,
          durationMin: 27,
          estimatedMaxDepthMeters: 0.24,
          depthClass: DepthClass.shallow,
          depth: '0.24 m',
          risk: 'LOW',
          pathPoints: [Offset(15, 75), Offset(18, 30), Offset(42, 18), Offset(62, 22)],
        ),
      ),
      coordinates: Offset(62, 22),
    ),
  ],

  roads: [
    RoadSegment(
      id: 'r1',
      name: 'N1 Main Trans-Regional Highway',
      status: 'OPEN',
      depthClass: DepthClass.dry,
      estimatedDepthMeters: 0.0,
      depth: null,
      points: [Offset(10, 85), Offset(15, 75), Offset(22, 50), Offset(18, 45), Offset(15, 20)],
    ),
    RoadSegment(
      id: 'r2',
      name: 'R204 North River Road',
      status: 'BLOCKED',
      depthClass: DepthClass.deep,
      estimatedDepthMeters: 1.34,
      depth: 'DEEP',
      points: [Offset(22, 50), Offset(32, 42), Offset(42, 35), Offset(46, 28), Offset(62, 22)],
    ),
    RoadSegment(
      id: 'r3',
      name: 'Canal South Access Link',
      status: 'FLOODED',
      depthClass: DepthClass.medium,
      estimatedDepthMeters: 0.57,
      depth: 'MEDIUM',
      points: [Offset(22, 50), Offset(28, 65), Offset(38, 52), Offset(52, 48), Offset(64, 62)],
    ),
    RoadSegment(
      id: 'r4',
      name: 'East Delta Trunk Road',
      status: 'BLOCKED',
      depthClass: DepthClass.deep,
      estimatedDepthMeters: 1.18,
      depth: 'DEEP',
      points: [Offset(52, 48), Offset(72, 45), Offset(84, 60), Offset(85, 38)],
    ),
    RoadSegment(
      id: 'r5',
      name: 'Southern Bypass Ridge',
      status: 'OPEN',
      depthClass: DepthClass.shallow,
      estimatedDepthMeters: 0.12,
      depth: 'SHALLOW',
      points: [Offset(15, 75), Offset(20, 85), Offset(48, 88), Offset(68, 75), Offset(78, 72)],
    ),
    RoadSegment(
      id: 'r6',
      name: 'Highland North Contour Link',
      status: 'FLOODED',
      depthClass: DepthClass.shallow,
      estimatedDepthMeters: 0.24,
      depth: 'SHALLOW',
      points: [Offset(18, 45), Offset(30, 20), Offset(42, 22), Offset(62, 22), Offset(78, 25)],
    ),
    RoadSegment(
      id: 'r7',
      name: 'Lowland Causeway Crossing',
      status: 'BLOCKED',
      depthClass: DepthClass.deep,
      estimatedDepthMeters: 1.62,
      depth: 'DEEP',
      points: [Offset(35, 60), Offset(55, 50), Offset(72, 45)],
    ),
    RoadSegment(
      id: 'r8',
      name: 'School Junction Culvert Path',
      status: 'FLOODED',
      depthClass: DepthClass.shallow,
      estimatedDepthMeters: 0.28,
      depth: 'SHALLOW',
      points: [Offset(22, 50), Offset(28, 38), Offset(34, 38)],
    ),
  ],

  floodZones: [
    FloodZone(
      id: 'fz-deep-1',
      depth: 'DEEP',
      polygon: [Offset(25, 30), Offset(45, 20), Offset(60, 25), Offset(55, 45), Offset(40, 48), Offset(28, 38)],
    ),
    FloodZone(
      id: 'fz-deep-2',
      depth: 'DEEP',
      polygon: [Offset(60, 40), Offset(85, 35), Offset(92, 55), Offset(80, 68), Offset(65, 58)],
    ),
    FloodZone(
      id: 'fz-med-1',
      depth: 'MEDIUM',
      polygon: [Offset(20, 25), Offset(50, 15), Offset(68, 20), Offset(62, 52), Offset(35, 55), Offset(22, 40)],
    ),
    FloodZone(
      id: 'fz-med-2',
      depth: 'MEDIUM',
      polygon: [Offset(50, 35), Offset(90, 30), Offset(96, 65), Offset(75, 75), Offset(55, 62)],
    ),
    FloodZone(
      id: 'fz-shallow-1',
      depth: 'SHALLOW',
      polygon: [Offset(15, 20), Offset(55, 10), Offset(75, 15), Offset(70, 58), Offset(30, 62), Offset(18, 45)],
    ),
    FloodZone(
      id: 'fz-shallow-2',
      depth: 'SHALLOW',
      polygon: [Offset(45, 30), Offset(94, 25), Offset(98, 72), Offset(70, 82), Offset(48, 68)],
    ),
  ],
);
