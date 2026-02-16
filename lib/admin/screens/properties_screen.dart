import 'package:flutter/material.dart';
import '../utils/admin_constants.dart';

class PropertiesScreen extends StatelessWidget {
  const PropertiesScreen({Key? key}) : super(key: key);

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
              'Properties',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1C1E21),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage all boarding house properties',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF65676B),
              ),
            ),
            const SizedBox(height: 32),
            
            // Properties List
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Property Listings',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1C1E21),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Add new property
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Add Property'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1877F2),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AdminConstants.buttonRadius),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const _PropertyItem(
                      name: 'Sunrise Boarding House',
                      address: '123 Main Street, Tagoloan',
                      rooms: '12 rooms',
                      status: 'Active',
                    ),
                    const SizedBox(height: 16),
                    const _PropertyItem(
                      name: 'Sunset Dormitory',
                      address: '456 Oak Avenue, Tagoloan',
                      rooms: '8 rooms',
                      status: 'Active',
                    ),
                    const SizedBox(height: 16),
                    const _PropertyItem(
                      name: 'Moonlight Hostel',
                      address: '789 Pine Road, Tagoloan',
                      rooms: '15 rooms',
                      status: 'Pending',
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

class _PropertyItem extends StatelessWidget {
  final String name;
  final String address;
  final String rooms;
  final String status;

  const _PropertyItem({
    required this.name,
    required this.address,
    required this.rooms,
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
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF1877F2),
              borderRadius: BorderRadius.circular(AdminConstants.buttonRadius),
            ),
            child: const Icon(
              Icons.home_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1C1E21),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  address,
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
                        color: status == 'Active' 
                            ? const Color(0xFF31A24C).withOpacity(0.1)
                            : const Color(0xFFE99537).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: status == 'Active' 
                              ? const Color(0xFF31A24C)
                              : const Color(0xFFE99537),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      rooms,
                      style: const TextStyle(
                        fontSize: 14,
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
}
