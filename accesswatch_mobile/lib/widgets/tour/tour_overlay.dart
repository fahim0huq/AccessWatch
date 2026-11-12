// The tour over the app: the screen dimmed, a hole with a white outline around
// the real control, and one white speech card with a pointer. Missing or
// off-screen targets are skipped.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../state/tour_state.dart';
import '../../theme/app_theme.dart';
import 'tour_card.dart';

/// Room between the hole and the card, for the pointer.
const _gap = 14.0;
const _margin = 12.0;

class TourOverlay extends ConsumerStatefulWidget {
  const TourOverlay({super.key});

  @override
  ConsumerState<TourOverlay> createState() => _TourOverlayState();
}

class _TourOverlayState extends ConsumerState<TourOverlay> {
  Rect? _hole;
  int? _measured;

  /// +1 going forward, -1 going back: the way to skip a missing target.
  int _direction = 1;

  void _go(int step) {
    final now = ref.read(tourProvider).step ?? 0;
    _direction = step < now ? -1 : 1;
    ref.read(tourProvider.notifier).goTo(step);
  }

  void _measure(int step) {
    if (!mounted || ref.read(tourProvider).step != step) return;
    final me = context.findRenderObject() as RenderBox?;
    final box = TourTargets.all[step].currentContext?.findRenderObject() as RenderBox?;
    Rect? rect;
    if (me != null && me.hasSize && box != null && box.attached && box.hasSize) {
      final r = box.localToGlobal(Offset.zero, ancestor: me) & box.size;
      final seen = r.intersect(Offset.zero & me.size);
      // Off-screen, or mostly hidden, counts as missing.
      if (!seen.isEmpty && seen.width * seen.height >= 0.5 * r.width * r.height) rect = r;
    }
    if (rect == null) {
      ref.read(tourProvider.notifier).goTo(step + _direction);
      return;
    }
    if (rect != _hole || _measured != step) {
      setState(() {
        _hole = rect;
        _measured = step;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = ref.watch(tourProvider).step;
    if (step == null) {
      _measured = null;
      return const SizedBox.shrink();
    }
    // Measure after layout; the target may move with text size or rotation.
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure(step));
    final hole = _measured == step ? _hole!.inflate(6) : null;
    final l = AppLocalizations.of(context)!;
    return LayoutBuilder(
      builder: (context, box) {
        final size = box.biggest;
        final card = hole == null
            ? null
            : TourCard(
                step: step,
                onBack: step > 0 ? () => _go(step - 1) : null,
                onSkip: () => ref.read(tourProvider.notifier).finish(),
                onNext: () => step == tourStepCount - 1 ? ref.read(tourProvider.notifier).finish() : _go(step + 1),
              );
        final below = hole == null ? true : size.height - hole.bottom >= hole.top;
        final room = hole == null
            ? 0.0
            : (below ? size.height - hole.bottom : hole.top) - _gap - _margin - MediaQuery.paddingOf(context).vertical / 2;
        return Stack(
          children: [
            // The dim layer takes every tap: only the card answers during the tour.
            Positioned.fill(
              child: ExcludeSemantics(
                child: AbsorbPointer(
                  child: CustomPaint(painter: _DimPainter(hole)),
                ),
              ),
            ),
            if (hole != null && card != null) ...[
              Positioned(
                left: (hole.center.dx - 10).clamp(_margin + 12, size.width - _margin - 32),
                top: below ? hole.bottom + _gap - 9 : null,
                bottom: below ? null : size.height - hole.top + _gap - 9,
                child: ExcludeSemantics(child: CustomPaint(size: const Size(20, 10), painter: _PointerPainter(below))),
              ),
              Positioned(
                left: _margin,
                right: _margin,
                top: below ? hole.bottom + _gap : null,
                bottom: below ? null : size.height - hole.top + _gap,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: room.clamp(160.0, size.height - 2 * _margin)),
                  // The card is the only thing a screen reader sees during the tour.
                  child: BlockSemantics(
                    child: Semantics(
                      scopesRoute: true,
                      namesRoute: true,
                      explicitChildNodes: true,
                      label: l.tourStepOf('${step + 1}', '$tourStepCount'),
                      child: card,
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _DimPainter extends CustomPainter {
  final Rect? hole;

  const _DimPainter(this.hole);

  @override
  void paint(Canvas canvas, Size size) {
    final screen = Path()..addRect(Offset.zero & size);
    final dim = Paint()..color = AppColors.ink.withValues(alpha: 0.62);
    if (hole == null) {
      canvas.drawPath(screen, dim);
      return;
    }
    final rrect = RRect.fromRectAndRadius(hole!, const Radius.circular(18));
    canvas.drawPath(Path.combine(PathOperation.difference, screen, Path()..addRRect(rrect)), dim);
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = AppColors.surface
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(_DimPainter old) => old.hole != hole;
}

/// The small triangle from the card to the control.
class _PointerPainter extends CustomPainter {
  final bool up;

  const _PointerPainter(this.up);

  @override
  void paint(Canvas canvas, Size size) {
    final path = up
        ? (Path()
            ..moveTo(0, size.height)
            ..lineTo(size.width / 2, 0)
            ..lineTo(size.width, size.height))
        : (Path()
            ..moveTo(0, 0)
            ..lineTo(size.width / 2, size.height)
            ..lineTo(size.width, 0));
    canvas.drawPath(path..close(), Paint()..color = AppColors.surface);
  }

  @override
  bool shouldRepaint(_PointerPainter old) => old.up != up;
}
