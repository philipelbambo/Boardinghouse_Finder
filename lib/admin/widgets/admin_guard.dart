import 'package:flutter/material.dart';
import '../screens/admin_login_screen.dart';

class AdminGuard extends StatelessWidget {
  final Widget child;
  final String? redirectRoute;

  const AdminGuard({
    Key? key,
    required this.child,
    this.redirectRoute = '/admin/login',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // In a real app, you would check for admin authentication here
    // For now, we'll just pass through to demonstrate the structure
    bool isAdminAuthenticated = true; // This would be determined by your auth logic

    if (!isAdminAuthenticated && redirectRoute != null) {
      // Redirect to login if not authenticated
      Future.microtask(() {
        Navigator.of(context).pushReplacementNamed(redirectRoute!);
      });
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return child;
  }
}