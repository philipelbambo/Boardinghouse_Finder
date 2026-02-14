    import 'package:flutter/material.dart';

class NavigationSidebar extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback onHomePressed;
  final VoidCallback onMapPressed;
  final VoidCallback onFavoritesPressed;
  final VoidCallback onQrScanPressed;

  const NavigationSidebar({
    Key? key,
    required this.isExpanded,
    required this.onToggle,
    required this.onHomePressed,
    required this.onMapPressed,
    required this.onFavoritesPressed,
    required this.onQrScanPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Always render the sidebar with fixed width, but control visibility
    return Container(
      width: 200.0, // Fixed width
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: const Offset(5, 0),
          ),
        ],
      ),
      child: Visibility(
        visible: isExpanded, // Control visibility instead of width
        child: Column(
          children: [
            // Header with toggle button
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
                  IconButton(
                    onPressed: onToggle,
                    icon: Icon(
                      isExpanded
                          ? Icons.close_rounded
                          : Icons.menu_rounded,
                      color: Color(0xFF982598),
                      size: 28,
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
                    icon: Icons.home_outlined,
                    label: 'Home',
                    isSelected: false,
                    onTap: onHomePressed,
                  ),
                  _buildNavigationItem(
                    icon: Icons.map_outlined,
                    label: 'Map',
                    isSelected: false,
                    onTap: onMapPressed,
                  ),
                  _buildNavigationItem(
                    icon: Icons.favorite_outline,
                    label: 'Favorites',
                    isSelected: false,
                    onTap: onFavoritesPressed,
                  ),
                  _buildNavigationItem(
                    icon: Icons.qr_code_scanner_outlined,
                    label: 'Scan QR',
                    isSelected: false,
                    onTap: onQrScanPressed,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isSelected 
            ? Color(0xFF982598).withValues(alpha: 0.1)
            : Colors.transparent,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Color(0xFF982598),
          size: 24,
        ),
        title: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF982598),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        selected: isSelected,
        selectedTileColor: Color(0xFF982598).withValues(alpha: 0.1),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        dense: false,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}