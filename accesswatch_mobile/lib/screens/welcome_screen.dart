import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import '../router.dart';
import '../state/providers.dart';
import '../theme/app_theme.dart';
import '../widgets/ui/kit.dart';

/// First run: what the app is and the safety message, on one screen with one
/// button. The app opens only after it. From About it can be read again.
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final text = Theme.of(context).textTheme;
    final accepted = ref.watch(safetyAcceptedProvider);
    void finish() {
      ref.read(safetyAcceptedProvider.notifier).state = true;
      context.canPop() ? context.pop() : context.go(AppRoutes.map);
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.water_rounded, size: 48, color: AppColors.brand),
                    const SizedBox(height: 16),
                    Semantics(header: true, child: Text(l.introTitle1, style: text.headlineMedium)),
                    const SizedBox(height: 12),
                    Text(l.introBody1, style: text.bodyLarge),
                    const SizedBox(height: 24),
                    AppCard(
                      color: AppColors.cautionTint,
                      borderColor: AppColors.boat,
                      borderWidth: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.health_and_safety_rounded, color: AppColors.boatText),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(l.safetyTitle, style: text.titleMedium!.copyWith(color: AppColors.boatText)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(l.safetyBody, style: text.bodyLarge),
                          const SizedBox(height: 10),
                          Text(l.safetyEmergency,
                              style: text.bodyLarge!.copyWith(color: AppColors.dangerText, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: BigButton(
                icon: accepted ? Icons.close_rounded : Icons.check_rounded,
                label: accepted ? l.close : l.safetyAccept,
                onPressed: finish,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
