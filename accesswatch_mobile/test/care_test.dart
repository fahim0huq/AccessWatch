import 'dart:async';
import 'dart:io';

import 'package:accesswatch_mobile/data/bundle_repository.dart';
import 'package:accesswatch_mobile/data/models/enums.dart';
import 'package:accesswatch_mobile/data/my_spot.dart';
import 'package:accesswatch_mobile/l10n/app_localizations.dart';
import 'package:accesswatch_mobile/l10n/app_localizations_en.dart';
import 'package:accesswatch_mobile/screens/care_screen.dart';
import 'package:accesswatch_mobile/state/care_state.dart';
import 'package:accesswatch_mobile/state/location.dart';
import 'package:accesswatch_mobile/widgets/map/care_route_layer.dart';
import 'package:accesswatch_mobile/widgets/map/feature_layers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart' show LatLng;

import 'support/app_harness.dart';
import 'support/needs_boat_fixture.dart';

/// A GPS that tests control: counts listeners and sends positions on demand.
class FakeGps implements LocationSource {
  bool permitted;
  final _positions = StreamController<LatLng>.broadcast();

  FakeGps({this.permitted = false});

  bool get listening => _positions.hasListener;

  void send(LatLng p) => _positions.add(p);

  @override
  Future<bool> isPermitted() async => permitted;

  @override
  Future<LocationIssue?> prepare() async {
    permitted = true;
    return null;
  }

  @override
  Stream<LatLng> positions() => _positions.stream;
}

