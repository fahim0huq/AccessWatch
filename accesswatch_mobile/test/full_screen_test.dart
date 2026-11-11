// Full-screen map: enter, exit, no bar or summary card, only the floating controls.
import 'package:accesswatch_mobile/data/bundle_repository.dart';
import 'package:accesswatch_mobile/l10n/app_localizations.dart';
import 'package:accesswatch_mobile/l10n/app_localizations_en.dart';
import 'package:accesswatch_mobile/l10n/app_localizations_pt.dart';
import 'package:accesswatch_mobile/widgets/map/feature_layers.dart';
import 'package:accesswatch_mobile/widgets/map/full_screen_map.dart';
import 'package:accesswatch_mobile/widgets/map/layers_sheet.dart';
import 'package:accesswatch_mobile/widgets/map/legend_pill.dart';
import 'package:accesswatch_mobile/widgets/map/map_overlay.dart';
import 'package:accesswatch_mobile/widgets/map/routes_panel.dart';
import 'package:accesswatch_mobile/widgets/ui/floating_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
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

  Future<void> enter(WidgetTester tester) async {
    await tester.tap(find.byKey(const ValueKey('enter-full-screen')));
    await tester.pumpAndSettle();
  }

  void tapArea(WidgetTester tester, String id) =>
      tester.widget<PocketLabelsLayer>(find.byType(PocketLabelsLayer)).onTap(bundle.pockets.firstWhere((p) => p.id == id));

  testWidgets('enter hides the bar and the summary card; exit brings them back', (tester) async {
    await pumpApp(tester, bundle, height: 844);
    expect(find.byType(FloatingNavBar), findsOneWidget);
    expect(find.byType(MapSummaryCard), findsOneWidget);
    await enter(tester);
    expect(find.byType(FloatingNavBar), findsNothing);
    expect(find.byType(MapSummaryCard), findsNothing);
    expect(find.byKey(const ValueKey('enter-full-screen')), findsNothing);
    await tester.tap(find.byTooltip(en.exitFullScreen));
    await tester.pumpAndSettle();
    expect(find.byType(FloatingNavBar), findsOneWidget);
    expect(find.byType(MapSummaryCard), findsOneWidget);
  });

  testWidgets('full screen keeps every floating control', (tester) async {
    await pumpApp(tester, bundle, height: 844);
    await enter(tester);
    for (final tip in [
      en.exitFullScreen,
      en.layersButton,
      en.routesButton,
      en.tooltipLocate,
      en.tooltipFit,
      en.tooltipZoomIn,
      en.tooltipZoomOut,
    ]) {
      expect(find.byTooltip(tip), findsOneWidget, reason: tip);
    }
    expect(find.byType(MapLegendPill), findsOneWidget);
    for (final word in [en.legendFlooded, en.legendBoat, en.legendVehicle]) {
      expect(find.descendant(of: find.byType(MapLegendPill), matching: find.text(word)), findsOneWidget);
    }
    expect(find.byType(Scalebar), findsOneWidget);
    // Layers and Routes still open their panels.
    await tester.tap(find.byTooltip(en.layersButton));
    await tester.pumpAndSettle();
    expect(find.byType(LayersSheet), findsOneWidget);
    Navigator.of(tester.element(find.byType(LayersSheet))).pop();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip(en.routesButton));
    await tester.pumpAndSettle();
    expect(find.byType(RoutesPanel), findsOneWidget);
  });

  testWidgets('a tapped area shows the small card; Open leaves full screen for the area', (tester) async {
    await pumpApp(tester, bundle, height: 844);
    await enter(tester);
    tapArea(tester, 'P01');
    await tester.pumpAndSettle();
    final card = find.byType(FullScreenAreaCard);
    expect(find.descendant(of: card, matching: find.text(en.modeNeedsBoat)), findsOneWidget);
    expect(find.descendant(of: card, matching: find.text(en.populationEstimate('12,853'))), findsOneWidget);
    // No bottom sheet in full screen: the card is the answer.
    expect(find.byType(BottomSheet), findsNothing);
    await tester.tap(find.descendant(of: card, matching: find.text(en.openArea)));
    await tester.pumpAndSettle();
    expect(find.byType(FloatingNavBar), findsOneWidget);
    expect(find.text(en.waterDepthTitle), findsOneWidget);
  });

  for (final (locale, l) in [(const Locale('en'), en), (const Locale('pt'), pt)]) {
    testWidgets('full screen meets the guidelines and has no overflow at 200% (${locale.languageCode})', (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpApp(tester, bundle, locale: locale, height: 844);
      await enter(tester);
      tapArea(tester, 'P05');
      await tester.pumpAndSettle();
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      semantics.dispose();
      await pumpApp(tester, bundle, locale: locale, height: 844, textScale: 2.0);
      expect(tester.takeException(), isNull);
      await enter(tester);
      expect(tester.takeException(), isNull);
      tapArea(tester, 'P05');
      await tester.pumpAndSettle();
      expect(find.byType(FullScreenAreaCard), findsOneWidget);
      expect(find.text(l.openArea), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
