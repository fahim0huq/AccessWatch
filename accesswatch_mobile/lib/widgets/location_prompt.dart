import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../state/location.dart';
import '../theme/app_theme.dart';

/// Explains why before the system asks for location, then starts it.
/// Returns true when the position will follow.
Future<bool> requestLocation(BuildContext context, WidgetRef ref) async {
  final l = AppLocalizations.of(context)!;
  final messenger = ScaffoldMessenger.of(context);
  if (!await ref.read(locationSourceProvider).isPermitted()) {
    if (!context.mounted) return false;
    final go = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        icon: const Icon(Icons.my_location_rounded, color: AppColors.brand),
        title: Text(l.locationWhyTitle, style: const TextStyle(color: AppColors.ink, fontSize: 16)),
        content: Text(l.locationWhyBody, style: const TextStyle(color: AppColors.ink, fontSize: 13, height: 1.4)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: Text(l.locationNotNow)),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: Text(l.locationContinue)),
        ],
      ),
    );
    if (go != true) return false;
  }
  final issue = await ref.read(locationControllerProvider.notifier).start();
  if (issue != null) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(issue == LocationIssue.serviceOff ? l.locationOff : l.locationDenied)));
  }
  return issue == null;
}

/// For screens that show the position: tells the location controller when the
/// screen is on screen, so GPS stops on other tabs.
mixin ShowsLocation<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  late final LocationController _location = ref.read(locationControllerProvider.notifier);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _location.setVisible(this, TickerMode.valuesOf(context).enabled);
  }

  @override
  void dispose() {
    _location.setVisible(this, false);
    super.dispose();
  }
}
