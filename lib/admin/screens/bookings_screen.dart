import 'package:flutter/material.dart';
import '../utils/admin_constants.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({Key? key}) : super(key: key);

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
              'Bookings',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1C1E21),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage all property bookings',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF65676B),
              ),
            ),
            const SizedBox(height: 32),
            
            // Bookings List
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
                      'Recent Bookings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1C1E21),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const _BookingItem(
                      propertyName: 'Sunrise Boarding House',
                      guestName: 'John Doe',
                      checkIn: 'Jan 15, 2024',
                      checkOut: 'Jan 30, 2024',
                      status: 'Confirmed',
                    ),
                    const SizedBox(height: 16),
                    const _BookingItem(
                      propertyName: 'Sunset Dormitory',
                      guestName: 'Jane Smith',
                      checkIn: 'Jan 20, 2024',
                      checkOut: 'Feb 5, 2024',
                      status: 'Pending',
                    ),
                    const SizedBox(height: 16),
                    const _BookingItem(
                      propertyName: 'Moonlight Hostel',
                      guestName: 'Robert Johnson',
                      checkIn: 'Jan 10, 2024',
                      checkOut: 'Jan 25, 2024',
                      status: 'Completed',
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

class _BookingItem extends StatelessWidget {
  final String propertyName;
  final String guestName;
  final String checkIn;
  final String checkOut;
  final String status;

  const _BookingItem({
    required this.propertyName,
    required this.guestName,
    required this.checkIn,
    required this.checkOut,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFE4E6EB),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF1877F2),
              borderRadius: BorderRadius.circular(AdminConstants.buttonRadius),
            ),
            child: const Icon(
              Icons.book_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  propertyName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1C1E21),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Guest: $guestName',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF65676B),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(status),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '$checkIn - $checkOut',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF65676B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: Color(0xFF65676B),
            size: 16,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return const Color(0xFF31A24C);
      case 'pending':
        return const Color(0xFFE99537);
      case 'completed':
        return const Color(0xFF1877F2);
      default:
        return const Color(0xFF65676B);
    }
  }
}
