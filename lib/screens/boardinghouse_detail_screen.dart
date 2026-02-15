import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import '../models/boardinghouse.dart';
import '../services/map_service.dart';
import '../widgets/interested/interested_button.dart';
import '../widgets/interested/interested_dialog.dart';

class BoardinghouseDetailScreen extends StatefulWidget {
  final Boardinghouse boardinghouse;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const BoardinghouseDetailScreen({
    super.key,
    required this.boardinghouse,
    this.isFavorite = false,
    required this.onFavoriteToggle,
  });

  @override
  State<BoardinghouseDetailScreen> createState() => _BoardinghouseDetailScreenState();
}

class _BoardinghouseDetailScreenState extends State<BoardinghouseDetailScreen> {
  int _currentImageIndex = 0;
  LatLng? _boardingHouseLocation;
  Map<String, dynamic>? _mapData;
  bool _isLoadingMapData = true;
  bool _mapDataError = false;
  bool _isInterested = false;

  // Facebook Settings colors
  static const Color _bgColor = Color(0xFFF0F2F5);
  static const Color _primary = Color(0xFF1877F2);
  static const Color _cardColor = Color(0xFFFFFFFF);
  static const Color _borderColor = Color(0xFFE4E6EB);
  static const Color _textPrimary = Color(0xFF1C1E21);
  static const Color _textSecondary = Color(0xFF65676B);

  @override
  void initState() {
    super.initState();
    _boardingHouseLocation = LatLng(widget.boardinghouse.latitude, widget.boardinghouse.longitude);
    _loadMapData();
  }

  Future<void> _loadMapData() async {
    setState(() {
      _isLoadingMapData = true;
      _mapDataError = false;
    });
    
    try {
      final mapData = await MapService.getMapData(widget.boardinghouse.id);
      if (mounted) {
        setState(() {
          _mapData = mapData;
          _isLoadingMapData = false;
          if (mapData != null) {
            _boardingHouseLocation = LatLng(
              mapData['latitude']?.toDouble() ?? widget.boardinghouse.latitude,
              mapData['longitude']?.toDouble() ?? widget.boardinghouse.longitude,
            );
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingMapData = false;
          _mapDataError = true;
        });
      }
    }
  }

  Future<void> _reloadMap() async {
    setState(() {
      _isLoadingMapData = true;
      _mapDataError = false;
    });
    await _loadMapData();
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Could not launch URL'),
            backgroundColor: _primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    }
  }

  void _showInterestedDialog() {
    showDialog(
      context: context,
      builder: (context) => InterestedDialog(
        boardinghouseTitle: widget.boardinghouse.title,
        boardinghouseId: widget.boardinghouse.id,
      ),
    ).then((_) {
      // Update interested state after dialog closes
      if (mounted) {
        setState(() => _isInterested = true);
      }
    });
  }

