import 'package:flutter/material.dart';

import '../../data/mission_ranking.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../utils/labels.dart';
import '../ui/kit.dart';
import '../ui/mode_look.dart';

/// One area in Help first. The most urgent one is [emphasised]: a coloured
/// border, bigger type and its own Open button. The others are compact rows.
class AreaCard extends StatelessWidget {
  final RankedMission ranked;
  final bool emphasised;
  final VoidCallback onOpen;

  const AreaCard({super.key, required this.ranked, required this.onOpen, this.emphasised = false});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final text = Theme.of(context).textTheme;
    final m = ranked.mission;
    final tone = modeTone(m.accessMode);
    final people = l.populationEstimate(Fmt.of(context).count(m.population));
    final name = l.missionTitle(m);
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
    return Semantics(
      button: true,
      label: l.areaCardLabel('${ranked.rank}', name, people, modeWords(l, m.accessMode)),
      excludeSemantics: !emphasised,
      child: AppCard(
        onTap: onOpen,
        borderColor: emphasised ? tone.strong : null,
        borderWidth: emphasised ? 2.5 : 1,
        child: emphasised
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  header,
                  const SizedBox(height: 16),
                  BigButton(icon: Icons.arrow_forward_rounded, label: l.openArea, onPressed: onOpen),
                ],
              )
            : header,
      ),
    );
  }
}
