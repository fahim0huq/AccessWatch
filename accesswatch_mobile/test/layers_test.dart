// The Map's Layers sheet: every switch, reset, and the saved choice.
import 'package:accesswatch_mobile/data/bundle_repository.dart';
import 'package:accesswatch_mobile/data/models/enums.dart';
import 'package:accesswatch_mobile/l10n/app_localizations.dart';
import 'package:accesswatch_mobile/l10n/app_localizations_en.dart';
import 'package:accesswatch_mobile/l10n/app_localizations_pt.dart';
import 'package:accesswatch_mobile/state/map_state.dart';
import 'package:accesswatch_mobile/state/settings_store.dart';
import 'package:accesswatch_mobile/widgets/map/feature_layers.dart';
import 'package:accesswatch_mobile/widgets/map/flood_layers.dart';
import 'package:accesswatch_mobile/widgets/map/layers_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/app_harness.dart';

void main() {
  late AppBundle bundle;
  final AppLocalizations en = AppLocalizationsEn();
  final AppLocalizations pt = AppLocalizationsPt();

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    bundle = await BundleRepository().load();
  });

  Future<void> openSheet(WidgetTester tester, {AppLocalizations? l}) async {
    await tester.tap(find.byTooltip((l ?? en).layersButton));
    await tester.pumpAndSettle();
  }

  Future<void> flip(WidgetTester tester, MapLayer layer) async {
    final tile = find.byKey(ValueKey('layer-switch-${layer.name}'));
    await tester.ensureVisible(tile);
    await tester.pumpAndSettle();
    await tester.tap(tile);
    await tester.pumpAndSettle();
  }

  Set<ServiceType> placesShown(WidgetTester tester) {
    final layer = find.byType(ServicesLayer);
    return layer.evaluate().isEmpty ? {} : tester.widget<ServicesLayer>(layer).types;
  }

  /// A widget that only exists while its layer is on.
  final drawnBy = <MapLayer, Finder>{
    MapLayer.flood: find.byType(FloodLayer),
    MapLayer.depthZones: find.byType(DepthZonesLayer),
    MapLayer.pockets: find.byType(PocketAreasLayer),
    MapLayer.floodedRoads: find.byType(FloodedRoadsLayer),
    MapLayer.allRoads: find.byType(AllRoadsLayer),
    MapLayer.routes: find.byType(RoutesLayer),
    MapLayer.floodBaseline: find.byType(BaselineFloodLayer),
    MapLayer.compare: find.byType(OverlayImageLayer),
  };

  testWidgets('every switch shows and hides its layer', (tester) async {
    await pumpApp(tester, bundle, height: 844);
    await openSheet(tester);
    for (final entry in drawnBy.entries) {
      final on = entry.value.evaluate().isNotEmpty;
      await flip(tester, entry.key);
      expect(entry.value, on ? findsNothing : findsWidgets, reason: '${entry.key.name} after one tap');
      await flip(tester, entry.key);
      expect(entry.value, on ? findsWidgets : findsNothing, reason: '${entry.key.name} after two taps');
    }
    for (final entry in placeLayers.entries) {
      await flip(tester, entry.key);
      expect(placesShown(tester), contains(entry.value), reason: entry.key.name);
      await flip(tester, entry.key);
      expect(placesShown(tester), isNot(contains(entry.value)), reason: entry.key.name);
    }
  });

  testWidgets('turning off flood water removes the blue layer; reset brings the default back', (tester) async {
    await pumpApp(tester, bundle, height: 844);
    await openSheet(tester);
    await flip(tester, MapLayer.flood);
    expect(find.byType(FloodLayer), findsNothing);
    await flip(tester, MapLayer.clinics);
    await flip(tester, MapLayer.allRoads);
    final reset = find.text(en.resetView);
    await tester.ensureVisible(reset);
    await tester.tap(reset);
    await tester.pumpAndSettle();
    final container = ProviderScope.containerOf(tester.element(find.byType(FlutterMap)));
    expect(container.read(mapLayersProvider), defaultMapLayers);
    expect(find.byType(FloodLayer), findsOneWidget);
    expect(find.byType(AllRoadsLayer), findsNothing);
  });

  testWidgets('the choice is saved and comes back after a restart', (tester) async {
    await pumpApp(tester, bundle, height: 844);
    await openSheet(tester);
    await flip(tester, MapLayer.flood);
    await flip(tester, MapLayer.markets);
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(SettingsKeys.mapLayers)!;
    expect(saved, containsAll(['markets', 'pockets']));
    expect(saved, isNot(contains('flood')));
    await pumpApp(tester, bundle, height: 844, saved: {SettingsKeys.mapLayers: saved});
    expect(find.byType(FloodLayer), findsNothing);
    expect(placesShown(tester), {ServiceType.market});
  });

  test('unknown saved layer names are skipped', () async {
    SharedPreferences.setMockInitialValues({SettingsKeys.mapLayers: ['flood', 'a_removed_layer']});
    expect(readMapLayers(await SharedPreferences.getInstance()), {MapLayer.flood});
  });

  testWidgets('the depot says it is assumed; the map has a scale bar', (tester) async {
    await pumpApp(tester, bundle, height: 844);
    expect(find.byType(Scalebar), findsOneWidget);
    await openSheet(tester);
    expect(find.text(en.layerDepotAssumed), findsOneWidget);
    expect(find.text(en.layerFlood), findsOneWidget);
  });

  for (final (locale, l) in [(const Locale('en'), en), (const Locale('pt'), pt)]) {
    testWidgets('the sheet meets the guidelines and has no overflow at 200% (${locale.languageCode})', (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpApp(tester, bundle, locale: locale, height: 844);
      await openSheet(tester, l: l);
      await flip(tester, MapLayer.allRoads);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      semantics.dispose();
      await pumpApp(tester, bundle, locale: locale, height: 844, textScale: 2.0);
      await openSheet(tester, l: l);
      final reset = find.text(l.resetView);
      await tester.ensureVisible(reset);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
