// Cards of the Watch screen: an event with data, the picked box, and the
// empty live list.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/watch_event.dart';
import '../../l10n/app_localizations.dart';
import '../../router.dart';
import '../../state/providers.dart';
import '../../state/watch_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/labels.dart';
import '../ui/kit.dart';
import '../ui/look.dart';

String eventKindWords(AppLocalizations l, EventKind kind) => switch (kind) {
  EventKind.flood => l.watchKindFlood,
  EventKind.cycloneFlooding => l.watchKindCyclone,
};

/// Watch [event] and show it on the Map.
void goWatch(BuildContext context, WidgetRef ref, WatchEvent event) {
  watchEvent(ref, event);
  context.go(AppRoutes.map);
}

/// An event with satellite data: name, kind, scene dates, and Watch this area.
class EventCard extends ConsumerWidget {
  final WatchEvent event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final fmt = Fmt.of(context);
    final text = Theme.of(context).textTheme;
    final dates = ref.watch(loadedBundleProvider).manifest.dates;
    final watching = ref.watch(watchedEventProvider)?.id == event.id;
    return AppCard(
      key: ValueKey('event-card-${event.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const IconTile(icon: Icons.water_rounded, tone: Tone.flood),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event.name(Localizations.localeOf(context).languageCode), style: text.titleMedium),
                    const SizedBox(height: 2),
                    Text(eventKindWords(l, event.kind), style: text.bodyMedium),
                    Text(l.eventScenes(fmt.date(dates.nisarBefore), fmt.date(dates.nisarAfter)), style: text.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StatusChip(icon: Icons.check_circle_rounded, label: l.dataAvailable, tone: Tone.reach),
              if (watching) StatusChip(icon: Icons.visibility_rounded, label: l.watchingNow, tone: Tone.brand),
            ],
          ),
          const SizedBox(height: 12),
          BigButton(
            icon: Icons.satellite_alt_rounded,
            label: l.watchThisArea,
            onPressed: () => goWatch(context, ref, event),
          ),
        ],
      ),
    );
  }
}

/// The box picked on the map: watch it if it has data, or go to the event that has.
class SelectionResultCard extends ConsumerWidget {
  const SelectionResultCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final box = ref.watch(watchSelectionProvider);
    final available = ref.watch(availableEventsProvider);
    if (box == null || available.isEmpty) return const SizedBox.shrink();
    final l = AppLocalizations.of(context)!;
    final lang = Localizations.localeOf(context).languageCode;
    final text = Theme.of(context).textTheme;
    final match = eventForSelection(box, available, ref.watch(loadedBundleProvider).manifest);
    final event = match ?? available.first;
    return AppCard(
      key: ValueKey(match != null ? 'selection-has-data' : 'selection-no-data'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconTile(icon: Icons.crop_free_rounded, tone: match != null ? Tone.brand : Tone.notice),
              const SizedBox(width: 14),
              Expanded(child: Text(l.selectionTitle, style: text.titleMedium)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            match != null ? l.selectionHasData(event.name(lang)) : l.selectionNoData(event.name(lang)),
            style: text.bodyMedium,
          ),
          const SizedBox(height: 12),
          BigButton(
            icon: match != null ? Icons.satellite_alt_rounded : Icons.arrow_forward_rounded,
            label: match != null ? l.watchThisArea : l.goToEvent(event.name(lang)),
            onPressed: () {
              ref.read(watchSelectionProvider.notifier).state = null;
              goWatch(context, ref, event);
            },
          ),
        ],
      ),
    );
  }
}

/// No live feed is connected: say so plainly.
class LiveEventsEmpty extends StatelessWidget {
  const LiveEventsEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return AppCard(
      key: const ValueKey('live-events-empty'),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const IconTile(icon: Icons.cloud_off_rounded, tone: Tone.neutral),
          const SizedBox(width: 14),
          Expanded(child: Text(l.liveEventsEmpty, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
