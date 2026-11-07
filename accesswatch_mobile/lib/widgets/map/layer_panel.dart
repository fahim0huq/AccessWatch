import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../state/map_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/labels.dart';

/// Switch and opacity for each layer.
class LayerPanel extends ConsumerWidget {
  const LayerPanel({super.key});

  String _name(AppLocalizations l, MapLayer layer) => switch (layer) {
        MapLayer.depthZones => l.layerDepth,
        MapLayer.flood => l.layerFlood,
        MapLayer.floodEms => l.layerEms,
        MapLayer.floodedRoads => l.layerRoads,
        MapLayer.pockets => l.layerPockets,
        MapLayer.routes => l.layerRoutes,
        MapLayer.services => l.layerServices,
        MapLayer.compare => l.layerCompare,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final fmt = Fmt.of(context);
    final visible = ref.watch(mapLayersProvider);
    final opacity = ref.watch(mapOpacityProvider);
    return Material(
      color: AppColors.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20),
          children: [
            Text(l.layersControl,
                style: const TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
            const SizedBox(height: 8),
            // Top of the map first, the way people think of a layer list.
            for (final layer in MapLayer.values.reversed) ...[
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                title: Text(_name(l, layer), style: const TextStyle(color: AppColors.text, fontSize: 13)),
                value: visible.contains(layer),
                activeThumbColor: AppColors.accent,
                onChanged: (on) => ref.read(mapLayersProvider.notifier).setVisible(layer, on),
              ),
              if (visible.contains(layer) && opacity.containsKey(layer))
                Row(
                  children: [
                    SizedBox(
                      width: 96,
                      child: Text(l.opacityLabel(fmt.percent(opacity[layer]!)),
                          style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                    ),
                    Expanded(
                      child: Slider(
                        value: opacity[layer]!,
                        min: 0.1,
                        divisions: 18,
                        activeColor: AppColors.accent,
                        semanticFormatterCallback: (_) => l.opacityLabel(fmt.percent(opacity[layer]!)),
                        onChanged: (value) => ref.read(mapOpacityProvider.notifier).set(layer, value),
                      ),
                    ),
                  ],
                ),
            ],
            const SizedBox(height: 8),
            Text(l.depthDetailNote, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
