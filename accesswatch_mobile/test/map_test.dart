// The real map on the real bundle: camera, alignment, layers, taps, smoothness limits.
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:accesswatch_mobile/data/bundle_repository.dart';
import 'package:accesswatch_mobile/data/depth_lod.dart';
import 'package:accesswatch_mobile/data/models/enums.dart';
import 'package:accesswatch_mobile/data/models/geo.dart';
import 'package:accesswatch_mobile/l10n/app_localizations.dart';
import 'package:accesswatch_mobile/l10n/app_localizations_en.dart';
import 'package:accesswatch_mobile/state/map_state.dart';
import 'package:accesswatch_mobile/widgets/map/feature_layers.dart';
import 'package:accesswatch_mobile/widgets/map/flood_layers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart' show LatLng;

import 'support/app_harness.dart';

/// Screen position from the Web Mercator formula alone, without the map library.
Offset mercatorPixel(LatLng p, double zoom) {
  final world = 256 * math.pow(2, zoom).toDouble();
  final lat = p.latitude * math.pi / 180;
  return Offset(
    (p.longitude + 180) / 360 * world,
    (1 - math.log(math.tan(lat) + 1 / math.cos(lat)) / math.pi) / 2 * world,
  );
}

bool insideRing(LatLng p, List<LatLng> ring) {
  var inside = false;
  for (var i = 0, j = ring.length - 1; i < ring.length; j = i++) {
    final a = ring[i], b = ring[j];
    if ((a.latitude > p.latitude) != (b.latitude > p.latitude) &&
        p.longitude < (b.longitude - a.longitude) * (p.latitude - a.latitude) / (b.latitude - a.latitude) + a.longitude) {
      inside = !inside;
    }
  }
  return inside;
}

bool insidePolygon(LatLng p, GeoPolygon polygon) =>
    insideRing(p, polygon.outer) && !polygon.holes.any((hole) => insideRing(p, hole));

/// A point strictly inside the polygon: the middle of a scanline's first span.
LatLng interiorPoint(GeoPolygon polygon) {
  final lat = (polygon.outer.map((p) => p.latitude).reduce(math.max) + polygon.outer.map((p) => p.latitude).reduce(math.min)) / 2 + 1e-6;
  final crossings = <double>[];
  for (var i = 0; i < polygon.outer.length - 1; i++) {
    final a = polygon.outer[i], b = polygon.outer[i + 1];
    if ((a.latitude > lat) != (b.latitude > lat)) {
      crossings.add(a.longitude + (lat - a.latitude) / (b.latitude - a.latitude) * (b.longitude - a.longitude));
    }
  }
  crossings.sort();
  return LatLng(lat, (crossings[0] + crossings[1]) / 2);
}

/// Serves a blank tile and records what the map asked for, without any network.
class RecordingTiles extends TileProvider {
  final requested = <TileCoordinates>[];
  static final _blank = base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==');

  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) {
    requested.add(coordinates);
    return MemoryImage(_blank);
  }
}

