// Shared building blocks: cards, chips, big buttons, rows and the "?" button.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../router.dart';
import '../../theme/app_theme.dart';

/// White rounded card. [tone] colours the border and, with [tinted], the fill.
class AppCard extends StatelessWidget {
  final Widget child;
  final Color? borderColor;
  final Color? color;
  final double borderWidth;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.borderColor,
    this.color,
    this.borderWidth = 1,
    this.padding = const EdgeInsets.all(AppSizes.gutter),
    this.margin = const EdgeInsets.only(bottom: 12),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      side: BorderSide(color: borderColor ?? AppColors.line, width: borderWidth),
    );
    return Padding(
      padding: margin,
      child: Material(
        color: color ?? AppColors.surface,
        shape: shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: padding, child: SizedBox(width: double.infinity, child: child)),
        ),
      ),
    );
  }
}

/// Icon and word on a tint. The word carries the meaning, not the colour.
class StatusChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Tone tone;

  const StatusChip({super.key, required this.icon, required this.label, required this.tone});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: tone.tint, borderRadius: BorderRadius.circular(AppSizes.chipRadius)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: tone.text),
            const SizedBox(width: 6),
            Flexible(
              child: Text(label,
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(color: tone.text, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      );
}

/// A full-width 56 dp button with an icon and a word.
class BigButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool primary;

  const BigButton({super.key, required this.icon, required this.label, required this.onPressed, this.primary = true});

  const BigButton.secondary({super.key, required this.icon, required this.label, required this.onPressed})
      : primary = false;

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 22),
        const SizedBox(width: 10),
        Flexible(child: Text(label, textAlign: TextAlign.center)),
      ],
    );
    final style = ButtonStyle(
      padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
    );
    return SizedBox(
      width: double.infinity,
      child: primary
          ? FilledButton(onPressed: onPressed, style: style, child: child)
          : OutlinedButton(onPressed: onPressed, style: style, child: child),
    );
  }
}

/// The round "?" that opens About this data.
class HelpButton extends StatelessWidget {
  const HelpButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Semantics(
      button: true,
      label: l.aboutThisData,
      excludeSemantics: true,
      child: Material(
        color: AppColors.surface,
        shape: const CircleBorder(side: BorderSide(color: AppColors.line, width: 1.5)),
        elevation: 1,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => context.push(AppRoutes.about),
          child: const SizedBox(
            width: AppSizes.tap,
            height: AppSizes.tap,
            child: Center(
              child: Text('?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.brand)),
            ),
          ),
        ),
      ),
    );
  }
}

/// A screen heading: title, optional subtitle, and the "?" on the right.
class ScreenTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool help;

  const ScreenTitle({super.key, required this.title, this.subtitle, this.help = true});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSizes.gutter, 12, 12, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(header: true, child: Text(title, style: text.headlineSmall)),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(subtitle!, style: text.bodySmall),
                ],
              ],
            ),
          ),
          if (help) const HelpButton(),
        ],
      ),
    );
  }
}

/// A plain row that opens more detail: icon, words, and a chevron.
class NavRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const NavRow({super.key, required this.icon, required this.title, this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.chipRadius),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 56),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: Row(
            children: [
              Icon(icon, color: AppColors.brand),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: text.titleSmall),
                    if (subtitle != null) Text(subtitle!, style: text.bodySmall),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.inkSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

/// The rank number in a circle.
class RankCircle extends StatelessWidget {
  final int rank;
  final Tone tone;
  final double size;

  const RankCircle({super.key, required this.rank, required this.tone, this.size = 40});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: tone.tint, shape: BoxShape.circle, border: Border.all(color: tone.strong, width: 1.5)),
        child: Text('$rank', style: TextStyle(fontSize: size * 0.42, fontWeight: FontWeight.w700, color: tone.text)),
      );
}

/// A small swatch with its word, for map legends.
class LegendChip extends StatelessWidget {
  final Color color;
  final String label;

  const LegendChip({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.chipRadius),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 14, height: 14, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
            const SizedBox(width: 6),
            Flexible(child: Text(label, style: Theme.of(context).textTheme.labelMedium!.copyWith(color: AppColors.ink))),
          ],
        ),
      );
}
