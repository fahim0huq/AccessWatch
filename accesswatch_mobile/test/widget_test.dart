import 'package:accesswatch_mobile/data/bundle_repository.dart';
import 'package:accesswatch_mobile/data/models/enums.dart';
import 'package:accesswatch_mobile/l10n/app_localizations.dart';
import 'package:accesswatch_mobile/l10n/app_localizations_en.dart';
import 'package:accesswatch_mobile/l10n/app_localizations_pt.dart';
import 'package:accesswatch_mobile/widgets/help/area_card.dart';
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

  testWidgets('Help first lists every area, most urgent first', (tester) async {
    await pumpApp(tester, bundle);
    await openTab(tester, en.tabHelpFirst);
    expect(find.text(en.helpTitle), findsOneWidget);
    expect(find.text(en.helpSubtitle(bundle.missions.length)), findsOneWidget);
    // No warning banners here: they live in About.
    expect(find.text(en.warnShortNisarBeta), findsNothing);
    expect(find.text(en.pocketTitle('west', 'Guija')), findsWidgets);
    expect(find.byType(AreaCard), findsNWidgets(bundle.missions.length));
    // Only the most urgent card is emphasised, with its own Open button.
    final cards = tester.widgetList<AreaCard>(find.byType(AreaCard)).toList();
    expect(cards.first.emphasised, isTrue);
    expect(cards.skip(1).any((c) => c.emphasised), isFalse);
    expect(find.text(en.openArea), findsOneWidget);
  });

  testWidgets('the access filter only keeps matching missions', (tester) async {
    await pumpApp(tester, bundle);
    await openTab(tester, en.tabHelpFirst);
    final boats = bundle.missions.where((m) => m.accessMode == AccessMode.boat).length;
    final trucks = bundle.missions.where((m) => m.accessMode == AccessMode.highClearanceTruck).length;
    // Counts on the chips come from the data.
    expect(find.text(en.filterAllCount('${bundle.missions.length}')), findsOneWidget);
    expect(find.text(en.filterTruckCount('$trucks')), findsOneWidget);
    final chip = find.widgetWithText(FilterChip, en.filterBoatCount('$boats'));
    await tester.ensureVisible(chip);
    await tester.pumpAndSettle();
    await tester.tap(chip);
    await tester.pumpAndSettle();
    expect(find.byType(AreaCard), findsNWidgets(boats));
  });

  testWidgets('mission sheet shows real fields and depth as a class, not metres', (tester) async {
    await pumpApp(tester, bundle);
    await openTab(tester, en.tabHelpFirst);
    await tester.tap(find.byType(AreaCard).first);
    await tester.pumpAndSettle();
    expect(find.text(en.populationEstimate('12,853')), findsOneWidget);
    await tester.tap(find.text(en.howSure(en.sureLow)));
    await tester.pumpAndSettle();
    expect(find.text(en.estimatedMaxDepth), findsOneWidget);
    expect(find.text(en.depthDeep), findsWidgets);
  });

  testWidgets('Portuguese changes text and number format', (tester) async {
    await pumpApp(tester, bundle, locale: const Locale('pt'));
    expect(find.text(pt.tabHelpFirst), findsOneWidget);
    await openTab(tester, pt.tabHelpFirst);
    expect(find.text(pt.populationEstimate('12.853')), findsOneWidget);
  });

  group('no overflow at 200% text', () {
    for (final locale in const [Locale('en'), Locale('pt')]) {
      testWidgets('Help first, an area and About in ${locale.languageCode}', (tester) async {
        final l = locale.languageCode == 'en' ? en : pt;
        await pumpApp(tester, bundle, locale: locale, textScale: 2.0);
        await openTab(tester, l.tabHelpFirst);
        await tester.tap(find.byType(AreaCard).first);
        await tester.pumpAndSettle();
        for (final row in [l.checkOnGround('4'), l.howSure(l.sureLow)]) {
          await tester.tap(find.text(row));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull, reason: row);
          await goBack(tester);
        }
        await goBack(tester);
        await openAbout(tester);
        expect(tester.takeException(), isNull);
      });
    }
  });
}
