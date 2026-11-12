// Every route separately: one alone, all, none, highlight, and from an area.
import 'package:accesswatch_mobile/data/bundle_repository.dart';
import 'package:accesswatch_mobile/data/models/route_line.dart';
import 'package:accesswatch_mobile/l10n/app_localizations.dart';
import 'package:accesswatch_mobile/l10n/app_localizations_en.dart';
import 'package:accesswatch_mobile/l10n/app_localizations_pt.dart';
import 'package:accesswatch_mobile/state/route_view.dart';
import 'package:accesswatch_mobile/widgets/help/area_card.dart';
import 'package:accesswatch_mobile/widgets/map/feature_layers.dart';
import 'package:accesswatch_mobile/widgets/map/routes_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_harness.dart';

void main() {
  late AppBundle bundle;
  final AppLocalizations en = AppLocalizationsEn();
  final AppLocalizations pt = AppLocalizationsPt();

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    bundle = await BundleRepository().load();
  });

  Future<void> openPanel(WidgetTester tester, {AppLocalizations? l}) async {
    final t = l ?? en;
    await tester.tap(find.byTooltip(t.layersButton));
    await tester.pumpAndSettle();
    final open = find.byKey(const ValueKey('layer-switch-routes'));
    await tester.ensureVisible(open);
    await tester.pumpAndSettle();
    await tester.tap(open);
    await tester.pumpAndSettle();
  }

  List<Polyline<RouteLine>> drawn(WidgetTester tester) {
    final layer = find.descendant(of: find.byType(RoutesLayer), matching: find.byType(PolylineLayer<RouteLine>));
    return layer.evaluate().isEmpty ? [] : tester.widget<PolylineLayer<RouteLine>>(layer).polylines;
  }

  MapCamera camera(WidgetTester tester) => MapCamera.of(tester.element(find.byType(PocketLabelsLayer)));

  Future<void> tapRow(WidgetTester tester, String pocket, String type) async {
    final row = find.byKey(ValueKey('route-row-$pocket-$type'));
    await tester.ensureVisible(row);
    await tester.pumpAndSettle();
    await tester.tap(row);
    await tester.pumpAndSettle();
  }

  testWidgets('a row shows only that route and zooms to it; tapping it again clears it', (tester) async {
    await pumpApp(tester, bundle, height: 844);
    final before = camera(tester).zoom;
    await openPanel(tester);
    expect(find.byType(RoutesPanel), findsOneWidget);
    await tapRow(tester, 'P05', 'shortest');
    expect(find.byType(RoutesPanel), findsNothing);
    final lines = drawn(tester);
    expect(lines, hasLength(1));
    expect((lines.single.hitValue!.pocketId, lines.single.hitValue!.routeType.name), ('P05', 'shortest'));
    expect(camera(tester).zoom, greaterThan(before));
    await openPanel(tester);
    expect(find.text(en.routeShownOnly), findsOneWidget);
    await tapRow(tester, 'P05', 'shortest');
    expect(find.text(en.routeShownOnly), findsNothing);
    expect(drawn(tester), isEmpty);
  });

  testWidgets('Show all routes draws every route; Hide all removes them', (tester) async {
    await pumpApp(tester, bundle, height: 844);
    await openPanel(tester);
    await tester.tap(find.text(en.routesShowAll));
    await tester.pumpAndSettle();
    expect(drawn(tester), hasLength(bundle.routes.length));
    await openPanel(tester);
    await tester.tap(find.text(en.routesHideAll));
    await tester.pumpAndSettle();
    expect(drawn(tester), isEmpty);
  });

  testWidgets('every row has a pattern word, distance and its warnings', (tester) async {
    await pumpApp(tester, bundle, height: 844);
    await openPanel(tester);
    final p01 = bundle.routes.firstWhere((r) => r.pocketId == 'P01' && r.routeType.name == 'safest');
    expect(find.text('${en.routeRowSafest} · ${en.routeLineSolid}'), findsWidgets);
    expect(find.text('${en.routeRowShortest} · ${en.routeLineDashed}'), findsWidgets);
    expect(find.text('• ${en.routeDeepWater('0.56')}'), findsWidgets);
    expect(find.text('• ${en.routeUncertainBridges(p01.uncertainBridges)}'), findsWidgets);
    // P01's two routes are the same road, and the row says so.
    expect(find.text(en.routeSameRoad), findsWidgets);
  });

  testWidgets('with several shown, tapping a line highlights it and shows its card', (tester) async {
    await pumpApp(tester, bundle, height: 844);
    await openPanel(tester);
    await tester.tap(find.text(en.routesShowAll));
    await tester.pumpAndSettle();
    final p03 = bundle.routes.firstWhere((r) => r.pocketId == 'P03');
    tester.widget<RoutesLayer>(find.byType(RoutesLayer)).onTap([p03]);
    await tester.pumpAndSettle();
    final container = ProviderScope.containerOf(tester.element(find.byType(FlutterMap)));
    expect(sameRoute(container.read(highlightedRouteProvider), p03), isTrue);
    expect(drawn(tester).where((p) => p.borderStrokeWidth > 0).single.hitValue, p03);
    expect(find.text(en.routesIllustrative), findsOneWidget);
  });

  testWidgets('Show on map from an area opens the panel on that area', (tester) async {
    await pumpApp(tester, bundle, height: 844);
    await tester.tap(find.text(en.tabHelpFirst).last);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(AreaCard).at(1));
    await tester.pumpAndSettle();
    final show = find.text(en.viewOnMap);
    await scrollTo(tester, show);
    await tester.tap(show);
    await tester.pumpAndSettle();
    expect(find.byType(RoutesPanel), findsOneWidget);
    expect(tester.widget<RoutesPanel>(find.byType(RoutesPanel)).focusPocketId, 'P05');
    final focus = tester.getTopLeft(find.byKey(const ValueKey('routes-area-P05'))).dy;
    final top = tester.getTopLeft(find.byKey(const ValueKey('routes-area-P01'))).dy;
    expect(focus, lessThan(top));
  });

  for (final (locale, l) in [(const Locale('en'), en), (const Locale('pt'), pt)]) {
    testWidgets('the panel meets the guidelines and has no overflow at 200% (${locale.languageCode})', (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpApp(tester, bundle, locale: locale, height: 844);
      await openPanel(tester, l: l);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      semantics.dispose();
      await pumpApp(tester, bundle, locale: locale, height: 844, textScale: 2.0);
      await openPanel(tester, l: l);
      await tester.ensureVisible(find.byKey(const ValueKey('route-row-P07-shortest')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
