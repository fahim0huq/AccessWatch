import 'dart:typed_data';

/// `graph.json` in typed arrays, so it stays compact and can cross isolates.
class RoadGraph {
  static const _edgeFields = ['u', 'v', 'length_m', 'depth_class', 'flags', 'risk_cost', 'travel_time_min'];

  final Float64List lon, lat;
  final Int32List u, v;
  final Float64List lengthM, riskCost, travelTimeMin;
  final Uint8List depthClass, flags;

  /// `normal_vehicle`, `high_clearance`, `foot`, `bridge`, `bridge_uncertain` -> bit.
  final Map<String, int> flagBits;

  const RoadGraph({
    required this.lon,
    required this.lat,
    required this.u,
    required this.v,
    required this.lengthM,
    required this.riskCost,
    required this.travelTimeMin,
    required this.depthClass,
    required this.flags,
    required this.flagBits,
  });

  int get nodeCount => lon.length;
  int get edgeCount => u.length;

  factory RoadGraph.fromJson(Map<String, dynamic> j) {
    final fields = (j['edge_fields'] as List<dynamic>).cast<String>();
    if (fields.join(',') != _edgeFields.join(',')) {
      throw FormatException('Unexpected graph edge_fields: $fields');
    }
    final flat = j['edges'] as List<dynamic>;
    final stride = fields.length;
    if (flat.length % stride != 0) throw const FormatException('Graph edges array has a partial edge');
    final count = flat.length ~/ stride;

    final u = Int32List(count), v = Int32List(count);
    final length = Float64List(count), risk = Float64List(count), time = Float64List(count);
    final depth = Uint8List(count), flags = Uint8List(count);
    for (var e = 0; e < count; e++) {
      final o = e * stride;
      u[e] = flat[o] as int;
      v[e] = flat[o + 1] as int;
      length[e] = (flat[o + 2] as num).toDouble();
      depth[e] = flat[o + 3] as int;
      flags[e] = flat[o + 4] as int;
      risk[e] = (flat[o + 5] as num).toDouble();
      time[e] = (flat[o + 6] as num).toDouble();
    }
    Float64List coords(String key) =>
        Float64List.fromList([for (final x in j[key] as List<dynamic>) (x as num).toDouble()]);

    return RoadGraph(
      lon: coords('lon'),
      lat: coords('lat'),
      u: u,
      v: v,
      lengthM: length,
      riskCost: risk,
      travelTimeMin: time,
      depthClass: depth,
      flags: flags,
      flagBits: (j['flag_bits'] as Map<String, dynamic>).cast<String, int>(),
    );
  }
}
