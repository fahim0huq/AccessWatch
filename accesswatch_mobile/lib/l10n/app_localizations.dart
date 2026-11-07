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

  /// No description provided for @depthShallowRange.
  ///
  /// In en, this message translates to:
  /// **'< 0.3 m'**
  String get depthShallowRange;

  /// No description provided for @depthMediumRange.
  ///
  /// In en, this message translates to:
  /// **'0.3–0.8 m'**
  String get depthMediumRange;

  /// No description provided for @depthDeepRange.
  ///
  /// In en, this message translates to:
  /// **'> 0.8 m'**
  String get depthDeepRange;

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

  /// No description provided for @servicesLost.
  ///
  /// In en, this message translates to:
  /// **'SERVICES LOST'**
  String get servicesLost;

  /// No description provided for @servicesLimited.
  ///
  /// In en, this message translates to:
  /// **'SERVICES WITH DIFFICULT ACCESS'**
  String get servicesLimited;

  /// No description provided for @serviceWasMinutes.
  ///
  /// In en, this message translates to:
  /// **'{service} (about {minutes} min before the flood)'**
  String serviceWasMinutes(String service, String minutes);

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

  /// No description provided for @verifyOnGround.
  ///
  /// In en, this message translates to:
  /// **'Verify on the ground before acting.'**
  String get verifyOnGround;

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
