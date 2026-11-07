// Translated labels and locale-aware number and date text for bundle values.
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../data/models/enums.dart';
import '../data/models/mission.dart';
import '../data/models/quality.dart';
import '../data/models/manifest.dart';
import '../l10n/app_localizations.dart';

extension BundleLabels on AppLocalizations {
  String accessMode(AccessMode mode) => switch (mode) {
        AccessMode.normalVehicle => accessNormalVehicle,
        AccessMode.highClearanceTruck => accessHighClearanceTruck,
        AccessMode.onFoot => accessOnFoot,
        AccessMode.boat => accessBoat,
      };

  String pocketStatus(PocketStatus status) => switch (status) {
        PocketStatus.cutOff => statusCutOff,
        PocketStatus.difficult => statusDifficult,
      };

  String depthClass(DepthClass depth) => switch (depth) {
        DepthClass.dry => depthDry,
        DepthClass.shallow => depthShallow,
        DepthClass.medium => depthMedium,
        DepthClass.deep => depthDeep,
        DepthClass.unknown => depthUnknown,
      };

  String riskLevel(RiskLevel level) => switch (level) {
        RiskLevel.low => levelLow,
        RiskLevel.medium => levelMedium,
        RiskLevel.high => levelHigh,
      };

  String confidence(Confidence level) => switch (level) {
        Confidence.low => levelLow,
        Confidence.medium => levelMedium,
        Confidence.high => levelHigh,
      };

  String serviceLink(ServiceLink link) => switch (link) {
        ServiceLink.clinic => serviceClinic,
        ServiceLink.market => serviceMarket,
        ServiceLink.shelter => serviceShelter,
        ServiceLink.aidDepotLink => serviceAidDepotLink,
      };

  String serviceList(Iterable<ServiceLink> links) => links.map(serviceLink).join(', ');

  /// `north-west` in the data becomes the `northwest` case in the ARB files.
  String missionTitle(Mission m) => pocketTitle(m.directionFromPlace.replaceAll('-', ''), m.nearestPlace);

  /// All the reasons in one sentence, built only from the card's fields.
  String whyFlaggedText(Mission m) {
    final mode = accessMode(m.accessMode);
    final depth = depthClass(m.maxDepthClass);
    if (m.accessStatus == PocketStatus.cutOff) {
      return whyCutOff(serviceList(m.lostServices.map((s) => s.service)), mode, depth);
    }
    return whyDifficult(serviceList(m.limitedServices), mode, depth);
  }

  String warningShort(QualityFlag flag) => switch (flag) {
        QualityFlag.nisarBeta => warnShortNisarBeta,
        QualityFlag.depotAutoSelected => warnShortDepotAutoSelected,
        QualityFlag.validationChosenByProductOrder => warnShortValidationProductOrder,
        QualityFlag.classifierCalibratedOnEms => warnShortClassifierCalibrated,
      };

  String warningFull(QualityFlag flag, Manifest manifest, Quality quality, Fmt fmt) => switch (flag) {
        QualityFlag.nisarBeta => warnNisarBeta,
        QualityFlag.depotAutoSelected => warnDepotAutoSelected,
        QualityFlag.validationChosenByProductOrder =>
          warnValidationProductOrder(fmt.oneDecimal(manifest.dates.emsHoursAfterNisar)),
        QualityFlag.classifierCalibratedOnEms =>
          warnClassifierCalibrated(fmt.score(quality.classifierCvIou), fmt.score(quality.thresholdMapIou)),
      };

  /// Known events get a translated name; any other shows its id from the data.
  String eventName(String event) => event == 'mozambique_flood_2026' ? eventMozambique2026 : event;
}

/// Numbers and dates in the current language (0,56 in Portuguese, 0.56 in English).
class Fmt {
  final String _locale;

  const Fmt(this._locale);

  factory Fmt.of(BuildContext context) => Fmt(Localizations.localeOf(context).toString());

  String count(num value) => NumberFormat.decimalPattern(_locale).format(value);
  String km(num value) => NumberFormat('0.00', _locale).format(value);
  String score(num value) => NumberFormat('0.00', _locale).format(value);
  String oneDecimal(num value) => NumberFormat('0.0', _locale).format(value);
  String minutes(num value) => NumberFormat('0', _locale).format(value);
  String percent(num fraction) => NumberFormat('0', _locale).format(fraction * 100);

  /// Dates in the bundle are UTC and are shown as UTC dates.
  String date(DateTime utc) => DateFormat.yMMMd(_locale).format(utc.toUtc());
}
