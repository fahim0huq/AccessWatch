// The chip row on the Map: Flood, Areas, Routes, Clinics, Markets, Shelters.
// Each chip switches the same layer state as the Layers sheet.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/enums.dart';
import '../../l10n/app_localizations.dart';
import '../../state/map_state.dart';
import '../../theme/app_theme.dart';
import '../ui/mode_look.dart';

/// One chip: its layer, its word, and the colours of what the map draws for it.
class LayerChipSpec {
  final MapLayer layer;
  final String Function(AppLocalizations) label;
  final List<Color> dots;

  const LayerChipSpec(this.layer, this.label, this.dots);
}

/// Dot colours match the map: the flood fill, the area colours by mode, the
/// safest-route line, and the place markers.
final layerChips = [
  LayerChipSpec(MapLayer.flood, (l) => l.chipFlood, const [mapFloodColor]),
  LayerChipSpec(MapLayer.pockets, (l) => l.chipAreas, [
    modeMapColor(AccessMode.boat),
    modeMapColor(AccessMode.highClearanceTruck),
  ]),
  LayerChipSpec(MapLayer.routes, (l) => l.chipRoutes, const [AppColors.safestRoute]),
  LayerChipSpec(MapLayer.clinics, (l) => l.chipClinics, const [AppColors.brand]),
  LayerChipSpec(MapLayer.markets, (l) => l.chipMarkets, const [AppColors.brand]),
  LayerChipSpec(MapLayer.shelters, (l) => l.chipShelters, const [AppColors.brand]),
];

/// Visible chip height; the tap target around it is 48 dp.
const layerChipHeight = 44.0;

class LayerChipRow extends ConsumerWidget {
  const LayerChipRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final on = ref.watch(mapLayersProvider);
    return SingleChildScrollView(
      key: const ValueKey('layer-chip-row'),
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          for (final chip in layerChips)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: LayerChip(
                key: ValueKey('layer-chip-${chip.layer.name}'),
                label: chip.label(l),
                dots: chip.dots,
                selected: on.contains(chip.layer),
                onTap: () => ref.read(mapLayersProvider.notifier).setVisible(chip.layer, !on.contains(chip.layer)),
              ),
            ),
        ],
      ),
    );
  }
}

/// On: filled brand colour, check icon, white words. Off: white, coloured dot, dark words.
class LayerChip extends StatelessWidget {
  final String label;
  final List<Color> dots;
  final bool selected;
  final VoidCallback onTap;

  const LayerChip({super.key, required this.label, required this.dots, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(layerChipHeight / 2);
    final color = selected ? AppColors.surface : AppColors.ink;
    return Semantics(
      button: true,
      toggled: selected,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        // The words are the label above; the check and dots say nothing new.
        child: ExcludeSemantics(
          child: Container(
            constraints: const BoxConstraints(minHeight: AppSizes.tap),
            alignment: Alignment.center,
            child: Container(
              constraints: const BoxConstraints(minHeight: layerChipHeight),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: selected ? AppColors.brand : AppColors.surface,
                borderRadius: radius,
                border: Border.all(color: selected ? AppColors.brand : AppColors.line),
                boxShadow: AppShadows.card,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (selected)
                    const Icon(Icons.check_rounded, size: 18, color: AppColors.surface)
                  else
                    for (final dot in dots)
                      Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.only(right: 2),
                        decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
                      ),
                  const SizedBox(width: 6),
                  Text(label, style: Theme.of(context).textTheme.labelLarge!.copyWith(color: color)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
