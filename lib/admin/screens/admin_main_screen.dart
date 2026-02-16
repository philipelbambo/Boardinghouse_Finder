import 'package:flutter/material.dart';
import '../admin_layout.dart';
import '../screens/dashboard_screen.dart';
import '../screens/properties_screen.dart';
import '../screens/bookings_screen.dart';
import '../screens/analytics_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/profile_screen.dart';
import '../widgets/admin_guard.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({Key? key}) : super(key: key);

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  String _currentRoute = '/admin/dashboard';
  Widget _currentScreen = const DashboardScreen();

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: _getTitle(),
      child: _currentScreen,
      currentRoute: _currentRoute,
      menuItems: _getDefaultMenuItems(),
      onMenuItemSelected: (String route) {
        setState(() {
          _currentRoute = route;
          _currentScreen = _getScreenByRoute(route);
        });
      },
    );
  }

  Widget _getScreenByRoute(String route) {
    switch (route) {
      case '/admin/dashboard':
        return const DashboardScreen();
      case '/admin/properties':
        return const PropertiesScreen();
      case '/admin/bookings':
        return const BookingsScreen();
      case '/admin/analytics':
        return const AnalyticsScreen();
      case '/admin/settings':
        return const SettingsScreen();
      case '/admin/profile':
        return const ProfileScreen();
      default:
        return const DashboardScreen();
    }
  }

  String _getTitle() {
    switch (_currentRoute) {
      case '/admin/dashboard':
        return 'Admin Dashboard';
      case '/admin/properties':
        return 'Properties';
      case '/admin/bookings':
        return 'Bookings';
      case '/admin/analytics':
        return 'Analytics';
      case '/admin/settings':
        return 'Settings';
      case '/admin/profile':
        return 'Profile';
      default:
        return 'Admin Dashboard';
    }
  }

  List<AdminMenuItem> _getDefaultMenuItems() {
    return [
      AdminMenuItem(
        title: 'Dashboard',
        icon: Icons.dashboard,
        route: '/admin/dashboard',
      ),
      AdminMenuItem(
        title: 'Users',
        icon: Icons.people,
        route: '/admin/users',
      ),
      AdminMenuItem(
        title: 'Properties',
        icon: Icons.home,
        route: '/admin/properties',
      ),
      AdminMenuItem(
        title: 'Bookings',
        icon: Icons.book,
        route: '/admin/bookings',
      ),
      AdminMenuItem(
        title: 'Analytics',
        icon: Icons.analytics,
        route: '/admin/analytics',
      ),
    ];
  }
}