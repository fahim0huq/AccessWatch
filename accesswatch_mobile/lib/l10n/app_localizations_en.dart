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
  String get tabMap => 'Map';

  @override
  String get loadingData => 'Loading flood data…';

  @override
  String get loadError => 'The flood data could not be loaded.';

  @override
  String get retry => 'Try again';

  @override
  String get eventMozambique2026 => 'Mozambique flood, January 2026';

  @override
  String floodAreaKm2(String area) {
    return '$area km²';
  }

  @override
  String get depthDry => 'Dry';

  @override
  String get depthShallow => 'Shallow';

  @override
  String get depthMedium => 'Medium';

  @override
  String get depthDeep => 'Deep';

  @override
  String get depthUnknown => 'Unknown';

  @override
  String get depthEstimateWarning =>
      'Depth is an estimate, shown as classes and not exact metres. Verify on the ground.';

  @override
  String get warningsTitle => 'Data warnings';

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
  String get whyFlagged => 'Why flagged';

  @override
  String whyCutOff(String services, String mode, String depth) {
    return 'The flood cuts this area off from: $services. Reaching it needs: $mode. Deepest water on the safest route: $depth (estimate).';
  }

  @override
  String whyDifficult(String services, String mode, String depth) {
    return 'Reaching these is difficult from this area: $services. Access needs: $mode. Deepest water on the safest route: $depth (estimate).';
  }

  @override
  String get estimatedMaxDepth => 'Deepest water on the safest route';

  @override
  String boatLegKm(String km) {
    return 'Boat leg: $km km';
  }

  @override
  String get routeComparison => 'Route comparison';

  @override
  String get metric => 'Metric';

  @override
  String get shortest => 'Shortest';

  @override
  String get safestStar => 'Safest ★';

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
      'For this area the safest route is the same as the shortest.';

  @override
  String get routesDiffer =>
      'For this area the safest route differs from the shortest.';

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
  String stabilityLabel(String pct) {
    return 'Holds in $pct% of test scenarios';
  }

  @override
  String worstCaseMode(String mode) {
    return 'Worst case, prepare: $mode';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languagePortuguese => 'Português';

  @override
  String get presentationMode => 'Presentation mode';

  @override
  String get presentationModeSubtitle =>
      'Hide the bottom navigation for screen recording';

  @override
  String get dataDates => 'Data dates';

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
  String get dataSources => 'Data sources & attribution';

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
  String get tooltipLocate => 'My location';

  @override
  String get tooltipZoomIn => 'Zoom in';

  @override
  String get tooltipZoomOut => 'Zoom out';

  @override
  String get tooltipFit => 'Fit to the flood area';

  @override
  String get layersControl => 'Layers';

  @override
  String get layerDepth => 'Water depth classes';

  @override
  String get layerFlood => 'Flood water';

  @override
  String get layerEms => 'Official EMS flood';

  @override
  String get layerRoads => 'Flooded roads';

  @override
  String get layerPockets => 'Cut-off areas';

  @override
  String get layerRoutes => 'Routes';

  @override
  String get layerCompare => 'Compare with the official EMS map';

  @override
  String opacityLabel(String pct) {
    return 'Opacity $pct%';
  }

  @override
  String get depthDetailNote =>
      'At low zoom only the largest depth patches are drawn, with smoothed edges. Zoom in to see them all.';

  @override
  String get legendTitle => 'Legend';

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
  String get compareTitle => 'Compare with EMS';

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
  String compareNotIndependent(
    String agreement,
    String crossValidation,
    String physicsOnly,
  ) {
    return 'Not an independent check: our flood map was calibrated on this EMS map, so its agreement with it (IoU $agreement; $crossValidation in spatial cross-validation) says little about accuracy elsewhere. The physics-only map, made without EMS, agrees less (IoU $physicsOnly) and is the more conservative one: it marks less flood.';
  }

  @override
  String compareEmsDate(String date, String hours) {
    return 'EMS image: $date, $hours hours after the NISAR scene.';
  }

  @override
  String get compareTransparent =>
      'Clear areas are dry in both maps, or outside the area EMS mapped.';

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
    return 'Inside cut-off area $pocket';
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
  String get viewOnMap => 'Show on map';

  @override
  String get layerBaseline => 'Physics-only flood map';

  @override
  String get layerBaselineNote =>
      'The threshold-based map from before the EMS calibration. It is more cautious: it finds less flood.';

  @override
  String get rankingTitle => 'Ranking weights';

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
  String missionNotFound(String id) {
    return 'No mission $id. Back to the list.';
  }

  @override
  String get serviceAccessTitle => 'Service access';

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
  String get priorityTermsTitle => 'Priority terms (0 to 1)';

  @override
  String get verifyTitle => 'Verify on the ground';

  @override
  String get verifyLowConfidence =>
      'Low confidence: at least one exit road may not really be blocked (uncertain depth or bridge).';

  @override
  String get verifyBoatRoute =>
      'The boat route follows the flooded roads, which is an approximation: check currents, debris and the actual landing point.';

  @override
  String get verifyUnstable =>
      'This area disappears or changes when the flood extent or depth is slightly off: check it first.';

  @override
  String verifyShortestDeep(String km) {
    return 'The shortest road route ($km km) crosses deep water: avoid it.';
  }

  @override
  String get verifyEstimates =>
      'Depth classes come from a surface model and population is modelled: confirm both with local responders.';

  @override
  String get shareAlert => 'Share alert';

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

  @override
  String get mySpotIntro =>
      'Check your position against the flood map: in the flood or not, the estimated depth, and the nearest clinic you can reach by road.';

  @override
  String get useMyLocation => 'Use my location';

  @override
  String get mySpotWaiting => 'Waiting for location…';

  @override
  String get testPositionBadge => 'Test position (debug build)';

  @override
  String get testPositionHint =>
      'Debug build: long-press the map to set a test position.';

  @override
  String get spotOutside =>
      'You are outside the mapped area. AccessWatch cannot check this spot or route from it.';

  @override
  String get spotInFlood => 'Inside the mapped flood';

  @override
  String get spotNotInFlood => 'Not inside the mapped flood';

  @override
  String spotDepth(String depth, String range) {
    return 'Estimated depth here: $depth $range';
  }

  @override
  String spotFloodedRoad(String metres) {
    return 'Nearest flooded road: $metres m away';
  }

  @override
  String spotSnapped(String metres) {
    return 'Routes start at the nearest road point, $metres m away';
  }

  @override
  String get routingFailed => 'Routes could not be worked out.';

  @override
  String get needsBoatAny =>
      'Needs a boat: no road route reaches any clinic from here.';

  @override
  String needsBoatClinic(String clinic) {
    return 'Needs a boat: no road route reaches $clinic from here.';
  }

  @override
  String get needsBoatShort => 'Needs a boat from your spot';

  @override
  String get criterionFastest => 'Fastest';

  @override
  String get criterionSafest => 'Safest';

  @override
  String get targetUseNearest => 'Use nearest';

  @override
  String get careModeCar => 'Car';

  @override
  String get careModeTruck => 'High-clearance truck';

  @override
  String get careModeFoot => 'On foot';

  @override
  String routeDistanceTime(String km, String minutes) {
    return '$km km, about $minutes min';
  }

  @override
  String routeWater(String shallow, String medium) {
    return 'Water on the way: $shallow m shallow, $medium m medium (estimate)';
  }

  @override
  String routeBridges(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count bridges to check on the ground: radar cannot see their condition',
      one: '1 bridge to check on the ground: radar cannot see its condition',
    );
    return '$_temp0';
  }

  @override
  String get routeNoWalkingTime =>
      'Walking time is not in the data, so only the distance is shown.';

  @override
  String get routeTimeRounded =>
      'Time is a vehicle estimate from rounded data: allow a few minutes either way.';

  @override
  String careRouteTo(String clinic, String mode) {
    return 'To $clinic by $mode';
  }

  @override
  String get clearRoute => 'Clear the route';

  @override
  String get locationWhyTitle => 'Why your location?';

  @override
  String get locationWhyBody =>
      'AccessWatch uses your position only while Map or Care is open, to check it against the flood map and route you to a clinic. The app does not send your position anywhere, though map tiles for the area you view come from OpenStreetMap.';

  @override
  String get locationContinue => 'Continue';

  @override
  String get locationNotNow => 'Not now';

  @override
  String get warnShortDepotAssumed => 'Aid depot location is assumed';

  @override
  String get warnDepotAssumed =>
      'The aid depot location is assumed, not confirmed. Routes and priority depend on it: confirm the real depot before acting.';

  @override
  String dateEmsGap(String hours) {
    return 'The EMS image was taken $hours hours after the NISAR \"after\" scene, so the water may have changed in between.';
  }

  @override
  String get knownIssuesTitle => 'Known issues in this data';

  @override
  String get knownIssuesNone => 'The data records no known issues.';

  @override
  String issueRankInversion(String higher, String lower) {
    return '$higher ranks above $lower although $lower has more people: their priority terms are equal after rounding.';
  }

  @override
  String issueSafestCount(String report, String routes) {
    return 'The validation report says the safest route differs from the shortest for $report pocket(s), but the route data shows $routes.';
  }

  @override
  String issueRoadsOutsideCoverage(String count, String dry) {
    return '$count road pieces reach outside the radar coverage; $dry of them are labelled dry, which may only mean the radar did not see them.';
  }

  @override
  String issuePocketOutsideCoverage(String pct, String pocket) {
    return '$pct% of pocket $pocket lies outside the radar coverage.';
  }

  @override
  String issueClinicDuplicates(String records, String pairs) {
    return 'The $records clinic records include $pairs pairs less than 100 m apart, so some may be the same clinic counted twice.';
  }

  @override
  String get validationTitle => 'How well the flood map agrees';

  @override
  String get scoreIou => 'Agreement with EMS (IoU)';

  @override
  String get scoreF1 => 'F1 score';

  @override
  String get scorePrecision => 'Precision (flood we mark that EMS also marks)';

  @override
  String get scoreRecall => 'Recall (EMS flood we also mark)';

  @override
  String get scoreCrossValidation => 'Spatial cross-validation (IoU)';

  @override
  String get scorePhysicsOnly => 'Physics-only map vs EMS (IoU)';

  @override
  String get scoreStablePockets => 'Pockets that hold in every test scenario';

  @override
  String validationReference(String layer) {
    return 'Reference map: $layer';
  }

  @override
  String get limitsTitle => 'Limits, in plain words';

  @override
  String get limitDepth =>
      'Radar shows where water is, not how deep it is. Depth is estimated from a surface model, so the classes are a guide, not measurements.';

  @override
  String get limitRadar =>
      'The radar finds open water well but can miss water under trees or between buildings.';

  @override
  String limitRoads(String pct, String fragments) {
    return 'Roads come from OpenStreetMap: $pct% of buildings are within 150 m of a mapped road, and $fragments small disconnected road pieces were left out.';
  }

  @override
  String get limitPopulation =>
      'People counts come from a population model, not a census.';

  @override
  String get limitBoat =>
      'Boat routes follow the flooded roads, so real water routes can differ. Bridges cannot be checked from space.';

  @override
  String get limitThresholds =>
      'The depth and vehicle limits are adjustable defaults: confirm them with local responders and always check on the ground.';

  @override
  String limitUntranslated(String text) {
    return '(Only in English for now) $text';
  }

  @override
  String get colorsTitle => 'How to read the colours';

  @override
  String get sourceWebsite => 'Website';

  @override
  String get sourceDocs => 'Documentation';

  @override
  String sourceDoi(String doi) {
    return 'DOI: $doi';
  }

  @override
  String sourceLicence(String licence) {
    return 'Licence: $licence';
  }

  @override
  String get readIntroAgain => 'Read the safety message again';

  @override
  String get introTitle1 => 'See who the flood cuts off';

  @override
  String get introBody1 =>
      'AccessWatch shows where floodwater cuts people off from clinics, markets and shelters, and how to reach them. It is built from satellite radar: depth and population are estimates.';

  @override
  String get introBody2 =>
      'The flood map comes from NISAR radar, checked against the Copernicus EMS map. Depth and population are estimates, and the radar data is still in beta.';

  @override
  String get safetyTitle => 'Before you start';

  @override
  String get safetyBody =>
      'AccessWatch supports decisions and is not an emergency service. The data can be wrong or out of date: always check on the ground before acting.';

  @override
  String get safetyEmergency =>
      'If you are in danger, call your local emergency number.';

  @override
  String get safetyAccept => 'I understand';

  @override
  String get rankingDepotAssumedNote =>
      'The aid depot location is assumed, not confirmed, so this ranking is illustrative.';

  @override
  String get alertDepotAssumed =>
      'Route starts at an assumed, unconfirmed depot location, so it is illustrative.';

  @override
  String dataAge(String date, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days ago',
      one: '1 day ago',
      zero: 'today',
    );
    return 'Data acquired $date (NISAR radar). This is a snapshot from $_temp0: the water has changed since.';
  }

  @override
  String get offlineBanner =>
      'No network connection. Everything works from the data inside the app, except the map background and web links.';

  @override
  String get offlineWorks =>
      'All analysis data is inside the app, so it works offline. Only the map background and web links need a network.';

  @override
  String get mapSemanticsLabel =>
      'Flood map. The same areas are listed on the Help first tab.';

  @override
  String alreadyAtClinic(String clinic) {
    return 'You\'re already at $clinic: no route needed.';
  }

  @override
  String get alreadyHereShort => 'You\'re here';

  @override
  String get tabHelpFirst => 'Help first';

  @override
  String get tabFindCare => 'Find care';

  @override
  String get aboutThisData => 'About this data';

  @override
  String mapAreasCutOff(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString areas cut off or hard to reach',
      one: '1 area cut off or hard to reach',
    );
    return '$_temp0';
  }

  @override
  String mapPeopleNear(String people, String places) {
    return 'About $people people near $places';
  }

  @override
  String placesAnd(String first, String last) {
    return '$first and $last';
  }

  @override
  String get seeWhoNeedsHelp => 'See who needs help first';

  @override
  String mapPreliminary(String date) {
    return 'Preliminary data · snapshot of $date · tap for details';
  }

  @override
  String mapSnapshot(String date) {
    return 'Snapshot of $date · tap for details';
  }

  @override
  String get legendFlooded => 'Flooded';

  @override
  String get modeNeedsBoat => 'Needs a boat';

  @override
  String get modeTruckCanReach => 'Truck can reach';

  @override
  String get modeCarCanReach => 'A car can reach';

  @override
  String get modeFootCanReach => 'Reachable on foot';

  @override
  String get openArea => 'Open';

  @override
  String areaMarkerLabel(String rank, String name, String mode) {
    return 'Area $rank: $name, $mode';
  }

  @override
  String get helpTitle => 'Who needs help first';

  @override
  String helpSubtitle(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString areas, most urgent at the top',
      one: '1 area, most urgent at the top',
    );
    return '$_temp0';
  }

  @override
  String filterAllCount(String count) {
    return 'All $count';
  }

  @override
  String filterBoatCount(String count) {
    return 'Boat $count';
  }

  @override
  String filterFootCount(String count) {
    return 'On foot $count';
  }

  @override
  String get customWeightsNote =>
      'Ordered with your own priority weights. Reset them in About this data › Advanced.';

  @override
  String areaCardLabel(String rank, String name, String people, String mode) {
    return 'Area $rank: $name. $people. $mode';
  }

  @override
  String get noAreasForFilter => 'No areas match this filter.';

  @override
  String areaXofN(String rank, String count) {
    return 'Area $rank of $count';
  }

  @override
  String modeBoatDetail(String water, String total) {
    return 'About $water km by water. Safest route $total km in all.';
  }

  @override
  String get modeTruckTitle => 'A high-clearance truck can reach it';

  @override
  String get modeCarTitle => 'A normal car can reach it';

  @override
  String get modeFootTitle => 'It can be reached on foot only';

  @override
  String get modeTruckDetail => 'No boat needed, but the road has water on it.';

  @override
  String get lostTitle => 'What they can no longer reach';

  @override
  String get harderTitle => 'What is harder to reach';

  @override
  String lostWasMinutes(String minutes) {
    return 'was about $minutes min';
  }

  @override
  String get serviceDepotLinkPlain => 'Link to the aid depot';

  @override
  String get safestRouteTitle => 'Safest road route';

  @override
  String routeCheckBridges(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Check $count bridges first',
      one: 'Check 1 bridge first',
    );
    return '$_temp0';
  }

  @override
  String get riskChipHigh => 'High risk';

  @override
  String get riskChipMedium => 'Medium risk';

  @override
  String get riskChipLow => 'Low risk';

  @override
  String get sureHigh => 'High';

  @override
  String get sureMedium => 'Medium';

  @override
  String get sureLow => 'Low';

  @override
  String checkOnGround(String count) {
    return 'Check on the ground first ($count)';
  }

  @override
  String get checkOnGroundTitle => 'Check on the ground first';

  @override
  String get checkOnGroundIntro =>
      'Tick each one when a team has checked it. Ticks stay on this phone.';

  @override
  String howSure(String level) {
    return 'How sure are we? $level';
  }

  @override
  String get howSureTitle => 'How sure are we?';

  @override
  String howSureConfidence(String level) {
    return 'Confidence: $level';
  }

  @override
  String get routesIllustrativeShort =>
      'Routes start at the aid depot, which is assumed. Use them as a guide.';

  @override
  String get findCareTitle => 'Find care';

  @override
  String get findCareSubtitle => 'The nearest clinic you can reach, and how';

  @override
  String get trySampleSpot => 'Try a sample spot in Chókwè';

  @override
  String get sampleNotice => 'Sample location, not your position';

  @override
  String get nearestClinicLabel => 'Nearest clinic';

  @override
  String get chosenClinicLabel => 'Your chosen clinic';

  @override
  String get byCar => 'By car';

  @override
  String get byTruck => 'High-clearance truck';

  @override
  String get byFoot => 'On foot';

  @override
  String get canReach => 'Can reach';

  @override
  String get noRoadRoute => 'No road route';

  @override
  String toClinic(String clinic) {
    return 'to $clinic';
  }

  @override
  String get showRouteOnMapLong => 'Show the route on the map';

  @override
  String get routeBy => 'Route by';

  @override
  String get aboutThisSpot => 'About this spot';

  @override
  String allClinicsTitle(String count) {
    return 'All clinics ($count)';
  }

  @override
  String get aboutPreliminary =>
      'Preliminary data. Use as a guide, then verify on the ground.';

  @override
  String get aboutGuideOnly => 'Use as a guide, then verify on the ground.';

  @override
  String get plainNisarBeta =>
      'The NISAR radar scenes are beta products, not yet fully calibrated.';

  @override
  String get plainDepotAutoSelected =>
      'The aid depot was chosen automatically by the analysis, so routes and priorities are only illustrative.';

  @override
  String get plainDepotAssumed =>
      'The aid depot is assumed, not confirmed, so routes and priorities are a guide.';

  @override
  String get plainValidationProductOrder =>
      'The official map used to check ours was chosen by product order, not by which image was closest in time.';

  @override
  String get plainClassifierCalibrated =>
      'The flood map is calibrated to this event\'s official map, so it agrees with that map partly by design.';

  @override
  String get aboutFloodMapRow => 'How the flood map was made';

  @override
  String get aboutMatchRow => 'How well it matches the official map';

  @override
  String get aboutLimitsRow => 'Limits and known issues';

  @override
  String get aboutSourcesRow => 'Sources';

  @override
  String get aboutAgeRow => 'Data age and update info';

  @override
  String get aboutAdvancedRow => 'Advanced';

  @override
  String get aboutAdvancedSubtitle =>
      'Priority weights, Compare, physics-only and depth layers';

  @override
  String get aboutLanguage => 'Language';

  @override
  String get aboutTextSize => 'Text size';

  @override
  String textSizeOption(String pct) {
    return '$pct%';
  }

  @override
  String get aboutSafetyLine =>
      'This app supports decisions. It is not an emergency service. If you are in danger, call your local emergency number.';

  @override
  String get floodMapIntro =>
      'The flood map compares NISAR radar scenes from before and after the flood. Open water reflects radar differently from land, so a change between the two scenes marks new water.';

  @override
  String dataGenerated(String date) {
    return 'Analysis run: $date';
  }

  @override
  String get updateInfo =>
      'The data comes from one run of the analysis. When the analysis is run again on newer scenes, a new app version carries the new data.';

  @override
  String get advancedMapNote => 'Layer changes show on the Map tab.';

  @override
  String areaNameNumbered(String name, String number) {
    return '$name ($number)';
  }

  @override
  String get routeTimeUntrusted =>
      'No time shown: many short road pieces on this route have a time of zero in the data, so a summed time would be far too low.';

  @override
  String get confHigh => 'HIGH';

  @override
  String get confMedium => 'MEDIUM';

  @override
  String get confLow => 'LOW';

  @override
  String filterVehicleCount(String count) {
    return 'Vehicle (high-clearance) $count';
  }

  @override
  String get shareGroupButton => 'Share an alert for a team';

  @override
  String get shareGroupTitle => 'Which teams is the alert for?';

  @override
  String groupAll(String count) {
    return 'All areas ($count)';
  }

  @override
  String groupBoat(String count) {
    return 'Boat teams ($count)';
  }

  @override
  String groupVehicle(String count) {
    return 'Vehicle teams, high-clearance ($count)';
  }

  @override
  String get alertGroupNameAll => 'all areas';

  @override
  String get alertGroupNameBoat => 'areas that need a boat';

  @override
  String get alertGroupNameVehicle =>
      'areas a high-clearance vehicle can reach';

  @override
  String alertGroupHeadline(
    String group,
    int count,
    String people,
    String date,
  ) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count areas',
      one: '1 area',
    );
    return 'ACCESSWATCH, $group: $_temp0, about $people people (estimate). Data from $date.';
  }

  @override
  String alertGroupArea(
    String rank,
    String pocket,
    String name,
    String people,
    String mode,
    String depth,
  ) {
    return '#$rank $pocket $name: about $people people (estimate). $mode. $depth';
  }

  @override
  String alertModeBoat(String km) {
    return 'Needs a boat ($km km by water)';
  }

  @override
  String get alertModeVehicle =>
      'High-clearance vehicle only, not an ordinary car';

  @override
  String get alertModeCar => 'A car can reach it';

  @override
  String get alertModeFoot => 'On foot only';

  @override
  String get alertPreliminaryDepotAssumed =>
      'Preliminary data; the aid depot is assumed, not confirmed.';

  @override
  String get alertPreliminaryDepotAuto =>
      'Preliminary data; the aid depot was chosen automatically, not confirmed.';

  @override
  String get alertPreliminary => 'Preliminary data.';

  @override
  String get waterDepthTitle => 'Water on the way in';

  @override
  String depthAverageLine(String mean, String max) {
    return 'Water about $mean m deep on average (estimate), up to about $max m';
  }

  @override
  String get waterDepthUnknown => 'Water depth unknown';

  @override
  String get depthSourceNote =>
      'Estimated from a 30 m terrain model. A guide, not a measurement.';

  @override
  String deepestClassChip(String depth) {
    return 'Deepest: $depth';
  }

  @override
  String alertDepthMetres(String mean, String max) {
    return 'Water about $mean m deep on average, up to $max m (estimate).';
  }

  @override
  String get alertDepthUnknownLine => 'Water depth unknown.';

  @override
  String get layersButton => 'Layers';

  @override
  String get layersTitle => 'What the map shows';

  @override
  String get layerGroupWater => 'Water';

  @override
  String get layerGroupAreas => 'Areas';

  @override
  String get layerGroupRoads => 'Roads';

  @override
  String get layerGroupPlaces => 'Places';

  @override
  String get layerGroupRoutes => 'Routes';

  @override
  String get layerGroupMore => 'More';

  @override
  String get layerFloodNote =>
      'Turn it off to see the roads and land under the water.';

  @override
  String get layerRoadsNote =>
      'Road pieces under water, shaded by depth class: light shallow, middle medium, dark deep.';

  @override
  String get layerAllRoads => 'All roads status';

  @override
  String get roadAnyCar => 'Any car';

  @override
  String get roadHighClearance => 'High-clearance only';

  @override
  String get roadFootOnly => 'On foot only';

  @override
  String get roadImpassable => 'Impassable';

  @override
  String get layerClinics => 'Clinics';

  @override
  String get layerMarkets => 'Markets';

  @override
  String get layerShelters => 'Shelters';

  @override
  String get layerDepot => 'Aid depot';

  @override
  String get layerDepotAssumed => 'Aid depot (assumed)';

  @override
  String get layerDepotAuto => 'Aid depot (auto-selected)';

  @override
  String get layerRoutesNote =>
      'The safest and shortest route to each area from the aid depot.';

  @override
  String get resetView => 'Reset to default view';

  @override
  String get routesPanelOpen => 'See every route';
}
