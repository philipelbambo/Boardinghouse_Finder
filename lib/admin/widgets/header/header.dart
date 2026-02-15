import 'package:flutter/material.dart';
import '../../utils/admin_constants.dart';

class Header extends StatelessWidget {
  final String title;
  final List<Widget>? actions;

  const Header({
    Key? key,
    required this.title,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AdminConstants.headerHeight,
      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF), // White background
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          // Page title
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1C1E21), // Dark gray text
                letterSpacing: -0.5,
              ),
            ),
          ),
          
          // Action buttons (if any)
          if (actions != null && actions!.isNotEmpty)
            Row(
              children: [
                ...actions!.map((action) => Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: action,
                )),
              ],
            ),
          
          // User profile section
          Container(
            margin: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                // Notifications button
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F2F5), // Light gray background
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {},
                    tooltip: 'Notifications',
                    color: const Color(0xFF65676B), // Light gray icon
                    iconSize: 22,
                    splashRadius: 24,
                  ),
                ),
                const SizedBox(width: 12),
                
                // User profile
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F2F5), // Light gray background
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFF1877F2), // Facebook blue
                        radius: 18,
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Admin',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Color(0xFF1C1E21), // Dark gray text
                          letterSpacing: 0.1,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Color(0xFF65676B), // Light gray icon
                        size: 20,
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