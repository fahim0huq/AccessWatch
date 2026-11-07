import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/enums.dart';
import '../data/models/mission.dart';
import '../l10n/app_localizations.dart';
import '../state/providers.dart';
import '../theme/app_theme.dart';
import '../utils/labels.dart';
import '../widgets/beta_badge.dart';
import '../widgets/mission_card_detail.dart';
import '../widgets/mission_list_card.dart';
import '../widgets/quality_banners.dart';

class MissionsScreen extends ConsumerStatefulWidget {
  const MissionsScreen({super.key});

  @override
  ConsumerState<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends ConsumerState<MissionsScreen> {
  /// null shows every access mode.
  AccessMode? _filter;

  void _openDetail(Mission mission) {
    ref.read(selectedPocketIdProvider.notifier).state = mission.pocketId;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        builder: (context, scrollController) =>
            MissionCardDetail(mission: mission, scrollController: scrollController),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final missions = ref.watch(loadedBundleProvider).missions;
    final modes = {for (final m in missions) m.accessMode};
    final shown = [
      for (final m in missions)
        if (_filter == null || m.accessMode == _filter) m,
    ]..sort((a, b) => a.rank.compareTo(b.rank));

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
                                fontFamily: 'monospace')),
                        const SizedBox(height: 2),
                        Text(l.rankedPockets(Fmt.of(context).count(shown.length)),
                            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const BetaBadge(),
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
                  for (final m in shown) MissionListCard(mission: m, onTap: () => _openDetail(m)),
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
          fontFamily: 'monospace',
        ),
        side: const BorderSide(color: AppColors.border),
      ),
    );
  }
}
