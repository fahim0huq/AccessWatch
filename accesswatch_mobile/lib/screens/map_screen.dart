import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart' show LatLng;

import '../data/bundle_repository.dart';
import '../data/models/manifest.dart';
import '../l10n/app_localizations.dart';
import '../state/location.dart';
import '../state/map_state.dart';
import '../state/providers.dart';
import '../theme/app_theme.dart';
import '../widgets/map/feature_layers.dart';
import '../widgets/map/flood_layers.dart';
import '../widgets/map/layer_panel.dart';
import '../widgets/map/map_chrome.dart';
import '../widgets/map/map_bottom_panel.dart';
import '../widgets/map/map_legend.dart';
import '../widgets/map/map_sheets.dart';
import '../widgets/quality_banners.dart';

const _tileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
const _userAgentPackage = 'com.accesswatch.app.accesswatch_mobile';
// Room on the right for the floating buttons, so nothing fitted sits under them.
const _fitPadding = EdgeInsets.fromLTRB(12, 12, 68, 24);

LatLngBounds _latLngBounds(GeoBounds b) => LatLngBounds(LatLng(b.south, b.west), LatLng(b.north, b.east));

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final _map = MapController();
  // Kept across rebuilds: each new TileLayer would bring its own tile provider and client.
  late final _tiles = TileLayer(
    urlTemplate: _tileUrl,
    userAgentPackageName: _userAgentPackage,
    maxNativeZoom: 19,
    tileProvider: ref.read(mapTileProvider),
  );
  bool _ready = false;
  bool _bannersOpen = false;
  bool _legendOpen = false;
  bool _wantsLocation = false;
  LatLng? _me;
  StreamSubscription<LatLng>? _positions;

  AppBundle get _bundle => ref.read(loadedBundleProvider);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // The tab stays alive while hidden: GPS only runs while it is on screen.
    if (!TickerMode.valuesOf(context).enabled) {
      _stopPositions();
    } else if (_wantsLocation) {
      _startPositions();
    }
  }

  @override
  void dispose() {
    _stopPositions();
    _map.dispose();
    super.dispose();
  }

  void _stopPositions() {
    _positions?.cancel();
    _positions = null;
  }

  void _startPositions() {
    _positions ??= ref.read(locationSourceProvider).positions().listen((position) {
      if (!mounted) return;
      final first = _me == null;
      setState(() => _me = position);
      if (first) _centreOnMe();
    }, onError: (Object _) => _stopPositions());
  }

  void _say(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _centreOnMe() {
    final me = _me;
    if (me == null) return;
    if (_latLngBounds(_bundle.manifest.boundsAll).contains(me)) {
      _map.move(me, 15);
    } else {
      _say(AppLocalizations.of(context)!.locationOutside);
    }
  }

  Future<void> _locate() async {
    final l = AppLocalizations.of(context)!;
    final issue = await ref.read(locationSourceProvider).prepare();
    if (!mounted) return;
    switch (issue) {
      case LocationIssue.serviceOff:
        _say(l.locationOff);
      case LocationIssue.denied:
        _say(l.locationDenied);
      case null:
        _wantsLocation = true;
        _startPositions();
        _centreOnMe();
    }
  }

  void _fitAll() => _map.fitCamera(CameraFit.bounds(
        bounds: _latLngBounds(_bundle.manifest.bounds),
        padding: _fitPadding,
      ));

  void _focus(String? pocketId) {
    if (!_ready) return;
    if (pocketId == null) {
      _fitAll();
      return;
    }
    final pocket = _bundle.pockets.firstWhere((p) => p.id == pocketId);
    final points = [for (final polygon in pocket.polygons) ...polygon.outer];
    _map.fitCamera(CameraFit.bounds(
      bounds: LatLngBounds.fromPoints(points),
      padding: const EdgeInsets.fromLTRB(48, 48, 80, 48),
      maxZoom: 15,
    ));
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
    ref.read(selectedPocketIdProvider.notifier).state = id;
    showPocketSheet(context, ref, id);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String?>(selectedPocketIdProvider, (_, id) => _focus(id));
    final l = AppLocalizations.of(context)!;
    final bundle = ref.watch(loadedBundleProvider);
    final layers = ref.watch(mapLayersProvider);
    final compare = layers.contains(MapLayer.compare);
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Scrolls within a cap, so large text can never squeeze the map away.
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: height * 0.4),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    MapHeader(
                      bannersOpen: _bannersOpen,
                      onToggleBanners: () => setState(() => _bannersOpen = !_bannersOpen),
                    ),
                    if (compare) const CompareLegend(),
                    if (_bannersOpen) const QualityBanners(padding: EdgeInsets.fromLTRB(8, 0, 8, 2)),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _map,
                    options: MapOptions(
                      // Set as well as the fit, so even the very first tile requests
                      // are for this area and not the library's default centre.
                      initialCenter: _latLngBounds(bundle.manifest.bounds).center,
                      initialZoom: 12,
                      initialCameraFit: CameraFit.bounds(
                        bounds: _latLngBounds(bundle.manifest.bounds),
                        padding: _fitPadding,
                      ),
                      minZoom: 9,
                      maxZoom: 18,
                      backgroundColor: AppColors.surfaceElevated,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                      ),
                      onMapReady: () {
                        _ready = true;
                        final selected = ref.read(selectedPocketIdProvider);
                        if (selected != null) {
                          _focus(selected);
                        } else {
                          _loadFittedTiles();
                        }
                      },
                    ),
                    children: [
                      if (ref.watch(showBaseTilesProvider)) _tiles,
                      if (compare)
                        OverlayImageLayer(overlayImages: [
                          OverlayImage(
                            bounds: _latLngBounds(bundle.manifest.bounds),
                            imageProvider: const AssetImage(BundleRepository.compareImageAsset),
                            opacity: ref.watch(mapOpacityProvider)[MapLayer.compare]!,
                            filterQuality: FilterQuality.none,
                          ),
                        ])
                      else ...[
                        if (layers.contains(MapLayer.depthZones)) const DepthZonesLayer(),
                        if (layers.contains(MapLayer.flood)) const FloodLayer(),
                        if (layers.contains(MapLayer.floodBaseline)) const BaselineFloodLayer(),
                        if (layers.contains(MapLayer.floodEms)) const EmsFloodLayer(),
                      ],
                      if (layers.contains(MapLayer.floodedRoads)) const FloodedRoadsLayer(),
                      if (layers.contains(MapLayer.pockets)) PocketAreasLayer(onTap: (p) => _openPocket(p.id)),
                      if (layers.contains(MapLayer.routes)) RoutesLayer(onTap: (r) => showRoutesSheet(context, r)),
                      if (layers.contains(MapLayer.pockets)) PocketLabelsLayer(onTap: (p) => _openPocket(p.id)),
                      if (layers.contains(MapLayer.services))
                        ServicesLayer(onTap: (s) => showServiceSheet(context, ref, s)),
                      if (_me != null) MyLocationLayer(position: _me!),
                      const OsmAttribution(),
                    ],
                  ),
                  MapControls(
                    compare: compare,
                    onLayers: () => showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const LayerPanel(),
                    ),
                    onCompare: () {
                      // The compare panel takes the banners' place so the map stays large.
                      if (!compare) setState(() => _bannersOpen = false);
                      ref.read(mapLayersProvider.notifier).setVisible(MapLayer.compare, !compare);
                    },
                    onLocate: _locate,
                    onZoomIn: () => _zoom(1),
                    onZoomOut: () => _zoom(-1),
                    onFit: _fitAll,
                  ),
                  Positioned(
                    left: 8,
                    bottom: 30,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_legendOpen)
                          ConstrainedBox(constraints: BoxConstraints(maxHeight: height * 0.4), child: const MapLegend()),
                        const SizedBox(height: 6),
                        ActionChip(
                          avatar: Icon(_legendOpen ? Icons.close_rounded : Icons.legend_toggle_rounded, size: 16, color: AppColors.accent),
                          label: Text(l.tooltipLegend, style: const TextStyle(color: AppColors.text, fontSize: 12)),
                          backgroundColor: AppColors.surface,
                          onPressed: () => setState(() => _legendOpen = !_legendOpen),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            MapBottomPanel(onOpenPocket: _openPocket),
          ],
        ),
      ),
    );
  }
}
