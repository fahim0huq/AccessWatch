import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart' show LatLng;

import '../data/bundle_repository.dart';
import '../data/models/manifest.dart';
import '../data/models/route_line.dart';
import '../l10n/app_localizations.dart';
import '../state/care_state.dart';
import '../state/location.dart';
import '../state/map_state.dart';
import '../state/providers.dart';
import '../state/route_view.dart';
import '../theme/app_theme.dart';
import '../widgets/location_prompt.dart';
import '../widgets/map/full_screen_map.dart';
import '../widgets/map/map_layer_list.dart';
import '../widgets/map/map_overlay.dart';
import '../widgets/map/routes_panel.dart';

const _tileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
const _userAgentPackage = 'com.accesswatch.app';

/// Room for the pill and chips above (they grow with the text size) and the
/// buttons on the right, so nothing fitted sits under them.
double _overlayHeight(BuildContext context) =>
    64 + 56 * MediaQuery.textScalerOf(context).scale(1).clamp(1.0, mapOverlayMaxTextScale);
EdgeInsets _fitPadding(BuildContext context) => EdgeInsets.fromLTRB(16, _overlayHeight(context), 72, 16);
EdgeInsets _focusPadding(BuildContext context) => EdgeInsets.fromLTRB(48, _overlayHeight(context), 80, 48);

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

  void _fitPoints(List<LatLng> points, double maxZoom) => _map.fitCamera(
    CameraFit.bounds(bounds: LatLngBounds.fromPoints(points), padding: _focusPadding(context), maxZoom: maxZoom),
  );

  void _showCareRoute(CareRouteOnMap? route) {
    if (route == null || !_ready || route.points.length < 2) return;
    _fitPoints(route.points, 16);
  }

  void _fitAll() =>
      _map.fitCamera(CameraFit.bounds(bounds: _latLngBounds(_bundle.manifest.bounds), padding: _fitPadding(context)));

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

  void _openPocket(String id) {
    if (ref.read(mapFullScreenProvider)) {
      ref.read(fullScreenAreaProvider.notifier).state = id;
    } else {
      showAreaSheet(context, ref, id);
    }
  }

  void _fitFlood() {
    ref.read(selectedPocketIdProvider.notifier).state = null;
    ref.read(selectedRouteProvider.notifier).state = null;
    ref.read(highlightedRouteProvider.notifier).state = null;
    _fitAll();
  }

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
    ref.listen<RouteLine?>(selectedRouteProvider, (_, route) {
      if (route != null && _ready && route.points.length > 1) _fitPoints(route.points, 16);
    });
    ref.listen<String?>(routesPanelRequestProvider, (_, pocketId) {
      if (pocketId == null) return;
      // After the tab switch, so the panel opens over the Map.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref.read(routesPanelRequestProvider.notifier).state = null;
        showRoutesPanel(context, focusPocketId: pocketId);
      });
    });
    ref.listen<LocationState>(locationControllerProvider, (before, now) {
      if (before?.position == null && now.position != null) _centreOnMe();
    });
    final l = AppLocalizations.of(context)!;
    final bundle = ref.watch(loadedBundleProvider);
    final full = ref.watch(mapFullScreenProvider);
    // In full screen, Back leaves full screen first.
    return PopScope(
      canPop: !full,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setMapFullScreen(ref, false);
      },
      child: Scaffold(
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
                        initialCameraFit: CameraFit.bounds(
                          bounds: _latLngBounds(bundle.manifest.bounds),
                          padding: _fitPadding(context),
                        ),
                        minZoom: 9,
                        maxZoom: 18,
                        backgroundColor: AppColors.mapBackground,
                        interactionOptions: const InteractionOptions(
                          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                        ),
                        // Debug builds only: a long press sets a test position, for trying Find care on a desktop.
                        onLongPress: kDebugMode
                            ? (_, point) => ref.read(locationControllerProvider.notifier).setTestPosition(point)
                            : null,
                        onMapReady: _onMapReady,
                      ),
                      children: mapLayerList(context, ref, tiles: _tiles, onPocket: _openPocket),
                    ),
                  ),
                  // Each overlay is only as big as what it shows, so the map
                  // around them still takes every pan and tap.
                  Positioned.fill(
                    child: SafeArea(
                      bottom: false,
                      child: full
                          ? FullScreenControls(onLocate: _locate, onFit: _fitFlood, onZoom: _zoom)
                          : Stack(
                              children: [
                                const Positioned(
                                  top: 8,
                                  left: 12,
                                  right: 72,
                                  bottom: 24,
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: SingleChildScrollView(child: MapTopLeft()),
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 12,
                                  bottom: 24,
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: SingleChildScrollView(
                                      child: MapSideButtons(
                                        onLocate: _locate,
                                        onZoom: _zoom,
                                        onFit: _fitFlood,
                                        onFullScreen: () => setMapFullScreen(ref, true),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  if (full)
                    const Positioned(left: 0, right: 0, bottom: 0, child: SafeArea(child: FullScreenAreaCard())),
                ],
              ),
            ),
            if (!full) const MapSummaryCard(),
          ],
        ),
      ),
    );
  }
}
