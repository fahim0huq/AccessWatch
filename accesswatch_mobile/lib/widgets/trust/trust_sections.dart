// Sections of the Data and trust screen. Everything comes from quality.json and the manifest.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/quality.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import '../../theme/app_theme.dart';
import '../../utils/labels.dart';
import '../../utils/trust_text.dart';
import '../area/area_sections.dart' show CardTitle;
import '../ui/kit.dart';

/// The doi.org address of a DOI, the standard resolver for DOIs.
String doiUrl(String doi) => 'https://doi.org/${doi.trim()}';

const trustBody = TextStyle(color: AppColors.ink, fontSize: 16, height: 1.45);
const trustMuted = TextStyle(color: AppColors.inkSecondary, fontSize: 14, height: 1.4);

class TrustCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Color? accent;

  const TrustCard({super.key, required this.title, required this.children, this.accent});

  @override
  Widget build(BuildContext context) => AppCard(
        borderColor: accent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [CardTitle(title), ...children],
        ),
      );
}

class Bullet extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;

  const Bullet(this.text, {super.key, this.icon = Icons.circle, this.color = AppColors.inkSecondary});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: const EdgeInsets.only(top: 3), child: Icon(icon, size: icon == Icons.circle ? 8 : 18, color: color)),
            const SizedBox(width: 8),
            Expanded(child: Text(text, style: trustBody)),
          ],
        ),
      );
}

/// Data problems the bundle records about itself. Shown in full, never hidden.
class KnownIssuesSection extends ConsumerWidget {
  const KnownIssuesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final issues = l.knownIssues(ref.watch(loadedBundleProvider).quality, Fmt.of(context));
    return TrustCard(
      title: l.knownIssuesTitle,
      accent: AppColors.boat,
      children: [
        if (issues.isEmpty) Text(l.knownIssuesNone, style: trustBody),
        for (final issue in issues) Bullet(issue, icon: Icons.report_problem_outlined, color: AppColors.boatText),
      ],
    );
  }
}

/// How well the flood map agrees with EMS, and why that is not an independent check.
class ValidationSection extends ConsumerWidget {
  const ValidationSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final fmt = Fmt.of(context);
    final bundle = ref.watch(loadedBundleProvider);
    final q = bundle.quality;
    final v = q.floodVsReference;
    final dates = bundle.manifest.dates;
    Widget row(String label, String value) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            children: [
              Expanded(child: Text(label, style: trustMuted)),
              Text(value, style: const TextStyle(color: AppColors.ink, fontSize: 12.5)),
            ],
          ),
        );
    return TrustCard(
      title: l.validationTitle,
      children: [
        Bullet(l.calibrationNote(bundle.manifest, q, fmt), icon: Icons.warning_amber_rounded, color: AppColors.boatText),
        Bullet(l.compareEmsDate(fmt.date(dates.emsImage), fmt.oneDecimal(dates.emsHoursAfterNisar)),
            icon: Icons.schedule_rounded, color: AppColors.inkSecondary),
        const SizedBox(height: 4),
        row(l.scoreIou, fmt.score(v.iou)),
        row(l.scoreF1, fmt.score(v.f1)),
        row(l.scorePrecision, fmt.score(v.precision)),
        row(l.scoreRecall, fmt.score(v.recall)),
        row(l.scoreCrossValidation, fmt.score(q.classifierCvIou)),
        row(l.scorePhysicsOnly, fmt.score(q.thresholdMapIou)),
        row(l.scoreStablePockets, '${fmt.percent(q.stablePocketShare)}%'),
        const SizedBox(height: 4),
        Text(l.validationReference(bundle.quality.ems.layer), style: trustMuted),
      ],
    );
  }
}

class LimitsSection extends ConsumerWidget {
  const LimitsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final quality = ref.watch(loadedBundleProvider).quality;
    return TrustCard(
      title: l.limitsTitle,
      children: [
        for (final limit in limitsOf(quality)) Bullet(l.limitText(limit, quality, Fmt.of(context))),
        Bullet(l.limitRouteTimes),
        Bullet(l.populationIsModelled),
      ],
    );
  }
}

/// Sources from DATA_SOURCES. A link appears only when the data holds one.
class SourcesSection extends ConsumerWidget {
  const SourcesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    return TrustCard(
      title: l.dataSources,
      children: [
        for (final source in ref.watch(loadedBundleProvider).quality.dataSources) _Source(source: source),
        const SizedBox(height: 4),
        Text(l.notAffiliated, style: trustMuted),
      ],
    );
  }
}

class _Source extends StatelessWidget {
  final DataSource source;

  const _Source({required this.source});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    Widget link(String label, String url) => TextButton.icon(
          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(48, 48), alignment: Alignment.centerLeft),
          onPressed: () => launchUrl(Uri.parse(url)),
          icon: const Icon(Icons.open_in_new_rounded, size: 15),
          label: Text(label, style: const TextStyle(fontSize: 14)),
        );
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(source.name, style: trustBody.copyWith(fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 12,
            children: [
              if (source.url != null) link(l.sourceWebsite, source.url!),
              if (source.docs != null) link(l.sourceDocs, source.docs!),
              // A DOI resolves through doi.org; the identifier itself comes from the data.
              if (source.doi != null) link(l.sourceDoi(source.doi!), doiUrl(source.doi!)),
            ],
          ),
          if (source.licence != null) Text(l.sourceLicence(source.licence!), style: trustMuted),
        ],
      ),
    );
  }
}
