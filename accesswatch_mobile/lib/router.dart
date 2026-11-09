import 'package:go_router/go_router.dart';

import 'screens/care_screen.dart';
import 'screens/info_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/map_screen.dart';
import 'screens/mission_detail_screen.dart';
import 'screens/missions_screen.dart';
import 'screens/welcome_screen.dart';

class AppRoutes {
  static const map = '/map';
  static const help = '/help';
  static const care = '/care';
  static const about = '/about';
  static const welcome = '/welcome';

  static String area(String pocketId) => '$help/$pocketId';
}

/// [safetyAccepted] is read on every navigation, so accepting opens the app at once.
GoRouter createRouter({required bool Function() safetyAccepted}) => GoRouter(
      initialLocation: AppRoutes.map,
      redirect: (context, state) =>
          !safetyAccepted() && state.matchedLocation != AppRoutes.welcome ? AppRoutes.welcome : null,
      routes: [
        GoRoute(path: AppRoutes.welcome, builder: (context, state) => const WelcomeScreen()),
        GoRoute(path: AppRoutes.about, builder: (context, state) => const BundleGate(child: InfoScreen())),
        StatefulShellRoute.indexedStack(
          builder: (context, state, shell) => MainNavigationScreen(shell: shell),
          branches: [
            StatefulShellBranch(routes: [
              GoRoute(path: AppRoutes.map, builder: (context, state) => const MapScreen()),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                path: AppRoutes.help,
                builder: (context, state) => const MissionsScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => MissionDetailScreen(pocketId: state.pathParameters['id']!),
                  ),
                ],
              ),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(path: AppRoutes.care, builder: (context, state) => const CareScreen()),
            ]),
          ],
        ),
      ],
    );
