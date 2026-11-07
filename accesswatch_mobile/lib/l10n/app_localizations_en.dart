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

  @override
  String depthBelow(String limit) {
    return '< $limit m';
  }

  @override
  String depthBetween(String low, String high) {
    return '$low–$high m';
  }

  @override
  String depthAbove(String limit) {
    return '> $limit m';
  }

  @override
  String get osmAttribution => '© OpenStreetMap contributors';

  @override
  String mapDates(String before, String after, String ems) {
    return 'NISAR $before – $after · EMS $ems';
  }

  @override
  String warningsToggle(String count) {
    return '$count warnings';
  }

  @override
  String get tooltipLayers => 'Layers';

  @override
  String get tooltipLegend => 'Legend';

  @override
  String get tooltipCompare => 'Compare with EMS';

  @override
  String get tooltipLocate => 'Show my location';

  @override
  String get tooltipZoomIn => 'Zoom in';

  @override
  String get tooltipZoomOut => 'Zoom out';

  @override
  String get tooltipFit => 'Show the whole area';

  @override
  String get layersControl => 'LAYERS';

  @override
  String get layerDepth => 'Water depth (estimate)';

  @override
  String get layerFlood => 'Flood extent';

  @override
  String get layerEms => 'Official EMS flood';

  @override
  String get layerRoads => 'Flooded roads';

  @override
  String get layerPockets => 'Pockets';

  @override
  String get layerRoutes => 'Routes';

  @override
  String get layerServices => 'Services';

  @override
  String get layerCompare => 'Compare with EMS';

  @override
  String opacityLabel(String pct) {
    return 'Opacity $pct%';
  }

  @override
  String get depthDetailNote =>
      'At low zoom only the largest depth patches are drawn, with smoothed edges. Zoom in to see them all.';

  @override
  String get legendTitle => 'LEGEND';

  @override
  String legendPocketRisk(String level) {
    return 'Pocket, $level risk';
  }

  @override
  String get legendSafest => 'Safest route';

  @override
  String get legendShortest => 'Shortest route (dashed)';

  @override
  String get legendRoad => 'Flooded road, by depth';

  @override
  String get legendEms => 'Official EMS flood outline';

  @override
  String get legendClinic => 'Clinic';

  @override
  String get legendMarket => 'Market';

  @override
  String get legendShelter => 'Shelter';

  @override
  String get legendDepot => 'Aid depot';

  @override
  String get legendMe => 'My location';

  @override
  String get compareTitle => 'COMPARE WITH EMS';

  @override
  String compareBoth(String area) {
    return 'Both maps: $area km²';
  }

  @override
  String compareOnlyOurs(String area) {
    return 'Only our map: $area km²';
  }

  @override
  String compareOnlyEms(String area) {
    return 'Only EMS: $area km²';
  }

  @override
  String compareIou(String iou) {
    return 'Agreement (IoU): $iou';
  }

  @override
  String get compareNotIndependent =>
      'Not an independent check: our flood map was calibrated on this EMS map.';

  @override
  String compareEmsDate(String date, String hours) {
    return 'EMS image: $date, $hours hours after the NISAR scene.';
  }

  @override
  String get compareTransparent =>
      'Clear areas are dry in both maps, or outside the area EMS mapped.';

  @override
  String get rankedPocketsTitle => 'RANKED POCKETS';

  @override
  String get allPockets => 'ALL';

  @override
  String routeSheetTitle(String pocket, String route) {
    return '$pocket: $route';
  }

  @override
  String get routeSafestLabel => 'Safest route';

  @override
  String get routeShortestLabel => 'Shortest route';

  @override
  String get routeAccess => 'Access';

  @override
  String get routeWaterKm => 'Water on route';

  @override
  String routeWaterValue(String shallow, String medium, String deep) {
    return '$shallow / $medium / $deep km (shallow / medium / deep)';
  }

  @override
  String get routesIllustrative =>
      'Distances and times are estimates, and the route starts from the auto-selected depot.';

  @override
  String get sheetServiceType => 'Type';

  @override
  String get sheetStatus => 'Access status';

  @override
  String get clinicReachable => 'Reachable on dry roads';

  @override
  String get clinicAccessFlooded => 'Access road flooded';

  @override
  String clinicInsidePocket(String pocket) {
    return 'Inside pocket $pocket';
  }

  @override
  String get clinicStatusNote =>
      'This shows whether the clinic connects to the main dry road network. It does not say whether a cut-off pocket can reach it.';

  @override
  String get clinicDuplicateNote =>
      'Mapped records can repeat one facility, so nearby clinics may be the same place.';

  @override
  String get locationOff => 'Location is turned off on this device.';

  @override
  String get locationDenied => 'Location permission was not given.';

  @override
  String get locationOutside => 'You are outside the mapped area.';

  @override
  String get viewOnMap => 'SHOW ON MAP';

  @override
  String get layerBaseline => 'Physics-only flood map';

  @override
  String get layerBaselineNote =>
      'The threshold-based map from before the EMS calibration. It is more cautious: it finds less flood.';

  @override
  String get rankingTitle => 'RANKING WEIGHTS';

  @override
  String get rankingShow => 'Show the sliders';

  @override
  String get rankingHide => 'Hide the sliders';

  @override
  String get rankingReset => 'Reset';

  @override
  String get weightPeople => 'People';

  @override
  String get weightServiceLoss => 'Service loss';

  @override
  String get weightDifficulty => 'Difficulty';

  @override
  String get rankingChoiceNote =>
      'The weights are a choice, not science. At 1.00 each they give the published ranking.';

  @override
  String rankingDominated(String pocket, String pct) {
    return '$pocket holds $pct% of the estimated people, so it dominates this list and the weights mostly reorder the others.';
  }

  @override
  String get rankingTies =>
      'Pockets with equal terms tie, whatever the weights, and keep their published order.';

  @override
  String get rankingDepotNote =>
      'The aid depot is auto-selected, so this ranking is illustrative.';

  @override
  String publishedRank(String rank) {
    return 'Published rank: #$rank';
  }

  @override
  String missionNotFound(String id) {
    return 'No mission $id. Back to the list.';
  }

  @override
  String get serviceAccessTitle => 'SERVICE ACCESS';

  @override
  String get accessYes => 'reachable';

  @override
  String get accessDifficult => 'difficult';

  @override
  String get accessNo => 'cut off';

  @override
  String get accessNotApplicable => 'not applicable';

  @override
  String accessWasMinutes(String minutes) {
    return '(about $minutes min before the flood)';
  }

  @override
  String get priorityTermsTitle => 'PRIORITY TERMS (0 TO 1)';

  @override
  String get verifyTitle => 'VERIFY ON THE GROUND';

  @override
  String get verifyLowConfidence =>
      'Low confidence: at least one exit road may not really be blocked (uncertain depth or bridge).';

  @override
  String get verifyBoatRoute =>
      'The boat route follows the flooded roads, which is an approximation: check currents, debris and the actual landing point.';

  @override
  String get verifyUnstable =>
      'This pocket disappears or changes when the flood extent or depth is slightly off: verify it first.';

  @override
  String verifyShortestDeep(String km) {
    return 'The shortest road route ($km km) crosses deep water: avoid it.';
  }

  @override
  String get verifyEstimates =>
      'Depth classes come from a surface model and population is modelled: confirm both with local responders.';

  @override
  String get shareAlert => 'SHARE ALERT';

  @override
  String get alertTitle => 'Alert for field teams';

  @override
  String get alertCopy => 'Copy';

  @override
  String get close => 'Close';

  @override
  String alertHeadline(
    String rank,
    String pocket,
    String place,
    String people,
  ) {
    return 'ACCESSWATCH #$rank $pocket, $place: about $people people (estimate).';
  }

  @override
  String alertNeeds(String mode) {
    return 'Needs: $mode.';
  }

  @override
  String alertBoatLeg(String mode, String km) {
    return '$mode ($km km by water)';
  }

  @override
  String alertRoute(String km, String risk, String confidence) {
    return 'Route $km km, risk $risk, confidence $confidence.';
  }

  @override
  String alertDataDate(String date) {
    return 'Data from $date.';
  }

  @override
  String get alertCustomWeights => 'Rank uses custom weights.';

  @override
  String get alertDepot =>
      'Route starts at an auto-selected depot, so it is illustrative.';

  @override
  String get alertVerify => 'VERIFY ON THE GROUND.';

  @override
  String verifyBridges(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Verify $count bridges on the route on the ground first: radar cannot see their condition.',
      one:
          'Verify 1 bridge on the route on the ground first: radar cannot see its condition.',
    );
    return '$_temp0';
  }
}
