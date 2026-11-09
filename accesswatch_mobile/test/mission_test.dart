import 'dart:convert';
import 'dart:io';

import 'package:accesswatch_mobile/data/bundle_repository.dart';
import 'package:accesswatch_mobile/data/mission_ranking.dart';
import 'package:accesswatch_mobile/data/models/enums.dart';
import 'package:accesswatch_mobile/data/verify_notes.dart';
import 'package:accesswatch_mobile/l10n/app_localizations.dart';
import 'package:accesswatch_mobile/l10n/app_localizations_en.dart';
import 'package:accesswatch_mobile/l10n/app_localizations_pt.dart';
import 'package:accesswatch_mobile/state/mission_state.dart';
import 'package:accesswatch_mobile/utils/labels.dart';
import 'package:accesswatch_mobile/utils/mission_text.dart';
import 'package:accesswatch_mobile/widgets/help/area_card.dart';
import 'package:accesswatch_mobile/widgets/ranking_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_harness.dart';
import 'support/bundle_variants.dart';

void main() {
  late AppBundle bundle;
  final AppLocalizations en = AppLocalizationsEn();
  final AppLocalizations pt = AppLocalizationsPt();

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    bundle = await BundleRepository().load();
  });

  Future<void> openMissions(WidgetTester tester, {List<Override> overrides = const [], Locale locale = const Locale('en')}) async {
    await pumpApp(tester, bundle, overrides: overrides, locale: locale);
    final l = locale.languageCode == 'en' ? en : pt;
    await tester.tap(find.text(l.tabHelpFirst).last);
    await tester.pumpAndSettle();
  }

  Future<void> openFirstMission(WidgetTester tester) async {
    await tester.tap(find.byType(AreaCard).first);
    await tester.pumpAndSettle();
  }

  /// The priority sliders, in About.
  Future<void> openRanking(WidgetTester tester) async {
    await openAbout(tester);
    await scrollTo(tester, find.byType(RankingPanel));
  }

  List<String> order(WidgetTester tester) =>
      tester.widgetList<AreaCard>(find.byType(AreaCard)).map((c) => c.ranked.mission.pocketId).toList();

  group('ranking', () {
    test('the published weights give back the published ranking exactly', () {
      final ranked = rankMissions(bundle.missions, const PriorityWeights());
      expect(ranked.map((r) => r.rank), ranked.map((r) => r.mission.rank));
      for (final r in ranked) {
        // The score reproduces the data's priority_score, within its rounding.
        expect(r.score, closeTo(r.mission.priorityScore, 0.0006));
      }
    });

    test('more weight on people moves the larger difficult pocket above smaller boat pockets', () {
      final ranked = rankMissions(bundle.missions, const PriorityWeights(people: 2));
      final ids = ranked.map((r) => r.mission.pocketId).toList();
      expect(ids.first, 'P01');
      expect(ids.indexOf('P02'), lessThan(ids.indexOf('P08')));
    });

    test('a weight of zero drops that term', () {
      const w = PriorityWeights(people: 0, serviceLoss: 0, difficulty: 0);
      expect(rankMissions(bundle.missions, w).every((r) => r.score == 1), isTrue);
      // All tied, so the published order holds.
      expect(rankMissions(bundle.missions, w).map((r) => r.rank), bundle.missions.map((m) => m.rank));
    });

    test('the data has a dominant pocket and, since unrounded pop_norm, no tied terms', () {
      final (top, share) = largestPocket(bundle.missions)!;
      expect(top.pocketId, 'P01');
      expect(share, greaterThan(dominantPocketShare));
      expect(hasTiedTerms(bundle.missions), isFalse);
    });

    test('P05, P06 and P08 now have distinct scores, but no weights can reorder them', () {
      // They share service-loss and difficulty terms, so only people separates them.
      List<String> trio(PriorityWeights w) => [
            for (final r in rankMissions(bundle.missions, w))
              if (const {'P05', 'P06', 'P08'}.contains(r.mission.pocketId)) r.mission.pocketId,
          ];
      expect(trio(const PriorityWeights()), ['P05', 'P06', 'P08']);
      for (final people in [0.25, 0.5, 1.0, 1.5, 2.0]) {
        for (final other in [0.0, 1.0, 2.0]) {
          expect(trio(PriorityWeights(people: people, serviceLoss: other, difficulty: other)), ['P05', 'P06', 'P08']);
        }
      }
      // With no weight on people the three tie and keep the published order.
      final tied = rankMissions(bundle.missions, const PriorityWeights(people: 0));
      final scores = {for (final r in tied) if (const {'P05', 'P06', 'P08'}.contains(r.mission.pocketId)) r.score};
      expect(scores, hasLength(1));
    });
  });

  group('verify notes', () {
    // Each kind, matched to the wording of the notebook's own notes in the source file.
    const sourceWords = {
      VerifyNoteKind.bridges: 'bridge(s) on the route',
      VerifyNoteKind.lowConfidence: 'Low confidence',
      VerifyNoteKind.boatRoute: 'boat route follows',
      VerifyNoteKind.unstable: 'Sensitivity test',
      VerifyNoteKind.shortestDeep: 'crosses deep water',
      VerifyNoteKind.depotAutoSelected: 'AUTO-SELECTED',
      VerifyNoteKind.estimates: 'Depth classes are estimates',
    };

    test('match the source notes for every card, built only from the fields', () {
      final source = jsonDecode(File('../data_sample/notebook_outputs/mission_cards.json').readAsStringSync());
      for (final card in source['cards'] as List) {
        final notes = (card['verify_notes'] as List).cast<String>();
        final mission = bundle.missions.firstWhere((m) => m.pocketId == card['pocket_id']);
        final fromSource = {
          for (final e in sourceWords.entries)
            if (notes.any((n) => n.contains(e.value))) e.key,
        };
        expect(fromSource, hasLength(notes.length), reason: 'a source note has no kind: $notes');
        expect(verifyNotesFor(mission).map((n) => n.kind).toSet(), fromSource, reason: mission.pocketId);
      }
    });

    testWidgets('are a checklist whose ticks survive leaving the page', (tester) async {
      await openMissions(tester);
      await openFirstMission(tester);
      final mission = bundle.missions.first;
      final notes = verifyNotesFor(mission);
      expect(find.byType(CheckboxListTile), findsNWidgets(notes.length));
      await tester.tap(find.byType(CheckboxListTile).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text(en.back));
      await tester.pumpAndSettle();
      await openFirstMission(tester);
      final first = tester.widget<CheckboxListTile>(find.byType(CheckboxListTile).first);
      expect(first.value, isTrue);
    });
  });

  group('sliders', () {
    testWidgets('re-rank Help first, say so there, and reset', (tester) async {
      await openMissions(tester);
      final published = order(tester);
      expect(find.text(en.customWeightsNote), findsNothing);
      await openRanking(tester);
      final sliders = find.descendant(of: find.byType(RankingPanel), matching: find.byType(Slider));
      expect(sliders, findsNWidgets(3));

      // Full weight on people: drag the first slider to its right end.
      tester.widget<Slider>(sliders.first).onChanged!(PriorityWeights.max);
      await tester.pumpAndSettle();
      await goBack(tester);
      final changed = order(tester);
      expect(changed, isNot(published));
      expect(changed.first, 'P01');
      expect(find.text(en.customWeightsNote), findsOneWidget);

      await openRanking(tester);
      await tester.tap(find.text(en.rankingReset));
      await tester.pumpAndSettle();
      await goBack(tester);
      expect(order(tester), published);
      expect(find.text(en.customWeightsNote), findsNothing);
    });

    testWidgets('show the choice and dominance notes; tie and depot notes follow the data', (tester) async {
      await openMissions(tester);
      await openRanking(tester);
      expect(find.text(en.rankingChoiceNote), findsOneWidget);
      expect(find.text(en.rankingDominated('P01', '98')), findsOneWidget);
      // The new data has no tied terms, and its depot is assumed rather than auto-selected.
      expect(find.text(en.rankingTies), hasTiedTerms(bundle.missions) ? findsOneWidget : findsNothing);
      expect(bundle.manifest.qualityFlags, contains(QualityFlag.depotAssumed));
      expect(find.text(en.rankingDepotAssumedNote), findsOneWidget);
      expect(find.text(en.rankingDepotNote), findsNothing);
    });

    testWidgets('keep the notes when folded away', (tester) async {
      await openMissions(tester);
      await openRanking(tester);
      await tester.tap(find.byTooltip(en.rankingHide));
      await tester.pumpAndSettle();
      expect(find.descendant(of: find.byType(RankingPanel), matching: find.byType(Slider)), findsNothing);
      expect(find.text(en.rankingDominated('P01', '98')), findsOneWidget);
    });
  });

  group('detail page', () {
    testWidgets('shows service access, routes and the priority terms', (tester) async {
      await openMissions(tester);
      await openFirstMission(tester);
      expect(find.text(en.serviceAccessTitle), findsOneWidget);
      expect(find.textContaining(en.accessNo), findsWidgets);
      expect(find.text(en.routeComparison), findsOneWidget);
      expect(find.text(en.priorityTermsTitle), findsOneWidget);
    });

    testWidgets('Show on map goes to that pocket', (tester) async {
      await openMissions(tester);
      await openFirstMission(tester);
      await tester.tap(find.text(en.viewOnMap));
      await tester.pumpAndSettle();
      expect(find.byType(FlutterMap), findsOneWidget);
    });

    testWidgets('an unknown mission link does not crash', (tester) async {
      tester.binding.platformDispatcher.defaultRouteNameTestValue = '/help/P99';
      addTearDown(tester.binding.platformDispatcher.clearDefaultRouteNameTestValue);
      await pumpApp(tester, bundle);
      expect(find.text(en.missionNotFound('P99')), findsOneWidget);
    });
  });

  group('share alert', () {
    Future<List<String>> shareFirst(WidgetTester tester, AppLocalizations l, Locale locale) async {
      final sent = <String>[];
      await openMissions(tester, locale: locale, overrides: [
        alertSharerProvider.overrideWithValue((text) async => sent.add(text)),
      ]);
      await openFirstMission(tester);
      await tester.tap(find.text(l.shareAlert));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, l.shareAlert));
      await tester.pumpAndSettle();
      return sent;
    }

    testWidgets('is built in English from the fields', (tester) async {
      final sent = await shareFirst(tester, en, const Locale('en'));
      expect(sent, hasLength(1));
      expect(sent.single, allOf(contains('#1 P01'), contains('West of Guija'), contains('12,853'), contains('BOAT (0.56 km by water)')));
      expect(sent.single, allOf(contains('Jan 17, 2026'), contains(en.alertVerify)));
      // The depot is assumed in the new data, so the alert says so (not "auto-selected").
      expect(sent.single, contains(en.alertDepotAssumed));
      expect(sent.single, isNot(contains(en.alertDepot)));
      expect(sent.single, isNot(contains(en.alertCustomWeights)));
    });

    testWidgets('is built in Portuguese, with no notebook English', (tester) async {
      final sent = await shareFirst(tester, pt, const Locale('pt'));
      expect(sent.single, allOf(contains('A oeste de Guija'), contains('12.853'), contains('BARCO (0,56 km por água)'), contains(pt.alertVerify)));
      final card = (jsonDecode(File('../data_sample/notebook_outputs/mission_cards.json').readAsStringSync())['cards'] as List).first;
      expect(sent.single, isNot(contains(card['alert_text'] as String)));
      for (final english in const ['people', 'Route', 'risk', 'VERIFY']) {
        expect(sent.single, isNot(contains(english)));
      }
    });

    test('says the depot is auto-selected when the flag says so, whatever the card', () {
      final ranked = rankMissions(bundle.missions, const PriorityWeights()).first;
      final auto = withFlags(bundle, {...bundle.manifest.qualityFlags, QualityFlag.depotAutoSelected});
      final text = en.alertText(ranked, const PriorityWeights(), auto.manifest, const Fmt('en'));
      expect(text, contains(en.alertDepot));
      expect(text, isNot(contains(en.alertDepotAssumed)));
    });

    test('says when the rank uses custom weights', () {
      const weights = PriorityWeights(people: 2);
      final ranked = rankMissions(bundle.missions, weights).first;
      final text = en.alertText(ranked, weights, bundle.manifest, const Fmt('en'));
      expect(text, contains(en.alertCustomWeights));
    });
  });

  testWidgets('no overflow at 200% on the list and the page, in both languages', (tester) async {
    for (final (locale, l) in [(const Locale('en'), en), (const Locale('pt'), pt)]) {
      await pumpApp(tester, bundle, locale: locale, textScale: 2.0);
      await tester.tap(find.text(l.tabHelpFirst).last);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(AreaCard).first);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    }
  });
}
