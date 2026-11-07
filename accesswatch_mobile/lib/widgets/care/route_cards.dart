import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart' show LatLng;

import '../../data/routing.dart';
import '../../l10n/app_localizations.dart';
import '../../router.dart';
import '../../state/care_state.dart';
import '../../state/providers.dart';
import '../../theme/app_theme.dart';
import '../../utils/labels.dart';
import 'care_common.dart';

/// Warnings for a route, shared by the cards and the map panel.
List<String> routeWarnings(AppLocalizations l, Fmt fmt, CareMode mode, GraphRoute r) => [
      if (r.shallowM > 0 || r.mediumM > 0)
        l.routeWater(fmt.count(r.shallowM.round()), fmt.count(r.mediumM.round())),
      if (r.uncertainBridges > 0) l.routeBridges(r.uncertainBridges),
      mode == CareMode.foot ? l.routeNoWalkingTime : l.routeTimeRounded,
    ];

String routeSummary(AppLocalizations l, Fmt fmt, CareMode mode, GraphRoute r) => mode == CareMode.foot
    ? l.distanceKm(fmt.km(r.lengthM / 1000))
    : l.routeDistanceTime(fmt.km(r.lengthM / 1000), fmt.minutes(r.timeMin));

/// Route from the user's spot to a clinic, one card per mode.
class RouteCards extends ConsumerWidget {
  const RouteCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final criterion = ref.watch(routeCriterionProvider);
    final targetId = ref.watch(targetClinicIdProvider);
    final target = targetId == null ? null : ref.watch(loadedBundleProvider).clinics.firstWhere((c) => c.id == targetId);
    return CareCard(
      title: l.routesToClinic,
      children: [
        SegmentedButton<RouteCriterion>(
          segments: [
            ButtonSegment(value: RouteCriterion.fastest, label: Text(l.criterionFastest), icon: const Icon(Icons.speed_rounded)),
            ButtonSegment(value: RouteCriterion.safest, label: Text(l.criterionSafest), icon: const Icon(Icons.shield_outlined)),
          ],
          selected: {criterion},
          onSelectionChanged: (s) => ref.read(routeCriterionProvider.notifier).state = s.first,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Text(target == null ? l.targetNearest : l.targetChosen(l.serviceName(target)), style: careBodyStyle),
            ),
            if (target != null)
              TextButton(
                onPressed: () => ref.read(targetClinicIdProvider.notifier).state = null,
                child: Text(l.targetUseNearest),
              ),
          ],
        ),
        const SizedBox(height: 6),
        ref.watch(careRoutesProvider).when(
              loading: () => const LinearProgressIndicator(),
              error: (_, _) => Text(l.routingFailed, style: careMutedStyle),
              data: (routes) {
                if (routes == null) return const SizedBox.shrink();
                return Column(
                  children: [
                    if (routes.needsBoat(targetId))
                      NeedsBoatNotice(text: target == null ? l.needsBoatAny : l.needsBoatClinic(l.serviceName(target))),
                    for (final mode in CareMode.values) _ModeCard(mode: mode, route: routes.forMode(mode, targetId)),
                  ],
                );
              },
            ),
      ],
    );
  }
}

class _ModeCard extends ConsumerWidget {
  final CareMode mode;
  final ClinicRoute? route;

  const _ModeCard({required this.mode, required this.route});

  void _showOnMap(BuildContext context, WidgetRef ref, ClinicRoute r) {
    final g = ref.read(loadedBundleProvider).graph;
    final points = [for (final n in r.route.nodes) LatLng(g.lat[n], g.lon[n])];
    ref.read(careRouteOnMapProvider.notifier).state = CareRouteOnMap(points, r, mode);
    context.go(AppRoutes.map);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final fmt = Fmt.of(context);
    final r = route;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(careModeIcon(mode), color: AppColors.accent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(careModeLabel(l, mode),
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (r == null)
            Text(l.noRouteForMode(careModeLabel(l, mode)), style: careMutedStyle)
          else ...[
            Text(l.serviceName(r.clinic), style: careBodyStyle.copyWith(fontWeight: FontWeight.bold)),
            Text(routeSummary(l, fmt, mode, r.route), style: careBodyStyle),
            for (final warning in routeWarnings(l, fmt, mode, r.route)) Text('• $warning', style: careMutedStyle),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _showOnMap(context, ref, r),
                icon: const Icon(Icons.map_rounded, size: 18),
                label: Text(l.showRouteOnMap),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
