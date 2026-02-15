import 'package:flutter/material.dart';

// Admin Constants
class AdminConstants {
  static const String appName = 'Boardinghouse Finder Admin';
  static const String version = '1.0.0';
  static const String copyright = '© Build by Philip. All rights reserved.';
  
  // Route names
  static const String adminDashboardRoute = '/admin/dashboard';
  static const String adminUsersRoute = '/admin/users';
  static const String adminPropertiesRoute = '/admin/properties';
  static const String adminBookingsRoute = '/admin/bookings';
  static const String adminAnalyticsRoute = '/admin/analytics';
  static const String adminSettingsRoute = '/admin/settings';
  
  // Facebook-inspired Colors
  // Primary - Facebook Blue
  static const Color primaryColor = Color(0xFF1877F2);
  static const Color primaryColorLight = Color(0xFF4A9FF5);
  static const Color primaryColorDark = Color(0xFF0C63D4);
  
  // Background - Light Gray
  static const Color backgroundColor = Color(0xFFF0F2F5);
  
  // Card - Pure White
  static const Color cardColor = Color(0xFFFFFFFF);
  
  // Text Colors
  static const Color textColor = Color(0xFF1C1E21);           // Dark Gray - Main text
  static const Color textSecondaryColor = Color(0xFF65676B);  // Light Gray - Secondary text
  static const Color textTertiaryColor = Color(0xFF8A8D91);   // Even lighter gray
  
  // Border and Divider
  static const Color borderColor = Color(0xFFDCDEE2);
  static const Color dividerColor = Color(0xFFE4E6EB);
  
  // Status Colors
  static const Color successColor = Color(0xFF31A24C);
  static const Color warningColor = Color(0xFFE99537);
  static const Color errorColor = Color(0xFFD93025);
  static const Color infoColor = Color(0xFF1877F2);
  
  // Hover and Active States
  static const Color hoverColor = Color(0xFFF2F3F5);
  static const Color activeColor = Color(0xFFE7F3FF);
  static const Color selectedColor = Color(0xFFE7F3FF);
  
  // Dimensions
  static const double sidebarWidth = 280.0;
  static const double sidebarCollapsedWidth = 70.0;
  static const double headerHeight = 64.0;
  static const double footerHeight = 56.0;
  static const double standardPadding = 16.0;
  static const double largePadding = 24.0;
  static const double smallPadding = 8.0;
  static const double cardRadius = 8.0;
  static const double buttonRadius = 6.0;
  
  // Spacing (following Facebook's generous spacing)
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;
  
  // Typography Sizes
  static const double fontSizeXs = 12.0;
  static const double fontSizeSm = 13.0;
  static const double fontSizeMd = 15.0;
  static const double fontSizeLg = 17.0;
  static const double fontSizeXl = 20.0;
  static const double fontSizeXxl = 24.0;
  static const double fontSizeXxxl = 28.0;
  
  // Icon Sizes
  static const double iconSizeSm = 16.0;
  static const double iconSizeMd = 20.0;
  static const double iconSizeLg = 24.0;
  static const double iconSizeXl = 32.0;
  
  // Elevation/Shadow
  static const double cardElevation = 0.0; // Facebook uses soft shadows, not material elevation
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 150);
  static const Duration mediumAnimation = Duration(milliseconds: 250);
  static const Duration longAnimation = Duration(milliseconds: 400);
}

// Admin permissions and roles
class AdminRoles {
  static const String superAdmin = 'super_admin';
  static const String admin = 'admin';
  static const String manager = 'manager';
  static const String staff = 'staff';
  
  // Role display names
  static const Map<String, String> roleDisplayNames = {
    superAdmin: 'Super Admin',
    admin: 'Admin',
    manager: 'Manager',
    staff: 'Staff',
  };
  
  // Role colors for badges
  static const Map<String, Color> roleColors = {
    superAdmin: AdminConstants.errorColor,
    admin: AdminConstants.primaryColor,
    manager: AdminConstants.successColor,
    staff: AdminConstants.textSecondaryColor,
  };
}

class AdminPermissions {
  static const String viewDashboard = 'view_dashboard';
  static const String manageUsers = 'manage_users';
  static const String manageProperties = 'manage_properties';
  static const String manageBookings = 'manage_bookings';
  static const String viewAnalytics = 'view_analytics';
  static const String manageSettings = 'manage_settings';
  
  // Permission display names
  static const Map<String, String> permissionDisplayNames = {
    viewDashboard: 'View Dashboard',
    manageUsers: 'Manage Users',
    manageProperties: 'Manage Properties',
    manageBookings: 'Manage Bookings',
    viewAnalytics: 'View Analytics',
    manageSettings: 'Manage Settings',
  };
  
  // Permission icons
  static const Map<String, IconData> permissionIcons = {
    viewDashboard: Icons.dashboard_outlined,
    manageUsers: Icons.people_outline,
    manageProperties: Icons.home_outlined,
    manageBookings: Icons.event_note_outlined,
    viewAnalytics: Icons.analytics_outlined,
    manageSettings: Icons.settings_outlined,
  };
}

// Status badges configuration
class StatusConfig {
  static const Map<String, Color> statusColors = {
    'active': AdminConstants.successColor,
    'inactive': AdminConstants.textSecondaryColor,
    'pending': AdminConstants.warningColor,
    'blocked': AdminConstants.errorColor,
    'verified': AdminConstants.primaryColor,
  };
  
  static const Map<String, String> statusLabels = {
    'active': 'Active',
    'inactive': 'Inactive',
    'pending': 'Pending',
    'blocked': 'Blocked',
    'verified': 'Verified',
  };
}