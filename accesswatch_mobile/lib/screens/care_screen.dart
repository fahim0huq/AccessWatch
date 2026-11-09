import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../state/care_state.dart';
import '../state/location.dart';
import '../theme/app_theme.dart';
import '../widgets/care/care_result.dart';
import '../widgets/care/clinic_list.dart';
import '../widgets/location_prompt.dart';
import '../widgets/ui/kit.dart';

/// Find care: where is the nearest clinic, and can a car, a truck or someone
/// on foot get there from here.
class CareScreen extends ConsumerStatefulWidget {
  const CareScreen({super.key});

  @override
  ConsumerState<CareScreen> createState() => _CareScreenState();
}

class _CareScreenState extends ConsumerState<CareScreen> with ShowsLocation {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final text = Theme.of(context).textTheme;
    final location = ref.watch(locationControllerProvider);
    final spot = ref.watch(mySpotProvider);
    final sample = ref.watch(sampleSpotProvider);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            ScreenTitle(title: l.findCareTitle, subtitle: l.findCareSubtitle),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.gutter),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (spot == null) ...[
                    Text(l.mySpotIntro, style: text.bodyMedium),
                    const SizedBox(height: 16),
                  ],
                  BigButton(
                    icon: Icons.my_location_rounded,
                    label: location.wanted && location.position == null ? l.mySpotWaiting : l.useMyLocation,
                    onPressed: () => requestLocation(context, ref),
                  ),
                  if (sample != null) ...[
                    const SizedBox(height: 12),
                    BigButton.secondary(
                      icon: Icons.place_rounded,
                      label: l.trySampleSpot,
                      onPressed: () => ref.read(locationControllerProvider.notifier).setSamplePosition(sample.point),
                    ),
                  ],
                  if (kDebugMode && spot == null) ...[
                    const SizedBox(height: 8),
                    Text(l.testPositionHint, style: text.bodySmall),
                  ],
                  const SizedBox(height: 16),
                  if (location.isSample)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: StatusChip(icon: Icons.info_rounded, label: l.sampleNotice, tone: Tone.notice),
                    ),
                  if (location.isTestPosition)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: StatusChip(icon: Icons.bug_report_rounded, label: l.testPositionBadge, tone: Tone.notice),
                    ),
                  if (spot != null && !spot.usable)
                    AppCard(
                      color: AppColors.noticeTint,
                      borderColor: AppColors.notice,
                      child: Text(l.spotOutside, style: text.bodyLarge!.copyWith(color: AppColors.noticeText)),
                    ),
                  if (spot?.usable ?? false) ...[
                    const CareResultCard(),
                    const SpotFactsCard(),
                  ],
                  const ClinicList(),
                  Text(l.appDisclaimer, style: text.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
