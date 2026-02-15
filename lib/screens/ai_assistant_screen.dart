import 'package:flutter/material.dart';
import '../services/ai_service.dart';

// Facebook-inspired color palette
class FBColors {
  static const Color background = Color(0xFFF0F2F5);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color primaryBlue = Color(0xFF1877F2);
  static const Color darkText = Color(0xFF1C1E21);
  static const Color secondaryText = Color(0xFF65676B);
  static const Color divider = Color(0xFFE4E6EB);
  static const Color hoverGray = Color(0xFFF2F3F5);
}

class AiAssistantOverlay extends StatefulWidget {
  const AiAssistantOverlay({Key? key}) : super(key: key);

  @override
  State<AiAssistantOverlay> createState() => _AiAssistantOverlayState();
}

class _AiAssistantOverlayState extends State<AiAssistantOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    // Test connection on startup
    _testConnection();
  }

  void _testConnection() async {
    try {
      print('Testing AI service connection...');
      final result = await AIService.testConnection();
      print('Connection test result: ${result['message']}');
      if (!result['success']) {
        print('Connection failed: ${result['message']}');
      }
    } catch (e) {
      print('Connection test error: $e');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleAssistant() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24,
      right: 24,
      child: AnimatedScale(
        scale: _isExpanded ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: FBColors.primaryBlue.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: _toggleAssistant,
            backgroundColor: FBColors.primaryBlue,
            foregroundColor: Colors.white,
            elevation: 0,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _isExpanded
                  ? const Icon(Icons.close, key: ValueKey('close'), size: 24)
                  : const Icon(Icons.chat_bubble, key: ValueKey('chat'), size: 24),
            ),
          ),
        ),
      ),
    );
  }
}

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({Key? key}) : super(key: key);

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "Hello! I'm your Boardinghouse Finder AI Assistant. How can I help you today?",
      isUser: false,
      timestamp: DateTime.now(),
    ),
  ];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_textController.text.trim().isEmpty) return;

    final message = _textController.text.trim();
    setState(() {
      _messages.add(ChatMessage(
        text: message,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isTyping = true;
    });

    _textController.clear();
    _scrollToBottom();

    // Generate AI response immediately (no artificial delay)
    _generateAiResponse(message);
  }

  void _generateAiResponse(String userMessage) async {
    // Extract conversation history (excluding the latest user message)
    List<ChatMessage> conversationHistory = [];
    for (int i = 0; i < _messages.length - 1; i++) {
      conversationHistory.add(_messages[i]);
    }
    
    try {
      String response = await _getAiResponseFromBackend(userMessage, conversationHistory);
      
      setState(() {
        _messages.add(ChatMessage(
          text: response,
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isTyping = false;
      });
      
      _scrollToBottom();
    } catch (e) {
      // Show error message when AI service is unavailable
      String errorMessage = _getFriendlyErrorMessage(e);
      
      setState(() {
        _messages.add(ChatMessage(
          text: errorMessage,
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isTyping = false;
      });
      
      _scrollToBottom();
    }
  }

  Future<String> _getAiResponseFromBackend(String message, List<ChatMessage> context) async {
    try {
      // Convert context to the format expected by the backend service
      List<Map<String, dynamic>> contextList = [];
      for (var msg in context) {
        contextList.add({
          'text': msg.text,
          'isUser': msg.isUser,
        });
      }

      final result = await AIService.sendMessage(message, contextList);
      
      if (result['success']) {
        return result['response'];
      } else {
        throw Exception(result['error'] ?? 'Unknown error');
      }
    } catch (e) {
      print('Error calling AI backend: $e');
      throw e; // Re-throw to be handled by the calling function
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Returns user-friendly error messages based on exception type
  String _getFriendlyErrorMessage(dynamic error) {
    String errorString = error.toString().toLowerCase();
    
    if (errorString.contains('timeout') || errorString.contains('time out')) {
      return "The request took too long. Please check your internet connection and try again.";
    } else if (errorString.contains('unauthorized') || errorString.contains('401')) {
      return "I'm having trouble connecting to the service. Please try again later.";
    } else if (errorString.contains('rate limit') || errorString.contains('429')) {
      return "I'm a bit busy right now. Please wait a moment and try again.";
    } else if (errorString.contains('network') || errorString.contains('connection')) {
      return "I'm having trouble connecting to the internet. Please check your connection and try again.";
    } else if (errorString.contains('socket')) {
      return "Unable to connect to the server. Please make sure the backend service is running.";
    } else {
      return "I'm sorry, I'm currently unable to assist you. Please try again later.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FBColors.background,
      appBar: AppBar(
        title: const Text(
          'AI Assistant',
          style: TextStyle(
            color: FBColors.darkText,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: FBColors.cardWhite,
        foregroundColor: FBColors.darkText,
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: FBColors.darkText),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Chat header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: FBColors.cardWhite,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: const Text(
              'How can I help you find the perfect boardinghouse?',
              style: TextStyle(
                color: FBColors.secondaryText,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Chat messages
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: FBColors.cardWhite,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(20),
                      itemCount: _messages.length + (_isTyping ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _messages.length && _isTyping) {
                          return const _TypingIndicator();
                        }
                        return _ChatMessageWidget(message: _messages[index]);
                      },
                    ),
                  ),
                  
                  // Input area
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: FBColors.cardWhite,
                      border: Border(
                        top: BorderSide(
                          color: FBColors.divider,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: FBColors.background,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: TextField(
                              controller: _textController,
                              style: const TextStyle(
                                color: FBColors.darkText,
                                fontSize: 15,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Ask about boardinghouses...',
                                hintStyle: TextStyle(
                                  color: FBColors.secondaryText,
                                  fontSize: 15,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                              ),
                              onSubmitted: (_) => _sendMessage(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: FBColors.primaryBlue,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: FBColors.primaryBlue.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.send_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: _sendMessage,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

// Standalone chat box widget that can be embedded anywhere
class AiAssistantChatBox extends StatefulWidget {
  const AiAssistantChatBox({Key? key}) : super(key: key);

  @override
  State<AiAssistantChatBox> createState() => _AiAssistantChatBoxState();
}

class _AiAssistantChatBoxState extends State<AiAssistantChatBox> {
  final List<ChatMessage> _messages = [];
  final List<List<ChatMessage>> _chatHistory = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_textController.text.trim().isEmpty) return;

    final message = _textController.text.trim();
    setState(() {
      _messages.add(ChatMessage(
        text: message,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isTyping = true;
    });

    _textController.clear();
    _scrollToBottom();

    // Generate AI response immediately (no artificial delay)
    _generateAiResponse(message);
  }

  void _generateAiResponse(String userMessage) async {
    // Extract conversation history (excluding the latest user message)
    List<ChatMessage> conversationHistory = [];
    for (int i = 0; i < _messages.length - 1; i++) {
      conversationHistory.add(_messages[i]);
    }
    
    try {
      String response = await _getAiResponseFromBackend(userMessage, conversationHistory);
      
      setState(() {
        _messages.add(ChatMessage(
          text: response,
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isTyping = false;
      });
      
      _scrollToBottom();
    } catch (e) {
      // Show error message when AI service is unavailable
      String errorMessage = _getFriendlyErrorMessage(e);
      
      setState(() {
        _messages.add(ChatMessage(
          text: errorMessage,
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isTyping = false;
      });
      
      _scrollToBottom();
    }
  }

  Future<String> _getAiResponseFromBackend(String message, List<ChatMessage> context) async {
    try {
      // Convert context to the format expected by the backend service
      List<Map<String, dynamic>> contextList = [];
      for (var msg in context) {
        contextList.add({
          'text': msg.text,
          'isUser': msg.isUser,
        });
      }

      final result = await AIService.sendMessage(message, contextList);
      
      if (result['success']) {
        return result['response'];
      } else {
        throw Exception(result['error'] ?? 'Unknown error');
      }
    } catch (e) {
      print('Error calling AI backend: $e');
      throw e; // Re-throw to be handled by the calling function
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _startNewChat() {
    // Save current conversation to history (if it has user messages)
    if (_messages.any((message) => message.isUser)) {
      _chatHistory.add(List.from(_messages));
    }
    
    setState(() {
      _messages.clear();
      _textController.clear();
      _isTyping = false;
    });
  }

  /// Returns user-friendly error messages based on exception type
  String _getFriendlyErrorMessage(dynamic error) {
    String errorString = error.toString().toLowerCase();
    
    if (errorString.contains('timeout') || errorString.contains('time out')) {
      return "The request took too long. Please check your internet connection and try again.";
    } else if (errorString.contains('unauthorized') || errorString.contains('401')) {
      return "I'm having trouble connecting to the service. Please try again later.";
    } else if (errorString.contains('rate limit') || errorString.contains('429')) {
      return "I'm a bit busy right now. Please wait a moment and try again.";
    } else if (errorString.contains('network') || errorString.contains('connection')) {
      return "I'm having trouble connecting to the internet. Please check your connection and try again.";
    } else if (errorString.contains('socket')) {
      return "Unable to connect to the server. Please make sure the backend service is running.";
    } else {
      return "I'm sorry, I'm currently unable to assist you. Please try again later.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700,
      decoration: BoxDecoration(
        color: FBColors.cardWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with Recent Chats dropdown and New Chat icon
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: FBColors.cardWhite,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              border: Border(
                bottom: BorderSide(
                  color: FBColors.divider,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Recent Chats dropdown
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: Row(
                        children: [
                          const Icon(
                            Icons.history_rounded,
                            color: FBColors.secondaryText,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Recent Chats ${_chatHistory.isEmpty ? '' : '(${_chatHistory.length})'}',
                              style: const TextStyle(
                                color: FBColors.darkText,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    items: [
                      if (_chatHistory.isNotEmpty)
                        DropdownMenuItem<String>(
                          value: 'clear_all',
                          child: SizedBox(
                            width: 220,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.delete_sweep_rounded,
                                    size: 18,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Clear All Chats',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ..._chatHistory.asMap().entries.map((entry) {
                        final int index = entry.key;
                        final List<ChatMessage> chat = entry.value;
                        String firstUserMessage = 'Chat #${index + 1}';
                        final userMessages = chat.where((msg) => msg.isUser).toList();
                        if (userMessages.isNotEmpty) {
                          firstUserMessage = userMessages.first.text;
                        }
                        
                        if (firstUserMessage.length > 28) {
                          firstUserMessage = '${firstUserMessage.substring(0, 28)}...';
                        }
                        
                        final int deleteIndex = index;
                        
                        return DropdownMenuItem<String>(
                          value: index.toString(),
                          child: SizedBox(
                            width: 220,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      firstUserMessage,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: FBColors.darkText,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Future.microtask(() {
                                        if (mounted) {
                                          setState(() {
                                            _chatHistory.removeAt(deleteIndex);
                                          });
                                        }
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: FBColors.hoverGray,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 16,
                                        color: FBColors.secondaryText,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                    onChanged: (String? value) {
                      if (value != null) {
                        if (value == 'clear_all') {
                          Navigator.of(context).pop();
                          Future.microtask(() {
                            if (mounted) {
                              setState(() {
                                _chatHistory.clear();
                              });
                            }
                          });
                        } else {
                          int index = int.parse(value);
                          setState(() {
                            _messages.clear();
                            _messages.addAll(_chatHistory[index]);
                            _textController.clear();
                            _isTyping = false;
                          });
                        }
                      }
                    },
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: FBColors.secondaryText,
                    ),
                  ),
                ),
                ),
                // New Chat icon
                Container(
                  decoration: BoxDecoration(
                    color: FBColors.hoverGray,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: _startNewChat,
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: FBColors.primaryBlue,
                      size: 22,
                    ),
                    tooltip: 'New Chat',
                  ),
                ),
              ],
            ),
          ),
          
          // Chat messages
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.zero,
                      itemCount: _messages.length + (_isTyping ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _messages.length && _isTyping) {
                          return const _TypingIndicator();
                        }
                        return _ChatMessageWidget(message: _messages[index]);
                      },
                    ),
                  ),
                  
                  // Input area
                  Container(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: FBColors.background,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: TextField(
                              controller: _textController,
                              style: const TextStyle(
                                color: FBColors.darkText,
                                fontSize: 15,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Ask about boardinghouses...',
                                hintStyle: TextStyle(
                                  color: FBColors.secondaryText,
                                  fontSize: 15,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                              ),
                              onSubmitted: (_) => _sendMessage(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: FBColors.primaryBlue,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: FBColors.primaryBlue.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.send_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            onPressed: _sendMessage,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class _ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;

  const _ChatMessageWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) const _AiAvatar(),
          if (!message.isUser) const SizedBox(width: 12),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser
                    ? FBColors.primaryBlue
                    : FBColors.background,
                borderRadius: BorderRadius.circular(18),
                boxShadow: message.isUser
                    ? [
                        BoxShadow(
                          color: FBColors.primaryBlue.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : FBColors.darkText,
                  fontSize: 15,
                  height: 1.4,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          if (message.isUser) const SizedBox(width: 12),
          if (message.isUser) const _UserAvatar(),
        ],
      ),
    );
  }
}

class _AiAvatar extends StatelessWidget {
  const _AiAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            FBColors.primaryBlue,
            FBColors.primaryBlue.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: FBColors.primaryBlue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.smart_toy_rounded,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: FBColors.background,
        shape: BoxShape.circle,
        border: Border.all(color: FBColors.divider, width: 1.5),
      ),
      child: const Center(
        child: Icon(
          Icons.person,
          color: FBColors.secondaryText,
          size: 20,
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _AiAvatar(),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: FBColors.background,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _TypingBubble(delay: 0),
                SizedBox(width: 5),
                _TypingBubble(delay: 150),
                SizedBox(width: 5),
                _TypingBubble(delay: 300),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingBubble extends StatefulWidget {
  final int delay;
  
  const _TypingBubble({this.delay = 0});

  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: FBColors.secondaryText,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}