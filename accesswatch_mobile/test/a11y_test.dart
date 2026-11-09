// Accessibility checks on every screen: 48 dp tap targets, a label on every tap
// target, text contrast, and no overflow at 200% text in both languages.
import 'package:accesswatch_mobile/data/bundle_repository.dart';
import 'package:accesswatch_mobile/l10n/app_localizations.dart';
import 'package:accesswatch_mobile/l10n/app_localizations_en.dart';
import 'package:accesswatch_mobile/l10n/app_localizations_pt.dart';
import 'package:accesswatch_mobile/state/location.dart';
import 'package:accesswatch_mobile/screens/missions_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'support/app_harness.dart';

void main() {
  late AppBundle bundle;
  final AppLocalizations en = AppLocalizationsEn();
  final AppLocalizations pt = AppLocalizationsPt();

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    bundle = await BundleRepository().load();
  });

  Future<void> checkGuidelines(WidgetTester tester, String where) async {
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline), reason: '$where: tap targets');
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline), reason: '$where: labels');
    await expectLater(tester, meetsGuideline(textContrastGuideline), reason: '$where: contrast');
  }

  for (final (locale, l) in [(const Locale('en'), en), (const Locale('pt'), pt)]) {
    final lang = locale.languageCode;
    testWidgets('every tab meets the guidelines ($lang)', (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpApp(tester, bundle, locale: locale, height: 844);
      for (final tab in [l.tabMap, l.tabHelpFirst, l.tabFindCare]) {
        await tester.tap(find.text(tab).last);
        await tester.pumpAndSettle();
        await checkGuidelines(tester, '$lang $tab');
      }
      await openAbout(tester);
      await checkGuidelines(tester, '$lang about');
      semantics.dispose();
    });

    testWidgets('mission page and Care with a position meet the guidelines ($lang)', (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpApp(tester, bundle, locale: locale, height: 844);
      await tester.tap(find.text(l.tabHelpFirst).last);
      await tester.pumpAndSettle();
      GoRouter.of(tester.element(find.byType(MissionsScreen))).go('/help/P01');
      await tester.pumpAndSettle();
      await checkGuidelines(tester, '$lang mission page');
      await tester.tap(find.text(l.tabFindCare).last);
      await tester.pumpAndSettle();
      final container = ProviderScope.containerOf(tester.element(find.byType(Navigator).first));
      container.read(locationControllerProvider.notifier).setTestPosition(bundle.services.first.point);
      await tester.pumpAndSettle();
      await checkGuidelines(tester, '$lang care with routes');
      semantics.dispose();
    });

    testWidgets('no overflow at 200% on any tab ($lang)', (tester) async {
      await pumpApp(tester, bundle, locale: locale, height: 844, textScale: 2.0);
      for (final tab in [l.tabMap, l.tabHelpFirst, l.tabFindCare]) {
        await tester.tap(find.text(tab).last);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: '$lang $tab at 200%');
      }
      await openAbout(tester);
      expect(tester.takeException(), isNull, reason: '$lang about at 200%');
    });
  }
}
