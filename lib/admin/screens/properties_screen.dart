import 'package:flutter/material.dart';

void main() {
  runApp(const BoardinghouseFinderApp());
}

// ─── Facebook-inspired Color Palette ──────────────────────────────────────────
class FBColors {
  static const Color primary       = Color(0xFF1877F2); // Facebook Blue
  static const Color primaryDark   = Color(0xFF0D65D9);
  static const Color primaryLight  = Color(0xFFE7F0FD);
  static const Color background    = Color(0xFFF0F2F5); // FB Light Gray BG
  static const Color surface       = Color(0xFFFFFFFF); // White cards
  static const Color textPrimary   = Color(0xFF1C1E21); // Dark gray
  static const Color textSecondary = Color(0xFF65676B); // Lighter gray
  static const Color textHint      = Color(0xFF8A8D91);
  static const Color divider       = Color(0xFFDDDFE2);
  static const Color success       = Color(0xFF2D9B6F);
  static const Color successLight  = Color(0xFFE6F4EE);
  static const Color danger        = Color(0xFFE53935);
  static const Color dangerLight   = Color(0xFFFDECEC);
  static const Color warning       = Color(0xFFF09A1A);
  static const Color warningLight  = Color(0xFFFEF3E0);
  static const Color shadow        = Color(0x14000000);
}

class BoardinghouseFinderApp extends StatelessWidget {
  const BoardinghouseFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boardinghouse Finder - Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: FBColors.primary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: FBColors.background,
        fontFamily: 'Roboto',
      ),
      home: const PropertiesScreen(),
    );
  }
}

// ─── Data Models ──────────────────────────────────────────────────────────────

enum PropertyStatus { available, occupied, pendingApproval }

class Property {
  final String id;
  final String name;
  final String address;
  final double monthlyPrice;
  final PropertyStatus status;
  final int totalSlots;
  final int occupiedSlots;
  final String imageUrl;
  final String ownerName;

  const Property({
    required this.id,
    required this.name,
    required this.address,
    required this.monthlyPrice,
    required this.status,
    required this.totalSlots,
    required this.occupiedSlots,
    required this.imageUrl,
    required this.ownerName,
  });
}

// ─── Sample Data ──────────────────────────────────────────────────────────────

final List<Property> _sampleProperties = [
  const Property(
    id: '1',
    name: 'Sunshine Boardinghouse',
    address: 'Purok 1, Poblacion, Tagoloan, Misamis Oriental',
    monthlyPrice: 3500,
    status: PropertyStatus.available,
    totalSlots: 8,
    occupiedSlots: 5,
    imageUrl: 'https://picsum.photos/seed/house1/400/300',
    ownerName: 'Maria Santos',
  ),
  const Property(
    id: '2',
    name: 'Green View Dormitory',
    address: 'Purok 4, Barangay Baluarte, Tagoloan, Misamis Oriental',
    monthlyPrice: 2800,
    status: PropertyStatus.occupied,
    totalSlots: 10,
    occupiedSlots: 10,
    imageUrl: 'https://picsum.photos/seed/house2/400/300',
    ownerName: 'Jose Reyes',
  ),
  const Property(
    id: '3',
    name: 'Blue Haven Rooms',
    address: 'Purok 2, Barangay Casinglot, Tagoloan, Misamis Oriental',
    monthlyPrice: 4200,
    status: PropertyStatus.pendingApproval,
    totalSlots: 6,
    occupiedSlots: 0,
    imageUrl: 'https://picsum.photos/seed/house3/400/300',
    ownerName: 'Ana Cruz',
  ),
  const Property(
    id: '4',
    name: 'Riverside Lodge',
    address: 'Purok 3, Barangay Natumolan, Tagoloan, Misamis Oriental',
    monthlyPrice: 3000,
    status: PropertyStatus.available,
    totalSlots: 12,
    occupiedSlots: 7,
    imageUrl: 'https://picsum.photos/seed/house4/400/300',
    ownerName: 'Pedro Lim',
  ),
  const Property(
    id: '5',
    name: 'Valley Suites',
    address: 'Purok 5, Barangay Linao, Tagoloan, Misamis Oriental',
    monthlyPrice: 5000,
    status: PropertyStatus.pendingApproval,
    totalSlots: 15,
    occupiedSlots: 0,
    imageUrl: 'https://picsum.photos/seed/house5/400/300',
    ownerName: 'Gloria Tan',
  ),
];

// ─── Shared Decoration Helpers ─────────────────────────────────────────────────

BoxDecoration get _cardDecoration => BoxDecoration(
      color: FBColors.surface,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: FBColors.shadow,
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
    );

