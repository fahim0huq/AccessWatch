// The pages behind the rows of About this data. Each keeps the content the old
// Info screen had for that topic, read from the bundle.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../state/map_state.dart';
import '../state/providers.dart';
import '../theme/app_theme.dart';
import '../utils/labels.dart';
import '../utils/trust_text.dart';
import '../widgets/data_status.dart';
import '../widgets/map/layer_panel.dart';
import '../widgets/map/map_legend.dart';
import '../widgets/quality_banners.dart';
import '../widgets/ranking_panel.dart';
import '../widgets/trust/trust_sections.dart';

class _AboutPage extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _AboutPage({required this.title, required this.children});

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.transparent,
        appBar: AppBar(title: Text(title)),
        body: ListView(padding: const EdgeInsets.fromLTRB(AppSizes.gutter, 4, AppSizes.gutter, 32), children: children),
      );
}

class AboutFloodMapPage extends ConsumerWidget {
  const AboutFloodMapPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final fmt = Fmt.of(context);
    final bundle = ref.watch(loadedBundleProvider);
    final dates = bundle.manifest.dates;
    return _AboutPage(title: l.aboutFloodMapRow, children: [
      TrustCard(title: l.aboutFloodMapRow, children: [
        Text(l.floodMapIntro, style: trustBody),
        const SizedBox(height: 8),
        Text(l.introBody2, style: trustBody),
        const SizedBox(height: 8),
        Text(l.calibrationNote(bundle.manifest, bundle.quality, fmt), style: trustMuted),
      ]),
      TrustCard(title: l.dataDates, children: [
        Text(l.dateNisarBefore(fmt.date(dates.nisarBefore)), style: trustBody),
        Text(l.dateNisarAfter(fmt.date(dates.nisarAfter)), style: trustBody),
        Text(l.dateEmsImage(fmt.date(dates.emsImage)), style: trustBody),
        Text(l.dateEmsGap(fmt.oneDecimal(dates.emsHoursAfterNisar)), style: trustMuted),
      ]),
      TrustCard(title: l.colorsTitle, children: const [MapLegend(width: double.infinity)]),
    ]);
  }
}

class AboutMatchPage extends StatelessWidget {
  const AboutMatchPage({super.key});

  @override
  Widget build(BuildContext context) => _AboutPage(
        title: AppLocalizations.of(context)!.aboutMatchRow,
        children: const [ValidationSection(), CompareLegend()],
      );
}

class AboutLimitsPage extends StatelessWidget {
  const AboutLimitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return _AboutPage(title: l.aboutLimitsRow, children: [
      TrustCard(title: l.warningsTitle, children: const [QualityBanners(startExpanded: true)]),
      const KnownIssuesSection(),
      const LimitsSection(),
    ]);
  }
}

class AboutSourcesPage extends StatelessWidget {
  const AboutSourcesPage({super.key});

  @override
  Widget build(BuildContext context) =>
      _AboutPage(title: AppLocalizations.of(context)!.aboutSourcesRow, children: const [SourcesSection()]);
}

class AboutAgePage extends ConsumerWidget {
  const AboutAgePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final fmt = Fmt.of(context);
    final manifest = ref.watch(loadedBundleProvider).manifest;
    final generated = DateTime.tryParse(manifest.dates.notebookGenerated);
    return _AboutPage(title: l.aboutAgeRow, children: [
      TrustCard(title: l.aboutAgeRow, children: [
        const DataAgeNote(),
        const SizedBox(height: 10),
        Text(l.dateNisarAfter(fmt.date(manifest.dates.nisarAfter)), style: trustBody),
        // The run time has no zone in the data, so only its calendar date is shown.
        if (generated != null)
          Text(l.dataGenerated(fmt.date(DateTime.utc(generated.year, generated.month, generated.day))), style: trustBody),
        const SizedBox(height: 10),
        Text(l.updateInfo, style: trustBody),
        const SizedBox(height: 10),
        Text(l.offlineWorks, style: trustMuted),
      ]),
    ]);
  }
}

class AboutAdvancedPage extends ConsumerWidget {
  const AboutAdvancedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final text = Theme.of(context).textTheme;
    final compare = ref.watch(mapLayersProvider).contains(MapLayer.compare);
    return _AboutPage(title: l.aboutAdvancedRow, children: [
      const RankingPanel(),
      TrustCard(title: l.layersControl, children: [
        Text(l.advancedMapNote, style: text.bodySmall),
        const LayerControls(),
      ]),
      if (compare) const CompareLegend(),
      TrustCard(title: l.settingsTitle, children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l.presentationMode, style: text.bodyLarge),
          subtitle: Text(l.presentationModeSubtitle, style: text.bodySmall),
          value: ref.watch(presentationModeProvider),
          onChanged: (value) => ref.read(presentationModeProvider.notifier).state = value,
        ),
      ]),
    ]);
  }
}
