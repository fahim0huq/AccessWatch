import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/enums.dart';
import '../../data/models/manifest.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import '../../theme/app_theme.dart';
import '../../utils/labels.dart';
import '../../utils/trust_text.dart';
import '../mission_card_sections.dart' show depthColor;
import '../ui/mode_look.dart';
import 'feature_layers.dart' show serviceIcon;

const _text = TextStyle(color: AppColors.ink, fontSize: 14);
const _title = TextStyle(color: AppColors.ink, fontSize: 16, fontWeight: FontWeight.w700);

BoxDecoration _panel() => BoxDecoration(
  color: AppColors.surface.withValues(alpha: 0.96),
  borderRadius: BorderRadius.circular(12),
  border: Border.all(color: AppColors.line),
);

class _Row extends StatelessWidget {
  final Widget sample;
  final String label;

  const _Row(this.sample, this.label);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        SizedBox(width: 26, height: 20, child: Center(child: sample)),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: _text)),
      ],
    ),
  );
}

Widget _swatch(Color color) => Container(
  width: 22,
  height: 13,
  decoration: BoxDecoration(
    color: color,
    border: Border.all(color: AppColors.line),
    borderRadius: BorderRadius.circular(2),
  ),
);

class _LinePainter extends CustomPainter {
  final Color color;
  final bool dashed;

  const _LinePainter(this.color, this.dashed);

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height / 2;
    final paint = Paint()
      ..color = color
      ..strokeWidth = dashed ? 2.5 : 4;
    if (!dashed) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
      return;
    }
    for (var x = 0.0; x < size.width; x += 8) {
      canvas.drawLine(Offset(x, y), Offset(x + 5, y), paint);
    }
  }

  @override
  bool shouldRepaint(_LinePainter old) => old.color != color || old.dashed != dashed;
}

Widget _line(Color color, {bool dashed = false}) =>
    CustomPaint(size: const Size(22, 10), painter: _LinePainter(color, dashed));

class MapLegend extends ConsumerWidget {
  final double width;

  const MapLegend({super.key, this.width = 240});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final fmt = Fmt.of(context);
    final limits = ref.watch(loadedBundleProvider).manifest.depthClasses;
    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: _panel(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.legendTitle, style: _title),
            const SizedBox(height: 6),
            for (final depth in const [DepthClass.shallow, DepthClass.medium, DepthClass.deep])
              _Row(_swatch(depthColor(depth)), '${l.depthClass(depth)} ${l.depthRange(depth, limits, fmt)}'),
            _Row(_swatch(AppColors.floodMedium.withValues(alpha: 0.35)), l.layerFlood),
            _Row(_swatch(AppColors.floodBaseline.withValues(alpha: 0.6)), l.layerBaseline),
            _Row(_swatch(AppColors.boat.withValues(alpha: 0.6)), l.legendEms),
            _Row(_line(AppColors.floodMedium), l.legendRoad),
            for (final mode in const [AccessMode.boat, AccessMode.highClearanceTruck])
              _Row(_swatch(modeMapColor(mode).withValues(alpha: 0.6)), modeWords(l, mode)),
            _Row(_line(AppColors.safestRoute), l.legendSafest),
            _Row(_line(AppColors.shortestRoute, dashed: true), l.legendShortest),
            for (final type in ServiceType.values)
              _Row(Icon(serviceIcon(type), size: 15, color: AppColors.brand), l.serviceType(type)),
            _Row(const Icon(Icons.navigation_rounded, size: 15, color: AppColors.flood), l.legendMe),
            const SizedBox(height: 6),
            Text(l.depthEstimateWarning, style: const TextStyle(color: AppColors.boatText, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

/// Shown while Compare mode is on: colours from the manifest, areas, and the
/// plain statement that this is not an independent check.
class CompareLegend extends ConsumerWidget {
  const CompareLegend({super.key});

  Color _hex(String value) => Color(int.parse(value.substring(1), radix: 16) | 0xFF000000);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final fmt = Fmt.of(context);
    final manifest = ref.watch(loadedBundleProvider).manifest;
    final CompareInfo c = manifest.compare;
    String km2(int pixels) => fmt.oneDecimal(pixels * c.pixelAreaM2 / 1e6);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 6),
      padding: const EdgeInsets.all(12),
      decoration: _panel(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.compareTitle, style: _title),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.warning_amber_rounded, size: 15, color: AppColors.boatText),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  l.calibrationNote(manifest, ref.watch(loadedBundleProvider).quality, fmt),
                  style: const TextStyle(color: AppColors.boatText, fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          _Row(_swatch(_hex(c.colors['both']!)), l.compareBoth(km2(c.both))),
          _Row(_swatch(_hex(c.colors['only_ours']!)), l.compareOnlyOurs(km2(c.onlyOurs))),
          _Row(_swatch(_hex(c.colors['only_ems']!)), l.compareOnlyEms(km2(c.onlyEms))),
          const SizedBox(height: 4),
          Text(l.compareIou(fmt.score(c.iou)), style: _text),
          Text(
            l.compareEmsDate(fmt.date(manifest.dates.emsImage), fmt.oneDecimal(manifest.dates.emsHoursAfterNisar)),
            style: _text,
          ),
          Text(l.compareTransparent, style: const TextStyle(color: AppColors.inkSecondary, fontSize: 14)),
        ],
      ),
    );
  }
}
