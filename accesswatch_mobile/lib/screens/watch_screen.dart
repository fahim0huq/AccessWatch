import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../widgets/ui/kit.dart';

/// Watch an area: which events have satellite data, and picking an area to watch.
class WatchScreen extends StatelessWidget {
  const WatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [ScreenTitle(title: l.watchTitle)],
        ),
      ),
    );
  }
}
