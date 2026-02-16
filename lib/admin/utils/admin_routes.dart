import 'package:flutter/material.dart';
import '../screens/dashboard_screen.dart';
import '../screens/properties_screen.dart';
import '../screens/bookings_screen.dart';
import '../screens/analytics_screen.dart';
import '../screens/settings_screen.dart';

class AdminRoutes {
  static const String dashboard = '/admin/dashboard';
  static const String properties = '/admin/properties';
  static const String bookings = '/admin/bookings';
  static const String analytics = '/admin/analytics';
  static const String settings = '/admin/settings';

  static Map<String, WidgetBuilder> get routes => {
        dashboard: (context) => const DashboardScreen(),
        properties: (context) => const PropertiesScreen(),
        bookings: (context) => const BookingsScreen(),
        analytics: (context) => const AnalyticsScreen(),
        settings: (context) => const SettingsScreen(),
      };
}