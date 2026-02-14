import 'package:flutter/material.dart';

class SidebarLayout extends StatefulWidget {
  final Widget child;
  final String title;
  final Function(String)? onNavigate;

  const SidebarLayout({
    super.key,
    required this.child,
    required this.title,
    this.onNavigate,
  });

  @override
  State<SidebarLayout> createState() => _SidebarLayoutState();
}

class _SidebarLayoutState extends State<SidebarLayout> with TickerProviderStateMixin {
  final double _expandedWidth = 200.0;
  final double _collapsedWidth = 0.0;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isSidebarExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: _collapsedWidth,
      end: _expandedWidth,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    // Start from completely hidden state
    _animationController.value = 0.0;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarExpanded = !_isSidebarExpanded;
    });
    if (_isSidebarExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _handleNavigation(String screen) {
    // Close sidebar when navigating
    if (_isSidebarExpanded) {
      setState(() {
        _isSidebarExpanded = false;
      });
      _animationController.reverse();
    }
    
    // Call the navigation callback if provided
    if (widget.onNavigate != null) {
      widget.onNavigate!(screen);
    } else {
      // Default navigation using routes
      switch (screen) {
        case 'home':
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          break;
        case 'map':
          Navigator.pushNamedAndRemoveUntil(context, '/map', (route) => false);
          break;
        case 'favorites':
          Navigator.pushNamedAndRemoveUntil(context, '/favorites', (route) => false);
          break;
        case 'qr-scan':
          Navigator.pushNamedAndRemoveUntil(context, '/qr-scan', (route) => false);
          break;
      }
    }
  }

  void _navigateToScreen(VoidCallback navigationCallback) {
    // Close sidebar when navigating
    if (_isSidebarExpanded) {
      setState(() {
        _isSidebarExpanded = false;
      });
      _animationController.reverse();
    }
    navigationCallback();
  }

  @override
  Widget build(BuildContext context) {
    // Check if we're on mobile device
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    if (isMobile) {
      // Mobile layout - Bottom navigation
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF982598),
          elevation: 2,
          actions: [
            IconButton(
              onPressed: _toggleSidebar,
              icon: const Icon(Icons.menu),
              color: const Color(0xFF982598),
            ),
          ],
        ),
        drawer: _buildMobileDrawer(),
        body: widget.child,
        bottomNavigationBar: _buildBottomNavBar(),
      );
    } else {
      // Desktop layout - Side navigation
      return Scaffold(
        body: Row(
          children: [
            // Navigation Sidebar - Left side toggle
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  width: _animation.value,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: _isSidebarExpanded
                        ? [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: const Offset(5, 0),
                            ),
                          ]
                        : [],
                  ),
                  child: _isSidebarExpanded
                      ? _buildExpandedSidebar()
                      : const SizedBox.shrink(),
                );
              },
            ),
            // Main Content Area
            Expanded(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    // Top App Bar with toggle button
                    Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            // Toggle button on the left side
                            IconButton(
                              onPressed: _toggleSidebar,
                              icon: Icon(
                                _isSidebarExpanded
                                    ? Icons.close
                                    : Icons.menu,
                                color: const Color(0xFF982598),
                                size: 28,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                widget.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF982598),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Screen Content
                    Expanded(
                      child: widget.child,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildExpandedSidebar() {
    return Column(
      children: [
        // Header with app name
        Container(
          height: 80,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xFF982598),
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.apartment,
                color: Color(0xFF982598),
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Finder',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF982598),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Navigation Items
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            children: [
              _buildNavigationItem(
                icon: Icons.home,
                label: 'Home',
                onTap: () => _handleNavigation('home'),
              ),
              _buildNavigationItem(
                icon: Icons.map,
                label: 'Map',
                onTap: () => _handleNavigation('map'),
              ),
              _buildNavigationItem(
                icon: Icons.favorite_border,
                label: 'Favorites',
                onTap: () => _handleNavigation('favorites'),
              ),
              _buildNavigationItem(
                icon: Icons.qr_code_scanner,
                label: 'Scan QR',
                onTap: () => _handleNavigation('qr-scan'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.transparent,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFF982598),
          size: 24,
          semanticLabel: label,
        ),
        title: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF982598),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        dense: false,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  // Mobile-specific methods
  Widget _buildMobileDrawer() {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF982598),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.apartment,
                  color: Colors.white,
                  size: 32,
                ),
                SizedBox(width: 16),
                Text(
                  'Finder',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.home,
                  label: 'Home',
                  onTap: () => _handleNavigation('home'),
                ),
                _buildDrawerItem(
                  icon: Icons.map,
                  label: 'Map',
                  onTap: () => _handleNavigation('map'),
                ),
                _buildDrawerItem(
                  icon: Icons.favorite_border,
                  label: 'Favorites',
                  onTap: () => _handleNavigation('favorites'),
                ),
                _buildDrawerItem(
                  icon: Icons.qr_code_scanner,
                  label: 'Scan QR',
                  onTap: () => _handleNavigation('qr-scan'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFF982598),
        size: 28,
      ),
      title: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF982598),
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.pop(context); // Close drawer
        onTap();
      },
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF982598),
      unselectedItemColor: Colors.grey,
      currentIndex: _getCurrentIndex(),
      onTap: (index) {
        switch (index) {
          case 0:
            _handleNavigation('home');
            break;
          case 1:
            _handleNavigation('map');
            break;
          case 2:
            _handleNavigation('favorites');
            break;
          case 3:
            _handleNavigation('qr-scan');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Map',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.qr_code_scanner),
          label: 'Scan QR',
        ),
      ],
    );
  }

  int _getCurrentIndex() {
    // This would need to be enhanced to track current route
    // For now, returning 0 as default
    return 0;
  }
}
