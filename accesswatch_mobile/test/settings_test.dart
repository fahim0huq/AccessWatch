import 'dart:convert';

import 'package:accesswatch_mobile/data/mission_ranking.dart';
import 'package:accesswatch_mobile/data/verify_notes.dart';
import 'package:accesswatch_mobile/state/mission_state.dart';
import 'package:accesswatch_mobile/state/providers.dart';
import 'package:accesswatch_mobile/state/settings_store.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<ProviderContainer> start(Map<String, Object> saved) async {
  SharedPreferences.setMockInitialValues(saved);
  final prefs = await SharedPreferences.getInstance();
  final container = ProviderContainer(overrides: [sharedPreferencesProvider.overrideWithValue(prefs)]);
  addTearDown(container.dispose);
  container.read(settingsPersistenceProvider);
  return container;
}

void main() {
  test('nothing saved: device language, 100% text, no ticks', () async {
    final c = await start({});
    expect(c.read(localeProvider), isNull);
    expect(c.read(textScaleProvider), 1.0);
    expect(c.read(verifyChecksProvider), isEmpty);
    expect(c.read(priorityWeightsProvider).isPublished, isTrue);
    expect(c.read(safetyAcceptedProvider), isFalse);
  });

  test('saved values come back after a restart', () async {
    final first = await start({});
    first.read(localeProvider.notifier).state = const Locale('pt');
    first.read(textScaleProvider.notifier).state = 1.75;
    first.read(verifyChecksProvider.notifier).set('P06', VerifyNoteKind.bridges, true);
    first.read(verifyChecksProvider.notifier).set('P06', VerifyNoteKind.unstable, true);
    first.read(priorityWeightsProvider.notifier).state = const PriorityWeights(people: 1.75, difficulty: 0.25);
    first.read(safetyAcceptedProvider.notifier).state = true;
    final prefs = first.read(sharedPreferencesProvider);

    // A "restart": a new container over what was written.
    final saved = {for (final key in prefs.getKeys()) key: prefs.get(key)!};
    final second = await start(saved);
    expect(second.read(localeProvider), const Locale('pt'));
    expect(second.read(textScaleProvider), 1.75);
    expect(second.read(verifyChecksProvider)['P06'], {VerifyNoteKind.bridges, VerifyNoteKind.unstable});
    final weights = second.read(priorityWeightsProvider);
    expect((weights.people, weights.serviceLoss, weights.difficulty), (1.75, 1.0, 0.25));
    expect(second.read(safetyAcceptedProvider), isTrue);
  });

  test('going back to the device language removes the saved one', () async {
    final c = await start({SettingsKeys.language: 'pt'});
    expect(c.read(localeProvider), const Locale('pt'));
    c.read(localeProvider.notifier).state = null;
    expect(c.read(sharedPreferencesProvider).getString(SettingsKeys.language), isNull);
  });

  test('bad or unknown saved values are ignored, not fatal', () async {
    final c = await start({
      SettingsKeys.textScale: 9.0,
      SettingsKeys.verifyChecks: jsonEncode({'P01': ['bridges', 'a_removed_check']}),
    });
    expect(c.read(textScaleProvider), maxTextScale);
    expect(c.read(verifyChecksProvider)['P01'], {VerifyNoteKind.bridges});
    final broken = await start({SettingsKeys.verifyChecks: 'not json'});
    expect(broken.read(verifyChecksProvider), isEmpty);
  });
}
