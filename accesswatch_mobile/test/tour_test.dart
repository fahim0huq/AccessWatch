// The first-run tour: once after the safety screen, Next/Back/Skip, replay from
// About, missing targets skipped, both languages and 200% text.
import 'package:accesswatch_mobile/data/bundle_repository.dart';
import 'package:accesswatch_mobile/l10n/app_localizations.dart';
import 'package:accesswatch_mobile/l10n/app_localizations_en.dart';
import 'package:accesswatch_mobile/l10n/app_localizations_pt.dart';
import 'package:accesswatch_mobile/state/map_state.dart';
import 'package:accesswatch_mobile/state/settings_store.dart';
import 'package:accesswatch_mobile/state/tour_state.dart';
import 'package:accesswatch_mobile/widgets/tour/tour_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/app_harness.dart';

void main() {
  late AppBundle bundle;
  final AppLocalizations en = AppLocalizationsEn();
  final AppLocalizations pt = AppLocalizationsPt();
  const fresh = {SettingsKeys.safetyAccepted: false, SettingsKeys.tourSeen: false};

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    bundle = await BundleRepository().load();
  });

  final card = find.byType(TourCard);

  int? step(WidgetTester tester) => card.evaluate().isEmpty ? null : tester.widget<TourCard>(card).step;

  ProviderContainer container(WidgetTester tester) =>
      ProviderScope.containerOf(tester.element(find.byType(MaterialApp)));

  Future<void> press(WidgetTester tester, String key) async {
    await tester.tap(find.byKey(ValueKey(key)));
    await tester.pumpAndSettle();
  }

  Future<void> acceptSafety(WidgetTester tester, AppLocalizations l) async {
    await tester.tap(find.text(l.safetyAccept));
    await tester.pumpAndSettle();
  }

  testWidgets('shown once, right after the safety screen; the flag is saved', (tester) async {
    await pumpApp(tester, bundle, height: 844, saved: fresh);
    expect(card, findsNothing);
    await acceptSafety(tester, en);
    expect(step(tester), 0);
    expect(find.text(en.tourStepOf('1', '5')), findsOneWidget);
    expect(find.text(en.tourMapTitle), findsOneWidget);
    expect((await SharedPreferences.getInstance()).getBool(SettingsKeys.tourSeen), isTrue);
    // Started again with the saved settings: no tour.
    await pumpApp(tester, bundle, height: 844, saved: {SettingsKeys.safetyAccepted: true, SettingsKeys.tourSeen: true});
    expect(card, findsNothing);
  });

  testWidgets('Next walks the five steps over their controls; Back goes back; Done closes', (tester) async {
    await pumpApp(tester, bundle, height: 844, saved: fresh);
    await acceptSafety(tester, en);
    final titles = [en.tourMapTitle, en.tourChipsTitle, en.tabHelpFirst, en.tourWatchTitle, en.tabFindCare];
    for (var i = 0; i < tourStepCount; i++) {
      expect(step(tester), i);
      expect(find.text(en.tourStepOf('${i + 1}', '5')), findsOneWidget);
      expect(find.descendant(of: card, matching: find.text(titles[i])), findsOneWidget);
      expect(find.byKey(const ValueKey('tour-back')), i == 0 ? findsNothing : findsOneWidget);
      if (i == 2) {
        await press(tester, 'tour-back');
        expect(step(tester), 1);
        await press(tester, 'tour-next');
      }
      if (i < tourStepCount - 1) await press(tester, 'tour-next');
    }
    expect(find.text(en.tourDone), findsOneWidget);
    await press(tester, 'tour-next');
    expect(card, findsNothing);
    expect(container(tester).read(tourProvider).active, isFalse);
  });

  testWidgets('Skip closes the tour at once, and the map works again', (tester) async {
    await pumpApp(tester, bundle, height: 844, saved: fresh);
    await acceptSafety(tester, en);
    await press(tester, 'tour-skip');
    expect(card, findsNothing);
    await tester.tap(find.byKey(const ValueKey('layer-chip-routes')));
    await tester.pumpAndSettle();
    expect(container(tester).read(mapLayersProvider), contains(MapLayer.routes));
  });

  testWidgets('Take the tour again in About replays it on the Map', (tester) async {
    await pumpApp(tester, bundle, height: 1600);
    expect(card, findsNothing);
    await openAbout(tester);
    final again = find.byKey(const ValueKey('tour-again'));
    await scrollTo(tester, again);
    await tester.tap(again);
    await tester.pumpAndSettle();
    expect(step(tester), 0);
    expect(find.text(en.tourMapTitle), findsOneWidget);
  });

  testWidgets('a step whose control is missing is skipped', (tester) async {
    await pumpApp(tester, bundle, height: 844);
    // In full screen the summary card, the keyed chip row, the pill and the bar are gone.
    container(tester).read(mapFullScreenProvider.notifier).state = true;
    await tester.pumpAndSettle();
    container(tester).read(tourProvider.notifier).start();
    await tester.pumpAndSettle();
    expect(card, findsNothing);
    expect(container(tester).read(tourProvider).active, isFalse);
    // Back on the normal Map, a full tour runs.
    container(tester).read(mapFullScreenProvider.notifier).state = false;
    container(tester).read(tourProvider.notifier).start();
    await tester.pumpAndSettle();
    expect(step(tester), 0);
  });

  for (final (locale, l) in [(const Locale('en'), en), (const Locale('pt'), pt)]) {
    testWidgets('every step meets the guidelines and fits at 200% text (${locale.languageCode})', (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpApp(tester, bundle, locale: locale, height: 844, saved: fresh);
      await acceptSafety(tester, l);
      expect(find.text(l.tourStepOf('1', '5')), findsOneWidget);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      semantics.dispose();
      await pumpApp(tester, bundle, locale: locale, height: 844, textScale: 2.0, saved: fresh);
      await acceptSafety(tester, l);
      for (var i = 0; i < tourStepCount; i++) {
        expect(step(tester), i);
        expect(tester.takeException(), isNull, reason: 'step ${i + 1}');
        final rect = tester.getRect(card);
        expect(rect.top, greaterThanOrEqualTo(0), reason: 'step ${i + 1}');
        expect(rect.bottom, lessThanOrEqualTo(844), reason: 'step ${i + 1}');
        // Skip is always on screen.
        final skip = tester.getRect(find.byKey(const ValueKey('tour-skip')));
        expect(skip.bottom, lessThanOrEqualTo(844), reason: 'step ${i + 1}');
        expect(skip.top, greaterThanOrEqualTo(0), reason: 'step ${i + 1}');
        await press(tester, 'tour-next');
      }
      expect(card, findsNothing);
    });
  }
}
