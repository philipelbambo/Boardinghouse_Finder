import 'package:flutter/material.dart';

// Facebook Settings Color Palette
const Color _bgLight = Color(0xFFF0F2F5);      // Light gray background
const Color _cardWhite = Color(0xFFFFFFFF);    // White card containers
const Color _fbBlue = Color(0xFF1877F2);       // Facebook blue (primary accent)
const Color _textDark = Color(0xFF1C1E21);     // Dark gray main text
const Color _textLight = Color(0xFF65676B);    // Light gray secondary text
const Color _divider = Color(0xFFDDDFE2);      // Subtle divider color
const Color _hoverBg = Color(0xFFF2F3F5);      // Hover state background

const double _borderRadius = 12.0;             // Modern rounded corners
const double _cardElevation = 0.5;             // Subtle elevation

/// Facebook-style soft shadow for cards
List<BoxShadow> _fbCardShadow() {
  return [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      offset: const Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      offset: const Offset(0, 2),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];
}

class RoomSidebar extends StatefulWidget {
  final int? selectedRoom;
  final Function(int)? onRoomSelected;
  final List<int> roomNumbers;
  final bool isVisible;
  final VoidCallback onToggle;

  const RoomSidebar({
    Key? key,
    this.selectedRoom,
    this.onRoomSelected,
    required this.roomNumbers,
    required this.isVisible,
    required this.onToggle,
  }) : super(key: key);

  @override
  State<RoomSidebar> createState() => _RoomSidebarState();
}

class _RoomSidebarState extends State<RoomSidebar> {
  int? _hoveredRoom;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOutCubic,
      width: widget.isVisible ? 280 : 0,
      child: widget.isVisible
          ? Container(
              decoration: BoxDecoration(
                color: _cardWhite,
                boxShadow: _fbCardShadow(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  _buildHeader(),
                  
                  // Divider
                  Container(
                    height: 1,
                    color: _divider,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Room List
                  Expanded(
                    child: _buildRoomList(),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 12, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title
          Text(
            'Rooms',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: _textDark,
              letterSpacing: -0.5,
            ),
          ),
          
          // Collapse Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onToggle,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.chevron_right,
                  size: 24,
                  color: _textLight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      itemCount: widget.roomNumbers.length,
      itemBuilder: (context, index) {
        final roomNumber = widget.roomNumbers[index];
        final isSelected = widget.selectedRoom == roomNumber;
        final isHovered = _hoveredRoom == roomNumber;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: MouseRegion(
            onEnter: (_) => setState(() => _hoveredRoom = roomNumber),
            onExit: (_) => setState(() => _hoveredRoom = null),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => widget.onRoomSelected?.call(roomNumber),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _fbBlue.withOpacity(0.1)
                        : isHovered
                            ? _hoverBg
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      // Icon
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _fbBlue.withOpacity(0.15)
                              : _hoverBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.meeting_room_outlined,
                          size: 20,
                          color: isSelected ? _fbBlue : _textLight,
                        ),
                      ),
                      
                      const SizedBox(width: 12),
                      
                      // Room Text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Room ${roomNumber.toString().padLeft(3, '0')}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isSelected ? _fbBlue : _textDark,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Selection Indicator
                      if (isSelected)
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _fbBlue,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Optional: Expand/Collapse Toggle Button (if sidebar is collapsed)
class SidebarToggleButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isExpanded;

  const SidebarToggleButton({
    Key? key,
    required this.onTap,
    required this.isExpanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _cardWhite,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Icon(
            isExpanded ? Icons.chevron_left : Icons.chevron_right,
            color: _textLight,
            size: 24,
          ),
        ),
      ),
    );
  }
}

// Example Usage Screen with Facebook-style background
class RoomManagementScreen extends StatefulWidget {
  const RoomManagementScreen({Key? key}) : super(key: key);

  @override
  State<RoomManagementScreen> createState() => _RoomManagementScreenState();
}

class _RoomManagementScreenState extends State<RoomManagementScreen> {
  int? _selectedRoom;
  bool _isSidebarVisible = true;
  final List<int> _roomNumbers = List.generate(25, (index) => index + 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgLight, // Facebook Settings background
      body: Row(
        children: [
          // Sidebar
          RoomSidebar(
            selectedRoom: _selectedRoom,
            onRoomSelected: (room) {
              setState(() => _selectedRoom = room);
            },
            roomNumbers: _roomNumbers,
            isVisible: _isSidebarVisible,
            onToggle: () {
              setState(() => _isSidebarVisible = !_isSidebarVisible);
            },
          ),
          
          // Toggle Button (when collapsed)
          if (!_isSidebarVisible)
            Padding(
              padding: const EdgeInsets.all(16),
              child: SidebarToggleButton(
                onTap: () {
                  setState(() => _isSidebarVisible = true);
                },
                isExpanded: false,
              ),
            ),
          
          // Main Content Area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: _selectedRoom != null
                  ? _buildRoomContent()
                  : _buildEmptyState(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomContent() {
    return Container(
      decoration: BoxDecoration(
        color: _cardWhite,
        borderRadius: BorderRadius.circular(_borderRadius),
        boxShadow: _fbCardShadow(),
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Room ${_selectedRoom.toString().padLeft(3, '0')}',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: _textDark,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Manage room settings and configurations',
            style: TextStyle(
              fontSize: 15,
              color: _textLight,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 32),
          
          // Example Action Buttons
          Row(
            children: [
              _buildActionButton(
                label: 'Edit Room',
                icon: Icons.edit_outlined,
                isPrimary: true,
              ),
              const SizedBox(width: 12),
              _buildActionButton(
                label: 'View Details',
                icon: Icons.visibility_outlined,
                isPrimary: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required bool isPrimary,
  }) {
    return Material(
      color: isPrimary ? _fbBlue : _hoverBg,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isPrimary ? Colors.white : _textDark,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isPrimary ? Colors.white : _textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: _hoverBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.meeting_room_outlined,
              size: 40,
              color: _textLight,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Select a room to get started',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose a room from the sidebar to view details',
            style: TextStyle(
              fontSize: 14,
              color: _textLight,
            ),
          ),
        ],
      ),
    );
  }
}