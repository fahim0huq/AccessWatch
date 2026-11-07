// Pockets, routes, services and my location. These are the layers people tap.
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart' show LatLng;

import '../../data/models/enums.dart';
import '../../data/models/pocket.dart';
import '../../data/models/route_line.dart';
import '../../data/models/service_point.dart';
import '../../l10n/app_localizations.dart';
import '../../state/map_state.dart';
import '../../state/providers.dart';
import '../../theme/app_theme.dart';
import '../../utils/labels.dart';
import 'flood_layers.dart' show mapPolygon;

/// Service names appear from this zoom; below it they would pile on top of each other.
const serviceLabelMinZoom = 15.0;

Color riskColor(RiskLevel level) => switch (level) {
      RiskLevel.high => AppColors.highRisk,
      RiskLevel.medium => AppColors.warning,
      RiskLevel.low => const Color(0xFFFDE047),
    };

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
                riskColor(pocket.riskLevel).withValues(alpha: opacity),
                border: pocket.id == selected ? AppColors.accent : riskColor(pocket.riskLevel),
                width: pocket.id == selected ? 3 : 1.5,
                hit: pocket,
              ),
        ],
      ),
    );
  }
}

/// "P01 · HIGH" labels. Text carries the risk, so colour is not the only signal.
/// Labels that would cover a higher-ranked one wait until the map is zoomed in.
class PocketLabelsLayer extends ConsumerWidget {
  final ValueChanged<Pocket> onTap;

  const PocketLabelsLayer({super.key, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final camera = MapCamera.of(context);
    final selected = ref.watch(selectedPocketIdProvider);
    final scale = MediaQuery.textScalerOf(context).scale(1);
    final width = 92.0 * scale, height = 26.0 * scale;
    final ordered = [...ref.watch(loadedBundleProvider).pockets]
      ..sort((a, b) => (a.id == selected ? -1 : a.rank).compareTo(b.id == selected ? -1 : b.rank));

    final placed = <Rect>[];
    final markers = <Marker>[];
    for (final pocket in ordered) {
      final box = Rect.fromCenter(center: camera.latLngToScreenOffset(pocket.point), width: width, height: height);
      if (placed.any(box.overlaps)) continue;
      placed.add(box);
      markers.add(Marker(
        point: pocket.point,
        width: width,
        height: height,
        child: GestureDetector(
          onTap: () => onTap(pocket),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: pocket.id == selected ? AppColors.accent : riskColor(pocket.riskLevel),
                width: pocket.id == selected ? 2 : 1,
              ),
            ),
            child: Text(
              '${pocket.id} · ${l.riskLevel(pocket.riskLevel)}',
              maxLines: 1,
              overflow: TextOverflow.fade,
              softWrap: false,
              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
            ),
          ),
        ),
      ));
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
                color: (type == RouteType.safest ? AppColors.safestRoute : AppColors.shortestRoute)
                    .withValues(alpha: opacity),
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

  const ServicesLayer({super.key, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final labelled = MapCamera.of(context).zoom >= serviceLabelMinZoom;
    final scale = MediaQuery.textScalerOf(context).scale(1);
    return MarkerLayer(markers: [
      for (final service in ref.watch(loadedBundleProvider).services)
        Marker(
          point: service.point,
          width: labelled ? 120 * scale : 40,
          height: labelled ? 40 + 26 * scale : 40,
          // The icon sits on the point, with its name below it.
          alignment: labelled ? const Alignment(0, 0.2) : Alignment.center,
          child: GestureDetector(
            onTap: () => onTap(service),
            child: Semantics(
              button: true,
              label: l.serviceName(service),
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
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
    ]);
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
          color: AppColors.surface,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        child: Icon(serviceIcon(service.type), size: 16, color: Colors.white),
      );
}

class MyLocationLayer extends StatelessWidget {
  final LatLng position;
  final bool isTest;

  const MyLocationLayer({super.key, required this.position, this.isTest = false});

  @override
  Widget build(BuildContext context) => MarkerLayer(markers: [
        Marker(
          point: position,
          width: 28,
          height: 28,
          child: Semantics(
            label: isTest ? AppLocalizations.of(context)!.testPositionBadge : AppLocalizations.of(context)!.legendMe,
            child: Container(
              decoration: BoxDecoration(
                color: isTest ? AppColors.warning : AppColors.accentSecondary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: const Icon(Icons.navigation_rounded, size: 12, color: Colors.white),
            ),
          ),
        ),
      ]);
}
