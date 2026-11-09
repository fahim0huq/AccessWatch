// Groups of areas by who can reach them, and the alert for a whole group.
import '../data/mission_ranking.dart';
import '../data/models/enums.dart';
import '../data/models/manifest.dart';
import '../data/models/mission.dart';
import '../l10n/app_localizations.dart';
import 'labels.dart';

/// [vehicle] is every area a vehicle reaches; in this data that always needs a
/// high-clearance vehicle, and the words say so.
enum AreaGroup {
  all,
  boat,
  vehicle,
  foot;

  bool has(Mission m) => switch (this) {
        AreaGroup.all => true,
        AreaGroup.boat => m.accessMode == AccessMode.boat,
        AreaGroup.vehicle => m.accessMode == AccessMode.highClearanceTruck || m.accessMode == AccessMode.normalVehicle,
        AreaGroup.foot => m.accessMode == AccessMode.onFoot,
      };

  List<RankedMission> of(List<RankedMission> ranked) => [for (final r in ranked) if (has(r.mission)) r];
}

extension GroupAlertText on AppLocalizations {
  String alertModeWords(Mission m, Fmt fmt) => switch (m.accessMode) {
        AccessMode.boat => alertModeBoat(fmt.km(m.boatLegKm)),
        AccessMode.highClearanceTruck => alertModeVehicle,
        AccessMode.normalVehicle => alertModeCar,
        AccessMode.onFoot => alertModeFoot,
      };

  /// How deep the water is on the way in, in one sentence.
  String alertDepthLine(Mission m, Fmt fmt) => m.meanDepthM == null || m.maxDepthM == null
      ? alertDepthUnknownLine
      : alertDepthMetres(fmt.oneDecimal(m.meanDepthM!), fmt.oneDecimal(m.maxDepthM!));

  /// "Preliminary data", plus what the flags say about the depot.
  String alertCaveat(Manifest manifest) {
    final flags = manifest.qualityFlags;
    if (flags.contains(QualityFlag.depotAutoSelected)) return alertPreliminaryDepotAuto;
    if (flags.contains(QualityFlag.depotAssumed)) return alertPreliminaryDepotAssumed;
    return alertPreliminary;
  }

  /// The alert for a group: headline, then every area in rank order, then the caveat.
  String groupAlertText(AreaGroup group, List<RankedMission> ranked, Manifest manifest, Fmt fmt) {
    final areas = group.of(ranked);
    final people = areas.fold<int>(0, (sum, r) => sum + r.mission.population);
    final name = switch (group) {
      AreaGroup.all => alertGroupNameAll,
      AreaGroup.boat => alertGroupNameBoat,
      AreaGroup.vehicle || AreaGroup.foot => alertGroupNameVehicle,
    };
    return [
      alertGroupHeadline(name, areas.length, fmt.count(people), fmt.date(manifest.dates.nisarAfter)),
      for (final r in areas)
        alertGroupArea(fmt.count(r.rank), r.mission.pocketId, areaName(r, ranked), fmt.count(r.mission.population),
            alertModeWords(r.mission, fmt), alertDepthLine(r.mission, fmt)),
      alertCaveat(manifest),
      alertVerify,
    ].join('\n');
  }
}
