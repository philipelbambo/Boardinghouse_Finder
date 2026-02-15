import 'package:flutter/material.dart';
import '../../admin_layout.dart';
import '../../utils/admin_constants.dart';

class Sidebar extends StatelessWidget {
  final List<AdminMenuItem> menuItems;
  final String? currentRoute;
  final Function(String)? onMenuItemSelected;

  const Sidebar({
    Key? key,
    required this.menuItems,
    this.currentRoute,
    this.onMenuItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AdminConstants.sidebarWidth,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF), // White card container
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(2, 0),
            spreadRadius: 0,
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Logo/Header section - Facebook blue
            Container(
              height: 88,
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              decoration: const BoxDecoration(
                color: Color(0xFF1877F2), // Facebook blue
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.admin_panel_settings,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Admin Panel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Menu items with spacing
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: menuItems.asMap().entries.map((entry) {
                  int index = entry.key;
                  AdminMenuItem item = entry.value;
                  
                  bool isSelected = currentRoute == item.route;
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          if (onMenuItemSelected != null) {
                            onMenuItemSelected!(item.route);
                          } else {
                            Navigator.pushNamed(context, item.route);
                          }
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 14.0,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? const Color(0xFF1877F2).withOpacity(0.08) // Light Facebook blue tint
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF1877F2).withOpacity(0.2)
                                  : Colors.transparent,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                item.icon,
                                color: isSelected 
                                    ? const Color(0xFF1877F2) // Facebook blue for active
                                    : const Color(0xFF65676B), // Light gray for inactive
                                size: 22,
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: TextStyle(
                                    fontWeight: isSelected 
                                        ? FontWeight.w600 
                                        : FontWeight.w500,
                                    fontSize: 15,
                                    color: isSelected 
                                        ? const Color(0xFF1C1E21) // Dark gray for active text
                                        : const Color(0xFF65676B), // Light gray for inactive text
                                    letterSpacing: 0.1,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF1877F2),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}