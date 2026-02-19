# AI Chatbot Widget

## Overview
The AI Chatbot is a floating widget that provides contextual assistance to users within the admin dashboard. It appears as a circular button at the bottom-right corner of the screen and expands into a chat panel when clicked.

## Features
- Floating circular action button with modern design
- Smooth animations for opening/closing the chat panel
- Contextual AI responses based on user queries
- Responsive design that works on both desktop and mobile
- Integration with admin dashboard theme
- Message history and scrolling capability

## Components

### Main Widget
- `AdminAIChatbot` - The main StatefulWidget that manages the chat interface

### Supporting Files
- `admin_constants.dart` - Contains all styling and animation constants
- `services/ai_response_service.dart` - Handles AI response logic (both mock and API versions)

## Usage
The widget is automatically integrated into the admin dashboard layout through the `AdminLayout` widget. Simply include the widget in any screen, and it will appear consistently across all dashboard pages.

## Styling
The chatbot uses the existing admin theme colors and follows the design guidelines of the dashboard:
- Primary color: `AdminConstants.primaryColor`
- Background color: `AdminConstants.cardColor`
- Text colors: Follow admin theme

## AI Response Logic
The widget uses a service layer to handle AI responses:
- For demonstration purposes, a mock response service is used
- For production, connect to an actual AI API (OpenAI, Google, etc.)
- Responses are context-aware based on keywords related to boardinghouse management

## Animation & Transitions
- Opening animation: Scale and slide-up transition
- Closing animation: Reverse of opening
- Message sending: Smooth scrolling to latest message
- Duration: Configured via constants

## Future Enhancements
- Connect to actual AI API for smarter responses
- Add typing indicators
- Implement message persistence
- Add voice input capability
- Integrate with real-time admin data