void main() {
  late AppBundle bundle;
  final AppLocalizations en = AppLocalizationsEn();

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    bundle = await BundleRepository().load();
  });

  Future<void> openMap(WidgetTester tester, {double textScale = 1.0}) async {
    await pumpApp(tester, bundle, height: 844, textScale: textScale);
    await tester.tap(find.text(en.tabMap).last);
    await tester.pumpAndSettle();
  }

  MapCamera cameraOf(WidgetTester tester) => MapCamera.of(tester.element(find.byType(PocketLabelsLayer)));

  group('camera and alignment', () {
    testWidgets('opens fitted to manifest.bounds', (tester) async {
      await openMap(tester);
      final camera = cameraOf(tester);
      final size = tester.getSize(find.byType(FlutterMap));
      final b = bundle.manifest.bounds;
      final corners = [LatLng(b.south, b.west), LatLng(b.south, b.east), LatLng(b.north, b.west), LatLng(b.north, b.east)];
      final points = corners.map(camera.latLngToScreenOffset).toList();
      for (final point in points) {
        expect(point.dx, inInclusiveRange(0, size.width));
        expect(point.dy, inInclusiveRange(0, size.height));
      }
      // Fitted: the box fills one dimension (less the padding), so it is not just somewhere on screen.
      final boxWidth = points[1].dx - points[0].dx, boxHeight = points[0].dy - points[2].dy;
      // The fit leaves room on the right for the buttons and at the bottom for the attribution.
      expect(math.max(boxWidth / (size.width - 80), boxHeight / (size.height - 36)), closeTo(1, 0.02));
    });

    testWidgets('pockets draw where the bundle coordinates say (prints a table)', (tester) async {
      await openMap(tester);
      final camera = cameraOf(tester);
      final mapTopLeft = tester.getTopLeft(find.byType(FlutterMap));
      final centre = mercatorPixel(camera.center, camera.zoom);
      final size = tester.getSize(find.byType(FlutterMap));

      // ignore: avoid_print
      print('zoom ${camera.zoom.toStringAsFixed(3)}, map size $size, map top-left $mapTopLeft');
      // ignore: avoid_print
      print('pocket  lat        lon        | Mercator formula x,y | map library x,y | drawn label x,y');
      var checked = 0;
      for (final id in const ['P01', 'P02', 'P04']) {
        final pocket = bundle.pockets.firstWhere((p) => p.id == id);
        final label = find.textContaining('$id ·');
        expect(label, findsOneWidget, reason: '$id label is on screen at the fitted zoom');
        final fromFormula = mercatorPixel(pocket.point, camera.zoom) - centre + size.center(Offset.zero);
        final fromLibrary = camera.latLngToScreenOffset(pocket.point);
        final drawn = tester.getCenter(label) - mapTopLeft;
        // ignore: avoid_print
        print('$id     ${pocket.point.latitude.toStringAsFixed(5)}  ${pocket.point.longitude.toStringAsFixed(5)} | '
            '${fromFormula.dx.toStringAsFixed(1)},${fromFormula.dy.toStringAsFixed(1)} | '
            '${fromLibrary.dx.toStringAsFixed(1)},${fromLibrary.dy.toStringAsFixed(1)} | '
            '${drawn.dx.toStringAsFixed(1)},${drawn.dy.toStringAsFixed(1)}');
        expect((fromFormula - fromLibrary).distance, lessThan(0.5));
        expect((drawn - fromLibrary).distance, lessThan(1.5));
        checked++;
      }
      expect(checked, 3);
    });

    testWidgets('tiles load for the fitted area, and never for anywhere else', (tester) async {
      final tiles = RecordingTiles();
      await pumpApp(tester, bundle, height: 844, tiles: tiles);
      await tester.tap(find.text(en.tabMap).last);
      await tester.pumpAndSettle();
      final camera = cameraOf(tester);
      final level = camera.zoom.round();
      final b = bundle.manifest.bounds;
      final nw = mercatorPixel(LatLng(b.north, b.west), level.toDouble()) / 256;
      final se = mercatorPixel(LatLng(b.south, b.east), level.toDouble()) / 256;
      // Every tile covering the fitted box was requested at the view's zoom...
      for (var x = nw.dx.floor(); x <= se.dx.floor(); x++) {
        for (var y = nw.dy.floor(); y <= se.dy.floor(); y++) {
          expect(tiles.requested.any((t) => t.z == level && t.x == x && t.y == y), isTrue, reason: '$level/$x/$y');
        }
      }
      // ...and none were far from the area: longitude within a few tiles at any zoom.
      for (final t in tiles.requested) {
        final tileLon = (t.x + 0.5) / math.pow(2, t.z) * 360 - 180;
        expect((tileLon - camera.center.longitude).abs(), lessThan(1.5), reason: '${t.z}/${t.x}/${t.y}');
      }
    });

    testWidgets('a direct load of the map route also loads its tiles', (tester) async {
      tester.binding.platformDispatcher.defaultRouteNameTestValue = '/map';
      addTearDown(tester.binding.platformDispatcher.clearDefaultRouteNameTestValue);
      final tiles = RecordingTiles();
      await pumpApp(tester, bundle, height: 844, tiles: tiles);
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
      expect(find.byType(FlutterMap), findsOneWidget);
      // ignore: avoid_print
      print('direct load requested ${tiles.requested.length} tiles');
      expect(tiles.requested, isNotEmpty);
    });

    test('each pocket point is inside its own polygon', () {
      for (final pocket in bundle.pockets) {
        expect(pocket.polygons.any((polygon) => insidePolygon(pocket.point, polygon)), isTrue, reason: pocket.id);
      }
    });

    test('depth zones lie inside the flood map, as they come from the same pixels', () {
      final flood = [for (final area in bundle.flood) ...area.polygons];
      for (final patch in bundle.depthLod.levels.last.take(100)) {
        final point = interiorPoint(patch.polygon);
        expect(flood.any((polygon) => insidePolygon(point, polygon)), isTrue);
      }
    });

    test('services lie inside the mapped box, and routes start at the depot', () {
      final b = bundle.manifest.boundsAll;
      for (final s in bundle.services) {
        expect(s.point.latitude, inInclusiveRange(b.south, b.north));
        expect(s.point.longitude, inInclusiveRange(b.west, b.east));
      }
      final depot = bundle.services.firstWhere((s) => s.type == ServiceType.aidDepot).point;
      for (final route in bundle.routes) {
        final start = route.points.first;
        expect((start.latitude - depot.latitude).abs() + (start.longitude - depot.longitude).abs(), lessThan(1e-3));
      }
    });
  });

  group('smooth drawing', () {
    test('each detail level respects its cap and keeps most of the water', () {
      final lod = bundle.depthLod;
      final total = lod.levels.last.fold<double>(0, (sum, p) => sum + polygonAreaM2(p.polygon));
      int vertices(List<DepthPatch> patches) => patches.fold(
          0, (sum, p) => sum + p.polygon.outer.length + p.polygon.holes.fold<int>(0, (s, h) => s + h.length));
      for (var i = 0; i < depthLodLevels.length; i++) {
        final patches = lod.levels[i];
        if (depthLodLevels[i].maxPolygons != null) {
          expect(patches.length, lessThanOrEqualTo(depthLodLevels[i].maxPolygons!));
        }
        final area = patches.fold<double>(0, (sum, p) => sum + polygonAreaM2(p.polygon));
        // ignore: avoid_print
        print('depth level $i from zoom ${depthLodLevels[i].minZoom}: ${patches.length} polygons, '
            '${vertices(patches)} vertices, ${(area / total * 100).toStringAsFixed(1)}% of the depth area');
        expect(area / total, greaterThan(0.9));
      }
      expect(vertices(lod.levels.first), lessThan(vertices(lod.levels.last) / 3));
      expect(lod.levels.last.length, greaterThan(depthLodLevels.first.maxPolygons!));
    });

    test('the zoom picks the right level', () {
      expect(DepthLod.levelIndexForZoom(12), 0);
      expect(DepthLod.levelIndexForZoom(14), 1);
      expect(DepthLod.levelIndexForZoom(16), 2);
    });

    test('a staircase edge simplifies but a small ring survives', () {
      final stairs = <LatLng>[for (var i = 0; i < 20; i++) LatLng(i * 0.0001 + (i.isOdd ? 0.00002 : 0), i * 0.0001)];
      final ring = [...stairs, const LatLng(0.002, 0), stairs.first];
      expect(simplifyRing(ring, 20).length, lessThan(ring.length));
      final square = const [LatLng(0, 0), LatLng(0, 0.0001), LatLng(0.0001, 0.0001), LatLng(0.0001, 0), LatLng(0, 0)];
      expect(simplifyRing(square, 500), square);
    });
  });

  group('layers', () {
    testWidgets('default layers are on, EMS and Compare are off, attribution shows', (tester) async {
      await openMap(tester);
      expect(find.byType(DepthZonesLayer), findsOneWidget);
      expect(find.byType(FloodLayer), findsOneWidget);
      expect(find.byType(EmsFloodLayer), findsNothing);
      expect(find.byType(OverlayImageLayer), findsNothing);
      expect(find.text(en.osmAttribution), findsOneWidget);
    });

    testWidgets('flooded roads draw only the flooded graph edges', (tester) async {
      await openMap(tester);
      final layer = tester.widget<PolylineLayer<Object>>(find.descendant(
        of: find.byType(FloodedRoadsLayer),
        matching: find.byType(PolylineLayer<Object>),
      ));
      final stats = bundle.manifest.stats;
      expect(layer.polylines, hasLength(stats.floodedShallow + stats.floodedMedium + stats.floodedDeep));
    });

    testWidgets('Compare mode shows the image, its legend and the warning', (tester) async {
      await openMap(tester);
      await tester.tap(find.byTooltip(en.tooltipCompare));
      await tester.pumpAndSettle();
      expect(find.byType(OverlayImageLayer), findsOneWidget);
      expect(find.byType(DepthZonesLayer), findsNothing);
      expect(find.text(en.compareNotIndependent), findsOneWidget);
      expect(find.text(en.compareBoth('23.4')), findsOneWidget);
      expect(find.text(en.osmAttribution), findsOneWidget);
    });

    testWidgets('layer panel switches a layer off', (tester) async {
      await openMap(tester);
      await tester.tap(find.byTooltip(en.tooltipLayers));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(SwitchListTile, en.layerFlood));
      await tester.pumpAndSettle();
      expect(find.byType(FloodLayer), findsNothing);
      expect(MapLayer.values, contains(MapLayer.floodEms));
    });

    testWidgets('legend shows depth limits from the manifest', (tester) async {
      await openMap(tester);
      await tester.tap(find.text(en.tooltipLegend));
      await tester.pumpAndSettle();
      final limits = bundle.manifest.depthClasses;
      expect(find.text('${en.depthShallow} ${en.depthBelow(limits.shallowMaxM.toString())}'), findsOneWidget);
      expect(find.text('${en.depthDeep} ${en.depthAbove(limits.deepMinM.toString())}'), findsOneWidget);
    });
  });

  group('taps', () {
    testWidgets('the pocket label opens that pocket', (tester) async {
      await openMap(tester);
      await tester.tap(find.textContaining('P04 ·'));
      await tester.pumpAndSettle();
      expect(find.text(en.whyFlagged), findsOneWidget);
      expect(find.text(en.estimatedPopulation), findsOneWidget);
    });

    testWidgets('a tap on the screen position of a route opens the route sheet', (tester) async {
      await openMap(tester);
      final camera = cameraOf(tester);
      // A point on any route clear of service markers, pocket labels and the buttons, which sit on top.
      final width = tester.getSize(find.byType(FlutterMap)).width;
      final markers = bundle.services.map((s) => camera.latLngToScreenOffset(s.point)).toList();
      final labels = bundle.pockets.map((p) => camera.latLngToScreenOffset(p.point)).toList();
      final points = bundle.routes.expand((r) => r.points).map(camera.latLngToScreenOffset);
      final clear = points.firstWhere((p) =>
          p.dx < width - 70 &&
          markers.every((m) => (m - p).distance > 30) &&
          labels.every((m) => (m.dx - p.dx).abs() > 60 || (m.dy - p.dy).abs() > 26));
      await tester.tapAt(tester.getTopLeft(find.byType(FlutterMap)) + clear);
      await tester.pumpAndSettle();
      expect(find.textContaining(RegExp('${en.routeSafestLabel}|${en.routeShortestLabel}')), findsWidgets);
      expect(find.text(en.routesIllustrative), findsOneWidget);
    });

    testWidgets('a tap on a service opens its sheet, and clinics show their status', (tester) async {
      await openMap(tester);
      // Called directly: at the fitted zoom neighbouring markers overlap this one.
      tester.widget<ServicesLayer>(find.byType(ServicesLayer)).onTap(bundle.clinics.first);
      await tester.pumpAndSettle();
      expect(find.text(en.clinicReachable), findsOneWidget);
      expect(find.text(en.clinicStatusNote), findsOneWidget);
    });

    testWidgets('choosing a pocket shows only its routes and zooms to it', (tester) async {
      await openMap(tester);
      final before = cameraOf(tester).zoom;
      await tester.tap(find.text('#02 P08'));
      await tester.pumpAndSettle();
      expect(cameraOf(tester).zoom, greaterThan(before));
      final routes = tester.widget<PolylineLayer<Object>>(find.descendant(
        of: find.byType(RoutesLayer),
        matching: find.byWidgetPredicate((w) => w is PolylineLayer),
      ));
      expect(routes.polylines, hasLength(2));
    });
  });

  testWidgets('View on map from a mission selects the pocket on the map', (tester) async {
    await pumpApp(tester, bundle, height: 844);
    await tester.tap(find.text(en.tabMissions).last);
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('West of Guija').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text(en.viewOnMap));
    await tester.pumpAndSettle();
    expect(find.byType(FlutterMap), findsOneWidget);
    expect(find.textContaining('P01 ·'), findsOneWidget);
    final routes = tester.widget<PolylineLayer<Object>>(find.descendant(
      of: find.byType(RoutesLayer),
      matching: find.byWidgetPredicate((w) => w is PolylineLayer),
    ));
    expect(routes.polylines, hasLength(2));
  });

  testWidgets('no overflow on the map at 200% text', (tester) async {
    await openMap(tester, textScale: 2.0);
    expect(tester.takeException(), isNull);
    await tester.tap(find.byTooltip(en.tooltipCompare));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  group('no demo left', () {
    test('no demo files, JPGs or imports remain', () {
      expect(File('lib/models/demo_data.dart').existsSync(), isFalse);
      expect(File('lib/widgets/map_painter.dart').existsSync(), isFalse);
      expect(File('lib/widgets/demo_badge.dart').existsSync(), isFalse);
      expect(Directory('assets/maps').existsSync(), isFalse);
      expect(File('pubspec.yaml').readAsStringSync(), isNot(contains('assets/maps')));
      final banned = RegExp(r'demo_|DemoBadge|DEMO_DATA|map_painter|assets/maps|\.jpg|analysis_progress');
      final sources = Directory('lib').listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
      for (final file in sources) {
        // synthetic_demo is a real manifest field.
        final text = file.readAsStringSync().replaceAll('synthetic_demo', '');
        expect(banned.hasMatch(text), isFalse, reason: file.path);
      }
    });

    test('depth limits are not typed into the ARB files', () {
      for (final name in const ['app_en.arb', 'app_pt.arb']) {
        final text = File('lib/l10n/$name').readAsStringSync();
        expect(RegExp(r'0[.,][38]\s*m').hasMatch(text), isFalse, reason: name);
      }
    });
  });
}
