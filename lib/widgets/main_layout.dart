import 'package:flutter/material.dart';
import 'navigation_sidebar.dart'; // Import the new navigation sidebar

class MainLayout extends StatefulWidget {
  final Widget child;
  final String title;
  final VoidCallback onHomePressed;
  final VoidCallback onMapPressed;
  final VoidCallback onFavoritesPressed;
  final VoidCallback onQrScanPressed;

  const MainLayout({
    Key? key,
    required this.child,
    required this.title,
    required this.onHomePressed,
    required this.onMapPressed,
    required this.onFavoritesPressed,
    required this.onQrScanPressed,
  }) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> with TickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Navigation Sidebar
          NavigationSidebar(
            isExpanded: _isSidebarExpanded,
            onToggle: _toggleSidebar,
            onHomePressed: widget.onHomePressed,
            onMapPressed: widget.onMapPressed,
            onFavoritesPressed: widget.onFavoritesPressed,
            onQrScanPressed: widget.onQrScanPressed,
          ),
          // Main Content Area - adjust based on sidebar state
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  // Top App Bar
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Show toggle button in main content when sidebar is hidden
                          if (!_isSidebarExpanded)
                            IconButton(
                              onPressed: _toggleSidebar,
                              icon: Icon(
                                Icons.menu_rounded,
                                color: Color(0xFF982598),
                                size: 28,
                              ),
                            ),
                          Expanded(
                            child: Text(
                              widget.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF982598),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          // Spacer or close button when sidebar is expanded
                          if (_isSidebarExpanded)
                            IconButton(
                              onPressed: _toggleSidebar,
                              icon: Icon(
                                Icons.close_rounded,
                                color: Color(0xFF982598),
                                size: 28,
                              ),
                            )
                          else
                            const SizedBox(width: 40),
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