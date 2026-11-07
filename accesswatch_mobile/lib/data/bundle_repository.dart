import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'depth_lod.dart';
import 'models/layers.dart';
import 'models/manifest.dart';
import 'models/mission.dart';
import 'models/pocket.dart';
import 'models/quality.dart';
import 'models/road_graph.dart';
import 'models/route_line.dart';
import 'models/service_point.dart';

/// Everything in `assets/bundle/`, parsed. `compare.png` is shown from its asset path.
class AppBundle {
  final Manifest manifest;
  final Quality quality;
  final List<FloodArea> flood, floodBaseline;
  final EmsLayer ems;
  final List<DepthZone> depthZones;

  /// Simplified copies of [depthZones] for drawing, by zoom.
  final DepthLod depthLod;
  final List<Pocket> pockets;
  final List<RouteLine> routes;
  final List<ServicePoint> services;
  final List<Mission> missions;
  final RoadGraph graph;

  const AppBundle({
    required this.manifest,
    required this.quality,
    required this.flood,
    required this.floodBaseline,
    required this.ems,
    required this.depthZones,
    required this.depthLod,
    required this.pockets,
    required this.routes,
    required this.services,
    required this.missions,
    required this.graph,
  });

  Iterable<ServicePoint> get clinics => services.where((s) => s.clinicStatus != null);
}

// Top-level so compute can run them in another isolate.
Map<String, dynamic> _json(String text) => jsonDecode(text) as Map<String, dynamic>;
List<FloodArea> _parseFlood(String text) => FloodArea.listFromJson(_json(text));
EmsLayer _parseEms(String text) => EmsLayer.fromJson(_json(text));
(List<DepthZone>, DepthLod) _parseDepth(String text) {
  final zones = DepthZone.listFromJson(_json(text));
  return (zones, buildDepthLod(zones));
}
List<Pocket> _parsePockets(String text) => Pocket.listFromJson(_json(text));
List<RouteLine> _parseRoutes(String text) => RouteLine.listFromJson(_json(text));
RoadGraph _parseGraph(String text) => RoadGraph.fromJson(_json(text));

class BundleRepository {
  static const assetDir = 'assets/bundle';
  static const compareImageAsset = '$assetDir/compare.png';

  final AssetBundle assets;

  BundleRepository([AssetBundle? assets]) : assets = assets ?? rootBundle;

  Future<String> _text(String name) => assets.loadString('$assetDir/$name', cache: false);

  /// Large files go through an isolate; the small ones parse on the spot.
  Future<T> _big<T>(String name, ComputeCallback<String, T> parse) async =>
      compute(parse, await _text(name), debugLabel: name);

  Future<T> _small<T>(String name, T Function(Map<String, dynamic>) parse) async =>
      parse(_json(await _text(name)));

  Future<AppBundle> load() async {
    final manifest = _small('manifest.json', Manifest.fromJson);
    final quality = _small('quality.json', Quality.fromJson);
    final flood = _big('flood.geojson', _parseFlood);
    final baseline = _big('flood_baseline.geojson', _parseFlood);
    final ems = _big('flood_ems.geojson', _parseEms);
    final depth = _big('depth_zones.geojson', _parseDepth);
    final pockets = _big('pockets.geojson', _parsePockets);
    final routes = _big('routes.geojson', _parseRoutes);
    final services = _small('services.geojson', ServicePoint.listFromJson);
    final missions = _small('missions.json', Mission.listFromJson);
    final graph = _big('graph.json', _parseGraph);
    return AppBundle(
      manifest: await manifest,
      quality: await quality,
      flood: await flood,
      floodBaseline: await baseline,
      ems: await ems,
      depthZones: (await depth).$1,
      depthLod: (await depth).$2,
      pockets: await pockets,
      routes: await routes,
      services: await services,
      missions: await missions,
      graph: await graph,
    );
  }
}
