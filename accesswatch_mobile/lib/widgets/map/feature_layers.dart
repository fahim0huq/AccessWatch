// Pockets, routes, services and my location. These are the layers people tap.
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/enums.dart';
import '../../data/models/pocket.dart';
import '../../data/models/route_line.dart';
import '../../data/models/service_point.dart';
import '../../l10n/app_localizations.dart';
import '../../state/map_state.dart';
import '../../state/mission_state.dart';
import '../../state/providers.dart';
import '../../theme/app_theme.dart';
import '../../utils/labels.dart';
import '../ui/mode_look.dart';
import 'flood_layers.dart' show mapPolygon;

export 'my_location_layer.dart';

/// Smallest tap area for anything on the map (Material and Android guidance).
const minTapTarget = 48.0;

/// Service names appear from this zoom; below it they would pile on top of each other.
const serviceLabelMinZoom = 15.0;

IconData serviceIcon(ServiceType type) => switch (type) {
  ServiceType.clinic => Icons.local_hospital_rounded,
  ServiceType.market => Icons.storefront_rounded,
  ServiceType.shelter => Icons.night_shelter_rounded,
  ServiceType.aidDepot => Icons.warehouse_rounded,
};

class PocketAreasLayer extends ConsumerStatefulWidget {
  final ValueChanged<Pocket> onTap;

  const PocketAreasLayer({super.key, required this.onTap});

  @override
  ConsumerState<PocketAreasLayer> createState() => _PocketAreasLayerState();
}

class _PocketAreasLayerState extends ConsumerState<PocketAreasLayer> {
  final LayerHitNotifier<Pocket> _hit = ValueNotifier(null);

  @override
  void dispose() {
    _hit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final opacity = ref.watch(mapOpacityProvider)[MapLayer.pockets]!;
    final selected = ref.watch(selectedPocketIdProvider);
    final pockets = ref.watch(loadedBundleProvider).pockets;
    return GestureDetector(
      excludeFromSemantics: true,
      onTap: () {
        final hits = _hit.value?.hitValues;
        if (hits != null && hits.isNotEmpty) widget.onTap(hits.first);
      },
      child: PolygonLayer<Pocket>(
        hitNotifier: _hit,
        polygons: [
          for (final pocket in pockets)
            for (final polygon in pocket.polygons)
              mapPolygon<Pocket>(
                polygon,
                modeMapColor(pocket.accessMode).withValues(alpha: opacity),
                border: pocket.id == selected ? AppColors.ink : modeMapColor(pocket.accessMode),
                width: pocket.id == selected ? 3 : 2,
                hit: pocket,
              ),
        ],
      ),
    );
  }
}

/// Area pills: the mode icon and the area's place in Help first. The words are
/// in the screen-reader label; the icon and the colour say boat or truck.
/// Pills that would cover a higher-ranked one wait until the map is zoomed in.
class PocketLabelsLayer extends ConsumerWidget {
  final ValueChanged<Pocket> onTap;

