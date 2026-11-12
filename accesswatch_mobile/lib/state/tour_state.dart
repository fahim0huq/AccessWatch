// The first-run tour: five steps over the real controls, shown once, replayable from About.
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'settings_store.dart';

/// The controls the tour points at. Each is attached to exactly one widget.
class TourTargets {
  static final summaryCard = GlobalKey(debugLabel: 'tour-summary-card');
  static final chipRow = GlobalKey(debugLabel: 'tour-chip-row');
  static final helpTab = GlobalKey(debugLabel: 'tour-help-tab');
  static final watchingPill = GlobalKey(debugLabel: 'tour-watching-pill');
  static final careTab = GlobalKey(debugLabel: 'tour-care-tab');

  static List<GlobalKey> get all => [summaryCard, chipRow, helpTab, watchingPill, careTab];
}

const tourStepCount = 5;

class TourState {
  /// Null while no tour is showing.
  final int? step;

  const TourState(this.step);

  bool get active => step != null;
}

class TourController extends StateNotifier<TourState> {
  final Ref _ref;
  bool _autoChecked = false;

  TourController(this._ref) : super(const TourState(null));

  bool get seen => _ref.read(sharedPreferencesProvider).getBool(SettingsKeys.tourSeen) ?? false;

  /// After the first-run safety screen: start once, and remember it at once.
  void maybeAutoStart() {
    if (_autoChecked) return;
    _autoChecked = true;
    if (!seen) start();
  }

  void start() {
    _ref.read(sharedPreferencesProvider).setBool(SettingsKeys.tourSeen, true);
    state = const TourState(0);
  }

  void goTo(int step) => state = step < 0 || step >= tourStepCount ? const TourState(null) : TourState(step);

  void finish() => state = const TourState(null);
}

final tourProvider = StateNotifierProvider<TourController, TourState>((ref) => TourController(ref));
