import 'package:flutter/material.dart';
import 'widgets/sidebar/sidebar.dart';
import 'widgets/header/header.dart';
import 'widgets/footer/footer.dart';
import 'utils/admin_constants.dart';
import 'utils/admin_routes.dart';

class AdminLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final List<AdminMenuItem>? menuItems;
  final String? currentRoute;
  final Function(String)? onMenuItemSelected;

  const AdminLayout({
    Key? key,
    required this.child,
    this.title = 'Admin Dashboard',
    this.menuItems,
    this.currentRoute,
    this.onMenuItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine if we're in desktop/tablet view based on screen width
        final isDesktop = constraints.maxWidth >= 1024;
        
        if (isDesktop) {
          // Desktop layout: Sidebar on the left, header at the top, content in the middle, footer at the bottom
          return Scaffold(
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fixed sidebar on the left
                Sidebar(
                  menuItems: menuItems ?? _getDefaultMenuItems(),
                  currentRoute: currentRoute,
                  onMenuItemSelected: (String route) {
                    // Handle menu item selection
                    if (onMenuItemSelected != null) {
                      onMenuItemSelected!(route);
                    } else {
                      Navigator.pushReplacementNamed(context, route);
                    }
                  },
                ),
                
                // Main content area (Header + Content + Footer)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header at the top
                      Header(
                        title: title,
                        onNavigate: onMenuItemSelected,
                      ),
                      
                      // Main content area
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          child: child,
                        ),
                      ),
                      
                      // Footer at the bottom
                      Footer(),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          // Mobile/Tablet layout: Use standard app bar and drawer
          return Scaffold(
            appBar: AppBar(
              title: Text(title),
              centerTitle: false,
              elevation: 1,
              actions: [
                // Notifications button
                IconButton(
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.notifications_outlined),
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFA383E),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    // Handle notifications
                  },
                ),
                const SizedBox(width: 8),
                
                // User profile dropdown
                PopupMenuButton<String>(
                  offset: const Offset(0, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 8,
                  color: const Color(0xFFFFFFFF),
                  onSelected: (value) {
                    if (value == '/admin/profile') {
                      // Navigate to profile screen
                      onMenuItemSelected?.call(value);
                    } else if (value == '/admin/settings') {
                      // Navigate to settings screen
                      onMenuItemSelected?.call(value);
                    } else if (value == 'signout') {
                      // Show confirmation dialog
                      _showSignOutDialog(context);
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem<String>(
                      value: '/admin/profile',
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            color: Color(0xFF65676B),
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Profile',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF1C1E21),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: '/admin/settings',
                      child: Row(
                        children: [
                          Icon(
                            Icons.settings_outlined,
                            color: Color(0xFF65676B),
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Settings',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF1C1E21),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(height: 1),
                    const PopupMenuItem<String>(
                      value: 'signout',
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout,
                            color: Color(0xFF65676B),
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Sign Out',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF1C1E21),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F2F5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xFF1877F2),
                          radius: 14,
                          child: const Text(
                            'A',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Admin',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xFF1C1E21),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFF65676B),
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
            drawer: Sidebar(
              menuItems: menuItems ?? _getDefaultMenuItems(),
              currentRoute: currentRoute,
              onMenuItemSelected: (String route) {
                // Handle menu item selection
                if (onMenuItemSelected != null) {
                  onMenuItemSelected!(route);
                } else {
                  Navigator.pushReplacementNamed(context, route);
                }
              },
            ),
            body: Container(
              padding: const EdgeInsets.all(16.0),
              child: child,
            ),
            bottomNavigationBar: constraints.maxWidth < 768 
                ? Footer() 
                : null,
          );
        }
      },
    );
  }

  List<AdminMenuItem> _getDefaultMenuItems() {
    return [
      AdminMenuItem(
        title: 'Dashboard',
        icon: Icons.dashboard,
        route: '/admin/dashboard',
      ),
      AdminMenuItem(
        title: 'Users',
        icon: Icons.people,
        route: '/admin/users',
      ),
      AdminMenuItem(
        title: 'Properties',
        icon: Icons.home,
        route: '/admin/properties',
      ),
      AdminMenuItem(
        title: 'Bookings',
        icon: Icons.book,
        route: '/admin/bookings',
      ),
      AdminMenuItem(
        title: 'Analytics',
        icon: Icons.analytics,
        route: '/admin/analytics',
      ),
    ];
  }

  static void _showSignOutDialog(BuildContext context) async {
    final bool? shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to leave?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1877F2),
                foregroundColor: Colors.white,
              ),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
    
    // If user confirmed, navigate to login screen
    if (shouldSignOut == true) {
      Navigator.pushNamedAndRemoveUntil(
        context, 
        '/admin/login', 
        (route) => false,
      );
    }
  }
}

class AdminMenuItem {
  final String title;
  final IconData icon;
  final String route;

  const AdminMenuItem({
    required this.title,
    required this.icon,
    required this.route,
  });
}