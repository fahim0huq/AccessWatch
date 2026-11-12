// Saved settings: language, text size and the ticked ground checks.
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/mission_ranking.dart';
import '../data/verify_notes.dart';
import 'map_state.dart';
import 'mission_state.dart';
import 'providers.dart';

/// Opened in main() before the app starts; tests supply their own.
final sharedPreferencesProvider =
    Provider<SharedPreferences>((ref) => throw UnimplementedError('Override with SharedPreferences.getInstance()'));

class SettingsKeys {
  static const language = 'language';
  static const textScale = 'text_scale';
  static const verifyChecks = 'verify_checks';
  static const safetyAccepted = 'safety_accepted_v1';
  static const priorityWeights = 'priority_weights';
  static const mapLayers = 'map_layers';
  static const tourSeen = 'tour_seen_v1';
}

/// English unless the user chose another language; never the device's own.
const defaultLocale = Locale('en');

Locale readLocale(SharedPreferences prefs) {
  final code = prefs.getString(SettingsKeys.language);
  return code == null ? defaultLocale : Locale(code);
}

double readTextScale(SharedPreferences prefs) =>
    (prefs.getDouble(SettingsKeys.textScale) ?? minTextScale).clamp(minTextScale, maxTextScale);

/// Unknown check names are skipped, so a saved list from an older version cannot break loading.
Map<String, Set<VerifyNoteKind>> readVerifyChecks(SharedPreferences prefs) {
  final text = prefs.getString(SettingsKeys.verifyChecks);
  if (text == null) return const {};
  try {
    final byName = {for (final kind in VerifyNoteKind.values) kind.name: kind};
    return {
      for (final entry in (jsonDecode(text) as Map<String, dynamic>).entries)
        entry.key: {
          for (final name in entry.value as List<dynamic>)
            if (byName[name] != null) byName[name]!,
        },
    };
  } on FormatException {
    return const {};
  }
}

PriorityWeights readPriorityWeights(SharedPreferences prefs) {
  final text = prefs.getString(SettingsKeys.priorityWeights);
  if (text == null) return const PriorityWeights();
  try {
    final j = jsonDecode(text) as Map<String, dynamic>;
    double weight(String key) =>
        ((j[key] as num?)?.toDouble() ?? PriorityWeights.published).clamp(PriorityWeights.min, PriorityWeights.max);
    return PriorityWeights(people: weight('people'), serviceLoss: weight('service_loss'), difficulty: weight('difficulty'));
  } on FormatException {
    return const PriorityWeights();
  }
}

/// Watched by the app: writes every change of a saved setting.
final settingsPersistenceProvider = Provider<void>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  ref.listen<Locale>(localeProvider, (_, locale) => prefs.setString(SettingsKeys.language, locale.languageCode));
  ref.listen<double>(textScaleProvider, (_, scale) => prefs.setDouble(SettingsKeys.textScale, scale));
  ref.listen<bool>(safetyAcceptedProvider, (_, accepted) => prefs.setBool(SettingsKeys.safetyAccepted, accepted));
  ref.listen<PriorityWeights>(priorityWeightsProvider, (_, w) {
    prefs.setString(SettingsKeys.priorityWeights,
        jsonEncode({'people': w.people, 'service_loss': w.serviceLoss, 'difficulty': w.difficulty}));
  });
  ref.listen<Set<MapLayer>>(mapLayersProvider,
      (_, layers) => prefs.setStringList(SettingsKeys.mapLayers, [for (final l in layers) l.name]..sort()));
  ref.listen<Map<String, Set<VerifyNoteKind>>>(verifyChecksProvider, (_, checks) {
    prefs.setString(SettingsKeys.verifyChecks, jsonEncode({
      for (final entry in checks.entries) entry.key: [for (final kind in entry.value) kind.name],
    }));
  });
});