  void _showContactOptions() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Contact Options',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              _buildContactOption(
                Icons.phone,
                'Call',
                widget.boardinghouse.contactNumber,
                () {
                  Navigator.pop(context);
                  _launchUrl('tel:${widget.boardinghouse.contactNumber}');
                },
              ),
              const SizedBox(height: 12),
              _buildContactOption(
                Icons.message,
                'Send Message',
                'via SMS',
                () {
                  Navigator.pop(context);
                  _launchUrl('sms:${widget.boardinghouse.contactNumber}');
                },
              ),
              const SizedBox(height: 12),
              _buildContactOption(
                Icons.message,
                'WhatsApp',
                'via WhatsApp',
                () {
                  Navigator.pop(context);
                  _launchUrl('https://wa.me/${widget.boardinghouse.contactNumber}');
                },
                iconColor: Colors.green,
              ),
              const SizedBox(height: 20),
              _buildButton(
                'Cancel',
                () => Navigator.pop(context),
                isSecondary: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactOption(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    Color iconColor = _primary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: _textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: _textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: _textSecondary, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onTap, {bool isSecondary = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSecondary ? _bgColor : _primary,
          borderRadius: BorderRadius.circular(8),
          border: isSecondary ? Border.all(color: _borderColor) : null,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isSecondary ? _textPrimary : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: _primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _primary.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          color: _primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 500,
            pinned: true,
            backgroundColor: _cardColor,
            foregroundColor: _textPrimary,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: _cardColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(0, 1),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: Icon(Icons.arrow_back, color: _textPrimary),
                ),
              ),
            ),
            actions: [],
            automaticallyImplyLeading: false,
            primary: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  PageView.builder(
                    itemCount: widget.boardinghouse.images.length,
                    onPageChanged: (index) => setState(() => _currentImageIndex = index),
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            widget.boardinghouse.images[index],
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: _bgColor,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(_primary),
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: _bgColor,
                              child: Icon(Icons.home, size: 80, color: _textSecondary),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  // Interested Button
                  InterestedButton(
                    isInterested: _isInterested,
                    onPressed: _showInterestedDialog,
                  ),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        widget.boardinghouse.images.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentImageIndex == index 
                                ? _primary 
                                : Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.boardinghouse.title,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: _textPrimary,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: _primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                widget.boardinghouse.formattedPrice,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 18, color: _textSecondary),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                widget.boardinghouse.location,
                                style: TextStyle(fontSize: 15, color: _textSecondary),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (widget.boardinghouse.rating > 0) ...[
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: _cardColor,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(0, 1),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, size: 20, color: Colors.amber),
                            const SizedBox(width: 6),
                            Text(
                              '${widget.boardinghouse.formattedRating} (${widget.boardinghouse.reviewCount} reviews)',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Text(
                    'Room Type',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: _textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildCard(
                    child: Text(
                      widget.boardinghouse.roomType,
                      style: TextStyle(fontSize: 15, color: _textSecondary),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: _textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildCard(
                    child: Text(
                      widget.boardinghouse.description,
                      style: TextStyle(
                        fontSize: 15,
                        color: _textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Amenities',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: _textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.boardinghouse.amenities
                        .map((amenity) => _buildChip(amenity))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: _textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 450,
                    decoration: BoxDecoration(
                      color: _cardColor,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(0, 1),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        children: [
                          _isLoadingMapData
                              ? Container(
                                  color: _bgColor,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(color: _primary),
                                        const SizedBox(height: 12),
                                        Text(
                                          'Loading map...',
                                          style: TextStyle(fontSize: 14, color: _textSecondary),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : _mapDataError
                                  ? Container(
                                      color: _bgColor,
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.location_on, size: 48, color: _primary),
                                              const SizedBox(height: 12),
                                              Text(
                                                'Location: ${widget.boardinghouse.location}',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 14, color: _textPrimary),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                'Lat: ${widget.boardinghouse.latitude.toStringAsFixed(4)}, Long: ${widget.boardinghouse.longitude.toStringAsFixed(4)}',
                                                style: TextStyle(fontSize: 12, color: _textSecondary),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                'Map temporarily unavailable',
                                                style: TextStyle(fontSize: 12, color: _textSecondary),
                                              ),
                                              const SizedBox(height: 16),
                                              _buildButton(
                                                'Retry',
                                                () => _loadMapData(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : FlutterMap(
                                      options: MapOptions(
                                        initialCenter: _boardingHouseLocation ??
                                            LatLng(
                                              widget.boardinghouse.latitude,
                                              widget.boardinghouse.longitude,
                                            ),
                                        initialZoom: 15.0,
                                      ),
                                      children: [
                                        TileLayer(
                                          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                          subdomains: ['a', 'b', 'c'],
                                          userAgentPackageName: 'boardinghouse_finder.app',
                                        ),
                                        MarkerLayer(
                                          markers: [
                                            Marker(
                                              width: 45.0,
                                              height: 45.0,
                                              point: _boardingHouseLocation ??
                                                  LatLng(
                                                    widget.boardinghouse.latitude,
                                                    widget.boardinghouse.longitude,
                                                  ),
                                              child: Icon(
                                                Icons.location_on,
                                                color: _primary,
                                                size: 45.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Contact',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: _textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: GestureDetector(
                        onTap: _showContactOptions,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: _primary,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: _primary.withOpacity(0.3),
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'Contact Owner',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}