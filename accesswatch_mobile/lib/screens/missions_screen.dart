import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/models/enums.dart';
import '../l10n/app_localizations.dart';
import '../router.dart';
import '../state/mission_state.dart';
import '../theme/app_theme.dart';
import '../utils/labels.dart';
import '../widgets/ui/kit.dart';
import '../widgets/mission_list_card.dart';
import '../widgets/quality_banners.dart';
import '../widgets/ranking_panel.dart';

class MissionsScreen extends ConsumerStatefulWidget {
  const MissionsScreen({super.key});

  @override
  ConsumerState<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends ConsumerState<MissionsScreen> {
  /// null shows every access mode.
  AccessMode? _filter;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final ranked = ref.watch(rankedMissionsProvider);
    final modes = {for (final r in ranked) r.mission.accessMode};
    final shown = [
      for (final r in ranked)
        if (_filter == null || r.mission.accessMode == _filter) r,
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.responseMissions,
                            style: const TextStyle(
                                color: AppColors.accent,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                )),
                        const SizedBox(height: 2),
                        Text(l.rankedPockets(Fmt.of(context).count(shown.length)),
                            style: const TextStyle(color: AppColors.ink, fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const HelpButton(),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  _FilterChip(label: l.filterAll, selected: _filter == null, onTap: () => setState(() => _filter = null)),
                  // Only modes that exist in the data get a chip.
                  for (final mode in AccessMode.values)
                    if (modes.contains(mode))
                      _FilterChip(
                        label: l.accessMode(mode),
                        selected: _filter == mode,
                        onTap: () => setState(() => _filter = mode),
                      ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  const QualityBanners(padding: EdgeInsets.only(bottom: 8)),
                  const RankingPanel(),
                  for (final r in shown)
                    MissionListCard(
                      ranked: r,
                      onTap: () => context.go(AppRoutes.area(r.mission.pocketId)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (value) {
          if (value) onTap();
        },
        selectedColor: AppColors.accent,
        backgroundColor: AppColors.surface,
        labelStyle: TextStyle(
          color: selected ? AppColors.background : AppColors.text,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
        side: const BorderSide(color: AppColors.border),
      ),
    );
  }
}
