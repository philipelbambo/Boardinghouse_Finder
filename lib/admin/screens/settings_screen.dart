import 'package:flutter/material.dart';
import '../utils/admin_constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1C1E21),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Configure application settings and preferences',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF65676B),
              ),
            ),
            const SizedBox(height: 32),
            
            // Settings Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AdminConstants.cardRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SettingsSection(
                      title: 'General Settings',
                      icon: Icons.settings_outlined,
                      items: [
                        _SettingsItem(
                          title: 'Theme',
                          subtitle: 'Light mode',
                          icon: Icons.brightness_6_outlined,
                        ),
                        _SettingsItem(
                          title: 'Language',
                          subtitle: 'English',
                          icon: Icons.language_outlined,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const _SettingsSection(
                      title: 'Notifications',
                      icon: Icons.notifications_outlined,
                      items: [
                        _SettingsItem(
                          title: 'Email Notifications',
                          subtitle: 'Receive email updates',
                          icon: Icons.email_outlined,
                        ),
                        _SettingsItem(
                          title: 'Push Notifications',
                          subtitle: 'In-app notifications',
                          icon: Icons.notifications_active_outlined,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const _SettingsSection(
                      title: 'Account',
                      icon: Icons.account_circle_outlined,
                      items: [
                        _SettingsItem(
                          title: 'Privacy Settings',
                          subtitle: 'Manage your privacy',
                          icon: Icons.privacy_tip_outlined,
                        ),
                        _SettingsItem(
                          title: 'Security',
                          subtitle: 'Password and security',
                          icon: Icons.security_outlined,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<_SettingsItem> items;

  const _SettingsSection({
    required this.title,
    required this.icon,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF1877F2),
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1C1E21),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...items,
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _SettingsItem({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFE4E6EB),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF65676B),
            size: 20,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1C1E21),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF65676B),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: Color(0xFF65676B),
            size: 16,
          ),
        ],
      ),
    );
  }
}
