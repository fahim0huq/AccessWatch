// Watch an area: the local event list, which one is watched, and the box
// picked on the map. No network calls.
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_map/flutter_map.dart' show LatLngBounds;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart' show LatLng;

import '../data/models/manifest.dart';
import '../data/models/watch_event.dart';
import 'providers.dart';

const watchEventsAsset = 'assets/events/events.json';

final watchEventsProvider = FutureProvider<List<WatchEvent>>((ref) async {
  final text = await rootBundle.loadString(watchEventsAsset);
  return parseWatchEvents(jsonDecode(text) as Map<String, dynamic>);
});

/// Events that have satellite data in this build.
final availableEventsProvider = Provider<List<WatchEvent>>(
  (ref) => [
    for (final e in ref.watch(watchEventsProvider).valueOrNull ?? const <WatchEvent>[])
      if (e.hasBundleData) e,
  ],
);

final watchKindProvider = StateProvider<EventKind>((ref) => EventKind.flood);
final watchQueryProvider = StateProvider<String>((ref) => '');

/// The watched event: chosen, or the first one with data.
final watchedEventIdProvider = StateProvider<String?>((ref) => null);
final watchedEventProvider = Provider<WatchEvent?>((ref) {
  final available = ref.watch(availableEventsProvider);
  final id = ref.watch(watchedEventIdProvider);
  return available.where((e) => e.id == id).firstOrNull ?? available.firstOrNull;
});

/// The Map is in "select an area" mode.
final mapSelectingProvider = StateProvider<bool>((ref) => false);

/// The box picked on the map, if any.
final watchSelectionProvider = StateProvider<LatLngBounds?>((ref) => null);

/// Asks the Map to fit the flood area (a counter, so each request is new).
final mapFitRequestProvider = StateProvider<int>((ref) => 0);

LatLngBounds boundsOf(GeoBounds b) => LatLngBounds(LatLng(b.south, b.west), LatLng(b.north, b.east));

/// The event with data whose area the box overlaps, or null.
WatchEvent? eventForSelection(LatLngBounds box, List<WatchEvent> available, Manifest manifest) {
  final area = boundsOf(manifest.boundsAll);
  return box.isOverlapping(area) ? available.where((e) => e.hasBundleData).firstOrNull : null;
}

/// Watch [event]: leave selection mode and ask the Map to show its flood area.
void watchEvent(WidgetRef ref, WatchEvent event) {
  ref.read(watchedEventIdProvider.notifier).state = event.id;
  ref.read(mapSelectingProvider.notifier).state = false;
  ref.read(selectedPocketIdProvider.notifier).state = null;
  ref.read(mapFitRequestProvider.notifier).state++;
}
