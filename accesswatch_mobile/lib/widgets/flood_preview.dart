import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' show LatLng, degToRadian;

import '../data/bundle_repository.dart';
import '../data/models/geo.dart';
import '../theme/app_theme.dart';

/// Small non-interactive outline of the real flood and pockets for the Home card.
class FloodPreview extends StatelessWidget {
  final AppBundle bundle;

  const FloodPreview({super.key, required this.bundle});

  @override
  Widget build(BuildContext context) => RepaintBoundary(child: CustomPaint(painter: _PreviewPainter(bundle)));
}

class _PreviewPainter extends CustomPainter {
  final AppBundle bundle;

  _PreviewPainter(this.bundle);

  @override
  void paint(Canvas canvas, Size size) {
    final b = bundle.manifest.bounds;
    // Equal scale in both axes, using real ground distance at this latitude.
    final squeeze = math.cos(degToRadian((b.north + b.south) / 2));
    final spanX = (b.east - b.west) * squeeze;
    final spanY = b.north - b.south;
    final scale = math.min(size.width / spanX, size.height / spanY);
    final left = size.width - spanX * scale;
    final top = (size.height - spanY * scale) / 2;

    Offset project(LatLng p) => Offset(
          left + (p.longitude - b.west) * squeeze * scale,
          top + (b.north - p.latitude) * scale,
        );

    Path pathOf(GeoPolygon polygon) {
      final path = Path()..fillType = PathFillType.evenOdd;
      path.addPolygon(polygon.outer.map(project).toList(), true);
      for (final hole in polygon.holes) {
        path.addPolygon(hole.map(project).toList(), true);
      }
      return path;
    }

    final floodPaint = Paint()..color = AppColors.floodMedium.withValues(alpha: 0.75);
    for (final area in bundle.flood) {
      for (final polygon in area.polygons) {
        canvas.drawPath(pathOf(polygon), floodPaint);
      }
    }
    final pocketFill = Paint()..color = AppColors.highRisk.withValues(alpha: 0.35);
    final pocketEdge = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppColors.highRisk;
    for (final pocket in bundle.pockets) {
      for (final polygon in pocket.polygons) {
        final path = pathOf(polygon);
        canvas.drawPath(path, pocketFill);
        canvas.drawPath(path, pocketEdge);
      }
    }
  }

  @override
  bool shouldRepaint(_PreviewPainter old) => old.bundle != bundle;
}
