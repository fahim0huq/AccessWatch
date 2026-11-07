import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import '../router.dart';
import '../state/providers.dart';
import '../theme/app_theme.dart';
import '../widgets/mission_card_detail.dart';

/// The page for one mission, at /missions/:id.
class MissionDetailScreen extends ConsumerWidget {
  final String pocketId;

  const MissionDetailScreen({super.key, required this.pocketId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matches = ref.watch(loadedBundleProvider).missions.where((m) => m.pocketId == pocketId);
    void back() => context.canPop() ? context.pop() : context.go(AppRoutes.missions);
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: matches.isEmpty
            ? Center(
                child: TextButton(
                  onPressed: back,
                  child: Text(AppLocalizations.of(context)!.missionNotFound(pocketId)),
                ),
              )
            : MissionCardDetail(
                mission: matches.first,
                onBack: back,
                onViewOnMap: () {
                  ref.read(selectedPocketIdProvider.notifier).state = pocketId;
                  context.go(AppRoutes.map);
                },
              ),
      ),
    );
  }
}
