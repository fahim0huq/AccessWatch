// The Map's Layers sheet: a grid of big tiles, a More group, Reset and close.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/enums.dart';
import '../../l10n/app_localizations.dart';
import '../../state/map_state.dart';
import '../../state/providers.dart';
import '../../theme/app_theme.dart';
import '../../utils/trust_text.dart';
import '../../utils/labels.dart';
import 'layer_tile.dart';
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

/// The tiles of the sheet, in order. Routes opens the routes panel instead of switching.
const sheetTiles = [
  MapLayer.flood,
  MapLayer.depthZones,
  MapLayer.floodedRoads,
  MapLayer.allRoads,
  MapLayer.pockets,
  MapLayer.routes,
  MapLayer.clinics,
  MapLayer.markets,
  MapLayer.shelters,
  MapLayer.depot,
];

String tileName(AppLocalizations l, MapLayer layer, Set<QualityFlag> flags) => switch (layer) {
  MapLayer.depthZones => l.tileWaterDepth,
  MapLayer.allRoads => l.tileAllRoads,
  _ => layerName(l, layer, flags),
};

/// A half-height sheet over the map. [onRoutes] opens the routes panel.
void showLayersSheet(BuildContext context, {VoidCallback? onRoutes}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      maxChildSize: 0.92,
      minChildSize: 0.3,
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
    // Four columns; fewer at large text so the labels stay whole.
    final scale = MediaQuery.textScalerOf(context).scale(1);
    final columns = scale > 1.6 ? 2 : (scale > 1.2 ? 3 : 4);
    Widget tile(MapLayer layer) => LayerTile(
      key: ValueKey('layer-switch-${layer.name}'),
      icon: layerIcon(layer),
      label: tileName(l, layer, flags),
      maxLines: columns == 4 ? 2 : 3,
      selected: layer == MapLayer.routes ? null : visible.contains(layer),
      onTap: layer == MapLayer.routes ? (onRoutes ?? () {}) : () => layers.setVisible(layer, !visible.contains(layer)),
    );
    Widget note(String words) =>
        Padding(padding: const EdgeInsets.only(top: 6), child: Text(words, style: text.bodySmall));
    Widget roadKey(Color color, String label) => Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Container(width: 24, height: 5, color: color),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: text.bodySmall)),
        ],
      ),
    );
    Widget more(MapLayer layer, String title, String oneLine, String longNote) => SwitchListTile(
      key: ValueKey('layer-switch-${layer.name}'),
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: text.bodyLarge),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(oneLine, style: text.bodyMedium!.copyWith(color: AppColors.inkSecondary)),
          note(longNote),
        ],
      ),
      value: visible.contains(layer),
      onChanged: (on) => layers.setVisible(layer, on),
    );
    final rows = [for (var i = 0; i < sheetTiles.length; i += columns) sheetTiles.skip(i).take(columns).toList()];
    return SingleChildScrollView(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(AppSizes.gutter, 0, AppSizes.gutter, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Semantics(header: true, child: Text(l.layersSheetTitle, style: text.titleLarge)),
              ),
              TextButton(key: const ValueKey('layers-reset'), onPressed: layers.reset, child: Text(l.layersReset)),
              IconButton(
                key: const ValueKey('layers-close'),
                tooltip: l.close,
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final row in rows)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < columns; i++) ...[
                    if (i > 0) const SizedBox(width: 8),
                    Expanded(child: i < row.length ? tile(row[i]) : const SizedBox()),
                  ],
                ],
              ),
            ),
          // Notes for what is on, so the map can be read.
          if (visible.contains(MapLayer.flood)) note(l.layerFloodNote),
          if (visible.contains(MapLayer.depthZones)) note(l.depthDetailNote),
          if (visible.contains(MapLayer.floodedRoads)) note(l.layerRoadsNote),
          if (visible.contains(MapLayer.allRoads)) ...[
            note(l.layerAllRoads),
            roadKey(AppColors.roadAnyCar, l.roadAnyCar),
            roadKey(AppColors.roadHighClearance, l.roadHighClearance),
            roadKey(AppColors.roadFootOnly, l.roadFootOnly),
            roadKey(AppColors.roadImpassable, l.roadImpassable),
          ],
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 4),
            child: Semantics(header: true, child: Text(l.layerGroupMore, style: text.titleMedium)),
          ),
          more(
            MapLayer.compare,
            l.layerCompare,
            l.moreCompareNote,
            l.calibrationNote(bundle.manifest, bundle.quality, Fmt.of(context)),
          ),
          more(MapLayer.floodBaseline, l.layerBaseline, l.moreBaselineNote, l.layerBaselineNote),
        ],
      ),
    );
  }
}
