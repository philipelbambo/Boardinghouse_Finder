import 'package:flutter/material.dart';
import '../utils/admin_constants.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1C1E21),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Welcome to the admin dashboard',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF65676B),
              ),
            ),
            const SizedBox(height: 32),
            
            // Stats Cards
            const Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Total Properties',
                    value: '142',
                    icon: Icons.home_outlined,
                    color: Color(0xFF1877F2),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _StatCard(
                    title: 'Active Bookings',
                    value: '89',
                    icon: Icons.book_outlined,
                    color: Color(0xFF31A24C),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Total Users',
                    value: '1,248',
                    icon: Icons.people_outlined,
                    color: Color(0xFFE99537),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _StatCard(
                    title: 'Revenue',
                    value: '₱245K',
                    icon: Icons.attach_money_outlined,
                    color: Color(0xFFD93025),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // Recent Activity
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AdminConstants.cardRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recent Activity',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1C1E21),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const _ActivityItem(
                      title: 'New property listing added',
                      time: '2 hours ago',
                      icon: Icons.add_circle_outline,
                    ),
                    const SizedBox(height: 12),
                    const _ActivityItem(
                      title: 'Booking confirmed for Room 101',
                      time: '5 hours ago',
                      icon: Icons.check_circle_outline,
                    ),
                    const SizedBox(height: 12),
                    const _ActivityItem(
                      title: 'New user registered',
                      time: '1 day ago',
                      icon: Icons.person_add_outlined,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AdminConstants.cardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1C1E21),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF65676B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final String title;
  final String time;
  final IconData icon;

  const _ActivityItem({
    required this.title,
    required this.time,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF1877F2),
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1C1E21),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF65676B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
