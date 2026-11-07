// Mission text built from the fields, in the current language. The notebook's
// ready-made English text is not in the bundle.
import '../data/mission_ranking.dart';
import '../data/models/enums.dart';
import '../data/models/manifest.dart';
import '../data/verify_notes.dart';
import '../l10n/app_localizations.dart';
import 'labels.dart';

extension MissionText on AppLocalizations {
  String verifyNote(VerifyNote note, Fmt fmt) => switch (note.kind) {
        VerifyNoteKind.bridges => verifyBridges(note.bridges!),
        VerifyNoteKind.lowConfidence => verifyLowConfidence,
        VerifyNoteKind.boatRoute => verifyBoatRoute,
        VerifyNoteKind.unstable => verifyUnstable,
        VerifyNoteKind.shortestDeep => verifyShortestDeep(fmt.km(note.shortestKm!)),
        VerifyNoteKind.depotAutoSelected => warnDepotAutoSelected,
        VerifyNoteKind.estimates => verifyEstimates,
      };

  String serviceAccess(ServiceAccess access) => switch (access) {
        ServiceAccess.yes => accessYes,
        ServiceAccess.difficult => accessDifficult,
        ServiceAccess.no => accessNo,
        ServiceAccess.notApplicable => accessNotApplicable,
      };

  /// The field alert. Current rank, with a note when the weights were changed,
  /// and always the data date, so an old alert cannot pass for current news.
  String alertText(RankedMission ranked, PriorityWeights weights, Manifest manifest, Fmt fmt) {
    final m = ranked.mission;
    final mode = accessMode(m.accessMode);
    return [
      alertHeadline(fmt.count(ranked.rank), m.pocketId, missionTitle(m), fmt.count(m.population)),
      alertNeeds(m.boatLegKm > 0 ? alertBoatLeg(mode, fmt.km(m.boatLegKm)) : mode),
      alertRoute(fmt.km(m.safest.distanceKm), riskLevel(m.riskLevel), confidence(m.confidence)),
      alertDataDate(fmt.date(manifest.dates.nisarAfter)),
      if (!weights.isPublished) alertCustomWeights,
      if (m.depotAutoSelected) alertDepot,
      alertVerify,
    ].join(' ');
  }
}
