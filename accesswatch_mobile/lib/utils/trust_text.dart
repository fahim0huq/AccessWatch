// Plain-language text for the Data and trust screen, built from quality.json and
// the manifest. The notebook's English limit sentences are matched to translated ones.
import '../data/models/manifest.dart';
import '../data/models/quality.dart';
import '../l10n/app_localizations.dart';
import 'labels.dart';

enum LimitTopic { depth, radar, roads, population, boat, thresholds }

/// Keywords that identify each limit in `report.limitations`.
const _limitKeywords = {
  LimitTopic.depth: 'depth is an estimate',
  LimitTopic.radar: 'thresholds detect open water',
  LimitTopic.roads: 'OSM completeness',
  LimitTopic.population: 'Population is',
  LimitTopic.boat: 'boat route follows',
  LimitTopic.thresholds: 'thresholds are adjustable',
};

/// A limit from the report: a known topic, or one the app has no translation for yet.
class Limit {
  final LimitTopic? topic;
  final String source;

  const Limit(this.topic, this.source);
}

List<Limit> limitsOf(Quality quality) => [
      for (final text in quality.limitations)
        Limit(
          _limitKeywords.entries.where((e) => text.contains(e.value)).map((e) => e.key).firstOrNull,
          text,
        ),
    ];

extension TrustText on AppLocalizations {
  String limitText(Limit limit, Quality quality, Fmt fmt) => switch (limit.topic) {
        LimitTopic.depth => limitDepth,
        LimitTopic.radar => limitRadar,
        LimitTopic.roads =>
          limitRoads(fmt.oneDecimal(quality.buildingsNearRoadPercent), fmt.count(quality.disconnectedRoadFragments)),
        LimitTopic.population => limitPopulation,
        LimitTopic.boat => limitBoat,
        LimitTopic.thresholds => limitThresholds,
        // Shown rather than hidden: the text exists only in English for now.
        null => limitUntranslated(limit.source),
      };

  /// Every known issue in quality.json `notes`, plus report figures that disagree with the data.
  List<String> knownIssues(Quality quality, Fmt fmt) {
    final notes = quality.notes;
    return [
      for (final pair in notes.rankPopulationInversions) issueRankInversion(pair[0], pair[1]),
      if (notes.pocketsWhereSafestDiffersInRoutes != quality.reportSafestDiffers)
        issueSafestCount(fmt.count(quality.reportSafestDiffers), fmt.count(notes.pocketsWhereSafestDiffersInRoutes)),
      if (notes.roadPiecesOutsideRaster > 0)
        issueRoadsOutsideCoverage(fmt.count(notes.roadPiecesOutsideRaster), fmt.count(notes.roadPiecesOutsideRasterLabelledDry)),
      for (final entry in notes.pocketShareOutsideRaster.entries)
        issuePocketOutsideCoverage(entry.key, fmt.oneDecimal(entry.value * 100)),
      if (notes.clinicRecordPairsWithin100m > 0)
        issueClinicDuplicates(fmt.count(notes.clinicRecords), fmt.count(notes.clinicRecordPairsWithin100m)),
    ];
  }

  /// The plain statement for Compare mode and the trust screen.
  String calibrationNote(Manifest manifest, Quality quality, Fmt fmt) => compareNotIndependent(
        fmt.score(manifest.compare.iou),
        fmt.score(quality.classifierCvIou),
        fmt.score(quality.thresholdMapIou),
      );
}