// ─── Main Screen ──────────────────────────────────────────────────────────────

class PropertiesScreen extends StatefulWidget {
  const PropertiesScreen({super.key});

  @override
  State<PropertiesScreen> createState() => _PropertiesScreenState();
}

class _PropertiesScreenState extends State<PropertiesScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  PropertyStatus? _selectedFilter;
  bool _isGridView = true;
  List<Property> _allProperties = [];
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _allProperties = List.from(_sampleProperties);
    _fadeController.forward();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  List<Property> get _filteredProperties {
    return _allProperties.where((p) {
      final q = _searchController.text.toLowerCase();
      final matchesSearch = q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.address.toLowerCase().contains(q);
      final matchesFilter =
          _selectedFilter == null || p.status == _selectedFilter;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _deleteProperty(Property property) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: FBColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Delete Property',
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: FBColors.textPrimary),
        ),
        content: Text(
          'Are you sure you want to delete "${property.name}"? This action cannot be undone.',
          style: const TextStyle(fontSize: 14, color: FBColors.textSecondary),
        ),
        actionsPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            style: TextButton.styleFrom(
              foregroundColor: FBColors.textSecondary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: const Text('Cancel',
                style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: FBColors.danger,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _allProperties.remove(property));
              _showSnackbar('${property.name} has been deleted.', FBColors.danger);
            },
            child: const Text('Delete',
                style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style: const TextStyle(fontWeight: FontWeight.w500)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showPropertyDetail(Property property) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => _PropertyDetailSheet(property: property),
    );
  }

  void _showEditDialog(Property property) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => _EditPropertyDialog(property: property),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FBColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildSearchAndFilter(),
          _buildStatsRow(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 20,
        right: 20,
        bottom: 14,
      ),
      decoration: const BoxDecoration(
        color: FBColors.surface,
        border: Border(
          bottom: BorderSide(color: FBColors.divider, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Logo area
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: FBColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.home_work_rounded,
                color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Properties',
                  style: TextStyle(
                    color: FBColors.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  'Manage all boardinghouse listings',
                  style: TextStyle(
                    color: FBColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // View toggle
          Container(
            decoration: BoxDecoration(
              color: FBColors.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: FBColors.divider),
            ),
            child: Row(
              children: [
                _viewToggleBtn(Icons.grid_view_rounded, true),
                _viewToggleBtn(Icons.table_rows_rounded, false),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Add button
          ElevatedButton.icon(
            onPressed: () => _showSnackbar(
                'Opening Add Property form...', FBColors.success),
            style: ElevatedButton.styleFrom(
              backgroundColor: FBColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text(
              'Add Property',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _viewToggleBtn(IconData icon, bool isGrid) {
    final active = _isGridView == isGrid;
    return GestureDetector(
      onTap: () => setState(() => _isGridView = isGrid),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: active ? FBColors.primaryLight : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(
          icon,
          size: 18,
          color: active ? FBColors.primary : FBColors.textHint,
        ),
      ),
    );
  }

  // ── Search & Filter ──────────────────────────────────────────────────────────
  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      decoration: const BoxDecoration(
        color: FBColors.surface,
        border: Border(
          bottom: BorderSide(color: FBColors.divider, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search
          TextField(
            controller: _searchController,
            style: const TextStyle(
                fontSize: 14, color: FBColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Search properties by name or barangay...',
              hintStyle: const TextStyle(
                  color: FBColors.textHint, fontSize: 14),
              prefixIcon: const Icon(Icons.search_rounded,
                  color: FBColors.textHint, size: 20),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.cancel_rounded,
                          color: FBColors.textHint, size: 18),
                      onPressed: () => _searchController.clear(),
                    )
                  : null,
              filled: true,
              fillColor: FBColors.background,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22),
                borderSide: const BorderSide(
                    color: FBColors.primary, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterChip('All', null),
                const SizedBox(width: 8),
                _filterChip('Available', PropertyStatus.available),
                const SizedBox(width: 8),
                _filterChip('Occupied', PropertyStatus.occupied),
                const SizedBox(width: 8),
                _filterChip('Pending Approval', PropertyStatus.pendingApproval),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, PropertyStatus? status) {
    final isSelected = _selectedFilter == status;
    Color chipColor;
    Color textColor;
    Color borderColor;

    if (isSelected) {
      switch (status) {
        case PropertyStatus.available:
          chipColor = FBColors.success;
          textColor = Colors.white;
          borderColor = FBColors.success;
          break;
        case PropertyStatus.occupied:
          chipColor = FBColors.danger;
          textColor = Colors.white;
          borderColor = FBColors.danger;
          break;
        case PropertyStatus.pendingApproval:
          chipColor = FBColors.warning;
          textColor = Colors.white;
          borderColor = FBColors.warning;
          break;
        default:
          chipColor = FBColors.primary;
          textColor = Colors.white;
          borderColor = FBColors.primary;
      }
    } else {
      chipColor = FBColors.surface;
      textColor = FBColors.textSecondary;
      borderColor = FBColors.divider;
    }

    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = status),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: chipColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textColor)),
      ),
    );
  }

  // ── Stats Row ────────────────────────────────────────────────────────────────
  Widget _buildStatsRow() {
    final total = _allProperties.length;
    final available = _allProperties
        .where((p) => p.status == PropertyStatus.available)
        .length;
    final occupied = _allProperties
        .where((p) => p.status == PropertyStatus.occupied)
        .length;
    final pending = _allProperties
        .where((p) => p.status == PropertyStatus.pendingApproval)
        .length;

    return Container(
      color: FBColors.background,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          _statCard('Total', total.toString(), FBColors.primary,
              FBColors.primaryLight, Icons.home_work_rounded),
          const SizedBox(width: 10),
          _statCard('Available', available.toString(), FBColors.success,
              FBColors.successLight, Icons.check_circle_outline_rounded),
          const SizedBox(width: 10),
          _statCard('Occupied', occupied.toString(), FBColors.danger,
              FBColors.dangerLight, Icons.people_rounded),
          const SizedBox(width: 10),
          _statCard('Pending', pending.toString(), FBColors.warning,
              FBColors.warningLight, Icons.pending_actions_rounded),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, Color accent, Color bgColor,
      IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: FBColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
                color: FBColors.shadow, blurRadius: 6, offset: Offset(0, 2))
          ],
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: accent, size: 16),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: FBColors.textPrimary)),
                  Text(label,
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: FBColors.textSecondary)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Body ──────────────────────────────────────────────────────────────────────
  Widget _buildBody() {
    final filtered = _filteredProperties;
    if (filtered.isEmpty) return _buildEmptyState();

    return FadeTransition(
      opacity: _fadeAnimation,
      child: _isGridView ? _buildGridView(filtered) : _buildListView(filtered),
    );
  }

  Widget _buildEmptyState() {
    final hasFilter =
        _selectedFilter != null || _searchController.text.isNotEmpty;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: FBColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              hasFilter
                  ? Icons.search_off_rounded
                  : Icons.home_work_outlined,
              size: 52,
              color: FBColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            hasFilter ? 'No Properties Found' : 'No Properties Yet',
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: FBColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            hasFilter
                ? 'Try adjusting your search or filter.'
                : 'Start building your directory by adding\nthe first boardinghouse listing.',
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 14, color: FBColors.textSecondary, height: 1.6),
          ),
          const SizedBox(height: 24),
          if (hasFilter)
            OutlinedButton.icon(
              onPressed: () {
                _searchController.clear();
                setState(() => _selectedFilter = null);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: FBColors.primary,
                side: const BorderSide(color: FBColors.primary, width: 1.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Clear Filters',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            )
          else
            ElevatedButton.icon(
              onPressed: () => _showSnackbar(
                  'Opening Add Property form...', FBColors.success),
              style: ElevatedButton.styleFrom(
                backgroundColor: FBColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
              ),
              icon: const Icon(Icons.add_rounded, size: 20),
              label: const Text('Add First Property',
                  style:
                      TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            ),
        ],
      ),
    );
  }

  Widget _buildGridView(List<Property> properties) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        itemCount: properties.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 360,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.78,
        ),
        itemBuilder: (_, i) => _PropertyCard(
          property: properties[i],
          onView: () => _showPropertyDetail(properties[i]),
          onEdit: () => _showEditDialog(properties[i]),
          onDelete: () => _deleteProperty(properties[i]),
        ),
      ),
    );
  }

  Widget _buildListView(List<Property> properties) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: properties.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _PropertyListTile(
        property: properties[i],
        onView: () => _showPropertyDetail(properties[i]),
        onEdit: () => _showEditDialog(properties[i]),
        onDelete: () => _deleteProperty(properties[i]),
      ),
    );
  }
}

