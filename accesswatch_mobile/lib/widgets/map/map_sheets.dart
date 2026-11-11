// Bottom sheets for tapped routes and services.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/enums.dart';
import '../../data/models/route_line.dart';
import '../../data/models/service_point.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import '../../theme/app_theme.dart';
import '../../utils/labels.dart';
import 'feature_layers.dart' show serviceIcon;

void _show(BuildContext context, Widget Function(ScrollController) body) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.95,
      minChildSize: 0.3,
      expand: false,
      builder: (_, controller) => body(controller),
    ),
  );
}

/// Several routes can run along the same road, so a tap can hit more than one.
void showRoutesSheet(BuildContext context, List<RouteLine> routes) {
  _show(context, (controller) {
    final l = AppLocalizations.of(context)!;
    return ListView(
      controller: controller,
      padding: const EdgeInsets.all(20),
      children: [
        Text(l.routesIllustrative, style: const TextStyle(color: AppColors.boat, fontSize: 11.5)),
        const SizedBox(height: 12),
        for (final route in routes) _RouteCard(route: route),
      ],
    );
  });
}

class _Fact extends StatelessWidget {
  final String label, value;

  const _Fact(this.label, this.value);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(label, style: const TextStyle(color: AppColors.inkSecondary, fontSize: 12)),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(color: AppColors.ink, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}

class _RouteCard extends StatelessWidget {
  final RouteLine route;

  const _RouteCard({required this.route});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final fmt = Fmt.of(context);
    final name = route.routeType == RouteType.safest ? l.routeSafestLabel : l.routeShortestLabel;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.ground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.routeSheetTitle(route.pocketId, name),
            style: const TextStyle(color: AppColors.ink, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          _Fact(l.routeAccess, l.accessMode(route.accessMode)),
          _Fact(l.distance, l.distanceKm(fmt.km(route.distanceKm))),
          _Fact(l.eta, l.durationMin(fmt.minutes(route.estimatedTimeMin))),
          _Fact(l.depthLevel, l.depthClass(route.maxDepthClass)),
          _Fact(
            l.routeWaterKm,
            l.routeWaterValue(fmt.km(route.kmShallow), fmt.km(route.kmMedium), fmt.km(route.kmDeep)),
          ),
          if (route.boatLegKm > 0) _Fact(l.routeAccess, l.boatLegKm(fmt.km(route.boatLegKm))),
          _Fact(l.uncertainBridges, fmt.count(route.uncertainBridges)),
          _Fact(l.accessRisk, l.riskLevel(route.riskLevel)),
        ],
      ),
    );
  }
}

void showServiceSheet(BuildContext context, WidgetRef ref, ServicePoint service) {
  final bundle = ref.read(loadedBundleProvider);
  final flags = bundle.manifest.qualityFlags;
  final repeatsPossible = bundle.quality.notes.clinicRecordPairsWithin100m > 0;
  _show(context, (controller) {
    final l = AppLocalizations.of(context)!;
    const note = TextStyle(color: AppColors.inkSecondary, fontSize: 12, height: 1.35);
    return ListView(
      controller: controller,
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          children: [
            Icon(serviceIcon(service.type), color: AppColors.brand),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                l.serviceName(service),
                style: const TextStyle(color: AppColors.ink, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _Fact(l.sheetServiceType, l.serviceType(service.type)),
        if (service.clinicStatus != null) ...[
          _Fact(l.sheetStatus, l.clinicStatus(service.clinicStatus!, service.pocketId)),
          const SizedBox(height: 10),
          Text(l.clinicStatusNote, style: note),
          if (repeatsPossible) ...[const SizedBox(height: 6), Text(l.clinicDuplicateNote, style: note)],
        ],
        if (service.type == ServiceType.aidDepot && flags.contains(QualityFlag.depotAutoSelected)) ...[
          const SizedBox(height: 10),
          Text(l.warnDepotAutoSelected, style: note.copyWith(color: AppColors.boat)),
        ],
      ],
    );
  });
}
