import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

/// Top bar of the mission detail and of the map's sheets: back, and when given,
/// share and show on map. In a sheet it also has a drag handle.
class MissionCardHeader extends StatelessWidget {
  final VoidCallback? onViewOnMap, onShare;

  /// Set on a full page; without it, back closes the sheet.
  final VoidCallback? onBack;

  const MissionCardHeader({super.key, this.onViewOnMap, this.onShare, this.onBack});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (onBack == null) ...[
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 10),
          ],
          Wrap(
            spacing: 8,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              TextButton.icon(
                onPressed: onBack ?? () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_rounded, size: 14, color: AppColors.accent),
                label: Text(l.back, style: const TextStyle(color: AppColors.accent, fontSize: 13, fontWeight: FontWeight.bold)),
              ),
              if (onShare != null)
                OutlinedButton.icon(
                  onPressed: onShare,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accent,
                    side: const BorderSide(color: AppColors.accent),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.share_rounded, size: 15),
                  label: Text(l.shareAlert, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900)),
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
                  label: Text(l.viewOnMap, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
