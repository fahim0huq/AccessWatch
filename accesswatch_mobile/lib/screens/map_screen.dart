import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart' show LatLng;

import '../data/bundle_repository.dart';
import '../data/models/manifest.dart';
import '../l10n/app_localizations.dart';
import '../state/care_state.dart';
import '../state/connectivity.dart';
import '../state/location.dart';
import '../state/map_state.dart';
import '../state/providers.dart';
import '../theme/app_theme.dart';
import '../widgets/location_prompt.dart';
import '../widgets/map/care_route_layer.dart';
import '../widgets/map/feature_layers.dart';
import '../widgets/map/flood_layers.dart';
import '../widgets/map/map_chrome.dart';
import '../widgets/map/map_overlay.dart';
import '../widgets/map/map_sheets.dart';
import '../widgets/ui/kit.dart';

const _tileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
const _userAgentPackage = 'com.accesswatch.app';
// Room for the pill and chips above and the buttons on the right.
const _fitPadding = EdgeInsets.fromLTRB(16, 120, 72, 16);
const _focusPadding = EdgeInsets.fromLTRB(48, 120, 80, 48);

LatLngBounds _latLngBounds(GeoBounds b) => LatLngBounds(LatLng(b.south, b.west), LatLng(b.north, b.east));

/// The Map tab: the real layers full screen, a few words on top, and one
/// summary card with the way to Help first.
class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> with ShowsLocation {
  final _map = MapController();
  // Kept across rebuilds: each new TileLayer would bring its own tile provider and client.
  late final _tiles = TileLayer(
    urlTemplate: _tileUrl,
    userAgentPackageName: _userAgentPackage,
    maxNativeZoom: 19,
    tileProvider: ref.read(mapTileProvider),
  );
  bool _ready = false;

  AppBundle get _bundle => ref.read(loadedBundleProvider);

  @override
  void dispose() {
    _map.dispose();
    super.dispose();
  }

