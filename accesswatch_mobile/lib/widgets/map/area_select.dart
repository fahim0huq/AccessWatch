// "Select an area on the map": tap to place a box, or drag to draw one; then
// the card says whether that box has satellite data.
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart' show LatLng;

import '../../l10n/app_localizations.dart';
import '../../router.dart';
import '../../state/watch_state.dart';
import '../../theme/app_theme.dart';
import '../watch/watch_cards.dart';
import 'map_overlay.dart';

/// Half the side of a box placed by a tap, in screen pixels.
const _tapBoxHalf = 60.0;

/// The picked box, drawn while selecting.
class SelectionBoxLayer extends ConsumerWidget {
  const SelectionBoxLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final box = ref.watch(watchSelectionProvider);
    if (box == null || !ref.watch(mapSelectingProvider)) return const SizedBox.shrink();
    return PolygonLayer(
      polygons: [
        Polygon(
          points: [box.northWest, box.northEast, box.southEast, box.southWest],
          color: AppColors.brand.withValues(alpha: 0.18),
          borderColor: AppColors.brand,
          borderStrokeWidth: 3,
        ),
      ],
    );
  }
}

/// Over the map while selecting: takes taps and drags, with the hint, Cancel,
/// zoom and the result card.
class AreaSelectOverlay extends ConsumerStatefulWidget {
  final MapController map;
  final ValueChanged<double> onZoom;

  const AreaSelectOverlay({super.key, required this.map, required this.onZoom});

  @override
  ConsumerState<AreaSelectOverlay> createState() => _AreaSelectOverlayState();
}

class _AreaSelectOverlayState extends ConsumerState<AreaSelectOverlay> {
  Offset? _start;

  LatLng _at(Offset p) => widget.map.camera.screenOffsetToLatLng(p);

  void _set(Offset a, Offset b) =>
      ref.read(watchSelectionProvider.notifier).state = LatLngBounds.fromPoints([_at(a), _at(b)]);

  /// Cancel with no box; Done keeps the box. Either way, back to Watch.
  void _close() {
    ref.read(mapSelectingProvider.notifier).state = false;
    context.go(AppRoutes.watch);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    const half = Offset(_tapBoxHalf, _tapBoxHalf);
    final hasBox = ref.watch(watchSelectionProvider) != null;
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            key: const ValueKey('select-surface'),
            behavior: HitTestBehavior.opaque,
            onTapUp: (d) => _set(d.localPosition - half, d.localPosition + half),
            onPanStart: (d) => _start = d.localPosition,
            onPanUpdate: (d) {
              if (_start != null) _set(_start!, d.localPosition);
            },
            onPanEnd: (_) => _start = null,
          ),
        ),
        SafeArea(
          child: MediaQuery.withClampedTextScaling(
            maxScaleFactor: mapOverlayMaxTextScale,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                  boxShadow: AppShadows.floating,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 6, 6, 6),
                  child: Row(
                    children: [
                      const Icon(Icons.crop_free_rounded, color: AppColors.brand),
                      const SizedBox(width: 10),
                      Expanded(child: Text(l.selectHint, style: Theme.of(context).textTheme.bodyMedium)),
                      TextButton(
                        key: const ValueKey('select-close'),
                        onPressed: _close,
                        child: Text(hasBox ? l.selectDone : l.selectCancel),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 12,
          top: 0,
          bottom: 0,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MapRoundButton(icon: Icons.add_rounded, tooltip: l.tooltipZoomIn, onPressed: () => widget.onZoom(1)),
                MapRoundButton(
                  icon: Icons.remove_rounded,
                  tooltip: l.tooltipZoomOut,
                  onPressed: () => widget.onZoom(-1),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SafeArea(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.45),
              child: const SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: SelectionResultCard(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
