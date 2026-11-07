import 'package:flutter/material.dart';

import '../data/models/manifest.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../utils/labels.dart';

/// Home KPIs, all from `manifest.stats`.
class KpiGrid extends StatelessWidget {
  final BundleStats stats;

  const KpiGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final fmt = Fmt.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _Kpi(
            icon: Icons.warning_amber_rounded,
            color: AppColors.highRisk,
            title: l.kpiPockets(fmt.count(stats.pockets)),
            subtitle: l.kpiPocketsSub,
          ),
          const Divider(color: AppColors.border, height: 16),
          _Kpi(
            icon: Icons.groups_rounded,
            color: AppColors.accent,
            title: fmt.count(stats.populationEstimate),
            subtitle: l.kpiPeopleSub,
          ),
          const Divider(color: AppColors.border, height: 16),
          _Kpi(
            icon: Icons.water_rounded,
            color: AppColors.info,
            title: l.floodAreaKm2(fmt.oneDecimal(stats.floodAreaKm2)),
            subtitle: l.kpiFloodSub,
          ),
          const Divider(color: AppColors.border, height: 16),
          _Kpi(
            icon: Icons.water_drop_rounded,
            color: AppColors.floodMedium,
            title: [
              l.depthCount(fmt.count(stats.floodedShallow), l.depthShallow),
              l.depthCount(fmt.count(stats.floodedMedium), l.depthMedium),
              l.depthCount(fmt.count(stats.floodedDeep), l.depthDeep),
            ].join(' · '),
            subtitle: l.kpiDepthSub,
          ),
        ],
      ),
    );
  }
}

class _Kpi extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title, subtitle;

  const _Kpi({required this.icon, required this.color, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: AppColors.text, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
              Text(subtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
            ],
          ),
        ),
      ],
    );
  }
}
