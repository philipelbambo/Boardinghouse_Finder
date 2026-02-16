import 'package:flutter/material.dart';
import '../utils/admin_constants.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

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
              'Analytics',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1C1E21),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'View analytics and insights',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF65676B),
              ),
            ),
            const SizedBox(height: 32),
            
            // Charts Section
            const Row(
              children: [
                Expanded(
                  child: _ChartCard(
                    title: 'Monthly Revenue',
                    value: '₱125K',
                    change: '+12.5%',
                    icon: Icons.attach_money,
                    color: Color(0xFF31A24C),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _ChartCard(
                    title: 'Active Users',
                    value: '1,248',
                    change: '+8.2%',
                    icon: Icons.people,
                    color: Color(0xFF1877F2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Expanded(
                  child: _ChartCard(
                    title: 'Bookings',
                    value: '89',
                    change: '+5.7%',
                    icon: Icons.book,
                    color: Color(0xFFE99537),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _ChartCard(
                    title: 'Properties',
                    value: '142',
                    change: '+3.1%',
                    icon: Icons.home,
                    color: Color(0xFFD93025),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // Detailed Analytics
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
                      'Performance Overview',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1C1E21),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const _AnalyticsItem(
                      label: 'Peak Booking Month',
                      value: 'January 2024',
                      icon: Icons.calendar_month,
                    ),
                    const SizedBox(height: 16),
                    const _AnalyticsItem(
                      label: 'Most Popular Property',
                      value: 'Sunrise Boarding House',
                      icon: Icons.star,
                    ),
                    const SizedBox(height: 16),
                    const _AnalyticsItem(
                      label: 'Average Stay Duration',
                      value: '15 days',
                      icon: Icons.timer,
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

class _ChartCard extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final IconData icon;
  final Color color;

  const _ChartCard({
    required this.title,
    required this.value,
    required this.change,
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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF31A24C).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    change,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF31A24C),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1C1E21),
              ),
            ),
            const SizedBox(height: 4),
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

class _AnalyticsItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _AnalyticsItem({
    required this.label,
    required this.value,
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
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF65676B),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C1E21),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
