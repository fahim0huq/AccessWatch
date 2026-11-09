// The redesign's promises: three tabs, a calm Map, the same alert text, and
// every screen at 200% text in both languages.
import 'package:accesswatch_mobile/data/bundle_repository.dart';
import 'package:accesswatch_mobile/data/mission_ranking.dart';
import 'package:accesswatch_mobile/l10n/app_localizations.dart';
import 'package:accesswatch_mobile/l10n/app_localizations_en.dart';
import 'package:accesswatch_mobile/l10n/app_localizations_pt.dart';
import 'package:accesswatch_mobile/state/mission_state.dart';
import 'package:accesswatch_mobile/utils/labels.dart';
import 'package:accesswatch_mobile/utils/mission_text.dart';
import 'package:accesswatch_mobile/widgets/help/area_card.dart';
import 'package:accesswatch_mobile/widgets/map/feature_layers.dart';
import 'package:accesswatch_mobile/widgets/quality_banners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'support/app_harness.dart';

/// The field alert for the top area, exactly as the app built it before the
/// redesign. The redesign changed where the button is, not the words.
const _alertEn = 'ACCESSWATCH #1 P01, West of Guija: about 12,853 people (estimate). '
    'Needs: BOAT (0.56 km by water). Route 5.62 km, risk HIGH, confidence LOW. Data from Jan 17, 2026. '
    'Route starts at an assumed, unconfirmed depot location, so it is illustrative. VERIFY ON THE GROUND.';
const _alertPt = 'ACCESSWATCH #1 P01, A oeste de Guija: cerca de 12.853 pessoas (estimativa). '
    'Precisa de: BARCO (0,56 km por água). Rota de 5,62 km, risco ALTO, confiança BAIXO. Dados de 17 de jan. de 2026. '
    'A rota parte de uma localização de depósito presumida e não confirmada, por isso é ilustrativa. VERIFIQUE NO TERRENO.';

void main() {
  late AppBundle bundle;
  final AppLocalizations en = AppLocalizationsEn();
  final AppLocalizations pt = AppLocalizationsPt();

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    bundle = await BundleRepository().load();
    await initializeDateFormatting();
  });

  Future<void> tab(WidgetTester tester, String label) async {
    await tester.tap(find.text(label).last);
    await tester.pumpAndSettle();
  }

  testWidgets('three tabs only: Map, Help first, Find care', (tester) async {
    await pumpApp(tester, bundle);
    final destinations = tester.widgetList<NavigationDestination>(find.byType(NavigationDestination)).toList();
    expect(destinations.map((d) => d.label), [en.tabMap, en.tabHelpFirst, en.tabFindCare]);
    // Map is where the app opens.
    expect(find.text(en.seeWhoNeedsHelp), findsOneWidget);
  });

  testWidgets('the Map has no warning banners, only the one preliminary line', (tester) async {
    await pumpApp(tester, bundle);
    expect(find.byType(QualityBanners), findsNothing);
    for (final flag in bundle.manifest.qualityFlags) {
      expect(find.text(en.warningShort(flag)), findsNothing, reason: flag.name);
    }
    expect(find.text(en.mapPreliminary('Jan 17, 2026')), findsOneWidget);
  });

  group('share alert', () {
    test('the text is the same as before the redesign', () {
      final top = rankMissions(bundle.missions, const PriorityWeights()).first;
      expect(en.alertText(top, const PriorityWeights(), bundle.manifest, const Fmt('en')), _alertEn);
      expect(pt.alertText(top, const PriorityWeights(), bundle.manifest, const Fmt('pt')), _alertPt);
    });

    for (final (locale, l, expected) in [(const Locale('en'), en, _alertEn), (const Locale('pt'), pt, _alertPt)]) {
      testWidgets('the area page shows and shares that same text (${locale.languageCode})', (tester) async {
        final sent = <String>[];
        await pumpApp(tester, bundle, locale: locale, overrides: [
          alertSharerProvider.overrideWithValue((text) async => sent.add(text)),
        ]);
        await tab(tester, l.tabHelpFirst);
        await tester.tap(find.byType(AreaCard).first);
        await tester.pumpAndSettle();
        await scrollTo(tester, find.text(l.shareAlert));
        await tester.tap(find.text(l.shareAlert));
        await tester.pumpAndSettle();
        // The preview, with Copy, before anything is sent.
        expect(find.text(expected), findsOneWidget);
        expect(find.text(l.alertCopy), findsOneWidget);
        await tester.tap(find.widgetWithText(FilledButton, l.shareAlert).last);
        await tester.pumpAndSettle();
        expect(sent, [expected]);
      });
    }
  });

  group('no overflow at 200% text on every screen', () {
    for (final (locale, l) in [(const Locale('en'), en), (const Locale('pt'), pt)]) {
      testWidgets(locale.languageCode, (tester) async {
        await pumpApp(tester, bundle, locale: locale, height: 844, textScale: 2.0);
        void ok(String where) => expect(tester.takeException(), isNull, reason: '${locale.languageCode} $where');
        ok('map');
        // At 200% the legend chips can sit over this pill, so use the layer's own tap.
        tester.widget<PocketLabelsLayer>(find.byType(PocketLabelsLayer)).onTap(bundle.pockets.firstWhere((p) => p.id == 'P01'));
        await tester.pumpAndSettle();
        ok('map area sheet');
        await tester.tap(find.text(l.openArea));
        await tester.pumpAndSettle();
        ok('area');
        for (final row in [l.checkOnGround('4'), l.howSure(l.sureLow)]) {
          await scrollTo(tester, find.text(row));
          await tester.tap(find.text(row));
          await tester.pumpAndSettle();
          ok(row);
          await goBack(tester);
        }
        await goBack(tester);
        ok('help first');
        await tab(tester, l.tabFindCare);
        ok('find care');
        await tester.tap(find.text(l.trySampleSpot));
        await tester.pumpAndSettle();
        ok('find care with the sample spot');
        await tab(tester, l.tabMap);
        await openAbout(tester);
        ok('about');
      });
    }
  });
}
