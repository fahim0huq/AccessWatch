import 'package:flutter/material.dart';

import '../data/mission_ranking.dart';
import '../data/models/enums.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../utils/labels.dart';

/// Small coloured label. The text carries the meaning, not the colour.
class MissionTag extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;

  const MissionTag({super.key, required this.text, required this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 13, color: color), const SizedBox(width: 4)],
          Flexible(child: Text(text, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}

IconData accessIcon(AccessMode mode) => switch (mode) {
      AccessMode.boat => Icons.directions_boat,
      AccessMode.highClearanceTruck => Icons.local_shipping,
      AccessMode.onFoot => Icons.directions_walk,
      AccessMode.normalVehicle => Icons.directions_car,
    };

Color statusColor(PocketStatus status) => status == PocketStatus.cutOff ? AppColors.highRisk : AppColors.warning;

class MissionListCard extends StatelessWidget {
  final RankedMission ranked;
  final VoidCallback onTap;

  const MissionListCard({super.key, required this.ranked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final m = ranked.mission;
    final services = m.accessStatus == PocketStatus.cutOff
        ? l.lostServices(l.serviceList(m.lostServices.map((s) => s.service)))
        : l.limitedServices(l.serviceList(m.limitedServices));
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.surface,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  MissionTag(text: '#${ranked.rank.toString().padLeft(2, '0')}', color: AppColors.accent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(l.missionTitle(m),
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  Text(m.pocketId,
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 11, fontFamily: 'monospace')),
                  const SizedBox(width: 6),
                  Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted.withValues(alpha: 0.6)),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(l.populationEstimate(Fmt.of(context).count(m.population)),
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 12, fontFamily: 'monospace')),
                  MissionTag(text: l.pocketStatus(m.accessStatus), color: statusColor(m.accessStatus)),
                  MissionTag(text: l.accessMode(m.accessMode), color: AppColors.accent, icon: accessIcon(m.accessMode)),
                ],
              ),
              if (ranked.rank != m.rank) ...[
                const SizedBox(height: 6),
                Text(l.publishedRank(Fmt.of(context).count(m.rank)),
                    style: const TextStyle(color: AppColors.accent, fontSize: 11)),
              ],
              const SizedBox(height: 8),
              Text(services, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }
}
