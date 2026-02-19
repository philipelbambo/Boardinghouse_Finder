import 'package:flutter/material.dart';
import 'dart:async';
import '../utils/admin_constants.dart';
import 'admin_constants.dart' as ai_constants;
import 'services/ai_response_service.dart';

class AdminAIChatbot extends StatefulWidget {
  const AdminAIChatbot({Key? key}) : super(key: key);

  @override
  _AdminAIChatbotState createState() => _AdminAIChatbotState();
}

class _AdminAIChatbotState extends State<AdminAIChatbot> 
    with TickerProviderStateMixin {
  bool _isChatOpen = false;
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animations
    _animationController = AnimationController(
      duration: ai_constants.AIChatbotConstants.chatOpenDuration,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: ai_constants.AIChatbotConstants.chatOpenCurve),
    );

    _positionAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: ai_constants.AIChatbotConstants.chatOpenCurve),
    );

    // Add welcome message
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String welcomeMessage = await AIResponseService.getAIResponse("Hello");
      _addBotMessage(welcomeMessage);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleChat() {
    setState(() {
      _isChatOpen = !_isChatOpen;
    });

    if (_isChatOpen) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _addMessage(String text, bool isUser) {
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: isUser));
    });
    
    // Scroll to bottom after a brief delay to ensure the widget is built
    Timer(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _addBotMessage(String text) {
    _addMessage(text, false);
  }

  void _handleSendMessage() {
    if (_textController.text.trim().isEmpty) return;

    String message = _textController.text.trim();
    _addMessage(message, true);
    _textController.clear();

    // Simulate AI response after a delay
    Timer(ai_constants.AIChatbotConstants.messageSendDelay, () {
      _simulateAIResponse(message);
    });
  }

  void _simulateAIResponse(String userMessage) async {
    // Get AI response using the service
    String response = await AIResponseService.getAIResponse(userMessage);
    
    _addBotMessage(response);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Floating chat button
        Positioned(
          bottom: 20,
          right: 20,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: FloatingActionButton(
              onPressed: _toggleChat,
              backgroundColor: AdminConstants.primaryColor,
              foregroundColor: Colors.white,
              elevation: ai_constants.AIChatbotConstants.floatingButtonElevation,
              shape: const CircleBorder(),
              child: Icon(_isChatOpen ? Icons.close : Icons.chat_bubble_rounded),
            ),
          ),
        ),

        // Chat panel
        if (_isChatOpen)
          Positioned.fill(
            child: Container(
              color: Colors.transparent,
              child: Center(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SlideTransition(
                      position: _positionAnimation,
                      child: Container(
                        width: ai_constants.AIChatbotConstants.chatPanelWidth,
                        height: ai_constants.AIChatbotConstants.chatPanelHeight,
                        decoration: BoxDecoration(
                          color: AdminConstants.cardColor,
                          borderRadius: BorderRadius.circular(ai_constants.AIChatbotConstants.chatHeaderBorderRadius),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Header
                            Container(
                              height: ai_constants.AIChatbotConstants.chatHeaderHeight,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: ai_constants.AIChatbotConstants.chatHeaderColor,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(ai_constants.AIChatbotConstants.chatHeaderBorderRadius),
                                  topRight: Radius.circular(ai_constants.AIChatbotConstants.chatHeaderBorderRadius),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Icon(
                                          Icons.smart_toy,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'AI Assistant',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: _toggleChat,
                                    icon: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Messages area
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                child: ListView.builder(
                                  controller: _scrollController,
                                  itemCount: _messages.length,
                                  itemBuilder: (context, index) {
                                    return _buildMessageBubble(_messages[index]);
                                  },
                                ),
                              ),
                            ),
                            
                            // Input area
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AdminConstants.backgroundColor,
                                border: Border(
                                  top: BorderSide(
                                    color: AdminConstants.borderColor,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _textController,
                                      onSubmitted: (value) => _handleSendMessage(),
                                      decoration: InputDecoration(
                                        hintText: 'Type a message...',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(ai_constants.AIChatbotConstants.inputFieldBorderRadius),
                                          borderSide: BorderSide.none,
                                        ),
                                        filled: true,
                                        fillColor: AdminConstants.cardColor,
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        isDense: true,
                                      ),
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  FloatingActionButton(
                                    onPressed: _handleSendMessage,
                                    backgroundColor: AdminConstants.primaryColor,
                                    foregroundColor: Colors.white,
                                    mini: true,
                                    child: const Icon(
                                      Icons.send,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Container(
      margin: EdgeInsets.only(bottom: ai_constants.AIChatbotConstants.messageMargin),
      child: Align(
        alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: ai_constants.AIChatbotConstants.messagePadding),
          decoration: BoxDecoration(
            color: message.isUser
                ? ai_constants.AIChatbotConstants.userMessageColor
                : ai_constants.AIChatbotConstants.botMessageColor,
            borderRadius: BorderRadius.circular(ai_constants.AIChatbotConstants.messageBorderRadius),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * ai_constants.AIChatbotConstants.maxMessageWidthRatio,
            ),
            child: Text(
              message.text,
              style: TextStyle(
                color: message.isUser ? Colors.white : AdminConstants.textColor,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({
    required this.text,
    required this.isUser,
  });
}