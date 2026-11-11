// Full-screen map: only floating controls, a small legend pill, and a small
// card for a tapped area.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/enums.dart';
import '../../l10n/app_localizations.dart';
import '../../router.dart';
import '../../state/map_state.dart';
import '../../state/mission_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/labels.dart';
import '../ui/kit.dart';
import '../ui/mode_look.dart';
import 'layers_sheet.dart';
import 'map_overlay.dart';
import 'routes_panel.dart';

/// The area tapped in full screen, shown in the small bottom card.
final fullScreenAreaProvider = StateProvider<String?>((ref) => null);

void setMapFullScreen(WidgetRef ref, bool on) {
  ref.read(fullScreenAreaProvider.notifier).state = null;
  ref.read(mapFullScreenProvider.notifier).state = on;
}

/// Flooded, Boat, Vehicle in one small pill.
class MapLegendPill extends StatelessWidget {
  const MapLegendPill({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final style = Theme.of(context).textTheme.labelMedium!.copyWith(color: AppColors.ink);
    Widget item(Color color, String word) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(word, style: style),
      ],
    );
    return Container(
      key: const ValueKey('legend-pill'),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.button / 2),
        boxShadow: AppShadows.card,
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 4,
        children: [
          item(mapFloodColor, l.legendFlooded),
          item(modeMapColor(AccessMode.boat), l.legendBoat),
          item(modeMapColor(AccessMode.highClearanceTruck), l.legendVehicle),
        ],
      ),
    );
  }
}

/// Exit and the legend on the left; Layers, Routes, My location, Fit and zoom on the right.
class FullScreenControls extends ConsumerWidget {
  final VoidCallback onLocate, onFit;
  final ValueChanged<double> onZoom;

  const FullScreenControls({super.key, required this.onLocate, required this.onFit, required this.onZoom});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: mapOverlayMaxTextScale,
      child: Stack(
        children: [
          Positioned(
            top: 8,
            left: 12,
            right: 72,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MapRoundButton(
                  key: const ValueKey('exit-full-screen'),
                  icon: Icons.fullscreen_exit_rounded,
                  tooltip: l.exitFullScreen,
                  onPressed: () => setMapFullScreen(ref, false),
                ),
                const SizedBox(height: 8),
                const MapLegendPill(),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 12,
            bottom: 24,
            child: Align(
              alignment: Alignment.topRight,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                    MapRoundButton(
                      icon: Icons.alt_route_rounded,
                      tooltip: l.routesButton,
                      onPressed: () => showRoutesPanel(context),
                    ),
                    MapRoundButton(icon: Icons.my_location_rounded, tooltip: l.tooltipLocate, onPressed: onLocate),
                    MapRoundButton(icon: Icons.fit_screen_rounded, tooltip: l.tooltipFit, onPressed: onFit),
                    MapRoundButton(icon: Icons.add_rounded, tooltip: l.tooltipZoomIn, onPressed: () => onZoom(1)),
                    MapRoundButton(icon: Icons.remove_rounded, tooltip: l.tooltipZoomOut, onPressed: () => onZoom(-1)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A tapped area in full screen: name, people, mode and Open.
class FullScreenAreaCard extends ConsumerWidget {
  const FullScreenAreaCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = ref.watch(fullScreenAreaProvider);
    if (id == null) return const SizedBox.shrink();
    final l = AppLocalizations.of(context)!;
    final text = Theme.of(context).textTheme;
    final all = ref.watch(rankedMissionsProvider);
    final ranked = all.firstWhere((r) => r.mission.pocketId == id);
    final m = ranked.mission;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.4),
      child: AppCard(
        key: const ValueKey('full-screen-area-card'),
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        padding: const EdgeInsets.fromLTRB(14, 10, 4, 12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  RankCircle(rank: ranked.rank, tone: modeTone(m.accessMode), size: 36),
                  const SizedBox(width: 10),
                  Expanded(child: Text(l.areaName(ranked, all), style: text.titleMedium)),
                  IconButton(
                    tooltip: l.close,
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => ref.read(fullScreenAreaProvider.notifier).state = null,
                  ),
                ],
              ),
              Text(l.populationEstimate(Fmt.of(context).count(m.population)), style: text.bodyMedium),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ModeChip(mode: m.accessMode),
                    FilledButton.icon(
                      onPressed: () {
                        setMapFullScreen(ref, false);
                        context.go(AppRoutes.area(m.pocketId));
                      },
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: Text(l.openArea),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
