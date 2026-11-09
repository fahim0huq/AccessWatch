import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../state/providers.dart';
import '../theme/app_theme.dart';
import '../utils/labels.dart';

/// Language, text size and presentation mode.
class SettingsCard extends ConsumerWidget {
  const SettingsCard({super.key});

  static const _english = 'en';
  static const _portuguese = 'pt';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);
    final scale = ref.watch(textScaleProvider);
    const label = TextStyle(color: AppColors.ink, fontSize: 14, fontWeight: FontWeight.bold);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.settingsTitle,
              style: const TextStyle(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(l.language, style: label),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final (code, name) in [
                (_english, l.languageEnglish),
                (_portuguese, l.languagePortuguese),
              ])
                ChoiceChip(
                  label: Text(name),
                  selected: locale.languageCode == code,
                  onSelected: (_) => ref.read(localeProvider.notifier).state = Locale(code),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(l.textSize(Fmt.of(context).minutes(scale * 100)), style: label),
          Slider(
            value: scale,
            min: minTextScale,
            max: maxTextScale,
            divisions: 4,
            activeColor: AppColors.accent,
            label: Fmt.of(context).minutes(scale * 100),
            onChanged: (value) => ref.read(textScaleProvider.notifier).state = value,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.presentationMode, style: label),
                    const SizedBox(height: 4),
                    Text(l.presentationModeSubtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                  ],
                ),
              ),
              Switch(
                value: ref.watch(presentationModeProvider),
                onChanged: (value) => ref.read(presentationModeProvider.notifier).state = value,
                activeThumbColor: AppColors.accent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
