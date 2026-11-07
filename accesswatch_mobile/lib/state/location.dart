import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

enum LocationIssue { serviceOff, denied }

/// Device position. Behind an interface so tests can supply a fixed position.
abstract class LocationSource {
  /// Asks for permission if needed. Returns the problem, or null when usable.
  Future<LocationIssue?> prepare();

  Stream<LatLng> positions();
}

class GeolocatorSource implements LocationSource {
  @override
  Future<LocationIssue?> prepare() async {
    if (!await Geolocator.isLocationServiceEnabled()) return LocationIssue.serviceOff;
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    final granted = permission == LocationPermission.always || permission == LocationPermission.whileInUse;
    return granted ? null : LocationIssue.denied;
  }

  @override
  Stream<LatLng> positions() => Geolocator.getPositionStream().map((p) => LatLng(p.latitude, p.longitude));
}

final locationSourceProvider = Provider<LocationSource>((ref) => GeolocatorSource());
