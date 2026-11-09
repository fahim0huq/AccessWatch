// Depth-class card and route comparison table of the mission sheet.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/enums.dart';
import '../data/models/mission.dart';
import '../l10n/app_localizations.dart';
import '../state/providers.dart';
import '../theme/app_theme.dart';
import '../utils/labels.dart';

const _mono = TextStyle(fontWeight: FontWeight.bold);
const _section = TextStyle(color: AppColors.ink, fontSize: 18, fontWeight: FontWeight.w700);

Color depthColor(DepthClass depth) => switch (depth) {
      DepthClass.deep => AppColors.floodDeep,
      DepthClass.medium => AppColors.floodMedium,
      DepthClass.shallow => AppColors.floodShallow,
      DepthClass.dry || DepthClass.unknown => AppColors.textMuted,
    };

/// Depth is shown as a class with its definition, never as exact metres.
class MissionCardDepthSection extends ConsumerWidget {
  final DepthClass depth;

  const MissionCardDepthSection({super.key, required this.depth});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final range = l.depthRange(depth, ref.watch(loadedBundleProvider).manifest.depthClasses, Fmt.of(context));
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: depthColor(depth), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.estimatedMaxDepth, style: _section.copyWith(fontSize: 14)),
          const SizedBox(height: 8),
          Text(l.depthClass(depth), style: _mono.copyWith(color: AppColors.ink, fontSize: 26)),
          if (range != null) Text(range, style: _mono.copyWith(color: AppColors.textMuted, fontSize: 14)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, size: 16, color: AppColors.warning),
              const SizedBox(width: 6),
              Expanded(
                child: Text(l.depthEstimateWarning,
                    style: const TextStyle(color: AppColors.warning, fontSize: 14, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MissionCardRouteTable extends StatelessWidget {
  final Mission mission;

  const MissionCardRouteTable({super.key, required this.mission});

  Widget _row(String label, String shortest, String safest) => Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 14))),
            Expanded(child: Text(shortest, style: _mono.copyWith(color: AppColors.ink, fontSize: 14))),
            Expanded(child: Text(safest, style: _mono.copyWith(color: AppColors.safestRoute, fontSize: 14))),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final fmt = Fmt.of(context);
    final s = mission.shortest;
    final f = mission.safest;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.routeComparison, style: _section),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: Text(l.metric, style: _section.copyWith(fontSize: 14))),
                  Expanded(child: Text(l.shortest, style: _section.copyWith(fontSize: 14, color: AppColors.text))),
                  Expanded(child: Text(l.safestStar, style: _section.copyWith(fontSize: 14, color: AppColors.safestRoute))),
                ],
              ),
              const Divider(color: AppColors.border, height: 12),
              _row(l.distance, l.distanceKm(fmt.km(s.distanceKm)), l.distanceKm(fmt.km(f.distanceKm))),
              _row(l.eta, l.durationMin(fmt.minutes(s.timeMin)), l.durationMin(fmt.minutes(f.timeMin))),
              _row(l.depthLevel, l.depthClass(s.maxDepthClass), l.depthClass(f.maxDepthClass)),
              _row(l.accessRisk, l.riskLevel(s.riskLevel), l.riskLevel(f.riskLevel)),
              _row(l.uncertainBridges, fmt.count(s.uncertainBridges), fmt.count(f.uncertainBridges)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(s.sameAs(f) ? l.routesSame : l.routesDiffer,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 14, fontStyle: FontStyle.italic)),
        ),
      ],
    );
  }
}
