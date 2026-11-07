import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/enums.dart';
import '../l10n/app_localizations.dart';
import '../state/providers.dart';
import '../theme/app_theme.dart';
import '../utils/labels.dart';

/// One warning banner for every true flag in `manifest.quality_flags`.
/// Each shows a short statement and opens to the full text. With
/// [startExpanded] every banner begins open.
class QualityBanners extends ConsumerWidget {
  final bool startExpanded;
  final EdgeInsetsGeometry padding;

  const QualityBanners({super.key, this.startExpanded = false, this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flags = ref.watch(loadedBundleProvider).manifest.qualityFlags;
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final flag in QualityFlag.values)
            if (flags.contains(flag))
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: _Banner(flag: flag, startExpanded: startExpanded),
              ),
        ],
      ),
    );
  }
}

class _Banner extends ConsumerStatefulWidget {
  final QualityFlag flag;
  final bool startExpanded;

  const _Banner({required this.flag, required this.startExpanded});

  @override
  ConsumerState<_Banner> createState() => _BannerState();
}

class _BannerState extends ConsumerState<_Banner> {
  late bool _open = widget.startExpanded;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final bundle = ref.watch(loadedBundleProvider);
    final full = l.warningFull(widget.flag, bundle.manifest, bundle.quality, Fmt.of(context));
    return Semantics(
      button: true,
      expanded: _open,
      hint: l.warningExpandHint,
      child: Material(
        color: AppColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => setState(() => _open = !_open),
          child: Container(
            constraints: const BoxConstraints(minHeight: 48),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l.warningShort(widget.flag),
                        style: const TextStyle(color: AppColors.warning, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      if (_open) ...[
                        const SizedBox(height: 4),
                        Text(full, style: const TextStyle(color: AppColors.text, fontSize: 12, height: 1.35)),
                      ],
                    ],
                  ),
                ),
                Icon(_open ? Icons.expand_less_rounded : Icons.expand_more_rounded, color: AppColors.warning, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
