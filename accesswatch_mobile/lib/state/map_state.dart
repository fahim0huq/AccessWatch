import 'package:flutter_map/flutter_map.dart' show TileProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings_store.dart';

/// Every map layer, bottom to top. [compare] is the compare.png overlay, which
/// stands in for the flood layers while on. Places are one layer per type.
enum MapLayer {
  depthZones,
  flood,
  floodBaseline,
  floodEms,
  allRoads,
  floodedRoads,
  pockets,
  routes,
  clinics,
  markets,
  shelters,
  depot,
  compare,
}

/// The default view: flood water and cut-off areas, everything else off.
final defaultMapLayers = {MapLayer.flood, MapLayer.pockets};

/// Below this zoom the depth classes would only be noise over the flood.
const depthZonesMinZoom = 13.5;

const _startOpacity = {
  MapLayer.depthZones: 0.7,
  MapLayer.flood: 0.55,
  MapLayer.floodBaseline: 0.45,
  MapLayer.floodEms: 0.45,
  MapLayer.allRoads: 0.9,
  MapLayer.floodedRoads: 1.0,
  MapLayer.pockets: 0.4,
  MapLayer.routes: 1.0,
  MapLayer.compare: 0.85,
};

/// Layers with an opacity slider. Places are icons with labels, so they have none.
Iterable<MapLayer> get layersWithOpacity => _startOpacity.keys;

/// The saved layer choice; names it does not know are skipped. Null if none saved.
Set<MapLayer>? readMapLayers(SharedPreferences prefs) {
  final names = prefs.getStringList(SettingsKeys.mapLayers);
  if (names == null) return null;
  final byName = {for (final layer in MapLayer.values) layer.name: layer};
  return {for (final name in names) if (byName[name] != null) byName[name]!};
}

class MapLayersNotifier extends StateNotifier<Set<MapLayer>> {
  MapLayersNotifier([Set<MapLayer>? saved]) : super(saved ?? {...defaultMapLayers});

  void setVisible(MapLayer layer, bool visible) {
    state = visible ? {...state, layer} : ({...state}..remove(layer));
  }

  void setAll(Iterable<MapLayer> layers, bool visible) {
    state = visible ? {...state, ...layers} : ({...state}..removeAll(layers));
  }

  void reset() => state = {...defaultMapLayers};
}

final mapLayersProvider = StateNotifierProvider<MapLayersNotifier, Set<MapLayer>>(
    (ref) => MapLayersNotifier(readMapLayers(ref.watch(sharedPreferencesProvider))));

class MapOpacityNotifier extends StateNotifier<Map<MapLayer, double>> {
  MapOpacityNotifier() : super(_startOpacity);

  void set(MapLayer layer, double value) => state = {...state, layer: value};
}

final mapOpacityProvider =
    StateNotifierProvider<MapOpacityNotifier, Map<MapLayer, double>>((ref) => MapOpacityNotifier());

/// Tests switch this off so they make no network calls.
final showBaseTilesProvider = Provider<bool>((ref) => true);

/// null uses the map's normal network tiles. Tests supply a recording provider.
final mapTileProvider = Provider<TileProvider?>((ref) => null);

/// Full-screen map: the bottom bar and the summary card are hidden.
final mapFullScreenProvider = StateProvider<bool>((ref) => false);
