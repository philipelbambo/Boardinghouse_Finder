import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/scheduler.dart';
import '../utils/admin_constants.dart';
import '../admin_AI_Chatbot/services/ai_response_service.dart';
import '../../../screens/ai_assistant_screen.dart' show FBColors;

// Initialize the AI service to load environment variables
void initializeAIService() {
  AIResponseService.initialize();
}

// Fake TickerProvider for default controller
class _FakeTickerProvider implements TickerProvider {
  const _FakeTickerProvider();
  
  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick, debugLabel: 'FakeTicker');
  }
}

// ─────────────────────────────────────────────────────────────
// Data Models
// ─────────────────────────────────────────────────────────────
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class ChatSession {
  final String id;
  final String title;
  final DateTime lastUpdated;
  final List<ChatMessage> messages;

  ChatSession({
    required this.id,
    required this.title,
    required this.lastUpdated,
    required this.messages,
  });
}

// ─────────────────────────────────────────────────────────────
// Widget
// ─────────────────────────────────────────────────────────────
class AIChatbotWidget extends StatefulWidget {
  const AIChatbotWidget({Key? key}) : super(key: key);

  @override
  State<AIChatbotWidget> createState() => _AIChatbotWidgetState();
}

class _AIChatbotWidgetState extends State<AIChatbotWidget>
    with TickerProviderStateMixin {
  // ── State ──────────────────────────────────────────────────
  bool _isChatOpen          = false;
  bool _isTyping            = false;
  bool _showRecentChats     = false;   // toggle for recent chats panel
  int  _sessionCounter      = 1;

  final List<ChatMessage>  _messages        = [];
  final List<ChatSession>  _recentSessions  = [];
  final TextEditingController _textController  = TextEditingController();
  final ScrollController      _scrollController = ScrollController();
  final FocusNode             _inputFocus       = FocusNode();

  // ── Animations ─────────────────────────────────────────────
  late AnimationController _panelController;
  late AnimationController _typingController;
  late AnimationController _blurController;
  late AnimationController _recentController;

  late Animation<double> _panelSlide;
  late Animation<double> _panelFade;
  late Animation<double> _typingDot;
  late Animation<double> _blurOpacity;
  late Animation<double> _blurIntensity;
  late Animation<double> _recentHeight;

  // Default animation for safe initialization
  static const _defaultAnimation = AlwaysStoppedAnimation<double>(0.0);
  
  // Default controller for safe initialization
  static final _defaultController = AnimationController(
    vsync: const _FakeTickerProvider(),
    duration: const Duration(milliseconds: 1),
  );

  // ── Lifecycle ──────────────────────────────────────────────
  @override
  void initState() {
    super.initState();

    // Panel open/close
    _panelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _panelSlide = CurvedAnimation(
      parent: _panelController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    _panelFade = CurvedAnimation(
      parent: _panelController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    // Typing indicator dots
    _typingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
    _typingDot = CurvedAnimation(parent: _typingController, curve: Curves.easeInOut);

    // Blur effect animations
    _blurController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _blurOpacity = CurvedAnimation(
      parent: _blurController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    _blurIntensity = CurvedAnimation(
      parent: _blurController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      reverseCurve: const Interval(0.2, 1.0, curve: Curves.easeIn),
    );

    // Recent chats collapse/expand
    _recentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _recentHeight = CurvedAnimation(
      parent: _recentController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    // Welcome message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 600), () {
        _addBotMessage("Hi! 👋 I'm your AI assistant. How can I help you today?");
      });
    });
  }

  @override
  void dispose() {
    _safePanelController.dispose();
    _safeBlurController.dispose();
    _safeRecentController.dispose();
    _safeTypingController.dispose();
    _textController.dispose();
    _scrollController.dispose();
    _inputFocus.dispose();
    super.dispose();
  }

  // ── Helpers ────────────────────────────────────────────────
  Animation<double> get _safeRecentHeight {
    try {
      return _recentHeight;
    } catch (e) {
      return _defaultAnimation;
    }
  }

  Animation<double> get _safePanelSlide {
    try {
      return _panelSlide;
    } catch (e) {
      return _defaultAnimation;
    }
  }

  Animation<double> get _safePanelFade {
    try {
      return _panelFade;
    } catch (e) {
      return _defaultAnimation;
    }
  }

  Animation<double> get _safeBlurOpacity {
    try {
      return _blurOpacity;
    } catch (e) {
      return _defaultAnimation;
    }
  }

  Animation<double> get _safeBlurIntensity {
    try {
      return _blurIntensity;
    } catch (e) {
      return _defaultAnimation;
    }
  }

  Animation<double> get _safeTypingDot {
    try {
      return _typingDot;
    } catch (e) {
      return _defaultAnimation;
    }
  }

  AnimationController get _safeRecentController {
    try {
      return _recentController;
    } catch (e) {
      return _defaultController;
    }
  }

  AnimationController get _safePanelController {
    try {
      return _panelController;
    } catch (e) {
      return _defaultController;
    }
  }

  AnimationController get _safeBlurController {
    try {
      return _blurController;
    } catch (e) {
      return _defaultController;
    }
  }

  AnimationController get _safeTypingController {
    try {
      return _typingController;
    } catch (e) {
      return _defaultController;
    }
  }

  void _toggleChat() {
    setState(() => _isChatOpen = !_isChatOpen);
    if (_isChatOpen) {
      _safePanelController.forward();
      _safeBlurController.forward();
      Future.delayed(const Duration(milliseconds: 200), () {
        _inputFocus.requestFocus();
      });
    } else {
      _safePanelController.reverse();
      _safeBlurController.reverse();
      _inputFocus.unfocus();
    }
  }

  void _toggleRecentChats() {
    setState(() => _showRecentChats = !_showRecentChats);
    if (_showRecentChats) {
      _safeRecentController.forward();
    } else {
      _safeRecentController.reverse();
    }
  }

  /// Save the current session then start a fresh one.
  void _startNewChat() {
    // Always save current session (even if empty)
    // Build a title - either from first message or default
    String title;
    if (_messages.isNotEmpty) {
      final firstUser = _messages.firstWhere(
        (m) => m.isUser,
        orElse: () => _messages.first,
      );
      title = firstUser.text.length > 40
          ? '${firstUser.text.substring(0, 40)}…'
          : firstUser.text;
    } else {
      title = 'New Conversation $_sessionCounter';
    }

    setState(() {
      _recentSessions.insert(
        0,
        ChatSession(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          lastUpdated: DateTime.now(),
          messages: List.unmodifiable(_messages),
        ),
      );
      _messages.clear();
      _sessionCounter++;
      _isTyping = false;
    });

    Future.delayed(const Duration(milliseconds: 120), () {
      _addBotMessage("Hi! 👋 Starting a new conversation. How can I help you?");
    });
  }

  /// Restore a past session for viewing.
  void _restoreSession(ChatSession session) {
    // Save current session if it has content
    if (_messages.isNotEmpty) {
      final firstUser = _messages.firstWhere(
        (m) => m.isUser,
        orElse: () => _messages.first,
      );
      final title = firstUser.text.length > 40
          ? '${firstUser.text.substring(0, 40)}…'
          : firstUser.text;

      _recentSessions.removeWhere((s) => s.id == session.id);
      _recentSessions.insert(
        0,
        ChatSession(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          lastUpdated: DateTime.now(),
          messages: List.unmodifiable(_messages),
        ),
      );
    }

    setState(() {
      _messages
        ..clear()
        ..addAll(session.messages);
      _showRecentChats = false;
    });
    _safeRecentController.reverse();
    _scrollToBottom();
  }

  /// Delete a recent session from history
  void _deleteRecentSession(ChatSession session) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Conversation'),
          content: Text('Are you sure you want to delete "${session.title}"? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _recentSessions.removeWhere((s) => s.id == session.id);
                });
                
                // Show confirmation snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Conversation deleted'),
                    duration: const Duration(seconds: 2),
                    backgroundColor: Colors.red.withOpacity(0.8),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _addMessage(String text, {required bool isUser}) {
    if (!mounted) return;
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: isUser,
        timestamp: DateTime.now(),
      ));
    });
    _scrollToBottom();
  }

  void _addBotMessage(String text) => _addMessage(text, isUser: false);

  void _scrollToBottom() {
    Timer(const Duration(milliseconds: 80), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 340),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  void _handleSendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _addMessage(text, isUser: true);
    _textController.clear();
    _inputFocus.requestFocus();

    setState(() => _isTyping = true);
    _scrollToBottom();

    Timer(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() => _isTyping = false);
      _simulateAIResponse(text);
    });
  }

  void _simulateAIResponse(String userMessage) async {
    try {
      final response = await AIResponseService.getAdvancedAIResponse(userMessage);
      if (mounted) _addBotMessage(response);
    } catch (e) {
      if (mounted) {
        _addBotMessage(
            "Thanks for your message! I'm here to help with any questions you have.");
      }
    }
  }

  String _formatTime(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  String _formatDate(DateTime t) {
    final now = DateTime.now();
    final diff = now.difference(t);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${t.day}/${t.month}/${t.year}';
  }

  double _panelWidth(BuildContext ctx) {
    final w = MediaQuery.of(ctx).size.width;
    if (w > 1200) return 400;
    if (w > 768) return 360;
    return w * 0.92;
  }

  // ── Build ──────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── Backdrop Blur Overlay ──────────────────────────────
        if (_isChatOpen)
          AnimatedBuilder(
            animation: _blurController,
            builder: (context, child) {
              return Positioned.fill(
                child: Opacity(
                  opacity: _safeBlurOpacity.value * 0.7,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 8.0 * _safeBlurIntensity.value,
                      sigmaY: 8.0 * _safeBlurIntensity.value,
                    ),
                    child: Container(
                      color: Colors.black.withOpacity(0.3 * _safeBlurOpacity.value),
                    ),
                  ),
                ),
              );
            },
          ),

        // ── Chat Panel ─────────────────────────────────────────
        AnimatedBuilder(
          animation: _panelController,
          builder: (context, child) {
            return Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              child: Transform.translate(
                offset: Offset(
                  _panelWidth(context) * (1 - _safePanelSlide.value),
                  0,
                ),
                child: Opacity(
                  opacity: _safePanelFade.value,
                  child: child,
                ),
              ),
            );
          },
          child: _buildChatPanel(),
        ),

        // ── Floating Chat Icon ─────────────────────────────────
        if (!_isChatOpen)
          Positioned(
            bottom: 28,
            right: 28,
            child: GestureDetector(
              onTap: _toggleChat,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AdminConstants.primaryColor,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AdminConstants.primaryColor.withOpacity(0.35),
                      blurRadius: 20,
                      spreadRadius: 0,
                      offset: const Offset(0, 6),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 8,
                      spreadRadius: 0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.chat_bubble_rounded,
                    color: Colors.white, size: 22),
              ),
            ),
          ),
      ],
    );
  }

  // ── Chat Panel ────────────────────────────────────────────
  Widget _buildChatPanel() {
    return Material(
      elevation: 0,
      child: Container(
        width: _panelWidth(context),
        decoration: BoxDecoration(
          color: AdminConstants.cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.16),
              blurRadius: 32,
              offset: const Offset(-6, 0),
            ),
          ],
          border: Border(
            left: BorderSide(color: AdminConstants.borderColor, width: 1),
          ),
        ),
        child: Column(
          children: [
            _buildHeader(),
            _buildOnlineBadge(),
            // ── Recent Chats (collapsible) ──────────────────
            _buildRecentChatsPanel(),
            Expanded(child: _buildMessagesArea()),
            if (_isTyping) _buildTypingIndicator(),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AdminConstants.primaryColor,
        boxShadow: [
          BoxShadow(
            color: AdminConstants.primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
            ),
            child: const Icon(Icons.auto_awesome_rounded,
                color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),

          // Title + subtitle
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI Assistant',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: const Color(0xFF42B72A),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.6), width: 1.2),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Always active',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Recent chats toggle button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _toggleRecentChats,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _showRecentChats
                      ? Colors.white.withOpacity(0.3)
                      : Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.history_rounded,
                    color: Colors.white, size: 20),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Close
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _toggleChat,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.close_rounded,
                    color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Online badge strip ────────────────────────────────────
  Widget _buildOnlineBadge() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: AdminConstants.primaryColor.withOpacity(0.1),
      child: Row(
        children: [
          Icon(Icons.lock_outline_rounded,
              size: 13,
              color: AdminConstants.primaryColor.withOpacity(0.8)),
          const SizedBox(width: 6),
          Text(
            'End-to-end encrypted conversation',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AdminConstants.primaryColor,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  // ── Recent Chats Panel (collapsible) ─────────────────────
  Widget _buildRecentChatsPanel() {
    return SizeTransition(
      sizeFactor: _safeRecentHeight,
      axisAlignment: -1,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 220),
        decoration: BoxDecoration(
          color: AdminConstants.backgroundColor,
          border: Border(
            bottom: BorderSide(color: AdminConstants.borderColor, width: 1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Section header
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Icon(Icons.history_rounded,
                      size: 15,
                      color: AdminConstants.textColor.withOpacity(0.6)),
                  const SizedBox(width: 6),
                  Text(
                    'Recent Chats',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AdminConstants.textColor.withOpacity(0.6),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacer(),
                  if (_recentSessions.isNotEmpty)
                    Text(
                      '${_recentSessions.length} conversation${_recentSessions.length > 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: 11,
                        color: AdminConstants.textColor.withOpacity(0.4),
                      ),
                    ),
                ],
              ),
            ),

            // Sessions list or empty state
            if (_recentSessions.isEmpty)
              Padding(
                padding:
                    const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Row(
                  children: [
                    Icon(Icons.chat_bubble_outline_rounded,
                        size: 14,
                        color: AdminConstants.textColor.withOpacity(0.3)),
                    const SizedBox(width: 8),
                    Text(
                      'No previous chats yet',
                      style: TextStyle(
                        fontSize: 13,
                        color: AdminConstants.textColor.withOpacity(0.4),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              )
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: 8),
                  itemCount: _recentSessions.length,
                  itemBuilder: (context, index) {
                    final session = _recentSessions[index];
                    return _buildRecentSessionTile(session);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSessionTile(ChatSession session) {
    return InkWell(
      onTap: () => _restoreSession(session),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AdminConstants.primaryColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.chat_bubble_outline_rounded,
                size: 15,
                color: AdminConstants.primaryColor,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AdminConstants.textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${session.messages.length} messages · ${_formatDate(session.lastUpdated)}',
                    style: TextStyle(
                      fontSize: 11,
                      color: AdminConstants.textColor.withOpacity(0.45),
                    ),
                  ),
                ],
              ),
            ),
            // Delete button
            IconButton(
              onPressed: () => _deleteRecentSession(session),
              icon: Icon(
                Icons.delete_outline_rounded,
                size: 18,
                color: AdminConstants.textColor.withOpacity(0.4),
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
            Icon(Icons.chevron_right_rounded,
                size: 18,
                color: AdminConstants.textColor.withOpacity(0.3)),
          ],
        ),
      ),
    );
  }

  // ── Messages ──────────────────────────────────────────────
  Widget _buildMessagesArea() {
    return Container(
      color: AdminConstants.backgroundColor,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final msg = _messages[index];
          final prev = index > 0 ? _messages[index - 1] : null;
          final isFirstInGroup =
              prev == null || prev.isUser != msg.isUser;
          return _buildMessageBubble(msg, isFirstInGroup: isFirstInGroup);
        },
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg,
      {required bool isFirstInGroup}) {
    final isUser = msg.isUser;

    return Padding(
      padding: EdgeInsets.only(
        bottom: isFirstInGroup ? 4 : 2,
        top: isFirstInGroup ? 10 : 0,
      ),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser)
            SizedBox(
              width: 36,
              child: isFirstInGroup
                  ? Container(
                      width: 28,
                      height: 28,
                      margin: const EdgeInsets.only(right: 8, bottom: 2),
                      decoration: BoxDecoration(
                        color: FBColors.primaryBlue,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.auto_awesome_rounded,
                          color: Colors.white, size: 14),
                    )
                  : null,
            ),

          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.68,
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isUser
                        ? AdminConstants.primaryColor
                        : AdminConstants.cardColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: isUser
                          ? const Radius.circular(18)
                          : const Radius.circular(4),
                      bottomRight: isUser
                          ? const Radius.circular(4)
                          : const Radius.circular(18),
                    ),
                    border: isUser
                        ? null
                        : Border.all(
                            color: AdminConstants.borderColor, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    msg.text,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: isUser
                          ? Colors.white
                          : AdminConstants.textColor,
                      height: 1.45,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _formatTime(msg.timestamp),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.1,
                    color: AdminConstants.textColor.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),

          if (isUser) const SizedBox(width: 4),
        ],
      ),
    );
  }

  // ── Typing Indicator ─────────────────────────────────────
  Widget _buildTypingIndicator() {
    return Container(
      color: AdminConstants.backgroundColor,
      padding: const EdgeInsets.only(left: 52, bottom: 4, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AdminConstants.cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
              ),
              border:
                  Border.all(color: AdminConstants.borderColor, width: 1),
            ),
            child: AnimatedBuilder(
              animation: _typingDot,
              builder: (_, __) => Row(
                children: List.generate(3, (i) {
                  final delay = i * 0.33;
                  final phase =
                      (_safeTypingDot.value - delay).clamp(0.0, 1.0);
                  final bounce =
                      (phase < 0.5) ? phase * 2 : (1 - phase) * 2;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2.5),
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: AdminConstants.textColor
                          .withOpacity(0.5 + bounce * 0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    transform:
                        Matrix4.translationValues(0, -bounce * 4, 0),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Input Area ────────────────────────────────────────────
  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
      decoration: BoxDecoration(
        color: AdminConstants.cardColor,
        border: Border(
          top: BorderSide(color: AdminConstants.borderColor, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // ── New Chat button ───────────────────────────────
          Tooltip(
            message: 'New Chat',
            child: GestureDetector(
              onTap: _startNewChat,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AdminConstants.backgroundColor,
                  borderRadius: BorderRadius.circular(19),
                  border: Border.all(
                      color: AdminConstants.borderColor, width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.add_comment_rounded,
                  color: AdminConstants.primaryColor,
                  size: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),

          // ── TextField ─────────────────────────────────────
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 120),
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: AdminConstants.backgroundColor,
                borderRadius: BorderRadius.circular(22),
                border:
                    Border.all(color: AdminConstants.borderColor, width: 1),
              ),
              child: TextField(
                controller: _textController,
                focusNode: _inputFocus,
                minLines: 1,
                maxLines: 5,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _handleSendMessage(),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: AdminConstants.textColor,
                  height: 1.45,
                ),
                decoration: InputDecoration(
                  hintText: 'Aa',
                  hintStyle: TextStyle(
                    fontSize: 15,
                    color: AdminConstants.textColor.withOpacity(0.6),
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 10),
                  isDense: true,
                ),
              ),
            ),
          ),

          // ── Send button ───────────────────────────────────
          GestureDetector(
            onTap: _handleSendMessage,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AdminConstants.primaryColor,
                borderRadius: BorderRadius.circular(19),
                boxShadow: [
                  BoxShadow(
                    color: AdminConstants.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.send_rounded,
                  color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}