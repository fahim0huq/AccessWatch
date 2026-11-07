import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

enum LocationIssue { serviceOff, denied }

/// Device position. Behind an interface so tests can supply positions.
abstract class LocationSource {
  /// Whether the app may already read the position, without asking.
  Future<bool> isPermitted();

  /// Asks for permission if needed. Returns the problem, or null when usable.
  Future<LocationIssue?> prepare();

  Stream<LatLng> positions();
}

class GeolocatorSource implements LocationSource {
  @override
  Future<bool> isPermitted() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

  @override
  Future<LocationIssue?> prepare() async {
    if (!await Geolocator.isLocationServiceEnabled()) return LocationIssue.serviceOff;
    if (await isPermitted()) return null;
    await Geolocator.requestPermission();
    return await isPermitted() ? null : LocationIssue.denied;
  }

  @override
  Stream<LatLng> positions() => Geolocator.getPositionStream().map((p) => LatLng(p.latitude, p.longitude));
}

final locationSourceProvider = Provider<LocationSource>((ref) => GeolocatorSource());

class LocationState {
  final LatLng? position;

  /// Set by hand in a debug build; never from GPS.
  final bool isTestPosition;

  /// The user asked for their position on Map or Care.
  final bool wanted;

  const LocationState({this.position, this.isTestPosition = false, this.wanted = false});
}

/// One position for the whole app. GPS runs only while the user wants it and a
/// screen that shows it (Map or Care) is on screen.
class LocationController extends StateNotifier<LocationState> {
  final LocationSource _source;
  final _visibleScreens = <Object>{};
  StreamSubscription<LatLng>? _updates;

  LocationController(this._source) : super(const LocationState());

  bool get isListening => _updates != null;

  /// Call after the user has seen why the app asks. Returns the problem, if any.
  Future<LocationIssue?> start() async {
    final issue = await _source.prepare();
    if (issue != null || !mounted) return issue;
    state = LocationState(position: state.isTestPosition ? null : state.position, wanted: true);
    _sync();
    return null;
  }

  /// Map and Care report whether they are on screen. Changes no state, so it is
  /// safe to call while widgets build.
  void setVisible(Object screen, bool visible) {
    visible ? _visibleScreens.add(screen) : _visibleScreens.remove(screen);
    _sync();
  }

  /// A fixed position for trying the app on a desktop. Debug builds only.
  void setTestPosition(LatLng position) {
    if (!kDebugMode) return;
    state = LocationState(position: position, isTestPosition: true);
    _sync();
  }

  void _sync() {
    final run = state.wanted && _visibleScreens.isNotEmpty;
    if (run && _updates == null) {
      _updates = _source.positions().listen(
            (p) => state = LocationState(position: p, wanted: true),
            onError: (Object _) => _stop(),
          );
    } else if (!run) {
      _stop();
    }
  }

  void _stop() {
    _updates?.cancel();
    _updates = null;
  }

  @override
  void dispose() {
    _stop();
    super.dispose();
  }
}

final locationControllerProvider = StateNotifierProvider<LocationController, LocationState>(
  (ref) => LocationController(ref.watch(locationSourceProvider)),
);
