// Closed value sets from docs/SCHEMA.md. An unknown value is a data error, so
// parsing throws instead of silently showing something wrong.

T _parse<T>(Map<Object, T> values, Object? raw, String field) {
  final value = values[raw];
  if (value == null) throw FormatException('Unknown $field: $raw');
  return value;
}

enum AccessMode {
  normalVehicle,
  highClearanceTruck,
  onFoot,
  boat;

  static AccessMode parse(Object? raw) => _parse(const {
        'normal_vehicle': normalVehicle,
        'high_clearance_truck': highClearanceTruck,
        'on_foot': onFoot,
        'boat': boat,
      }, raw, 'access mode');
}

enum PocketStatus {
  cutOff,
  difficult;

  static PocketStatus parse(Object? raw) =>
      _parse(const {'cut_off': cutOff, 'difficult': difficult}, raw, 'status');
}

enum RiskLevel {
  low,
  medium,
  high;

  static RiskLevel parse(Object? raw) =>
      _parse(const {'low': low, 'medium': medium, 'high': high}, raw, 'risk level');
}

enum Confidence {
  low,
  medium,
  high;

  static Confidence parse(Object? raw) =>
      _parse(const {'low': low, 'medium': medium, 'high': high}, raw, 'confidence');
}

enum DepthClass {
  dry,
  shallow,
  medium,
  deep,
  unknown;

  static DepthClass parse(Object? raw) => _parse(const {
        'dry': dry,
        'shallow': shallow,
        'medium': medium,
        'deep': deep,
        'unknown': unknown,
      }, raw, 'depth class');

  /// `depth_class` integer codes from the rasters and the road graph.
  static DepthClass fromCode(int code) =>
      _parse(const {0: dry, 1: shallow, 2: medium, 3: deep, 4: unknown}, code, 'depth class code');
}

enum ServiceAccess {
  yes,
  difficult,
  no,
  notApplicable;

  static ServiceAccess parse(Object? raw) => _parse(const {
        'yes': yes,
        'difficult': difficult,
        'no': no,
        'n/a': notApplicable,
      }, raw, 'service access');
}

/// Names used in `lost_services` and `limited_services`.
enum ServiceLink {
  clinic,
  market,
  shelter,
  aidDepotLink;

  static ServiceLink parse(Object? raw) => _parse(const {
        'clinic': clinic,
        'market': market,
        'shelter': shelter,
        'aid_depot_link': aidDepotLink,
      }, raw, 'service');
}

enum RouteType {
  shortest,
  safest;

  static RouteType parse(Object? raw) =>
      _parse(const {'shortest': shortest, 'safest': safest}, raw, 'route type');
}

enum ServiceType {
  clinic,
  market,
  shelter,
  aidDepot;

  static ServiceType parse(Object? raw) => _parse(const {
        'clinic': clinic,
        'market': market,
        'shelter': shelter,
        'aid_depot': aidDepot,
      }, raw, 'service type');
}

enum ClinicStatus {
  reachable,
  accessFlooded,
  insidePocket;

  static ClinicStatus parse(Object? raw) => _parse(const {
        'reachable': reachable,
        'access_flooded': accessFlooded,
        'inside_pocket': insidePocket,
      }, raw, 'clinic status');
}

/// Every flag the app has a translated warning for. An unknown flag stops
/// loading, so a new warning from the notebook can never be dropped silently.
enum QualityFlag {
  nisarBeta,
  depotAutoSelected,
  validationChosenByProductOrder,
  classifierCalibratedOnEms;

  static QualityFlag parse(Object? raw) => _parse(const {
        'nisar_beta': nisarBeta,
        'depot_auto_selected': depotAutoSelected,
        'validation_chosen_by_product_order': validationChosenByProductOrder,
        'classifier_calibrated_on_ems': classifierCalibratedOnEms,
      }, raw, 'quality flag');

  /// The flags whose value is true in a `quality_flags` / `flags` object.
  static Set<QualityFlag> activeIn(Map<String, dynamic> json) => {
        for (final entry in json.entries)
          if (parse(entry.key) case final flag when entry.value == true) flag,
      };
}
