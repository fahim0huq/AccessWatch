// The map legend in one small pill: Flooded, Boat, Vehicle.
import 'package:flutter/material.dart';

import '../../data/models/enums.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../ui/mode_look.dart';

/// Flooded, Boat, Vehicle in one small pill.
class MapLegendPill extends StatelessWidget {
  const MapLegendPill({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final style = Theme.of(context).textTheme.labelMedium!.copyWith(color: AppColors.ink);
    Widget item(Color color, String word) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(word, style: style),
      ],
    );
    return Container(
      key: const ValueKey('legend-pill'),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.button / 2),
        boxShadow: AppShadows.card,
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 4,
        children: [
          item(mapFloodColor, l.legendFlooded),
          item(modeMapColor(AccessMode.boat), l.legendBoat),
          item(modeMapColor(AccessMode.highClearanceTruck), l.legendVehicle),
        ],
      ),
    );
  }
}

