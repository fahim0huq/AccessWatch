import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../state/connectivity.dart';
import '../state/providers.dart';
import '../theme/app_theme.dart';
import '../utils/labels.dart';

/// When the data was acquired and how old it is: a snapshot, not live.
class DataAgeNote extends ConsumerWidget {
  final bool compact;

  const DataAgeNote({super.key, this.compact = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final acquired = ref.watch(loadedBundleProvider).manifest.dates.nisarAfter;
    final days = ref.watch(clockProvider)().toUtc().difference(acquired).inDays;
    final text = compact
        ? l.dataAgeShort(days < 0 ? 0 : days)
        : l.dataAge(Fmt.of(context).date(acquired), days < 0 ? 0 : days);
    return Semantics(
      container: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.history_rounded, size: compact ? 13 : 16, color: AppColors.warning),
          const SizedBox(width: 6),
          Expanded(
            child: Text(text,
                style: TextStyle(color: AppColors.warning, fontSize: compact ? 10.5 : 12, height: 1.35)),
          ),
        ],
      ),
    );
  }
}

/// Shown across the top of every tab while the device has no network.
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(onlineProvider).valueOrNull != false) return const SizedBox.shrink();
    final l = AppLocalizations.of(context)!;
    return Material(
      color: AppColors.surfaceElevated,
      child: SafeArea(
        bottom: false,
        child: Semantics(
          liveRegion: true,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
            child: Row(
              children: [
                const Icon(Icons.cloud_off_rounded, color: AppColors.warning, size: 20),
                const SizedBox(width: 10),
                Expanded(child: Text(l.offlineBanner, style: const TextStyle(color: AppColors.text, fontSize: 12.5))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
