// Demo roads, flood zones, KPIs, and re-exports for backward compatibility.
// Screens import this file just as before: `import 'demo_data.dart'`.
import 'dart:ui';
import 'demo_types.dart';
import 'demo_pockets.dart';
export 'demo_types.dart';
export 'demo_pockets.dart' show demoPockets, demoServices;

const _demoRoads = <RoadSegment>[
  RoadSegment(id: 'r1', name: 'N1 Main Trans-Regional Highway', status: 'OPEN', depthClass: DepthClass.dry, estimatedDepthMeters: 0.0, depth: null, points: [Offset(10, 85), Offset(15, 75), Offset(22, 50), Offset(18, 45), Offset(15, 20)]),
  RoadSegment(id: 'r2', name: 'R204 North River Road', status: 'BLOCKED', depthClass: DepthClass.deep, estimatedDepthMeters: 1.34, depth: 'DEEP', points: [Offset(22, 50), Offset(32, 42), Offset(42, 35), Offset(46, 28), Offset(62, 22)]),
  RoadSegment(id: 'r3', name: 'Canal South Access Link', status: 'FLOODED', depthClass: DepthClass.medium, estimatedDepthMeters: 0.57, depth: 'MEDIUM', points: [Offset(22, 50), Offset(28, 65), Offset(38, 52), Offset(52, 48), Offset(64, 62)]),
  RoadSegment(id: 'r4', name: 'East Delta Trunk Road', status: 'BLOCKED', depthClass: DepthClass.deep, estimatedDepthMeters: 1.18, depth: 'DEEP', points: [Offset(52, 48), Offset(72, 45), Offset(84, 60), Offset(85, 38)]),
  RoadSegment(id: 'r5', name: 'Southern Bypass Ridge', status: 'OPEN', depthClass: DepthClass.shallow, estimatedDepthMeters: 0.12, depth: 'SHALLOW', points: [Offset(15, 75), Offset(20, 85), Offset(48, 88), Offset(68, 75), Offset(78, 72)]),
  RoadSegment(id: 'r6', name: 'Highland North Contour Link', status: 'FLOODED', depthClass: DepthClass.shallow, estimatedDepthMeters: 0.24, depth: 'SHALLOW', points: [Offset(18, 45), Offset(30, 20), Offset(42, 22), Offset(62, 22), Offset(78, 25)]),
  RoadSegment(id: 'r7', name: 'Lowland Causeway Crossing', status: 'BLOCKED', depthClass: DepthClass.deep, estimatedDepthMeters: 1.62, depth: 'DEEP', points: [Offset(35, 60), Offset(55, 50), Offset(72, 45)]),
  RoadSegment(id: 'r8', name: 'School Junction Culvert Path', status: 'FLOODED', depthClass: DepthClass.shallow, estimatedDepthMeters: 0.28, depth: 'SHALLOW', points: [Offset(22, 50), Offset(28, 38), Offset(34, 38)]),
];

const _demoFloodZones = <FloodZone>[
  FloodZone(id: 'fz-deep-1', depth: 'DEEP', polygon: [Offset(25, 30), Offset(45, 20), Offset(60, 25), Offset(55, 45), Offset(40, 48), Offset(28, 38)]),
  FloodZone(id: 'fz-deep-2', depth: 'DEEP', polygon: [Offset(60, 40), Offset(85, 35), Offset(92, 55), Offset(80, 68), Offset(65, 58)]),
  FloodZone(id: 'fz-med-1', depth: 'MEDIUM', polygon: [Offset(20, 25), Offset(50, 15), Offset(68, 20), Offset(62, 52), Offset(35, 55), Offset(22, 40)]),
  FloodZone(id: 'fz-med-2', depth: 'MEDIUM', polygon: [Offset(50, 35), Offset(90, 30), Offset(96, 65), Offset(75, 75), Offset(55, 62)]),
  FloodZone(id: 'fz-shallow-1', depth: 'SHALLOW', polygon: [Offset(15, 20), Offset(55, 10), Offset(75, 15), Offset(70, 58), Offset(30, 62), Offset(18, 45)]),
  FloodZone(id: 'fz-shallow-2', depth: 'SHALLOW', polygon: [Offset(45, 30), Offset(94, 25), Offset(98, 72), Offset(70, 82), Offset(48, 68)]),
];

// ignore: constant_identifier_names
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
  services: demoServices,
  pockets: demoPockets,
  roads: _demoRoads,
  floodZones: _demoFloodZones,
);
