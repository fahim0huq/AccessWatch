import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import '../state/connectivity.dart';
import '../state/providers.dart';
import '../theme/app_theme.dart';
import '../widgets/data_status.dart';

/// Shows [child] only once the data has loaded, so no screen ever has to
/// handle a missing bundle.
class BundleGate extends ConsumerWidget {
  final Widget child;

  const BundleGate({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    return ref.watch(bundleProvider).when(
          loading: () => _Message(icon: const CircularProgressIndicator(color: AppColors.brand), text: l.loadingData),
          error: (error, _) => _Message(
            icon: const Icon(Icons.error_outline_rounded, color: AppColors.danger, size: 40),
            text: l.loadError,
            action: FilledButton(onPressed: () => ref.invalidate(bundleProvider), child: Text(l.retry)),
          ),
          data: (_) => child,
        );
  }
}

/// The three tabs: Map, Help first, Find care.
class MainNavigationScreen extends ConsumerWidget {
  final StatefulNavigationShell shell;

  const MainNavigationScreen({super.key, required this.shell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final offline = ref.watch(onlineProvider).valueOrNull == false;
    return BundleGate(
      child: Scaffold(
        body: Column(
          children: [
            const OfflineBanner(),
            Expanded(
              child: MediaQuery.removePadding(
                context: context,
                // The banner already sits below the status bar.
                removeTop: offline,
                child: shell,
              ),
            ),
          ],
        ),
        bottomNavigationBar: ref.watch(presentationModeProvider)
            ? null
            : NavigationBar(
                selectedIndex: shell.currentIndex,
                onDestinationSelected: (index) => shell.goBranch(index, initialLocation: index == shell.currentIndex),
                destinations: [
                  NavigationDestination(
                      icon: const Icon(Icons.map_outlined), selectedIcon: const Icon(Icons.map_rounded), label: l.tabMap),
                  NavigationDestination(
                      icon: const Icon(Icons.volunteer_activism_outlined),
                      selectedIcon: const Icon(Icons.volunteer_activism_rounded),
                      label: l.tabHelpFirst),
                  NavigationDestination(
                      icon: const Icon(Icons.local_hospital_outlined),
                      selectedIcon: const Icon(Icons.local_hospital_rounded),
                      label: l.tabFindCare),
                ],
              ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  final Widget icon;
  final String text;
  final Widget? action;

  const _Message({required this.icon, required this.text, this.action});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                const SizedBox(height: 16),
                Text(text, textAlign: TextAlign.center),
                if (action != null) ...[const SizedBox(height: 16), action!],
              ],
            ),
          ),
        ),
      );
}
