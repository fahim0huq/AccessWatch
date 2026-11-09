// Help first: the Vehicle filter and alerts for a whole group of areas.
import 'package:accesswatch_mobile/data/bundle_repository.dart';
import 'package:accesswatch_mobile/data/models/enums.dart';
import 'package:accesswatch_mobile/l10n/app_localizations.dart';
import 'package:accesswatch_mobile/l10n/app_localizations_en.dart';
import 'package:accesswatch_mobile/l10n/app_localizations_pt.dart';
import 'package:accesswatch_mobile/state/mission_state.dart';
import 'package:accesswatch_mobile/utils/area_groups.dart';
import 'package:accesswatch_mobile/utils/labels.dart';
import 'package:accesswatch_mobile/widgets/help/area_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_harness.dart';

void main() {
  late AppBundle bundle;
  final AppLocalizations en = AppLocalizationsEn();
  final AppLocalizations pt = AppLocalizationsPt();

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    bundle = await BundleRepository().load();
  });

  int count(AccessMode mode) => bundle.missions.where((m) => m.accessMode == mode).length;

  testWidgets('chips: All, Boat and Vehicle (high-clearance), never just "car"', (tester) async {
    await pumpApp(tester, bundle);
    await tester.tap(find.text(en.tabHelpFirst).last);
    await tester.pumpAndSettle();
    expect(find.text(en.filterAllCount('${bundle.missions.length}')), findsOneWidget);
    expect(find.text(en.filterBoatCount('${count(AccessMode.boat)}')), findsOneWidget);
    final vehicle = find.text(en.filterVehicleCount('${count(AccessMode.highClearanceTruck)}'));
    expect(vehicle, findsOneWidget);
    expect(en.filterVehicleCount('4'), contains('high-clearance'));
    await tester.ensureVisible(vehicle);
    await tester.pumpAndSettle();
    await tester.tap(vehicle);
    await tester.pumpAndSettle();
    final shown = tester.widgetList<AreaCard>(find.byType(AreaCard)).toList();
    expect(shown, hasLength(count(AccessMode.highClearanceTruck)));
    expect(shown.every((c) => c.ranked.mission.accessMode == AccessMode.highClearanceTruck), isTrue);
  });

  for (final (locale, l) in [(const Locale('en'), en), (const Locale('pt'), pt)]) {
    final lang = locale.languageCode;
    final fmt = Fmt(lang);

    for (final group in [AreaGroup.all, AreaGroup.boat, AreaGroup.vehicle]) {
      testWidgets('the ${group.name} alert ($lang): areas in rank order, people, mode, depth, caveat', (tester) async {
        final sent = <String>[];
        await pumpApp(tester, bundle, locale: locale, overrides: [
          alertSharerProvider.overrideWithValue((text) async => sent.add(text)),
        ]);
        await tester.tap(find.text(l.tabHelpFirst).last);
        await tester.pumpAndSettle();
        await tester.tap(find.text(l.shareGroupButton));
        await tester.pumpAndSettle();
        final label = switch (group) {
          AreaGroup.all => l.groupAll('${bundle.missions.length}'),
          AreaGroup.boat => l.groupBoat('${count(AccessMode.boat)}'),
          _ => l.groupVehicle('${count(AccessMode.highClearanceTruck)}'),
        };
        await tester.tap(find.text(label));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(FilledButton, l.shareAlert).last);
        await tester.pumpAndSettle();
        final text = sent.single;
        final lines = text.split('\n');
        final ranked = group.of(rankMissionsForTest(bundle));
        // Headline, one line per area, caveat, verify.
        expect(lines, hasLength(ranked.length + 3));
        for (var i = 0; i < ranked.length; i++) {
          final m = ranked[i].mission;
          expect(lines[i + 1], startsWith('#${ranked[i].rank} ${m.pocketId} '), reason: 'rank order');
          expect(lines[i + 1], contains(fmt.count(m.population)));
          expect(lines[i + 1], contains(l.alertModeWords(m, fmt)));
          expect(lines[i + 1], contains(l.alertDepthLine(m)));
        }
        expect(lines[lines.length - 2], l.alertPreliminaryDepotAssumed);
        if (group == AreaGroup.vehicle) {
          expect(text, contains(l.alertModeVehicle));
          expect(text, isNot(contains(l.alertModeBoat('0'))));
        }
        if (lang == 'pt') {
          for (final english in const ['people', 'boat', 'Preliminary', 'VERIFY']) {
            expect(text, isNot(contains(english)));
          }
        }
      });
    }
  }
}