  void _say(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _centreOnMe() {
    final me = ref.read(locationControllerProvider).position;
    if (me == null || !_ready) return;
    if (_latLngBounds(_bundle.manifest.boundsAll).contains(me)) {
      _map.move(me, 15);
    } else {
      _say(AppLocalizations.of(context)!.locationOutside);
    }
  }

  Future<void> _locate() async {
    if (await requestLocation(context, ref)) _centreOnMe();
  }

  void _fitPoints(List<LatLng> points, double maxZoom) =>
      _map.fitCamera(CameraFit.bounds(bounds: LatLngBounds.fromPoints(points), padding: _focusPadding, maxZoom: maxZoom));

  void _showCareRoute(CareRouteOnMap? route) {
    if (route == null || !_ready || route.points.length < 2) return;
    _fitPoints(route.points, 16);
  }

  void _fitAll() =>
      _map.fitCamera(CameraFit.bounds(bounds: _latLngBounds(_bundle.manifest.bounds), padding: _fitPadding));

  void _focus(String? pocketId) {
    if (!_ready) return;
    if (pocketId == null) {
      _fitAll();
      return;
    }
    final pocket = _bundle.pockets.firstWhere((p) => p.id == pocketId);
    _fitPoints([for (final polygon in pocket.polygons) ...polygon.outer], 15);
  }

  /// The map loads its first tiles before it applies initialCameraFit and does
  /// not reload after, which leaves the fitted view with no base map. A tiny
  /// camera move makes it load the tiles for the view actually on screen.
  void _loadFittedTiles() {
    final camera = _map.camera;
    _map.move(camera.center, camera.zoom + 0.001);
    // On an idle page nothing else asks for the frame that shows them.
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  void _zoom(double by) {
    final camera = _map.camera;
    _map.move(camera.center, camera.zoom + by);
  }

  void _openPocket(String id) => showAreaSheet(context, ref, id);

  void _onMapReady() {
    _ready = true;
    final selected = ref.read(selectedPocketIdProvider);
    final careRoute = ref.read(careRouteOnMapProvider);
    if (careRoute != null) {
      _showCareRoute(careRoute);
    } else if (selected != null) {
      _focus(selected);
    } else {
      _loadFittedTiles();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String?>(selectedPocketIdProvider, (_, id) => _focus(id));
    ref.listen<CareRouteOnMap?>(careRouteOnMapProvider, (_, route) => _showCareRoute(route));
    ref.listen<LocationState>(locationControllerProvider, (before, now) {
      if (before?.position == null && now.position != null) _centreOnMe();
    });
    final me = ref.watch(locationControllerProvider);
    final l = AppLocalizations.of(context)!;
    final bundle = ref.watch(loadedBundleProvider);
    final layers = ref.watch(mapLayersProvider);
    final compare = layers.contains(MapLayer.compare);
    // An area chosen from Help first shows its own routes even with the routes layer off.
    final showRoutes = layers.contains(MapLayer.routes) || ref.watch(selectedPocketIdProvider) != null;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Semantics(
                  label: l.mapSemanticsLabel,
                  child: FlutterMap(
                    mapController: _map,
                    options: MapOptions(
                      // Set as well as the fit, so even the very first tile requests
                      // are for this area and not the library's default centre.
                      initialCenter: _latLngBounds(bundle.manifest.bounds).center,
                      initialZoom: 12,
                      initialCameraFit: CameraFit.bounds(bounds: _latLngBounds(bundle.manifest.bounds), padding: _fitPadding),
                      minZoom: 9,
                      maxZoom: 18,
                      backgroundColor: AppColors.mapBackground,
                      interactionOptions: const InteractionOptions(flags: InteractiveFlag.all & ~InteractiveFlag.rotate),
                      // Debug builds only: a long press sets a test position, for trying Find care on a desktop.
                      onLongPress: kDebugMode
                          ? (_, point) => ref.read(locationControllerProvider.notifier).setTestPosition(point)
                          : null,
                      onMapReady: _onMapReady,
                    ),
                    children: [
                      if (ref.watch(showBaseTilesProvider) && ref.watch(onlineProvider).valueOrNull != false) _tiles,
                      if (compare)
                        OverlayImageLayer(
                          overlayImages: [
                            OverlayImage(
                              bounds: _latLngBounds(bundle.manifest.bounds),
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
                      if (layers.contains(MapLayer.floodedRoads)) const FloodedRoadsLayer(),
                      if (layers.contains(MapLayer.pockets)) PocketAreasLayer(onTap: (p) => _openPocket(p.id)),
                      if (showRoutes) RoutesLayer(onTap: (r) => showRoutesSheet(context, r)),
                      if (layers.contains(MapLayer.pockets)) PocketLabelsLayer(onTap: (p) => _openPocket(p.id)),
                      if (layers.contains(MapLayer.services)) ServicesLayer(onTap: (s) => showServiceSheet(context, ref, s)),
                      const CareRouteLayer(),
                      if (me.position != null) MyLocationLayer(position: me.position!, isTest: me.isTestPosition),
                      const OsmAttribution(),
                    ],
                  ),
                ),
                // Each overlay is only as big as what it shows, so the map
                // around them still takes every pan and tap.
                Positioned.fill(
                  child: SafeArea(
                    bottom: false,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 8,
                          left: 12,
                          right: 72,
                          bottom: 24,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  MapBrandPill(),
                                  SizedBox(height: 8),
                                  MapLegendChips(),
                                  SizedBox(height: 8),
                                  CareRoutePanel(),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 12,
                          bottom: 24,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const HelpButton(),
                                  const SizedBox(height: 4),
                                  MapRoundButton(icon: Icons.my_location_rounded, tooltip: l.tooltipLocate, onPressed: _locate),
                                  MapRoundButton(icon: Icons.add_rounded, tooltip: l.tooltipZoomIn, onPressed: () => _zoom(1)),
                                  MapRoundButton(icon: Icons.remove_rounded, tooltip: l.tooltipZoomOut, onPressed: () => _zoom(-1)),
                                  MapRoundButton(
                                    icon: Icons.fit_screen_rounded,
                                    tooltip: l.tooltipFit,
                                    onPressed: () {
                                      ref.read(selectedPocketIdProvider.notifier).state = null;
                                      _fitAll();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const MapSummaryCard(),
        ],
      ),
    );
  }
}
