// The two pages one tap deeper than an area: the ground checklist, and how
// sure the analysis is (with the technical detail behind it).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/enums.dart';
import '../l10n/app_localizations.dart';
import '../state/mission_state.dart';
import '../theme/app_theme.dart';
import '../utils/labels.dart';
import '../widgets/area/area_sections.dart';
import '../widgets/mission_card_sections.dart';
import '../widgets/mission_detail_sections.dart';
import '../widgets/ui/kit.dart';
import 'area_screen.dart';

class _DetailPage extends ConsumerWidget {
  final String pocketId;
  final String title;
  final List<Widget> Function(BuildContext, WidgetRef) children;

  const _DetailPage({required this.pocketId, required this.title, required this.children});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ranked = rankedArea(ref, pocketId);
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSizes.gutter, 4, AppSizes.gutter, 32),
        children: ranked == null
            ? [Text(l.missionNotFound(pocketId))]
            : [
                Text(l.areaName(ranked, ref.watch(rankedMissionsProvider)), style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                ...children(context, ref),
              ],
      ),
    );
  }
}

class AreaChecksScreen extends StatelessWidget {
  final String pocketId;

  const AreaChecksScreen({super.key, required this.pocketId});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return _DetailPage(
      pocketId: pocketId,
      title: l.checkOnGroundTitle,
      children: (context, ref) => [
        Text(l.checkOnGroundIntro, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        AppCard(child: VerifyChecklist(mission: rankedArea(ref, pocketId)!.mission)),
      ],
    );
  }
}

class AreaSureScreen extends StatelessWidget {
  final String pocketId;

  const AreaSureScreen({super.key, required this.pocketId});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return _DetailPage(
      pocketId: pocketId,
      title: l.howSureTitle,
      children: (context, ref) {
        final fmt = Fmt.of(context);
        final text = Theme.of(context).textTheme;
        final m = rankedArea(ref, pocketId)!.mission;
        return [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatusChip(
                  icon: m.confidence == Confidence.high ? Icons.verified_rounded : Icons.help_outline_rounded,
                  label: l.howSureConfidence(sureWord(l, m.confidence)),
                  tone: m.confidence == Confidence.high ? Tone.reach : Tone.notice,
                ),
                const SizedBox(height: 10),
                Text(l.stabilityLabel(fmt.percent(m.stability)), style: text.bodyMedium),
                Text(l.worstCaseMode(l.accessMode(m.worstCaseMode)), style: text.bodyMedium),
              ],
            ),
          ),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [CardTitle(l.whyFlagged), Text(l.whyFlaggedText(m))],
            ),
          ),
          AppCard(child: ServiceAccessSection(mission: m)),
          MissionCardDepthSection(depth: m.maxDepthClass),
          const SizedBox(height: 12),
          AppCard(child: MissionCardRouteTable(mission: m)),
          AppCard(child: PriorityTermsSection(mission: m)),
        ];
      },
    );
  }
}
