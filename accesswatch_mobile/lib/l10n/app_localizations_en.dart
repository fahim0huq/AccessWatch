// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'AccessWatch';

  @override
  String get accesswatchTitle => 'ACCESSWATCH';

  @override
  String get tabHome => 'Home';

  @override
  String get tabMap => 'Map';

  @override
  String get tabMissions => 'Missions';

  @override
  String get tabInfo => 'Info';

  @override
  String get loadingData => 'Loading flood data…';

  @override
  String get loadError => 'The flood data could not be loaded.';

  @override
  String get retry => 'Try again';

  @override
  String get betaBadge => 'BETA DATA';

  @override
  String get heroTitle => 'Find who is cut off.\nReach them safely.';

  @override
  String get heroSubtitle =>
      'Turn flood observations into clear humanitarian access decisions.';

  @override
  String get missionControl => 'MISSION CONTROL';

  @override
  String get missionControlSubtitle => 'Explore the flood and access situation';

  @override
  String get missionCards => 'MISSION CARDS';

  @override
  String missionCardsSubtitle(String count) {
    return 'Response briefs for $count ranked pockets';
  }

  @override
  String get tapToOpenMap => 'Tap to open the map';

  @override
  String get floodPreviewLabel =>
      'Outline of the mapped flood and cut-off pockets. Tap to open the map.';

  @override
  String get eventMozambique2026 => 'Mozambique flood, January 2026';

  @override
  String kpiPockets(String count) {
    return '$count pockets';
  }

  @override
  String get kpiPocketsSub => 'Cut off or difficult to reach';

  @override
  String get kpiPeopleSub => 'People in pockets (modelled estimate)';

  @override
  String floodAreaKm2(String area) {
    return '$area km²';
  }

  @override
  String get kpiFloodSub => 'New flood mapped';

  @override
  String get waterDepth => 'WATER DEPTH';

  @override
  String get kpiDepthSub => 'Flooded road pieces, by estimated depth';

  @override
  String depthCount(String count, String label) {
    return '$count $label';
  }

  @override
  String get depthDry => 'DRY';

  @override
  String get depthShallow => 'SHALLOW';

  @override
  String get depthMedium => 'MEDIUM';

  @override
  String get depthDeep => 'DEEP';

  @override
  String get depthUnknown => 'UNKNOWN';

  @override
  String get depthShallowRange => '< 0.3 m';

  @override
  String get depthMediumRange => '0.3–0.8 m';

  @override
  String get depthDeepRange => '> 0.8 m';

  @override
  String get depthEstimateWarning =>
      'Depth is an estimate, shown as classes and not exact metres. Verify on the ground.';

  @override
  String get warningsTitle => 'DATA WARNINGS';

  @override
  String get warnShortNisarBeta => 'NISAR scenes are BETA data';

  @override
  String get warnNisarBeta =>
      'The NISAR scenes are BETA products, not yet fully calibrated. Treat the results as preliminary.';

  @override
  String get warnShortDepotAutoSelected =>
      'Aid depot is auto-selected: routes and priority are illustrative';

  @override
  String get warnDepotAutoSelected =>
      'The aid depot was AUTO-SELECTED and is not a real depot. Routes and priority are illustrative until the real depot is set.';

  @override
  String get warnShortValidationProductOrder =>
      'Validation map was chosen by product order, not by date';

  @override
  String warnValidationProductOrder(String hours) {
    return 'The EMS validation map was chosen by product order, not by date. Its image was taken $hours hours after the NISAR scene, so the water may have changed.';
  }

  @override
  String get warnShortClassifierCalibrated =>
      'Compare mode is not an independent check';

  @override
  String warnClassifierCalibrated(String classifierIou, String thresholdIou) {
    return 'The flood map is a classifier calibrated on the EMSR857 map (spatial cross-validation IoU $classifierIou, against $thresholdIou for the threshold map). Agreement with EMS in Compare mode is not an independent check.';
  }

  @override
  String get warningExpandHint => 'Show or hide details';

  @override
  String get appDisclaimer =>
      'This app supports decisions and is not an emergency service.';

  @override
  String get populationIsModelled =>
      'Population is a modelled estimate, not a census.';

  @override
  String get responseMissions => 'RESPONSE MISSIONS';

  @override
  String rankedPockets(String count) {
    return '$count ranked pockets';
  }

  @override
  String get filterAll => 'ALL';

  @override
  String get accessNormalVehicle => 'VEHICLE';

  @override
  String get accessHighClearanceTruck => 'HIGH-CLEARANCE TRUCK';

  @override
  String get accessOnFoot => 'ON FOOT';

  @override
  String get accessBoat => 'BOAT';

  @override
  String get statusCutOff => 'CUT OFF';

  @override
  String get statusDifficult => 'DIFFICULT ACCESS';

  @override
  String get serviceClinic => 'Clinic';

  @override
  String get serviceMarket => 'Market';

  @override
  String get serviceShelter => 'Shelter';

  @override
  String get serviceAidDepotLink => 'Aid depot link';

  @override
  String lostServices(String services) {
    return 'Lost: $services';
  }

  @override
  String limitedServices(String services) {
    return 'Difficult: $services';
  }

  @override
  String populationEstimate(String count) {
    return '$count people (estimate)';
  }

  @override
  String pocketTitle(String direction, String place) {
    String _temp0 = intl.Intl.selectLogic(direction, {
      'north': 'North of $place',
      'northeast': 'North-east of $place',
      'east': 'East of $place',
      'southeast': 'South-east of $place',
      'south': 'South of $place',
      'southwest': 'South-west of $place',
      'west': 'West of $place',
      'northwest': 'North-west of $place',
      'other': 'Near $place',
    });
    return '$_temp0';
  }

  @override
  String get estimatedPopulation => 'ESTIMATED POPULATION';

  @override
  String get servicesLost => 'SERVICES LOST';

  @override
  String get servicesLimited => 'SERVICES WITH DIFFICULT ACCESS';

  @override
  String serviceWasMinutes(String service, String minutes) {
    return '$service (about $minutes min before the flood)';
  }

  @override
  String get whyFlagged => 'WHY FLAGGED';

  @override
  String whyCutOff(String services, String mode, String depth) {
    return 'The flood cuts this area off from: $services. Reaching it needs: $mode. Deepest water on the safest route: $depth (estimate).';
  }

  @override
  String whyDifficult(String services, String mode, String depth) {
    return 'Reaching these is difficult from this area: $services. Access needs: $mode. Deepest water on the safest route: $depth (estimate).';
  }

  @override
  String get estimatedMaxDepth => 'DEEPEST WATER ON THE SAFEST ROUTE';

  @override
  String boatLegKm(String km) {
    return 'Boat leg: $km km';
  }

  @override
  String get routeComparison => 'ROUTE COMPARISON';

  @override
  String get metric => 'METRIC';

  @override
  String get shortest => 'SHORTEST';

  @override
  String get safestStar => 'SAFEST ★';

  @override
  String get distance => 'Distance';

  @override
  String get eta => 'Time';

  @override
  String get depthLevel => 'Max depth';

  @override
  String get accessRisk => 'Risk';

  @override
  String get uncertainBridges => 'Uncertain bridges';

  @override
  String get routesSame =>
      'For this pocket the safest route is the same as the shortest.';

  @override
  String get routesDiffer =>
      'For this pocket the safest route differs from the shortest.';

  @override
  String distanceKm(String km) {
    return '$km km';
  }

  @override
  String durationMin(String min) {
    return '$min min';
  }

  @override
  String get levelHigh => 'HIGH';

  @override
  String get levelMedium => 'MEDIUM';

  @override
  String get levelLow => 'LOW';

  @override
  String get analysisConfidence => 'ANALYSIS CONFIDENCE';

  @override
  String stabilityLabel(String pct) {
    return 'Holds in $pct% of test scenarios';
  }

  @override
  String worstCaseMode(String mode) {
    return 'Worst case, prepare: $mode';
  }

  @override
  String get verifyOnGround => 'Verify on the ground before acting.';

  @override
  String get back => 'Back';

  @override
  String get systemHonestyBrief => 'SYSTEM & HONESTY BRIEF';

  @override
  String get appTitle => 'AccessWatch Mobile';

  @override
  String get appSubtitle => 'Satellite radar flood access analysis';

  @override
  String get settingsTitle => 'SETTINGS';

  @override
  String get language => 'Language';

  @override
  String get languageDevice => 'Device';

  @override
  String get languageEnglish => 'English';

  @override
  String get languagePortuguese => 'Português';

  @override
  String textSize(String pct) {
    return 'Text size: $pct%';
  }

  @override
  String get presentationMode => 'Presentation mode';

  @override
  String get presentationModeSubtitle =>
      'Hide the bottom navigation for screen recording';

  @override
  String get dataDates => 'DATA DATES';

  @override
  String dateNisarBefore(String date) {
    return 'NISAR before the flood: $date';
  }

  @override
  String dateNisarAfter(String date) {
    return 'NISAR after the flood: $date';
  }

  @override
  String dateEmsImage(String date) {
    return 'EMS image: $date';
  }

  @override
  String get howDepthEstimated => 'HOW DEPTH IS ESTIMATED';

  @override
  String get depthDescription =>
      'Radar shows where the water is, not how deep it is. Depth classes are estimated from the flood edge and a surface elevation model, so they are indicative only.';

  @override
  String get waterDepthSummary => 'WATER DEPTH SUMMARY';

  @override
  String get dataSources => 'DATA SOURCES & ATTRIBUTION';

  @override
  String get notAffiliated =>
      'Not affiliated with or endorsed by NASA, ISRO or Copernicus.';
}
