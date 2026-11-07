import 'package:go_router/go_router.dart';

import 'screens/care_screen.dart';
import 'screens/home_screen.dart';
import 'screens/info_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/map_screen.dart';
import 'screens/mission_detail_screen.dart';
import 'screens/missions_screen.dart';

class AppRoutes {
  static const home = '/home';
  static const map = '/map';
  static const missions = '/missions';
  static const care = '/care';
  static const info = '/info';
}

GoRouter createRouter() => GoRouter(
      initialLocation: AppRoutes.home,
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, shell) => MainNavigationScreen(shell: shell),
          branches: [
            StatefulShellBranch(routes: [
              GoRoute(path: AppRoutes.home, builder: (context, state) => const HomeScreen()),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(path: AppRoutes.map, builder: (context, state) => const MapScreen()),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                path: AppRoutes.missions,
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
            StatefulShellBranch(routes: [
              GoRoute(path: AppRoutes.info, builder: (context, state) => const InfoScreen()),
            ]),
          ],
        ),
      ],
    );
