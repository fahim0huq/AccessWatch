import 'package:accesswatch_mobile/data/bundle_repository.dart';
import 'package:accesswatch_mobile/main.dart';
import 'package:accesswatch_mobile/state/providers.dart';
import 'package:flutter/material.dart';
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
}) async {
  tester.view.physicalSize = Size(width, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(ProviderScope(
    overrides: [
      bundleProvider.overrideWith((ref) async => bundle),
      localeProvider.overrideWith((ref) => locale),
      textScaleProvider.overrideWith((ref) => textScale),
    ],
    child: const AccessWatchApp(),
  ));
  await tester.pumpAndSettle();
}
