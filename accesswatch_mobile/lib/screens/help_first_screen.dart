import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/models/enums.dart';
import '../l10n/app_localizations.dart';
import '../router.dart';
import '../state/mission_state.dart';
import '../theme/app_theme.dart';
import '../utils/labels.dart';
import '../widgets/help/area_card.dart';
import '../widgets/ui/kit.dart';
import '../widgets/ui/mode_look.dart';

/// Help first: every area, most urgent first, in the order the app ranks them
/// (the published ranking, or the user's weights from About > Advanced).
class HelpFirstScreen extends ConsumerStatefulWidget {
  const HelpFirstScreen({super.key});

  @override
  ConsumerState<HelpFirstScreen> createState() => _HelpFirstScreenState();
}

class _HelpFirstScreenState extends ConsumerState<HelpFirstScreen> {
  /// null shows every access mode.
  AccessMode? _filter;

  String _chipLabel(AppLocalizations l, AccessMode mode, String count) => switch (mode) {
        AccessMode.boat => l.filterBoatCount(count),
        AccessMode.highClearanceTruck => l.filterTruckCount(count),
        AccessMode.normalVehicle => l.filterCarCount(count),
        AccessMode.onFoot => l.filterFootCount(count),
      };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final fmt = Fmt.of(context);
    final ranked = ref.watch(rankedMissionsProvider);
    final custom = !ref.watch(priorityWeightsProvider).isPublished;
    final counts = <AccessMode, int>{};
    for (final r in ranked) {
      counts[r.mission.accessMode] = (counts[r.mission.accessMode] ?? 0) + 1;
    }
    final shown = [
      for (final r in ranked)
        if (_filter == null || r.mission.accessMode == _filter) r,
    ];

    Widget chip(String label, AccessMode? mode, {IconData? icon}) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: FilterChip(
            label: Text(label),
            avatar: icon == null ? null : Icon(icon, size: 18, color: AppColors.ink),
            selected: _filter == mode,
            showCheckmark: icon == null,
            onSelected: (_) => setState(() => _filter = mode),
          ),
        );

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            ScreenTitle(title: l.helpTitle, subtitle: l.helpSubtitle(ranked.length)),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.gutter, vertical: 4),
              child: Row(
                children: [
                  chip(l.filterAllCount(fmt.count(ranked.length)), null),
                  // Only modes that exist in the data get a chip.
                  for (final mode in AccessMode.values)
                    if (counts[mode] != null) chip(_chipLabel(l, mode, fmt.count(counts[mode]!)), mode, icon: modeIcon(mode)),
                ],
              ),
            ),
            if (custom)
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSizes.gutter, 8, AppSizes.gutter, 0),
                child: StatusChip(icon: Icons.tune_rounded, label: l.customWeightsNote, tone: Tone.notice),
              ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.gutter),
              child: Column(
                children: [
                  if (shown.isEmpty) Text(l.noAreasForFilter),
                  for (final r in shown)
                    AreaCard(
                      ranked: r,
                      emphasised: r.rank == 1,
                      onOpen: () => context.go(AppRoutes.area(r.mission.pocketId)),
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
