import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'l10n/app_localizations.dart';
import 'router.dart';
import 'state/providers.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: AccessWatchApp()));
}

class AccessWatchApp extends ConsumerStatefulWidget {
  const AccessWatchApp({super.key});

  @override
  ConsumerState<AccessWatchApp> createState() => _AccessWatchAppState();
}

class _AccessWatchAppState extends ConsumerState<AccessWatchApp> {
  late final GoRouter _router = createRouter();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appScale = ref.watch(textScaleProvider);
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
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
