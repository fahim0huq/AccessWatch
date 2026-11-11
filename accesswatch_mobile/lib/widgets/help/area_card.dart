import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/mission_ranking.dart';
import '../../l10n/app_localizations.dart';
import '../../state/mission_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/labels.dart';
import '../ui/kit.dart';
import '../ui/look.dart';
import '../ui/mode_look.dart';

/// One area in Help first. The most urgent one is [emphasised]: a coloured
/// border, bigger type and its own Open button. The others are compact rows.
class AreaCard extends ConsumerWidget {
  final RankedMission ranked;
  final bool emphasised;
  final VoidCallback onOpen;

  const AreaCard({super.key, required this.ranked, required this.onOpen, this.emphasised = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final text = Theme.of(context).textTheme;
    final m = ranked.mission;
    final tone = modeTone(m.accessMode);
    final people = l.populationEstimate(Fmt.of(context).count(m.population));
    final name = l.areaName(ranked, ref.watch(rankedMissionsProvider));
    final header = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RankCircle(rank: ranked.rank, tone: tone, size: emphasised ? 48 : 40),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: emphasised ? text.titleLarge : text.titleMedium),
              const SizedBox(height: 2),
              Text(people, style: text.bodyMedium!.copyWith(color: AppColors.inkSecondary)),
              const SizedBox(height: 8),
              ModeChip(mode: m.accessMode),
            ],
          ),
        ),
        if (!emphasised) const Icon(Icons.chevron_right_rounded, color: AppColors.inkSecondary),
      ],
    );
    final label = l.areaCardLabel('${ranked.rank}', name, people, modeWords(l, m.accessMode));
    if (emphasised) {
      // White words on the violet gradient; the mode chip keeps its pastel tint and dark words.
      return Semantics(
        button: true,
        label: label,
        child: HeroCard(
          onTap: onOpen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeroRank(rank: ranked.rank),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: text.titleLarge!.copyWith(color: onHero)),
                        const SizedBox(height: 2),
                        Text(people, style: text.bodyMedium!.copyWith(color: onHero)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ModeChip(mode: m.accessMode),
              const SizedBox(height: 16),
              BigButton.light(icon: Icons.arrow_forward_rounded, label: l.openArea, onPressed: onOpen),
            ],
          ),
        ),
      );
    }
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: AppCard(onTap: onOpen, child: header),
    );
  }
}
