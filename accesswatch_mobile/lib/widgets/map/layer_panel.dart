import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../state/map_state.dart';
import '../../state/providers.dart';
import '../../utils/labels.dart';
import 'layers_sheet.dart' show layerName;

/// A switch and an opacity slider for each map layer (About > Advanced).
class LayerControls extends ConsumerWidget {
  const LayerControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final fmt = Fmt.of(context);
    final text = Theme.of(context).textTheme;
    final flags = ref.watch(loadedBundleProvider).manifest.qualityFlags;
    final visible = ref.watch(mapLayersProvider);
    final opacity = ref.watch(mapOpacityProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top of the map first, the way people think of a layer list.
        for (final layer in MapLayer.values.reversed) ...[
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(layerName(l, layer, flags), style: text.bodyLarge),
            value: visible.contains(layer),
            onChanged: (on) => ref.read(mapLayersProvider.notifier).setVisible(layer, on),
          ),
          if (layer == MapLayer.floodBaseline)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(l.layerBaselineNote, style: text.bodySmall),
            ),
          if (layer == MapLayer.depthZones)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(l.depthDetailNote, style: text.bodySmall),
            ),
          if (visible.contains(layer) && opacity.containsKey(layer))
            Row(
              children: [
                SizedBox(width: 110, child: Text(l.opacityLabel(fmt.percent(opacity[layer]!)), style: text.bodySmall)),
                Expanded(
                  child: Slider(
                    value: opacity[layer]!,
                    min: 0.1,
                    divisions: 18,
                    semanticFormatterCallback: (_) =>
                        '${layerName(l, layer, flags)}: ${l.opacityLabel(fmt.percent(opacity[layer]!))}',
                    onChanged: (value) => ref.read(mapOpacityProvider.notifier).set(layer, value),
                  ),
                ),
              ],
            ),
        ],
      ],
    );
  }
}
