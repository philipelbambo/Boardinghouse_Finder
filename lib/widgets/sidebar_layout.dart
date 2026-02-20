import 'package:flutter/material.dart';
import '../admin/services/admin_auth_service.dart';

// ─── Facebook Settings Design Tokens ──────────────────────────────────────────
const _kBgColor       = Color(0xFFF0F2F5);   // light gray background
const _kAccent        = Color(0xFF1877F2);   // Facebook blue
const _kCardColor     = Color(0xFFFFFFFF);   // white cards
const _kBorderColor   = Color(0xFFE4E6EB);   // soft border
const _kTextPrimary   = Color(0xFF1C1E21);   // dark gray main text
const _kTextSecondary = Color(0xFF65676B);   // lighter gray secondary text

// ─── Reusable Facebook-style helpers ──────────────────────────────────────────

/// Flat card with soft shadow
BoxDecoration facebookCard({
  double radius = 8,
  bool elevated = true,
}) {
  return BoxDecoration(
    color: _kCardColor,
    borderRadius: BorderRadius.circular(radius),
    boxShadow: elevated
        ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 1),
              blurRadius: 3,
              spreadRadius: 0,
            ),
          ]
        : [],
  );
}

/// Circular button decoration
BoxDecoration facebookCircle({bool pressed = false}) {
  return BoxDecoration(
    shape: BoxShape.circle,
    color: pressed ? _kBorderColor : _kCardColor,
    boxShadow: pressed
        ? []
        : [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 1),
              blurRadius: 2,
            ),
          ],
  );
}

// ─── Facebook-style Icon Button ───────────────────────────────────────────────
class _FbIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;

  const _FbIconButton({
    required this.icon,
    required this.onPressed,
    this.size = 40,
  });

  @override
  State<_FbIconButton> createState() => _FbIconButtonState();
}

class _FbIconButtonState extends State<_FbIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: widget.size,
        height: widget.size,
        decoration: facebookCircle(pressed: _pressed),
        child: Icon(widget.icon, color: _kTextSecondary, size: widget.size * 0.5),
      ),
    );
  }
}

// ─── Facebook-style Navigation Item ───────────────────────────────────────────
class _FbNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool compact; // for bottom nav bar
  final bool showLabel;
  final double? availableWidth;
  final bool isActive;

  const _FbNavItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.compact = false,
    this.showLabel = true,
    this.availableWidth,
    this.isActive = false,
  });

  @override
  State<_FbNavItem> createState() => _FbNavItemState();
}

