import 'package:flutter/material.dart';
import '../../utils/admin_constants.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome message
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    child: const Text(
                      'Welcome back, Admin!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1C1E21),
                      ),
                    ),
                  ),
                  
                  // Stats cards row
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _buildStatCard(
                        title: 'Total Properties',
                        value: '142',
                        icon: Icons.home,
                        color: Color(0xFF1877F2),
                      ),
                      _buildStatCard(
                        title: 'Active Bookings',
                        value: '24',
                        icon: Icons.book,
                        color: Color(0xFF31A24C),
                      ),
                      _buildStatCard(
                        title: 'Pending Reviews',
                        value: '8',
                        icon: Icons.reviews,
                        color: Color(0xFFE99537),
                      ),
                      _buildStatCard(
                        title: 'Total Users',
                        value: '1,242',
                        icon: Icons.people,
                        color: Color(0xFF8A8D91),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Charts and tables section
                  SizedBox(
                    height: 400, // Fixed height to avoid unbounded constraints
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left column - Chart
                        Expanded(
                          flex: 2,
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AdminConstants.cardRadius),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Monthly Activity',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey.withOpacity(0.3),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(AdminConstants.buttonRadius),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Chart Placeholder',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 16),
                        
                        // Right column - Recent activity
                        Expanded(
                          flex: 1,
                          child: Card(
                            elevation: 4,
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
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Expanded(
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      itemCount: 5,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                          leading: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.notifications,
                                              color: Colors.grey.shade600,
                                              size: 20,
                                            ),
                                          ),
                                          title: Text('Activity $index'),
                                          subtitle: Text('Description of activity $index'),
                                          trailing: Text(
                                            '${DateTime.now().day - index}/${DateTime.now().month}',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return const Divider(height: 1);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 200,
      height: 120,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AdminConstants.cardRadius),
        ),
        child: Container(
          padding: const EdgeInsets.all(12.0), // Reduced padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, color: color, size: 28), // Slightly reduced icon size
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.arrow_upward,
                      color: color,
                      size: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6), // Reduced spacing
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20, // Reduced font size
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF65676B),
                  fontSize: 12, // Reduced font size
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}