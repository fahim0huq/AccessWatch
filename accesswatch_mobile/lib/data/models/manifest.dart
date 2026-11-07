import 'enums.dart';

double _d(Object? v) => (v as num).toDouble();

class GeoBounds {
  final double west, south, east, north;

  const GeoBounds(this.west, this.south, this.east, this.north);

  factory GeoBounds.fromJson(Map<String, dynamic> j) =>
      GeoBounds(_d(j['west']), _d(j['south']), _d(j['east']), _d(j['north']));
}

class BundleDates {
  final DateTime nisarBefore, nisarAfter, emsImage;
  final double emsHoursAfterNisar;

  /// Local notebook time without a zone, kept as text.
  final String notebookGenerated;

  const BundleDates({
    required this.nisarBefore,
    required this.nisarAfter,
    required this.emsImage,
    required this.emsHoursAfterNisar,
    required this.notebookGenerated,
  });

  factory BundleDates.fromJson(Map<String, dynamic> j) => BundleDates(
        nisarBefore: DateTime.parse(j['nisar_before'] as String),
        nisarAfter: DateTime.parse(j['nisar_after'] as String),
        emsImage: DateTime.parse(j['ems_image'] as String),
        emsHoursAfterNisar: _d(j['ems_hours_after_nisar']),
        notebookGenerated: j['notebook_generated'] as String,
      );
}

/// Limits of the depth classes in metres. Depth itself remains an estimate.
class DepthClasses {
  final double shallowMaxM, mediumMinM, mediumMaxM, deepMinM;

  /// Where the limits came from, for the Data and trust screen.
  final String source;

  const DepthClasses({
    required this.shallowMaxM,
    required this.mediumMinM,
    required this.mediumMaxM,
    required this.deepMinM,
    required this.source,
  });

  factory DepthClasses.fromJson(Map<String, dynamic> j) {
    Map<String, dynamic> cls(String name) => j[name] as Map<String, dynamic>;
    return DepthClasses(
      shallowMaxM: _d(cls('shallow')['max_m']),
      mediumMinM: _d(cls('medium')['min_m']),
      mediumMaxM: _d(cls('medium')['max_m']),
      deepMinM: _d(cls('deep')['min_m']),
      source: j['source'] as String,
    );
  }
}

class CompareInfo {
  final int both, onlyOurs, onlyEms, ourFloodPixelsOutsideEmsArea;
  final double pixelAreaM2, iou;
  final int imageWidth, imageHeight;

  /// `both`, `only_ours`, `only_ems` -> `#RRGGBB`.
  final Map<String, String> colors;

  const CompareInfo({
    required this.both,
    required this.onlyOurs,
    required this.onlyEms,
    required this.ourFloodPixelsOutsideEmsArea,
    required this.pixelAreaM2,
    required this.iou,
    required this.imageWidth,
    required this.imageHeight,
    required this.colors,
  });

  factory CompareInfo.fromJson(Map<String, dynamic> j) {
    final px = j['pixels'] as Map<String, dynamic>;
    final image = j['image'] as Map<String, dynamic>;
    return CompareInfo(
      both: px['both'] as int,
      onlyOurs: px['only_ours'] as int,
      onlyEms: px['only_ems'] as int,
      ourFloodPixelsOutsideEmsArea: j['our_flood_pixels_outside_ems_area'] as int,
      pixelAreaM2: _d(j['pixel_area_m2']),
      iou: _d(j['iou']),
      imageWidth: image['width'] as int,
      imageHeight: image['height'] as int,
      colors: (j['colors'] as Map<String, dynamic>).cast<String, String>(),
    );
  }
}

class ComponentCount {
  final int components, largest;

  const ComponentCount(this.components, this.largest);

  factory ComponentCount.fromJson(Map<String, dynamic> j) =>
      ComponentCount(j['components'] as int, j['largest'] as int);
}

class GraphInfo {
  final int nodes, edges, selfLoopsDropped, routesReplayed;
  final Map<String, ComponentCount> connectivity;