  const PocketLabelsLayer({super.key, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final camera = MapCamera.of(context);
    final selected = ref.watch(selectedPocketIdProvider);
    final scale = MediaQuery.textScalerOf(context).scale(1);
    final rankOf = {for (final r in ref.watch(rankedMissionsProvider)) r.mission.pocketId: r};
    final width = 64.0 * scale, height = (minTapTarget * scale).clamp(minTapTarget, 80.0);
    final ordered = [...ref.watch(loadedBundleProvider).pockets]
      ..sort((a, b) => (a.id == selected ? -1 : rankOf[a.id]!.rank).compareTo(b.id == selected ? -1 : rankOf[b.id]!.rank));

    final placed = <Rect>[];
    final markers = <Marker>[];
    for (final pocket in ordered) {
      final box = Rect.fromCenter(center: camera.latLngToScreenOffset(pocket.point), width: width, height: height);
      if (placed.any(box.overlaps)) continue;
      placed.add(box);
      final ranked = rankOf[pocket.id]!;
      final tone = modeTone(pocket.accessMode);
      final isSelected = pocket.id == selected;
      markers.add(
        Marker(
          key: ValueKey('area-pill-${pocket.id}'),
          point: pocket.point,
          width: width,
          height: height,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onTap(pocket),
            child: Semantics(
              button: true,
              label: l.areaMarkerLabel('${ranked.rank}', l.areaName(ranked, rankOf.values.toList()), modeWords(l, pocket.accessMode)),
              excludeSemantics: true,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: tone.tint,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isSelected ? AppColors.ink : tone.strong, width: isSelected ? 3 : 2),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(modeIcon(pocket.accessMode), size: 16, color: tone.text),
                      const SizedBox(width: 4),
                      Text('${ranked.rank}',
                          style: TextStyle(color: tone.text, fontSize: 14, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return MarkerLayer(markers: markers);
  }
}

/// Safest is solid teal, shortest dashed brown. Dashed goes on top so both show
/// where the two routes are the same. With a pocket selected, only its routes show.
class RoutesLayer extends ConsumerStatefulWidget {
  final ValueChanged<List<RouteLine>> onTap;

  const RoutesLayer({super.key, required this.onTap});

  @override
  ConsumerState<RoutesLayer> createState() => _RoutesLayerState();
}

class _RoutesLayerState extends ConsumerState<RoutesLayer> {
  final LayerHitNotifier<RouteLine> _hit = ValueNotifier(null);

  @override
  void dispose() {
    _hit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final opacity = ref.watch(mapOpacityProvider)[MapLayer.routes]!;
    final selected = ref.watch(selectedPocketIdProvider);
    final routes = ref.watch(loadedBundleProvider).routes.where((r) => selected == null || r.pocketId == selected);
    return GestureDetector(
      excludeFromSemantics: true,
      onTap: () {
        final hits = _hit.value?.hitValues;
        // Copied: the map library reuses this list for its next hit test.
        if (hits != null && hits.isNotEmpty) widget.onTap(List.of(hits));
      },
      child: PolylineLayer<RouteLine>(
        hitNotifier: _hit,
        polylines: [
          for (final type in const [RouteType.safest, RouteType.shortest])
            for (final route in routes.where((r) => r.routeType == type))
              Polyline<RouteLine>(
                points: route.points,
                hitValue: route,
                strokeWidth: type == RouteType.safest ? 5 : 2.5,
                color: (type == RouteType.safest ? AppColors.safestRoute : AppColors.shortestRoute).withValues(
                  alpha: opacity,
                ),
                pattern: type == RouteType.safest
                    ? const StrokePattern.solid()
                    : StrokePattern.dashed(segments: const [9, 6]),
              ),
        ],
      ),
    );
  }
}

class ServicesLayer extends ConsumerWidget {
  final ValueChanged<ServicePoint> onTap;

  /// Which kinds of place to show.
  final Set<ServiceType> types;

  const ServicesLayer({super.key, required this.onTap, required this.types});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final labelled = MapCamera.of(context).zoom >= serviceLabelMinZoom;
    final scale = MediaQuery.textScalerOf(context).scale(1);
    return MarkerLayer(
      markers: [
        for (final service in ref.watch(loadedBundleProvider).services)
          if (types.contains(service.type))
          Marker(
            point: service.point,
            width: labelled ? 120 * scale : minTapTarget,
            height: labelled ? minTapTarget + 26 * scale : minTapTarget,
            // The icon sits on the point, with its name below it.
            alignment: labelled ? const Alignment(0, 0.2) : Alignment.center,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onTap(service),
              child: Semantics(
                button: true,
                label: '${l.serviceType(service.type)}: ${l.serviceName(service)}',
                excludeSemantics: true,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ServiceIcon(service: service),
                    if (labelled)
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppColors.surface.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            l.serviceName(service),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: AppColors.ink, fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ServiceIcon extends StatelessWidget {
  final ServicePoint service;

  const _ServiceIcon({required this.service});

  @override
  Widget build(BuildContext context) => Container(
    width: 28,
    height: 28,
    decoration: BoxDecoration(
      color: AppColors.brand,
      shape: BoxShape.circle,
      border: Border.all(color: AppColors.surface, width: 1.5),
    ),
    child: Icon(serviceIcon(service.type), size: 16, color: AppColors.surface),
  );
}
