import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../state/care_state.dart';
import '../../state/location.dart';
import '../../state/providers.dart';
import '../../theme/app_theme.dart';
import '../../utils/labels.dart';
import '../location_prompt.dart';
import 'care_common.dart';

/// What the data says about the user's position.
class MySpotCard extends ConsumerWidget {
  const MySpotCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final fmt = Fmt.of(context);
    final location = ref.watch(locationControllerProvider);
    final spot = ref.watch(mySpotProvider);
    final limits = ref.watch(loadedBundleProvider).manifest.depthClasses;
    return CareCard(
      title: l.mySpotTitle,
      children: [
        if (location.isTestPosition)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            color: AppColors.warning,
            child: Text(l.testPositionBadge,
                style: const TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.w900)),
          ),
        if (spot == null) ...[
          Text(l.mySpotIntro, style: careBodyStyle),
          const SizedBox(height: 10),
          FilledButton.icon(
            onPressed: () => requestLocation(context, ref),
            icon: const Icon(Icons.my_location_rounded),
            label: Text(location.wanted ? l.mySpotWaiting : l.useMyLocation),
          ),
          if (kDebugMode) ...[
            const SizedBox(height: 8),
            Text(l.testPositionHint, style: careMutedStyle),
          ],
        ] else if (!spot.usable)
          CareFact(icon: Icons.wrong_location_rounded, color: AppColors.warning, text: l.spotOutside)
        else ...[
          CareFact(
            icon: spot.inFlood ? Icons.water_rounded : Icons.landscape_rounded,
            color: spot.inFlood ? AppColors.highRisk : AppColors.safestRoute,
            text: spot.inFlood ? l.spotInFlood : l.spotNotInFlood,
          ),
          if (spot.depthClass != null)
            CareFact(
              icon: Icons.straighten_rounded,
              color: AppColors.floodMedium,
              text: l.spotDepth(l.depthClass(spot.depthClass!), l.depthRange(spot.depthClass!, limits, fmt) ?? ''),
            ),
          if (spot.nearestFloodedRoadMetres != null)
            CareFact(
              icon: Icons.add_road_rounded,
              color: AppColors.floodMedium,
              text: l.spotFloodedRoad(fmt.count(spot.nearestFloodedRoadMetres!.round())),
            ),
          CareFact(
            icon: Icons.place_rounded,
            color: AppColors.textMuted,
            text: l.spotSnapped(fmt.count(spot.snapMetres!.round())),
          ),
          const _NearestClinic(),
          const SizedBox(height: 4),
          Text(l.depthEstimateWarning, style: careMutedStyle),
        ],
      ],
    );
  }
}

class _NearestClinic extends ConsumerWidget {
  const _NearestClinic();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final fmt = Fmt.of(context);
    return ref.watch(careRoutesProvider).when(
          loading: () => const Padding(padding: EdgeInsets.all(6), child: LinearProgressIndicator()),
          error: (_, _) => Text(l.routingFailed, style: careMutedStyle),
          data: (routes) {
            if (routes == null) return const SizedBox.shrink();
            if (routes.needsBoat(null)) return NeedsBoatNotice(text: l.needsBoatAny);
            // The shortest road route over all modes.
            final best = [
              for (final mode in routes.byMode.keys)
                if (routes.forMode(mode, null) case final r?) (mode, r),
            ]..sort((a, b) => a.$2.route.lengthM.compareTo(b.$2.route.lengthM));
            final (mode, route) = best.first;
            if (route.route.isAtTarget) {
              return CareFact(
                icon: Icons.local_hospital_rounded,
                color: AppColors.safestRoute,
                text: l.alreadyAtClinic(l.serviceName(route.clinic)),
              );
            }
            return CareFact(
              icon: Icons.local_hospital_rounded,
              color: AppColors.safestRoute,
              text: l.spotNearestClinic(
                  l.serviceName(route.clinic), careModeLabel(l, mode), fmt.km(route.route.lengthM / 1000)),
            );
          },
        );
  }
}
