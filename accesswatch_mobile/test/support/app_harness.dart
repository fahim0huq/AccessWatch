import 'package:accesswatch_mobile/data/bundle_repository.dart';
import 'package:accesswatch_mobile/main.dart';
import 'package:accesswatch_mobile/data/routing.dart';
import 'package:accesswatch_mobile/state/care_state.dart';
import 'package:accesswatch_mobile/state/connectivity.dart';
import 'package:accesswatch_mobile/state/map_state.dart';
import 'package:accesswatch_mobile/state/providers.dart';
import 'package:accesswatch_mobile/state/settings_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' show TileProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pumps the real app on the real bundle: phone width, tall enough that the
/// scrolling lists build every row, so finders can see them.
/// Scrolls the first list until [finder] is built and on screen.
Future<void> scrollTo(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(finder, 400, scrollable: find.byType(Scrollable).first);
  await tester.pumpAndSettle();
}

Future<void> pumpApp(
  WidgetTester tester,
  AppBundle bundle, {
  Locale locale = const Locale('en'),
  double textScale = 1.0,
  double width = 390,
  double height = 5000,
  TileProvider? tiles,
  List<Override> overrides = const [],
  Map<String, Object> saved = const {},
  bool online = true,
}) async {
  // A fresh tree, so a second pump in one test starts the app anew.
  await tester.pumpWidget(const SizedBox());
  SharedPreferences.setMockInitialValues({SettingsKeys.safetyAccepted: true, ...saved});
  final prefs = await SharedPreferences.getInstance();
  tester.view.physicalSize = Size(width, height);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(ProviderScope(
    overrides: [
      bundleProvider.overrideWith((ref) async => bundle),
      sharedPreferencesProvider.overrideWithValue(prefs),
      onlineProvider.overrideWith((ref) => Stream.value(online)),
      clockProvider.overrideWithValue(() => DateTime.utc(2026, 11, 8, 12)),
      // Routing in the same isolate: the fake test clock cannot wait for another one.
      careRouteRunnerProvider.overrideWithValue((request) async => careRoutes(request)),
      showBaseTilesProvider.overrideWithValue(tiles != null),
      mapTileProvider.overrideWithValue(tiles),
      localeProvider.overrideWith((ref) => locale),
      textScaleProvider.overrideWith((ref) => textScale),
      ...overrides,
    ],
    child: const AccessWatchApp(),
  ));
  await tester.pumpAndSettle();
}
