// The Map's Layers sheet: big switches in plain groups, and a reset.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/enums.dart';
import '../../l10n/app_localizations.dart';
import '../../state/map_state.dart';
import '../../state/providers.dart';
import '../../theme/app_theme.dart';
import '../../utils/trust_text.dart';
import '../../utils/labels.dart';
import '../ui/kit.dart';
import 'feature_layers.dart' show serviceIcon;

/// The depot's name follows the quality flags: assumed, auto-selected, or neither.
String depotLayerName(AppLocalizations l, Set<QualityFlag> flags) => flags.contains(QualityFlag.depotAutoSelected)
    ? l.layerDepotAuto
    : flags.contains(QualityFlag.depotAssumed)
    ? l.layerDepotAssumed
    : l.layerDepot;

String layerName(AppLocalizations l, MapLayer layer, Set<QualityFlag> flags) => switch (layer) {
  MapLayer.depthZones => l.layerDepth,
  MapLayer.flood => l.layerFlood,
  MapLayer.floodBaseline => l.layerBaseline,
  MapLayer.floodEms => l.layerEms,
  MapLayer.allRoads => l.layerAllRoads,
  MapLayer.floodedRoads => l.layerRoads,
  MapLayer.pockets => l.layerPockets,
  MapLayer.routes => l.layerRoutes,
  MapLayer.clinics => l.layerClinics,
  MapLayer.markets => l.layerMarkets,
  MapLayer.shelters => l.layerShelters,
  MapLayer.depot => depotLayerName(l, flags),
  MapLayer.compare => l.layerCompare,
};

IconData layerIcon(MapLayer layer) => switch (layer) {
  MapLayer.depthZones => Icons.layers_rounded,
  MapLayer.flood => Icons.water_rounded,
  MapLayer.floodBaseline => Icons.radar_rounded,
  MapLayer.floodEms => Icons.flag_rounded,
  MapLayer.allRoads => Icons.alt_route_rounded,
  MapLayer.floodedRoads => Icons.add_road_rounded,
  MapLayer.pockets => Icons.crop_square_rounded,
  MapLayer.routes => Icons.route_rounded,
  MapLayer.clinics => serviceIcon(ServiceType.clinic),
  MapLayer.markets => serviceIcon(ServiceType.market),
  MapLayer.shelters => serviceIcon(ServiceType.shelter),
  MapLayer.depot => serviceIcon(ServiceType.aidDepot),
  MapLayer.compare => Icons.compare_rounded,
};

/// Place layers and the kind of place each shows.
const placeLayers = {
  MapLayer.clinics: ServiceType.clinic,
  MapLayer.markets: ServiceType.market,
  MapLayer.shelters: ServiceType.shelter,
  MapLayer.depot: ServiceType.aidDepot,
};

/// [onRoutes] opens the routes panel (see the Routes section).
void showLayersSheet(BuildContext context, {VoidCallback? onRoutes}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      builder: (_, controller) => LayersSheet(controller: controller, onRoutes: onRoutes),
    ),
  );
}

class LayersSheet extends ConsumerWidget {
  final ScrollController? controller;
  final VoidCallback? onRoutes;

  const LayersSheet({super.key, this.controller, this.onRoutes});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final text = Theme.of(context).textTheme;
    final bundle = ref.watch(loadedBundleProvider);
    final flags = bundle.manifest.qualityFlags;
    final visible = ref.watch(mapLayersProvider);
    final layers = ref.read(mapLayersProvider.notifier);
    Widget heading(String title) => Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 4),
      child: Semantics(header: true, child: Text(title, style: text.titleMedium)),
    );
    Widget toggle(MapLayer layer, {String? note}) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          key: ValueKey('layer-switch-${layer.name}'),
          contentPadding: EdgeInsets.zero,
          secondary: Icon(layerIcon(layer), color: AppColors.ink),
          title: Text(layerName(l, layer, flags), style: text.bodyLarge),
          subtitle: note == null ? null : Text(note, style: text.bodySmall),
          value: visible.contains(layer),
          onChanged: (on) => layers.setVisible(layer, on),
        ),
      ],
    );
    Widget roadKey(Color color, String label) => Padding(
      padding: const EdgeInsets.only(left: 56, bottom: 4),
      child: Row(
        children: [
          Container(width: 24, height: 5, color: color),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: text.bodySmall)),
        ],
      ),
    );
    // One column, built whole: the list is short and every switch stays findable.
    return SingleChildScrollView(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(AppSizes.gutter, 0, AppSizes.gutter, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.layersTitle, style: text.titleLarge),
          heading(l.layerGroupWater),
          toggle(MapLayer.flood, note: l.layerFloodNote),
          toggle(MapLayer.depthZones, note: l.depthDetailNote),
          heading(l.layerGroupAreas),
          toggle(MapLayer.pockets),
          heading(l.layerGroupRoads),
          toggle(MapLayer.floodedRoads, note: l.layerRoadsNote),
          toggle(MapLayer.allRoads),
          if (visible.contains(MapLayer.allRoads)) ...[
            roadKey(AppColors.roadAnyCar, l.roadAnyCar),
            roadKey(AppColors.roadHighClearance, l.roadHighClearance),
            roadKey(AppColors.roadFootOnly, l.roadFootOnly),
            roadKey(AppColors.roadImpassable, l.roadImpassable),
          ],
          heading(l.layerGroupPlaces),
          for (final layer in placeLayers.keys) toggle(layer),
          heading(l.layerGroupRoutes),
          toggle(MapLayer.routes, note: l.layerRoutesNote),
          if (onRoutes != null) ...[
            const SizedBox(height: 4),
            BigButton.secondary(icon: Icons.list_alt_rounded, label: l.routesPanelOpen, onPressed: onRoutes),
          ],
          heading(l.layerGroupMore),
          toggle(MapLayer.compare, note: l.calibrationNote(bundle.manifest, bundle.quality, Fmt.of(context))),
          toggle(MapLayer.floodBaseline, note: l.layerBaselineNote),
          const SizedBox(height: 20),
          BigButton(icon: Icons.restart_alt_rounded, label: l.resetView, onPressed: layers.reset),
        ],
      ),
    );
  }
}
