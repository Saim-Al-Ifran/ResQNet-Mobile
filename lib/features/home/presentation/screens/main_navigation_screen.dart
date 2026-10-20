
import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../events/presentation/screens/events_feed_screen.dart';
import '../../../events/presentation/screens/report_event_screen.dart';

class MainNavigationScreen extends StatefulWidget {

  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 1;

  final List<Widget> _screens = const [
    _PlaceholderScreen(
      icon: Icons.map_outlined,
      title: 'Disaster Map',
      message: 'Live disaster map will be added here.',
    ),
    EventsFeedScreen(),
    ReportEventScreen(),
    _PlaceholderScreen(
      icon: Icons.local_hospital_outlined,
      title: 'Nearby Hospitals',
      message: 'Nearby hospitals will appear here.',
    ),
    _PlaceholderScreen(
      icon: Icons.person_outline_rounded,
      title: 'Your Profile',
      message: 'Profile and event history will be added here.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map_rounded),
            label: 'Map',
          ),
          const NavigationDestination(
            icon: Icon(Icons.dynamic_feed_outlined),
            selectedIcon: Icon(Icons.dynamic_feed_rounded),
            label: 'Events',
          ),
          NavigationDestination(
            icon: const Icon(Icons.add_location_alt_outlined),
            selectedIcon: const Icon(Icons.add_location_alt_rounded),
            label: 'Report',
          ),
          const NavigationDestination(
            icon: Icon(Icons.local_hospital_outlined),
            selectedIcon: Icon(Icons.local_hospital_rounded),
            label: 'Hospitals',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      appBar: AppBar(
        title: const Text(
          'ResQNet',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppTheme.lightBackground,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 64,
                color: AppTheme.primaryRed,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
