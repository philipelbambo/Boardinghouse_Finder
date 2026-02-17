import 'package:flutter/material.dart';
import 'lib/admin/screens/admin_main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sidebar Toggle Test',
      home: const AdminMainScreen(),
    );
  }
}