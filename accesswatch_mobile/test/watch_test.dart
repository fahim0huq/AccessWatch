// Watch an area: one event with data, an empty live list, and picking a box on the map.
import 'package:accesswatch_mobile/data/bundle_repository.dart';
import 'package:accesswatch_mobile/data/models/watch_event.dart';
import 'package:accesswatch_mobile/l10n/app_localizations.dart';
import 'package:accesswatch_mobile/l10n/app_localizations_en.dart';
import 'package:accesswatch_mobile/l10n/app_localizations_pt.dart';
import 'package:accesswatch_mobile/state/watch_state.dart';
import 'package:accesswatch_mobile/widgets/map/area_select.dart';
import 'package:accesswatch_mobile/widgets/map/map_overlay.dart';
import 'package:accesswatch_mobile/widgets/map/watching_pill.dart';
import 'package:accesswatch_mobile/widgets/ui/floating_nav_bar.dart';
import 'package:accesswatch_mobile/widgets/watch/watch_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart' show LatLng;

import 'support/app_harness.dart';

void main() {
  late AppBundle bundle;
  final AppLocalizations en = AppLocalizationsEn();
  final AppLocalizations pt = AppLocalizationsPt();
  const nameEn = 'Chókwè and Guija, Mozambique';

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    bundle = await BundleRepository().load();
  });

  Future<void> openWatch(WidgetTester tester) async {
    await tester.tap(find.byKey(const ValueKey('nav-watch')));
    await tester.pumpAndSettle();
  }

  ProviderContainer container(WidgetTester tester) =>
      ProviderScope.containerOf(tester.element(find.byType(MaterialApp, skipOffstage: false).first));

  Future<void> startSelecting(WidgetTester tester, AppLocalizations l) async {
    await openWatch(tester);
    await tester.ensureVisible(find.text(l.watchSelectOnMap));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l.watchSelectOnMap));
    await tester.pumpAndSettle();
  }

  test('the local list holds one event, a flood, with data from the bundle', () {
    final events = parseWatchEvents({
      'events': [
        {
          'id': 'a',
          'kind': 'flood',
          'data': 'bundle',
          'name': {'en': nameEn, 'pt': 'Chókwè e Guija, Moçambique'},
        },
      ],
    });
    expect(filterEvents(events, EventKind.flood, 'chokwe'), hasLength(1));
    expect(filterEvents(events, EventKind.flood, 'Moçambique'), hasLength(1));
    expect(filterEvents(events, EventKind.cycloneFlooding, ''), isEmpty);
    expect(filterEvents(events, EventKind.flood, 'Beira'), isEmpty);
  });

  testWidgets('Available now lists exactly one event, with the bundle dates; Live events is empty', (tester) async {
    await pumpApp(tester, bundle, height: 1600);
    await openWatch(tester);
    expect(find.byType(EventCard), findsOneWidget);
    final card = find.byType(EventCard);
    expect(find.descendant(of: card, matching: find.text(nameEn)), findsOneWidget);
    expect(find.descendant(of: card, matching: find.text(en.watchKindFlood)), findsOneWidget);
    expect(
      find.descendant(of: card, matching: find.text(en.eventScenes('Jan 5, 2026', 'Jan 17, 2026'))),
      findsOneWidget,
    );
    expect(find.descendant(of: card, matching: find.text(en.dataAvailable)), findsOneWidget);
    expect(find.text(en.liveEventsEmpty), findsOneWidget);
    expect(find.byType(LiveEventsEmpty), findsOneWidget);
  });

  testWidgets('Cyclone flooding has no event yet; search filters the local list', (tester) async {
    await pumpApp(tester, bundle, height: 1600);
    await openWatch(tester);
    await tester.tap(find.text(en.watchKindCyclone));
    await tester.pumpAndSettle();
    expect(find.byType(EventCard), findsNothing);
    expect(find.text(en.watchNoneOfKind), findsOneWidget);
    await tester.tap(find.text(en.watchKindFlood));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('watch-search')), 'chokwe');
    await tester.pumpAndSettle();
    expect(find.byType(EventCard), findsOneWidget);
    await tester.enterText(find.byKey(const ValueKey('watch-search')), 'Beira');
    await tester.pumpAndSettle();
    expect(find.byType(EventCard), findsNothing);
    expect(find.text(en.watchSearchNone('Beira')), findsOneWidget);
  });

  testWidgets('the Map pill names the watched event and date, and opens Watch', (tester) async {
    await pumpApp(tester, bundle, height: 844);
    expect(find.text(en.watchingPill(nameEn, 'Jan 17, 2026')), findsOneWidget);
    await tester.tap(find.byType(WatchingPill));
    await tester.pumpAndSettle();
    expect(find.byType(EventCard), findsOneWidget);
  });

  testWidgets('a box tapped inside the flood area offers Watch this area', (tester) async {
    await pumpApp(tester, bundle, height: 844);
    await startSelecting(tester, en);
    expect(find.byType(AreaSelectOverlay), findsOneWidget);
    expect(find.byType(FloatingNavBar), findsNothing);
    expect(find.byType(MapSummaryCard), findsNothing);
    expect(find.text(en.selectHint), findsOneWidget);
    await tester.tapAt(tester.getCenter(find.byKey(const ValueKey('select-surface'))));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('selection-has-data')), findsOneWidget);
    expect(find.text(en.selectionHasData(nameEn)), findsOneWidget);
    await tester.tap(find.text(en.watchThisArea));
    await tester.pumpAndSettle();
    expect(find.byType(AreaSelectOverlay), findsNothing);
    expect(find.byType(FloatingNavBar), findsOneWidget);
  });

  testWidgets('Cancel with no box goes back to Watch with nothing selected', (tester) async {
    await pumpApp(tester, bundle, height: 844);
    await startSelecting(tester, en);
    expect(find.text(en.selectCancel), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('select-close')));
    await tester.pumpAndSettle();
    expect(find.byType(AreaSelectOverlay), findsNothing);
    expect(find.byType(EventCard), findsOneWidget);
    expect(find.byType(SelectionResultCard), findsOneWidget);
    expect(find.byKey(const ValueKey('selection-has-data')), findsNothing);
    expect(find.byKey(const ValueKey('selection-no-data')), findsNothing);
  });

  testWidgets('a box drawn by dragging is kept; Done shows it on the Watch screen', (tester) async {
    await pumpApp(tester, bundle, height: 844);
    await startSelecting(tester, en);
    final surface = find.byKey(const ValueKey('select-surface'));
    await tester.timedDrag(surface, const Offset(120, 160), const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    final box = container(tester).read(watchSelectionProvider);
    expect(box, isNotNull);
    expect(box!.north, greaterThan(box.south));
    expect(find.byKey(const ValueKey('selection-has-data')), findsOneWidget);
    expect(find.text(en.selectDone), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('select-close')));
    await tester.pumpAndSettle();
    expect(find.byType(AreaSelectOverlay), findsNothing);
    expect(container(tester).read(watchSelectionProvider), isNotNull);
    expect(find.byKey(const ValueKey('selection-has-data')), findsOneWidget);
    expect(find.byType(EventCard), findsOneWidget);
  });

  testWidgets('a box outside the area says there is no data yet and offers the event', (tester) async {
    await pumpApp(tester, bundle, height: 844);
    await startSelecting(tester, en);
    // Near Beira, far from the bundled flood.
    container(tester).read(watchSelectionProvider.notifier).state = LatLngBounds(
      const LatLng(-19.9, 34.8),
      const LatLng(-19.7, 35.0),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('selection-no-data')), findsOneWidget);
    expect(find.text(en.selectionNoData(nameEn)), findsOneWidget);
    await tester.tap(find.text(en.goToEvent(nameEn)));
    await tester.pumpAndSettle();
    expect(find.byType(AreaSelectOverlay), findsNothing);
    expect(find.text(en.watchingPill(nameEn, 'Jan 17, 2026')), findsOneWidget);
  });

  for (final (locale, l, name) in [
    (const Locale('en'), en, nameEn),
    (const Locale('pt'), pt, 'Chókwè e Guija, Moçambique'),
  ]) {
    testWidgets('Watch and selection meet the guidelines, no overflow at 200% (${locale.languageCode})', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await pumpApp(tester, bundle, locale: locale, height: 844);
      await openWatch(tester);
      expect(find.text(l.watchTitle), findsWidgets);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      semantics.dispose();
      await pumpApp(tester, bundle, locale: locale, height: 844, textScale: 2.0);
      await openWatch(tester);
      await scrollTo(tester, find.text(l.liveEventsEmpty));
      expect(tester.takeException(), isNull);
      await tester.tap(find.byKey(const ValueKey('nav-map')));
      await tester.pumpAndSettle();
      await startSelecting(tester, l);
      container(tester).read(watchSelectionProvider.notifier).state = LatLngBounds(
        const LatLng(-19.9, 34.8),
        const LatLng(-19.7, 35.0),
      );
      await tester.pumpAndSettle();
      expect(find.text(l.selectionNoData(name)), findsOneWidget);
      expect(tester.takeException(), isNull);
      // With a selection, the Watch screen shows the same card.
      await tester.tap(find.byKey(const ValueKey('select-close')));
      await tester.pumpAndSettle();
      await scrollTo(tester, find.byKey(const ValueKey('selection-no-data')));
      expect(tester.takeException(), isNull);
    });
  }
}
