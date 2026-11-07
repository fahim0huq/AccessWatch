import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../state/providers.dart';
import '../theme/app_theme.dart';
import '../utils/labels.dart';
import '../widgets/beta_badge.dart';
import '../widgets/quality_banners.dart';
import '../widgets/settings_card.dart';

const _sectionStyle = TextStyle(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'monospace');
const _bodyStyle = TextStyle(color: AppColors.text, fontSize: 12.5, height: 1.4);

class InfoScreen extends ConsumerWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final fmt = Fmt.of(context);
    final bundle = ref.watch(loadedBundleProvider);
    final dates = bundle.manifest.dates;
    final stats = bundle.manifest.stats;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                Expanded(child: Text(l.systemHonestyBrief, style: _sectionStyle.copyWith(fontSize: 12))),
                const BetaBadge(),
              ],
            ),
            const SizedBox(height: 16),
            Text(l.appTitle, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Text(l.appSubtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
            const SizedBox(height: 4),
            Text(l.eventName(bundle.manifest.event), style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
            const SizedBox(height: 24),
            const SettingsCard(),
            const SizedBox(height: 20),
            Text(l.warningsTitle, style: _sectionStyle.copyWith(color: AppColors.warning)),
            const SizedBox(height: 10),
            const QualityBanners(startExpanded: true),
            const SizedBox(height: 14),
            _Card(
              title: l.dataDates,
              children: [
                Text(l.dateNisarBefore(fmt.date(dates.nisarBefore)), style: _bodyStyle),
                Text(l.dateNisarAfter(fmt.date(dates.nisarAfter)), style: _bodyStyle),
                Text(l.dateEmsImage(fmt.date(dates.emsImage)), style: _bodyStyle),
              ],
            ),
            const SizedBox(height: 20),
            _Card(
              title: l.howDepthEstimated,
              children: [
                Text(l.depthDescription, style: _bodyStyle),
                const SizedBox(height: 14),
                _DepthRow(label: l.depthShallow, range: l.depthShallowRange, color: AppColors.floodShallow),
                const Divider(color: AppColors.border, height: 12),
                _DepthRow(label: l.depthMedium, range: l.depthMediumRange, color: AppColors.floodMedium),
                const Divider(color: AppColors.border, height: 12),
                _DepthRow(label: l.depthDeep, range: l.depthDeepRange, color: AppColors.floodDeep),
                const SizedBox(height: 14),
                Text(l.depthEstimateWarning,
                    style: const TextStyle(color: AppColors.warning, fontSize: 11.5, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),
            _Card(
              title: l.waterDepthSummary,
              children: [
                Text(l.kpiDepthSub, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                const SizedBox(height: 12),
                Wrap(
                  alignment: WrapAlignment.spaceAround,
                  spacing: 16,
                  runSpacing: 12,
                  children: [
                    _DepthCount(count: fmt.count(stats.floodedShallow), label: l.depthShallow),
                    _DepthCount(count: fmt.count(stats.floodedMedium), label: l.depthMedium),
                    _DepthCount(count: fmt.count(stats.floodedDeep), label: l.depthDeep),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            _Card(
              title: l.dataSources,
              children: [
                for (final source in bundle.quality.dataSources)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text('• ${source.name}', style: _bodyStyle),
                  ),
                const SizedBox(height: 8),
                Text(l.notAffiliated, style: const TextStyle(color: AppColors.textMuted, fontSize: 11.5)),
              ],
            ),
            const SizedBox(height: 20),
            Text(l.populationIsModelled, style: _bodyStyle),
            const SizedBox(height: 6),
            Text(l.appDisclaimer, style: _bodyStyle.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Card({required this.title, required this.children});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(title, style: _sectionStyle), const SizedBox(height: 10), ...children],
        ),
      );
}

class _DepthRow extends StatelessWidget {
  final String label, range;
  final Color color;

  const _DepthRow({required this.label, required this.range, required this.color});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(Icons.square_rounded, size: 14, color: color),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.bold, fontSize: 12))),
          Text(range, style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 12)),
        ],
      );
}

class _DepthCount extends StatelessWidget {
  final String count, label;

  const _DepthCount({required this.count, required this.label});

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(count,
              style: const TextStyle(color: AppColors.text, fontSize: 24, fontWeight: FontWeight.w900, fontFamily: 'monospace')),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
        ],
      );
}