void main() {
  late AppBundle bundle;
  final AppLocalizations en = AppLocalizationsEn();

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    bundle = await BundleRepository().load();
  });

  Future<void> openTab(WidgetTester tester, String label) async {
    await tester.tap(find.text(label).last);
    await tester.pumpAndSettle();
  }

  ProviderContainer containerOf(WidgetTester tester) =>
      ProviderScope.containerOf(tester.element(find.byType(Navigator).first));

  Future<void> standAt(WidgetTester tester, LatLng p) async {
    containerOf(tester).read(locationControllerProvider.notifier).setTestPosition(p);
    await tester.pumpAndSettle();
  }

  group('clinic list', () {
    testWidgets('shows all 7 clinics with their status from the bundle', (tester) async {
      await pumpApp(tester, bundle);
      await openTab(tester, en.tabCare);
      expect(find.text(en.clinicsTitle('7')), findsOneWidget);
      expect(find.text(en.clinicReachable), findsNWidgets(7));
    });
  });

  group('my spot on real data', () {
    testWidgets('at the depot: dry, nearest clinic by road, routes for each mode', (tester) async {
      await pumpApp(tester, bundle);
      await openTab(tester, en.tabCare);
      final depot = bundle.services.firstWhere((s) => s.type == ServiceType.aidDepot).point;
      await standAt(tester, depot);
      expect(find.text(en.testPositionBadge), findsOneWidget);
      expect(find.text(en.spotNotInFlood), findsOneWidget);
      expect(find.textContaining('Nearest clinic by road'), findsOneWidget);
      expect(find.text(en.needsBoatAny), findsNothing);
      expect(find.text(en.showRouteOnMap), findsNWidgets(3));
      expect(find.text('• ${en.routeNoWalkingTime}'), findsOneWidget);
    });

    testWidgets('Show on map draws the road route and its panel', (tester) async {
      await pumpApp(tester, bundle);
      await openTab(tester, en.tabCare);
      await standAt(tester, bundle.services.firstWhere((s) => s.type == ServiceType.aidDepot).point);
      await tester.tap(find.text(en.showRouteOnMap).first);
      await tester.pumpAndSettle();
      expect(find.byType(FlutterMap), findsOneWidget);
      final layer = tester.widget<PolylineLayer<Object>>(
          find.descendant(of: find.byType(CareRouteLayer), matching: find.byType(PolylineLayer<Object>)));
      final route = containerOf(tester).read(careRouteOnMapProvider)!;
      // Every point is a road node, so the line follows roads.
      expect(layer.polylines.single.points, route.points);
      expect(route.points.length, route.clinicRoute.route.nodes.length);
      expect(find.textContaining('To '), findsWidgets);
      await tester.tap(find.byTooltip(en.clearRoute));
      await tester.pumpAndSettle();
      expect(find.byType(PolylineLayer<Object>).evaluate().where((e) => e.widget is PolylineLayer && (e.widget as PolylineLayer).polylines.any((p) => p.color.toARGB32() == 0xFFC026D3)), isEmpty);
    });

    testWidgets('outside the mapped area: says so and does not route', (tester) async {
      await pumpApp(tester, bundle);
      await openTab(tester, en.tabCare);
      await standAt(tester, const LatLng(-25.9, 32.6));
      expect(find.text(en.spotOutside), findsOneWidget);
      expect(find.text(en.routesToClinic), findsNothing);
      expect(containerOf(tester).read(careRoutesProvider).valueOrNull, isNull);
    });
  });

  group('needs a boat (TEST FIXTURE)', () {
    testWidgets('a clinic only deep water reaches says "needs a boat" and draws nothing', (tester) async {
      final fixture = needsBoatFixture(bundle);
      await pumpApp(tester, fixture.bundle);
      await openTab(tester, en.tabCare);
      expect(find.text(en.clinicInsidePocket('P01')), findsOneWidget);
      await standAt(tester, fixture.start);
      expect(find.text(en.needsBoatAny), findsWidgets);
      expect(find.text(en.needsBoatShort), findsOneWidget);
      for (final mode in [en.careModeCar, en.careModeTruck, en.careModeFoot]) {
        expect(find.text(en.noRouteForMode(mode)), findsOneWidget);
      }
      expect(find.text(en.showRouteOnMap), findsNothing);
      expect(containerOf(tester).read(careRouteOnMapProvider), isNull);
    });

    test('a spot more than 400 m from any road is not used', () {
      final fixture = needsBoatFixture(bundle);
      final far = analyzeSpot(fixture.bundle, fixture.farFromRoads);
      expect(far.insideBounds, isTrue);
      expect(far.usable, isFalse);
      expect(analyzeSpot(fixture.bundle, fixture.start).usable, isTrue);
      expect(maxSnapMetres, 400);
    });

    test('the fixture never reaches the app', () {
      for (final file in Directory('lib').listSync(recursive: true).whereType<File>()) {
        expect(file.readAsStringSync(), isNot(contains('FIXTURE')), reason: file.path);
      }
    });
  });

  group('GPS', () {
    testWidgets('explains first, then runs only while Map or Care is on screen', (tester) async {
      final gps = FakeGps();
      await pumpApp(tester, bundle, overrides: [locationSourceProvider.overrideWithValue(gps)]);
      await openTab(tester, en.tabCare);
      await tester.tap(find.text(en.useMyLocation));
      await tester.pumpAndSettle();
      expect(find.text(en.locationWhyTitle), findsOneWidget);
      expect(gps.listening, isFalse);
      await tester.tap(find.text(en.locationContinue));
      await tester.pumpAndSettle();
      expect(gps.listening, isTrue);

      await openTab(tester, en.tabHome);
      expect(gps.listening, isFalse);
      await openTab(tester, en.tabMap);
      expect(gps.listening, isTrue);
      await openTab(tester, en.tabInfo);
      expect(gps.listening, isFalse);
      await openTab(tester, en.tabCare);
      expect(gps.listening, isTrue);

      gps.send(bundle.services.first.point);
      await tester.pumpAndSettle();
      expect(find.text(en.spotNotInFlood), findsOneWidget);
      expect(find.text(en.testPositionBadge), findsNothing);
    });

    testWidgets('"Not now" leaves GPS off', (tester) async {
      final gps = FakeGps();
      await pumpApp(tester, bundle, overrides: [locationSourceProvider.overrideWithValue(gps)]);
      await openTab(tester, en.tabCare);
      await tester.tap(find.text(en.useMyLocation));
      await tester.pumpAndSettle();
      await tester.tap(find.text(en.locationNotNow));
      await tester.pumpAndSettle();
      expect(gps.listening, isFalse);
    });

    testWidgets('a long press on the map sets a labelled test position (debug build)', (tester) async {
      await pumpApp(tester, bundle, height: 844);
      await openTab(tester, en.tabMap);
      await tester.longPress(find.byType(FlutterMap));
      await tester.pumpAndSettle();
      final state = containerOf(tester).read(locationControllerProvider);
      expect(state.isTestPosition, isTrue);
      expect(find.byType(MyLocationLayer), findsOneWidget);
      await openTab(tester, en.tabCare);
      expect(find.text(en.testPositionBadge), findsOneWidget);
      expect(find.byType(CareScreen), findsOneWidget);
    });
  });
}
