import 'dart:convert';
import 'package:http/http.dart' as http;

class AIResponseService {
  // Mock AI response service - in a real implementation, this would connect to an AI API
  static Future<String> getAIResponse(String userMessage) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Predefined responses based on keywords
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

  // In a real implementation, this would connect to an actual AI API
  static Future<String> getAdvancedAIResponse(String userMessage, String apiKey) async {
    try {
      // This is a placeholder for actual API integration
      // Replace with your preferred AI service (OpenAI, Google, etc.)
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
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
      } else {
        // Fallback to mock response if API fails
        return await getAIResponse(userMessage);
      }
    } catch (e) {
      // Fallback to mock response if API fails
      return await getAIResponse(userMessage);
    }
  }
}