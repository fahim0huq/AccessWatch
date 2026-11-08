import 'package:accesswatch_mobile/data/bundle_repository.dart';
import 'package:accesswatch_mobile/data/models/enums.dart';
import 'package:accesswatch_mobile/l10n/app_localizations.dart';
import 'package:accesswatch_mobile/l10n/app_localizations_en.dart';
import 'package:accesswatch_mobile/l10n/app_localizations_pt.dart';
import 'package:accesswatch_mobile/widgets/mission_list_card.dart';
import 'package:flutter/material.dart';
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

  Future<void> openTab(WidgetTester tester, String label) async {
    await tester.tap(find.text(label).last);
    await tester.pumpAndSettle();
  }

  testWidgets('Home shows KPIs from the manifest and every warning', (tester) async {
    await pumpApp(tester, bundle);
    final stats = bundle.manifest.stats;
    expect(find.text('ACCESSWATCH'), findsOneWidget);
    expect(find.text(en.kpiPockets('${stats.pockets}')), findsOneWidget);
    expect(find.text('13,072'), findsOneWidget);
    expect(find.text(en.warnShortNisarBeta), findsOneWidget);
    expect(find.text(en.warnShortDepotAssumed), findsOneWidget);
    expect(find.text(en.warnShortValidationProductOrder), findsOneWidget);
    expect(find.text(en.warnShortClassifierCalibrated), findsOneWidget);
    expect(find.text('DEMO DATA'), findsNothing);
  });

  testWidgets('a banner opens to its full text with values from the bundle', (tester) async {
    await pumpApp(tester, bundle);
    await tester.tap(find.text(en.warnShortClassifierCalibrated));
    await tester.pumpAndSettle();
    expect(find.text(en.warnClassifierCalibrated('0.82', '0.68')), findsOneWidget);
  });

  testWidgets('Missions lists every card and shows all warnings', (tester) async {
    await pumpApp(tester, bundle);
    await openTab(tester, en.tabMissions);
    expect(find.text(en.warnShortNisarBeta), findsOneWidget);
    expect(find.text(en.pocketTitle('west', 'Guija')), findsWidgets);
    expect(find.byType(MissionListCard), findsNWidgets(bundle.missions.length));
    expect(find.text('P07'), findsOneWidget);
  });

  testWidgets('the access filter only keeps matching missions', (tester) async {
    await pumpApp(tester, bundle);
    await openTab(tester, en.tabMissions);
    final chip = find.widgetWithText(ChoiceChip, en.accessBoat);
    await tester.ensureVisible(chip);
    await tester.pumpAndSettle();
    await tester.tap(chip);
    await tester.pumpAndSettle();
    final boats = bundle.missions.where((m) => m.accessMode == AccessMode.boat).length;
    expect(find.text(en.rankedPockets('$boats')), findsOneWidget);
  });

  testWidgets('mission sheet shows real fields and depth as a class, not metres', (tester) async {
    await pumpApp(tester, bundle);
    await openTab(tester, en.tabMissions);
    await tester.tap(find.byType(MissionListCard).first);
    await tester.pumpAndSettle();
    expect(find.text('12,853'), findsOneWidget);
    expect(find.text(en.estimatedMaxDepth), findsOneWidget);
    expect(find.text(en.boatLegKm('0.56')), findsOneWidget);
  });

  testWidgets('Map tab shows the warnings above the map', (tester) async {
    await pumpApp(tester, bundle);
    await openTab(tester, en.tabMap);
    // They start collapsed to a chip that names how many there are.
    expect(find.text(en.warnShortNisarBeta), findsNothing);
    await tester.tap(find.text(en.warningsToggle('${bundle.manifest.qualityFlags.length}')));
    await tester.pumpAndSettle();
    expect(find.text(en.warnShortNisarBeta), findsOneWidget);
    expect(find.text(en.warnShortClassifierCalibrated), findsOneWidget);
  });

  testWidgets('Info reads dates and sources from the bundle', (tester) async {
    await pumpApp(tester, bundle);
    await openTab(tester, en.tabInfo);
    expect(find.text(en.dateNisarBefore('Jan 5, 2026')), findsOneWidget);
    expect(find.text(en.dateEmsImage('Jan 18, 2026')), findsOneWidget);
    await scrollTo(tester, find.text('OpenStreetMap'));
    expect(find.text('OpenStreetMap'), findsOneWidget);
  });

  testWidgets('Portuguese changes text and number format', (tester) async {
    await pumpApp(tester, bundle, locale: const Locale('pt'));
    expect(find.text(pt.tabMissions), findsOneWidget);
    expect(find.text(pt.warnShortNisarBeta), findsOneWidget);
    expect(find.text('13.072'), findsOneWidget);
  });

  group('no overflow at 200% text', () {
    for (final locale in const [Locale('en'), Locale('pt')]) {
      testWidgets('Home, Missions and Info in ${locale.languageCode}', (tester) async {
        final l = locale.languageCode == 'en' ? en : pt;
        await pumpApp(tester, bundle, locale: locale, textScale: 2.0);
        await openTab(tester, l.tabMissions);
        await tester.tap(find.byType(MissionListCard).first);
        await tester.pumpAndSettle();
        await tester.tap(find.text(l.back));
        await tester.pumpAndSettle();
        await openTab(tester, l.tabInfo);
        expect(tester.takeException(), isNull);
      });
    }
  });
}
