// What floats on the Map tab: the name pill, legend chips, buttons, the summary
// card and the small sheet for a tapped area.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../router.dart';
import '../../state/mission_state.dart';
import '../../state/providers.dart';
import '../../state/tour_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/labels.dart';
import '../ui/kit.dart';
import '../ui/mode_look.dart';
import 'layers_sheet.dart';
import 'layer_chips.dart';
import 'routes_panel.dart';
import 'watching_pill.dart';

/// A round 48 dp map button with a tooltip that names it.
class MapRoundButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const MapRoundButton({super.key, required this.icon, required this.tooltip, required this.onPressed});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: IconButton.filled(
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.ink,
        side: const BorderSide(color: AppColors.line),
        minimumSize: const Size(AppSizes.tap, AppSizes.tap),
      ),
      icon: Icon(icon),
    ),
  );
}

/// Text-size cap for the name pill and legend chips on top of the map.
const mapOverlayMaxTextScale = 1.5;

/// Across the top: the Watching pill and the layer chips. The chips replace
/// the legend: each one shows the colour the map draws for it.
class MapTopBar extends StatelessWidget {
  const MapTopBar({super.key});

  @override
  Widget build(BuildContext context) => MediaQuery.withClampedTextScaling(
    // The pill and chips repeat words shown full size elsewhere;
    // capped so that at very large text the map stays visible.
    maxScaleFactor: mapOverlayMaxTextScale,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: WatchingPill(key: TourTargets.watchingPill),
        ),
        const SizedBox(height: 4),
        LayerChipRow(key: TourTargets.chipRow),
      ],
    ),
  );
}

/// The column on the right: Full screen, Layers, My location. Zoom, Fit and
/// the scale bar are in full screen; pinch and double-tap still zoom here.
class MapSideButtons extends StatelessWidget {
  final VoidCallback onLocate, onFullScreen;

  const MapSideButtons({super.key, required this.onLocate, required this.onFullScreen});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MapRoundButton(
          key: const ValueKey('enter-full-screen'),
          icon: Icons.fullscreen_rounded,
          tooltip: l.fullScreen,
          onPressed: onFullScreen,
        ),
        MapRoundButton(
          icon: Icons.layers_rounded,
          tooltip: l.layersButton,
          onPressed: () => showLayersSheet(
            context,
            onRoutes: () {
              Navigator.pop(context);
              showRoutesPanel(context);
            },
          ),
        ),
        MapRoundButton(icon: Icons.my_location_rounded, tooltip: l.tooltipLocate, onPressed: onLocate),
      ],
    );
  }
}

/// The one-glance answer under the map: how many areas, how many people, and
/// where to go next. Every number comes from the bundle.
class MapSummaryCard extends ConsumerWidget {
  const MapSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final fmt = Fmt.of(context);
    final text = Theme.of(context).textTheme;
    final bundle = ref.watch(loadedBundleProvider);
    final stats = bundle.manifest.stats;
    final places = {for (final m in bundle.missions) m.nearestPlace}.toList()..sort();
    final preliminary = bundle.manifest.qualityFlags.isNotEmpty;
    final date = fmt.date(bundle.manifest.dates.nisarAfter);
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.cardRadius)),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: Offset(0, -2))],
      ),
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.42),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(AppSizes.gutter, 18, AppSizes.gutter, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l.mapAreasCutOff(stats.pockets), style: text.headlineSmall),
            const SizedBox(height: 4),
            Text(
              l.mapPeopleNear(fmt.count(roundForDisplay(stats.populationEstimate)), l.placeList(places)),
              style: text.bodyLarge!.copyWith(color: AppColors.inkSecondary),
            ),
            const SizedBox(height: 14),
            BigButton(
              icon: Icons.volunteer_activism_rounded,
              label: l.seeWhoNeedsHelp,
              onPressed: () => context.go(AppRoutes.help),
            ),
            const SizedBox(height: 4),
            InkWell(
              onTap: () => context.go(AppRoutes.about),
              borderRadius: BorderRadius.circular(AppSizes.chipRadius),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: AppSizes.tap),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(color: AppColors.boat, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(preliminary ? l.mapPreliminary(date) : l.mapSnapshot(date), style: text.bodySmall),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A tapped area: name, people, how to reach it, and Open.
void showAreaSheet(BuildContext context, WidgetRef ref, String pocketId) {
  final ranked = ref.read(rankedMissionsProvider).firstWhere((r) => r.mission.pocketId == pocketId);
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) {
      final l = AppLocalizations.of(sheetContext)!;
      final text = Theme.of(sheetContext).textTheme;
      final m = ranked.mission;
      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(AppSizes.gutter, 0, AppSizes.gutter, AppSizes.gutter),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  RankCircle(rank: ranked.rank, tone: modeTone(m.accessMode)),
                  const SizedBox(width: 12),
                  Expanded(child: Text(l.areaName(ranked, ref.read(rankedMissionsProvider)), style: text.titleLarge)),
                ],
              ),
              const SizedBox(height: 8),
              Text(l.populationEstimate(Fmt.of(sheetContext).count(m.population)), style: text.bodyLarge),
              const SizedBox(height: 10),
              ModeChip(mode: m.accessMode),
              const SizedBox(height: 16),
              BigButton(
                icon: Icons.arrow_forward_rounded,
                label: l.openArea,
                onPressed: () {
                  Navigator.pop(sheetContext);
                  context.go(AppRoutes.area(m.pocketId));
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
