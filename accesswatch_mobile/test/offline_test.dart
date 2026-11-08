import 'dart:io';

import 'package:accesswatch_mobile/data/bundle_repository.dart';
import 'package:accesswatch_mobile/l10n/app_localizations.dart';
import 'package:accesswatch_mobile/l10n/app_localizations_en.dart';
import 'package:accesswatch_mobile/widgets/map/feature_layers.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_harness.dart';

void main() {
  late AppBundle bundle;
  final AppLocalizations en = AppLocalizationsEn();

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    bundle = await BundleRepository().load();
  });

  testWidgets('data age: acquisition date and a snapshot age, from the manifest', (tester) async {
    await pumpApp(tester, bundle);
    // Harness clock: 2026-11-08 12:00 UTC; NISAR after scene: 2026-01-17 03:42 UTC.
    expect(find.text(en.dataAge('Jan 17, 2026', 295)), findsOneWidget);
    await tester.tap(find.text(en.tabMap).last);
    await tester.pumpAndSettle();
    expect(find.text(en.dataAgeShort(295)), findsOneWidget);
  });

  testWidgets('offline: a banner on every tab, and every tab still works', (tester) async {
    await pumpApp(tester, bundle, online: false);
    for (final tab in [en.tabHome, en.tabMap, en.tabMissions, en.tabCare, en.tabInfo]) {
      await tester.tap(find.text(tab).last);
      await tester.pumpAndSettle();
      expect(find.text(en.offlineBanner), findsOneWidget, reason: tab);
      expect(tester.takeException(), isNull, reason: tab);
    }
    await tester.tap(find.text(en.tabMap).last);
    await tester.pumpAndSettle();
    // The data layers still draw; only the background is missing.
    expect(find.byType(PocketAreasLayer), findsOneWidget);
    expect(find.byType(TileLayer), findsNothing);
  });

  testWidgets('online: no banner', (tester) async {
    await pumpApp(tester, bundle);
    expect(find.text(en.offlineBanner), findsNothing);
  });

  test('the app makes no network calls of its own besides map tiles and links', () {
    final network = RegExp(r'package:http/|HttpClient|NetworkImage|Image\.network|WebSocket');
    final dart = Directory('lib').listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
    for (final file in dart) {
      expect(network.hasMatch(file.readAsStringSync()), isFalse, reason: file.path);
    }
    // Everything the app shows is an asset in the bundle.
    expect(File('pubspec.yaml').readAsStringSync(), contains('assets/bundle/'));
  });
}
