import 'package:accesswatch_mobile/data/bundle_repository.dart';
import 'package:accesswatch_mobile/main.dart';
import 'package:accesswatch_mobile/state/map_state.dart';
import 'package:accesswatch_mobile/state/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' show TileProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pumps the real app on the real bundle: phone width, tall enough that the
/// scrolling lists build every row, so finders can see them.
Future<void> pumpApp(
  WidgetTester tester,
  AppBundle bundle, {
  Locale locale = const Locale('en'),
  double textScale = 1.0,
  double width = 390,
  double height = 2400,
  TileProvider? tiles,
}) async {
  tester.view.physicalSize = Size(width, height);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(ProviderScope(
    overrides: [
      bundleProvider.overrideWith((ref) async => bundle),
      showBaseTilesProvider.overrideWithValue(tiles != null),
      mapTileProvider.overrideWithValue(tiles),
      localeProvider.overrideWith((ref) => locale),
      textScaleProvider.overrideWith((ref) => textScale),
    ],
    child: const AccessWatchApp(),
  ));
  await tester.pumpAndSettle();
}
