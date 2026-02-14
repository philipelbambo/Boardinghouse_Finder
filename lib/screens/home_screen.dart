import 'package:flutter/material.dart';
import '../models/boardinghouse.dart';
import 'boardinghouse_detail_screen.dart';
import 'ai_assistant_screen.dart';
import '../widgets/room_sidebar.dart';

// ─── Facebook Settings Design System ──────────────────────────────────────────
const Color _nmBg        = Color(0xFFF0F2F5);   // light gray background
const Color _nmPrimary   = Color(0xFF1877F2);   // Facebook blue
const Color _nmLight     = Color(0xFFFFFFFF);   // white cards
const Color _nmDark      = Color(0xFFE4E6EB);   // soft shadow color
const Color _textPrimary = Color(0xFF1C1E21);   // dark gray main text
const Color _textSecondary = Color(0xFF65676B); // lighter gray secondary text
const double _nmRadius   = 8.0;
const double _nmElevation = 1.0;

/// Returns soft shadows for Facebook-style cards
List<BoxShadow> nmShadow({double elevation = _nmElevation, bool inset = false}) {
  if (inset) {
    return [
      BoxShadow(
        color: _nmDark.withOpacity(0.5),
        offset: const Offset(0, 1),
        blurRadius: 2,
      ),
    ];
  }
  return [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      offset: const Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
    ),
  ];
}

/// A flat card container
class NmBox extends StatelessWidget {
  const NmBox({
    Key? key,
    required this.child,
    this.radius = _nmRadius,
    this.elevation = _nmElevation,
    this.inset = false,
    this.padding = const EdgeInsets.all(16),
    this.color = _nmLight,
  }) : super(key: key);

  final Widget child;
  final double radius;
  final double elevation;
  final bool inset;
  final EdgeInsetsGeometry padding;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: nmShadow(elevation: elevation, inset: inset),
      ),
      child: child,
    );
  }
}

/// Pressable button
class NmButton extends StatefulWidget {
  const NmButton({
    Key? key,
    required this.child,
    required this.onTap,
    this.radius = _nmRadius,
    this.padding = const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
    this.filled = false,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onTap;
  final double radius;
  final EdgeInsetsGeometry padding;
  final bool filled;

  @override
  State<NmButton> createState() => _NmButtonState();
}

class _NmButtonState extends State<NmButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: widget.padding,
        decoration: BoxDecoration(
          color: widget.filled 
            ? (_pressed ? const Color(0xFF166FE5) : _nmPrimary)
            : (_pressed ? _nmDark : _nmLight),
          borderRadius: BorderRadius.circular(widget.radius),
          boxShadow: _pressed ? [] : nmShadow(elevation: widget.filled ? 2 : 1),
        ),
        child: widget.child,
      ),
    );
  }
}

/// Icon button (circular)
class NmIconButton extends StatefulWidget {
  const NmIconButton({
    Key? key,
    required this.icon,
    required this.onTap,
    this.tooltip,
    this.iconColor = _nmPrimary,
    this.size = 40,
  }) : super(key: key);

  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;
  final Color iconColor;
  final double size;

  @override
  State<NmIconButton> createState() => _NmIconButtonState();
}

class _NmIconButtonState extends State<NmIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip ?? '',
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: _pressed ? _nmDark : _nmLight,
            shape: BoxShape.circle,
            boxShadow: _pressed ? [] : nmShadow(elevation: 1),
          ),
          child: Icon(widget.icon, color: widget.iconColor, size: 20),
        ),
      ),
    );
  }
}

/// Chip (toggle)
class NmChip extends StatelessWidget {
  const NmChip({
    Key? key,
    required this.label,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? _nmPrimary.withOpacity(0.1) : _nmLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? _nmPrimary : _nmDark,
            width: selected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            color: selected ? _nmPrimary : _textSecondary,
          ),
        ),
      ),
    );
  }
}

