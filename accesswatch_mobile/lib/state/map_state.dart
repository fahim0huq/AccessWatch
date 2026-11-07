import 'package:flutter_map/flutter_map.dart' show TileProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Everything the layer panel controls, bottom to top. [compare] is the
/// compare.png overlay, which stands in for the three flood layers while on.
enum MapLayer { depthZones, flood, floodEms, floodedRoads, pockets, routes, services, compare }

const _startOff = {MapLayer.floodEms, MapLayer.compare};

const _startOpacity = {
  MapLayer.depthZones: 0.7,
  MapLayer.flood: 0.25,
  MapLayer.floodEms: 0.45,
  MapLayer.floodedRoads: 1.0,
  MapLayer.pockets: 0.35,
  MapLayer.routes: 1.0,
  MapLayer.compare: 0.85,
};

/// Layers with an opacity slider. Services are icons with labels, so they have none.
Iterable<MapLayer> get layersWithOpacity => _startOpacity.keys;

class MapLayersNotifier extends StateNotifier<Set<MapLayer>> {
  MapLayersNotifier() : super(MapLayer.values.toSet().difference(_startOff));

  void setVisible(MapLayer layer, bool visible) {
    state = visible ? {...state, layer} : ({...state}..remove(layer));
  }
}

final mapLayersProvider =
    StateNotifierProvider<MapLayersNotifier, Set<MapLayer>>((ref) => MapLayersNotifier());

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
