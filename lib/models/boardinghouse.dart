class Boardinghouse {
  final String id;
  final String title;
  final String description;
  final double price;
  final String location;
  final List<String> images;
  final List<String> amenities;
  final double latitude;
  final double longitude;
  final String roomType;
  final String contactNumber;
  final double rating;
  final int reviewCount;

  Boardinghouse({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.location,
    required this.images,
    required this.amenities,
    required this.latitude,
    required this.longitude,
    required this.roomType,
    required this.contactNumber,
    this.rating = 0.0,
    this.reviewCount = 0,
  });

  factory Boardinghouse.fromJson(Map<String, dynamic> json) {
    return Boardinghouse(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      location: json['location'] as String,
      images: List<String>.from(json['images'] as List),
      amenities: List<String>.from(json['amenities'] as List),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      roomType: json['roomType'] as String,
      contactNumber: json['contactNumber'] as String,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'location': location,
      'images': images,
      'amenities': amenities,
      'latitude': latitude,
      'longitude': longitude,
      'roomType': roomType,
      'contactNumber': contactNumber,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }

  String get formattedPrice => '₱${price.toStringAsFixed(0)}/month';
  
  String get formattedRating => rating > 0 ? rating.toStringAsFixed(1) : 'No ratings';
}