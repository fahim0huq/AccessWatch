import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/mission_ranking.dart';
import '../../l10n/app_localizations.dart';
import '../../state/mission_state.dart';
import '../../state/providers.dart';
import '../../theme/app_theme.dart';
import '../../utils/labels.dart';

/// Ranked pockets under the map. Choosing one focuses it and shows only its
/// routes; ALL shows every route again.
class MapBottomPanel extends ConsumerWidget {
  final ValueChanged<String> onOpenPocket;

  const MapBottomPanel({super.key, required this.onOpenPocket});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final ranked = ref.watch(rankedMissionsProvider);
    final selected = ref.watch(selectedPocketIdProvider);
    final scale = MediaQuery.textScalerOf(context).scale(1);
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.rankedPocketsTitle,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
          const SizedBox(height: 6),
          SizedBox(
            height: 58 * scale,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _Chip(
                  width: 60 * scale,
                  selected: selected == null,
                  onTap: () => ref.read(selectedPocketIdProvider.notifier).state = null,
                  child: Center(child: Text(l.allPockets, style: _strong)),
                ),
                for (final r in ranked)
                  _Chip(
                    width: 150 * scale,
                    selected: r.mission.pocketId == selected,
                    onTap: () {
                      if (r.mission.pocketId == selected) {
                        onOpenPocket(r.mission.pocketId);
                      } else {
                        ref.read(selectedPocketIdProvider.notifier).state = r.mission.pocketId;
                      }
                    },
                    child: _MissionChip(ranked: r),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const _strong = TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'monospace');

class _MissionChip extends StatelessWidget {
  final RankedMission ranked;

  const _MissionChip({required this.ranked});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final mission = ranked.mission;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('#${ranked.rank.toString().padLeft(2, '0')} ${mission.pocketId}',
            maxLines: 1, overflow: TextOverflow.ellipsis, style: _strong),
        Text(l.missionTitle(mission),
            maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 11)),
        Text(l.accessMode(mission.accessMode),
            maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.warning, fontSize: 9, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final double width;
  final bool selected;
  final VoidCallback onTap;
  final Widget child;

  const _Chip({required this.width, required this.selected, required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Material(
          color: selected ? AppColors.accent.withValues(alpha: 0.15) : AppColors.background,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onTap,
            child: Container(
              width: width,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: selected ? AppColors.accent : AppColors.border, width: selected ? 1.5 : 1),
              ),
              child: child,
            ),
          ),
        ),
      );
}
