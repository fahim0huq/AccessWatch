import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/mission_ranking.dart';
import '../data/models/enums.dart';
import '../data/verify_notes.dart';
import '../l10n/app_localizations.dart';
import '../router.dart';
import '../state/mission_state.dart';
import '../state/providers.dart';
import '../state/route_view.dart';
import '../theme/app_theme.dart';
import '../utils/labels.dart';
import '../widgets/area/area_sections.dart';
import '../widgets/mission_detail_sections.dart' show showAlertDialog;
import '../widgets/ui/kit.dart';

/// The ranked area for [pocketId], or null when the link names no area.
RankedMission? rankedArea(WidgetRef ref, String pocketId) {
  for (final r in ref.watch(rankedMissionsProvider)) {
    if (r.mission.pocketId == pocketId) return r;
  }
  return null;
}

String sureWord(AppLocalizations l, Confidence c) => switch (c) {
      Confidence.high => l.sureHigh,
      Confidence.medium => l.sureMedium,
      Confidence.low => l.sureLow,
    };

/// One area: how to reach it, what it lost, the safest route, and what to do.
class AreaScreen extends ConsumerWidget {
  final String pocketId;

  const AreaScreen({super.key, required this.pocketId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final fmt = Fmt.of(context);
    final text = Theme.of(context).textTheme;
    final ranked = rankedArea(ref, pocketId);
    void back() => context.canPop() ? context.pop() : context.go(AppRoutes.help);
    final total = ref.watch(rankedMissionsProvider).length;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: back),
        title: Text(ranked == null ? '' : l.areaXofN(fmt.count(ranked.rank), fmt.count(total))),
      ),
      body: ranked == null
          ? Center(child: TextButton(onPressed: back, child: Text(l.missionNotFound(pocketId))))
          : ListView(
              padding: const EdgeInsets.fromLTRB(AppSizes.gutter, 4, AppSizes.gutter, 32),
              children: [
                Semantics(header: true, child: Text(l.areaName(ranked, ref.watch(rankedMissionsProvider)), style: text.headlineMedium)),
                const SizedBox(height: 4),
                Text(l.populationEstimate(fmt.count(ranked.mission.population)),
                    style: text.bodyLarge!.copyWith(color: AppColors.inkSecondary)),
                const SizedBox(height: 16),
                ModeCard(mission: ranked.mission),
                WaterDepthCard(mission: ranked.mission),
                LostServicesCard(mission: ranked.mission),
                SafestRouteCard(mission: ranked.mission),
                const SizedBox(height: 4),
                BigButton(
                  icon: Icons.share_rounded,
                  label: l.shareAlert,
                  onPressed: () => showAlertDialog(context, ref, ranked),
                ),
                const SizedBox(height: 12),
                BigButton.secondary(
                  icon: Icons.map_rounded,
                  label: l.viewOnMap,
                  onPressed: () {
                    ref.read(selectedRouteProvider.notifier).state = null;
                    ref.read(selectedPocketIdProvider.notifier).state = pocketId;
                    context.go(AppRoutes.map);
                    ref.read(routesPanelRequestProvider.notifier).state = pocketId;
                  },
                ),
                const SizedBox(height: 16),
                AppCard(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Column(
                    children: [
                      NavRow(
                        icon: Icons.fact_check_rounded,
                        title: l.checkOnGround(fmt.count(verifyNotesFor(ranked.mission).length)),
                        onTap: () => context.push(AppRoutes.areaChecks(pocketId)),
                      ),
                      const Divider(),
                      NavRow(
                        icon: Icons.insights_rounded,
                        title: l.howSure(sureWord(l, ranked.mission.confidence)),
                        onTap: () => context.push(AppRoutes.areaSure(pocketId)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
