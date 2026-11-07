// The ground checks for a mission, worked out from its fields. The app holds the
// wording, so the notes follow the current language.
import 'models/enums.dart';
import 'models/mission.dart';

enum VerifyNoteKind { bridges, lowConfidence, boatRoute, unstable, shortestDeep, depotAutoSelected, estimates }

class VerifyNote {
  final VerifyNoteKind kind;

  /// Uncertain bridges for [VerifyNoteKind.bridges].
  final int? bridges;

  /// Shortest route length for [VerifyNoteKind.shortestDeep].
  final double? shortestKm;

  const VerifyNote(this.kind, {this.bridges, this.shortestKm});
}

List<VerifyNote> verifyNotesFor(Mission m) => [
      if (m.safest.uncertainBridges > 0) VerifyNote(VerifyNoteKind.bridges, bridges: m.safest.uncertainBridges),
      if (m.confidence == Confidence.low) const VerifyNote(VerifyNoteKind.lowConfidence),
      if (m.accessMode == AccessMode.boat) const VerifyNote(VerifyNoteKind.boatRoute),
      if (m.stability < 1) const VerifyNote(VerifyNoteKind.unstable),
      // Only a warning when there is a different, safer route to take instead.
      if (m.shortest.maxDepthClass == DepthClass.deep && !m.shortest.sameAs(m.safest))
        VerifyNote(VerifyNoteKind.shortestDeep, shortestKm: m.shortest.distanceKm),
      if (m.depotAutoSelected) const VerifyNote(VerifyNoteKind.depotAutoSelected),
      const VerifyNote(VerifyNoteKind.estimates),
    ];