// ─── Main Screen ──────────────────────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _sortBy = 'price';
  RangeValues _priceRange = const RangeValues(1000, 2500);
  String _selectedBarangay = 'All';
  Set<String> _selectedAmenities = {};

  late AnimationController _filterAnimationController;
  late Animation<double> _filterAnimation;

  // AI Assistant State
  bool _isAiVisible = false;
  late AnimationController _aiAnimationController;
  late Animation<Offset> _aiSlideAnimation;

  final Map<String, int> _currentImageIndex = {};

  // Room sidebar state
  int? _selectedRoom;
  bool _isRoomSidebarVisible = true;
  List<int> get _roomNumbers => _allBoardinghouses.map((bh) => int.tryParse(bh.id) ?? 0).toList();

  final List<Boardinghouse> _allBoardinghouses = [
    Boardinghouse(
      id: '1',
      title: 'Sunrise Dormitory',
      description: 'Comfortable boarding house with modern amenities',
      price: 2000,
      location: 'Poblacion',
      images: [
        'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?w=800',
        'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
        'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800',
      ],
      amenities: ['Wi-Fi', 'AC', 'Laundry'],
      latitude: 8.5367, longitude: 124.7519,
      roomType: 'Single', contactNumber: '09123456789',
      rating: 4.5, reviewCount: 12,
    ),
    Boardinghouse(
      id: '2',
      title: 'Cozy Haven Boarding',
      description: 'Affordable and cozy living space',
      price: 1800,
      location: 'Santa Ana',
      images: [
        'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
        'https://images.unsplash.com/photo-1484154218962-a197022b5858?w=800',
        'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?w=800',
      ],
      amenities: ['Wi-Fi', 'Kitchen'],
      latitude: 8.5389, longitude: 124.7545,
      roomType: 'Double', contactNumber: '09123456788',
      rating: 4.2, reviewCount: 8,
    ),
    Boardinghouse(
      id: '3',
      title: 'Modern Living Spaces',
      description: 'Premium accommodations with all modern amenities',
      price: 2500,
      location: 'Natumolan',
      images: [
        'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800',
        'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800',
        'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
      ],
      amenities: ['Wi-Fi', 'AC', 'Parking', 'Security'],
      latitude: 8.5412, longitude: 124.7567,
      roomType: 'Single', contactNumber: '09123456787',
      rating: 4.8, reviewCount: 15,
    ),
    Boardinghouse(
      id: '4',
      title: 'Student Quarters',
      description: 'Budget-friendly accommodation for students',
      price: 1500,
      location: 'Gracia',
      images: [
        'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
        'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?w=800',
      ],
      amenities: ['Wi-Fi', 'Study Area'],
      latitude: 8.5434, longitude: 124.7589,
      roomType: 'Dormitory', contactNumber: '09123456786',
      rating: 4.0, reviewCount: 20,
    ),
    Boardinghouse(
      id: '5',
      title: 'Premium Residence',
      description: 'High-end boarding house with luxury amenities',
      price: 2500,
      location: 'Mohon',
      images: [
        'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800',
        'https://images.unsplash.com/photo-1484154218962-a197022b5858?w=800',
        'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
      ],
      amenities: ['Wi-Fi', 'AC', 'Gym', 'Pool'],
      latitude: 8.5456, longitude: 124.7612,
      roomType: 'Single', contactNumber: '09123456785',
      rating: 4.9, reviewCount: 18,
    ),
    Boardinghouse(
      id: '6',
      title: 'Budget Friendly Stay',
      description: 'Affordable accommodation for budget-conscious individuals',
      price: 1200,
      location: 'Santa Cruz',
      images: [
        'https://images.unsplash.com/photo-1484154218962-a197022b5858?w=800',
        'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800',
      ],
      amenities: ['Wi-Fi'],
      latitude: 8.5478, longitude: 124.7634,
      roomType: 'Shared', contactNumber: '09123456784',
      rating: 3.8, reviewCount: 5,
    ),
  ];

  List<Boardinghouse> _filteredBoardinghouses = [];

  @override
  void initState() {
    super.initState();
    _filteredBoardinghouses = List.from(_allBoardinghouses);
    _sortBoardinghouses();

    _filterAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300), vsync: this);
    _filterAnimation = CurvedAnimation(
      parent: _filterAnimationController, curve: Curves.easeInOut);
    
    // Initialize AI animation controller
    _aiAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _aiSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Start from bottom (off-screen)
      end: Offset.zero, // End at position
    ).animate(CurvedAnimation(
      parent: _aiAnimationController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _filterAnimationController.dispose();
    _aiAnimationController.dispose();
    super.dispose();
  }

  // ─── Filtering / Sorting ────────────────────────────────────────────────────
  void _applyFilters() {
    setState(() {
      _filteredBoardinghouses = _allBoardinghouses.where((bh) {
        if (bh.price < _priceRange.start || bh.price > _priceRange.end) return false;
        if (_selectedBarangay != 'All' && bh.location != _selectedBarangay) return false;
        if (_selectedAmenities.isNotEmpty &&
            !_selectedAmenities.every((a) => bh.amenities.contains(a))) return false;
        if (_searchController.text.isNotEmpty) {
          final q = _searchController.text.toLowerCase();
          return bh.title.toLowerCase().contains(q) ||
                 bh.location.toLowerCase().contains(q);
        }
        return true;
      }).toList();
      _sortBoardinghouses();
    });
  }

  void _sortBoardinghouses() {
    setState(() {
      switch (_sortBy) {
        case 'price':
          _filteredBoardinghouses.sort((a, b) => a.price.compareTo(b.price)); break;
        case 'distance':
          _filteredBoardinghouses.sort((a, b) => a.location.compareTo(b.location)); break;
        case 'rating':
          _filteredBoardinghouses.sort((a, b) => b.rating.compareTo(a.rating)); break;
      }
    });
  }
  
  // ─── AI Assistant Toggle ────────────────────────────────────────────────────
  void _toggleAiAssistant() {
    setState(() {
      _isAiVisible = !_isAiVisible;
      if (_isAiVisible) {
        _aiAnimationController.forward();
      } else {
        _aiAnimationController.reverse();
      }
    });
  }

  void _toggleRoomSidebar() {
    setState(() {
      _isRoomSidebarVisible = !_isRoomSidebarVisible;
    });
  }



  // ─── Filter Modal ───────────────────────────────────────────────────────────
  void _showFilterModal() {
    _filterAnimationController.forward();
    showDialog(
      context: context,
      barrierColor: Colors.black38,
      builder: (_) => _buildFilterModal(),
    ).then((_) => _filterAnimationController.reverse());
  }

  Widget _buildFilterModal() {
    return StatefulBuilder(builder: (ctx, setModal) {
      final sw = MediaQuery.of(ctx).size.width;
      final modalW = sw < 600 ? sw * 0.9
                   : sw < 900 ? sw * 0.5
                   : sw < 1200 ? sw * 0.35
                   : sw * 0.25;
      return AnimatedBuilder(
        animation: _filterAnimation,
        builder: (_, child) => ScaleTransition(
          scale: _filterAnimation,
          child: FadeTransition(opacity: _filterAnimation, child: child),
        ),
        child: Dialog(
          backgroundColor: _nmLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_nmRadius)),
          child: Container(
            width: modalW,
            height: MediaQuery.of(ctx).size.height * 0.60,
            decoration: BoxDecoration(
              color: _nmLight,
              borderRadius: BorderRadius.circular(_nmRadius),
              boxShadow: nmShadow(elevation: 3),
            ),
            child: Column(children: [
              // Handle bar
              Container(
                width: 44, height: 5,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _nmDark,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Filters',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                          color: _textPrimary)),
                    GestureDetector(
                      onTap: () => setModal(() {
                        _selectedBarangay = 'All';
                        _selectedAmenities.clear();
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _nmLight,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: _nmDark),
                        ),
                        child: Text('Reset',
                          style: TextStyle(color: _nmPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Scrollable content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildNmSortBySection(setModal),
                    const SizedBox(height: 20),
                    _buildNmPriceRangeSection(setModal),
                    const SizedBox(height: 20),
                    _buildNmLocationSection(setModal),
                    const SizedBox(height: 20),
                    _buildNmAmenitiesSection(setModal),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              // Apply button
              Padding(
                padding: const EdgeInsets.all(20),
                child: NmButton(
                  filled: true,
                  radius: _nmRadius,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  onTap: () {
                    Navigator.pop(ctx);
                    _applyFilters();
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Text('Apply Filters',
                        style: TextStyle(color: Colors.white, fontSize: 15,
                            fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      );
    });
  }

  // ─── Filter sections ────────────────────────────────────────────────────────
  Widget _buildNmSortBySection(StateSetter setModal) {
    return NmBox(
      padding: const EdgeInsets.all(16),
      elevation: 1,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Sort by',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _textPrimary)),
        const SizedBox(height: 12),
        ...['price', 'distance', 'rating'].map((opt) {
          final selected = _sortBy == opt;
          return GestureDetector(
            onTap: () => setModal(() => _sortBy = opt),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: selected ? _nmPrimary.withOpacity(0.05) : _nmLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: selected ? _nmPrimary : _nmDark,
                  width: selected ? 2 : 1,
                ),
              ),
              child: Row(children: [
                Container(
                  width: 20, height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? _nmPrimary : Colors.transparent,
                    border: Border.all(
                      color: selected ? _nmPrimary : _nmDark,
                      width: 2,
                    ),
                  ),
                  child: selected
                    ? Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
                ),
                const SizedBox(width: 12),
                Text(capitalize(opt),
                  style: TextStyle(
                    fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                    color: selected ? _textPrimary : _textSecondary,
                    fontSize: 14)),
              ]),
            ),
          );
        }).toList(),
      ]),
    );
  }

  Widget _buildNmPriceRangeSection(StateSetter setModal) {
    return NmBox(
      padding: const EdgeInsets.all(16),
      elevation: 1,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Price Range',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _textPrimary)),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          _priceTag('₱${_priceRange.start.round()}'),
          _priceTag('₱${_priceRange.end.round()}'),
        ]),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: _nmPrimary,
            inactiveTrackColor: _nmDark,
            thumbColor: _nmPrimary,
            overlayColor: _nmPrimary.withOpacity(0.15),
            rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 10),
            trackHeight: 4,
          ),
          child: RangeSlider(
            values: _priceRange,
            min: 1000, max: 2500, divisions: 15,
            labels: RangeLabels(
              '₱${_priceRange.start.round()}',
              '₱${_priceRange.end.round()}'),
            onChanged: (v) => setModal(() => _priceRange = v),
          ),
        ),
      ]),
    );
  }

  Widget _priceTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _nmLight,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _nmDark),
      ),
      child: Text(text,
        style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
    );
  }

  Widget _buildNmLocationSection(StateSetter setModal) {
    final locations = ['All','Poblacion','Natumolan','Gracia','Rosario',
      'San Isidro','Manga','Sugbongcogon','Baluarte','Casinglot','Santo Niño'];
    return NmBox(
      padding: const EdgeInsets.all(16),
      elevation: 1,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Location',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _textPrimary)),
        const SizedBox(height: 12),
        Wrap(spacing: 8, runSpacing: 8,
          children: locations.map((loc) => NmChip(
            label: loc,
            selected: _selectedBarangay == loc,
            onTap: () => setModal(() => _selectedBarangay = loc),
          )).toList(),
        ),
      ]),
    );
  }

  Widget _buildNmAmenitiesSection(StateSetter setModal) {
    final amenities = ['Wi-Fi','AC','Laundry','Kitchen','Parking',
      'Security','Gym','Pool','Study Area'];
    return NmBox(
      padding: const EdgeInsets.all(16),
      elevation: 1,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Amenities',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _textPrimary)),
        const SizedBox(height: 12),
        Wrap(spacing: 8, runSpacing: 8,
          children: amenities.map((a) => NmChip(
            label: a,
            selected: _selectedAmenities.contains(a),
            onTap: () => setModal(() {
              if (_selectedAmenities.contains(a)) {
                _selectedAmenities.remove(a);
              } else {
                _selectedAmenities.add(a);
              }
            }),
          )).toList(),
        ),
      ]),
    );
  }

  // ─── Main Build ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _nmBg,
      // ── AppBar ──────────────────────────────────────────────────────────────
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          decoration: BoxDecoration(
            color: _nmLight,
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(children: [
                // Logo / Title
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: _nmLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(children: [
                    Icon(Icons.home_work_rounded, color: _nmPrimary, size: 22),
                    const SizedBox(width: 8),
                    Text('BoardFind',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                          color: _textPrimary)),
                  ]),
                ),
                const Spacer(),
                NmIconButton(
                  icon: Icons.filter_list,
                  onTap: _showFilterModal,
                  tooltip: 'Filter',
                ),
                // AI button moved to floating implementation below
              ]),
            ),
          ),
        ),
      ),
      body: Stack(children: [
        // Main Content Area
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.only(right: _isRoomSidebarVisible ? 250 : 0),
          child: Column(children: [
            // ── Search Bar ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 450,
                  constraints: const BoxConstraints(maxWidth: 500),
                  decoration: BoxDecoration(
                    color: _nmLight,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: nmShadow(elevation: 1),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => _applyFilters(),
                    decoration: InputDecoration(
                      hintText: 'Search boardinghouses...',
                      hintStyle: TextStyle(color: _textSecondary, fontSize: 15),
                      prefixIcon: Icon(Icons.search, color: _textSecondary, size: 22),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            // ── Results count ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _nmLight,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: nmShadow(elevation: 1),
                ),
                child: Text(
                  '${_filteredBoardinghouses.length} results found',
                  style: TextStyle(
                    color: _textSecondary, fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(height: 14),
            // ── List ──────────────────────────────────────────────────────────
            Expanded(
              child: _filteredBoardinghouses.isEmpty
                ? Center(
                    child: NmBox(
                      padding: const EdgeInsets.all(24),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.search_off, color: _textSecondary, size: 48),
                        const SizedBox(height: 12),
                        Text('No boardinghouses found',
                          style: TextStyle(fontSize: 16, color: _textPrimary)),
                      ]),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredBoardinghouses.length,
                    itemBuilder: (_, i) {
                      // Show all rooms if no room is selected, otherwise show only selected room
                      if (_selectedRoom == null || 
                          int.tryParse(_filteredBoardinghouses[i].id) == _selectedRoom) {
                        return _buildBoardinghouseCard(_filteredBoardinghouses[i]);
                      }
                      return Container(); // Return empty container if room not selected
                    },
                ),
            ),
          ]),
        ),

        // Room Sidebar on the right side
        if (_isRoomSidebarVisible)
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            width: 250,
            child: RoomSidebar(
              selectedRoom: _selectedRoom,
              onRoomSelected: (roomNumber) {
                setState(() {
                  _selectedRoom = roomNumber;
                });
              },
              roomNumbers: _roomNumbers,
              isVisible: _isRoomSidebarVisible,
              onToggle: _toggleRoomSidebar,
            ),
          ),

        // ── Sidebar Reopen Button (when hidden) ────────────────────────────────
        if (!_isRoomSidebarVisible)
          Positioned(
            top: 20,
            right: 20,
            child: GestureDetector(
              onTap: _toggleRoomSidebar,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _nmLight,
                  shape: BoxShape.circle,
                  boxShadow: nmShadow(elevation: 2),
                  border: Border.all(color: _nmDark, width: 1),
                ),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: _nmPrimary,
                  size: 20,
                ),
              ),
            ),
          ),
        // ── Sidebar Reopen Button (when hidden) ────────────────────────────────
        if (!_isRoomSidebarVisible)
          Positioned(
            top: 20,
            right: 20,
            child: GestureDetector(
              onTap: _toggleRoomSidebar,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _nmLight,
                  shape: BoxShape.circle,
                  boxShadow: nmShadow(elevation: 2),
                  border: Border.all(color: _nmDark, width: 1),
                ),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: _nmPrimary,
                  size: 20,
                ),
              ),
            ),
          ),

        // ── Floating AI Chat Button ───────────────────────────────────────────
        Positioned(
          bottom: 20,
          right: _isRoomSidebarVisible ? 270 : 20, // Adjust position based on sidebar visibility
          child: ScaleTransition(
            scale: _isAiVisible 
              ? const AlwaysStoppedAnimation(0.8) 
              : const AlwaysStoppedAnimation(1.0),
            child: GestureDetector(
              onTap: _toggleAiAssistant,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF1877F2), // Changed from violet to Facebook blue
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1877F2).withOpacity(0.3), // Updated shadow color
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.2),
                      blurRadius: 0,
                      offset: const Offset(0, 0),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.psychology,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ),

        // ── AI Chat Panel ─────────────────────────────────────────────────────
        if (_isAiVisible)
          Positioned(
            top: 20,      // Add top spacing to prevent touching window border
            bottom: 90,   // Positioned above the floating button
            right: _isRoomSidebarVisible ? 270 : 20, // Adjust position based on sidebar visibility
            child: SlideTransition(
              position: _aiSlideAnimation,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Make chatbox responsive - use 90% of screen width on small screens, max 320px
                  double chatWidth = constraints.maxWidth > 400 ? 320 : constraints.maxWidth * 0.9;
                  // Adjust height based on available space
                  double chatHeight = constraints.maxHeight > 600 ? 500 : constraints.maxHeight * 0.7;
                  
                  return Container(
                    width: chatWidth,
                    height: chatHeight,
                    decoration: BoxDecoration(
                      color: _nmLight,
                      borderRadius: BorderRadius.circular(_nmRadius),
                      boxShadow: nmShadow(elevation: 8),
                    ),
                    padding: const EdgeInsets.all(16), // Add internal padding to prevent content from sticking to edges
                    child: Column(
                      children: [
                        // Header with close button (now with padding)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: _nmLight,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(_nmRadius)),
                            border: Border(
                              bottom: BorderSide(color: _nmDark, width: 1),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1877F2).withOpacity(0.1), // Updated to match new color
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.psychology, color: const Color(0xFF1877F2), size: 18),
                                ),
                                const SizedBox(width: 10),
                                Text('AI Assistant',
                                  style: TextStyle(fontWeight: FontWeight.w600,
                                      color: _textPrimary, fontSize: 15)),
                              ]),
                              GestureDetector(
                                onTap: _toggleAiAssistant,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: _nmDark.withOpacity(0.3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.close, color: _textSecondary, size: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(child: AiAssistantChatBox()),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
      ]), // Closing for Stack
    );
  }

  // ─── Image Slider ───────────────────────────────────────────────────────────
  Widget _buildImageSlider(Boardinghouse bh) {
    if (bh.images.isEmpty) {
      return Container(
        height: 400,
        decoration: BoxDecoration(
          color: _nmDark,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(_nmRadius))),
        child: Icon(Icons.image_not_supported, size: 50, color: _textSecondary));
    }

    _currentImageIndex.putIfAbsent(bh.id, () => 0);
    if (_currentImageIndex[bh.id]! >= bh.images.length) _currentImageIndex[bh.id] = 0;
    final ci = _currentImageIndex[bh.id]!;

    return Stack(children: [
      // Image
      ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(_nmRadius)),
        child: GestureDetector(
          onHorizontalDragEnd: (d) {
            if ((d.primaryVelocity ?? 0) > 0 && ci > 0) {
              setState(() => _currentImageIndex[bh.id] = ci - 1);
            } else if ((d.primaryVelocity ?? 0) < 0 &&
                ci < bh.images.length - 1) {
              setState(() => _currentImageIndex[bh.id] = ci + 1);
            }
          },
          child: Image.network(
            bh.images[ci], height: 400, width: double.infinity, fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 400, color: _nmDark,
              child: Icon(Icons.image_not_supported, size: 50, color: _textSecondary)),
          ),
        ),
      ),
      // Gradient overlay (bottom)
      Positioned(
        bottom: 0, left: 0, right: 0,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black.withOpacity(0.5), Colors.transparent])),
        ),
      ),
      // Dot indicators
      if (bh.images.length > 1)
        Positioned(
          bottom: 10, left: 0, right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(bh.images.length, (i) {
              final active = ci == i;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: active ? 20 : 8, height: 8,
                decoration: BoxDecoration(
                  color: active ? Colors.white : Colors.white54,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ),
      // Left arrow
      if (ci > 0)
        Positioned(
          left: 8, top: 0, bottom: 0,
          child: Center(
            child: GestureDetector(
              onTap: () => setState(() => _currentImageIndex[bh.id] = ci - 1),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _nmLight.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: nmShadow(elevation: 2),
                ),
                child: Icon(Icons.chevron_left, color: _textPrimary, size: 24)),
            ),
          ),
        ),
      // Right arrow
      if (ci < bh.images.length - 1)
        Positioned(
          right: 8, top: 0, bottom: 0,
          child: Center(
            child: GestureDetector(
              onTap: () => setState(() => _currentImageIndex[bh.id] = ci + 1),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _nmLight.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: nmShadow(elevation: 2),
                ),
                child: Icon(Icons.chevron_right, color: _textPrimary, size: 24)),
            ),
          ),
        ),
    ]);
  }

  // ─── Card ───────────────────────────────────────────────────────────────────
  Widget _buildBoardinghouseCard(Boardinghouse bh) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(
        builder: (_) => BoardinghouseDetailScreen(
          boardinghouse: bh, onFavoriteToggle: () {}))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: _nmLight,
          borderRadius: BorderRadius.circular(_nmRadius),
          boxShadow: nmShadow(elevation: 2),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Image slider with boarding house number overlay
          Stack(
            children: [
              _buildImageSlider(bh),
              // Boarding House Number Badge
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _nmPrimary.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: nmShadow(elevation: 3),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.home_work, color: Colors.white, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        '#${bh.id}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Title + rating
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(bh.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600, color: _textPrimary)),
                  ),
                  const SizedBox(width: 8),
                  // Rating badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: _nmBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                        const SizedBox(width: 2),
                        Flexible(
                          child: Text(
                            bh.rating > 0 ? bh.rating.toStringAsFixed(1) : 'N/A',
                            style: TextStyle(
                              fontSize: 12, color: _textPrimary, fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Location
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on, color: _textSecondary, size: 16),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(bh.location,
                      style: TextStyle(fontSize: 13, color: _textSecondary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Price
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _nmPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '₱${bh.price.toStringAsFixed(0)}/mo',
                  style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: _nmPrimary)),
              ),
              const SizedBox(height: 12),
              // Amenity chips
              if (bh.amenities.isNotEmpty)
                Wrap(
                  spacing: 6, runSpacing: 6,
                  children: bh.amenities.take(3).map((a) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _nmBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(a,
                      style: TextStyle(
                        fontSize: 11, color: _textSecondary, fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )).toList(),
                ),
            ]),
          ),
        ]),
      ),
    );
  }
}

// Helper function for capitalizing strings
String capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

// ─── String extension ──────────────────────────────────────────────────────────
extension StringExtension on String {
  String capitalize() => '${this[0].toUpperCase()}${substring(1)}';
}