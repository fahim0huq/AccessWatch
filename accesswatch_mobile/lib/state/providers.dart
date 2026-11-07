import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/bundle_repository.dart';

final bundleRepositoryProvider = Provider<BundleRepository>((ref) => BundleRepository());

/// The whole data bundle. Every screen reads from this.
final bundleProvider = FutureProvider<AppBundle>((ref) => ref.watch(bundleRepositoryProvider).load());

/// The loaded bundle, for screens shown only after it has loaded
/// (MainNavigationScreen holds them back until then).
final loadedBundleProvider = Provider<AppBundle>((ref) => ref.watch(bundleProvider).requireValue);

/// `pocket_id` of the selected pocket, or null.
final selectedPocketIdProvider = StateProvider<String?>((ref) => null);

/// null follows the device language.
final localeProvider = StateProvider<Locale?>((ref) => null);

/// App text size on top of the device setting, 1.0 to [maxTextScale].
const minTextScale = 1.0;
const maxTextScale = 2.0;
final textScaleProvider = StateProvider<double>((ref) => minTextScale);

/// Hides the bottom navigation for screen recording.
final presentationModeProvider = StateProvider<bool>((ref) => false);

enum MapLayer { depthZones, flood, floodEms, pockets, routes, services }

/// Which map layers are switched on. The official EMS layer starts off.
class MapLayersNotifier extends StateNotifier<Set<MapLayer>> {
  MapLayersNotifier() : super(MapLayer.values.toSet()..remove(MapLayer.floodEms));

  void setVisible(MapLayer layer, bool visible) {
    state = visible ? {...state, layer} : ({...state}..remove(layer));
  }
}

final mapLayersProvider =
    StateNotifierProvider<MapLayersNotifier, Set<MapLayer>>((ref) => MapLayersNotifier());
