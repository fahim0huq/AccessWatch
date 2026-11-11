import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/models/enums.dart';
import '../l10n/app_localizations.dart';
import '../router.dart';
import '../state/providers.dart';
import '../theme/app_theme.dart';
import '../utils/labels.dart';
import '../widgets/ui/kit.dart';

/// About this data: the honest summary first, then one row per topic, then
/// language, text size and the safety line.
class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  static const _english = Locale('en');
  static const _portuguese = Locale('pt');
  static const _textSizes = [1.0, 1.25, 1.5];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final fmt = Fmt.of(context);
    final text = Theme.of(context).textTheme;
    final flags = ref.watch(loadedBundleProvider).manifest.qualityFlags;
    // Every true flag, in a fixed order, in plain words.
    final active = [for (final flag in QualityFlag.values) if (flags.contains(flag)) flag];
    final locale = ref.watch(localeProvider);
    final scale = ref.watch(textScaleProvider);
    Widget row(IconData icon, String title, String route, {String? subtitle}) =>
        NavRow(icon: icon, title: title, subtitle: subtitle, onTap: () => context.push(route));
    return Scaffold(
      backgroundColor: Colors.transparent,
      // A tab of its own: nothing to go back to.
      appBar: AppBar(automaticallyImplyLeading: false, title: Text(l.aboutThisData)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSizes.gutter, 4, AppSizes.gutter, 32),
        children: [
          AppCard(
            color: AppColors.cautionTint,
            borderColor: AppColors.boat,
            borderWidth: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_rounded, color: AppColors.boatText),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(active.isEmpty ? l.aboutGuideOnly : l.aboutPreliminary,
                          style: text.titleMedium!.copyWith(color: AppColors.boatText)),
                    ),
                  ],
                ),
                for (final flag in active)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 3),
                          child: Icon(Icons.warning_amber_rounded, size: 18, color: AppColors.boatText),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: Text(l.warningPlain(flag), style: text.bodyMedium!.copyWith(color: AppColors.ink))),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Column(
              children: [
                row(Icons.satellite_alt_rounded, l.aboutFloodMapRow, AppRoutes.aboutFloodMap),
                const Divider(),
                row(Icons.compare_rounded, l.aboutMatchRow, AppRoutes.aboutMatch),
                const Divider(),
                row(Icons.report_problem_outlined, l.aboutLimitsRow, AppRoutes.aboutLimits),
                const Divider(),
                row(Icons.menu_book_rounded, l.aboutSourcesRow, AppRoutes.aboutSources),
                const Divider(),
                row(Icons.history_rounded, l.aboutAgeRow, AppRoutes.aboutAge),
                const Divider(),
                row(Icons.tune_rounded, l.aboutAdvancedRow, AppRoutes.aboutAdvanced, subtitle: l.aboutAdvancedSubtitle),
              ],
            ),
          ),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.aboutLanguage, style: text.titleSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final (option, name) in [(_english, l.languageEnglish), (_portuguese, l.languagePortuguese)])
                      ChoiceChip(
                        label: Text(name),
                        selected: locale.languageCode == option.languageCode,
                        onSelected: (_) => ref.read(localeProvider.notifier).state = option,
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(l.aboutTextSize, style: text.titleSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final size in _textSizes)
                      ChoiceChip(
                        label: Text(l.textSizeOption(fmt.minutes(size * 100))),
                        selected: (scale - size).abs() < 0.01,
                        onSelected: (_) => ref.read(textScaleProvider.notifier).state = size,
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          OutlinedButton.icon(
            onPressed: () => context.push(AppRoutes.welcome),
            icon: const Icon(Icons.health_and_safety_rounded),
            label: Text(l.readIntroAgain),
          ),
          const SizedBox(height: 20),
          Text(l.aboutSafetyLine, style: text.bodyLarge!.copyWith(color: AppColors.dangerText, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
