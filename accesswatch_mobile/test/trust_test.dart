// About this data: the honest summary, every page behind it, and first run.
import 'package:accesswatch_mobile/data/bundle_repository.dart';
import 'package:accesswatch_mobile/data/models/enums.dart';
import 'package:accesswatch_mobile/data/models/quality.dart';
import 'package:accesswatch_mobile/l10n/app_localizations.dart';
import 'package:accesswatch_mobile/l10n/app_localizations_en.dart';
import 'package:accesswatch_mobile/l10n/app_localizations_pt.dart';
import 'package:accesswatch_mobile/screens/welcome_screen.dart';
import 'package:accesswatch_mobile/state/map_state.dart';
import 'package:accesswatch_mobile/state/providers.dart';
import 'package:accesswatch_mobile/state/settings_store.dart';
import 'package:accesswatch_mobile/utils/labels.dart';
import 'package:accesswatch_mobile/utils/trust_text.dart';
import 'package:accesswatch_mobile/widgets/ranking_panel.dart';
import 'package:accesswatch_mobile/widgets/trust/trust_sections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_harness.dart';
import 'support/bundle_variants.dart';

void main() {
  late AppBundle bundle;
  final AppLocalizations en = AppLocalizationsEn();
  final AppLocalizations pt = AppLocalizationsPt();
  const fmt = Fmt('en');

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    bundle = await BundleRepository().load();
  });

  Future<void> openInfo(WidgetTester tester, {Locale locale = const Locale('en'), AppBundle? data}) async {
    await pumpApp(tester, data ?? bundle, locale: locale);
    await openAbout(tester);
  }

  /// One of the rows of About, by its title.
  Future<void> openPage(WidgetTester tester, String row) async {
    await scrollTo(tester, find.text(row));
    await tester.tap(find.text(row));
    await tester.pumpAndSettle();
  }

  group('summary card', () {
    testWidgets('lists every true quality flag in plain words, and no false one', (tester) async {
      await openInfo(tester);
      expect(find.text(en.aboutPreliminary), findsOneWidget);
      for (final flag in QualityFlag.values) {
        expect(find.text(en.warningPlain(flag)), bundle.manifest.qualityFlags.contains(flag) ? findsOneWidget : findsNothing,
            reason: flag.name);
      }
    });

    testWidgets('depot_assumed is true in the data and is said in About', (tester) async {
      expect(bundle.manifest.qualityFlags, contains(QualityFlag.depotAssumed));
      await openInfo(tester);
      expect(find.text(en.plainDepotAssumed), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('nav-map')));
      await tester.pumpAndSettle();
      // The Map and Help first leave the warnings to About.
      expect(find.text(en.plainDepotAssumed), findsNothing, reason: 'Map');
      await tester.tap(find.text(en.tabHelpFirst).last);
      await tester.pumpAndSettle();
      expect(find.text(en.plainDepotAssumed), findsNothing, reason: 'Who needs help');
    });

    testWidgets('follows the flags: an auto-selected depot is said, a removed flag is not', (tester) async {
      final auto = withFlags(bundle, {...bundle.manifest.qualityFlags, QualityFlag.depotAutoSelected});
      await openInfo(tester, data: auto);
      expect(find.text(en.plainDepotAutoSelected), findsOneWidget);
      final none = withFlags(bundle, {...bundle.manifest.qualityFlags}..remove(QualityFlag.depotAssumed));
      await openInfo(tester, data: none);
      expect(find.text(en.plainDepotAssumed), findsNothing);
      await openInfo(tester, data: withFlags(bundle, {}));
      expect(find.text(en.aboutPreliminary), findsNothing);
      expect(find.text(en.aboutGuideOnly), findsOneWidget);
    });

    testWidgets('ends with the safety line', (tester) async {
      await openInfo(tester);
      await scrollTo(tester, find.text(en.aboutSafetyLine));
      expect(find.text(en.aboutSafetyLine), findsOneWidget);
    });
  });

  group('known issues', () {
    test('every note in quality.json becomes a plain sentence', () {
      final issues = en.knownIssues(bundle.quality, fmt);
      expect(issues, containsAll([
        en.issueSafestCount('1', '2'),
        en.issueRoadsOutsideCoverage('42', '33'),
        en.issuePocketOutsideCoverage('P01', '3.2'),
        en.issueClinicDuplicates('7', '4'),
      ]));
      // The new data has no rank inversions, so none are listed.
      expect(bundle.quality.notes.rankPopulationInversions, isEmpty);
      expect(issues.where((i) => i.contains('ranks above')), isEmpty);
    });

    testWidgets('are all under Limits and known issues, in English and Portuguese', (tester) async {
      await openInfo(tester);
      await openPage(tester, en.aboutLimitsRow);
      for (final issue in en.knownIssues(bundle.quality, fmt)) {
        await scrollTo(tester, find.text(issue));
        expect(find.text(issue), findsOneWidget);
      }
      await openInfo(tester, locale: const Locale('pt'));
      await openPage(tester, pt.aboutLimitsRow);
      for (final issue in pt.knownIssues(bundle.quality, const Fmt('pt'))) {
        await scrollTo(tester, find.text(issue));
        expect(find.text(issue), findsOneWidget);
      }
    });
  });

  group('pages', () {
    testWidgets('the match page states the calibration plainly', (tester) async {
      await openInfo(tester);
      await openPage(tester, en.aboutMatchRow);
      // In the scores card and the compare legend.
      expect(find.text(en.compareNotIndependent('0.80', '0.82', '0.68')), findsWidgets);
      expect(find.text(en.compareBoth('23.4')), findsOneWidget);
      await scrollTo(tester, find.text(en.scorePhysicsOnly));
      expect(find.text(en.scorePhysicsOnly), findsOneWidget);
    });

    testWidgets('the flood map page has the dates, the EMS gap from the data and the colours', (tester) async {
      await openInfo(tester);
      await openPage(tester, en.aboutFloodMapRow);
      expect(find.text(en.dateNisarBefore('Jan 5, 2026')), findsOneWidget);
      expect(find.text(en.dateEmsImage('Jan 18, 2026')), findsOneWidget);
      expect(find.text(en.dateEmsGap('35.2')), findsOneWidget);
      final limits = bundle.manifest.depthClasses;
      await scrollTo(tester, find.text('${en.depthShallow} ${en.depthBelow(limits.shallowMaxM.toString())}'));
      expect(find.text('${en.depthDeep} ${en.depthAbove(limits.deepMinM.toString())}'), findsOneWidget);
    });

    testWidgets('limits shows every quality flag in full and the limits', (tester) async {
      await openInfo(tester);
      await openPage(tester, en.aboutLimitsRow);
      expect(find.text(en.warnNisarBeta), findsOneWidget);
      expect(find.text(en.warnDepotAssumed), findsOneWidget);
      expect(find.text(en.warnClassifierCalibrated('0.82', '0.68')), findsOneWidget);
      expect(find.text(en.warnDepotAutoSelected), findsNothing);
      await scrollTo(tester, find.text(en.limitBoat));
      expect(find.text(en.limitRoads('99.0', '2')), findsOneWidget);
      expect(find.textContaining('(Only in English'), findsNothing);
    });

    test('every limit in the current report has a translation', () {
      final limits = limitsOf(bundle.quality);
      expect(limits, hasLength(6));
      expect(limits.every((l) => l.topic != null), isTrue);
    });

    testWidgets('sources link only to addresses in the data, DOIs through doi.org', (tester) async {
      await openInfo(tester);
      await openPage(tester, en.aboutSourcesRow);
      await scrollTo(tester, find.text(en.notAffiliated));
      final links = bundle.quality.dataSources
          .fold<int>(0, (n, s) => n + (s.url != null ? 1 : 0) + (s.docs != null ? 1 : 0) + (s.doi != null ? 1 : 0));
      expect(find.byIcon(Icons.open_in_new_rounded), findsNWidgets(links));
      final worldPop = bundle.quality.dataSources.firstWhere((s) => s.name.startsWith('WorldPop'));
      expect(worldPop.url, isNull);
      expect(find.widgetWithText(TextButton, en.sourceDoi(worldPop.doi!)), findsOneWidget);
      expect(doiUrl(worldPop.doi!), 'https://doi.org/10.5258/SOTON/WP00839');
      await scrollTo(tester, find.text('OpenStreetMap'));
      expect(find.text('OpenStreetMap'), findsOneWidget);
    });

    test('a source without links shows only its name', () {
      const source = DataSource('Some source');
      expect(source.url ?? source.docs, isNull);
    });

    testWidgets('data age gives the date, the age and that it works offline', (tester) async {
      await openInfo(tester);
      await openPage(tester, en.aboutAgeRow);
      // Harness clock: 2026-11-08 12:00 UTC; NISAR after scene: 2026-01-17 03:42 UTC.
      expect(find.text(en.dataAge('Jan 17, 2026', 295)), findsOneWidget);
      expect(find.text(en.dataGenerated('Nov 8, 2026')), findsOneWidget);
      expect(find.text(en.offlineWorks), findsOneWidget);
    });

    testWidgets('Advanced holds the sliders, Compare, physics-only and depth controls', (tester) async {
      await openInfo(tester);
      await openPage(tester, en.aboutAdvancedRow);
      expect(find.byType(RankingPanel), findsOneWidget);
      final container = ProviderScope.containerOf(tester.element(find.byType(RankingPanel)));
      for (final (layer, name) in [
        (MapLayer.compare, en.layerCompare),
        (MapLayer.floodBaseline, en.layerBaseline),
        (MapLayer.depthZones, en.layerDepth),
      ]) {
        final tile = find.widgetWithText(SwitchListTile, name);
        await scrollTo(tester, tile);
        final before = container.read(mapLayersProvider).contains(layer);
        await tester.tap(tile);
        await tester.pumpAndSettle();
        expect(container.read(mapLayersProvider).contains(layer), !before, reason: name);
      }
      expect(find.text(en.layerBaselineNote), findsOneWidget);
      // Compare on: its legend and the calibration sentence show here too.
      expect(find.text(en.compareNotIndependent('0.80', '0.82', '0.68')), findsOneWidget);
    });
  });

  group('settings', () {
    testWidgets('language: English by default, Portuguese on request, and back', (tester) async {
      await pumpApp(tester, bundle, overrides: [localeProvider.overrideWith((ref) => readLocale(ref.watch(sharedPreferencesProvider)))]);
      expect(find.text(en.tabHelpFirst), findsOneWidget);
      await openAbout(tester);
      await tester.tap(find.widgetWithText(ChoiceChip, en.languagePortuguese));
      await tester.pumpAndSettle();
      expect(find.text(pt.aboutThisData), findsWidgets);
      await tester.tap(find.widgetWithText(ChoiceChip, pt.languageEnglish));
      await tester.pumpAndSettle();
      expect(find.text(en.aboutThisData), findsWidgets);
    });

    testWidgets('text size offers 100, 125 and 150%', (tester) async {
      await openInfo(tester);
      for (final pct in ['100', '125', '150']) {
        expect(find.widgetWithText(ChoiceChip, en.textSizeOption(pct)), findsOneWidget);
      }
      await tester.tap(find.widgetWithText(ChoiceChip, en.textSizeOption('125')));
      await tester.pumpAndSettle();
      final container = ProviderScope.containerOf(tester.element(find.byType(Navigator).first));
      expect(container.read(textScaleProvider), 1.25);
    });
  });

  group('first run', () {
    testWidgets('one screen, one button: the safety message, then the Map', (tester) async {
      await pumpApp(tester, bundle, saved: {SettingsKeys.safetyAccepted: false});
      expect(find.byType(WelcomeScreen), findsOneWidget);
      expect(find.text(en.introTitle1), findsOneWidget);
      expect(find.text(en.safetyEmergency), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);
      await tester.tap(find.text(en.safetyAccept));
      await tester.pumpAndSettle();
      expect(find.byType(WelcomeScreen), findsNothing);
      expect(find.text(en.mapAreasCutOff(bundle.manifest.stats.pockets)), findsOneWidget);
    });

    testWidgets('a deep link cannot skip the safety message', (tester) async {
      tester.binding.platformDispatcher.defaultRouteNameTestValue = '/care';
      addTearDown(tester.binding.platformDispatcher.clearDefaultRouteNameTestValue);
      await pumpApp(tester, bundle, saved: {SettingsKeys.safetyAccepted: false});
      expect(find.byType(WelcomeScreen), findsOneWidget);
    });

    testWidgets('once accepted, the app opens directly and About can show it again', (tester) async {
      await openInfo(tester);
      await scrollTo(tester, find.text(en.readIntroAgain));
      await tester.tap(find.text(en.readIntroAgain));
      await tester.pumpAndSettle();
      expect(find.byType(WelcomeScreen), findsOneWidget);
      await tester.tap(find.text(en.close));
      await tester.pumpAndSettle();
      expect(find.byType(WelcomeScreen), findsNothing);
      expect(find.text(en.readIntroAgain), findsOneWidget);
    });
  });

  testWidgets('no overflow at 200% on About, its pages and the intro, in both languages', (tester) async {
    for (final locale in const [Locale('en'), Locale('pt')]) {
      final l = locale.languageCode == 'en' ? en : pt;
      await pumpApp(tester, bundle, locale: locale, textScale: 2.0);
      await openAbout(tester);
      expect(tester.takeException(), isNull);
      for (final row in [l.aboutFloodMapRow, l.aboutMatchRow, l.aboutLimitsRow, l.aboutSourcesRow, l.aboutAgeRow, l.aboutAdvancedRow]) {
        await openPage(tester, row);
        expect(tester.takeException(), isNull, reason: '${locale.languageCode} $row');
        await goBack(tester);
      }
      await pumpApp(tester, bundle, locale: locale, textScale: 2.0, saved: {SettingsKeys.safetyAccepted: false});
      expect(tester.takeException(), isNull);
    }
  });
}
