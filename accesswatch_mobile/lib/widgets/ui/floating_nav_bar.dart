// The floating bottom bar: Map, Help first, the raised round Watch button,
// Find care and About. Every slot has an icon and a word, and is 48 dp or more.
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';

/// The shell branches, in bar order.
enum NavSlot { map, help, watch, care, about }

class FloatingNavBar extends StatelessWidget {
  final NavSlot current;
  final ValueChanged<NavSlot> onSelect;

  const FloatingNavBar({super.key, required this.current, required this.onSelect});

  /// How far the Watch button rises above the bar.
  static const overhang = 22.0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    Widget slot(NavSlot s, IconData icon, String word) =>
        Expanded(child: _Slot(icon: icon, word: word, selected: current == s, onTap: () => onSelect(s), slot: s));
    // The bar's words stay readable but never push the bar over half the screen.
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.3,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSizes.barMargin, 0, AppSizes.barMargin, AppSizes.barMargin),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: overhang),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSizes.barRadius),
                    boxShadow: AppShadows.floating,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        slot(NavSlot.map, Icons.map_rounded, l.tabMap),
                        slot(NavSlot.help, Icons.volunteer_activism_rounded, l.tabHelpFirst),
                        Expanded(
                          child: _Slot(
                            word: l.tabWatch,
                            selected: current == NavSlot.watch,
                            onTap: () => onSelect(NavSlot.watch),
                            slot: NavSlot.watch,
                          ),
                        ),
                        slot(NavSlot.care, Icons.local_hospital_rounded, l.tabFindCare),
                        slot(NavSlot.about, Icons.info_rounded, l.tabAbout),
                      ],
                    ),
                  ),
                ),
              ),
              // The word under it carries the label; the circle is the same target.
              ExcludeSemantics(child: _WatchCircle(onTap: () => onSelect(NavSlot.watch))),
            ],
          ),
        ),
      ),
    );
  }
}

class _Slot extends StatelessWidget {
  final IconData? icon;
  final String word;
  final bool selected;
  final VoidCallback onTap;
  final NavSlot slot;

  const _Slot({this.icon, required this.word, required this.selected, required this.onTap, required this.slot});

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.brandText : AppColors.inkSecondary;
    final style = Theme.of(context).textTheme.labelSmall!.copyWith(
          color: color,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        );
    return Semantics(
      button: true,
      selected: selected,
      label: word,
      excludeSemantics: true,
      child: InkWell(
        key: ValueKey('nav-${slot.name}'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.chipRadius),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(2, 8, 2, 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.brandTint : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppSizes.chipRadius),
                    ),
                    child: Icon(icon, size: 24, color: color),
                  )
                else
                  // Room for the raised circle.
                  const SizedBox(height: AppSizes.watchButton - FloatingNavBar.overhang + 2),
                const SizedBox(height: 3),
                Text(word, style: style, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WatchCircle extends StatelessWidget {
  final VoidCallback onTap;

  const _WatchCircle({required this.onTap});

  @override
  Widget build(BuildContext context) => Container(
        width: AppSizes.watchButton,
        height: AppSizes.watchButton,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppGradients.brand,
          boxShadow: AppShadows.floating,
          border: Border.fromBorderSide(BorderSide(color: AppColors.surface, width: 3)),
        ),
        child: Material(
          type: MaterialType.transparency,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            key: const ValueKey('nav-watch-circle'),
            onTap: onTap,
            child: const Icon(Icons.satellite_alt_rounded, color: AppColors.surface, size: 28),
          ),
        ),
      );
}
