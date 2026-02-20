import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIResponseService {
  // Load environment variables
  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
  }

  // Get AI response from backend API
  static Future<String> getAIResponse(String userMessage) async {
    try {
      // Use the same backend API that the main app uses
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/ai/chat'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'message': userMessage,
          'context': [] // For simplicity, no context in admin chat
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return data['response'];
        }
      }
      
      // Fallback to predefined responses if API call fails
      return _getMockResponse(userMessage);
    } catch (e) {
      // Fallback to predefined responses if API call fails
      return _getMockResponse(userMessage);
    }
  }

  // Helper method for mock responses
  static String _getMockResponse(String userMessage) {
    if (userMessage.toLowerCase().contains('hello') || 
        userMessage.toLowerCase().contains('hi')) {
      return "Hello there! How can I assist you with the boardinghouse management?";
    } else if (userMessage.toLowerCase().contains('property') ||
               userMessage.toLowerCase().contains('boardinghouse') ||
               userMessage.toLowerCase().contains('room') ||
               userMessage.toLowerCase().contains('apartment')) {
      return "I can help you manage properties. You can view, add, edit, or delete boardinghouse listings from the Properties section. You can also manage amenities, pricing, and availability.";
    } else if (userMessage.toLowerCase().contains('booking') ||
               userMessage.toLowerCase().contains('reservation') ||
               userMessage.toLowerCase().contains('schedule')) {
      return "For booking management, you can view all reservations, check availability, and manage customer bookings in the Bookings section. You can also send confirmations and handle cancellations.";
    } else if (userMessage.toLowerCase().contains('analytics') ||
               userMessage.toLowerCase().contains('report') ||
               userMessage.toLowerCase().contains('statistic')) {
      return "The Analytics section provides insights about occupancy rates, revenue, and booking trends for your boardinghouses. You can view daily, weekly, or monthly reports.";
    } else if (userMessage.toLowerCase().contains('payment') ||
               userMessage.toLowerCase().contains('money') ||
               userMessage.toLowerCase().contains('transaction')) {
      return "Payment management is handled in the Bookings section. You can view payment statuses, process refunds, and manage billing information for each reservation.";
    } else if (userMessage.toLowerCase().contains('customer') ||
               userMessage.toLowerCase().contains('tenant') ||
               userMessage.toLowerCase().contains('guest')) {
      return "Customer information is managed in the Bookings section. You can view tenant details, contact information, and rental history for each property.";
    } else if (userMessage.toLowerCase().contains('setting') ||
               userMessage.toLowerCase().contains('profile') ||
               userMessage.toLowerCase().contains('account')) {
      return "Account settings can be accessed through the profile menu in the top-right corner. From there, you can update your profile, change passwords, and manage preferences.";
    } else if (userMessage.toLowerCase().contains('help')) {
      return "I'm here to help! You can ask me about:\n• Property management\n• Booking management\n• Analytics and reports\n• Payment processing\n• Customer information\n• System navigation\n• Any other admin tasks";
    } else {
      // Default response
      return "Thank you for your message. As an AI assistant, I can help you with managing your boardinghouse operations. You can ask me about properties, bookings, analytics, payments, or general admin tasks. How else can I assist you?";
    }
  }

  // Alternative method that uses the admin-specific API key if needed
  static Future<String> getAdvancedAIResponse(String userMessage) async {
    try {
      // Get the admin-specific API key
      String? adminApiKey = dotenv.env['ADMIN_AI_API_KEY'];
      
      if (adminApiKey != null && adminApiKey.isNotEmpty) {
        // Use the admin API key with OpenAI-compatible endpoint
        final response = await http.post(
          Uri.parse('https://api.openai.com/v1/chat/completions'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $adminApiKey',
          },
          body: jsonEncode({
            'model': 'gpt-3.5-turbo',
            'messages': [
              {
                'role': 'system',
                'content': 'You are a helpful assistant for a boardinghouse management system. Respond to user queries about property management, bookings, analytics, and other admin tasks. Keep responses concise and professional.'
              },
              {
                'role': 'user',
                'content': userMessage
              }
            ],
          }),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          return data['choices'][0]['message']['content'];
        }
      }

      // Fallback to backend API if admin key is not available or fails
      return await getAIResponse(userMessage);
    } catch (e) {
      // Fallback to backend API if admin key fails
      return await getAIResponse(userMessage);
    }
  }
}