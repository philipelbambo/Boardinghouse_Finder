import '../models/boardinghouse.dart';

class DatabaseService {
  // Sample data for prototype
  static final List<Boardinghouse> _sampleBoardinghouses = [
    Boardinghouse(
      id: '1',
      title: 'Sunshine Boarding House',
      description: 'Comfortable and affordable boarding house near Tagoloan Central School. Perfect for students and working professionals.',
      price: 3500.0,
      location: 'Poblacion, Tagoloan',
      images: [
        'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
        'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800',
        'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=800',
      ],
      amenities: ['WiFi', 'Electricity', 'Water', 'Laundry Area'],
      latitude: 8.8333,
      longitude: 124.3833,
      roomType: 'Single Occupancy',
      contactNumber: '09123456789',
      rating: 4.5,
      reviewCount: 12,
    ),
    Boardinghouse(
      id: '2',
      title: 'Tagoloan Comfort Homes',
      description: 'Modern boarding house with air-conditioned rooms and 24/7 security. Located near public market.',
      price: 4200.0,
      location: 'San Roque, Tagoloan',
      images: [
        'https://images.unsplash.com/photo-1582268611958-ebfd161ef9cf?w=800',
        'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=800',
        'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
      ],
      amenities: ['WiFi', 'Aircon', 'Security', 'Parking', 'CCTV'],
      latitude: 8.8350,
      longitude: 124.3850,
      roomType: 'Double Occupancy',
      contactNumber: '09234567890',
      rating: 4.2,
      reviewCount: 8,
    ),
    Boardinghouse(
      id: '3',
      title: 'Mountain View Boarding',
      description: 'Peaceful boarding house with scenic mountain views. Quiet environment perfect for studying.',
      price: 2800.0,
      location: 'Cabangahan, Tagoloan',
      images: [
        'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800',
        'https://images.unsplash.com/photo-1582268611958-ebfd161ef9cf?w=800',
        'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=800',
      ],
      amenities: ['WiFi', 'Electricity', 'Water', 'Garden Area'],
      latitude: 8.8300,
      longitude: 124.3800,
      roomType: 'Single Occupancy',
      contactNumber: '09345678901',
      rating: 4.0,
      reviewCount: 15,
    ),
    Boardinghouse(
      id: '4',
      title: 'Downtown Residence',
      description: 'Conveniently located boarding house near commercial center. Easy access to transportation.',
      price: 3800.0,
      location: 'Poblacion, Tagoloan',
      images: [
        'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=800',
        'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
        'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800',
      ],
      amenities: ['WiFi', 'Electricity', 'Water', 'Laundry', 'Kitchen'],
      latitude: 8.8340,
      longitude: 124.3840,
      roomType: 'Single Occupancy',
      contactNumber: '09456789012',
      rating: 4.7,
      reviewCount: 20,
    ),
    Boardinghouse(
      id: '5',
      title: 'Seaside Boarding House',
      description: 'Boarding house with ocean view. Cool breeze and peaceful environment for relaxation.',
      price: 3200.0,
      location: 'Lawaan, Tagoloan',
      images: [
        'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800',
        'https://images.unsplash.com/photo-1582268611958-ebfd161ef9cf?w=800',
        'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=800',
      ],
      amenities: ['WiFi', 'Electricity', 'Water', 'Balcony'],
      latitude: 8.8360,
      longitude: 124.3860,
      roomType: 'Double Occupancy',
      contactNumber: '09567890123',
      rating: 4.3,
      reviewCount: 9,
    ),
  ];

  // Get all boardinghouses
  static Future<List<Boardinghouse>> getAllBoardinghouses() async {
    // Simulate network delay for prototype
    await Future.delayed(const Duration(milliseconds: 500));
    return _sampleBoardinghouses;
  }

  // Get boardinghouse by ID
  static Future<Boardinghouse?> getBoardinghouseById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _sampleBoardinghouses.firstWhere(
      (boardinghouse) => boardinghouse.id == id,
      orElse: () => throw Exception('Boardinghouse not found'),
    );
  }

  // Search boardinghouses by title or location
  static Future<List<Boardinghouse>> searchBoardinghouses(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (query.isEmpty) return _sampleBoardinghouses;
    
    return _sampleBoardinghouses.where((boardinghouse) {
      final lowerQuery = query.toLowerCase();
      return boardinghouse.title.toLowerCase().contains(lowerQuery) ||
             boardinghouse.location.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Filter boardinghouses by price range
  static List<Boardinghouse> filterByPriceRange(
    List<Boardinghouse> boardinghouses,
    double minPrice,
    double maxPrice,
  ) {
    return boardinghouses.where((bh) {
      return bh.price >= minPrice && bh.price <= maxPrice;
    }).toList();
  }

  // Filter boardinghouses by location
  static List<Boardinghouse> filterByLocation(
    List<Boardinghouse> boardinghouses,
    String location,
  ) {
    if (location.isEmpty) return boardinghouses;
    return boardinghouses.where((bh) {
      return bh.location.toLowerCase().contains(location.toLowerCase());
    }).toList();
  }

  // Filter boardinghouses by amenities
  static List<Boardinghouse> filterByAmenities(
    List<Boardinghouse> boardinghouses,
    List<String> amenities,
  ) {
    if (amenities.isEmpty) return boardinghouses;
    return boardinghouses.where((bh) {
      return amenities.every((amenity) => bh.amenities.contains(amenity));
    }).toList();
  }

  // Sort boardinghouses
  static List<Boardinghouse> sortBoardinghouses(
    List<Boardinghouse> boardinghouses,
    String sortBy,
  ) {
    final sortedList = List<Boardinghouse>.from(boardinghouses);
    
    switch (sortBy) {
      case 'price_low':
        sortedList.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        sortedList.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'rating':
        sortedList.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'distance':
        // For prototype, sort by ID (simulating proximity)
        sortedList.sort((a, b) => a.id.compareTo(b.id));
        break;
      default:
        // Default sort by rating
        sortedList.sort((a, b) => b.rating.compareTo(a.rating));
    }
    
    return sortedList;
  }
}