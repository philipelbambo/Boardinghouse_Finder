import 'package:flutter/material.dart';
import '../admin_layout.dart';
import 'dashboard/dashboard_screen.dart';
import '../widgets/admin_guard.dart';

class AdminMainScreen extends StatelessWidget {
  const AdminMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Admin Dashboard',
      child: const DashboardScreen(),
      currentRoute: '/admin/dashboard',
    );
  }
}