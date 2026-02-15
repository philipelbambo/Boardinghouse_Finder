import 'package:flutter/material.dart';
import '../screens/admin_login_screen.dart';
import '../services/admin_auth_service.dart';

class AdminGuard extends StatelessWidget {
  final Widget child;
  final String? redirectRoute;

  const AdminGuard({
    Key? key,
    required this.child,
    this.redirectRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AdminAuthService.instance.isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasData && snapshot.data == true) {
          // User is logged in, show the protected content
          return child;
        } else {
          // User is not logged in, redirect to login
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(
              context,
              redirectRoute ?? '/admin/login',
            );
          });
          
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}