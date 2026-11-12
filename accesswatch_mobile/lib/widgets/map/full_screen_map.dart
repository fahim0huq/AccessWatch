// Full-screen map: only floating controls, a small legend pill, and a small
// card for a tapped area.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../router.dart';
import '../../state/map_state.dart';
import '../../state/mission_state.dart';
import '../../utils/labels.dart';
import '../ui/kit.dart';
import '../ui/mode_look.dart';
import 'layer_chips.dart';
import 'layers_sheet.dart';
import 'legend_pill.dart';
import 'map_overlay.dart';
import 'routes_panel.dart';

/// The area tapped in full screen, shown in the small bottom card.
final fullScreenAreaProvider = StateProvider<String?>((ref) => null);

void setMapFullScreen(WidgetRef ref, bool on) {
  ref.read(fullScreenAreaProvider.notifier).state = null;
  ref.read(mapFullScreenProvider.notifier).state = on;
}

/// Exit and the legend, the chip row, then Layers, Routes, My location, Fit and zoom on the right.
class FullScreenControls extends ConsumerWidget {
  final VoidCallback onLocate, onFit;
  final ValueChanged<double> onZoom;

  const FullScreenControls({super.key, required this.onLocate, required this.onFit, required this.onZoom});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final buttons = Column(
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
    );
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: mapOverlayMaxTextScale,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MapRoundButton(
                  key: const ValueKey('exit-full-screen'),
                  icon: Icons.fullscreen_exit_rounded,
                  tooltip: l.exitFullScreen,
                  onPressed: () => setMapFullScreen(ref, false),
                ),
                const SizedBox(width: 8),
                const Flexible(child: Padding(padding: EdgeInsets.only(top: 8), child: MapLegendPill())),
              ],
            ),
          ),
          const SizedBox(height: 4),
          const LayerChipRow(),
          Expanded(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 12, bottom: 24),
                child: SingleChildScrollView(child: buttons),
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
