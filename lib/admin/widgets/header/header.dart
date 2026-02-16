import 'package:flutter/material.dart';
import '../../utils/admin_constants.dart';

class Header extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final Function(String)? onNavigate;

  const Header({
    Key? key,
    required this.title,
    this.actions,
    this.onNavigate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AdminConstants.headerHeight,
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF), // White background
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFE4E6EB), // Subtle border
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Page title
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1C1E21), // Dark gray text
                letterSpacing: -0.3,
              ),
            ),
          ),
          
          // Action buttons (if any)
          if (actions != null && actions!.isNotEmpty)
            Row(
              children: [
                ...actions!.map((action) => Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: action,
                )),
              ],
            ),
          
          // User profile section
          Container(
            margin: const EdgeInsets.only(left: 24.0),
            child: Row(
              children: [
                // Notifications button
                _IconButton(
                  icon: Icons.notifications_outlined,
                  onPressed: () {},
                  tooltip: 'Notifications',
                  hasBadge: true,
                ),
                const SizedBox(width: 12),
                
                // User profile with dropdown
                PopupMenuButton<String>(
                  offset: const Offset(0, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AdminConstants.buttonRadius),
                  ),
                  elevation: 8,
                  color: const Color(0xFFFFFFFF),
                  onSelected: (value) async {
                    if (value == '/admin/profile') {
                      // Navigate to profile screen
                      onNavigate?.call(value);
                    } else if (value == '/admin/settings') {
                      // Navigate to settings screen
                      onNavigate?.call(value);
                    } else if (value == 'signout') {
                      // Show confirmation dialog
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
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFF1877F2), // Facebook blue
                        radius: 16,
                        child: const Text(
                          'A',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFF65676B), // Light gray icon
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;
  final bool hasBadge;

  const _IconButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.hasBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF0F2F5), // Light gray background
            borderRadius: BorderRadius.circular(AdminConstants.buttonRadius),
          ),
          child: IconButton(
            icon: Icon(icon),
            onPressed: onPressed,
            tooltip: tooltip,
            color: const Color(0xFF65676B), // Light gray icon
            iconSize: 20,
            splashRadius: 20,
            padding: const EdgeInsets.all(10),
          ),
        ),
        if (hasBadge)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFFFA383E), // Red notification badge
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 1.5,
                ),
              ),
            ),
          ),
      ],
    );
  }
}