class _FbNavItemState extends State<_FbNavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool canShowLabel = widget.compact 
            ? false 
            : (widget.availableWidth != null 
                ? widget.availableWidth! > 100 
                : (constraints.maxWidth > 100 && widget.showLabel));
        
        bool hasMinimalSpace = !widget.compact && constraints.maxWidth < 60;
        
        return MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: widget.compact
                  ? const EdgeInsets.symmetric(horizontal: 2, vertical: 4) // Reduced margin for compact mode
                  : (hasMinimalSpace ? const EdgeInsets.all(1) : (canShowLabel ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4) : const EdgeInsets.all(2))),
              padding: widget.compact
                  ? const EdgeInsets.symmetric(horizontal: 8, vertical: 6) // Reduced padding for compact mode
                  : (hasMinimalSpace ? const EdgeInsets.all(1) : (canShowLabel ? const EdgeInsets.symmetric(horizontal: 12, vertical: 10) : const EdgeInsets.all(3))),
              decoration: BoxDecoration(
                color: widget.isActive 
                    ? _kAccent.withOpacity(0.1)
                    : (_hovered ? _kBorderColor : Colors.transparent),
                borderRadius: BorderRadius.circular(widget.compact ? 8 : (hasMinimalSpace ? 6 : (canShowLabel ? 8 : 10))),
              ),
              child: widget.compact
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          widget.icon, 
                          color: widget.isActive ? _kAccent : _kTextSecondary,
                          size: 20, // Reduced from 24 to save space
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.label,
                          style: TextStyle(
                            color: widget.isActive ? _kAccent : _kTextSecondary,
                            fontSize: 10, // Reduced from 11 to save space
                            fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ],
                    )
                  : hasMinimalSpace || !canShowLabel
                      ? Center(
                          child: Container(
                            decoration: facebookCircle(),
                            child: Center(
                              child: Icon(
                                widget.icon,
                                color: widget.isActive ? _kAccent : _kTextSecondary,
                                size: 18,
                              ),
                            ),
                            width: 24,
                            height: 24,
                          ),
                        )
                      : Row(
                          children: [
                            Icon(
                              widget.icon,
                              color: widget.isActive ? _kAccent : _kTextSecondary,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Flexible(
                              child: Text(
                                widget.label,
                                style: TextStyle(
                                  color: widget.isActive ? _kAccent : _kTextPrimary,
                                  fontSize: 15,
                                  fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
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
}

// ─── Facebook-style Drawer Item ───────────────────────────────────────────────
class _FbDrawerItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool showLabel;
  final bool isActive;

  const _FbDrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.showLabel = true,
    this.isActive = false,
  });

  @override
  State<_FbDrawerItem> createState() => _FbDrawerItemState();
}

class _FbDrawerItemState extends State<_FbDrawerItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: widget.isActive 
                ? _kAccent.withOpacity(0.1)
                : (_hovered ? _kBorderColor : Colors.transparent),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                color: widget.isActive ? _kAccent : _kTextSecondary,
                size: 24,
              ),
              if (widget.showLabel) const SizedBox(width: 12),
              if (widget.showLabel)
                Text(
                  widget.label,
                  style: TextStyle(
                    color: widget.isActive ? _kAccent : _kTextPrimary,
                    fontSize: 15,
                    fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Main SidebarLayout ───────────────────────────────────────────────────────
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

class _SidebarLayoutState extends State<SidebarLayout>
    with TickerProviderStateMixin {
  final double _expandedWidth = 240.0;
  final double _collapsedWidth = 0.0;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isSidebarExpanded = false;
  bool _imagesPreloaded = false;
  String _currentScreen = 'home';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: _collapsedWidth, end: _expandedWidth)
        .animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.value = 0.0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_imagesPreloaded) {
      _imagesPreloaded = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        precacheImage(const AssetImage('assets/images/BH-Finder.png'), context);
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleSidebar() {
    setState(() => _isSidebarExpanded = !_isSidebarExpanded);
    if (_isSidebarExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _handleNavigation(String screen) {
    setState(() => _currentScreen = screen);
    if (_isSidebarExpanded) {
      setState(() => _isSidebarExpanded = false);
      _animationController.reverse();
    }
    if (widget.onNavigate != null) {
      widget.onNavigate!(screen);
    } else {
      switch (screen) {
        case 'home':
          Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
          break;
        case 'map':
          Navigator.pushNamedAndRemoveUntil(context, '/map', (r) => false);
          break;
        case 'favorites':
          Navigator.pushNamedAndRemoveUntil(
              context, '/favorites', (r) => false);
          break;
        case 'qr-scan':
          Navigator.pushNamedAndRemoveUntil(
              context, '/qr-scan', (r) => false);
          break;
        case 'about':
          Navigator.pushNamedAndRemoveUntil(
              context, '/about', (r) => false);
          break;
      }
    }
  }

  // ── BUILD ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;

        if (isMobile) {
          return Scaffold(
            backgroundColor: _kBgColor,
            appBar: _buildFbAppBar(),
            drawer: _buildFbMobileDrawer(),
            body: widget.child,
            bottomNavigationBar: _buildFbBottomNavBar(),
          );
        } else {
          return Scaffold(
            backgroundColor: _kBgColor,
            body: Row(
              children: [
                // ── Animated Sidebar ─────────────────────────────────────
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: _animation.value,
                      decoration: BoxDecoration(
                        color: _kCardColor,
                        border: Border(
                          right: BorderSide(
                            color: _kBorderColor,
                            width: _animation.value > 0 ? 1 : 0,
                          ),
                        ),
                      ),
                      child: _animation.value > 20
                          ? _buildExpandedSidebar()
                          : null,
                    );
                  },
                ),
                // ── Main Content ──────────────────────────────────────────
                Expanded(
                  child: Container(
                    color: _kBgColor,
                    child: Column(
                      children: [
                        _buildFbDesktopTopBar(),
                        Expanded(child: widget.child),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  // ── Facebook-style AppBar (mobile) ─────────────────────────────────────────
  PreferredSizeWidget _buildFbAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: Container(
        decoration: BoxDecoration(
          color: _kCardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 1),
              blurRadius: 3,
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Builder(
                  builder: (ctx) => _FbIconButton(
                    icon: Icons.menu,
                    onPressed: () => Scaffold.of(ctx).openDrawer(),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _kTextPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Facebook-style Desktop Top Bar ────────────────────────────────────────
  Widget _buildFbDesktopTopBar() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: _kCardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _FbIconButton(
            icon: _isSidebarExpanded ? Icons.close : Icons.menu,
            onPressed: _toggleSidebar,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _kTextPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ── Expanded Desktop Sidebar ───────────────────────────────────────────────
  Widget _buildExpandedSidebar() {
    return Column(
      children: [
        // Header / Logo area
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _kCardColor,
            border: Border(
              bottom: BorderSide(color: _kBorderColor, width: 1),
            ),
          ),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                'assets/images/BH-Finder.png',
                height: 32,
                width: 120,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Nav items
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 4),
            children: [
              _FbNavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                onTap: () => _handleNavigation('home'),
                availableWidth: _animation.value,
                isActive: _currentScreen == 'home',
              ),
              _FbNavItem(
                icon: Icons.map_rounded,
                label: 'Map',
                onTap: () => _handleNavigation('map'),
                availableWidth: _animation.value,
                isActive: _currentScreen == 'map',
              ),
              _FbNavItem(
                icon: Icons.favorite_border_rounded,
                label: 'Favorites',
                onTap: () => _handleNavigation('favorites'),
                availableWidth: _animation.value,
                isActive: _currentScreen == 'favorites',
              ),
              _FbNavItem(
                icon: Icons.qr_code_scanner_rounded,
                label: 'Scan QR',
                onTap: () => _handleNavigation('qr-scan'),
                availableWidth: _animation.value,
                isActive: _currentScreen == 'qr-scan',
              ),
              _FbNavItem(
                icon: Icons.info_outline,
                label: 'About',
                onTap: () => _handleNavigation('about'),
                availableWidth: _animation.value,
                isActive: _currentScreen == 'about',
              ),
              FutureBuilder<bool>(
                future: AdminAuthService.instance.isLoggedIn(),
                builder: (context, snapshot) {
                  bool isAdmin = snapshot.data ?? false;
                  if (isAdmin) {
                    return _FbNavItem(
                      icon: Icons.admin_panel_settings,
                      label: 'Admin',
                      onTap: () {
                        Navigator.pushNamed(context, '/admin');
                      },
                      availableWidth: _animation.value,
                      isActive: false, // We won't track this as active in the main app
                    );
                  }
                  return const SizedBox.shrink(); // Hide if not admin
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Mobile Drawer ──────────────────────────────────────────────────────────
  Widget _buildFbMobileDrawer() {
    return Drawer(
      backgroundColor: _kCardColor,
      child: Column(
        children: [
          // Drawer header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
            decoration: BoxDecoration(
              color: _kCardColor,
              border: Border(
                bottom: BorderSide(color: _kBorderColor, width: 1),
              ),
            ),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/BH-Finder.png',
                  height: 48,
                  width: 160,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Drawer nav items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 4, bottom: 16),
              children: [
                _FbDrawerItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  onTap: () {
                    Navigator.pop(context);
                    _handleNavigation('home');
                  },
                  showLabel: true,
                  isActive: _currentScreen == 'home',
                ),
                _FbDrawerItem(
                  icon: Icons.map_rounded,
                  label: 'Map',
                  onTap: () {
                    Navigator.pop(context);
                    _handleNavigation('map');
                  },
                  showLabel: true,
                  isActive: _currentScreen == 'map',
                ),
                _FbDrawerItem(
                  icon: Icons.favorite_border_rounded,
                  label: 'Favorites',
                  onTap: () {
                    Navigator.pop(context);
                    _handleNavigation('favorites');
                  },
                  showLabel: true,
                  isActive: _currentScreen == 'favorites',
                ),
                _FbDrawerItem(
                  icon: Icons.qr_code_scanner_rounded,
                  label: 'Scan QR',
                  onTap: () {
                    Navigator.pop(context);
                    _handleNavigation('qr-scan');
                  },
                  showLabel: true,
                  isActive: _currentScreen == 'qr-scan',
                ),
                _FbDrawerItem(
                  icon: Icons.info_outline,
                  label: 'About',
                  onTap: () {
                    Navigator.pop(context);
                    _handleNavigation('about');
                  },
                  showLabel: true,
                  isActive: _currentScreen == 'about',
                ),
                FutureBuilder<bool>(
                  future: AdminAuthService.instance.isLoggedIn(),
                  builder: (context, snapshot) {
                    bool isAdmin = snapshot.data ?? false;
                    if (isAdmin) {
                      return _FbDrawerItem(
                        icon: Icons.admin_panel_settings,
                        label: 'Admin Panel',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/admin');
                        },
                        showLabel: true,
                        isActive: false,
                      );
                    }
                    return const SizedBox.shrink(); // Hide if not admin
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Facebook-style Bottom Navigation Bar ───────────────────────────────────
  Widget _buildFbBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: _kCardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -1),
            blurRadius: 3,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4), // Reduced horizontal padding
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Changed from spaceAround to spaceEvenly
            children: [
              _FbNavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                onTap: () => _handleNavigation('home'),
                compact: true,
                showLabel: true,
                isActive: _currentScreen == 'home',
              ),
              _FbNavItem(
                icon: Icons.map_rounded,
                label: 'Map',
                onTap: () => _handleNavigation('map'),
                compact: true,
                showLabel: true,
                isActive: _currentScreen == 'map',
              ),
              _FbNavItem(
                icon: Icons.favorite_border_rounded,
                label: 'Favorites',
                onTap: () => _handleNavigation('favorites'),
                compact: true,
                showLabel: true,
                isActive: _currentScreen == 'favorites',
              ),
              _FbNavItem(
                icon: Icons.qr_code_scanner_rounded,
                label: 'Scan QR',
                onTap: () => _handleNavigation('qr-scan'),
                compact: true,
                showLabel: true,
                isActive: _currentScreen == 'qr-scan',
              ),
              _FbNavItem(
                icon: Icons.info_outline,
                label: 'About',
                onTap: () => _handleNavigation('about'),
                compact: true,
                showLabel: true,
                isActive: _currentScreen == 'about',
              ),
              FutureBuilder<bool>(
                future: AdminAuthService.instance.isLoggedIn(),
                builder: (context, snapshot) {
                  bool isAdmin = snapshot.data ?? false;
                  if (isAdmin) {
                    return _FbNavItem(
                      icon: Icons.admin_panel_settings,
                      label: 'Admin',
                      onTap: () {
                        Navigator.pushNamed(context, '/admin');
                      },
                      compact: true,
                      showLabel: true,
                      isActive: false,
                    );
                  }
                  return const SizedBox.shrink(); // Hide if not admin
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getCurrentIndex() => 0;
}