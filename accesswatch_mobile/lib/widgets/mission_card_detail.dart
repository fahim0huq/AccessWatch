import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/enums.dart';
import '../data/models/mission.dart';
import '../l10n/app_localizations.dart';
import '../state/mission_state.dart';
import '../theme/app_theme.dart';
import '../utils/labels.dart';
import 'mission_card_header.dart';
import 'mission_card_sections.dart';
import 'mission_detail_sections.dart';
import 'mission_list_card.dart';

const _sectionStyle =
    TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'monospace');

/// A mission's full detail: the Missions page and the Map's bottom sheet both
/// show this. Everything comes from the card's fields.
class MissionCardDetail extends ConsumerWidget {
  final Mission mission;
  final ScrollController? scrollController;
  final VoidCallback? onViewOnMap;

  /// Replaces closing the sheet, on the full page.
  final VoidCallback? onBack;

  const MissionCardDetail({super.key, required this.mission, this.scrollController, this.onViewOnMap, this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final fmt = Fmt.of(context);
    final m = mission;
    final ranked = ref.watch(rankedMissionsProvider).firstWhere((r) => r.mission.pocketId == m.pocketId);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: onBack != null ? null : const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          MissionCardHeader(
            onViewOnMap: onViewOnMap,
            onBack: onBack,
            onShare: () => showAlertDialog(context, ref, ranked),
          ),
          const Divider(color: AppColors.border, height: 1),
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    MissionTag(text: '#${ranked.rank.toString().padLeft(2, '0')}', color: AppColors.accent),
                    MissionTag(text: m.pocketId, color: AppColors.textMuted),
                    MissionTag(text: l.pocketStatus(m.accessStatus), color: statusColor(m.accessStatus)),
                    MissionTag(text: l.accessMode(m.accessMode), color: AppColors.accent, icon: accessIcon(m.accessMode)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(l.missionTitle(m).toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                const SizedBox(height: 16),
                _Panel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.estimatedPopulation, style: _sectionStyle.copyWith(fontSize: 10)),
                      const SizedBox(height: 4),
                      Text(fmt.count(m.population),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900, fontFamily: 'monospace')),
                      const SizedBox(height: 4),
                      Text(l.populationIsModelled, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ServiceAccessSection(mission: m),
                const SizedBox(height: 12),
                Text(l.whyFlagged, style: _sectionStyle),
                const SizedBox(height: 6),
                Text(l.whyFlaggedText(m), style: const TextStyle(color: AppColors.text, fontSize: 13, height: 1.4)),
                if (m.boatLegKm > 0) ...[
                  const SizedBox(height: 6),
                  Text(l.boatLegKm(fmt.km(m.boatLegKm)),
                      style: const TextStyle(color: AppColors.accent, fontSize: 12, fontFamily: 'monospace')),
                ],
                const SizedBox(height: 20),
                MissionCardDepthSection(depth: m.maxDepthClass),
                const SizedBox(height: 20),
                MissionCardRouteTable(mission: m),
                const SizedBox(height: 20),
                VerifyChecklist(mission: m),
                const SizedBox(height: 16),
                PriorityTermsSection(mission: m),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: Text(l.analysisConfidence, style: _sectionStyle)),
                    Text(l.confidence(m.confidence),
                        style: TextStyle(
                            color: m.confidence == Confidence.high ? AppColors.accent : AppColors.warning,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace')),
                  ],
                ),
                const SizedBox(height: 6),
                Text(l.stabilityLabel(fmt.percent(m.stability)),
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                const SizedBox(height: 2),
                Text(l.worstCaseMode(l.accessMode(m.worstCaseMode)),
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  final Widget child;

  const _Panel({required this.child});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: child,
      );
}
