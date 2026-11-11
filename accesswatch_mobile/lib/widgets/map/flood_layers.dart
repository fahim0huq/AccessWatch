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

Polygon<R> mapPolygon<R extends Object>(GeoPolygon p, Color fill, {Color? border, double width = 0, R? hit}) =>
    Polygon<R>(
      points: p.outer,
      holePointsList: p.holes.isEmpty ? null : p.holes,
      color: fill,
      borderColor: border ?? Colors.transparent,
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
  // The layer widget itself is kept per level, not only its polygons: the map
  // library drops its projection cache whenever it receives a new layer widget,
  // and this widget rebuilds on every camera change because it reads the zoom.
  final _cache = <int, PolygonLayer<Object>>{};
  double? _cachedOpacity;

  @override
  Widget build(BuildContext context) {
    final opacity = ref.watch(mapOpacityProvider)[MapLayer.depthZones]!;
    if (opacity != _cachedOpacity) {
      _cache.clear();
      _cachedOpacity = opacity;
    }
    final zoom = MapCamera.of(context).zoom;
    if (zoom < depthZonesMinZoom) return const SizedBox.shrink();
    final lod = ref.watch(loadedBundleProvider).depthLod;
    final level = DepthLod.levelIndexForZoom(zoom);
    return _cache.putIfAbsent(
      level,
      () => PolygonLayer<Object>(
        polygons: [
          for (final patch in lod.levels[level])
            mapPolygon<Object>(patch.polygon, depthColor(patch.depthClass).withValues(alpha: opacity)),
        ],
      ),
    );
  }
}

/// Our flood map. It sits above the depth zones, so it stays faint with a clear edge.
class FloodLayer extends ConsumerWidget {
  const FloodLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opacity = ref.watch(mapOpacityProvider)[MapLayer.flood]!;
    final flood = ref.watch(loadedBundleProvider).flood;
    return PolygonLayer<Object>(
      polygons: [
        for (final area in flood)
          for (final polygon in area.polygons)
            mapPolygon<Object>(
              polygon,
              AppColors.floodFill.withValues(alpha: opacity),
              border: AppColors.flood,
              width: 1,
            ),
      ],
    );
  }
}

/// The threshold map, not calibrated on EMS.
class BaselineFloodLayer extends ConsumerWidget {
  const BaselineFloodLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opacity = ref.watch(mapOpacityProvider)[MapLayer.floodBaseline]!;
    final baseline = ref.watch(loadedBundleProvider).floodBaseline;
    return PolygonLayer<Object>(
      polygons: [
        for (final area in baseline)
          for (final polygon in area.polygons)
            mapPolygon<Object>(
              polygon,
              AppColors.floodBaseline.withValues(alpha: opacity),
              border: AppColors.floodBaseline,
              width: 1.5,
            ),
      ],
    );
  }
}

class EmsFloodLayer extends ConsumerWidget {
  const EmsFloodLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opacity = ref.watch(mapOpacityProvider)[MapLayer.floodEms]!;
    final ems = ref.watch(loadedBundleProvider).ems;
    return PolygonLayer<Object>(
      polygons: [
        for (final polygon in ems.flood)
          mapPolygon<Object>(polygon, AppColors.boat.withValues(alpha: opacity), border: AppColors.boat, width: 1.5),
      ],
    );
  }
}

/// Every road piece of graph.json, coloured by who can still use it. The graph
/// holds a passable flag per mode, so this is read straight from the data.
Color roadStatusColor(int flags) => (flags & 1) != 0
    ? AppColors.roadAnyCar
    : (flags & 2) != 0
    ? AppColors.roadHighClearance
    : (flags & 4) != 0
    ? AppColors.roadFootOnly
    : AppColors.roadImpassable;

class AllRoadsLayer extends ConsumerStatefulWidget {
  const AllRoadsLayer({super.key});

  @override
  ConsumerState<AllRoadsLayer> createState() => _AllRoadsLayerState();
}

class _AllRoadsLayerState extends ConsumerState<AllRoadsLayer> {
  PolylineLayer<Object>? _layer;
  double? _opacity;

  @override
  Widget build(BuildContext context) {
    final opacity = ref.watch(mapOpacityProvider)[MapLayer.allRoads]!;
    if (_layer == null || opacity != _opacity) {
      _opacity = opacity;
      final g = ref.read(loadedBundleProvider).graph;
      _layer = PolylineLayer<Object>(
        polylines: [
          for (var e = 0; e < g.edgeCount; e++)
            Polyline<Object>(
              points: [LatLng(g.lat[g.u[e]], g.lon[g.u[e]]), LatLng(g.lat[g.v[e]], g.lon[g.v[e]])],
              strokeWidth: 2.5,
              color: roadStatusColor(g.flags[e]).withValues(alpha: opacity),
            ),
        ],
      );
    }
    return _layer!;
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
              borderColor: AppColors.surface.withValues(alpha: opacity),
            ),
      ];
    }
    return PolylineLayer<Object>(polylines: _lines!);
  }
}
