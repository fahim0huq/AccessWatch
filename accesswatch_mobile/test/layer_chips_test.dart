// The chip row on the Map: defaults, toggling, saving, screen readers, 200% text.
import 'package:accesswatch_mobile/data/bundle_repository.dart';
import 'package:accesswatch_mobile/data/models/enums.dart';
import 'package:accesswatch_mobile/l10n/app_localizations.dart';
import 'package:accesswatch_mobile/l10n/app_localizations_en.dart';
import 'package:accesswatch_mobile/l10n/app_localizations_pt.dart';
import 'package:accesswatch_mobile/state/map_state.dart';
import 'package:accesswatch_mobile/state/settings_store.dart';
import 'package:accesswatch_mobile/widgets/map/feature_layers.dart';
import 'package:accesswatch_mobile/widgets/map/flood_layers.dart';
import 'package:accesswatch_mobile/widgets/map/layer_chips.dart';
import 'package:accesswatch_mobile/widgets/map/legend_pill.dart';
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

  Finder chip(MapLayer layer) => find.byKey(ValueKey('layer-chip-${layer.name}'));

  Future<void> tapChip(WidgetTester tester, MapLayer layer) async {
    await tester.ensureVisible(chip(layer));
    await tester.pumpAndSettle();
    await tester.tap(chip(layer));
    await tester.pumpAndSettle();
  }

  bool chipOn(WidgetTester tester, MapLayer layer) => tester.widget<LayerChip>(chip(layer)).selected;

  testWidgets('six chips; Flood and Areas on, the rest off; no legend stack', (tester) async {
    await pumpApp(tester, bundle, height: 844);
    expect(find.byType(LayerChip), findsNWidgets(6));
    for (final word in [en.chipFlood, en.chipAreas, en.chipRoutes, en.chipClinics, en.chipMarkets, en.chipShelters]) {
      expect(
        find.descendant(of: find.byType(LayerChipRow), matching: find.text(word)),
        findsOneWidget,
        reason: word,
      );
    }
    expect(chipOn(tester, MapLayer.flood), isTrue);
    expect(chipOn(tester, MapLayer.pockets), isTrue);
    for (final off in [MapLayer.routes, MapLayer.clinics, MapLayer.markets, MapLayer.shelters]) {
      expect(chipOn(tester, off), isFalse, reason: off.name);
    }
    expect(find.byType(MapLegendPill), findsNothing);
  });

  testWidgets('each chip switches its layer on the map, and back', (tester) async {
    await pumpApp(tester, bundle, height: 844);
    await tapChip(tester, MapLayer.flood);
    expect(find.byType(FloodLayer), findsNothing);
    await tapChip(tester, MapLayer.pockets);
    expect(find.byType(PocketAreasLayer), findsNothing);
    await tapChip(tester, MapLayer.routes);
    expect(find.byType(RoutesLayer), findsOneWidget);
    await tapChip(tester, MapLayer.clinics);
    await tapChip(tester, MapLayer.shelters);
    expect(tester.widget<ServicesLayer>(find.byType(ServicesLayer)).types, {ServiceType.clinic, ServiceType.shelter});
    await tapChip(tester, MapLayer.routes);
    expect(find.byType(RoutesLayer), findsNothing);
    await tapChip(tester, MapLayer.flood);
    expect(find.byType(FloodLayer), findsOneWidget);
  });

  testWidgets('the choice is saved with the existing key and comes back', (tester) async {
    await pumpApp(tester, bundle, height: 844);
    await tapChip(tester, MapLayer.markets);
    final saved = (await SharedPreferences.getInstance()).getStringList(SettingsKeys.mapLayers)!;
    expect(saved, containsAll(['flood', 'pockets', 'markets']));
    await pumpApp(tester, bundle, height: 844, saved: {SettingsKeys.mapLayers: saved});
    expect(chipOn(tester, MapLayer.markets), isTrue);
    final container = ProviderScope.containerOf(tester.element(find.byType(FlutterMap)));
    expect(container.read(mapLayersProvider), contains(MapLayer.markets));
  });

  testWidgets('chips are buttons with a label and a selected state', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpApp(tester, bundle, height: 844);
    expect(
      tester.getSemantics(chip(MapLayer.flood)),
      matchesSemantics(
        label: en.chipFlood,
        isButton: true,
        isSelected: true,
        hasSelectedState: true,
        hasToggledState: true,
        isToggled: true,
        hasTapAction: true,
        isFocusable: true,
        hasFocusAction: true,
      ),
    );
    expect(
      tester.getSemantics(chip(MapLayer.routes)),
      matchesSemantics(
        label: en.chipRoutes,
        isButton: true,
        hasSelectedState: true,
        hasToggledState: true,
        hasTapAction: true,
        isFocusable: true,
        hasFocusAction: true,
      ),
    );
    semantics.dispose();
  });

  for (final (locale, l) in [(const Locale('en'), en), (const Locale('pt'), pt)]) {
    testWidgets('the chips meet the guidelines and have no overflow at 200% (${locale.languageCode})', (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpApp(tester, bundle, locale: locale, height: 844);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      semantics.dispose();
      await pumpApp(tester, bundle, locale: locale, height: 844, textScale: 2.0);
      expect(find.text(l.chipShelters), findsOneWidget);
      await tapChip(tester, MapLayer.shelters);
      expect(chipOn(tester, MapLayer.shelters), isTrue);
      expect(tester.takeException(), isNull);
    });
  }
}
