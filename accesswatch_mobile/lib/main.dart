import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n/app_localizations.dart';
import 'perf.dart';
import 'router.dart';
import 'state/providers.dart';
import 'state/settings_store.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  perfStart();
  WidgetsFlutterBinding.ensureInitialized();
  perfWatchFrames();
  WidgetsBinding.instance.addPostFrameCallback((_) => perfMark('first frame'));
  final prefs = await SharedPreferences.getInstance();
  runApp(ProviderScope(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    child: const AccessWatchApp(),
  ));
}

class AccessWatchApp extends ConsumerStatefulWidget {
  const AccessWatchApp({super.key});

  @override
  ConsumerState<AccessWatchApp> createState() => _AccessWatchAppState();
}

class _AccessWatchAppState extends ConsumerState<AccessWatchApp> {
  late final GoRouter _router = createRouter(safetyAccepted: () => ref.read(safetyAcceptedProvider));

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(settingsPersistenceProvider);
    final appScale = ref.watch(textScaleProvider);
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: _router,
      locale: ref.watch(localeProvider),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        final media = MediaQuery.of(context);
        final combined = (media.textScaler.scale(1) * appScale).clamp(minTextScale, maxTextScale);
        return MediaQuery(
          data: media.copyWith(textScaler: TextScaler.linear(combined)),
          child: child!,
        );
      },
    );
  }
}
