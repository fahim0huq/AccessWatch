import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../state/care_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/labels.dart';
import '../care/care_common.dart';
import '../care/route_cards.dart';

const _careRouteColor = AppColors.careRoute;

/// The route sent from Care, drawn along the roads only.
class CareRouteLayer extends ConsumerWidget {
  const CareRouteLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final route = ref.watch(careRouteOnMapProvider);
    if (route == null || route.points.length < 2) return const SizedBox.shrink();
    return PolylineLayer<Object>(polylines: [
      Polyline<Object>(
        points: route.points,
        strokeWidth: 6,
        color: _careRouteColor,
        borderStrokeWidth: 2,
        borderColor: Colors.white,
      ),
    ]);
  }
}

/// Distance, time and warnings of the route on the map, with a way to clear it.
class CareRoutePanel extends ConsumerWidget {
  const CareRoutePanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final route = ref.watch(careRouteOnMapProvider);
    if (route == null) return const SizedBox.shrink();
    final l = AppLocalizations.of(context)!;
    final fmt = Fmt.of(context);
    final r = route.clinicRoute.route;
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 6),
      padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(color: _careRouteColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(careModeIcon(route.mode), color: _careRouteColor),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.careRouteTo(l.serviceName(route.clinicRoute.clinic), careModeLabel(l, route.mode)),
                    style: careBodyStyle.copyWith(fontWeight: FontWeight.bold)),
                Text(routeSummary(l, fmt, route.mode, r), style: careBodyStyle),
                for (final warning in routeWarnings(l, fmt, route.mode, r)) Text('• $warning', style: careMutedStyle),
              ],
            ),
          ),
          IconButton(
            tooltip: l.clearRoute,
            onPressed: () => ref.read(careRouteOnMapProvider.notifier).state = null,
            icon: const Icon(Icons.close_rounded, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
