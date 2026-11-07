// Map tab: floating controls — zoom, reset, layers, legend, radar label.
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MapZoomControls extends StatelessWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onReset;
  final VoidCallback onLayers;

  const MapZoomControls({
    super.key,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onReset,
    required this.onLayers,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      right: 16,
      child: Column(
        children: [
          FloatingActionButton.small(heroTag: 'btnLayers', onPressed: onLayers, backgroundColor: AppColors.surface, child: const Icon(Icons.layers_rounded, color: AppColors.accent)),
          const SizedBox(height: 8),
          FloatingActionButton.small(heroTag: 'btnZoomIn', onPressed: onZoomIn, backgroundColor: AppColors.surface, child: const Icon(Icons.add, color: Colors.white)),
          const SizedBox(height: 8),
          FloatingActionButton.small(heroTag: 'btnZoomOut', onPressed: onZoomOut, backgroundColor: AppColors.surface, child: const Icon(Icons.remove, color: Colors.white)),
          const SizedBox(height: 8),
          FloatingActionButton.small(heroTag: 'btnResetView', onPressed: onReset, backgroundColor: AppColors.surface, child: const Icon(Icons.center_focus_strong, color: AppColors.accent)),
        ],
      ),
    );
  }
}

class MapDepthLegend extends StatelessWidget {
  const MapDepthLegend({super.key});

  Widget _row(Color color, String label, String range) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(children: [
          Container(width: 16, height: 4, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
          const SizedBox(width: 8),
          Text(range, style: const TextStyle(color: AppColors.textMuted, fontSize: 10, fontFamily: 'monospace')),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      left: 16,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
          boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('WATER DEPTH', style: TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'monospace', letterSpacing: 0.5)),
            const SizedBox(height: 6),
            _row(AppColors.floodShallow, 'SHALLOW', '< 0.3 m'),
            _row(AppColors.floodMedium, 'MEDIUM', '0.3–0.8 m'),
            _row(AppColors.floodDeep, 'DEEP', '> 0.8 m'),
            const SizedBox(height: 8),
            const Text('Estimated depth — verify on the ground.', style: TextStyle(color: AppColors.warning, fontSize: 9, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

