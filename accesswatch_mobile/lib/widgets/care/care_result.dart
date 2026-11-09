// The answer of Find care: the nearest clinic, and whether a car, a
// high-clearance truck or someone on foot can get there.
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
import '../area/area_sections.dart' show CardTitle;
import '../ui/kit.dart';
import 'care_common.dart';
import 'route_cards.dart';

String careRowLabel(AppLocalizations l, CareMode mode) => switch (mode) {
      CareMode.car => l.byCar,
      CareMode.truck => l.byTruck,
      CareMode.foot => l.byFoot,
    };

/// Sends a route to the Map tab, drawn along the roads.
void showCareRouteOnMap(BuildContext context, WidgetRef ref, CareMode mode, ClinicRoute r) {
  final g = ref.read(loadedBundleProvider).graph;
  final points = [for (final n in r.route.nodes) LatLng(g.lat[n], g.lon[n])];
  ref.read(careRouteOnMapProvider.notifier).state = CareRouteOnMap(points, r, mode);
  context.go(AppRoutes.map);
}

class CareResultCard extends ConsumerWidget {
  const CareResultCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final text = Theme.of(context).textTheme;
    final targetId = ref.watch(targetClinicIdProvider);
    final target = targetId == null ? null : ref.watch(loadedBundleProvider).clinics.firstWhere((c) => c.id == targetId);
    return ref.watch(careRoutesProvider).when(
          loading: () => const AppCard(child: LinearProgressIndicator()),
          error: (_, _) => AppCard(child: Text(l.routingFailed)),
          data: (routes) {
            if (routes == null) return const SizedBox.shrink();
            final byMode = {for (final mode in CareMode.values) mode: routes.forMode(mode, targetId)};
            // The shortest road route over all modes names the clinic.
            final reachable = [
              for (final e in byMode.entries)
                if (e.value != null) (e.key, e.value!),
            ]..sort((a, b) => a.$2.route.lengthM.compareTo(b.$2.route.lengthM));
            final best = reachable.isEmpty ? null : reachable.first;
            final clinic = target ?? best?.$2.clinic;
            final atClinic = best != null && best.$2.route.isAtTarget;
            return AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (routes.needsBoat(targetId))
                    NeedsBoatNotice(text: target == null ? l.needsBoatAny : l.needsBoatClinic(l.serviceName(target))),
                  if (clinic != null) ...[
                    Text(target == null ? l.nearestClinicLabel : l.chosenClinicLabel, style: text.bodySmall),
                    Text(l.serviceName(clinic), style: text.titleLarge),
                    if (target != null)
                      TextButton(
                        onPressed: () => ref.read(targetClinicIdProvider.notifier).state = null,
                        child: Text(l.targetUseNearest),
                      ),
                    const SizedBox(height: 8),
                  ],
                  if (atClinic)
                    CareFact(
                      icon: Icons.local_hospital_rounded,
                      color: AppColors.reach,
                      text: l.alreadyAtClinic(l.serviceName(best.$2.clinic)),
                    )
                  else ...[
                    for (final mode in CareMode.values) _ModeRow(mode: mode, route: byMode[mode], headline: clinic?.id),
                    const SizedBox(height: 8),
                    Text(l.routeBy, style: text.bodySmall),
                    const SizedBox(height: 4),
                    SegmentedButton<RouteCriterion>(
                      segments: [
                        ButtonSegment(value: RouteCriterion.fastest, label: Text(l.criterionFastest), icon: const Icon(Icons.speed_rounded)),
                        ButtonSegment(value: RouteCriterion.safest, label: Text(l.criterionSafest), icon: const Icon(Icons.shield_outlined)),
                      ],
                      selected: {ref.watch(routeCriterionProvider)},
                      onSelectionChanged: (s) => ref.read(routeCriterionProvider.notifier).state = s.first,
                    ),
                    if (best != null) ...[
                      const SizedBox(height: 12),
                      for (final warning in routeWarnings(l, Fmt.of(context), best.$1, best.$2.route))
                        Padding(padding: const EdgeInsets.only(bottom: 2), child: Text('• $warning', style: text.bodySmall)),
                      const SizedBox(height: 12),
                      BigButton(
                        icon: Icons.map_rounded,
                        label: l.showRouteOnMapLong,
                        onPressed: () => showCareRouteOnMap(context, ref, best.$1, best.$2),
                      ),
                    ],
                  ],
                ],
              ),
            );
          },
        );
  }
}

/// By car / High-clearance truck / On foot: can it reach, how far, how long.
class _ModeRow extends StatelessWidget {
  final CareMode mode;
  final ClinicRoute? route;
  final String? headline;

  const _ModeRow({required this.mode, required this.route, required this.headline});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final text = Theme.of(context).textTheme;
    final r = route;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(careModeIcon(mode), color: AppColors.ink),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(careRowLabel(l, mode), style: text.titleSmall),
                const SizedBox(height: 4),
                r == null
                    ? StatusChip(icon: Icons.block_rounded, label: l.noRoadRoute, tone: Tone.danger)
                    : StatusChip(icon: Icons.check_circle_rounded, label: l.canReach, tone: Tone.reach),
                if (r != null) ...[
                  const SizedBox(height: 4),
                  // Walking time is not modelled: distance only on foot.
                  Text(routeSummary(l, Fmt.of(context), mode, r.route), style: text.bodyMedium),
                  if (r.clinic.id != headline) Text(l.toClinic(l.serviceName(r.clinic)), style: text.bodySmall),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// What the data says about the spot itself.
class SpotFactsCard extends ConsumerWidget {
  const SpotFactsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final fmt = Fmt.of(context);
    final spot = ref.watch(mySpotProvider);
    if (spot == null || !spot.usable) return const SizedBox.shrink();
    final limits = ref.watch(loadedBundleProvider).manifest.depthClasses;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardTitle(l.aboutThisSpot),
          CareFact(
            icon: spot.inFlood ? Icons.water_rounded : Icons.landscape_rounded,
            color: spot.inFlood ? AppColors.danger : AppColors.reach,
            text: spot.inFlood ? l.spotInFlood : l.spotNotInFlood,
          ),
          if (spot.depthClass != null)
            CareFact(
              icon: Icons.straighten_rounded,
              color: AppColors.flood,
              text: l.spotDepth(l.depthClass(spot.depthClass!), l.depthRange(spot.depthClass!, limits, fmt) ?? ''),
            ),
          if (spot.nearestFloodedRoadMetres != null)
            CareFact(
              icon: Icons.add_road_rounded,
              color: AppColors.flood,
              text: l.spotFloodedRoad(fmt.count(spot.nearestFloodedRoadMetres!.round())),
            ),
          CareFact(icon: Icons.place_rounded, color: AppColors.inkSecondary, text: l.spotSnapped(fmt.count(spot.snapMetres!.round()))),
          const SizedBox(height: 4),
          Text(l.depthEstimateWarning, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
