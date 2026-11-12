// One big tile in the Layers sheet: an icon in a circle and a label under it.
import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class LayerTile extends StatelessWidget {
  final IconData icon;
  final String label;

  /// Null for a tile that opens something instead of switching.
  final bool? selected;
  final VoidCallback onTap;
  final int maxLines;

  const LayerTile({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.maxLines = 2,
  });

  @override
  Widget build(BuildContext context) {
    final on = selected ?? false;
    final radius = BorderRadius.circular(18);
    return Semantics(
      button: true,
      selected: selected,
      toggled: selected,
      label: label,
      child: Material(
        color: on ? AppColors.brandTint : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(color: on ? AppColors.brand : AppColors.line, width: on ? 2 : 1),
        ),
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: ExcludeSemantics(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 10, 4, 8),
              child: Column(
                children: [
                  // Status is never colour alone: a check badge when on, an arrow when it opens.
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: on ? AppColors.brand : AppColors.surfaceMuted,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: on ? AppColors.surface : AppColors.brandText),
                      ),
                      if (selected != false)
                        Positioned(
                          right: -4,
                          bottom: -4,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.brand),
                            ),
                            child: Icon(
                              selected == null ? Icons.arrow_outward_rounded : Icons.check_rounded,
                              size: 14,
                              color: AppColors.brandText,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: maxLines,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: on ? AppColors.brandText : AppColors.ink,
                          fontWeight: on ? FontWeight.w700 : FontWeight.w500,
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
