import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' show LatLng;

import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';

/// The position: the user's own in blue, a sample or test position in orange.
class MyLocationLayer extends StatelessWidget {
  final LatLng position;
  final bool isTest;

  /// Read out instead of the default, e.g. for the sample spot.
  final String? label;

  const MyLocationLayer({super.key, required this.position, this.isTest = false, this.label});

  @override
  Widget build(BuildContext context) => MarkerLayer(
    markers: [
      Marker(
        point: position,
        width: 28,
        height: 28,
        child: Semantics(
          label: label ?? (isTest ? AppLocalizations.of(context)!.testPositionBadge : AppLocalizations.of(context)!.legendMe),
          child: Container(
            decoration: BoxDecoration(
              color: isTest ? AppColors.boat : AppColors.me,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.surface, width: 3),
            ),
            child: const Icon(Icons.navigation_rounded, size: 12, color: AppColors.surface),
          ),
        ),
      ),
    ],
  );
}
