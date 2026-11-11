import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/models/watch_event.dart';
import '../l10n/app_localizations.dart';
import '../router.dart';
import '../state/watch_state.dart';
import '../theme/app_theme.dart';
import '../widgets/ui/kit.dart';
import '../widgets/watch/watch_cards.dart';

/// Watch an area: the events that have satellite data, picking an area on the
/// map, and the (empty) list of live events. No network calls.
class WatchScreen extends ConsumerStatefulWidget {
  const WatchScreen({super.key});

  @override
  ConsumerState<WatchScreen> createState() => _WatchScreenState();
}

class _WatchScreenState extends ConsumerState<WatchScreen> {
  late final _search = TextEditingController(text: ref.read(watchQueryProvider));

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final text = Theme.of(context).textTheme;
    final kind = ref.watch(watchKindProvider);
    final query = ref.watch(watchQueryProvider);
    final available = ref.watch(availableEventsProvider);
    final shown = filterEvents(available, kind, query);
    Widget heading(String words) => Padding(
      padding: const EdgeInsets.fromLTRB(4, 18, 4, 10),
      child: Semantics(header: true, child: Text(words, style: text.titleLarge)),
    );
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            ScreenTitle(title: l.watchTitle, subtitle: l.watchSubtitle),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.gutter),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 4),
                  KindSwitch(selected: kind, onSelect: (k) => ref.read(watchKindProvider.notifier).state = k),
                  const SizedBox(height: 8),
                  Text(l.watchKindNote, style: text.bodySmall),
                  const SizedBox(height: 14),
                  TextField(
                    key: const ValueKey('watch-search'),
                    controller: _search,
                    onChanged: (v) => ref.read(watchQueryProvider.notifier).state = v,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: l.watchSearchHint,
                      prefixIcon: const Icon(Icons.search_rounded),
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSizes.button / 2),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  BigButton.secondary(
                    icon: Icons.crop_free_rounded,
                    label: l.watchSelectOnMap,
                    onPressed: () {
                      ref.read(watchSelectionProvider.notifier).state = null;
                      ref.read(mapSelectingProvider.notifier).state = true;
                      context.go(AppRoutes.map);
                    },
                  ),
                  const SizedBox(height: 12),
                  const SelectionResultCard(),
                  heading(l.watchAvailableTitle),
                  for (final e in shown) EventCard(event: e),
                  if (shown.isEmpty)
                    AppCard(
                      key: const ValueKey('available-empty'),
                      child: Text(
                        query.trim().isEmpty ? l.watchNoneOfKind : l.watchSearchNone(query.trim()),
                        style: text.bodyMedium,
                      ),
                    ),
                  heading(l.liveEventsTitle),
                  const LiveEventsEmpty(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
