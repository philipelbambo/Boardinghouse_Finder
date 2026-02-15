import 'package:flutter/material.dart';

class InterestedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isInterested;
  
  const InterestedButton({
    super.key,
    required this.onPressed,
    this.isInterested = false,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      right: 16,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isInterested 
                ? const Color(0xFF4CAF50) // Green when interested
                : const Color(0xFF1877F2), // Facebook blue
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: (isInterested ? const Color(0xFF4CAF50) : const Color(0xFF1877F2))
                    .withOpacity(0.3),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isInterested ? Icons.check : Icons.favorite_border,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                isInterested ? 'Interested' : 'I\'m Interested',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}