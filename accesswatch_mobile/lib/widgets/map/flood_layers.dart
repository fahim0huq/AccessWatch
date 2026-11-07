// Depth zones, flood, official EMS flood and flooded roads.
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart' show LatLng;

import '../../data/depth_lod.dart';
import '../../data/models/enums.dart';
import '../../data/models/geo.dart';
import '../../state/map_state.dart';
import '../../state/providers.dart';
import '../../theme/app_theme.dart';
import '../mission_card_sections.dart' show depthColor;

Polygon<R> mapPolygon<R extends Object>(GeoPolygon p, Color fill, {Color? border, double width = 0, R? hit}) => Polygon<R>(
      points: p.outer,
      holePointsList: p.holes.isEmpty ? null : p.holes,
      color: fill,
      borderColor: border ?? const Color(0x00000000),
      borderStrokeWidth: width,
      hitValue: hit,
    );

/// Picks the detail level for the current zoom. Polygon objects are kept per
/// level, because the map's own drawing cache is tied to them.
class DepthZonesLayer extends ConsumerStatefulWidget {
  const DepthZonesLayer({super.key});

  @override
  ConsumerState<DepthZonesLayer> createState() => _DepthZonesLayerState();
}

class _DepthZonesLayerState extends ConsumerState<DepthZonesLayer> {
  final _cache = <int, List<Polygon<Object>>>{};
  double? _cachedOpacity;

  @override
  Widget build(BuildContext context) {
    final opacity = ref.watch(mapOpacityProvider)[MapLayer.depthZones]!;
    if (opacity != _cachedOpacity) {
      _cache.clear();
      _cachedOpacity = opacity;
    }
    final lod = ref.watch(loadedBundleProvider).depthLod;
    final level = DepthLod.levelIndexForZoom(MapCamera.of(context).zoom);
    final polygons = _cache.putIfAbsent(
      level,
      () => [
        for (final patch in lod.levels[level])
          mapPolygon<Object>(patch.polygon, depthColor(patch.depthClass).withValues(alpha: opacity)),
      ],
    );
    return PolygonLayer<Object>(polygons: polygons);
  }
}

/// Our flood map. It sits above the depth zones, so it stays faint with a clear edge.
class FloodLayer extends ConsumerWidget {
  const FloodLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opacity = ref.watch(mapOpacityProvider)[MapLayer.flood]!;
    final flood = ref.watch(loadedBundleProvider).flood;
    return PolygonLayer<Object>(polygons: [
      for (final area in flood)
        for (final polygon in area.polygons)
          mapPolygon<Object>(polygon, AppColors.floodMedium.withValues(alpha: opacity),
              border: AppColors.floodDeep.withValues(alpha: 0.8), width: 1),
    ]);
  }
}

/// The threshold map, not calibrated on EMS.
class BaselineFloodLayer extends ConsumerWidget {
  const BaselineFloodLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opacity = ref.watch(mapOpacityProvider)[MapLayer.floodBaseline]!;
    final baseline = ref.watch(loadedBundleProvider).floodBaseline;
    return PolygonLayer<Object>(polygons: [
      for (final area in baseline)
        for (final polygon in area.polygons)
          mapPolygon<Object>(polygon, AppColors.floodBaseline.withValues(alpha: opacity),
              border: AppColors.floodBaseline, width: 1.5),
    ]);
  }
}

class EmsFloodLayer extends ConsumerWidget {
  const EmsFloodLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opacity = ref.watch(mapOpacityProvider)[MapLayer.floodEms]!;
    final ems = ref.watch(loadedBundleProvider).ems;
    return PolygonLayer<Object>(polygons: [
      for (final polygon in ems.flood)
        mapPolygon<Object>(polygon, AppColors.warning.withValues(alpha: opacity),
            border: AppColors.warning, width: 1.5),
    ]);
  }
}

/// Only the flooded edges of graph.json. Each edge is a straight piece between
/// its two end points, which is all the geometry the graph holds.
class FloodedRoadsLayer extends ConsumerStatefulWidget {
  const FloodedRoadsLayer({super.key});

  @override
  ConsumerState<FloodedRoadsLayer> createState() => _FloodedRoadsLayerState();
}

class _FloodedRoadsLayerState extends ConsumerState<FloodedRoadsLayer> {
  List<Polyline<Object>>? _lines;
  double? _opacity;

  @override
  Widget build(BuildContext context) {
    final opacity = ref.watch(mapOpacityProvider)[MapLayer.floodedRoads]!;
    if (_lines == null || opacity != _opacity) {
      _opacity = opacity;
      final g = ref.read(loadedBundleProvider).graph;
      _lines = [
        for (var e = 0; e < g.edgeCount; e++)
          if (g.depthClass[e] > 0)
            Polyline<Object>(
              points: [LatLng(g.lat[g.u[e]], g.lon[g.u[e]]), LatLng(g.lat[g.v[e]], g.lon[g.v[e]])],
              strokeWidth: 3,
              color: depthColor(DepthClass.fromCode(g.depthClass[e])).withValues(alpha: opacity),
              borderStrokeWidth: 1,
              borderColor: Colors.white.withValues(alpha: opacity),
            ),
      ];
    }
    return PolylineLayer<Object>(polylines: _lines!);
  }
}
