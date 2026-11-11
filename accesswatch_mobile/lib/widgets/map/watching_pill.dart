// "Watching: <event> · <date>" on top of the Map. Opens Watch an area.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../router.dart';
import '../../state/providers.dart';
import '../../state/watch_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/labels.dart';

class WatchingPill extends ConsumerWidget {
  const WatchingPill({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final event = ref.watch(watchedEventProvider);
    final date = Fmt.of(context).date(ref.watch(loadedBundleProvider).manifest.dates.nisarAfter);
    final words = event == null
        ? l.appName
        : l.watchingPill(event.name(Localizations.localeOf(context).languageCode), date);
    final radius = BorderRadius.circular(AppSizes.button / 2);
    return Semantics(
      button: true,
      hint: l.watchingPillHint,
      child: DecoratedBox(
        decoration: BoxDecoration(borderRadius: radius, boxShadow: AppShadows.card),
        child: Material(
          key: const ValueKey('watching-pill'),
          color: AppColors.surface,
          borderRadius: radius,
          elevation: 0,
          child: InkWell(
            borderRadius: radius,
            onTap: () => context.go(AppRoutes.watch),
            child: Container(
              constraints: const BoxConstraints(minHeight: AppSizes.tap),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.satellite_alt_rounded, color: AppColors.brand, size: 20),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      words,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(color: AppColors.brandText),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
