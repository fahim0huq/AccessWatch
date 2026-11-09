
import '../../data/routing.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/labels.dart';

/// graph.json rounds each piece's travel_time_min to 0.1 min (docs/SCHEMA.md),
/// so each piece's time can be off by up to half of that, and pieces shorter
/// than about 50 m read 0.0.
const pieceTimeRoundingMin = 0.05;

/// The summed time is shown only when the rounding on all its pieces together
/// could change it by at most a quarter. Many short pieces summed (as near a
/// town, and as the fastest search prefers zero-time pieces) fail this.
bool timeIsTrustworthy(GraphRoute r) =>
    r.timeMin > 0 && (r.nodes.length - 1) * pieceTimeRoundingMin <= 0.25 * r.timeMin;

/// Warnings for a route, shared by the cards and the map panel.
List<String> routeWarnings(AppLocalizations l, Fmt fmt, CareMode mode, GraphRoute r) => [
      if (r.shallowM > 0 || r.mediumM > 0)
        l.routeWater(fmt.count(r.shallowM.round()), fmt.count(r.mediumM.round())),
      if (r.uncertainBridges > 0) l.routeBridges(r.uncertainBridges),
      if (mode == CareMode.foot)
        l.routeNoWalkingTime
      else if (!timeIsTrustworthy(r))
        l.routeTimeUntrusted
      else
        l.routeTimeRounded,
    ];

String routeSummary(AppLocalizations l, Fmt fmt, CareMode mode, GraphRoute r) => mode == CareMode.foot || !timeIsTrustworthy(r)
    ? l.distanceKm(fmt.km(r.lengthM / 1000))
    : l.routeDistanceTime(fmt.km(r.lengthM / 1000), fmt.minutes(r.timeMin));
