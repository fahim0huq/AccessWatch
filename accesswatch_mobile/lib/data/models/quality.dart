import 'enums.dart';

class EmsInfo {
  final String product, layer, imageSensor;
  final DateTime imageTime;
  final double hoursAfterNisarAfter, aoiShareOfBounds;

  const EmsInfo({
    required this.product,
    required this.layer,
    required this.imageSensor,
    required this.imageTime,
    required this.hoursAfterNisarAfter,
    required this.aoiShareOfBounds,
  });

  factory EmsInfo.fromJson(Map<String, dynamic> j) => EmsInfo(
        product: j['product'] as String,
        layer: j['layer'] as String,
        imageSensor: j['image_sensor'] as String,
        imageTime: DateTime.parse(j['image_time'] as String),
        hoursAfterNisarAfter: (j['hours_after_nisar_after'] as num).toDouble(),
        aoiShareOfBounds: (j['aoi_share_of_bounds'] as num).toDouble(),
      );
}

class QualityNotes {
  final int roadPiecesOutsideRaster, roadPiecesOutsideRasterLabelledDry;
  final Map<String, double> pocketShareOutsideRaster;
  final int pocketsWhereSafestDiffersInRoutes;

  /// Pairs: the first pocket ranks above the second despite equal terms and fewer people.
  final List<List<String>> rankPopulationInversions;
  final int clinicRecords, clinicRecordPairsWithin100m;

  const QualityNotes({
    required this.roadPiecesOutsideRaster,
    required this.roadPiecesOutsideRasterLabelledDry,
    required this.pocketShareOutsideRaster,
    required this.pocketsWhereSafestDiffersInRoutes,
    required this.rankPopulationInversions,
    required this.clinicRecords,
    required this.clinicRecordPairsWithin100m,
  });

  factory QualityNotes.fromJson(Map<String, dynamic> j) => QualityNotes(
        roadPiecesOutsideRaster: j['road_pieces_outside_raster'] as int,
        roadPiecesOutsideRasterLabelledDry: j['road_pieces_outside_raster_labelled_dry'] as int,
        pocketShareOutsideRaster: {
          for (final e in (j['pocket_share_outside_raster'] as Map<String, dynamic>).entries)
            e.key: (e.value as num).toDouble(),
        },
        pocketsWhereSafestDiffersInRoutes: j['pockets_where_safest_differs_in_routes'] as int,
        rankPopulationInversions: [
          for (final pair in j['rank_population_inversions'] as List<dynamic>)
            (pair as List<dynamic>).cast<String>(),
        ],
        clinicRecords: j['clinic_records'] as int,
        clinicRecordPairsWithin100m: j['clinic_record_pairs_within_100m'] as int,
      );
}

/// One entry of `sources` that names a data source (not a method or a note).
class DataSource {
  final String name;
  final String? url, doi, licence;

  const DataSource(this.name, {this.url, this.doi, this.licence});
}

class Quality {
  /// Entries of `sources` that describe methods or notes, not data sources.
  static const _notDataSources = {
    'Aid depot',
    'Validation reference',
    'validation_reference',
    'classifier_refinement',
    'flood_method',
  };

  final Set<QualityFlag> flags;

  /// Original English flag text. Traceability only: never shown in the app.
  final List<String> sourceFlags;
  final EmsInfo ems;
  final QualityNotes notes;

  /// `validation_report.json` and `DATA_SOURCES.json`, verbatim.
  final Map<String, dynamic> report, sources;

  const Quality({
    required this.flags,
    required this.sourceFlags,
    required this.ems,
    required this.notes,
    required this.report,
    required this.sources,
  });

  factory Quality.fromJson(Map<String, dynamic> j) => Quality(
        flags: QualityFlag.activeIn(j['flags'] as Map<String, dynamic>),
        sourceFlags: (j['source_flags'] as List<dynamic>).cast<String>(),
        ems: EmsInfo.fromJson(j['ems'] as Map<String, dynamic>),
        notes: QualityNotes.fromJson(j['notes'] as Map<String, dynamic>),
        report: j['report'] as Map<String, dynamic>,
        sources: j['sources'] as Map<String, dynamic>,
      );

  double _score(Map<String, dynamic> root, List<String> path) {
    Object? node = root;
    for (final key in path) {
      node = (node as Map<String, dynamic>)[key];
    }
    return (node as num).toDouble();
  }

  /// Spatial cross-validation IoU of the flood classifier adopted for the map.
  double get classifierCvIou => _score(sources, const ['classifier_refinement', 'classifier_cv', 'IoU']);

  /// IoU of the plain threshold map it replaced.
  double get thresholdMapIou => _score(sources, const ['classifier_refinement', 'threshold_map', 'IoU']);

  /// Flood map against the EMS reference (not independent: see the flags).
  double get floodVsReferenceIou => _score(report, const ['flood_vs_reference', 'IoU']);

  String? get nisarMaturity => (sources['NISAR GCOV'] as Map<String, dynamic>?)?['maturity'] as String?;

  List<DataSource> get dataSources => [
        for (final e in sources.entries)
          if (!_notDataSources.contains(e.key) && e.value is Map<String, dynamic>)
            DataSource(
              e.key,
              url: (e.value as Map<String, dynamic>)['url'] as String?,
              doi: (e.value as Map<String, dynamic>)['doi'] as String?,
              licence: (e.value as Map<String, dynamic>)['licence'] as String?,
            ),
      ];
}
