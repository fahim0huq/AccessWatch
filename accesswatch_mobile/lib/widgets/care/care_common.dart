import 'package:flutter/material.dart';

import '../../data/models/enums.dart';
import '../../data/routing.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../area/area_sections.dart' show CardTitle;
import '../ui/kit.dart';

const careSectionStyle = TextStyle(color: AppColors.ink, fontSize: 18, fontWeight: FontWeight.w700);
const careBodyStyle = TextStyle(color: AppColors.ink, fontSize: 16, height: 1.4);
const careMutedStyle = TextStyle(color: AppColors.inkSecondary, fontSize: 14, height: 1.4);

IconData careModeIcon(CareMode mode) => switch (mode) {
      CareMode.car => Icons.directions_car_rounded,
      CareMode.truck => Icons.local_shipping_rounded,
      CareMode.foot => Icons.directions_walk_rounded,
    };

String careModeLabel(AppLocalizations l, CareMode mode) => switch (mode) {
      CareMode.car => l.careModeCar,
      CareMode.truck => l.careModeTruck,
      CareMode.foot => l.careModeFoot,
    };

(IconData, Color) clinicStatusLook(ClinicStatus status) => switch (status) {
      ClinicStatus.reachable => (Icons.check_circle_rounded, AppColors.reach),
      ClinicStatus.accessFlooded => (Icons.water_rounded, AppColors.boatText),
      ClinicStatus.insidePocket => (Icons.block_rounded, AppColors.danger),
    };

class CareCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const CareCard({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) => AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [CardTitle(title), ...children],
        ),
      );
}

/// Icon and text side by side, so meaning never rests on colour alone.
class CareFact extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const CareFact({super.key, required this.icon, required this.color, required this.text});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Expanded(child: Text(text, style: careBodyStyle)),
          ],
        ),
      );
}

/// Shown when no road route reaches a clinic for any mode.
class NeedsBoatNotice extends StatelessWidget {
  final String text;

  const NeedsBoatNotice({super.key, required this.text});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.boatTint,
          borderRadius: BorderRadius.circular(AppSizes.chipRadius),
          border: Border.all(color: AppColors.boat, width: 1.5),
        ),
        child: Row(
          children: [
            const Icon(Icons.directions_boat_rounded, color: AppColors.boatText),
            const SizedBox(width: 10),
            Expanded(
              child: Text(text, style: const TextStyle(color: AppColors.boatText, fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      );
}
