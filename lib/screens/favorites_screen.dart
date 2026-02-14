import 'package:flutter/material.dart';
import '../models/boardinghouse.dart';
import 'boardinghouse_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Boardinghouse> favorites = [];
  bool isLoading = true;

  // Facebook-inspired colors
  static const Color backgroundColor = Color(0xFFF0F2F5);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color primaryColor = Color(0xFF1877F2);
  static const Color textPrimary = Color(0xFF1C1E21);
  static const Color textSecondary = Color(0xFF65676B);
  static const Color dividerColor = Color(0xFFE4E6EB);
  static const Color shadowColor = Color(0x1A000000);

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  // Load favorites from your backend/database
  Future<void> _loadFavorites() async {
    setState(() {
      isLoading = true;
    });

    try {
      // TODO: Replace with your actual API call or database query
      // Example:
      // final response = await http.get(Uri.parse('YOUR_API_URL/favorites'));
      // final List<dynamic> data = json.decode(response.body);
      // final loadedFavorites = data.map((json) => Boardinghouse.fromJson(json)).toList();
      
      // Simulating API call with sample data for now
      await Future.delayed(const Duration(milliseconds: 500));
      
      setState(() {
        favorites = [
          Boardinghouse(
            id: '1',
            title: 'Cozy Downtown Studio',
            description: 'Comfortable studio in the heart of the city',
            price: 1500.00,
            location: 'Poblacion, Tagoloan, Misamis Oriental',
            images: ['https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800', 'https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=800', 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800'],
            amenities: ['Wi-Fi', 'Aircon'],
            latitude: 8.5361,
            longitude: 124.7544,
            roomType: 'Studio',
            contactNumber: '+639123456789',
          ),
          Boardinghouse(
            id: '2',
            title: 'Modern City Apartment',
            description: 'Modern apartment with great amenities',
            price: 2000.00,
            location: 'Natumolan, Tagoloan, Misamis Oriental',
            images: ['https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800', 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800', 'https://images.unsplash.com/photo-1536376072261-38c75010e6c9?w=800', 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800'],
            amenities: ['Wi-Fi', 'Aircon', 'Kitchen'],
            latitude: 8.5422,
            longitude: 124.7601,
            roomType: '1 Bedroom',
            contactNumber: '+639123456790',
          ),
          Boardinghouse(
            id: '3',
            title: 'Peaceful Suburban Home',
            description: 'Quiet residential area with friendly neighbors',
            price: 1200.00,
            location: 'Gracia, Tagoloan, Misamis Oriental',
            images: ['https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800', 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=800', 'https://images.unsplash.com/photo-1484154218962-a197022b5858?w=800'],
            amenities: ['Wi-Fi', 'Laundry', 'Garden'],
            latitude: 8.5298,
            longitude: 124.7489,
            roomType: 'Shared Room',
            contactNumber: '+639123456791',
          ),
        ];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to load favorites'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  void _removeFavorite(String id) async {
    // Optimistically update UI
    final removedItem = favorites.firstWhere((item) => item.id == id);
    setState(() {
      favorites.removeWhere((boardinghouse) => boardinghouse.id == id);
    });
    
    try {
      // TODO: Replace with your actual API call
      // Example:
      // await http.delete(Uri.parse('YOUR_API_URL/favorites/$id'));
      
      // Simulating API call
      await Future.delayed(const Duration(milliseconds: 300));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Removed from favorites'),
            duration: const Duration(seconds: 2),
            backgroundColor: primaryColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      // If API call fails, restore the item
      setState(() {
        favorites.add(removedItem);
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to remove favorite'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  void _navigateToDetail(Boardinghouse boardinghouse) {
    // Navigate to BoardinghouseDetailScreen
    // Replace with your actual navigation logic
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BoardinghouseDetailScreen(
          boardinghouse: boardinghouse,
          onFavoriteToggle: () {
            // Handle favorite toggle logic here
            _removeFavorite(boardinghouse.id);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: cardBackground,
        surfaceTintColor: cardBackground,
        elevation: 0,
        title: const Text(
          'My Favorites',
          style: TextStyle(
            color: textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(color: textPrimary),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: dividerColor,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _loadFavorites,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.refresh,
                    color: primaryColor,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
                strokeWidth: 3,
              ),
            )
          : favorites.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  color: primaryColor,
                  backgroundColor: cardBackground,
                  onRefresh: _loadFavorites,
                  child: _buildFavoritesList(),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_border,
              size: 50,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Favorites Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Start adding boardinghouses to your favorites to see them here',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final boardinghouse = favorites[index];
        return _buildBoardinghouseCard(boardinghouse);
      },
    );
  }

  Widget _buildBoardinghouseCard(Boardinghouse boardinghouse) {
    return Dismissible(
      key: Key(boardinghouse.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red[400],
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 24,
        ),
      ),
      onDismissed: (direction) {
        _removeFavorite(boardinghouse.id);
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToDetail(boardinghouse),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: cardBackground,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  offset: const Offset(0, 1),
                  blurRadius: 2,
                ),
                BoxShadow(
                  color: shadowColor.withOpacity(0.5),
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image section
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: Image.network(
                        boardinghouse.images.isNotEmpty ? boardinghouse.images[0] : '',
                        height: 400,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 400,
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            child: const Icon(
                              Icons.image_not_supported_outlined,
                              size: 48,
                              color: textSecondary,
                            ),
                          );
                        },
                      ),
                    ),
                    // Favorite button overlay
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _removeFavorite(boardinghouse.id),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: cardBackground,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: shadowColor,
                                  offset: const Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.favorite,
                              color: primaryColor,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Content section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        boardinghouse.title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              boardinghouse.location,
                              style: const TextStyle(
                                fontSize: 13,
                                color: textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 1,
                        color: dividerColor,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '₱${boardinghouse.price.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: primaryColor,
                                  ),
                                ),
                                const TextSpan(
                                  text: '/month',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: textSecondary,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  'View Details',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: primaryColor,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 14,
                                  color: primaryColor,
                                ),
                              ],
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
      ),
    );
  }
}