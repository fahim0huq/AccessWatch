// The white speech card of one tour step: STEP n OF 5, a bold title, one
// sentence, progress dots, and Back / Skip / Next (Done on the last step).
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../state/tour_state.dart';
import '../../theme/app_theme.dart';

(String, String) tourStepText(AppLocalizations l, int step) => switch (step) {
      0 => (l.tourMapTitle, l.tourMapBody),
      1 => (l.tourChipsTitle, l.tourChipsBody),
      2 => (l.tabHelpFirst, l.tourHelpBody),
      3 => (l.tourWatchTitle, l.tourWatchBody),
      _ => (l.tabFindCare, l.tourCareBody),
    };

class TourCard extends StatelessWidget {
  final int step;
  final VoidCallback? onBack;
  final VoidCallback onSkip, onNext;

  const TourCard({super.key, required this.step, this.onBack, required this.onSkip, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final text = Theme.of(context).textTheme;
    final (title, body) = tourStepText(l, step);
    final last = step == tourStepCount - 1;
    return Material(
      key: const ValueKey('tour-card'),
      color: AppColors.surface,
      elevation: 8,
      shadowColor: AppColors.shadow,
      borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 12, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // The words scroll when the card is short of room; the buttons stay.
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(right: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.tourStepOf('${step + 1}', '$tourStepCount'),
                      style: text.labelMedium!.copyWith(
                        color: AppColors.brandText,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Semantics(header: true, child: Text(title, style: text.titleLarge)),
                    const SizedBox(height: 4),
                    Text(body, style: text.bodyLarge),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            ExcludeSemantics(
              child: Row(
                children: [
                  for (var i = 0; i < tourStepCount; i++)
                    Container(
                      width: i == step ? 18 : 8,
                      height: 8,
                      margin: const EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        color: i == step ? AppColors.brand : AppColors.line,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Wrap(
              alignment: WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 4,
              children: [
                if (onBack != null)
                  TextButton(key: const ValueKey('tour-back'), onPressed: onBack, child: Text(l.tourBack)),
                TextButton(key: const ValueKey('tour-skip'), onPressed: onSkip, child: Text(l.tourSkip)),
                FilledButton(
                  key: const ValueKey('tour-next'),
                  autofocus: true,
                  onPressed: onNext,
                  child: Text(last ? l.tourDone : l.tourNext),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
