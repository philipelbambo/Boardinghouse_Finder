import 'package:flutter/material.dart';
import '../screens/admin_login_screen.dart';
import '../services/admin_auth_service.dart';

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
    return FutureBuilder<bool>(
      future: AdminAuthService.instance.isLoggedIn(),
      builder: (context, snapshot) {
        bool isAdminAuthenticated = snapshot.data ?? false;

        if (!isAdminAuthenticated && redirectRoute != null) {
          // Redirect to login if not authenticated
          if (snapshot.connectionState == ConnectionState.done) {
            Future.microtask(() {
              Navigator.of(context).pushReplacementNamed(redirectRoute!);
            });
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        }

        // Show loading indicator while checking authentication
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return child;
      },
    );
  }
}