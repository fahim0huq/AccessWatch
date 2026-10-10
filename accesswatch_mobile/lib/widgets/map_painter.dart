import 'package:flutter/material.dart';
import '../models/demo_data.dart';
import '../theme/app_theme.dart';

class MapPainter extends CustomPainter {
  final List<Pocket> pockets;
  final List<ServicePoint> services;
  final List<RoadSegment> roads;
  final List<FloodZone> floodZones;
  final String? selectedPocketId;
  final bool isBeforeFlood;
  final Map<String, bool> layerVisibility;

  MapPainter({
    required this.pockets,
    required this.services,
    required this.roads,
    required this.floodZones,
    required this.selectedPocketId,
    required this.isBeforeFlood,
    required this.layerVisibility,
  });

  Offset _mapCoords(Offset pct, Size size) {
    return Offset(
      (pct.dx / 100) * size.width,
      (pct.dy / 100) * size.height,
    );
  }

  Path _pointsToPath(List<Offset> points, Size size) {
    final path = Path();
    for (int i = 0; i < points.length; i++) {
      final pt = _mapCoords(points[i], size);
      if (i == 0) {
        path.moveTo(pt.dx, pt.dy);
      } else {
        path.lineTo(pt.dx, pt.dy);
      }
    }
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // 1. FLOOD POLYGONS LAYER
    if (!isBeforeFlood && (layerVisibility['flood'] ?? true)) {
      for (final fz in floodZones) {
        final path = _pointsToPath(fz.polygon, size)..close();
        final Color fill;
        final Color stroke;

        if (fz.depth == 'DEEP') {
          fill = AppColors.floodDeep.withValues(alpha: 0.70);
          stroke = AppColors.floodDeep;
        } else if (fz.depth == 'MEDIUM') {
          fill = AppColors.floodMedium.withValues(alpha: 0.50);
          stroke = AppColors.floodMedium;
        } else {
          fill = AppColors.floodShallow.withValues(alpha: 0.35);
          stroke = AppColors.floodShallow;
        }

        final fillPaint = Paint()
          ..color = fill
          ..style = PaintingStyle.fill;
        canvas.drawPath(path, fillPaint);

        final strokePaint = Paint()
          ..color = stroke
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;
        canvas.drawPath(path, strokePaint);
      }
    }

    // 2. ROADS LAYER WITH WATER DEPTH STYLES
    if (layerVisibility['roads'] ?? true) {
      final showDepth = !isBeforeFlood && (layerVisibility['waterDepth'] ?? true);

      for (final road in roads) {
        final path = _pointsToPath(road.points, size);
        Color strokeColor = AppColors.info;
        double strokeWidth = 3.5;
        Color? depthBadgeBg;
        String? depthLabelText;

        if (!isBeforeFlood) {
          if (showDepth) {
            // Apply 3 distinct water depth styles to roads
            switch (road.depthClass) {
              case DepthClass.deep:
                strokeColor = AppColors.floodDeep;
                strokeWidth = 6.0;
                depthBadgeBg = AppColors.floodDeep;
                depthLabelText = '${road.estimatedDepthMeters.toStringAsFixed(2)} m';
                break;
              case DepthClass.medium:
                strokeColor = AppColors.floodMedium;
                strokeWidth = 5.0;
                depthBadgeBg = AppColors.floodMedium;
                depthLabelText = '${road.estimatedDepthMeters.toStringAsFixed(2)} m';
                break;
              case DepthClass.shallow:
                strokeColor = AppColors.floodShallow;
                strokeWidth = 4.0;
                depthBadgeBg = AppColors.floodShallow;
                depthLabelText = '${road.estimatedDepthMeters.toStringAsFixed(2)} m';
                break;
              case DepthClass.dry:
                strokeColor = AppColors.info;
                strokeWidth = 3.5;
                break;
            }
          } else {
            // Standard status colors when depth layer is off
            if (road.status == 'BLOCKED') {
              strokeColor = AppColors.highRisk;
              strokeWidth = 4.5;
            } else if (road.status == 'FLOODED') {
              strokeColor = AppColors.warning;
              strokeWidth = 4.0;
            }
          }
        }

        // Outline for satellite contrast
        final bgPaint = Paint()
          ..color = AppColors.background
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..strokeWidth = strokeWidth + 3.0;
        canvas.drawPath(path, bgPaint);

        // Deep water warning glow if DEEP road
        if (showDepth && road.depthClass == DepthClass.deep) {
          final deepGlow = Paint()
            ..color = AppColors.floodDeep.withValues(alpha: 0.5)
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round
            ..strokeWidth = strokeWidth + 6.0
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
          canvas.drawPath(path, deepGlow);
        }

        final roadPaint = Paint()
          ..color = strokeColor
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..strokeWidth = strokeWidth;
        canvas.drawPath(path, roadPaint);

        // Small depth badge along road segment if depth layer is enabled
        if (showDepth && depthLabelText != null && road.points.length >= 2) {
          final midIdx = road.points.length ~/ 2;
          final midPt = _mapCoords(road.points[midIdx], size);
          _drawDepthPill(canvas, depthLabelText, midPt, depthBadgeBg ?? AppColors.surface, road.depthClass);
        }
      }
    }

    // 3. ROUTES LAYER FOR SELECTED POCKET
    if ((layerVisibility['routes'] ?? true) && selectedPocketId != null && !isBeforeFlood) {
      final selectedPocket = pockets.firstWhere(
        (p) => p.id == selectedPocketId,
        orElse: () => pockets.first,
      );

      // Shortest Route (High Risk Red Dashed Path)
      final shortestPath = _pointsToPath(selectedPocket.routes.shortest.pathPoints, size);
      final shortestBg = Paint()
        ..color = AppColors.background
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7.0
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(shortestPath, shortestBg);

      final shortestPaint = Paint()
        ..color = AppColors.highRisk
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(shortestPath, shortestPaint);

      // Safest Route (Glowing Green Path - Green reserved specifically for safest route)
      final safestPath = _pointsToPath(selectedPocket.routes.safest.pathPoints, size);
      final safestGlow = Paint()
        ..color = AppColors.safestRoute.withValues(alpha: 0.45)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12.0
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawPath(safestPath, safestGlow);

      final safestBg = Paint()
        ..color = AppColors.background
        ..style = PaintingStyle.stroke
        ..strokeWidth = 9.0
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(safestPath, safestBg);

      final safestPaint = Paint()
        ..color = AppColors.safestRoute
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6.0
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(safestPath, safestPaint);
    }

    // 4. SERVICE POINTS
    if (layerVisibility['services'] ?? true) {
      for (final srv in services) {
        final center = _mapCoords(srv.coordinates, size);
        final isFlooded = !isBeforeFlood && srv.status == 'FLOODED';
        final isInaccessible = !isBeforeFlood && srv.status == 'INACCESSIBLE';

        final border = isFlooded
            ? AppColors.highRisk
            : isInaccessible
                ? AppColors.warning
                : AppColors.accent;

        // Background Circle
        final bgPaint = Paint()..color = AppColors.background;
        canvas.drawCircle(center, 14, bgPaint);

        // Border Circle
        final borderPaint = Paint()
          ..color = border
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5;
        canvas.drawCircle(center, 14, borderPaint);

        // Icon representation dot
        final dotPaint = Paint()..color = border;
        canvas.drawCircle(center, 4, dotPaint);

        // Label Badge
        _drawLabel(canvas, srv.name.split(' ')[0], center + const Offset(0, 24), AppColors.textMuted);
      }
    }

    // 5. POCKET MARKERS
    if (layerVisibility['pockets'] ?? true) {
      for (final p in pockets) {
        final center = _mapCoords(p.coordinates, size);
        final isSelected = p.id == selectedPocketId;
        final isCutOff = !isBeforeFlood && (p.status == 'CUT OFF' || p.status == 'HIGH RISK');

        // Selection Pulse Ring
        if (isSelected) {
          final pulsePaint = Paint()
            ..color = AppColors.accent.withValues(alpha: 0.5)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3;
          canvas.drawCircle(center, 26, pulsePaint);
        }

        // Priority Circle
        final circleColor = isSelected
            ? AppColors.accent
            : isCutOff
                ? AppColors.highRisk
                : AppColors.surface;

        final circlePaint = Paint()..color = circleColor;
        canvas.drawCircle(center, 18, circlePaint);

        final strokePaint = Paint()
          ..color = isSelected ? Colors.white : AppColors.border
          ..style = PaintingStyle.stroke
          ..strokeWidth = isSelected ? 3.0 : 2.0;
        canvas.drawCircle(center, 18, strokePaint);

        // Number Text
        final textPainter = TextPainter(
          text: TextSpan(
            text: '#${p.rank.toString().padLeft(2, '0')}',
            style: TextStyle(
              color: isSelected ? AppColors.background : Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        textPainter.paint(canvas, center - Offset(textPainter.width / 2, textPainter.height / 2));

        // Community Name Badge
        _drawBadge(canvas, p.name, center + const Offset(0, 30), isSelected);
      }
    }

    // 6. SUBTLE SECTOR GEOGRAPHIC LABELS (3-4 RECOGNIZABLE AREAS)
    _drawGisLabel(canvas, 'NORTH RIVER DELTA', _mapCoords(const Offset(46, 24), size), AppColors.accent);
    _drawGisLabel(canvas, 'CENTRAL FLOODPLAIN', _mapCoords(const Offset(68, 68), size), AppColors.textMuted);
    _drawGisLabel(canvas, 'SOUTHERN ACCESS LINK', _mapCoords(const Offset(15, 82), size), AppColors.safestRoute);
  }

  void _drawLabel(Canvas canvas, String text, Offset position, Color color) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w600,
          fontFamily: 'monospace',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, position - Offset(textPainter.width / 2, 0));
  }

  void _drawBadge(Canvas canvas, String text, Offset position, bool isSelected) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: isSelected ? AppColors.accent : AppColors.text,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final width = textPainter.width + 16;
    final height = textPainter.height + 8;
    final rect = Rect.fromCenter(center: position, width: width, height: height);

    final bgPaint = Paint()..color = AppColors.background.withValues(alpha: 0.9);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)), bgPaint);

    final borderPaint = Paint()
      ..color = isSelected ? AppColors.accent : AppColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)), borderPaint);

    textPainter.paint(canvas, position - Offset(textPainter.width / 2, textPainter.height / 2));
  }

  void _drawGisLabel(Canvas canvas, String text, Offset position, Color color) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          fontFamily: 'monospace',
          letterSpacing: 0.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, position);
  }

  void _drawDepthPill(Canvas canvas, String text, Offset position, Color badgeColor, DepthClass depthClass) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9.5,
          fontWeight: FontWeight.w900,
          fontFamily: 'monospace',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final width = textPainter.width + 12;
    final height = textPainter.height + 4;
    final rect = Rect.fromCenter(center: position, width: width, height: height);

    final bgPaint = Paint()..color = AppColors.background.withValues(alpha: 0.92);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(6)), bgPaint);

    final borderPaint = Paint()
      ..color = badgeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(6)), borderPaint);

    textPainter.paint(canvas, position - Offset(textPainter.width / 2, textPainter.height / 2));
  }

  @override
  bool shouldRepaint(covariant MapPainter oldDelegate) {
    return oldDelegate.selectedPocketId != selectedPocketId ||
        oldDelegate.isBeforeFlood != isBeforeFlood ||
        oldDelegate.layerVisibility != layerVisibility;
  }
}
