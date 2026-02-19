import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';
import '../utils/admin_constants.dart';
import '../admin_AI_Chatbot/services/ai_response_service.dart';
import '../../../screens/ai_assistant_screen.dart' show FBColors;

// ─────────────────────────────────────────────────────────────
// Data Model
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
  bool _isChatOpen   = false;
  bool _isTyping     = false;
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController     _scrollController = ScrollController();
  final FocusNode            _inputFocus = FocusNode();

  // ── Animations ─────────────────────────────────────────────
  late AnimationController _panelController;
  late AnimationController _typingController;
  late AnimationController _blurController;

  late Animation<double>  _panelSlide;
  late Animation<double>  _panelFade;
  late Animation<double>  _typingDot;
  late Animation<double>  _blurOpacity;
  late Animation<double>  _blurIntensity;

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

    // Welcome message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 600), () {
        _addBotMessage(
          "Hi! 👋 I'm your AI assistant. How can I help you today?",
        );
      });
    });
  }

  @override
  void dispose() {
    _panelController.dispose();
    _typingController.dispose();
    _blurController.dispose();
    _textController.dispose();
    _scrollController.dispose();
    _inputFocus.dispose();
    super.dispose();
  }

  // ── Helpers ────────────────────────────────────────────────
  void _toggleChat() {
    setState(() => _isChatOpen = !_isChatOpen);
    if (_isChatOpen) {
      _panelController.forward();
      _blurController.forward();
      Future.delayed(const Duration(milliseconds: 200), () {
        _inputFocus.requestFocus();
      });
    } else {
      _panelController.reverse();
      _blurController.reverse();
      _inputFocus.unfocus();
    }
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

    // Show typing indicator, then respond
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
      final response = await AIResponseService.getAIResponse(userMessage);
      if (mounted) {
        _addBotMessage(response);
      }
    } catch (e) {
      if (mounted) {
        _addBotMessage("Thanks for your message! I'm here to help with any questions you have.");
      }
    }
  }

  String _formatTime(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  double _panelWidth(BuildContext ctx) {
    final w = MediaQuery.of(ctx).size.width;
    if (w > 1200) return 400;
    if (w > 768)  return 360;
    return w * 0.92;
  }

  // ── Build ──────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── Backdrop Blur Overlay ─────────────────────────────────────
        if (_isChatOpen)
          AnimatedBuilder(
            animation: _blurController,
            builder: (context, child) {
              return Positioned.fill(
                child: Opacity(
                  opacity: _blurOpacity.value * 0.7, // 70% max opacity for dark overlay
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 8.0 * _blurIntensity.value,  // Soft blur effect
                      sigmaY: 8.0 * _blurIntensity.value,
                    ),
                    child: Container(
                      color: Colors.black.withOpacity(0.3 * _blurOpacity.value), // Semi-transparent dark overlay
                    ),
                  ),
                ),
              );
            },
          ),

        // ── Chat Panel ─────────────────────────────────────
        AnimatedBuilder(
          animation: _panelController,
          builder: (context, child) {
            return Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              child: Transform.translate(
                offset: Offset(
                  _panelWidth(context) * (1 - _panelSlide.value),
                  0,
                ),
                child: Opacity(
                  opacity: _panelFade.value,
                  child: child,
                ),
              ),
            );
          },
          child: _buildChatPanel(),
        ),

        // ── Floating Chat Icon ────────────────────────────────────────────
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
                child: const Icon(Icons.chat_bubble_rounded, color: Colors.white, size: 22),
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
              border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
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
                        border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.2),
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
                child: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
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
          Icon(Icons.lock_outline_rounded, size: 13, color: AdminConstants.primaryColor.withOpacity(0.8)),
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
          final isFirstInGroup = prev == null || prev.isUser != msg.isUser;
          return _buildMessageBubble(msg, isFirstInGroup: isFirstInGroup);
        },
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg, {required bool isFirstInGroup}) {
    final isUser = msg.isUser;

    return Padding(
      padding: EdgeInsets.only(
        bottom: isFirstInGroup ? 4 : 2,
        top: isFirstInGroup ? 10 : 0,
      ),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // ── FIX: Bot avatar — always reserve the same width (36px),
          // but only render the avatar circle on the first message in a group.
          if (!isUser)
            SizedBox(
              width: 36, // 28 avatar + 8 margin
              child: isFirstInGroup
                  ? Container(
                      width: 28,
                      height: 28,
                      margin: const EdgeInsets.only(right: 8, bottom: 2),
                      decoration: BoxDecoration(
                        color: FBColors.primaryBlue,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                    )
                  : null,
            ),

          // Bubble
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.68,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isUser ? AdminConstants.primaryColor : AdminConstants.cardColor,
                    borderRadius: BorderRadius.only(
                      topLeft:     const Radius.circular(18),
                      topRight:    const Radius.circular(18),
                      bottomLeft:  isUser ? const Radius.circular(18) : const Radius.circular(4),
                      bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(18),
                    ),
                    border: isUser
                        ? null
                        : Border.all(color: AdminConstants.borderColor, width: 1),
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
                      color: isUser ? Colors.white : AdminConstants.textColor,
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

          // User avatar spacing
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
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AdminConstants.cardColor,
              borderRadius: const BorderRadius.only(
                topLeft:     Radius.circular(18),
                topRight:    Radius.circular(18),
                bottomRight: Radius.circular(18),
                bottomLeft:  Radius.circular(4),
              ),
              border: Border.all(color: AdminConstants.borderColor, width: 1),
            ),
            child: AnimatedBuilder(
              animation: _typingDot,
              builder: (_, __) => Row(
                children: List.generate(3, (i) {
                  final delay = i * 0.33;
                  final phase = (_typingDot.value - delay).clamp(0.0, 1.0);
                  final bounce = (phase < 0.5) ? phase * 2 : (1 - phase) * 2;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2.5),
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: AdminConstants.textColor.withOpacity(0.5 + bounce * 0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    transform: Matrix4.translationValues(0, -bounce * 4, 0),
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
          // TextField
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 120),
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: AdminConstants.backgroundColor,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AdminConstants.borderColor, width: 1),
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  isDense: true,
                ),
              ),
            ),
          ),

          // Send button
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
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}