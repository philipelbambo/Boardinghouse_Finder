// Chat message models for the Admin AI Chatbot

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final MessageStatus status;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.status = MessageStatus.sent,
  });
}

enum MessageStatus { 
  sending, 
  sent, 
  failed 
}