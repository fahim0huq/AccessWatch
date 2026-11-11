// The soft violet look: the page gradient, the gradient hero card, icon
// tiles and pills. White text only on the violet gradient or solid orange/teal.
import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

/// The page gradient behind a screen whose Scaffold is transparent.
class GradientPage extends StatelessWidget {
  final Widget child;

  const GradientPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) =>
      DecoratedBox(decoration: const BoxDecoration(gradient: AppGradients.page), child: child);
}

/// Text and icons on a hero card.
const onHero = AppColors.surface;

/// A rounded card on a gradient (violet by default, or a solid mode colour).
/// Text styles inside must use [onHero].
class HeroCard extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  const HeroCard({
    super.key,
    required this.child,
    this.gradient = AppGradients.brand,
    this.onTap,
    this.padding = const EdgeInsets.all(20),
    this.margin = const EdgeInsets.only(bottom: 12),
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppSizes.heroRadius);
    return Padding(
      padding: margin,
      child: DecoratedBox(
        decoration: BoxDecoration(gradient: gradient, borderRadius: radius, boxShadow: AppShadows.floating),
        child: Material(
          type: MaterialType.transparency,
          borderRadius: radius,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: padding,
              child: IconTheme.merge(
                data: const IconThemeData(color: onHero),
                child: SizedBox(width: double.infinity, child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A 52-56 dp tile with a soft gradient behind a dark icon.
class IconTile extends StatelessWidget {
  final IconData icon;
  final Tone tone;
  final double size;

  const IconTile({super.key, required this.icon, required this.tone, this.size = AppSizes.iconTile});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(gradient: tone.tile, borderRadius: BorderRadius.circular(size / 3)),
        child: Icon(icon, color: tone.text, size: size * 0.5),
      );
}

/// A see-through white tile for an icon on a hero card.
class HeroIconTile extends StatelessWidget {
  final IconData icon;

  const HeroIconTile({super.key, required this.icon});

  @override
  Widget build(BuildContext context) => Container(
        width: AppSizes.iconTile,
        height: AppSizes.iconTile,
        decoration: BoxDecoration(
          color: onHero.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(AppSizes.iconTile / 3),
        ),
        child: Icon(icon, color: onHero, size: 28),
      );
}

/// The rank on a hero card: a white circle with violet digits.
class HeroRank extends StatelessWidget {
  final int rank;
  final double size;

  const HeroRank({super.key, required this.rank, this.size = 48});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: const BoxDecoration(color: onHero, shape: BoxShape.circle),
        child: Text('$rank',
            style: TextStyle(fontSize: size * 0.42, fontWeight: FontWeight.w700, color: AppColors.brandText)),
      );
}

/// A pastel pill: icon, words, and an optional second line. Dark text on the tint.
class InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? detail;
  final Tone tone;

  const InfoPill({super.key, required this.icon, required this.label, this.detail, required this.tone});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
      decoration: BoxDecoration(color: tone.tint, borderRadius: BorderRadius.circular(AppSizes.button / 2)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: tone.text),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, style: text.titleSmall!.copyWith(color: tone.text)),
                if (detail != null) Text(detail!, style: text.bodySmall!.copyWith(color: tone.text)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A filter pill: white, violet tint when chosen. Its words wrap at large text.
class FilterPill extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;

  const FilterPill({super.key, required this.label, this.icon, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.brandText : AppColors.ink;
    final radius = BorderRadius.circular(AppSizes.chipRadius);
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? AppColors.brandTint : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(color: selected ? AppColors.brand : AppColors.line),
        ),
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: AppSizes.tap),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null || selected) ...[
                  Icon(icon ?? Icons.check_rounded, size: 18, color: color),
                  const SizedBox(width: 6),
                ],
                Flexible(
                  child: Text(label,
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(color: color, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
