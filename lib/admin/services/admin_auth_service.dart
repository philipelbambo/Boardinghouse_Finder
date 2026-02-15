import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class AdminAuthService {
  static const String _adminTokenKey = 'admin_token';
  static const String _adminRoleKey = 'admin_role';
  static const String _isAdminLoggedInKey = 'is_admin_logged_in';

  // Simulated admin user data
  static const String _defaultAdminEmail = 'admin@boardinghouse.com';
  static const String _defaultAdminPassword = 'admin123';

  static AdminAuthService? _instance;
  static AdminAuthService get instance => _instance ??= AdminAuthService._();

  AdminAuthService._();

  Future<bool> login(String email, String password) async {
    // In a real app, this would be an API call
    if (email == _defaultAdminEmail && password == _defaultAdminPassword) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_adminTokenKey, 'mock_admin_token_${DateTime.now().millisecondsSinceEpoch}');
      await prefs.setString(_adminRoleKey, 'admin');
      await prefs.setBool(_isAdminLoggedInKey, true);
      
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_adminTokenKey);
    await prefs.remove(_adminRoleKey);
    await prefs.setBool(_isAdminLoggedInKey, false);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isAdminLoggedInKey) ?? false;
  }

  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_adminRoleKey);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_adminTokenKey);
  }

  // Check if user has specific permission
  Future<bool> hasPermission(String permission) async {
    final role = await getRole();
    if (role == null) return false;

    // Define role-based permissions
    switch (role) {
      case 'super_admin':
        return true; // Super admin has all permissions
      case 'admin':
        // Admin has most permissions except some critical ones
        return permission != 'critical_system_operation';
      case 'manager':
        // Manager has limited permissions
        return ['view_dashboard', 'manage_users', 'manage_properties'].contains(permission);
      case 'staff':
        // Staff has basic permissions
        return ['view_dashboard', 'view_basic_data'].contains(permission);
      default:
        return false;
    }
  }
}