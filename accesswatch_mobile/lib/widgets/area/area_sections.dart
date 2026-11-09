// The cards of one area: how to reach it, what it lost, and the safest route.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/enums.dart';
import '../../data/models/mission.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import '../../theme/app_theme.dart';
import '../../utils/labels.dart';
import '../ui/kit.dart';
import '../ui/mode_look.dart';

/// The big coloured card: boat or truck, in plain words.
class ModeCard extends StatelessWidget {
  final Mission mission;

  const ModeCard({super.key, required this.mission});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final fmt = Fmt.of(context);
    final text = Theme.of(context).textTheme;
    final m = mission;
    final tone = modeTone(m.accessMode);
    final (title, detail) = switch (m.accessMode) {
      // The data gives the water total and the route total, not where the water starts.
      AccessMode.boat => (l.modeNeedsBoat, l.modeBoatDetail(fmt.km(m.boatLegKm), fmt.km(m.safest.distanceKm))),
      AccessMode.highClearanceTruck => (l.modeTruckTitle, l.modeTruckDetail),
      AccessMode.normalVehicle => (l.modeCarTitle, null),
      AccessMode.onFoot => (l.modeFootTitle, null),
    };
    return AppCard(
      color: tone.tint,
      borderColor: tone.strong,
      borderWidth: 2,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(modeIcon(m.accessMode), size: 36, color: tone.text),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: text.titleLarge!.copyWith(color: tone.text)),
                if (detail != null) ...[
                  const SizedBox(height: 4),
                  Text(detail, style: text.bodyLarge!.copyWith(color: tone.text)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A heading inside a card.
class CardTitle extends StatelessWidget {
  final String text;

  const CardTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Semantics(header: true, child: Text(text, style: Theme.of(context).textTheme.titleMedium)),
      );
}

/// Each lost service and how long it took before the flood. A difficult area
/// lists what became harder to reach instead.
class LostServicesCard extends StatelessWidget {
  final Mission mission;

  const LostServicesCard({super.key, required this.mission});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final fmt = Fmt.of(context);
    final text = Theme.of(context).textTheme;
    final m = mission;
    final cutOff = m.lostServices.isNotEmpty;
    if (!cutOff && m.limitedServices.isEmpty) return const SizedBox.shrink();
    String name(ServiceLink link) => link == ServiceLink.aidDepotLink ? l.serviceDepotLinkPlain : l.serviceLink(link);
    Widget row(ServiceLink link, int? minutes) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(cutOff ? Icons.block_rounded : Icons.warning_amber_rounded,
                  color: cutOff ? AppColors.danger : AppColors.notice),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name(link), style: text.titleSmall),
                    if (minutes != null) Text(l.lostWasMinutes(fmt.count(minutes)), style: text.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        );
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardTitle(cutOff ? l.lostTitle : l.harderTitle),
          if (cutOff)
            for (final lost in m.lostServices) row(lost.service, lost.previousMinutes)
          else
            for (final link in m.limitedServices) row(link, null),
        ],
      ),
    );
  }
}

Tone riskTone(RiskLevel level) => switch (level) {
      RiskLevel.high => Tone.danger,
      RiskLevel.medium => Tone.notice,
      RiskLevel.low => Tone.reach,
    };

String riskChipText(AppLocalizations l, RiskLevel level) => switch (level) {
      RiskLevel.high => l.riskChipHigh,
      RiskLevel.medium => l.riskChipMedium,
      RiskLevel.low => l.riskChipLow,
    };

/// Distance, time, bridges to check and the risk, for the safest route.
class SafestRouteCard extends ConsumerWidget {
  final Mission mission;

  const SafestRouteCard({super.key, required this.mission});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final fmt = Fmt.of(context);
    final text = Theme.of(context).textTheme;
    final r = mission.safest;
    final flags = ref.watch(loadedBundleProvider).manifest.qualityFlags;
    final depotNote = flags.contains(QualityFlag.depotAutoSelected)
        ? l.warnDepotAutoSelected
        : flags.contains(QualityFlag.depotAssumed)
            ? l.routesIllustrativeShort
            : null;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardTitle(l.safestRouteTitle),
          Text(l.routeDistanceTime(fmt.km(r.distanceKm), fmt.minutes(r.timeMin)), style: text.titleLarge),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StatusChip(icon: Icons.speed_rounded, label: riskChipText(l, r.riskLevel), tone: riskTone(r.riskLevel)),
              if (r.uncertainBridges > 0)
                StatusChip(icon: Icons.fort_rounded, label: l.routeCheckBridges(r.uncertainBridges), tone: Tone.notice),
            ],
          ),
          if (depotNote != null) ...[
            const SizedBox(height: 10),
            Text(depotNote, style: text.bodySmall),
          ],
        ],
      ),
    );
  }
}

Tone depthTone(DepthClass depth) => switch (depth) {
      DepthClass.deep => Tone.danger,
      DepthClass.medium => Tone.notice,
      DepthClass.shallow || DepthClass.dry => Tone.reach,
      DepthClass.unknown => Tone.neutral,
    };

/// How deep the water is on the way in: average and highest estimate, the
/// deepest class, and where the numbers come from.
class WaterDepthCard extends StatelessWidget {
  final Mission mission;

  const WaterDepthCard({super.key, required this.mission});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final fmt = Fmt.of(context);
    final text = Theme.of(context).textTheme;
    final m = mission;
    final known = m.meanDepthM != null && m.maxDepthM != null;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardTitle(l.waterDepthTitle),
          Text(
            known ? l.depthAverageLine(fmt.oneDecimal(m.meanDepthM!), fmt.oneDecimal(m.maxDepthM!)) : l.waterDepthUnknown,
            style: text.titleMedium,
          ),
          const SizedBox(height: 10),
          StatusChip(
            icon: Icons.water_rounded,
            label: l.deepestClassChip(l.depthClass(m.maxDepthClass)),
            tone: depthTone(m.maxDepthClass),
          ),
          const SizedBox(height: 10),
          Text(l.depthSourceNote, style: text.bodySmall),
        ],
      ),
    );
  }
}
