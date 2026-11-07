import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import '../state/providers.dart';
import '../theme/app_theme.dart';

/// Bottom navigation around the tabs. Nothing shows until the data has loaded,
/// so no screen ever has to handle a missing bundle.
class MainNavigationScreen extends ConsumerWidget {
  final StatefulNavigationShell shell;

  const MainNavigationScreen({super.key, required this.shell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final bundle = ref.watch(bundleProvider);
    return bundle.when(
      loading: () => _Message(icon: const CircularProgressIndicator(color: AppColors.accent), text: l.loadingData),
      error: (error, _) => _Message(
        icon: const Icon(Icons.error_outline_rounded, color: AppColors.highRisk, size: 40),
        text: l.loadError,
        action: FilledButton(onPressed: () => ref.invalidate(bundleProvider), child: Text(l.retry)),
      ),
      data: (_) => Scaffold(
        body: shell,
        bottomNavigationBar: ref.watch(presentationModeProvider)
            ? null
            : BottomNavigationBar(
                currentIndex: shell.currentIndex,
                onTap: (index) => shell.goBranch(index, initialLocation: index == shell.currentIndex),
                selectedItemColor: AppColors.accent,
                unselectedItemColor: AppColors.textMuted,
                backgroundColor: AppColors.surface,
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(icon: const Icon(Icons.grid_view_rounded), label: l.tabHome),
                  BottomNavigationBarItem(icon: const Icon(Icons.map_rounded), label: l.tabMap),
                  BottomNavigationBarItem(icon: const Icon(Icons.assignment_rounded), label: l.tabMissions),
                  BottomNavigationBarItem(icon: const Icon(Icons.local_hospital_rounded), label: l.tabCare),
                  BottomNavigationBarItem(icon: const Icon(Icons.info_outline_rounded), label: l.tabInfo),
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
        backgroundColor: AppColors.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                const SizedBox(height: 16),
                Text(text, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.text, fontSize: 14)),
                if (action != null) ...[const SizedBox(height: 16), action!],
              ],
            ),
          ),
        ),
      );
}
