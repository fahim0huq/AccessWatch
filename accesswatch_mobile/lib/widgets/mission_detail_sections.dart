// Service access, priority terms, the ground checklist and the share dialog.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mission_ranking.dart';
import '../data/models/enums.dart';
import '../data/models/mission.dart';
import '../data/verify_notes.dart';
import '../l10n/app_localizations.dart';
import '../state/mission_state.dart';
import '../state/providers.dart';
import '../theme/app_theme.dart';
import '../utils/labels.dart';
import '../utils/mission_text.dart';

const _section = TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'monospace');

/// Whether each service can be reached, with an icon as well as a word.
class ServiceAccessSection extends StatelessWidget {
  final Mission mission;

  const ServiceAccessSection({super.key, required this.mission});

  (IconData, Color) _look(ServiceAccess access) => switch (access) {
        ServiceAccess.yes => (Icons.check_circle_rounded, AppColors.safestRoute),
        ServiceAccess.difficult => (Icons.warning_amber_rounded, AppColors.warning),
        ServiceAccess.no => (Icons.cancel_rounded, AppColors.highRisk),
        ServiceAccess.notApplicable => (Icons.remove_circle_outline_rounded, AppColors.textMuted),
      };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final fmt = Fmt.of(context);
    int? minutes(ServiceLink link) {
      for (final lost in mission.lostServices) {
        if (lost.service == link) return lost.previousMinutes;
      }
      return null;
    }

    Widget row(ServiceLink link, ServiceAccess access) {
      final (icon, color) = _look(access);
      final before = minutes(link);
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Expanded(
              child: Text.rich(TextSpan(children: [
                TextSpan(text: '${l.serviceLink(link)}: ', style: const TextStyle(color: AppColors.text, fontSize: 12.5)),
                TextSpan(text: l.serviceAccess(access), style: TextStyle(color: color, fontSize: 12.5, fontWeight: FontWeight.bold)),
                if (before != null)
                  TextSpan(
                    text: ' ${l.accessWasMinutes(fmt.count(before))}',
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 11.5),
                  ),
              ])),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.serviceAccessTitle, style: _section),
        const SizedBox(height: 8),
        row(ServiceLink.clinic, mission.clinic),
        row(ServiceLink.market, mission.market),
        row(ServiceLink.shelter, mission.shelter),
        row(ServiceLink.aidDepotLink, mission.aidDepot),
      ],
    );
  }
}

/// The three terms behind the rank, as they are in the data.
class PriorityTermsSection extends StatelessWidget {
  final Mission mission;

  const PriorityTermsSection({super.key, required this.mission});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final fmt = Fmt.of(context);
    final t = mission.priorityTerms;
    Widget term(String label, double value) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              Expanded(child: Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 12))),
              Text(fmt.term(value), style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'monospace')),
            ],
          ),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.priorityTermsTitle, style: _section),
        const SizedBox(height: 8),
        term(l.weightPeople, t.popNorm),
        term(l.weightServiceLoss, t.serviceLossNorm),
        term(l.weightDifficulty, t.difficultyNorm),
      ],
    );
  }
}

/// What to confirm on the ground. Ticks last for this session.
class VerifyChecklist extends ConsumerWidget {
  final Mission mission;

  const VerifyChecklist({super.key, required this.mission});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final fmt = Fmt.of(context);
    final checked = ref.watch(verifyChecksProvider)[mission.pocketId] ?? const <VerifyNoteKind>{};
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.verifyTitle, style: _section),
        const SizedBox(height: 4),
        Material(
          type: MaterialType.transparency,
          child: Column(
            children: [
              for (final note in verifyNotesFor(mission))
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: AppColors.accent,
                  value: checked.contains(note.kind),
                  onChanged: (value) =>
                      ref.read(verifyChecksProvider.notifier).set(mission.pocketId, note.kind, value ?? false),
                  title: Text(l.verifyNote(note, fmt), style: const TextStyle(color: AppColors.text, fontSize: 12.5, height: 1.35)),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Shows the alert before it is sent, and offers Copy where sharing is not available.
void showAlertDialog(BuildContext context, WidgetRef ref, RankedMission ranked) {
  final l = AppLocalizations.of(context)!;
  final text = l.alertText(
    ranked,
    ref.read(priorityWeightsProvider),
    ref.read(loadedBundleProvider).manifest,
    Fmt.of(context),
  );
  showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(l.alertTitle, style: const TextStyle(color: Colors.white, fontSize: 16)),
      content: SingleChildScrollView(
        child: SelectableText(text, style: const TextStyle(color: AppColors.text, fontSize: 13, height: 1.4)),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(l.close)),
        TextButton(
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: text));
            if (dialogContext.mounted) Navigator.pop(dialogContext);
          },
          child: Text(l.alertCopy),
        ),
        FilledButton.icon(
          onPressed: () {
            Navigator.pop(dialogContext);
            ref.read(alertSharerProvider)(text);
          },
          icon: const Icon(Icons.share_rounded, size: 16),
          label: Text(l.shareAlert),
        ),
      ],
    ),
  );
}