// ─── Property Card (Grid) ──────────────────────────────────────────────────────

class _PropertyCard extends StatelessWidget {
  final Property property;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _PropertyCard({
    required this.property,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(12)),
            child: Stack(
              children: [
                Image.network(
                  property.imageUrl,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 140,
                    color: FBColors.background,
                    child: const Icon(Icons.home_rounded,
                        size: 48, color: FBColors.divider),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: _StatusBadge(status: property.status),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: FBColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded,
                            size: 12, color: FBColors.textHint),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            property.address,
                            style: const TextStyle(
                                fontSize: 11,
                                color: FBColors.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₱${property.monthlyPrice.toStringAsFixed(0)}/mo',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: FBColors.primary,
                          ),
                        ),
                        _OccupancyIndicator(
                          occupied: property.occupiedSlots,
                          total: property.totalSlots,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Divider
                    const Divider(
                        height: 1, thickness: 1, color: FBColors.divider),
                    const SizedBox(height: 10),
                    // Action buttons
                    Row(
                      children: [
                        _ActionBtn(
                          icon: Icons.visibility_rounded,
                          color: FBColors.primary,
                          label: 'View',
                          onTap: onView,
                        ),
                        const SizedBox(width: 6),
                        _ActionBtn(
                          icon: Icons.edit_rounded,
                          color: FBColors.success,
                          label: 'Edit',
                          onTap: onEdit,
                        ),
                        const SizedBox(width: 6),
                        _ActionBtn(
                          icon: Icons.delete_outline_rounded,
                          color: FBColors.danger,
                          label: 'Del',
                          onTap: onDelete,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Property List Tile ────────────────────────────────────────────────────────

class _PropertyListTile extends StatelessWidget {
  final Property property;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _PropertyListTile({
    required this.property,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              property.imageUrl,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 72,
                height: 72,
                color: FBColors.background,
                child: const Icon(Icons.home_rounded,
                    size: 32, color: FBColors.divider),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        property.name,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: FBColors.textPrimary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _StatusBadge(status: property.status),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded,
                        size: 12, color: FBColors.textHint),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        property.address,
                        style: const TextStyle(
                            fontSize: 11,
                            color: FBColors.textSecondary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '₱${property.monthlyPrice.toStringAsFixed(0)}/mo',
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: FBColors.primary),
                    ),
                    const SizedBox(width: 12),
                    _OccupancyIndicator(
                      occupied: property.occupiedSlots,
                      total: property.totalSlots,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              _IconActionBtn(
                  icon: Icons.visibility_rounded,
                  color: FBColors.primary,
                  onTap: onView),
              const SizedBox(height: 4),
              _IconActionBtn(
                  icon: Icons.edit_rounded,
                  color: FBColors.success,
                  onTap: onEdit),
              const SizedBox(height: 4),
              _IconActionBtn(
                  icon: Icons.delete_outline_rounded,
                  color: FBColors.danger,
                  onTap: onDelete),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Supporting Widgets ────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final PropertyStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    String label;

    switch (status) {
      case PropertyStatus.available:
        bg = FBColors.success;
        label = 'Available';
        break;
      case PropertyStatus.occupied:
        bg = FBColors.danger;
        label = 'Occupied';
        break;
      case PropertyStatus.pendingApproval:
        bg = FBColors.warning;
        label = 'Pending';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.white),
      ),
    );
  }
}

class _OccupancyIndicator extends StatelessWidget {
  final int occupied;
  final int total;
  const _OccupancyIndicator({required this.occupied, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.people_alt_rounded,
            size: 12, color: FBColors.textHint),
        const SizedBox(width: 3),
        Text(
          '$occupied/$total',
          style: const TextStyle(
              fontSize: 11, color: FBColors.textSecondary),
        ),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: color == FBColors.primary
                ? FBColors.primaryLight
                : color == FBColors.success
                    ? FBColors.successLight
                    : FBColors.dangerLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 13, color: color),
              const SizedBox(width: 3),
              Text(label,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: color)),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _IconActionBtn(
      {required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color == FBColors.primary
              ? FBColors.primaryLight
              : color == FBColors.success
                  ? FBColors.successLight
                  : FBColors.dangerLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}

// ─── Property Detail Dialog ────────────────────────────────────────────────────

class _PropertyDetailSheet extends StatelessWidget {
  final Property property;
  const _PropertyDetailSheet({required this.property});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: FBColors.surface,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      child: Container(
        width: 480,
        decoration: BoxDecoration(
          color: FBColors.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding:
                    const EdgeInsets.fromLTRB(20, 16, 16, 16),
                decoration: const BoxDecoration(
                  color: FBColors.primary,
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(14)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.home_work_rounded,
                        color: Colors.white, size: 18),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Property Details',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(Icons.close_rounded,
                            color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
              ),

              // Image
              Image.network(
                property.imageUrl,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 160,
                  color: FBColors.background,
                  child: const Icon(Icons.home_rounded,
                      size: 64, color: FBColors.divider),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            property.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: FBColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _StatusBadge(status: property.status),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded,
                            size: 13,
                            color: FBColors.textSecondary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            property.address,
                            style: const TextStyle(
                                fontSize: 12,
                                color: FBColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(
                        height: 1,
                        thickness: 1,
                        color: FBColors.divider),
                    const SizedBox(height: 14),
                    _detailRow(Icons.person_rounded, 'Owner',
                        property.ownerName),
                    _detailRow(Icons.payments_rounded, 'Monthly Price',
                        '₱${property.monthlyPrice.toStringAsFixed(0)}'),
                    _detailRow(
                        Icons.people_rounded,
                        'Occupancy',
                        '${property.occupiedSlots} / ${property.totalSlots} slots'),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (_) => _EditPropertyDialog(
                                    property: property),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: FBColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(8)),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                            ),
                            icon: const Icon(Icons.edit_rounded, size: 15),
                            label: const Text('Edit Property',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor:
                                  FBColors.textSecondary,
                              side: const BorderSide(
                                  color: FBColors.divider),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(8)),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                            ),
                            icon: const Icon(Icons.close_rounded,
                                size: 15),
                            label: const Text('Close',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: FBColors.primaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 15, color: FBColors.primary),
          ),
          const SizedBox(width: 12),
          Text('$label:',
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: FBColors.textPrimary)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 13,
                    color: FBColors.textSecondary)),
          ),
        ],
      ),
    );
  }
}

