// Every published route, grouped by area: show one alone, all, or none.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/enums.dart';
import '../../data/models/route_line.dart';
import '../../l10n/app_localizations.dart';
import '../../state/map_state.dart';
import '../../state/mission_state.dart';
import '../../state/providers.dart';
import '../../state/route_view.dart';
import '../../theme/app_theme.dart';
import '../../utils/labels.dart';
import '../ui/kit.dart';
import '../ui/mode_look.dart';

/// A short piece of the route's line: solid teal for safest, dashed brown for shortest.
class RouteSwatch extends StatelessWidget {
  final RouteType type;

  const RouteSwatch({super.key, required this.type});

  @override
  Widget build(BuildContext context) => CustomPaint(size: const Size(32, 12), painter: _SwatchPainter(type));
}

class _SwatchPainter extends CustomPainter {
  final RouteType type;

  const _SwatchPainter(this.type);

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height / 2;
    final safest = type == RouteType.safest;
    final paint = Paint()
      ..color = safest ? AppColors.safestRoute : AppColors.shortestRoute
      ..strokeWidth = safest ? 5 : 3;
    if (safest) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
      return;
    }
    for (var x = 0.0; x < size.width; x += 9) {
      canvas.drawLine(Offset(x, y), Offset(x + 6, y), paint);
    }
  }

  @override
  bool shouldRepaint(_SwatchPainter old) => old.type != type;
}

/// Opens the panel. With [focusPocketId], that area comes first.
void showRoutesPanel(BuildContext context, {String? focusPocketId}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      minChildSize: 0.35,
      builder: (_, controller) => RoutesPanel(controller: controller, focusPocketId: focusPocketId),
    ),
  );
}

class RoutesPanel extends ConsumerWidget {
  final ScrollController? controller;
  final String? focusPocketId;

  const RoutesPanel({super.key, this.controller, this.focusPocketId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final text = Theme.of(context).textTheme;
    final ranked = ref.watch(rankedMissionsProvider);
    final routes = ref.watch(loadedBundleProvider).routes;
    final order = [
      for (final r in ranked)
        if (r.mission.pocketId == focusPocketId) r,
      for (final r in ranked)
        if (r.mission.pocketId != focusPocketId) r,
    ];
    void clearChoice() {
      ref.read(selectedRouteProvider.notifier).state = null;
      ref.read(highlightedRouteProvider.notifier).state = null;
      ref.read(selectedPocketIdProvider.notifier).state = null;
    }

    return SingleChildScrollView(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(AppSizes.gutter, 0, AppSizes.gutter, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(header: true, child: Text(l.routesPanelTitle, style: text.titleLarge)),
          const SizedBox(height: 4),
          Text(l.routesPanelIntro, style: text.bodySmall),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    clearChoice();
                    ref.read(mapLayersProvider.notifier).setVisible(MapLayer.routes, true);
                    Navigator.pop(context);
                  },
                  child: Text(l.routesShowAll, textAlign: TextAlign.center),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    clearChoice();
                    ref.read(mapLayersProvider.notifier).setVisible(MapLayer.routes, false);
                  },
                  child: Text(l.routesHideAll, textAlign: TextAlign.center),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(l.routeModeOnlyNote, style: text.bodySmall),
          const SizedBox(height: 8),
          for (final r in order)
            AppCard(
              key: ValueKey('routes-area-${r.mission.pocketId}'),
              borderColor: r.mission.pocketId == focusPocketId ? modeTone(r.mission.accessMode).strong : null,
              borderWidth: r.mission.pocketId == focusPocketId ? 2 : 1,
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      RankCircle(rank: r.rank, tone: modeTone(r.mission.accessMode), size: 36),
                      const SizedBox(width: 10),
                      Expanded(child: Text(l.areaName(r, ranked), style: text.titleMedium)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ModeChip(mode: r.mission.accessMode),
                  for (final type in const [RouteType.safest, RouteType.shortest])
                    for (final route in routes.where((x) => x.pocketId == r.mission.pocketId && x.routeType == type))
                      RouteRow(route: route, safest: routes.firstWhere((x) => x.pocketId == route.pocketId && x.routeType == RouteType.safest)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// One route: swatch and pattern, distance and time, warnings. Tap to show it alone.
class RouteRow extends ConsumerWidget {
  final RouteLine route;
  final RouteLine safest;

  const RouteRow({super.key, required this.route, required this.safest});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final fmt = Fmt.of(context);
    final text = Theme.of(context).textTheme;
    final selected = sameRoute(ref.watch(selectedRouteProvider), route);
    final isSafest = route.routeType == RouteType.safest;
    final same = !isSafest && route.distanceKm == safest.distanceKm && route.riskScore == safest.riskScore;
    final warnings = [
      if (route.kmDeep > 0) l.routeDeepWater(fmt.km(route.kmDeep)),
      if (route.uncertainBridges > 0) l.routeUncertainBridges(route.uncertainBridges),
    ];
    return Material(
      color: selected ? AppColors.truckTint : Colors.transparent,
      borderRadius: BorderRadius.circular(AppSizes.chipRadius),
      child: InkWell(
        key: ValueKey('route-row-${route.pocketId}-${route.routeType.name}'),
        borderRadius: BorderRadius.circular(AppSizes.chipRadius),
        onTap: () {
          ref.read(highlightedRouteProvider.notifier).state = null;
          if (selected) {
            ref.read(selectedRouteProvider.notifier).state = null;
            return;
          }
          ref.read(selectedRouteProvider.notifier).state = route;
          Navigator.pop(context);
        },
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppSizes.tap),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: const EdgeInsets.only(top: 6), child: RouteSwatch(type: route.routeType)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${isSafest ? l.routeRowSafest : l.routeRowShortest} · ${isSafest ? l.routeLineSolid : l.routeLineDashed}',
                          style: text.titleSmall),
                      // Published route times come from the notebook, not from summed rounded pieces.
                      Text(l.routeDistanceTime(fmt.km(route.distanceKm), fmt.minutes(route.estimatedTimeMin)),
                          style: text.bodyMedium),
                      if (same) Text(l.routeSameRoad, style: text.bodySmall),
                      for (final w in warnings) Text('• $w', style: text.bodySmall),
                      if (selected)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: StatusChip(icon: Icons.visibility_rounded, label: l.routeShownOnly, tone: Tone.truck),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
