import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/boardinghouse.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  MapController? _mapController;
  Boardinghouse? _selectedBoardinghouse;
  AnimationController? _cardAnimationController;
  Animation<double>? _cardAnimation;
  AnimationController? _markerAnimationController;

  // Tagoloan, Misamis Oriental coordinates
  static const LatLng _tagoloanCenter = LatLng(8.5386, 124.7744);

  // Facebook-inspired colors
  static const Color backgroundColor = Color(0xFFF0F2F5);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color primaryColor = Color(0xFF1877F2);
  static const Color textPrimary = Color(0xFF1C1E21);
  static const Color textSecondary = Color(0xFF65676B);
  static const Color shadowColor = Color(0x1A000000);

  // Sample boardinghouse data
  final List<Boardinghouse> _boardinghouses = [
    Boardinghouse(
      id: '1',
      title: 'Cozy Haven Boardinghouse',
      description: 'Comfortable boarding house near downtown Tagoloan',
      price: 3500,
      location: 'Poblacion, Tagoloan',
      images: ['https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=400'],
      amenities: ['WiFi', 'Laundry', 'Parking'],
      latitude: 8.5400,
      longitude: 124.7750,
      roomType: 'Single',
      contactNumber: '+639123456789',
    ),
    Boardinghouse(
      id: '2',
      title: 'Student\'s Paradise',
      description: 'Perfect for students, near schools and universities',
      price: 4200,
      location: 'Natumolan, Tagoloan',
      images: ['https://images.unsplash.com/photo-1555854877-bab0e564b8d5?w=400'],
      amenities: ['WiFi', 'Study Area', 'Kitchen'],
      latitude: 8.5370,
      longitude: 124.7730,
      roomType: 'Double',
      contactNumber: '+639123456788',
    ),
    Boardinghouse(
      id: '3',
      title: 'Modern Living Quarters',
      description: 'Modern facilities with AC and comfortable beds',
      price: 5000,
      location: 'Riverside, Tagoloan',
      images: ['https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=400'],
      amenities: ['WiFi', 'AC', 'TV', 'Balcony'],
      latitude: 8.5410,
      longitude: 124.7760,
      roomType: 'Single',
      contactNumber: '+639123456787',
    ),
    Boardinghouse(
      id: '4',
      title: 'Comfort Zone BH',
      description: 'Affordable and comfortable living space',
      price: 3800,
      location: 'Balintawak, Tagoloan',
      images: ['https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=400'],
      amenities: ['WiFi', 'Laundry', 'Parking'],
      latitude: 8.5360,
      longitude: 124.7740,
      roomType: 'Single',
      contactNumber: '+639123456786',
    ),
    Boardinghouse(
      id: '5',
      title: 'Peaceful Stay',
      description: 'Quiet place perfect for professionals',
      price: 4500,
      location: 'San Isidro, Tagoloan',
      images: ['https://images.unsplash.com/photo-1484101403633-562f891dc89a?w=400'],
      amenities: ['WiFi', 'AC', 'Kitchen'],
      latitude: 8.5395,
      longitude: 124.7735,
      roomType: 'Double',
      contactNumber: '+639123456785',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _cardAnimation = CurvedAnimation(
      parent: _cardAnimationController!,
      curve: Curves.easeOutCubic,
    );

    _markerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  void _onMarkerTapped(Boardinghouse boardinghouse) {
    setState(() {
      _selectedBoardinghouse = boardinghouse;
    });

    _markerAnimationController?.forward(from: 0).then((_) {
      _markerAnimationController?.reverse();
    });

    _cardAnimationController?.forward(from: 0);

    // Move map to marker position
    _mapController?.move(
      LatLng(boardinghouse.latitude, boardinghouse.longitude),
      16.0,
    );
  }

  void _navigateToDetails() {
    if (_selectedBoardinghouse != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Navigating to ${_selectedBoardinghouse!.title}'),
          backgroundColor: primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _cardAnimationController?.dispose();
    _markerAnimationController?.dispose();
    super.dispose();
  }

  // Clean card container builder
  Widget _buildCard({
    required Widget child,
    double borderRadius = 8,
    EdgeInsets? padding,
    EdgeInsets? margin,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          color: cardBackground,
          borderRadius: BorderRadius.circular(borderRadius),
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
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: cardBackground,
        surfaceTintColor: cardBackground,
        title: const Text(
          'Boardinghouses Map',
          style: TextStyle(
            color: textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: const Color(0xFFE4E6EB),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  _mapController?.move(
                    _tagoloanCenter,
                    14.0,
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.my_location,
                    color: primaryColor,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map container
          Padding(
            padding: const EdgeInsets.all(12),
            child: _buildCard(
              borderRadius: 12,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _tagoloanCenter,
                    initialZoom: 14.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                      userAgentPackageName: 'boardinghouse_finder.app',
                    ),
                    MarkerLayer(
                      markers: _boardinghouses.map((boardinghouse) {
                        final isSelected = _selectedBoardinghouse?.id == boardinghouse.id;
                        return Marker(
                          point: LatLng(boardinghouse.latitude, boardinghouse.longitude),
                          width: 56,
                          height: 56,
                          child: GestureDetector(
                            onTap: () => _onMarkerTapped(boardinghouse),
                            child: AnimatedScale(
                              scale: isSelected ? 1.15 : 1.0,
                              duration: const Duration(milliseconds: 200),
                              child: Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: isSelected ? primaryColor : cardBackground,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected ? Colors.white : primaryColor.withOpacity(0.3),
                                    width: isSelected ? 3 : 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: isSelected 
                                          ? primaryColor.withOpacity(0.3)
                                          : shadowColor,
                                      offset: const Offset(0, 2),
                                      blurRadius: isSelected ? 8 : 4,
                                      spreadRadius: isSelected ? 2 : 0,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.home_rounded,
                                  color: isSelected ? cardBackground : primaryColor,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Legend
          Positioned(
            top: 24,
            left: 24,
            child: _buildCard(
              borderRadius: 20,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_boardinghouses.length} Available',
                    style: const TextStyle(
                      color: textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Boardinghouse Info Card
          if (_selectedBoardinghouse != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(_cardAnimation!),
                child: FadeTransition(
                  opacity: _cardAnimation!,
                  child: _buildBoardinghouseCard(_selectedBoardinghouse!),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBoardinghouseCard(Boardinghouse boardinghouse) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _navigateToDetails,
        borderRadius: BorderRadius.circular(16),
        child: _buildCard(
          margin: const EdgeInsets.all(12),
          borderRadius: 16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with close button
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 12, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Property Details',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          _cardAnimationController?.reverse().then((_) {
                            setState(() {
                              _selectedBoardinghouse = null;
                            });
                          });
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 36,
                          height: 36,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.close,
                            size: 20,
                            color: textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Content
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Row(
                  children: [
                    // Image
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: shadowColor,
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          boardinghouse.images.isNotEmpty
                              ? boardinghouse.images[0]
                              : 'https://via.placeholder.com/400',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.home_rounded,
                                size: 40,
                                color: primaryColor.withOpacity(0.3),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            boardinghouse.title,
                            style: const TextStyle(
                              fontSize: 16,
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
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Price badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  '₱',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: primaryColor,
                                  ),
                                ),
                                Text(
                                  '${boardinghouse.price.toStringAsFixed(0)}/mo',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Arrow icon
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        size: 18,
                        color: primaryColor,
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
}