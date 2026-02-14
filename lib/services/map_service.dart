import 'dart:convert';
import 'package:http/http.dart' as http;

class MapService {
  // Base URL for your backend API
  static const String baseUrl = 'http://localhost:8000/api'; // Adjust this to your backend URL
  
  // Fetch map data for a specific boardinghouse
  static Future<Map<String, dynamic>?> getMapData(String boardinghouseId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/boardinghouse/$boardinghouseId/map-data'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('Map API Response Status: ${response.statusCode}');
      print('Map API Response Body: ${response.body}');
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to load map data: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching map data: $e');
      // Return fallback data if API fails
      return {
        'id': boardinghouseId,
        'title': 'Fallback Map Data',
        'location': 'Unknown Location',
        'latitude': 8.5367,
        'longitude': 124.7519,
        'staticMapUrl': null,
        'directions': {},
      };
    }
  }

  // Fetch nearby places for a specific boardinghouse
  static Future<List<dynamic>?> getNearbyPlaces(String boardinghouseId, {int radius = 1000}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/nearby-places/$boardinghouseId?radius=$radius'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to load nearby places: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching nearby places: $e');
      return null;
    }
  }

  // Geocode an address to get coordinates
  static Future<Map<String, dynamic>?> geocodeAddress(String address) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/geocode'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'address': address}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to geocode address: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error geocoding address: $e');
      return null;
    }
  }
}