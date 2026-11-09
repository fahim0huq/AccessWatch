
import '../../data/routing.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/labels.dart';

/// Warnings for a route, shared by the cards and the map panel.
List<String> routeWarnings(AppLocalizations l, Fmt fmt, CareMode mode, GraphRoute r) => [
      if (r.shallowM > 0 || r.mediumM > 0)
        l.routeWater(fmt.count(r.shallowM.round()), fmt.count(r.mediumM.round())),
      if (r.uncertainBridges > 0) l.routeBridges(r.uncertainBridges),
      mode == CareMode.foot ? l.routeNoWalkingTime : l.routeTimeRounded,
    ];

String routeSummary(AppLocalizations l, Fmt fmt, CareMode mode, GraphRoute r) => mode == CareMode.foot
    ? l.distanceKm(fmt.km(r.lengthM / 1000))
    : l.routeDistanceTime(fmt.km(r.lengthM / 1000), fmt.minutes(r.timeMin));
