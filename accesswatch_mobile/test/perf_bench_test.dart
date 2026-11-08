// Parse cost of each bundle file on this machine's Dart VM (no isolate, no
// asset loading). Prints the numbers; asserts only a loose ceiling.
import 'dart:convert';
import 'dart:io';

import 'package:accesswatch_mobile/data/depth_lod.dart';
import 'package:accesswatch_mobile/data/models/layers.dart';
import 'package:accesswatch_mobile/data/models/mission.dart';
import 'package:accesswatch_mobile/data/models/pocket.dart';
import 'package:accesswatch_mobile/data/models/road_graph.dart';
import 'package:accesswatch_mobile/data/models/route_line.dart';
import 'package:accesswatch_mobile/data/models/service_point.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parse time per bundle file (printed)', () {
    final parsers = <String, void Function(Map<String, dynamic>)>{
      'graph.json': RoadGraph.fromJson,
      'depth_zones.geojson': (j) => buildDepthLod(DepthZone.listFromJson(j)),
      'flood_ems.geojson': EmsLayer.fromJson,
      'flood_baseline.geojson': FloodArea.listFromJson,
      'flood.geojson': FloodArea.listFromJson,
      'pockets.geojson': Pocket.listFromJson,
      'routes.geojson': RouteLine.listFromJson,
      'services.geojson': ServicePoint.listFromJson,
      'missions.json': Mission.listFromJson,
    };
    var total = 0;
    for (final entry in parsers.entries) {
      final text = File('assets/bundle/${entry.key}').readAsStringSync();
      entry.value(jsonDecode(text) as Map<String, dynamic>); // warm up
      final runs = <int>[];
      for (var i = 0; i < 5; i++) {
        final watch = Stopwatch()..start();
        entry.value(jsonDecode(text) as Map<String, dynamic>);
        runs.add(watch.elapsedMicroseconds);
      }
      runs.sort();
      total += runs[2];
      // ignore: avoid_print
      print('${entry.key.padRight(24)} ${(text.length / 1024).round().toString().padLeft(4)} KB  median ${(runs[2] / 1000).toStringAsFixed(1)} ms');
    }
    // ignore: avoid_print
    print('all files, one after another: ${(total / 1000).toStringAsFixed(1)} ms');
    expect(total, lessThan(5 * 1000 * 1000));
  });
}