// ─── Edit Property Dialog ──────────────────────────────────────────────────────

class _EditPropertyDialog extends StatefulWidget {
  final Property property;
  const _EditPropertyDialog({required this.property});

  @override
  State<_EditPropertyDialog> createState() => _EditPropertyDialogState();
}

class _EditPropertyDialogState extends State<_EditPropertyDialog> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _priceController;
  late TextEditingController _ownerController;
  late PropertyStatus _selectedStatus;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.property.name);
    _addressController =
        TextEditingController(text: widget.property.address);
    _priceController = TextEditingController(
        text: widget.property.monthlyPrice.toStringAsFixed(0));
    _ownerController =
        TextEditingController(text: widget.property.ownerName);
    _selectedStatus = widget.property.status;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _priceController.dispose();
    _ownerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: FBColors.surface,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      child: Container(
        width: 480,
        decoration: BoxDecoration(
          color: FBColors.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding:
                    const EdgeInsets.fromLTRB(20, 16, 16, 16),
                decoration: const BoxDecoration(
                  color: FBColors.primary,
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(14)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.edit_rounded,
                        color: Colors.white, size: 18),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Edit Property',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(Icons.close_rounded,
                            color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
              ),

              // Form
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildField('Property Name', _nameController,
                        Icons.home_work_rounded),
                    const SizedBox(height: 14),
                    _buildField(
                        'Address (Tagoloan, Misamis Oriental)',
                        _addressController,
                        Icons.location_on_rounded),
                    const SizedBox(height: 14),
                    _buildField('Monthly Price (₱)', _priceController,
                        Icons.payments_rounded,
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 14),
                    _buildField('Owner Name', _ownerController,
                        Icons.person_rounded),
                    const SizedBox(height: 14),

                    // Status
                    const Text(
                      'Status',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: FBColors.textPrimary),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: FBColors.background,
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: FBColors.divider),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<PropertyStatus>(
                          value: _selectedStatus,
                          isExpanded: true,
                          dropdownColor: FBColors.surface,
                          icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 18,
                              color: FBColors.textSecondary),
                          style: const TextStyle(
                              fontSize: 13,
                              color: FBColors.textPrimary),
                          onChanged: (val) =>
                              setState(() => _selectedStatus = val!),
                          items: const [
                            DropdownMenuItem(
                              value: PropertyStatus.available,
                              child: Text('Available'),
                            ),
                            DropdownMenuItem(
                              value: PropertyStatus.occupied,
                              child: Text('Occupied'),
                            ),
                            DropdownMenuItem(
                              value: PropertyStatus.pendingApproval,
                              child: Text('Pending Approval'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Actions
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: FBColors.textSecondary,
                          side: const BorderSide(
                              color: FBColors.divider),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12),
                        ),
                        child: const Text('Cancel',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  '${_nameController.text} updated successfully!',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500)),
                              backgroundColor: FBColors.success,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(10)),
                              margin: const EdgeInsets.all(16),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: FBColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding:
                              const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Save Changes',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: FBColors.textPrimary),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(
              fontSize: 13, color: FBColors.textPrimary),
          decoration: InputDecoration(
            prefixIcon: Icon(icon,
                size: 16, color: FBColors.textHint),
            filled: true,
            fillColor: FBColors.background,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: FBColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: FBColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                  color: FBColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}