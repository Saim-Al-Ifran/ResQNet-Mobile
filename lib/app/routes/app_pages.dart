import 'package:get/get.dart';
import '../../../features/events/presentation/screens/events_feed_screen.dart';
import '../../../features/home/presentation/screens/main_navigation_screen.dart';
import '../../../features/splash/presentation/screens/login_screen.dart';
import '../../../features/splash/presentation/screens/register_screen.dart';
import '../../../features/splash/presentation/screens/welcome_screen.dart';
import '../../features/events/presentation/screens/report_event_screen.dart';
import 'app_routes.dart';

/// Centralized route definitions and page bindings for GetX navigation.
class AppPages {
  AppPages._();

  static const initial = Routes.welcome;

  static final routes = [
    GetPage(
      name: Routes.welcome,
      page: () => const WelcomeScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.register,
      page: () => const RegisterScreen(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: Routes.mainNavigation,
      page: () => const MainNavigationScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.eventsFeed,
      page: () => const EventsFeedScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.reportEvent,
      page: () => const ReportEventScreen(),
    ),
  ];
}
