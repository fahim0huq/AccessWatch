import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'AccessWatch'**
  String get appName;

  /// No description provided for @accesswatchTitle.
  ///
  /// In en, this message translates to:
  /// **'ACCESSWATCH'**
  String get accesswatchTitle;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get tabMap;

  /// No description provided for @tabMissions.
  ///
  /// In en, this message translates to:
  /// **'Missions'**
  String get tabMissions;

  /// No description provided for @tabInfo.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get tabInfo;

  /// No description provided for @loadingData.
  ///
  /// In en, this message translates to:
  /// **'Loading flood data…'**
  String get loadingData;

  /// No description provided for @loadError.
  ///
  /// In en, this message translates to:
  /// **'The flood data could not be loaded.'**
  String get loadError;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @betaBadge.
  ///
  /// In en, this message translates to:
  /// **'BETA DATA'**
  String get betaBadge;

  /// No description provided for @heroTitle.
  ///
  /// In en, this message translates to:
  /// **'Find who is cut off.\nReach them safely.'**
  String get heroTitle;

  /// No description provided for @heroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Turn flood observations into clear humanitarian access decisions.'**
  String get heroSubtitle;

  /// No description provided for @missionControl.
  ///
  /// In en, this message translates to:
  /// **'MISSION CONTROL'**
  String get missionControl;

  /// No description provided for @missionControlSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Explore the flood and access situation'**
  String get missionControlSubtitle;

  /// No description provided for @missionCards.
  ///
  /// In en, this message translates to:
  /// **'MISSION CARDS'**
  String get missionCards;

  /// No description provided for @missionCardsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Response briefs for {count} ranked pockets'**
  String missionCardsSubtitle(String count);

  /// No description provided for @tapToOpenMap.
  ///
  /// In en, this message translates to:
  /// **'Tap to open the map'**
  String get tapToOpenMap;

  /// No description provided for @floodPreviewLabel.
  ///
  /// In en, this message translates to:
  /// **'Outline of the mapped flood and cut-off pockets. Tap to open the map.'**
  String get floodPreviewLabel;

  /// No description provided for @eventMozambique2026.
  ///
  /// In en, this message translates to:
  /// **'Mozambique flood, January 2026'**
  String get eventMozambique2026;

  /// No description provided for @kpiPockets.
  ///
  /// In en, this message translates to:
  /// **'{count} pockets'**
  String kpiPockets(String count);

  /// No description provided for @kpiPocketsSub.
  ///
  /// In en, this message translates to:
  /// **'Cut off or difficult to reach'**
  String get kpiPocketsSub;

  /// No description provided for @kpiPeopleSub.
  ///
  /// In en, this message translates to:
  /// **'People in pockets (modelled estimate)'**
  String get kpiPeopleSub;

  /// No description provided for @floodAreaKm2.
  ///
  /// In en, this message translates to:
  /// **'{area} km²'**
  String floodAreaKm2(String area);

  /// No description provided for @kpiFloodSub.
  ///
  /// In en, this message translates to:
  /// **'New flood mapped'**
  String get kpiFloodSub;

  /// No description provided for @waterDepth.
  ///
  /// In en, this message translates to:
  /// **'WATER DEPTH'**
  String get waterDepth;

  /// No description provided for @kpiDepthSub.
  ///
  /// In en, this message translates to:
  /// **'Flooded road pieces, by estimated depth'**
  String get kpiDepthSub;

  /// No description provided for @depthCount.
  ///
  /// In en, this message translates to:
  /// **'{count} {label}'**
  String depthCount(String count, String label);

  /// No description provided for @depthDry.
  ///
  /// In en, this message translates to:
  /// **'DRY'**
  String get depthDry;

  /// No description provided for @depthShallow.
  ///
  /// In en, this message translates to:
  /// **'SHALLOW'**
  String get depthShallow;

  /// No description provided for @depthMedium.
  ///
  /// In en, this message translates to:
  /// **'MEDIUM'**
  String get depthMedium;

  /// No description provided for @depthDeep.
  ///
  /// In en, this message translates to:
  /// **'DEEP'**
  String get depthDeep;

  /// No description provided for @depthUnknown.
  ///
  /// In en, this message translates to:
  /// **'UNKNOWN'**
  String get depthUnknown;

  /// No description provided for @depthEstimateWarning.
  ///
  /// In en, this message translates to:
  /// **'Depth is an estimate, shown as classes and not exact metres. Verify on the ground.'**
  String get depthEstimateWarning;

  /// No description provided for @warningsTitle.
  ///
  /// In en, this message translates to:
  /// **'DATA WARNINGS'**
  String get warningsTitle;

  /// No description provided for @warnShortNisarBeta.
  ///
  /// In en, this message translates to:
  /// **'NISAR scenes are BETA data'**
  String get warnShortNisarBeta;

  /// No description provided for @warnNisarBeta.
  ///
  /// In en, this message translates to:
  /// **'The NISAR scenes are BETA products, not yet fully calibrated. Treat the results as preliminary.'**
  String get warnNisarBeta;

  /// No description provided for @warnShortDepotAutoSelected.
  ///
  /// In en, this message translates to:
  /// **'Aid depot is auto-selected: routes and priority are illustrative'**
  String get warnShortDepotAutoSelected;

  /// No description provided for @warnDepotAutoSelected.
  ///
  /// In en, this message translates to:
  /// **'The aid depot was AUTO-SELECTED and is not a real depot. Routes and priority are illustrative until the real depot is set.'**
  String get warnDepotAutoSelected;

  /// No description provided for @warnShortValidationProductOrder.
  ///
  /// In en, this message translates to:
  /// **'Validation map was chosen by product order, not by date'**
  String get warnShortValidationProductOrder;

  /// No description provided for @warnValidationProductOrder.
  ///
  /// In en, this message translates to:
  /// **'The EMS validation map was chosen by product order, not by date. Its image was taken {hours} hours after the NISAR scene, so the water may have changed.'**
  String warnValidationProductOrder(String hours);

  /// No description provided for @warnShortClassifierCalibrated.
  ///
  /// In en, this message translates to:
  /// **'Compare mode is not an independent check'**
  String get warnShortClassifierCalibrated;

  /// No description provided for @warnClassifierCalibrated.
  ///
  /// In en, this message translates to:
  /// **'The flood map is a classifier calibrated on the EMSR857 map (spatial cross-validation IoU {classifierIou}, against {thresholdIou} for the threshold map). Agreement with EMS in Compare mode is not an independent check.'**
  String warnClassifierCalibrated(String classifierIou, String thresholdIou);

  /// No description provided for @warningExpandHint.
  ///
  /// In en, this message translates to:
  /// **'Show or hide details'**
  String get warningExpandHint;

  /// No description provided for @appDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This app supports decisions and is not an emergency service.'**
  String get appDisclaimer;

  /// No description provided for @populationIsModelled.
  ///
  /// In en, this message translates to:
  /// **'Population is a modelled estimate, not a census.'**
  String get populationIsModelled;

  /// No description provided for @responseMissions.
  ///
  /// In en, this message translates to:
  /// **'RESPONSE MISSIONS'**
  String get responseMissions;

  /// No description provided for @rankedPockets.
  ///
  /// In en, this message translates to:
  /// **'{count} ranked pockets'**
  String rankedPockets(String count);

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'ALL'**
  String get filterAll;

  /// No description provided for @accessNormalVehicle.
  ///
  /// In en, this message translates to:
  /// **'VEHICLE'**
  String get accessNormalVehicle;

  /// No description provided for @accessHighClearanceTruck.
  ///
  /// In en, this message translates to:
  /// **'HIGH-CLEARANCE TRUCK'**
  String get accessHighClearanceTruck;

  /// No description provided for @accessOnFoot.
  ///
  /// In en, this message translates to:
  /// **'ON FOOT'**
  String get accessOnFoot;

  /// No description provided for @accessBoat.
  ///
  /// In en, this message translates to:
  /// **'BOAT'**
  String get accessBoat;

  /// No description provided for @statusCutOff.
  ///
  /// In en, this message translates to:
  /// **'CUT OFF'**
  String get statusCutOff;

  /// No description provided for @statusDifficult.
  ///
  /// In en, this message translates to:
  /// **'DIFFICULT ACCESS'**
  String get statusDifficult;

  /// No description provided for @serviceClinic.
  ///
  /// In en, this message translates to:
  /// **'Clinic'**
  String get serviceClinic;

  /// No description provided for @serviceMarket.
  ///
  /// In en, this message translates to:
  /// **'Market'**
  String get serviceMarket;

  /// No description provided for @serviceShelter.
  ///
  /// In en, this message translates to:
  /// **'Shelter'**
  String get serviceShelter;

  /// No description provided for @serviceAidDepotLink.
  ///
  /// In en, this message translates to:
  /// **'Aid depot link'**
  String get serviceAidDepotLink;

  /// No description provided for @lostServices.
  ///
  /// In en, this message translates to:
  /// **'Lost: {services}'**
  String lostServices(String services);

  /// No description provided for @limitedServices.
  ///
  /// In en, this message translates to:
  /// **'Difficult: {services}'**
  String limitedServices(String services);

  /// No description provided for @populationEstimate.
  ///
  /// In en, this message translates to:
  /// **'{count} people (estimate)'**
  String populationEstimate(String count);

  /// No description provided for @pocketTitle.
  ///
  /// In en, this message translates to:
  /// **'{direction, select, north{North of {place}} northeast{North-east of {place}} east{East of {place}} southeast{South-east of {place}} south{South of {place}} southwest{South-west of {place}} west{West of {place}} northwest{North-west of {place}} other{Near {place}}}'**
  String pocketTitle(String direction, String place);

  /// No description provided for @estimatedPopulation.
  ///
  /// In en, this message translates to:
  /// **'ESTIMATED POPULATION'**
  String get estimatedPopulation;

  /// No description provided for @whyFlagged.
  ///
  /// In en, this message translates to:
  /// **'WHY FLAGGED'**
  String get whyFlagged;

  /// No description provided for @whyCutOff.
  ///
  /// In en, this message translates to:
  /// **'The flood cuts this area off from: {services}. Reaching it needs: {mode}. Deepest water on the safest route: {depth} (estimate).'**
  String whyCutOff(String services, String mode, String depth);

  /// No description provided for @whyDifficult.
  ///
  /// In en, this message translates to:
  /// **'Reaching these is difficult from this area: {services}. Access needs: {mode}. Deepest water on the safest route: {depth} (estimate).'**
  String whyDifficult(String services, String mode, String depth);

  /// No description provided for @estimatedMaxDepth.
  ///
  /// In en, this message translates to:
  /// **'DEEPEST WATER ON THE SAFEST ROUTE'**
  String get estimatedMaxDepth;

  /// No description provided for @boatLegKm.
  ///
  /// In en, this message translates to:
  /// **'Boat leg: {km} km'**
  String boatLegKm(String km);

  /// No description provided for @routeComparison.
  ///
  /// In en, this message translates to:
  /// **'ROUTE COMPARISON'**
  String get routeComparison;

  /// No description provided for @metric.
  ///
  /// In en, this message translates to:
  /// **'METRIC'**
  String get metric;

  /// No description provided for @shortest.
  ///
  /// In en, this message translates to:
  /// **'SHORTEST'**
  String get shortest;

  /// No description provided for @safestStar.
  ///
  /// In en, this message translates to:
  /// **'SAFEST ★'**
  String get safestStar;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @eta.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get eta;

  /// No description provided for @depthLevel.
  ///
  /// In en, this message translates to:
  /// **'Max depth'**
  String get depthLevel;

  /// No description provided for @accessRisk.
  ///
  /// In en, this message translates to:
  /// **'Risk'**
  String get accessRisk;

  /// No description provided for @uncertainBridges.
  ///
  /// In en, this message translates to:
  /// **'Uncertain bridges'**
  String get uncertainBridges;

  /// No description provided for @routesSame.
  ///
  /// In en, this message translates to:
  /// **'For this pocket the safest route is the same as the shortest.'**
  String get routesSame;

  /// No description provided for @routesDiffer.
  ///
  /// In en, this message translates to:
  /// **'For this pocket the safest route differs from the shortest.'**
  String get routesDiffer;

  /// No description provided for @distanceKm.
  ///
  /// In en, this message translates to:
  /// **'{km} km'**
  String distanceKm(String km);

  /// No description provided for @durationMin.
  ///
  /// In en, this message translates to:
  /// **'{min} min'**
  String durationMin(String min);

  /// No description provided for @levelHigh.
  ///
  /// In en, this message translates to:
  /// **'HIGH'**
  String get levelHigh;

  /// No description provided for @levelMedium.
  ///
  /// In en, this message translates to:
  /// **'MEDIUM'**
  String get levelMedium;

  /// No description provided for @levelLow.
  ///
  /// In en, this message translates to:
  /// **'LOW'**
  String get levelLow;

  /// No description provided for @analysisConfidence.
  ///
  /// In en, this message translates to:
  /// **'ANALYSIS CONFIDENCE'**
  String get analysisConfidence;

  /// No description provided for @stabilityLabel.
  ///
  /// In en, this message translates to:
  /// **'Holds in {pct}% of test scenarios'**
  String stabilityLabel(String pct);

  /// No description provided for @worstCaseMode.
  ///
  /// In en, this message translates to:
  /// **'Worst case, prepare: {mode}'**
  String worstCaseMode(String mode);

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @systemHonestyBrief.
  ///
  /// In en, this message translates to:
  /// **'SYSTEM & HONESTY BRIEF'**
  String get systemHonestyBrief;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'AccessWatch Mobile'**
  String get appTitle;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Satellite radar flood access analysis'**
  String get appSubtitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get settingsTitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageDevice.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get languageDevice;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languagePortuguese.
  ///
  /// In en, this message translates to:
  /// **'Português'**
  String get languagePortuguese;

  /// No description provided for @textSize.
  ///
  /// In en, this message translates to:
  /// **'Text size: {pct}%'**
  String textSize(String pct);

  /// No description provided for @presentationMode.
  ///
  /// In en, this message translates to:
  /// **'Presentation mode'**
  String get presentationMode;

  /// No description provided for @presentationModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Hide the bottom navigation for screen recording'**
  String get presentationModeSubtitle;

  /// No description provided for @dataDates.
  ///
  /// In en, this message translates to:
  /// **'DATA DATES'**
  String get dataDates;

  /// No description provided for @dateNisarBefore.
  ///
  /// In en, this message translates to:
  /// **'NISAR before the flood: {date}'**
  String dateNisarBefore(String date);

  /// No description provided for @dateNisarAfter.
  ///
  /// In en, this message translates to:
  /// **'NISAR after the flood: {date}'**
  String dateNisarAfter(String date);

  /// No description provided for @dateEmsImage.
  ///
  /// In en, this message translates to:
  /// **'EMS image: {date}'**
  String dateEmsImage(String date);

  /// No description provided for @howDepthEstimated.
  ///
  /// In en, this message translates to:
  /// **'HOW DEPTH IS ESTIMATED'**
  String get howDepthEstimated;

  /// No description provided for @depthDescription.
  ///
  /// In en, this message translates to:
  /// **'Radar shows where the water is, not how deep it is. Depth classes are estimated from the flood edge and a surface elevation model, so they are indicative only.'**
  String get depthDescription;

  /// No description provided for @waterDepthSummary.
  ///
  /// In en, this message translates to:
  /// **'WATER DEPTH SUMMARY'**
  String get waterDepthSummary;

  /// No description provided for @dataSources.
  ///
  /// In en, this message translates to:
  /// **'DATA SOURCES & ATTRIBUTION'**
  String get dataSources;

  /// No description provided for @notAffiliated.
  ///
  /// In en, this message translates to:
  /// **'Not affiliated with or endorsed by NASA, ISRO or Copernicus.'**
  String get notAffiliated;

  /// No description provided for @depthBelow.
  ///
  /// In en, this message translates to:
  /// **'< {limit} m'**
  String depthBelow(String limit);

  /// No description provided for @depthBetween.
  ///
  /// In en, this message translates to:
  /// **'{low}–{high} m'**
  String depthBetween(String low, String high);

  /// No description provided for @depthAbove.
  ///
  /// In en, this message translates to:
  /// **'> {limit} m'**
  String depthAbove(String limit);

  /// No description provided for @osmAttribution.
  ///
  /// In en, this message translates to:
  /// **'© OpenStreetMap contributors'**
  String get osmAttribution;

  /// No description provided for @mapDates.
  ///
  /// In en, this message translates to:
  /// **'NISAR {before} – {after} · EMS {ems}'**
  String mapDates(String before, String after, String ems);

  /// No description provided for @warningsToggle.
  ///
  /// In en, this message translates to:
  /// **'{count} warnings'**
  String warningsToggle(String count);

  /// No description provided for @tooltipLayers.
  ///
  /// In en, this message translates to:
  /// **'Layers'**
  String get tooltipLayers;

  /// No description provided for @tooltipLegend.
  ///
  /// In en, this message translates to:
  /// **'Legend'**
  String get tooltipLegend;

  /// No description provided for @tooltipCompare.
  ///
  /// In en, this message translates to:
  /// **'Compare with EMS'**
  String get tooltipCompare;

  /// No description provided for @tooltipLocate.
  ///
  /// In en, this message translates to:
  /// **'Show my location'**
  String get tooltipLocate;

  /// No description provided for @tooltipZoomIn.
  ///
  /// In en, this message translates to:
  /// **'Zoom in'**
  String get tooltipZoomIn;

  /// No description provided for @tooltipZoomOut.
  ///
  /// In en, this message translates to:
  /// **'Zoom out'**
  String get tooltipZoomOut;

  /// No description provided for @tooltipFit.
  ///
  /// In en, this message translates to:
  /// **'Show the whole area'**
  String get tooltipFit;

  /// No description provided for @layersControl.
  ///
  /// In en, this message translates to:
  /// **'LAYERS'**
  String get layersControl;

  /// No description provided for @layerDepth.
  ///
  /// In en, this message translates to:
  /// **'Water depth (estimate)'**
  String get layerDepth;

  /// No description provided for @layerFlood.
  ///
  /// In en, this message translates to:
  /// **'Flood extent'**
  String get layerFlood;

  /// No description provided for @layerEms.
  ///
  /// In en, this message translates to:
  /// **'Official EMS flood'**
  String get layerEms;

  /// No description provided for @layerRoads.
  ///
  /// In en, this message translates to:
  /// **'Flooded roads'**
  String get layerRoads;

  /// No description provided for @layerPockets.
  ///
  /// In en, this message translates to:
  /// **'Pockets'**
  String get layerPockets;

  /// No description provided for @layerRoutes.
  ///
  /// In en, this message translates to:
  /// **'Routes'**
  String get layerRoutes;

  /// No description provided for @layerServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get layerServices;

  /// No description provided for @layerCompare.
  ///
  /// In en, this message translates to:
  /// **'Compare with EMS'**
  String get layerCompare;

  /// No description provided for @opacityLabel.
  ///
  /// In en, this message translates to:
  /// **'Opacity {pct}%'**
  String opacityLabel(String pct);

  /// No description provided for @depthDetailNote.
  ///
  /// In en, this message translates to:
  /// **'At low zoom only the largest depth patches are drawn, with smoothed edges. Zoom in to see them all.'**
  String get depthDetailNote;

  /// No description provided for @legendTitle.
  ///
  /// In en, this message translates to:
  /// **'LEGEND'**
  String get legendTitle;

  /// No description provided for @legendPocketRisk.
  ///
  /// In en, this message translates to:
  /// **'Pocket, {level} risk'**
  String legendPocketRisk(String level);

  /// No description provided for @legendSafest.
  ///
  /// In en, this message translates to:
  /// **'Safest route'**
  String get legendSafest;

  /// No description provided for @legendShortest.
  ///
  /// In en, this message translates to:
  /// **'Shortest route (dashed)'**
  String get legendShortest;

  /// No description provided for @legendRoad.
  ///
  /// In en, this message translates to:
  /// **'Flooded road, by depth'**
  String get legendRoad;

  /// No description provided for @legendEms.
  ///
  /// In en, this message translates to:
  /// **'Official EMS flood outline'**
  String get legendEms;

  /// No description provided for @legendClinic.
  ///
  /// In en, this message translates to:
  /// **'Clinic'**
  String get legendClinic;

  /// No description provided for @legendMarket.
  ///
  /// In en, this message translates to:
  /// **'Market'**
  String get legendMarket;

  /// No description provided for @legendShelter.
  ///
  /// In en, this message translates to:
  /// **'Shelter'**
  String get legendShelter;

  /// No description provided for @legendDepot.
  ///
  /// In en, this message translates to:
  /// **'Aid depot'**
  String get legendDepot;

  /// No description provided for @legendMe.
  ///
  /// In en, this message translates to:
  /// **'My location'**
  String get legendMe;

  /// No description provided for @compareTitle.
  ///
  /// In en, this message translates to:
  /// **'COMPARE WITH EMS'**
  String get compareTitle;

  /// No description provided for @compareBoth.
  ///
  /// In en, this message translates to:
  /// **'Both maps: {area} km²'**
  String compareBoth(String area);

  /// No description provided for @compareOnlyOurs.
  ///
  /// In en, this message translates to:
  /// **'Only our map: {area} km²'**
  String compareOnlyOurs(String area);

  /// No description provided for @compareOnlyEms.
  ///
  /// In en, this message translates to:
  /// **'Only EMS: {area} km²'**
  String compareOnlyEms(String area);

  /// No description provided for @compareIou.
  ///
  /// In en, this message translates to:
  /// **'Agreement (IoU): {iou}'**
  String compareIou(String iou);

  /// No description provided for @compareNotIndependent.
  ///
  /// In en, this message translates to:
  /// **'Not an independent check: our flood map was calibrated on this EMS map.'**
  String get compareNotIndependent;

  /// No description provided for @compareEmsDate.
  ///
  /// In en, this message translates to:
  /// **'EMS image: {date}, {hours} hours after the NISAR scene.'**
  String compareEmsDate(String date, String hours);

  /// No description provided for @compareTransparent.
  ///
  /// In en, this message translates to:
  /// **'Clear areas are dry in both maps, or outside the area EMS mapped.'**
  String get compareTransparent;

  /// No description provided for @rankedPocketsTitle.
  ///
  /// In en, this message translates to:
  /// **'RANKED POCKETS'**
  String get rankedPocketsTitle;

  /// No description provided for @allPockets.
  ///
  /// In en, this message translates to:
  /// **'ALL'**
  String get allPockets;

  /// No description provided for @routeSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'{pocket}: {route}'**
  String routeSheetTitle(String pocket, String route);

  /// No description provided for @routeSafestLabel.
  ///
  /// In en, this message translates to:
  /// **'Safest route'**
  String get routeSafestLabel;

  /// No description provided for @routeShortestLabel.
  ///
  /// In en, this message translates to:
  /// **'Shortest route'**
  String get routeShortestLabel;

  /// No description provided for @routeAccess.
  ///
  /// In en, this message translates to:
  /// **'Access'**
  String get routeAccess;

  /// No description provided for @routeWaterKm.
  ///
  /// In en, this message translates to:
  /// **'Water on route'**
  String get routeWaterKm;

  /// No description provided for @routeWaterValue.
  ///
  /// In en, this message translates to:
  /// **'{shallow} / {medium} / {deep} km (shallow / medium / deep)'**
  String routeWaterValue(String shallow, String medium, String deep);

  /// No description provided for @routesIllustrative.
  ///
  /// In en, this message translates to:
  /// **'Distances and times are estimates, and the route starts from the auto-selected depot.'**
  String get routesIllustrative;

  /// No description provided for @sheetServiceType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get sheetServiceType;

  /// No description provided for @sheetStatus.
  ///
  /// In en, this message translates to:
  /// **'Access status'**
  String get sheetStatus;

  /// No description provided for @clinicReachable.
  ///
  /// In en, this message translates to:
  /// **'Reachable on dry roads'**
  String get clinicReachable;

  /// No description provided for @clinicAccessFlooded.
  ///
  /// In en, this message translates to:
  /// **'Access road flooded'**
  String get clinicAccessFlooded;

  /// No description provided for @clinicInsidePocket.
  ///
  /// In en, this message translates to:
  /// **'Inside pocket {pocket}'**
  String clinicInsidePocket(String pocket);

  /// No description provided for @clinicStatusNote.
  ///
  /// In en, this message translates to:
  /// **'This shows whether the clinic connects to the main dry road network. It does not say whether a cut-off pocket can reach it.'**
  String get clinicStatusNote;

  /// No description provided for @clinicDuplicateNote.
  ///
  /// In en, this message translates to:
  /// **'Mapped records can repeat one facility, so nearby clinics may be the same place.'**
  String get clinicDuplicateNote;

  /// No description provided for @locationOff.
  ///
  /// In en, this message translates to:
  /// **'Location is turned off on this device.'**
  String get locationOff;

  /// No description provided for @locationDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission was not given.'**
  String get locationDenied;

  /// No description provided for @locationOutside.
  ///
  /// In en, this message translates to:
  /// **'You are outside the mapped area.'**
  String get locationOutside;

  /// No description provided for @viewOnMap.
  ///
  /// In en, this message translates to:
  /// **'SHOW ON MAP'**
  String get viewOnMap;

  /// No description provided for @layerBaseline.
  ///
  /// In en, this message translates to:
  /// **'Physics-only flood map'**
  String get layerBaseline;

  /// No description provided for @layerBaselineNote.
  ///
  /// In en, this message translates to:
  /// **'The threshold-based map from before the EMS calibration. It is more cautious: it finds less flood.'**
  String get layerBaselineNote;

  /// No description provided for @rankingTitle.
  ///
  /// In en, this message translates to:
  /// **'RANKING WEIGHTS'**
  String get rankingTitle;

  /// No description provided for @rankingShow.
  ///
  /// In en, this message translates to:
  /// **'Show the sliders'**
  String get rankingShow;

  /// No description provided for @rankingHide.
  ///
  /// In en, this message translates to:
  /// **'Hide the sliders'**
  String get rankingHide;

  /// No description provided for @rankingReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get rankingReset;

  /// No description provided for @weightPeople.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get weightPeople;

  /// No description provided for @weightServiceLoss.
  ///
  /// In en, this message translates to:
  /// **'Service loss'**
  String get weightServiceLoss;

  /// No description provided for @weightDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get weightDifficulty;

  /// No description provided for @rankingChoiceNote.
  ///
  /// In en, this message translates to:
  /// **'The weights are a choice, not science. At 1.00 each they give the published ranking.'**
  String get rankingChoiceNote;

  /// No description provided for @rankingDominated.
  ///
  /// In en, this message translates to:
  /// **'{pocket} holds {pct}% of the estimated people, so it dominates this list and the weights mostly reorder the others.'**
  String rankingDominated(String pocket, String pct);

  /// No description provided for @rankingTies.
  ///
  /// In en, this message translates to:
  /// **'Pockets with equal terms tie, whatever the weights, and keep their published order.'**
  String get rankingTies;

  /// No description provided for @rankingDepotNote.
  ///
  /// In en, this message translates to:
  /// **'The aid depot is auto-selected, so this ranking is illustrative.'**
  String get rankingDepotNote;

  /// No description provided for @publishedRank.
  ///
  /// In en, this message translates to:
  /// **'Published rank: #{rank}'**
  String publishedRank(String rank);

  /// No description provided for @missionNotFound.
  ///
  /// In en, this message translates to:
  /// **'No mission {id}. Back to the list.'**
  String missionNotFound(String id);

  /// No description provided for @serviceAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'SERVICE ACCESS'**
  String get serviceAccessTitle;

  /// No description provided for @accessYes.
  ///
  /// In en, this message translates to:
  /// **'reachable'**
  String get accessYes;

  /// No description provided for @accessDifficult.
  ///
  /// In en, this message translates to:
  /// **'difficult'**
  String get accessDifficult;

  /// No description provided for @accessNo.
  ///
  /// In en, this message translates to:
  /// **'cut off'**
  String get accessNo;

  /// No description provided for @accessNotApplicable.
  ///
  /// In en, this message translates to:
  /// **'not applicable'**
  String get accessNotApplicable;

  /// No description provided for @accessWasMinutes.
  ///
  /// In en, this message translates to:
  /// **'(about {minutes} min before the flood)'**
  String accessWasMinutes(String minutes);

  /// No description provided for @priorityTermsTitle.
  ///
  /// In en, this message translates to:
  /// **'PRIORITY TERMS (0 TO 1)'**
  String get priorityTermsTitle;

  /// No description provided for @verifyTitle.
  ///
  /// In en, this message translates to:
  /// **'VERIFY ON THE GROUND'**
  String get verifyTitle;

  /// No description provided for @verifyLowConfidence.
  ///
  /// In en, this message translates to:
  /// **'Low confidence: at least one exit road may not really be blocked (uncertain depth or bridge).'**
  String get verifyLowConfidence;

  /// No description provided for @verifyBoatRoute.
  ///
  /// In en, this message translates to:
  /// **'The boat route follows the flooded roads, which is an approximation: check currents, debris and the actual landing point.'**
  String get verifyBoatRoute;

  /// No description provided for @verifyUnstable.
  ///
  /// In en, this message translates to:
  /// **'This pocket disappears or changes when the flood extent or depth is slightly off: verify it first.'**
  String get verifyUnstable;

  /// No description provided for @verifyShortestDeep.
  ///
  /// In en, this message translates to:
  /// **'The shortest road route ({km} km) crosses deep water: avoid it.'**
  String verifyShortestDeep(String km);

  /// No description provided for @verifyEstimates.
  ///
  /// In en, this message translates to:
  /// **'Depth classes come from a surface model and population is modelled: confirm both with local responders.'**
  String get verifyEstimates;

  /// No description provided for @shareAlert.
  ///
  /// In en, this message translates to:
  /// **'SHARE ALERT'**
  String get shareAlert;

  /// No description provided for @alertTitle.
  ///
  /// In en, this message translates to:
  /// **'Alert for field teams'**
  String get alertTitle;

  /// No description provided for @alertCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get alertCopy;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @alertHeadline.
  ///
  /// In en, this message translates to:
  /// **'ACCESSWATCH #{rank} {pocket}, {place}: about {people} people (estimate).'**
  String alertHeadline(String rank, String pocket, String place, String people);

  /// No description provided for @alertNeeds.
  ///
  /// In en, this message translates to:
  /// **'Needs: {mode}.'**
  String alertNeeds(String mode);

  /// No description provided for @alertBoatLeg.
  ///
  /// In en, this message translates to:
  /// **'{mode} ({km} km by water)'**
  String alertBoatLeg(String mode, String km);

  /// No description provided for @alertRoute.
  ///
  /// In en, this message translates to:
  /// **'Route {km} km, risk {risk}, confidence {confidence}.'**
  String alertRoute(String km, String risk, String confidence);

  /// No description provided for @alertDataDate.
  ///
  /// In en, this message translates to:
  /// **'Data from {date}.'**
  String alertDataDate(String date);

  /// No description provided for @alertCustomWeights.
  ///
  /// In en, this message translates to:
  /// **'Rank uses custom weights.'**
  String get alertCustomWeights;

  /// No description provided for @alertDepot.
  ///
  /// In en, this message translates to:
  /// **'Route starts at an auto-selected depot, so it is illustrative.'**
  String get alertDepot;

  /// No description provided for @alertVerify.
  ///
  /// In en, this message translates to:
  /// **'VERIFY ON THE GROUND.'**
  String get alertVerify;

  /// No description provided for @verifyBridges.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Verify 1 bridge on the route on the ground first: radar cannot see its condition.} other{Verify {count} bridges on the route on the ground first: radar cannot see their condition.}}'**
  String verifyBridges(int count);

  /// No description provided for @tabCare.
  ///
  /// In en, this message translates to:
  /// **'Care'**
  String get tabCare;

  /// No description provided for @careTitle.
  ///
  /// In en, this message translates to:
  /// **'CARE'**
  String get careTitle;

  /// No description provided for @careSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Clinics and how to reach them'**
  String get careSubtitle;

  /// No description provided for @mySpotTitle.
  ///
  /// In en, this message translates to:
  /// **'MY SPOT'**
  String get mySpotTitle;

  /// No description provided for @mySpotIntro.
  ///
  /// In en, this message translates to:
  /// **'Check your position against the flood map: in the flood or not, the estimated depth, and the nearest clinic you can reach by road.'**
  String get mySpotIntro;

  /// No description provided for @useMyLocation.
  ///
  /// In en, this message translates to:
  /// **'Use my location'**
  String get useMyLocation;

  /// No description provided for @mySpotWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting for location…'**
  String get mySpotWaiting;

  /// No description provided for @testPositionBadge.
  ///
  /// In en, this message translates to:
  /// **'TEST POSITION (DEBUG BUILD)'**
  String get testPositionBadge;

  /// No description provided for @testPositionHint.
  ///
  /// In en, this message translates to:
  /// **'Debug build: long-press the map to set a test position.'**
  String get testPositionHint;

  /// No description provided for @spotOutside.
  ///
  /// In en, this message translates to:
  /// **'You are outside the mapped area. AccessWatch cannot check this spot or route from it.'**
  String get spotOutside;

  /// No description provided for @spotInFlood.
  ///
  /// In en, this message translates to:
  /// **'Inside the mapped flood'**
  String get spotInFlood;

  /// No description provided for @spotNotInFlood.
  ///
  /// In en, this message translates to:
  /// **'Not inside the mapped flood'**
  String get spotNotInFlood;

  /// No description provided for @spotDepth.
  ///
  /// In en, this message translates to:
  /// **'Estimated depth here: {depth} {range}'**
  String spotDepth(String depth, String range);

  /// No description provided for @spotFloodedRoad.
  ///
  /// In en, this message translates to:
  /// **'Nearest flooded road: {metres} m away'**
  String spotFloodedRoad(String metres);

  /// No description provided for @spotSnapped.
  ///
  /// In en, this message translates to:
  /// **'Routes start at the nearest road point, {metres} m away'**
  String spotSnapped(String metres);

  /// No description provided for @spotNearestClinic.
  ///
  /// In en, this message translates to:
  /// **'Nearest clinic by road: {clinic} ({mode}, {km} km)'**
  String spotNearestClinic(String clinic, String mode, String km);

  /// No description provided for @routingFailed.
  ///
  /// In en, this message translates to:
  /// **'Routes could not be worked out.'**
  String get routingFailed;

  /// No description provided for @needsBoatAny.
  ///
  /// In en, this message translates to:
  /// **'Needs a boat: no road route reaches any clinic from here.'**
  String get needsBoatAny;

  /// No description provided for @needsBoatClinic.
  ///
  /// In en, this message translates to:
  /// **'Needs a boat: no road route reaches {clinic} from here.'**
  String needsBoatClinic(String clinic);

  /// No description provided for @needsBoatShort.
  ///
  /// In en, this message translates to:
  /// **'Needs a boat from your spot'**
  String get needsBoatShort;

  /// No description provided for @routesToClinic.
  ///
  /// In en, this message translates to:
  /// **'ROUTE TO A CLINIC'**
  String get routesToClinic;

  /// No description provided for @criterionFastest.
  ///
  /// In en, this message translates to:
  /// **'Fastest'**
  String get criterionFastest;

  /// No description provided for @criterionSafest.
  ///
  /// In en, this message translates to:
  /// **'Safest'**
  String get criterionSafest;

  /// No description provided for @targetNearest.
  ///
  /// In en, this message translates to:
  /// **'To the nearest clinic each way of travel can reach.'**
  String get targetNearest;

  /// No description provided for @targetChosen.
  ///
  /// In en, this message translates to:
  /// **'To {clinic}'**
  String targetChosen(String clinic);

  /// No description provided for @targetUseNearest.
  ///
  /// In en, this message translates to:
  /// **'Use nearest'**
  String get targetUseNearest;

  /// No description provided for @careModeCar.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get careModeCar;

  /// No description provided for @careModeTruck.
  ///
  /// In en, this message translates to:
  /// **'High-clearance truck'**
  String get careModeTruck;

  /// No description provided for @careModeFoot.
  ///
  /// In en, this message translates to:
  /// **'On foot'**
  String get careModeFoot;

  /// No description provided for @noRouteForMode.
  ///
  /// In en, this message translates to:
  /// **'No route by {mode}: water or blocked roads are in the way.'**
  String noRouteForMode(String mode);

  /// No description provided for @routeDistanceTime.
  ///
  /// In en, this message translates to:
  /// **'{km} km, about {minutes} min'**
  String routeDistanceTime(String km, String minutes);

  /// No description provided for @routeWater.
  ///
  /// In en, this message translates to:
  /// **'Water on the way: {shallow} m shallow, {medium} m medium (estimate)'**
  String routeWater(String shallow, String medium);

  /// No description provided for @routeBridges.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 bridge to check on the ground: radar cannot see its condition} other{{count} bridges to check on the ground: radar cannot see their condition}}'**
  String routeBridges(int count);

  /// No description provided for @routeNoWalkingTime.
  ///
  /// In en, this message translates to:
  /// **'Walking time is not in the data, so only the distance is shown.'**
  String get routeNoWalkingTime;

  /// No description provided for @routeTimeRounded.
  ///
  /// In en, this message translates to:
  /// **'Time is a vehicle estimate from rounded data: allow a few minutes either way.'**
  String get routeTimeRounded;

  /// No description provided for @showRouteOnMap.
  ///
  /// In en, this message translates to:
  /// **'Show on map'**
  String get showRouteOnMap;

  /// No description provided for @careRouteTo.
  ///
  /// In en, this message translates to:
  /// **'To {clinic} by {mode}'**
  String careRouteTo(String clinic, String mode);

  /// No description provided for @clearRoute.
  ///
  /// In en, this message translates to:
  /// **'Clear the route'**
  String get clearRoute;

  /// No description provided for @clinicsTitle.
  ///
  /// In en, this message translates to:
  /// **'CLINICS ({count})'**
  String clinicsTitle(String count);

  /// No description provided for @locationWhyTitle.
  ///
  /// In en, this message translates to:
  /// **'Why your location?'**
  String get locationWhyTitle;

  /// No description provided for @locationWhyBody.
  ///
  /// In en, this message translates to:
  /// **'AccessWatch uses your position only while Map or Care is open, to check it against the flood map and route you to a clinic. The app does not send your position anywhere, though map tiles for the area you view come from OpenStreetMap.'**
  String get locationWhyBody;

  /// No description provided for @locationContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get locationContinue;

  /// No description provided for @locationNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get locationNotNow;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
