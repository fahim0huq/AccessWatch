import 'package:flutter/material.dart';
import '../models/demo_data.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'map_screen.dart';
import 'missions_screen.dart';
import 'info_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  bool _isPresentationMode = false;
  String? _focusPocketId;

  void _navigateToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _focusPocketOnMap(Pocket pocket) {
    setState(() {
      _focusPocketId = pocket.id;
      _currentIndex = 1; // Switch to Map tab
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(onNavigateToTab: _navigateToTab),
      MapScreen(
        key: ValueKey(_focusPocketId ?? 'default_map'),
        initialPocketId: _focusPocketId,
        onNavigateToTab: _navigateToTab,
      ),
      MissionsScreen(onViewOnMap: _focusPocketOnMap),
      InfoScreen(
        isPresentationMode: _isPresentationMode,
        onTogglePresentationMode: (value) {
          setState(() {
            _isPresentationMode = value;
          });
        },
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: _isPresentationMode
          ? null
          : BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _navigateToTab,
              selectedItemColor: AppColors.accent,
              unselectedItemColor: AppColors.textMuted,
              backgroundColor: AppColors.surface,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.grid_view_rounded),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.map_rounded),
                  label: 'Map',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.assignment_rounded),
                  label: 'Missions',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.info_outline_rounded),
                  label: 'Info',
                ),
              ],
            ),
    );
  }
}
