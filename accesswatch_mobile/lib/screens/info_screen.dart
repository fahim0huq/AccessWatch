import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import '../router.dart';
import '../state/providers.dart';
import '../theme/app_theme.dart';
import '../utils/labels.dart';
import '../widgets/beta_badge.dart';
import '../widgets/data_status.dart';
import '../widgets/map/map_legend.dart';
import '../widgets/quality_banners.dart';
import '../widgets/settings_card.dart';
import '../widgets/trust/trust_sections.dart';

/// Data and trust: what the data is, how far to trust it, and what is known to be wrong.
class InfoScreen extends ConsumerWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final fmt = Fmt.of(context);
    final bundle = ref.watch(loadedBundleProvider);
    final dates = bundle.manifest.dates;
    return Scaffold(
      appBar: AppBar(title: Text(l.aboutThisData)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(l.trustTitle,
                      style: const TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                const BetaBadge(),
              ],
            ),
            const SizedBox(height: 12),
            Text(l.eventName(bundle.manifest.event),
                style: const TextStyle(color: AppColors.ink, fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Text(l.appSubtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
            const SizedBox(height: 16),
            TrustCard(
              title: l.dataDates,
              children: [
                Text(l.dateNisarBefore(fmt.date(dates.nisarBefore)), style: trustBody),
                Text(l.dateNisarAfter(fmt.date(dates.nisarAfter)), style: trustBody),
                Text(l.dateEmsImage(fmt.date(dates.emsImage)), style: trustBody),
                Text(l.dateEmsGap(fmt.oneDecimal(dates.emsHoursAfterNisar)), style: trustMuted),
                const SizedBox(height: 8),
                const DataAgeNote(),
                const SizedBox(height: 4),
                Text(l.offlineWorks, style: trustMuted),
              ],
            ),
            Text(l.warningsTitle,
                style: const TextStyle(color: AppColors.warning, fontSize: 11, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const QualityBanners(startExpanded: true),
            const SizedBox(height: 10),
            const KnownIssuesSection(),
            const ValidationSection(),
            const LimitsSection(),
            TrustCard(
              title: l.colorsTitle,
              children: const [MapLegend(width: double.infinity), SizedBox(height: 10), CompareLegend()],
            ),
            const SourcesSection(),
            const SettingsCard(),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => context.push(AppRoutes.welcome),
              icon: const Icon(Icons.menu_book_rounded),
              label: Text(l.readIntroAgain),
            ),
            const SizedBox(height: 16),
            Text(l.appDisclaimer, style: trustBody.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(l.safetyEmergency, style: trustBody.copyWith(color: AppColors.highRisk, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
