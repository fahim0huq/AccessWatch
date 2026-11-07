// Parses the real assets/bundle/ files through BundleRepository.
import 'dart:convert';

import 'package:accesswatch_mobile/data/bundle_repository.dart';
import 'package:accesswatch_mobile/data/models/enums.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppBundle bundle;

  setUpAll(() async => bundle = await BundleRepository().load());

  test('has 8 pockets, 16 routes and 7 clinics', () {
    expect(bundle.pockets, hasLength(8));
    expect(bundle.routes, hasLength(16));
    expect(bundle.clinics, hasLength(7));
    expect(bundle.missions, hasLength(8));
  });

  test('manifest stats agree with the parsed files', () {
    final stats = bundle.manifest.stats;
    expect(stats.pockets, bundle.pockets.length);
    expect(stats.populationEstimate, bundle.pockets.fold<int>(0, (sum, p) => sum + p.population));
    expect(stats.clinicStatus.values.fold<int>(0, (a, b) => a + b), bundle.clinics.length);
    for (final mode in stats.pocketsByAccessMode.keys) {
      expect(stats.pocketsByAccessMode[mode], bundle.pockets.where((p) => p.accessMode == mode).length);
    }
  });

  test('every pocket has a mission and two routes, one of each type', () {
    for (final pocket in bundle.pockets) {
      expect(bundle.missions.where((m) => m.pocketId == pocket.id), hasLength(1));
      final routes = bundle.routes.where((r) => r.pocketId == pocket.id);
      expect(routes.map((r) => r.routeType).toSet(), RouteType.values.toSet());
      expect(pocket.polygons, isNotEmpty);
    }
    expect(bundle.routes.every((r) => r.points.length >= 2), isTrue);
  });

  test('missions come sorted by rank', () {
    final ranks = bundle.missions.map((m) => m.rank).toList();
    expect(ranks, [...ranks]..sort());
  });

  test('every clinic has a status, and a pocket id only when inside a pocket', () {
    for (final clinic in bundle.clinics) {
      expect(clinic.type, ServiceType.clinic);
      expect(clinic.clinicStatus == ClinicStatus.insidePocket, clinic.pocketId != null);
    }
    expect(bundle.services.where((s) => s.type == ServiceType.aidDepot), hasLength(1));
  });

  test('layers parse with the expected depth classes', () {
    expect(bundle.flood, isNotEmpty);
    expect(bundle.floodBaseline, isNotEmpty);
    expect(bundle.ems.flood, isNotEmpty);
    expect(bundle.ems.mappedArea, isNotEmpty);
    expect(bundle.depthZones.map((z) => z.depthClass).toSet(),
        {DepthClass.shallow, DepthClass.medium, DepthClass.deep});
  });

  test('graph matches the manifest and its node indices are valid', () {
    final graph = bundle.graph;
    expect(graph.nodeCount, bundle.manifest.graph.nodes);
    expect(graph.edgeCount, bundle.manifest.graph.edges);
    expect(graph.lat, hasLength(graph.nodeCount));
    expect(graph.u.every((n) => n >= 0 && n < graph.nodeCount), isTrue);
    expect(graph.v.every((n) => n >= 0 && n < graph.nodeCount), isTrue);
  });

  test('every file in the manifest exists with the listed size', () async {
    for (final entry in bundle.manifest.files.entries) {
      final data = await rootBundle.load('${BundleRepository.assetDir}/${entry.key}');
      expect(data.lengthInBytes, entry.value.size, reason: entry.key);
    }
  });

  test('flags in manifest and quality agree, and the scores are readable', () {
    expect(bundle.manifest.qualityFlags, bundle.quality.flags);
    expect(bundle.manifest.syntheticDemo, isFalse);
    expect(bundle.quality.classifierCvIou, greaterThan(bundle.quality.thresholdMapIou));
    expect(bundle.quality.dataSources, isNotEmpty);
  });

  test('an unknown quality flag stops parsing, even when false', () {
    expect(() => QualityFlag.activeIn({'new_warning': false}), throwsFormatException);
    expect(QualityFlag.activeIn({'nisar_beta': true, 'depot_auto_selected': false}), {QualityFlag.nisarBeta});
  });

  test('no ready-made English text reaches the missions file', () async {
    final text = await rootBundle.loadString('${BundleRepository.assetDir}/missions.json');
    final card = (jsonDecode(text)['cards'] as List).first as Map<String, dynamic>;
    expect(card.keys, isNot(anyOf(contains('alert_text'), contains('summary'), contains('verify_notes'))));
  });
}