  const GraphInfo({
    required this.nodes,
    required this.edges,
    required this.selfLoopsDropped,
    required this.routesReplayed,
    required this.connectivity,
  });

  factory GraphInfo.fromJson(Map<String, dynamic> j) => GraphInfo(
        nodes: j['nodes'] as int,
        edges: j['edges'] as int,
        selfLoopsDropped: j['self_loops_dropped'] as int,
        routesReplayed: j['routes_replayed'] as int,
        connectivity: {
          for (final e in (j['connectivity'] as Map<String, dynamic>).entries)
            e.key: ComponentCount.fromJson(e.value as Map<String, dynamic>),
        },
      );
}

class BundleStats {
  final double floodAreaKm2;
  final int pockets, populationEstimate;
  final Map<AccessMode, int> pocketsByAccessMode;
  final int floodedShallow, floodedMedium, floodedDeep;
  final Map<ClinicStatus, int> clinicStatus;

  const BundleStats({
    required this.floodAreaKm2,
    required this.pockets,
    required this.populationEstimate,
    required this.pocketsByAccessMode,
    required this.floodedShallow,
    required this.floodedMedium,
    required this.floodedDeep,
    required this.clinicStatus,
  });

  factory BundleStats.fromJson(Map<String, dynamic> j) {
    final roads = j['flooded_road_pieces'] as Map<String, dynamic>;
    return BundleStats(
      floodAreaKm2: _d(j['flood_area_km2']),
      pockets: j['pockets'] as int,
      populationEstimate: j['population_estimate'] as int,
      pocketsByAccessMode: {
        for (final e in (j['pockets_by_access_mode'] as Map<String, dynamic>).entries)
          AccessMode.parse(e.key): e.value as int,
      },
      floodedShallow: roads['shallow'] as int,
      floodedMedium: roads['medium'] as int,
      floodedDeep: roads['deep'] as int,
      clinicStatus: {
        for (final e in (j['clinic_status'] as Map<String, dynamic>).entries)
          ClinicStatus.parse(e.key): e.value as int,
      },
    );
  }
}

class BundleFile {
  final String sha256;
  final int size;

  const BundleFile(this.sha256, this.size);
}

class Manifest {
  final int schemaVersion;
  final String event;
  final bool syntheticDemo;
  final GeoBounds bounds, boundsAll;
  final BundleDates dates;
  final Set<QualityFlag> qualityFlags;
  final DepthClasses depthClasses;
  final CompareInfo compare;
  final GraphInfo graph;
  final BundleStats stats;
  final Map<String, BundleFile> files;

  const Manifest({
    required this.schemaVersion,
    required this.event,
    required this.syntheticDemo,
    required this.bounds,
    required this.boundsAll,
    required this.dates,
    required this.qualityFlags,
    required this.depthClasses,
    required this.compare,
    required this.graph,
    required this.stats,
    required this.files,
  });

  factory Manifest.fromJson(Map<String, dynamic> j) => Manifest(
        schemaVersion: j['schema_version'] as int,
        event: j['event'] as String,
        syntheticDemo: j['synthetic_demo'] as bool,
        bounds: GeoBounds.fromJson(j['bounds'] as Map<String, dynamic>),
        boundsAll: GeoBounds.fromJson(j['bounds_all'] as Map<String, dynamic>),
        dates: BundleDates.fromJson(j['dates'] as Map<String, dynamic>),
        qualityFlags: QualityFlag.activeIn(j['quality_flags'] as Map<String, dynamic>),
        depthClasses: DepthClasses.fromJson(j['depth_classes'] as Map<String, dynamic>),
        compare: CompareInfo.fromJson(j['compare'] as Map<String, dynamic>),
        graph: GraphInfo.fromJson(j['graph'] as Map<String, dynamic>),
        stats: BundleStats.fromJson(j['stats'] as Map<String, dynamic>),
        files: {
          for (final e in (j['files'] as Map<String, dynamic>).entries)
            e.key: BundleFile(
              (e.value as Map<String, dynamic>)['sha256'] as String,
              (e.value as Map<String, dynamic>)['size'] as int,
            ),
        },
      );
}
