import 'package:flutter/material.dart';

import '../data/models/enums.dart';
import '../data/models/mission.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../utils/labels.dart';
import 'mission_card_header.dart';
import 'mission_card_sections.dart';
import 'mission_list_card.dart';

const _sectionStyle =
    TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'monospace');

/// Bottom sheet for one mission. Everything comes from the card's fields.
class MissionCardDetail extends StatelessWidget {
  final Mission mission;
  final ScrollController? scrollController;

  const MissionCardDetail({super.key, required this.mission, this.scrollController});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final fmt = Fmt.of(context);
    final m = mission;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const MissionCardHeader(),
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
                    MissionTag(text: '#${m.rank.toString().padLeft(2, '0')}', color: AppColors.accent),
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
                if (m.lostServices.isNotEmpty) ...[
                  Text(l.servicesLost, style: _sectionStyle),
                  const SizedBox(height: 8),
                  for (final s in m.lostServices)
                    _ServiceRow(
                      icon: Icons.close_rounded,
                      color: AppColors.highRisk,
                      text: s.previousMinutes == null
                          ? l.serviceLink(s.service)
                          : l.serviceWasMinutes(l.serviceLink(s.service), fmt.count(s.previousMinutes!)),
                    ),
                  const SizedBox(height: 12),
                ],
                if (m.limitedServices.isNotEmpty) ...[
                  Text(l.servicesLimited, style: _sectionStyle),
                  const SizedBox(height: 8),
                  for (final s in m.limitedServices)
                    _ServiceRow(icon: Icons.priority_high_rounded, color: AppColors.warning, text: l.serviceLink(s)),
                  const SizedBox(height: 12),
                ],
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
                const SizedBox(height: 16),
                if (m.verificationRequired) _VerifyNotice(text: l.verifyOnGround),
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

class _ServiceRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _ServiceRow({required this.icon, required this.color, required this.text});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Expanded(child: Text(text, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold))),
          ],
        ),
      );
}

class _VerifyNotice extends StatelessWidget {
  final String text;

  const _VerifyNotice({required this.text});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.warning.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(text, style: const TextStyle(color: AppColors.warning, fontSize: 11.5, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
}
