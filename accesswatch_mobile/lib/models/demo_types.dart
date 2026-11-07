// Core data-type definitions used by demo data and painter.
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

