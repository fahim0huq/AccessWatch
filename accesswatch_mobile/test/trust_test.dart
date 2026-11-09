import 'package:accesswatch_mobile/data/bundle_repository.dart';
import 'package:accesswatch_mobile/data/models/enums.dart';
import 'package:accesswatch_mobile/data/models/quality.dart';
import 'package:accesswatch_mobile/l10n/app_localizations.dart';
import 'package:accesswatch_mobile/l10n/app_localizations_en.dart';
import 'package:accesswatch_mobile/l10n/app_localizations_pt.dart';
import 'package:accesswatch_mobile/screens/welcome_screen.dart';
import 'package:accesswatch_mobile/state/settings_store.dart';
import 'package:accesswatch_mobile/utils/labels.dart';
import 'package:accesswatch_mobile/utils/trust_text.dart';
import 'package:accesswatch_mobile/widgets/trust/trust_sections.dart';
import 'package:flutter/material.dart';
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

  Future<void> openInfo(WidgetTester tester, {Locale locale = const Locale('en')}) async {
    await pumpApp(tester, bundle, locale: locale);
    await openAbout(tester);
  }

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

    testWidgets('are all on the trust screen, in English and Portuguese', (tester) async {
      await openInfo(tester);
      for (final issue in en.knownIssues(bundle.quality, fmt)) {
        await scrollTo(tester, find.text(issue));
        expect(find.text(issue), findsOneWidget);
      }
      await openInfo(tester, locale: const Locale('pt'));
      for (final issue in pt.knownIssues(bundle.quality, const Fmt('pt'))) {
        await scrollTo(tester, find.text(issue));
        expect(find.text(issue), findsOneWidget);
      }
      expect(find.text(pt.issueSafestCount('1', '2')), findsOneWidget);
    });
  });

  group('trust screen', () {
    testWidgets('states the calibration plainly, with the EMS date and gap', (tester) async {
      await openInfo(tester);
      // On the trust screen and inside the colour guide's compare panel.
      expect(find.text(en.compareNotIndependent('0.80', '0.82', '0.68')), findsWidgets);
      expect(find.text(en.dateEmsGap('35.2')), findsOneWidget);
      expect(find.text(en.dateEmsImage('Jan 18, 2026')), findsOneWidget);
      await scrollTo(tester, find.text(en.scorePhysicsOnly));
      expect(find.text(en.scorePhysicsOnly), findsOneWidget);
    });

    testWidgets('shows every quality flag, the limits and the emergency line', (tester) async {
      await openInfo(tester);
      expect(find.text(en.warnNisarBeta), findsOneWidget);
      expect(find.text(en.warnDepotAssumed), findsOneWidget);
      expect(find.text(en.warnDepotAutoSelected), findsNothing);
      await scrollTo(tester, find.text(en.limitBoat));
      expect(find.text(en.limitRoads('99.0', '2')), findsOneWidget);
      expect(find.textContaining('(Only in English'), findsNothing);
      await scrollTo(tester, find.text(en.safetyEmergency));
      expect(find.text(en.safetyEmergency), findsOneWidget);
    });

    test('every limit in the current report has a translation', () {
      final limits = limitsOf(bundle.quality);
      expect(limits, hasLength(6));
      expect(limits.every((l) => l.topic != null), isTrue);
    });

    testWidgets('sources link only to addresses in the data', (tester) async {
      await openInfo(tester);
      await scrollTo(tester, find.text(en.notAffiliated));
      final links = bundle.quality.dataSources
          .fold<int>(0, (n, s) => n + (s.url != null ? 1 : 0) + (s.docs != null ? 1 : 0) + (s.doi != null ? 1 : 0));
      expect(find.byIcon(Icons.open_in_new_rounded), findsNWidgets(links));
      // WorldPop has a DOI and no website: its DOI is the link, through doi.org.
      final worldPop = bundle.quality.dataSources.firstWhere((s) => s.name.startsWith('WorldPop'));
      expect(worldPop.url, isNull);
      expect(find.widgetWithText(TextButton, en.sourceDoi(worldPop.doi!)), findsOneWidget);
      expect(doiUrl(worldPop.doi!), 'https://doi.org/10.5258/SOTON/WP00839');
    });

    test('a source without links shows only its name', () {
      const source = DataSource('Some source');
      expect(source.url ?? source.docs, isNull);
    });
  });

  group('depot_assumed', () {
    testWidgets('shows as a banner when the flag is true', (tester) async {
      final flagged = withFlags(bundle, {...bundle.manifest.qualityFlags, QualityFlag.depotAssumed});
      await pumpApp(tester, flagged);
      await openAbout(tester);
      expect(find.text(en.warnShortDepotAssumed), findsOneWidget);
    });

    testWidgets('is true in the current data and shows on About and Help first, not on the Map', (tester) async {
      expect(bundle.manifest.qualityFlags, contains(QualityFlag.depotAssumed));
      await pumpApp(tester, bundle);
      await openAbout(tester);
      expect(find.text(en.warnShortDepotAssumed), findsOneWidget, reason: 'About');
      await goBack(tester);
      // The Map keeps one short line and leaves the warnings to About.
      expect(find.text(en.warnShortDepotAssumed), findsNothing, reason: 'Map');
      await tester.tap(find.text(en.tabHelpFirst).last);
      await tester.pumpAndSettle();
      expect(find.text(en.warnShortDepotAssumed), findsOneWidget, reason: 'Missions');
    });

    testWidgets('does not show when the flag is false', (tester) async {
      await pumpApp(tester, withFlags(bundle, {...bundle.manifest.qualityFlags}..remove(QualityFlag.depotAssumed)));
      await openAbout(tester);
      expect(find.text(en.warnShortDepotAssumed), findsNothing);
    });
  });

  group('first run', () {
    testWidgets('intro, then a safety message that must be accepted', (tester) async {
      await pumpApp(tester, bundle, saved: {SettingsKeys.safetyAccepted: false});
      expect(find.byType(WelcomeScreen), findsOneWidget);
      expect(find.text(en.introTitle1), findsOneWidget);
      for (var i = 0; i < 3; i++) {
        await tester.tap(find.text(en.introNext));
        await tester.pumpAndSettle();
      }
      expect(find.text(en.safetyEmergency), findsOneWidget);
      final accept = find.widgetWithText(FilledButton, en.safetyAccept);
      expect(tester.widget<FilledButton>(accept).onPressed, isNull, reason: 'cannot accept without ticking');
      await tester.tap(find.text(en.safetyCheckbox));
      await tester.pumpAndSettle();
      await tester.tap(accept);
      await tester.pumpAndSettle();
      expect(find.byType(WelcomeScreen), findsNothing);
      expect(find.text(en.tabHelpFirst), findsOneWidget);
    });

    testWidgets('a deep link cannot skip the safety message', (tester) async {
      tester.binding.platformDispatcher.defaultRouteNameTestValue = '/care';
      addTearDown(tester.binding.platformDispatcher.clearDefaultRouteNameTestValue);
      await pumpApp(tester, bundle, saved: {SettingsKeys.safetyAccepted: false});
      expect(find.byType(WelcomeScreen), findsOneWidget);
    });

    testWidgets('once accepted, the app opens directly and Info can show it again', (tester) async {
      await openInfo(tester);
      await scrollTo(tester, find.text(en.readIntroAgain));
      await tester.tap(find.text(en.readIntroAgain));
      await tester.pumpAndSettle();
      expect(find.byType(WelcomeScreen), findsOneWidget);
      for (var i = 0; i < 3; i++) {
        await tester.tap(find.text(en.introNext));
        await tester.pumpAndSettle();
      }
      expect(find.text(en.safetyCheckbox), findsNothing);
      await tester.tap(find.text(en.close));
      await tester.pumpAndSettle();
      expect(find.byType(WelcomeScreen), findsNothing);
      expect(find.text(en.readIntroAgain), findsOneWidget);
    });
  });

  testWidgets('no overflow at 200% on the trust screen and the intro', (tester) async {
    for (final locale in const [Locale('en'), Locale('pt')]) {
      final l = locale.languageCode == 'en' ? en : pt;
      await pumpApp(tester, bundle, locale: locale, textScale: 2.0);
      await openAbout(tester);
      expect(tester.takeException(), isNull);
      await pumpApp(tester, bundle, locale: locale, textScale: 2.0, saved: {SettingsKeys.safetyAccepted: false});
      for (var i = 0; i < 3; i++) {
        await tester.tap(find.text(l.introNext));
        await tester.pumpAndSettle();
      }
      expect(tester.takeException(), isNull);
    }
  });
}
