import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import '../router.dart';
import '../state/mission_state.dart';
import '../state/providers.dart';
import '../theme/app_theme.dart';
import '../utils/area_groups.dart';
import '../utils/labels.dart';
import '../widgets/help/area_card.dart';
import '../widgets/mission_detail_sections.dart' show showAlertPreview;
import '../widgets/ui/kit.dart';
import '../widgets/ui/look.dart';

/// Help first: every area, most urgent first, in the order the app ranks them
/// (the published ranking, or the user's weights from About > Advanced).
class HelpFirstScreen extends ConsumerStatefulWidget {
  const HelpFirstScreen({super.key});

  @override
  ConsumerState<HelpFirstScreen> createState() => _HelpFirstScreenState();
}

/// Asks which teams the alert is for, then shows the alert before it is sent.
Future<void> showGroupAlertChooser(BuildContext context, WidgetRef ref) async {
  final ranked = ref.read(rankedMissionsProvider);
  final group = await showModalBottomSheet<AreaGroup>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) {
      final l = AppLocalizations.of(sheetContext)!;
      final fmt = Fmt.of(sheetContext);
      Widget option(AreaGroup g, IconData icon, String label) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: BigButton.secondary(icon: icon, label: label, onPressed: () => Navigator.pop(sheetContext, g)),
          );
      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(AppSizes.gutter, 0, AppSizes.gutter, AppSizes.gutter),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l.shareGroupTitle, style: Theme.of(sheetContext).textTheme.titleLarge),
              const SizedBox(height: 16),
              option(AreaGroup.all, Icons.groups_rounded, l.groupAll(fmt.count(AreaGroup.all.of(ranked).length))),
              if (AreaGroup.boat.of(ranked).isNotEmpty)
                option(AreaGroup.boat, Icons.directions_boat_rounded, l.groupBoat(fmt.count(AreaGroup.boat.of(ranked).length))),
              if (AreaGroup.vehicle.of(ranked).isNotEmpty)
                option(AreaGroup.vehicle, Icons.local_shipping_rounded,
                    l.groupVehicle(fmt.count(AreaGroup.vehicle.of(ranked).length))),
            ],
          ),
        ),
      );
    },
  );
  if (group == null || !context.mounted) return;
  final l = AppLocalizations.of(context)!;
  showAlertPreview(
      context, ref, l.groupAlertText(group, ranked, ref.read(loadedBundleProvider).manifest, Fmt.of(context)));
}

class _HelpFirstScreenState extends ConsumerState<HelpFirstScreen> {
  AreaGroup _filter = AreaGroup.all;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final fmt = Fmt.of(context);
    final ranked = ref.watch(rankedMissionsProvider);
    final custom = !ref.watch(priorityWeightsProvider).isPublished;
    final shown = _filter.of(ranked);

    Widget chip(AreaGroup group, String Function(String) label, {IconData? icon}) {
      final count = group.of(ranked).length;
      // Only groups that exist in the data get a chip.
      if (count == 0 && group != AreaGroup.all) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: FilterPill(
          label: label(fmt.count(count)),
          icon: icon,
          selected: _filter == group,
          onTap: () => setState(() => _filter = group),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            ScreenTitle(title: l.helpTitle, subtitle: l.helpSubtitle(ranked.length)),
            // Wrapped, not scrolled sideways, so every chip is in view.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.gutter, vertical: 4),
              child: Wrap(
                runSpacing: 8,
                children: [
                  chip(AreaGroup.all, l.filterAllCount),
                  chip(AreaGroup.boat, l.filterBoatCount, icon: Icons.directions_boat_rounded),
                  chip(AreaGroup.vehicle, l.filterVehicleCount, icon: Icons.local_shipping_rounded),
                  chip(AreaGroup.foot, l.filterFootCount, icon: Icons.directions_walk_rounded),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSizes.gutter, 8, AppSizes.gutter, 0),
              child: BigButton.secondary(
                icon: Icons.campaign_rounded,
                label: l.shareGroupButton,
                onPressed: () => showGroupAlertChooser(context, ref),
              ),
            ),
            if (custom)
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSizes.gutter, 8, AppSizes.gutter, 0),
                child: StatusChip(icon: Icons.tune_rounded, label: l.customWeightsNote, tone: Tone.notice),
              ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.gutter),
              child: Column(
                children: [
                  if (shown.isEmpty) Text(l.noAreasForFilter),
                  for (final r in shown)
                    AreaCard(
                      ranked: r,
                      emphasised: r.rank == 1,
                      onOpen: () => context.go(AppRoutes.area(r.mission.pocketId)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
