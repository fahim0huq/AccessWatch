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

  /// No description provided for @tabMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get tabMap;

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

  /// No description provided for @eventMozambique2026.
  ///
  /// In en, this message translates to:
  /// **'Mozambique flood, January 2026'**
  String get eventMozambique2026;

  /// No description provided for @floodAreaKm2.
  ///
  /// In en, this message translates to:
  /// **'{area} km²'**
  String floodAreaKm2(String area);

  /// No description provided for @depthDry.
  ///
  /// In en, this message translates to:
  /// **'Dry'**
  String get depthDry;

  /// No description provided for @depthShallow.
  ///
  /// In en, this message translates to:
  /// **'Shallow'**
  String get depthShallow;

  /// No description provided for @depthMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get depthMedium;

  /// No description provided for @depthDeep.
  ///
  /// In en, this message translates to:
  /// **'Deep'**
  String get depthDeep;

  /// No description provided for @depthUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get depthUnknown;

  /// No description provided for @depthEstimateWarning.
  ///
  /// In en, this message translates to:
  /// **'Depth is an estimate, shown as classes and not exact metres. Verify on the ground.'**
  String get depthEstimateWarning;

  /// No description provided for @warningsTitle.
  ///
  /// In en, this message translates to:
  /// **'Data warnings'**
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

  /// No description provided for @whyFlagged.
  ///
  /// In en, this message translates to:
  /// **'Why flagged'**
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
  /// **'Deepest water on the safest route'**
  String get estimatedMaxDepth;

  /// No description provided for @boatLegKm.
  ///
  /// In en, this message translates to:
  /// **'Boat leg: {km} km'**
  String boatLegKm(String km);

  /// No description provided for @routeComparison.
  ///
  /// In en, this message translates to:
  /// **'Route comparison'**
  String get routeComparison;

  /// No description provided for @metric.
  ///
  /// In en, this message translates to:
  /// **'Metric'**
  String get metric;

  /// No description provided for @shortest.
  ///
  /// In en, this message translates to:
  /// **'Shortest'**
  String get shortest;

  /// No description provided for @safestStar.
  ///
  /// In en, this message translates to:
  /// **'Safest ★'**
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
  /// **'For this area the safest route is the same as the shortest.'**
  String get routesSame;

  /// No description provided for @routesDiffer.
  ///
  /// In en, this message translates to:
  /// **'For this area the safest route differs from the shortest.'**
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

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

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
  /// **'Data dates'**
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

  /// No description provided for @dataSources.
  ///
  /// In en, this message translates to:
  /// **'Data sources & attribution'**
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
  /// **'Layers'**
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
  /// **'Legend'**
  String get legendTitle;

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
  /// **'Compare with EMS'**
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
  /// **'Not an independent check: our flood map was calibrated on this EMS map, so its agreement with it (IoU {agreement}; {crossValidation} in spatial cross-validation) says little about accuracy elsewhere. The physics-only map, made without EMS, agrees less (IoU {physicsOnly}) and is the more conservative one: it marks less flood.'**
  String compareNotIndependent(
    String agreement,
    String crossValidation,
    String physicsOnly,
  );

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
  /// **'Inside cut-off area {pocket}'**
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
  /// **'Show on map'**
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
  /// **'Ranking weights'**
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

  /// No description provided for @missionNotFound.
  ///
  /// In en, this message translates to:
  /// **'No mission {id}. Back to the list.'**
  String missionNotFound(String id);

  /// No description provided for @serviceAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Service access'**
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
  /// **'Priority terms (0 to 1)'**
  String get priorityTermsTitle;

  /// No description provided for @verifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify on the ground'**
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
  /// **'This area disappears or changes when the flood extent or depth is slightly off: check it first.'**
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
  /// **'Share alert'**
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
  /// **'Test position (debug build)'**
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

  /// No description provided for @warnShortDepotAssumed.
  ///
  /// In en, this message translates to:
  /// **'Aid depot location is assumed'**
  String get warnShortDepotAssumed;

  /// No description provided for @warnDepotAssumed.
  ///
  /// In en, this message translates to:
  /// **'The aid depot location is assumed, not confirmed. Routes and priority depend on it: confirm the real depot before acting.'**
  String get warnDepotAssumed;

  /// No description provided for @dateEmsGap.
  ///
  /// In en, this message translates to:
  /// **'The EMS image was taken {hours} hours after the NISAR \"after\" scene, so the water may have changed in between.'**
  String dateEmsGap(String hours);

  /// No description provided for @knownIssuesTitle.
  ///
  /// In en, this message translates to:
  /// **'Known issues in this data'**
  String get knownIssuesTitle;

  /// No description provided for @knownIssuesNone.
  ///
  /// In en, this message translates to:
  /// **'The data records no known issues.'**
  String get knownIssuesNone;

  /// No description provided for @issueRankInversion.
  ///
  /// In en, this message translates to:
  /// **'{higher} ranks above {lower} although {lower} has more people: their priority terms are equal after rounding.'**
  String issueRankInversion(String higher, String lower);

  /// No description provided for @issueSafestCount.
  ///
  /// In en, this message translates to:
  /// **'The validation report says the safest route differs from the shortest for {report} pocket(s), but the route data shows {routes}.'**
  String issueSafestCount(String report, String routes);

  /// No description provided for @issueRoadsOutsideCoverage.
  ///
  /// In en, this message translates to:
  /// **'{count} road pieces reach outside the radar coverage; {dry} of them are labelled dry, which may only mean the radar did not see them.'**
  String issueRoadsOutsideCoverage(String count, String dry);

  /// No description provided for @issuePocketOutsideCoverage.
  ///
  /// In en, this message translates to:
  /// **'{pct}% of pocket {pocket} lies outside the radar coverage.'**
  String issuePocketOutsideCoverage(String pct, String pocket);

  /// No description provided for @issueClinicDuplicates.
  ///
  /// In en, this message translates to:
  /// **'The {records} clinic records include {pairs} pairs less than 100 m apart, so some may be the same clinic counted twice.'**
  String issueClinicDuplicates(String records, String pairs);

  /// No description provided for @validationTitle.
  ///
  /// In en, this message translates to:
  /// **'How well the flood map agrees'**
  String get validationTitle;

  /// No description provided for @scoreIou.
  ///
  /// In en, this message translates to:
  /// **'Agreement with EMS (IoU)'**
  String get scoreIou;

  /// No description provided for @scoreF1.
  ///
  /// In en, this message translates to:
  /// **'F1 score'**
  String get scoreF1;

  /// No description provided for @scorePrecision.
  ///
  /// In en, this message translates to:
  /// **'Precision (flood we mark that EMS also marks)'**
  String get scorePrecision;

  /// No description provided for @scoreRecall.
  ///
  /// In en, this message translates to:
  /// **'Recall (EMS flood we also mark)'**
  String get scoreRecall;

  /// No description provided for @scoreCrossValidation.
  ///
  /// In en, this message translates to:
  /// **'Spatial cross-validation (IoU)'**
  String get scoreCrossValidation;

  /// No description provided for @scorePhysicsOnly.
  ///
  /// In en, this message translates to:
  /// **'Physics-only map vs EMS (IoU)'**
  String get scorePhysicsOnly;

  /// No description provided for @scoreStablePockets.
  ///
  /// In en, this message translates to:
  /// **'Pockets that hold in every test scenario'**
  String get scoreStablePockets;

  /// No description provided for @validationReference.
  ///
  /// In en, this message translates to:
  /// **'Reference map: {layer}'**
  String validationReference(String layer);

  /// No description provided for @limitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Limits, in plain words'**
  String get limitsTitle;

  /// No description provided for @limitDepth.
  ///
  /// In en, this message translates to:
  /// **'Radar shows where water is, not how deep it is. Depth is estimated from a surface model, so the classes are a guide, not measurements.'**
  String get limitDepth;

  /// No description provided for @limitRadar.
  ///
  /// In en, this message translates to:
  /// **'The radar finds open water well but can miss water under trees or between buildings.'**
  String get limitRadar;

  /// No description provided for @limitRoads.
  ///
  /// In en, this message translates to:
  /// **'Roads come from OpenStreetMap: {pct}% of buildings are within 150 m of a mapped road, and {fragments} small disconnected road pieces were left out.'**
  String limitRoads(String pct, String fragments);

  /// No description provided for @limitPopulation.
  ///
  /// In en, this message translates to:
  /// **'People counts come from a population model, not a census.'**
  String get limitPopulation;

  /// No description provided for @limitBoat.
  ///
  /// In en, this message translates to:
  /// **'Boat routes follow the flooded roads, so real water routes can differ. Bridges cannot be checked from space.'**
  String get limitBoat;

  /// No description provided for @limitThresholds.
  ///
  /// In en, this message translates to:
  /// **'The depth and vehicle limits are adjustable defaults: confirm them with local responders and always check on the ground.'**
  String get limitThresholds;

  /// No description provided for @limitUntranslated.
  ///
  /// In en, this message translates to:
  /// **'(Only in English for now) {text}'**
  String limitUntranslated(String text);

  /// No description provided for @colorsTitle.
  ///
  /// In en, this message translates to:
  /// **'How to read the colours'**
  String get colorsTitle;

  /// No description provided for @sourceWebsite.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get sourceWebsite;

  /// No description provided for @sourceDocs.
  ///
  /// In en, this message translates to:
  /// **'Documentation'**
  String get sourceDocs;

  /// No description provided for @sourceDoi.
  ///
  /// In en, this message translates to:
  /// **'DOI: {doi}'**
  String sourceDoi(String doi);

  /// No description provided for @sourceLicence.
  ///
  /// In en, this message translates to:
  /// **'Licence: {licence}'**
  String sourceLicence(String licence);

  /// No description provided for @readIntroAgain.
  ///
  /// In en, this message translates to:
  /// **'Read the safety message again'**
  String get readIntroAgain;

  /// No description provided for @introTitle1.
  ///
  /// In en, this message translates to:
  /// **'See who the flood cuts off'**
  String get introTitle1;

  /// No description provided for @introBody1.
  ///
  /// In en, this message translates to:
  /// **'AccessWatch shows where floodwater cuts people off from clinics, markets and shelters, and how to reach them. It is built from satellite radar: depth and population are estimates.'**
  String get introBody1;

  /// No description provided for @introBody2.
  ///
  /// In en, this message translates to:
  /// **'The flood map comes from NISAR radar, checked against the Copernicus EMS map. Depth and population are estimates, and the radar data is still in beta.'**
  String get introBody2;

  /// No description provided for @safetyTitle.
  ///
  /// In en, this message translates to:
  /// **'Before you start'**
  String get safetyTitle;

  /// No description provided for @safetyBody.
  ///
  /// In en, this message translates to:
  /// **'AccessWatch supports decisions and is not an emergency service. The data can be wrong or out of date: always check on the ground before acting.'**
  String get safetyBody;

  /// No description provided for @safetyEmergency.
  ///
  /// In en, this message translates to:
  /// **'If you are in danger, call your local emergency number.'**
  String get safetyEmergency;

  /// No description provided for @safetyAccept.
  ///
  /// In en, this message translates to:
  /// **'I understand'**
  String get safetyAccept;

  /// No description provided for @rankingDepotAssumedNote.
  ///
  /// In en, this message translates to:
  /// **'The aid depot location is assumed, not confirmed, so this ranking is illustrative.'**
  String get rankingDepotAssumedNote;

  /// No description provided for @alertDepotAssumed.
  ///
  /// In en, this message translates to:
  /// **'Route starts at an assumed, unconfirmed depot location, so it is illustrative.'**
  String get alertDepotAssumed;

  /// No description provided for @dataAge.
  ///
  /// In en, this message translates to:
  /// **'Data acquired {date} (NISAR radar). This is a snapshot from {days, plural, =0{today} =1{1 day ago} other{{days} days ago}}: the water has changed since.'**
  String dataAge(String date, int days);

  /// No description provided for @offlineBanner.
  ///
  /// In en, this message translates to:
  /// **'No network connection. Everything works from the data inside the app, except the map background and web links.'**
  String get offlineBanner;

  /// No description provided for @offlineWorks.
  ///
  /// In en, this message translates to:
  /// **'All analysis data is inside the app, so it works offline. Only the map background and web links need a network.'**
  String get offlineWorks;

  /// No description provided for @mapSemanticsLabel.
  ///
  /// In en, this message translates to:
  /// **'Flood map. The same areas are listed on the Help first tab.'**
  String get mapSemanticsLabel;

  /// No description provided for @alreadyAtClinic.
  ///
  /// In en, this message translates to:
  /// **'You\'re already at {clinic}: no route needed.'**
  String alreadyAtClinic(String clinic);

  /// No description provided for @alreadyHereShort.
  ///
  /// In en, this message translates to:
  /// **'You\'re here'**
  String get alreadyHereShort;

  /// No description provided for @tabHelpFirst.
  ///
  /// In en, this message translates to:
  /// **'Help first'**
  String get tabHelpFirst;

  /// No description provided for @tabFindCare.
  ///
  /// In en, this message translates to:
  /// **'Find care'**
  String get tabFindCare;

  /// No description provided for @aboutThisData.
  ///
  /// In en, this message translates to:
  /// **'About this data'**
  String get aboutThisData;

  /// No description provided for @mapAreasCutOff.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 area cut off} other{{count} areas cut off}}'**
  String mapAreasCutOff(int count);

  /// No description provided for @mapPeopleNear.
  ///
  /// In en, this message translates to:
  /// **'About {people} people near {places}'**
  String mapPeopleNear(String people, String places);

  /// No description provided for @placesAnd.
  ///
  /// In en, this message translates to:
  /// **'{first} and {last}'**
  String placesAnd(String first, String last);

  /// No description provided for @seeWhoNeedsHelp.
  ///
  /// In en, this message translates to:
  /// **'See who needs help first'**
  String get seeWhoNeedsHelp;

  /// No description provided for @mapPreliminary.
  ///
  /// In en, this message translates to:
  /// **'Preliminary data · snapshot of {date} · tap for details'**
  String mapPreliminary(String date);

  /// No description provided for @mapSnapshot.
  ///
  /// In en, this message translates to:
  /// **'Snapshot of {date} · tap for details'**
  String mapSnapshot(String date);

  /// No description provided for @legendFlooded.
  ///
  /// In en, this message translates to:
  /// **'Flooded'**
  String get legendFlooded;

  /// No description provided for @modeNeedsBoat.
  ///
  /// In en, this message translates to:
  /// **'Needs a boat'**
  String get modeNeedsBoat;

  /// No description provided for @modeTruckCanReach.
  ///
  /// In en, this message translates to:
  /// **'Truck can reach'**
  String get modeTruckCanReach;

  /// No description provided for @modeCarCanReach.
  ///
  /// In en, this message translates to:
  /// **'A car can reach'**
  String get modeCarCanReach;

  /// No description provided for @modeFootCanReach.
  ///
  /// In en, this message translates to:
  /// **'Reachable on foot'**
  String get modeFootCanReach;

  /// No description provided for @openArea.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openArea;

  /// No description provided for @areaMarkerLabel.
  ///
  /// In en, this message translates to:
  /// **'Area {rank}: {name}, {mode}'**
  String areaMarkerLabel(String rank, String name, String mode);

  /// No description provided for @helpTitle.
  ///
  /// In en, this message translates to:
  /// **'Who needs help first'**
  String get helpTitle;

  /// No description provided for @helpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 area, most urgent at the top} other{{count} areas, most urgent at the top}}'**
  String helpSubtitle(int count);

  /// No description provided for @filterAllCount.
  ///
  /// In en, this message translates to:
  /// **'All {count}'**
  String filterAllCount(String count);

  /// No description provided for @filterBoatCount.
  ///
  /// In en, this message translates to:
  /// **'Boat {count}'**
  String filterBoatCount(String count);

  /// No description provided for @filterTruckCount.
  ///
  /// In en, this message translates to:
  /// **'Truck {count}'**
  String filterTruckCount(String count);

  /// No description provided for @filterCarCount.
  ///
  /// In en, this message translates to:
  /// **'Car {count}'**
  String filterCarCount(String count);

  /// No description provided for @filterFootCount.
  ///
  /// In en, this message translates to:
  /// **'On foot {count}'**
  String filterFootCount(String count);

  /// No description provided for @customWeightsNote.
  ///
  /// In en, this message translates to:
  /// **'Ordered with your own priority weights. Reset them in About this data › Advanced.'**
  String get customWeightsNote;

  /// No description provided for @areaCardLabel.
  ///
  /// In en, this message translates to:
  /// **'Area {rank}: {name}. {people}. {mode}'**
  String areaCardLabel(String rank, String name, String people, String mode);

  /// No description provided for @noAreasForFilter.
  ///
  /// In en, this message translates to:
  /// **'No areas match this filter.'**
  String get noAreasForFilter;

  /// No description provided for @areaXofN.
  ///
  /// In en, this message translates to:
  /// **'Area {rank} of {count}'**
  String areaXofN(String rank, String count);

  /// No description provided for @modeBoatDetail.
  ///
  /// In en, this message translates to:
  /// **'About {water} km by water, after {road} km by road'**
  String modeBoatDetail(String water, String road);

  /// No description provided for @modeTruckTitle.
  ///
  /// In en, this message translates to:
  /// **'A high-clearance truck can reach it'**
  String get modeTruckTitle;

  /// No description provided for @modeCarTitle.
  ///
  /// In en, this message translates to:
  /// **'A normal car can reach it'**
  String get modeCarTitle;

  /// No description provided for @modeFootTitle.
  ///
  /// In en, this message translates to:
  /// **'It can be reached on foot only'**
  String get modeFootTitle;

  /// No description provided for @modeTruckDetail.
  ///
  /// In en, this message translates to:
  /// **'No boat needed, but the road has water on it.'**
  String get modeTruckDetail;

  /// No description provided for @lostTitle.
  ///
  /// In en, this message translates to:
  /// **'What they can no longer reach'**
  String get lostTitle;

  /// No description provided for @harderTitle.
  ///
  /// In en, this message translates to:
  /// **'What is harder to reach'**
  String get harderTitle;

  /// No description provided for @lostWasMinutes.
  ///
  /// In en, this message translates to:
  /// **'was about {minutes} min'**
  String lostWasMinutes(String minutes);

  /// No description provided for @serviceDepotLinkPlain.
  ///
  /// In en, this message translates to:
  /// **'Link to the aid depot'**
  String get serviceDepotLinkPlain;

  /// No description provided for @safestRouteTitle.
  ///
  /// In en, this message translates to:
  /// **'Safest road route'**
  String get safestRouteTitle;

  /// No description provided for @routeCheckBridges.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Check 1 bridge first} other{Check {count} bridges first}}'**
  String routeCheckBridges(int count);

  /// No description provided for @riskChipHigh.
  ///
  /// In en, this message translates to:
  /// **'High risk'**
  String get riskChipHigh;

  /// No description provided for @riskChipMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium risk'**
  String get riskChipMedium;

  /// No description provided for @riskChipLow.
  ///
  /// In en, this message translates to:
  /// **'Low risk'**
  String get riskChipLow;

  /// No description provided for @sureHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get sureHigh;

  /// No description provided for @sureMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get sureMedium;

  /// No description provided for @sureLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get sureLow;

  /// No description provided for @checkOnGround.
  ///
  /// In en, this message translates to:
  /// **'Check on the ground first ({count})'**
  String checkOnGround(String count);

  /// No description provided for @checkOnGroundTitle.
  ///
  /// In en, this message translates to:
  /// **'Check on the ground first'**
  String get checkOnGroundTitle;

  /// No description provided for @checkOnGroundIntro.
  ///
  /// In en, this message translates to:
  /// **'Tick each one when a team has checked it. Ticks stay on this phone.'**
  String get checkOnGroundIntro;

  /// No description provided for @howSure.
  ///
  /// In en, this message translates to:
  /// **'How sure are we? {level}'**
  String howSure(String level);

  /// No description provided for @howSureTitle.
  ///
  /// In en, this message translates to:
  /// **'How sure are we?'**
  String get howSureTitle;

  /// No description provided for @howSureConfidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence: {level}'**
  String howSureConfidence(String level);

  /// No description provided for @routesIllustrativeShort.
  ///
  /// In en, this message translates to:
  /// **'Routes start at the aid depot, which is assumed. Use them as a guide.'**
  String get routesIllustrativeShort;

  /// No description provided for @findCareTitle.
  ///
  /// In en, this message translates to:
  /// **'Find care'**
  String get findCareTitle;

  /// No description provided for @findCareSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The nearest clinic you can reach, and how'**
  String get findCareSubtitle;

  /// No description provided for @trySampleSpot.
  ///
  /// In en, this message translates to:
  /// **'Try a sample spot in Chókwè'**
  String get trySampleSpot;

  /// No description provided for @sampleNotice.
  ///
  /// In en, this message translates to:
  /// **'Sample location, not your position'**
  String get sampleNotice;

  /// No description provided for @nearestClinicLabel.
  ///
  /// In en, this message translates to:
  /// **'Nearest clinic'**
  String get nearestClinicLabel;

  /// No description provided for @chosenClinicLabel.
  ///
  /// In en, this message translates to:
  /// **'Your chosen clinic'**
  String get chosenClinicLabel;

  /// No description provided for @byCar.
  ///
  /// In en, this message translates to:
  /// **'By car'**
  String get byCar;

  /// No description provided for @byTruck.
  ///
  /// In en, this message translates to:
  /// **'High-clearance truck'**
  String get byTruck;

  /// No description provided for @byFoot.
  ///
  /// In en, this message translates to:
  /// **'On foot'**
  String get byFoot;

  /// No description provided for @canReach.
  ///
  /// In en, this message translates to:
  /// **'Can reach'**
  String get canReach;

  /// No description provided for @noRoadRoute.
  ///
  /// In en, this message translates to:
  /// **'No road route'**
  String get noRoadRoute;

  /// No description provided for @toClinic.
  ///
  /// In en, this message translates to:
  /// **'to {clinic}'**
  String toClinic(String clinic);

  /// No description provided for @showRouteOnMapLong.
  ///
  /// In en, this message translates to:
  /// **'Show the route on the map'**
  String get showRouteOnMapLong;

  /// No description provided for @routeBy.
  ///
  /// In en, this message translates to:
  /// **'Route by'**
  String get routeBy;

  /// No description provided for @aboutThisSpot.
  ///
  /// In en, this message translates to:
  /// **'About this spot'**
  String get aboutThisSpot;

  /// No description provided for @allClinicsTitle.
  ///
  /// In en, this message translates to:
  /// **'All clinics ({count})'**
  String allClinicsTitle(String count);

  /// No description provided for @aboutPreliminary.
  ///
  /// In en, this message translates to:
  /// **'Preliminary data. Use as a guide, then verify on the ground.'**
  String get aboutPreliminary;

  /// No description provided for @aboutGuideOnly.
  ///
  /// In en, this message translates to:
  /// **'Use as a guide, then verify on the ground.'**
  String get aboutGuideOnly;

  /// No description provided for @plainNisarBeta.
  ///
  /// In en, this message translates to:
  /// **'The NISAR radar scenes are beta products, not yet fully calibrated.'**
  String get plainNisarBeta;

  /// No description provided for @plainDepotAutoSelected.
  ///
  /// In en, this message translates to:
  /// **'The aid depot was chosen automatically by the analysis, so routes and priorities are only illustrative.'**
  String get plainDepotAutoSelected;

  /// No description provided for @plainDepotAssumed.
  ///
  /// In en, this message translates to:
  /// **'The aid depot is assumed, not confirmed, so routes and priorities are a guide.'**
  String get plainDepotAssumed;

  /// No description provided for @plainValidationProductOrder.
  ///
  /// In en, this message translates to:
  /// **'The official map used to check ours was chosen by product order, not by which image was closest in time.'**
  String get plainValidationProductOrder;

  /// No description provided for @plainClassifierCalibrated.
  ///
  /// In en, this message translates to:
  /// **'The flood map is calibrated to this event\'s official map, so it agrees with that map partly by design.'**
  String get plainClassifierCalibrated;

  /// No description provided for @aboutFloodMapRow.
  ///
  /// In en, this message translates to:
  /// **'How the flood map was made'**
  String get aboutFloodMapRow;

  /// No description provided for @aboutMatchRow.
  ///
  /// In en, this message translates to:
  /// **'How well it matches the official map'**
  String get aboutMatchRow;

  /// No description provided for @aboutLimitsRow.
  ///
  /// In en, this message translates to:
  /// **'Limits and known issues'**
  String get aboutLimitsRow;

  /// No description provided for @aboutSourcesRow.
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get aboutSourcesRow;

  /// No description provided for @aboutAgeRow.
  ///
  /// In en, this message translates to:
  /// **'Data age and update info'**
  String get aboutAgeRow;

  /// No description provided for @aboutAdvancedRow.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get aboutAdvancedRow;

  /// No description provided for @aboutAdvancedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Priority weights, Compare, physics-only and depth layers'**
  String get aboutAdvancedSubtitle;

  /// No description provided for @aboutLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get aboutLanguage;

  /// No description provided for @aboutTextSize.
  ///
  /// In en, this message translates to:
  /// **'Text size'**
  String get aboutTextSize;

  /// No description provided for @textSizeOption.
  ///
  /// In en, this message translates to:
  /// **'{pct}%'**
  String textSizeOption(String pct);

  /// No description provided for @aboutSafetyLine.
  ///
  /// In en, this message translates to:
  /// **'This app supports decisions. It is not an emergency service. If you are in danger, call your local emergency number.'**
  String get aboutSafetyLine;

  /// No description provided for @floodMapIntro.
  ///
  /// In en, this message translates to:
  /// **'The flood map compares NISAR radar scenes from before and after the flood. Open water reflects radar differently from land, so a change between the two scenes marks new water.'**
  String get floodMapIntro;

  /// No description provided for @dataGenerated.
  ///
  /// In en, this message translates to:
  /// **'Analysis run: {date}'**
  String dataGenerated(String date);

  /// No description provided for @updateInfo.
  ///
  /// In en, this message translates to:
  /// **'The data comes from one run of the analysis. When the analysis is run again on newer scenes, a new app version carries the new data.'**
  String get updateInfo;

  /// No description provided for @advancedMapNote.
  ///
  /// In en, this message translates to:
  /// **'Layer changes show on the Map tab.'**
  String get advancedMapNote;
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
