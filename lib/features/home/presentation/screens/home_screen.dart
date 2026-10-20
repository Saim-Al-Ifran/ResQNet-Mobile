import 'package:flutter/material.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../app/widgets/resqnet_logo.dart';

/// Home Dashboard UI Screen for ResQNet.
/// Located in the presentation layer of the feature-first architecture (`lib/features/home/presentation/screens/`).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Row(
          children: [
            ResQNetLogo(
              size: 26,
              showText: false,
            ),
            SizedBox(width: 10),
            Text(
              'ResQNet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E293B),
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notifications feature coming soon!'),
                ),
              );
            },
            icon: Stack(
              children: [
                const Icon(
                  Icons.notifications_none_rounded,
                  color: Color(0xFF334155),
                  size: 26,
                ),
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryRed,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Header & Safety Message
              _buildWelcomeHeader(),

              const SizedBox(height: 20),

              // Prominent Red SOS Emergency Button
              _buildSosButton(),

              const SizedBox(height: 24),

              // Map Preview Placeholder Card
              _buildMapPreviewCard(),

              const SizedBox(height: 24),

              // Overview Section Title
              const Text(
                'Emergency Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.2,
                ),
              ),

              const SizedBox(height: 12),

              // Summary Cards (Active Events & Nearby Hospitals)
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Active Events',
                      subtitle: '3 Alerts Nearby',
                      icon: Icons.warning_amber_rounded,
                      iconBgColor: AppTheme.primaryRed.withValues(alpha: 0.12),
                      iconColor: AppTheme.primaryRed,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Nearby Hospitals',
                      subtitle: '5 Rescue Units',
                      icon: Icons.local_hospital_rounded,
                      iconBgColor: const Color(0xFF0288D1).withValues(alpha: 0.12),
                      iconColor: const Color(0xFF0288D1),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppTheme.primaryRed,
          unselectedItemColor: const Color(0xFF64748B),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_rounded),
              label: 'Events',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_rounded),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  /// Welcome heading card displaying user branding and safety message
  Widget _buildWelcomeHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Stay Safe, Rescuer 👋',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Stay alert. Real-time disaster reports and community aid resources are available nearby.',
            style: TextStyle(
              fontSize: 13,
              height: 1.45,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  /// Prominent Red SOS Emergency Button
  Widget _buildSosButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [
            AppTheme.primaryRed,
            Color(0xFFB91C1C),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryRed.withValues(alpha: 0.38),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('EMERGENCY SOS Triggered! Nearby responders notified.'),
              backgroundColor: AppTheme.primaryRed,
            ),
          );
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sos_rounded, size: 28, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'EMERGENCY SOS',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Map Preview Card Placeholder
  Widget _buildMapPreviewCard() {
    return Container(
      width: double.infinity,
      height: 170,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF334155)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Tactical grid pattern overlay
          Positioned.fill(
            child: Opacity(
              opacity: 0.12,
              child: CustomPaint(
                painter: _MapGridPainter(),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryRed.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    size: 32,
                    color: AppTheme.primaryRed,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Map preview',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Live map coming soon',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Reusable Summary Card Component
  Widget _buildSummaryCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter to draw a subtle grid pattern for the map placeholder
class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.0;

    const step = 20.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
