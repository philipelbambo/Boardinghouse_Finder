import 'dart:convert';
import 'dart:async'; // For TimeoutException
import 'package:http/http.dart' as http;

class AIService {
  // Base URL for the backend API - adjust this based on your environment
  static const String baseUrl = 'http://127.0.0.1:8000/api'; // For Local Development on Windows
  // static const String baseUrl = 'http://10.0.2.2:8000/api'; // For Android Emulator
  // static const String baseUrl = 'http://your_backend_ip:8000/api'; // For Physical Device

  /// Send a message to the AI assistant and get a response
  static Future<Map<String, dynamic>> sendMessage(String message, List<Map<String, dynamic>>? context) async {
    try {
      print('AI Service: Starting request...'); // Debug log
      
      // Limit context to last 5 messages to reduce payload size
      List<Map<String, dynamic>>? limitedContext = context;
      if (context != null && context.length > 10) {
        limitedContext = context.sublist(context.length - 10);
      }

      final startTime = DateTime.now();
      print('AI Service: Sending request to $baseUrl/ai/chat'); // Debug log
      
      final response = await http.post(
        Uri.parse('$baseUrl/ai/chat'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'message': message,
          'context': limitedContext ?? [],
        }),
      ).timeout(Duration(seconds: 60)); // Increased to 60 seconds

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime).inMilliseconds;
      print('AI Service: Response received in ${duration}ms'); // Debug log

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'response': data['response'],
          'timestamp': data['timestamp'],
        };
      } else {
        final data = jsonDecode(response.body);
        String errorMessage = 'Service error';
        
        // Provide more specific error messages
        if (response.statusCode == 400) {
          errorMessage = data['error'] ?? 'Invalid request';
        } else if (response.statusCode == 401) {
          errorMessage = 'Authentication failed';
        } else if (response.statusCode == 429) {
          errorMessage = 'Too many requests. Please wait a moment.';
        } else if (response.statusCode == 503) {
          errorMessage = 'AI service is temporarily unavailable';
        } else if (response.statusCode >= 500) {
          errorMessage = 'Server error. Please try again later.';
        }
        
        return {
          'success': false,
          'error': errorMessage,
          'statusCode': response.statusCode,
        };
      }
    } on TimeoutException {
      return {
        'success': false,
        'error': 'Request timed out. Please check your connection and try again.',
      };
    } catch (e) {
      String errorMessage = 'Network error';
      
      if (e.toString().contains('SocketException')) {
        errorMessage = 'Unable to connect to server. Please check if the backend is running.';
      } else if (e.toString().contains('HandshakeException')) {
        errorMessage = 'SSL connection error. Please check your network settings.';
      }
      
      return {
        'success': false,
        'error': errorMessage,
      };
    }
  }

  /// Check if the AI service is available
  static Future<bool> isServiceAvailable() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/ai/health'),
        headers: {'Content-Type': 'application/json'}
      ).timeout(Duration(seconds: 10));
      return response.statusCode == 200;
    } on TimeoutException {
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Test connection to the backend
  static Future<Map<String, dynamic>> testConnection() async {
    try {
      final startTime = DateTime.now();
      final response = await http.get(
        Uri.parse('$baseUrl/ai/health'),
        headers: {'Content-Type': 'application/json'}
      ).timeout(Duration(seconds: 15));
      
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime).inMilliseconds;
      
      return {
        'success': response.statusCode == 200,
        'statusCode': response.statusCode,
        'responseTime': duration,
        'message': response.statusCode == 200 
          ? 'Connection successful' 
          : 'Connection failed with status ${response.statusCode}'
      };
    } on TimeoutException {
      return {
        'success': false,
        'statusCode': null,
        'responseTime': null,
        'message': 'Connection timed out'
      };
    } catch (e) {
      return {
        'success': false,
        'statusCode': null,
        'responseTime': null,
        'message': 'Connection error: ${e.toString()}'
      };
    }
  }
}