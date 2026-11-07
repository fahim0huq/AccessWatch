// TEST FIXTURE ONLY. Never part of the app or its bundle.
//
// The real bundle has 7 clinics and all are reachable, so the "needs a boat" path
// never shows with real data. This fixture swaps in a tiny road graph and one
// clinic on an island that only deep water reaches, inside a cut-off pocket.
import 'dart:typed_data';

import 'package:accesswatch_mobile/data/bundle_repository.dart';
import 'package:accesswatch_mobile/data/models/enums.dart';
import 'package:accesswatch_mobile/data/models/road_graph.dart';
import 'package:accesswatch_mobile/data/models/service_point.dart';
import 'package:latlong2/latlong.dart' show LatLng;

const fixtureClinicName = 'TEST FIXTURE clinic in a cut-off pocket';

class NeedsBoatFixture {
  final AppBundle bundle;

  /// Where to stand: on the dry road, inside the mapped area.
  final LatLng start;

  /// Inside the mapped area but more than 400 m from any road.
  final LatLng farFromRoads;

  const NeedsBoatFixture(this.bundle, this.start, this.farFromRoads);
}

NeedsBoatFixture needsBoatFixture(AppBundle real) {
  final b = real.manifest.bounds;
  final lat = (b.north + b.south) / 2, lon = (b.east + b.west) / 2;
  const all = 1 | 2 | 4;
  // Node 0 - dry road - node 1 - deep water, closed to every mode - node 2 (the island clinic).
  final graph = RoadGraph(
    lon: Float64List.fromList([lon, lon + 0.001, lon + 0.004]),
    lat: Float64List.fromList([lat, lat, lat]),
    u: Int32List.fromList([0, 1]),
    v: Int32List.fromList([1, 2]),
    lengthM: Float64List.fromList([101, 304]),
    depthClass: Uint8List.fromList([0, 3]),
    flags: Uint8List.fromList([all, 0]),
    riskCost: Float64List.fromList([101, 9999]),
    travelTimeMin: Float64List.fromList([0.3, 2.5]),
    flagBits: real.graph.flagBits,
  );
  final clinic = ServicePoint(
    id: 'FIXTURE-C1',
    type: ServiceType.clinic,
    name: fixtureClinicName,
    onNetwork: true,
    clinicStatus: ClinicStatus.insidePocket,
    pocketId: 'P01',
    point: LatLng(lat, lon + 0.004),
  );
  final bundle = AppBundle(
    manifest: real.manifest,
    quality: real.quality,
    flood: real.flood,
    floodBaseline: real.floodBaseline,
    ems: real.ems,
    depthZones: real.depthZones,
    depthLod: real.depthLod,
    pockets: real.pockets,
    routes: real.routes,
    services: [clinic, ...real.services.where((s) => s.type == ServiceType.aidDepot)],
    missions: real.missions,
    graph: graph,
  );
  return NeedsBoatFixture(bundle, LatLng(lat, lon), LatLng(lat - 0.02, lon));
}
