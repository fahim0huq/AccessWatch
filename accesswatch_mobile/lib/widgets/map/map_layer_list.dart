// Every layer the Map can draw, in drawing order, from the saved layer choice.
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart' show LatLng;

import '../../data/bundle_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../state/connectivity.dart';
import '../../state/location.dart';
import '../../state/map_state.dart';
import '../../state/providers.dart';
import '../../state/route_view.dart';
import 'area_select.dart';
import 'care_route_layer.dart';
import 'feature_layers.dart';
import 'flood_layers.dart';
import 'layers_sheet.dart';
import 'map_chrome.dart';
import 'map_sheets.dart';

List<Widget> mapLayerList(
  BuildContext context,
  WidgetRef ref, {
  required Widget tiles,
  required ValueChanged<String> onPocket,
}) {
  final l = AppLocalizations.of(context)!;
  final bundle = ref.watch(loadedBundleProvider);
  final me = ref.watch(locationControllerProvider);
  final layers = ref.watch(mapLayersProvider);
  final compare = layers.contains(MapLayer.compare);
  final b = bundle.manifest.bounds;
  // An area chosen from Help first shows its own routes even with the routes layer off.
  final showRoutes =
      layers.contains(MapLayer.routes) ||
      ref.watch(selectedPocketIdProvider) != null ||
      ref.watch(selectedRouteProvider) != null;
  return [
    if (ref.watch(showBaseTilesProvider) && ref.watch(onlineProvider).valueOrNull != false) tiles,
    if (compare)
      OverlayImageLayer(
        overlayImages: [
          OverlayImage(
            bounds: LatLngBounds(LatLng(b.south, b.west), LatLng(b.north, b.east)),
            imageProvider: const AssetImage(BundleRepository.compareImageAsset),
            opacity: ref.watch(mapOpacityProvider)[MapLayer.compare]!,
            filterQuality: FilterQuality.none,
          ),
        ],
      )
    else ...[
      if (layers.contains(MapLayer.depthZones)) const DepthZonesLayer(),
      if (layers.contains(MapLayer.flood)) const FloodLayer(),
      if (layers.contains(MapLayer.floodBaseline)) const BaselineFloodLayer(),
      if (layers.contains(MapLayer.floodEms)) const EmsFloodLayer(),
    ],
    if (layers.contains(MapLayer.allRoads)) const AllRoadsLayer(),
    if (layers.contains(MapLayer.floodedRoads)) const FloodedRoadsLayer(),
    if (layers.contains(MapLayer.pockets)) PocketAreasLayer(onTap: (p) => onPocket(p.id)),
    if (showRoutes)
      RoutesLayer(
        onTap: (hits) {
          ref.read(highlightedRouteProvider.notifier).state = hits.first;
          showRoutesSheet(context, hits);
        },
      ),
    if (layers.contains(MapLayer.pockets)) PocketLabelsLayer(onTap: (p) => onPocket(p.id)),
    if (placeLayers.keys.any(layers.contains))
      ServicesLayer(
        types: {
          for (final e in placeLayers.entries)
            if (layers.contains(e.key)) e.value,
        },
        onTap: (s) => showServiceSheet(context, ref, s),
      ),
    const CareRouteLayer(),
    if (me.position != null)
      MyLocationLayer(position: me.position!, isTest: me.isStandIn, label: me.isSample ? l.sampleNotice : null),
    // The scale bar is a full-screen tool.
    if (ref.watch(mapFullScreenProvider)) const Scalebar(alignment: Alignment.bottomLeft, padding: EdgeInsets.fromLTRB(12, 0, 0, 8)),
    const SelectionBoxLayer(),
    const OsmAttribution(),
  ];
}
