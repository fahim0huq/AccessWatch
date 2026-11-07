import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

/// Header bar of the sheets: drag handle, back button and, on the Missions tab,
/// a button to show the pocket on the map.
class MissionCardHeader extends StatelessWidget {
  final VoidCallback? onViewOnMap;

  const MissionCardHeader({super.key, this.onViewOnMap});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            alignment: onViewOnMap == null ? WrapAlignment.start : WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_rounded, size: 14, color: AppColors.accent),
                label: Text(l.back, style: const TextStyle(color: AppColors.accent, fontSize: 13, fontWeight: FontWeight.bold)),
              ),
              if (onViewOnMap != null)
                ElevatedButton.icon(
                  onPressed: onViewOnMap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.background,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.my_location_rounded, size: 15),
                  label: Text(l.viewOnMap, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, fontFamily: 'monospace')),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
