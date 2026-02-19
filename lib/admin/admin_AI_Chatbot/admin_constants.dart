import 'package:flutter/material.dart';

// AI Chatbot specific constants
class AIChatbotConstants {
  // Animation durations
  static const Duration chatOpenDuration = Duration(milliseconds: 300);
  static const Duration chatCloseDuration = Duration(milliseconds: 250);
  static const Duration messageSendDelay = Duration(milliseconds: 600);
  
  // Chat panel dimensions
  static const double chatPanelWidth = 380.0;
  static const double chatPanelMinWidth = 320.0;
  static const double chatPanelMaxWidth = 420.0;
  static const double chatPanelHeight = 500.0;
  static const double chatPanelMinHeight = 450.0;
  static const double chatPanelMaxHeight = 550.0;
  
  // Message bubble styling
  static const double messagePadding = 12.0;
  static const double messageMargin = 16.0;
  static const double messageBorderRadius = 18.0;
  static const double maxMessageWidthRatio = 0.75;
  
  // Input field styling
  static const double inputFieldBorderRadius = 24.0;
  static const double inputFieldHeight = 48.0;
  
  // Chat header styling
  static const double chatHeaderHeight = 64.0;
  static const double chatHeaderBorderRadius = 16.0;
  
  // Floating button styling
  static const double floatingButtonSize = 56.0;
  static const double floatingButtonElevation = 8.0;
  static const double floatingButtonRadius = 28.0;
  
  // Colors
  static const Color userMessageColor = Color(0xFF1877F2); // Primary blue
  static const Color botMessageColor = Color(0xFFF0F2F5); // Light gray
  static const Color chatHeaderColor = Color(0xFF1877F2); // Primary blue
  static const Color chatBackgroundColor = Color(0xFFFFFFFF); // White
  static const Color floatingButtonShadow = Color(0x4D1877F2); // Primary blue with opacity
  
  // Animation curves
  static const Curve chatOpenCurve = Curves.easeOutCubic;
  static const Curve chatCloseCurve = Curves.easeInCubic;
  static const Curve pulseCurve = Curves.easeInOut;
}