import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../data/mission_ranking.dart';
import '../data/verify_notes.dart';
import 'providers.dart';
import 'settings_store.dart';

/// The slider positions, saved. The published ranking is the starting point.
final priorityWeightsProvider =
    StateProvider<PriorityWeights>((ref) => readPriorityWeights(ref.watch(sharedPreferencesProvider)));

/// All missions in their current order.
final rankedMissionsProvider = Provider<List<RankedMission>>((ref) {
  return rankMissions(ref.watch(loadedBundleProvider).missions, ref.watch(priorityWeightsProvider));
});

/// Ticked ground checks per pocket, saved across restarts.
class VerifyChecksNotifier extends StateNotifier<Map<String, Set<VerifyNoteKind>>> {
  VerifyChecksNotifier(super.initial);

  void set(String pocketId, VerifyNoteKind kind, bool checked) {
    final current = {...?state[pocketId]};
    checked ? current.add(kind) : current.remove(kind);
    state = {...state, pocketId: current};
  }
}

final verifyChecksProvider =
    StateNotifierProvider<VerifyChecksNotifier, Map<String, Set<VerifyNoteKind>>>(
        (ref) => VerifyChecksNotifier(readVerifyChecks(ref.watch(sharedPreferencesProvider))));

/// Sends text to the device's share sheet. Tests record it instead.
final alertSharerProvider = Provider<Future<void> Function(String)>((ref) => (text) async {
      await Share.share(text);
    });
