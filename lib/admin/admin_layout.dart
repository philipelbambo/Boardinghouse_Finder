import 'package:flutter/material.dart';
import 'widgets/sidebar/sidebar.dart';
import 'widgets/header/header.dart';
import 'widgets/footer/footer.dart';
import 'utils/admin_constants.dart';

class AdminLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final List<AdminMenuItem>? menuItems;
  final String? currentRoute;

  const AdminLayout({
    Key? key,
    required this.child,
    this.title = 'Admin Dashboard',
    this.menuItems,
    this.currentRoute,
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
                    Navigator.pushNamed(context, route);
                  },
                ),
                
                // Main content area (Header + Content + Footer)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header at the top
                      Header(title: title),
                      
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
            ),
            drawer: Sidebar(
              menuItems: menuItems ?? _getDefaultMenuItems(),
              currentRoute: currentRoute,
              onMenuItemSelected: (String route) {
                // Handle menu item selection
                Navigator.pushNamed(context, route);
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
      AdminMenuItem(
        title: 'Settings',
        icon: Icons.settings,
        route: '/admin/settings',
      ),
    ];
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