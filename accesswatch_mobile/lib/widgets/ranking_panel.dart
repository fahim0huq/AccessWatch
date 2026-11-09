import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mission_ranking.dart';
import '../data/models/enums.dart';
import '../l10n/app_localizations.dart';
import '../state/mission_state.dart';
import '../state/providers.dart';
import '../theme/app_theme.dart';
import '../utils/labels.dart';

/// Above this share of all pocket people, one pocket holds "almost all" of them.
const dominantPocketShare = 0.8;

const _noteStyle = TextStyle(color: AppColors.textMuted, fontSize: 11.5, height: 1.35);

/// Sliders that re-rank the list live, a reset, and what the result can and
/// cannot tell you. The notes stay visible when the sliders are folded away.
class RankingPanel extends ConsumerStatefulWidget {
  const RankingPanel({super.key});

  @override
  ConsumerState<RankingPanel> createState() => _RankingPanelState();
}

class _RankingPanelState extends ConsumerState<RankingPanel> {
  bool _open = true;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final fmt = Fmt.of(context);
    final weights = ref.watch(priorityWeightsProvider);
    final setWeights = ref.read(priorityWeightsProvider.notifier);
    final bundle = ref.watch(loadedBundleProvider);
    final largest = largestPocket(bundle.missions);
    final dominated = largest != null && largest.$2 >= dominantPocketShare;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(14, 6, 14, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(l.rankingTitle,
                    style: const TextStyle(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
              IconButton(
                tooltip: _open ? l.rankingHide : l.rankingShow,
                onPressed: () => setState(() => _open = !_open),
                icon: Icon(_open ? Icons.expand_less_rounded : Icons.tune_rounded, color: AppColors.accent),
              ),
            ],
          ),
          if (_open) ...[
            _WeightSlider(
              label: l.weightPeople,
              value: weights.people,
              onChanged: (v) => setWeights.state = PriorityWeights(people: v, serviceLoss: weights.serviceLoss, difficulty: weights.difficulty),
            ),
            _WeightSlider(
              label: l.weightServiceLoss,
              value: weights.serviceLoss,
              onChanged: (v) => setWeights.state = PriorityWeights(people: weights.people, serviceLoss: v, difficulty: weights.difficulty),
            ),
            _WeightSlider(
              label: l.weightDifficulty,
              value: weights.difficulty,
              onChanged: (v) => setWeights.state = PriorityWeights(people: weights.people, serviceLoss: weights.serviceLoss, difficulty: v),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: weights.isPublished ? null : () => setWeights.state = const PriorityWeights(),
                icon: const Icon(Icons.restart_alt_rounded, size: 18),
                label: Text(l.rankingReset),
              ),
            ),
          ],
          Text(l.rankingChoiceNote, style: _noteStyle.copyWith(color: AppColors.text, fontWeight: FontWeight.bold)),
          if (dominated) ...[
            const SizedBox(height: 4),
            Text(l.rankingDominated(largest.$1.pocketId, fmt.percent(largest.$2)), style: _noteStyle),
          ],
          if (hasTiedTerms(bundle.missions)) ...[
            const SizedBox(height: 4),
            Text(l.rankingTies, style: _noteStyle),
          ],
          if (bundle.manifest.qualityFlags.contains(QualityFlag.depotAutoSelected)) ...[
            const SizedBox(height: 4),
            Text(l.rankingDepotNote, style: _noteStyle.copyWith(color: AppColors.warning)),
          ] else if (bundle.manifest.qualityFlags.contains(QualityFlag.depotAssumed)) ...[
            const SizedBox(height: 4),
            Text(l.rankingDepotAssumedNote, style: _noteStyle.copyWith(color: AppColors.warning)),
          ],
        ],
      ),
    );
  }
}

class _WeightSlider extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  const _WeightSlider({required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final shown = Fmt.of(context).score(value);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: const TextStyle(color: AppColors.text, fontSize: 12.5))),
            Text('× $shown', style: const TextStyle(color: AppColors.accent, fontSize: 12)),
          ],
        ),
        Slider(
          value: value,
          min: PriorityWeights.min,
          max: PriorityWeights.max,
          divisions: 8,
          label: shown,
          semanticFormatterCallback: (_) => '$label: $shown',
          activeColor: AppColors.accent,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
