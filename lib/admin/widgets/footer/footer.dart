import 'package:flutter/material.dart';
import '../../utils/admin_constants.dart';

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AdminConstants.footerHeight,
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF), // White background
        border: Border(
          top: BorderSide(
            color: const Color(0xFFE4E6EB), // Light border instead of shadow
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              AdminConstants.copyright,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Color(0xFF65676B), // Light gray text
                letterSpacing: 0.1,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2F5), // Light gray background
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'v${AdminConstants.version}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1877F2), // Facebook blue for version
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 3,
                height: 3,
                decoration: const BoxDecoration(
                  color: Color(0xFFCED0D4), // Subtle separator dot
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
        ],
      ),
    );
  }
}