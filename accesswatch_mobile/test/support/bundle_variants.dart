import 'package:accesswatch_mobile/data/bundle_repository.dart';
import 'package:accesswatch_mobile/data/models/enums.dart';
import 'package:accesswatch_mobile/data/models/manifest.dart';

/// The real bundle with a different set of quality flags.
AppBundle withFlags(AppBundle b, Set<QualityFlag> flags) {
  final m = b.manifest;
  return AppBundle(
    manifest: Manifest(
      schemaVersion: m.schemaVersion,
      event: m.event,
      syntheticDemo: m.syntheticDemo,
      bounds: m.bounds,
      boundsAll: m.boundsAll,
      dates: m.dates,
      qualityFlags: flags,
      depthClasses: m.depthClasses,
      compare: m.compare,
      graph: m.graph,
      stats: m.stats,
      files: m.files,
    ),
    quality: b.quality,
    flood: b.flood,
    floodBaseline: b.floodBaseline,
    ems: b.ems,
    depthZones: b.depthZones,
    depthLod: b.depthLod,
    pockets: b.pockets,
    routes: b.routes,
    services: b.services,
    missions: b.missions,
    graph: b.graph,
  );
}
