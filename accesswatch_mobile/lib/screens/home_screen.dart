import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/bundle_repository.dart';
import '../l10n/app_localizations.dart';
import '../router.dart';
import '../state/providers.dart';
import '../theme/app_theme.dart';
import '../utils/labels.dart';
import '../widgets/beta_badge.dart';
import '../widgets/data_status.dart';
import '../widgets/flood_preview.dart';
import '../widgets/kpi_grid.dart';
import '../widgets/quality_banners.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final bundle = ref.watch(loadedBundleProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 6,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.radar_rounded, color: AppColors.accent, size: 20),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(l.accesswatchTitle,
                          style: const TextStyle(
                              color: AppColors.accent,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                              letterSpacing: 1.0)),
                    ),
                  ],
                ),
                const BetaBadge(),
              ],
            ),
            const SizedBox(height: 14),
            Text(l.heroTitle,
                style: const TextStyle(color: AppColors.text, fontSize: 26, fontWeight: FontWeight.w900, height: 1.15)),
            const SizedBox(height: 4),
            Text(l.heroSubtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 12.5, height: 1.3)),
            const SizedBox(height: 14),
            const QualityBanners(),
            const SizedBox(height: 8),
            _PreviewCard(bundle: bundle),
            const SizedBox(height: 12),
            KpiGrid(stats: bundle.manifest.stats),
            const SizedBox(height: 14),
            _ActionCard(
              icon: Icons.map_rounded,
              iconColor: AppColors.accent,
              background: AppColors.surface,
              borderColor: AppColors.accent.withValues(alpha: 0.4),
              title: l.missionControl,
              subtitle: l.missionControlSubtitle,
              onTap: () => context.go(AppRoutes.map),
            ),
            const SizedBox(height: 10),
            _ActionCard(
              icon: Icons.assignment_rounded,
              iconColor: AppColors.accentSecondary,
              background: AppColors.surfaceElevated,
              borderColor: AppColors.border,
              title: l.missionCards,
              subtitle: l.missionCardsSubtitle(Fmt.of(context).count(bundle.missions.length)),
              onTap: () => context.go(AppRoutes.missions),
            ),
            const SizedBox(height: 14),
            Text(l.appDisclaimer,
                style: const TextStyle(color: AppColors.textMuted, fontSize: 11, fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  final AppBundle bundle;

  const _PreviewCard({required this.bundle});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final places = {for (final m in bundle.missions) m.nearestPlace}.join(' · ');
    return Semantics(
      button: true,
      label: l.floodPreviewLabel,
      child: GestureDetector(
        onTap: () => context.go(AppRoutes.map),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.accent.withValues(alpha: 0.35)),
          ),
          clipBehavior: Clip.antiAlias,
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 150, child: FloodPreview(bundle: bundle)),
              const SizedBox(height: 10),
              Text(l.eventName(bundle.manifest.event),
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(places, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
              const SizedBox(height: 6),
              const DataAgeNote(),
              const SizedBox(height: 4),
              const SizedBox(height: 2),
              Text(l.tapToOpenMap,
                  style: const TextStyle(color: AppColors.accent, fontSize: 11, fontFamily: 'monospace')),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor, background, borderColor;
  final String title, subtitle;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.iconColor,
    required this.background,
    required this.borderColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, color: iconColor, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
