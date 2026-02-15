import 'package:flutter/material.dart';
import 'screens/admin_main_screen.dart';
import 'utils/admin_theme.dart';

class AdminApp extends StatelessWidget {
  const AdminApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '© Build by Philip. All rights reserved.',
      theme: AdminTheme.theme,
      home: const AdminMainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}