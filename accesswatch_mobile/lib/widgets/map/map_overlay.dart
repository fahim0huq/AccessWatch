// What floats on the Map tab: the name pill, legend chips, buttons, the summary
// card and the small sheet for a tapped area.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/enums.dart';
import '../../l10n/app_localizations.dart';
import '../../router.dart';
import '../../state/mission_state.dart';
import '../../state/providers.dart';
import '../../theme/app_theme.dart';
import '../../utils/labels.dart';
import '../ui/kit.dart';
import '../ui/mode_look.dart';

class MapBrandPill extends StatelessWidget {
  const MapBrandPill({super.key});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.button / 2),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.water_rounded, color: AppColors.brand, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(AppLocalizations.of(context)!.appName,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(color: AppColors.brand)),
            ),
          ],
        ),
      );
}

/// Flooded, Needs a boat, Truck can reach: the three things the map draws by default.
class MapLegendChips extends StatelessWidget {
  const MapLegendChips({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        LegendChip(color: mapFloodColor, label: l.legendFlooded),
        LegendChip(color: modeMapColor(AccessMode.boat), label: l.modeNeedsBoat),
        LegendChip(color: modeMapColor(AccessMode.highClearanceTruck), label: l.modeTruckCanReach),
      ],
    );
  }
}

/// A round 48 dp map button with a tooltip that names it.
class MapRoundButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const MapRoundButton({super.key, required this.icon, required this.tooltip, required this.onPressed});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 8),
        child: IconButton.filled(
          tooltip: tooltip,
          onPressed: onPressed,
          style: IconButton.styleFrom(
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.ink,
            side: const BorderSide(color: AppColors.line),
            minimumSize: const Size(AppSizes.tap, AppSizes.tap),
          ),
          icon: Icon(icon),
        ),
      );
}

/// The one-glance answer under the map: how many areas, how many people, and
/// where to go next. Every number comes from the bundle.
class MapSummaryCard extends ConsumerWidget {
  const MapSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final fmt = Fmt.of(context);
    final text = Theme.of(context).textTheme;
    final bundle = ref.watch(loadedBundleProvider);
    final stats = bundle.manifest.stats;
    final places = {for (final m in bundle.missions) m.nearestPlace}.toList()..sort();
    final preliminary = bundle.manifest.qualityFlags.isNotEmpty;
    final date = fmt.date(bundle.manifest.dates.nisarAfter);
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.cardRadius)),
        boxShadow: [BoxShadow(color: Color(0x22000000), blurRadius: 12, offset: Offset(0, -2))],
      ),
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.5),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(AppSizes.gutter, 18, AppSizes.gutter, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l.mapAreasCutOff(stats.pockets), style: text.headlineSmall),
            const SizedBox(height: 4),
            Text(l.mapPeopleNear(fmt.count(roundForDisplay(stats.populationEstimate)), l.placeList(places)),
                style: text.bodyLarge!.copyWith(color: AppColors.inkSecondary)),
            const SizedBox(height: 14),
            BigButton(
              icon: Icons.volunteer_activism_rounded,
              label: l.seeWhoNeedsHelp,
              onPressed: () => context.go(AppRoutes.help),
            ),
            const SizedBox(height: 4),
            InkWell(
              onTap: () => context.push(AppRoutes.about),
              borderRadius: BorderRadius.circular(AppSizes.chipRadius),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: AppSizes.tap),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(color: AppColors.boat, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(preliminary ? l.mapPreliminary(date) : l.mapSnapshot(date), style: text.bodySmall),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A tapped area: name, people, how to reach it, and Open.
void showAreaSheet(BuildContext context, WidgetRef ref, String pocketId) {
  final ranked = ref.read(rankedMissionsProvider).firstWhere((r) => r.mission.pocketId == pocketId);
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) {
      final l = AppLocalizations.of(sheetContext)!;
      final text = Theme.of(sheetContext).textTheme;
      final m = ranked.mission;
      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(AppSizes.gutter, 0, AppSizes.gutter, AppSizes.gutter),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  RankCircle(rank: ranked.rank, tone: modeTone(m.accessMode)),
                  const SizedBox(width: 12),
                  Expanded(child: Text(l.missionTitle(m), style: text.titleLarge)),
                ],
              ),
              const SizedBox(height: 8),
              Text(l.populationEstimate(Fmt.of(sheetContext).count(m.population)), style: text.bodyLarge),
              const SizedBox(height: 10),
              ModeChip(mode: m.accessMode),
              const SizedBox(height: 16),
              BigButton(
                icon: Icons.arrow_forward_rounded,
                label: l.openArea,
                onPressed: () {
                  Navigator.pop(sheetContext);
                  context.go(AppRoutes.area(m.pocketId));
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
