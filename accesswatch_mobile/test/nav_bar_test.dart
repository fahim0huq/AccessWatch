// The bar's words with the real Inter font: never cut, in both languages, at 100% and 200%.
import 'package:accesswatch_mobile/data/bundle_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_harness.dart';

void main() {
  late AppBundle bundle;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    bundle = await BundleRepository().load();
    // The test font's square glyphs are far wider than Inter's; measure with the real one.
    final inter = FontLoader('Inter');
    for (final file in ['Regular', 'Medium', 'Bold']) {
      inter.addFont(rootBundle.load('assets/fonts/Inter-$file.ttf'));
    }
    await inter.load();
  });

  for (final locale in [const Locale('en'), const Locale('pt')]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('no bar label is cut (${locale.languageCode}, ${(scale * 100).round()}%)', (tester) async {
        await pumpApp(tester, bundle, locale: locale, height: 844, textScale: scale);
        for (final slot in ['map', 'help', 'watch', 'care', 'about']) {
          final paragraph = tester.renderObject<RenderParagraph>(
            find.descendant(of: find.byKey(ValueKey('nav-$slot')), matching: find.byType(RichText)).last,
          );
          expect(paragraph.didExceedMaxLines, isFalse, reason: slot);
          // Still readable: never shrunk below 60%.
          expect(paragraph.textScaler.scale(10), greaterThanOrEqualTo(6), reason: slot);
        }
      });
    }
  }
}
