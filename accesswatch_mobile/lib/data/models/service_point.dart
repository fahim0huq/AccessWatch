import 'package:latlong2/latlong.dart';

import 'enums.dart';
import 'geo.dart';

/// A feature of `services.geojson`: a service or the aid depot.
class ServicePoint {
  final String id;
  final ServiceType type;

  /// May be empty: the app shows a translated fallback.
  final String name;

  /// Absent on the depot.
  final bool? onNetwork;

  /// Clinics only.
  final ClinicStatus? clinicStatus;

  /// Set only when [clinicStatus] is `insidePocket`.
  final String? pocketId;
  final LatLng point;

  const ServicePoint({
    required this.id,
    required this.type,
    required this.name,
    required this.onNetwork,
    required this.clinicStatus,
    required this.pocketId,
    required this.point,
  });

  factory ServicePoint.fromFeature(Map<String, dynamic> feature) {
    final p = feature['properties'] as Map<String, dynamic>;
    final status = p['clinic_status'];
    return ServicePoint(
      id: p['service_id'] as String,
      type: ServiceType.parse(p['type']),
      name: p['name'] as String,
      onNetwork: p['on_network'] as bool?,
      clinicStatus: status == null ? null : ClinicStatus.parse(status),
      pocketId: p['pocket_id'] as String?,
      point: pointFromGeometry(feature['geometry'] as Map<String, dynamic>),
    );
  }

  static List<ServicePoint> listFromJson(Map<String, dynamic> collection) =>
      [for (final f in featuresOf(collection)) ServicePoint.fromFeature(f)];
}
