// Header and floating buttons around the map.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import '../../theme/app_theme.dart';
import '../../utils/labels.dart';
import '../beta_badge.dart';

final _osmCopyright = Uri.parse('https://www.openstreetmap.org/copyright');

/// Required credit for the base map; it links to the OSM copyright page.
class OsmAttribution extends StatelessWidget {
  const OsmAttribution({super.key});

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.bottomRight,
        child: GestureDetector(
          onTap: () => launchUrl(_osmCopyright),
          child: Container(
            color: Colors.white.withValues(alpha: 0.85),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            child: Text(AppLocalizations.of(context)!.osmAttribution,
                style: const TextStyle(color: Colors.black87, fontSize: 11)),
          ),
        ),
      );
}

class MapHeader extends ConsumerWidget {
  final bool bannersOpen;
  final VoidCallback onToggleBanners;

  const MapHeader({super.key, required this.bannersOpen, required this.onToggleBanners});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final fmt = Fmt.of(context);
    final manifest = ref.watch(loadedBundleProvider).manifest;
    final dates = manifest.dates;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(l.missionControl,
                        style: const TextStyle(color: AppColors.accent, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                    const BetaBadge(),
                  ],
                ),
                const SizedBox(height: 2),
                Text(l.mapDates(fmt.date(dates.nisarBefore), fmt.date(dates.nisarAfter), fmt.date(dates.emsImage)),
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 10.5)),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: onToggleBanners,
            icon: Icon(bannersOpen ? Icons.expand_less_rounded : Icons.warning_amber_rounded, size: 18, color: AppColors.warning),
            label: Text(l.warningsToggle(fmt.count(manifest.qualityFlags.length)),
                style: const TextStyle(color: AppColors.warning, fontSize: 11)),
          ),
        ],
      ),
    );
  }
}

class MapControls extends StatelessWidget {
  final bool compare;
  final VoidCallback onLayers, onCompare, onLocate, onZoomIn, onZoomOut, onFit;

  const MapControls({
    super.key,
    required this.compare,
    required this.onLayers,
    required this.onCompare,
    required this.onLocate,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onFit,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    Widget button(IconData icon, String tip, VoidCallback onTap, {bool active = false}) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: IconButton.filled(
            tooltip: tip,
            onPressed: onTap,
            iconSize: 22,
            style: IconButton.styleFrom(
              minimumSize: const Size(48, 48),
              backgroundColor: active ? AppColors.accent : AppColors.surface,
              foregroundColor: active ? AppColors.background : AppColors.text,
            ),
            icon: Icon(icon),
          ),
        );
    return Positioned(
      top: 8,
      right: 8,
      bottom: 26,
      child: SingleChildScrollView(
        child: Column(
          children: [
            button(Icons.layers_rounded, l.tooltipLayers, onLayers),
            button(Icons.compare_rounded, l.tooltipCompare, onCompare, active: compare),
            button(Icons.my_location_rounded, l.tooltipLocate, onLocate),
            button(Icons.add_rounded, l.tooltipZoomIn, onZoomIn),
            button(Icons.remove_rounded, l.tooltipZoomOut, onZoomOut),
            button(Icons.fit_screen_rounded, l.tooltipFit, onFit),
          ],
        ),
      ),
    );
  }
}
