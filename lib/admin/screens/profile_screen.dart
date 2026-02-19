import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
//  ProfileScreen – Facebook-inspired UI
//  Fully responsive: mobile / tablet / desktop
// ─────────────────────────────────────────────

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _nameController  = TextEditingController(text: 'Philip Elbambo');
  final _emailController = TextEditingController(text: 'admin@bfinder.ph');
  final _phoneController = TextEditingController(text: '+63 912 345 6789');

  bool _isSaving = false;

  // ── Facebook-inspired Palette ─────────────
  static const Color _primary  = Color(0xFF1877F2);
  static const Color _bg       = Color(0xFFF0F2F5);
  static const Color _card     = Color(0xFFFFFFFF);
  static const Color _textDark = Color(0xFF1C1E21);
  static const Color _textMid  = Color(0xFF65676B);
  static const Color _border   = Color(0xFFDDDFE2);

  // ── Breakpoints ───────────────────────────
  static const double _mobileBreak = 480;
  static const double _tabletBreak = 768;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _isSaving = false);
    _showSnackbar(
      icon: Icons.check_circle_rounded,
      message: 'Profile updated successfully!',
      color: const Color(0xFF42B72A),
    );
  }

  void _showSnackbar({
    required IconData icon,
    required String message,
    required Color color,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                message,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _ChangePasswordDialog(),
    );
  }

  void _onChangePhoto() {
    _showSnackbar(
      icon: Icons.photo_camera,
      message: 'Photo upload feature coming soon!',
      color: _primary,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final isMobile = width < _mobileBreak;
            final isTablet = width >= _mobileBreak && width < _tabletBreak;
            final isDesktop = width >= _tabletBreak;

            final hPad = isMobile ? 12.0 : isTablet ? 20.0 : 28.0;
            final vPad = isMobile ? 16.0 : 24.0;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeaderCard(isMobile: isMobile),
                        SizedBox(height: isMobile ? 12 : 16),

                        // Two-column on tablet+, stacked on mobile
                        if (isDesktop || isTablet)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  flex: 3,
                                  child: _buildPersonalInfoCard(
                                      isMobile: isMobile)),
                              const SizedBox(width: 16),
                              Expanded(
                                  flex: 2,
                                  child: _buildSecurityCard(
                                      isMobile: isMobile)),
                            ],
                          )
                        else
                          Column(
                            children: [
                              _buildPersonalInfoCard(isMobile: isMobile),
                              const SizedBox(height: 12),
                              _buildSecurityCard(isMobile: isMobile),
                            ],
                          ),

                        SizedBox(height: isMobile ? 16 : 20),
                        _buildActionButtons(isMobile: isMobile),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ── Header Card ───────────────────────────
  Widget _buildHeaderCard({required bool isMobile}) {
    final avatarSize = isMobile ? 64.0 : 88.0;
    final avatarFontSize = isMobile ? 20.0 : 26.0;
    final nameFontSize = isMobile ? 16.0 : 20.0;
    final camSize = isMobile ? 24.0 : 28.0;
    final camIconSize = isMobile ? 12.0 : 14.0;
    final padding = isMobile ? 16.0 : 24.0;

    final avatarWidget = Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: avatarSize,
          height: avatarSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _primary, width: 3),
            boxShadow: const [
              BoxShadow(
                color: Color(0x201877F2),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: avatarSize / 2,
            backgroundColor: const Color(0xFFE7F3FF),
            child: Text(
              'PE',
              style: TextStyle(
                color: _primary,
                fontSize: avatarFontSize,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: -2,
          child: GestureDetector(
            onTap: _onChangePhoto,
            child: Container(
              width: camSize,
              height: camSize,
              decoration: BoxDecoration(
                color: _primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(Icons.camera_alt_rounded,
                  color: Colors.white, size: camIconSize),
            ),
          ),
        ),
      ],
    );

    final infoWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Role badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFFE7F3FF),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.verified_rounded, color: _primary, size: 11),
              SizedBox(width: 4),
              Text(
                'SUPER ADMIN',
                style: TextStyle(
                  color: _primary,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        AnimatedBuilder(
          animation: _nameController,
          builder: (_, __) => Text(
            _nameController.text.isEmpty
                ? 'Administrator'
                : _nameController.text,
            style: TextStyle(
              fontSize: nameFontSize,
              fontWeight: FontWeight.w800,
              color: _textDark,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.email_outlined, size: 12, color: _textMid),
            const SizedBox(width: 4),
            Flexible(
              child: AnimatedBuilder(
                animation: _emailController,
                builder: (_, __) => Text(
                  _emailController.text,
                  style: TextStyle(
                      color: _textMid, fontSize: isMobile ? 11 : 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            const Icon(Icons.phone_outlined, size: 12, color: _textMid),
            const SizedBox(width: 4),
            Flexible(
              child: AnimatedBuilder(
                animation: _phoneController,
                builder: (_, __) => Text(
                  _phoneController.text.isEmpty
                      ? '—'
                      : _phoneController.text,
                  style: TextStyle(
                      color: _textMid, fontSize: isMobile ? 11 : 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ],
    );

    final activeChip = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 8 : 12, vertical: isMobile ? 5 : 7),
          decoration: BoxDecoration(
            color: const Color(0xFFE6F4EA),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFF81C995)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _PulsingDot(),
              const SizedBox(width: 5),
              Text(
                'Active',
                style: TextStyle(
                  color: const Color(0xFF1E7E34),
                  fontWeight: FontWeight.w700,
                  fontSize: isMobile ? 11 : 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Since Jan 2024',
          style: TextStyle(
              color: _textMid.withOpacity(0.7),
              fontSize: isMobile ? 10 : 11),
        ),
      ],
    );

    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(padding),
      child: isMobile
          // ── Mobile: stacked layout ──────────────
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    avatarWidget,
                    const SizedBox(width: 14),
                    Expanded(child: infoWidget),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [activeChip],
                ),
              ],
            )
          // ── Tablet/Desktop: row layout ──────────
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                avatarWidget,
                const SizedBox(width: 20),
                Expanded(child: infoWidget),
                activeChip,
              ],
            ),
    );
  }

  // ── Personal Info Card ────────────────────
  Widget _buildPersonalInfoCard({required bool isMobile}) {
    final padding = isMobile ? 16.0 : 24.0;
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(Icons.person_outline_rounded, 'Personal Information'),
          const SizedBox(height: 18),
          _buildTextField(
            controller: _nameController,
            label: 'Full Name',
            hint: 'e.g. Philip Elbambo',
            icon: Icons.badge_outlined,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Full name is required.';
              if (v.trim().length < 3)
                return 'Name must be at least 3 characters.';
              return null;
            },
          ),
          const SizedBox(height: 14),
          _buildTextField(
            controller: _emailController,
            label: 'Email Address',
            hint: 'e.g. admin@example.com',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Email is required.';
              final ok = RegExp(r'^[\w\-.]+@([\w\-]+\.)+[\w\-]{2,}$');
              if (!ok.hasMatch(v.trim()))
                return 'Enter a valid email address.';
              return null;
            },
          ),
          const SizedBox(height: 14),
          _buildTextField(
            controller: _phoneController,
            label: 'Phone Number',
            hint: 'e.g. +63 912 345 6789',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (v) {
              if (v == null || v.trim().isEmpty)
                return 'Phone number is required.';
              final ok = RegExp(r'^\+?[\d\s\-]{7,15}$');
              if (!ok.hasMatch(v.trim())) return 'Enter a valid phone number.';
              return null;
            },
          ),
        ],
      ),
    );
  }

  // ── Security Card ─────────────────────────
  Widget _buildSecurityCard({required bool isMobile}) {
    final padding = isMobile ? 16.0 : 24.0;
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(Icons.shield_outlined, 'Account Security'),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _bg,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: _border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.lock_outline_rounded,
                        size: 14, color: _textMid),
                    SizedBox(width: 7),
                    Text(
                      'Password',
                      style: TextStyle(
                        color: _textMid,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '••••••••••••',
                  style: TextStyle(
                      fontSize: 18, color: _textDark, letterSpacing: 2),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _strengthDot(const Color(0xFF42B72A)),
                    const SizedBox(width: 4),
                    _strengthDot(const Color(0xFF42B72A)),
                    const SizedBox(width: 4),
                    _strengthDot(const Color(0xFF42B72A)),
                    const SizedBox(width: 4),
                    _strengthDot(const Color(0xFFFFC300)),
                    const SizedBox(width: 8),
                    const Text(
                      'Strong',
                      style: TextStyle(
                        color: Color(0xFF42B72A),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Last changed: 3 months ago',
                  style: TextStyle(
                      color: _textMid.withOpacity(0.8), fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _showChangePasswordDialog,
              icon: const Icon(Icons.lock_reset_rounded, size: 16),
              label: const Text('Change Password'),
              style: OutlinedButton.styleFrom(
                foregroundColor: _primary,
                side: const BorderSide(color: _primary, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                textStyle: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Divider(color: _border),
          const SizedBox(height: 14),
          _sectionHeader(Icons.info_outline_rounded, 'Account Details'),
          const SizedBox(height: 12),
          _infoRow('Role', 'Super Admin'),
          _infoRow('User ID', '#ADM-00142'),
          _infoRow('Last Login', 'Feb 18, 2026'),
          _infoRow('2FA', '✓ Enabled'),
        ],
      ),
    );
  }

  // ── Action Buttons ────────────────────────
  Widget _buildActionButtons({required bool isMobile}) {
    if (isMobile) {
      // Full-width stacked buttons on mobile
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _isSaving ? null : _saveProfile,
              icon: _isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.5, color: Colors.white),
                    )
                  : const Icon(Icons.save_rounded, size: 18),
              label: Text(_isSaving ? 'Saving...' : 'Save Changes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                textStyle: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 15),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () {
                _formKey.currentState?.reset();
                setState(() {
                  _nameController.text  = 'Philip Elbambo';
                  _emailController.text = 'admin@bfinder.ph';
                  _phoneController.text = '+63 912 345 6789';
                });
              },
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Reset'),
              style: OutlinedButton.styleFrom(
                foregroundColor: _textMid,
                side: const BorderSide(color: _border, width: 1.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                textStyle: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
          ),
        ],
      );
    }

    // Tablet / Desktop: right-aligned row
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton.icon(
          onPressed: () {
            _formKey.currentState?.reset();
            setState(() {
              _nameController.text  = 'Philip Elbambo';
              _emailController.text = 'admin@bfinder.ph';
              _phoneController.text = '+63 912 345 6789';
            });
          },
          icon: const Icon(Icons.refresh_rounded, size: 16),
          label: const Text('Reset'),
          style: OutlinedButton.styleFrom(
            foregroundColor: _textMid,
            side: const BorderSide(color: _border, width: 1.5),
            padding:
                const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6)),
            textStyle:
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          height: 48,
          child: ElevatedButton.icon(
            onPressed: _isSaving ? null : _saveProfile,
            icon: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.5, color: Colors.white),
                  )
                : const Icon(Icons.save_rounded, size: 18),
            label: Text(_isSaving ? 'Saving...' : 'Save Changes'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primary,
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 15),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }

  // ── Helpers ───────────────────────────────
  Widget _sectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: const Color(0xFFE7F3FF),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: _primary),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: _textDark,
          ),
        ),
      ],
    );
  }

  Widget _strengthDot(Color color) => Container(
        width: 20,
        height: 5,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(3)),
      );

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 78,
            child: Text(label,
                style: const TextStyle(color: _textMid, fontSize: 13)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                  color: _textDark,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(
          fontSize: 15, color: _textDark, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: _textMid.withOpacity(0.5), fontSize: 14),
        prefixIcon: Icon(icon, color: _textMid, size: 20),
        filled: true,
        fillColor: _bg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: _border, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: _primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide:
              const BorderSide(color: Color(0xFFFA3E3E), width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFFFA3E3E), width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        labelStyle: const TextStyle(color: _textMid, fontSize: 14),
        floatingLabelStyle:
            const TextStyle(color: _primary, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Change Password Dialog – also responsive
// ─────────────────────────────────────────────
class _ChangePasswordDialog extends StatefulWidget {
  const _ChangePasswordDialog();

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final _formKey     = GlobalKey<FormState>();
  final _currentCtrl = TextEditingController();
  final _newCtrl     = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _showCurrent = false;
  bool _showNew     = false;
  bool _showConfirm = false;
  bool _isSaving    = false;

  double _strengthScore = 0;
  String _strengthLabel = '';
  Color  _strengthColor = Colors.transparent;

  static const Color _primary  = Color(0xFF1877F2);
  static const Color _bg       = Color(0xFFF0F2F5);
  static const Color _textDark = Color(0xFF1C1E21);
  static const Color _textMid  = Color(0xFF65676B);
  static const Color _border   = Color(0xFFDDDFE2);

  void _checkStrength(String v) {
    double score = 0;
    if (v.length >= 8) score++;
    if (v.contains(RegExp(r'[A-Z]'))) score++;
    if (v.contains(RegExp(r'[0-9]'))) score++;
    if (v.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) score++;
    setState(() {
      _strengthScore = score / 4;
      if (score <= 1) {
        _strengthLabel = 'Weak';
        _strengthColor = const Color(0xFFFA3E3E);
      } else if (score == 2) {
        _strengthLabel = 'Fair';
        _strengthColor = Colors.orange;
      } else if (score == 3) {
        _strengthLabel = 'Good';
        _strengthColor = const Color(0xFFFFC300);
      } else {
        _strengthLabel = 'Strong';
        _strengthColor = const Color(0xFF42B72A);
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        backgroundColor: const Color(0xFF42B72A),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        content: const Row(
          children: [
            Icon(Icons.lock_rounded, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Text('Password changed successfully!',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  InputDecoration _passDecoration({
    required String label,
    required bool show,
    required VoidCallback onToggle,
  }) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: _bg,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: _border, width: 1.5)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: _primary, width: 2)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide:
              const BorderSide(color: Color(0xFFFA3E3E), width: 1.5)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide:
              const BorderSide(color: Color(0xFFFA3E3E), width: 2)),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      prefixIcon: const Icon(Icons.lock_outline_rounded,
          color: _textMid, size: 18),
      suffixIcon: IconButton(
        icon: Icon(
            show
                ? Icons.visibility_off_rounded
                : Icons.visibility_rounded,
            color: _textMid,
            size: 18),
        onPressed: onToggle,
      ),
      labelStyle: const TextStyle(color: _textMid),
      floatingLabelStyle:
          const TextStyle(color: _primary, fontWeight: FontWeight.w600),
    );
  }

  Widget _passField({
    required TextEditingController controller,
    required String label,
    required bool show,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !show,
      validator: validator,
      style: const TextStyle(fontSize: 14, color: _textDark),
      decoration:
          _passDecoration(label: label, show: show, onToggle: onToggle),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 480;

    return Dialog(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      backgroundColor: Colors.white,
      // Full-screen feel on mobile, modal on larger screens
      insetPadding: isMobile
          ? const EdgeInsets.symmetric(horizontal: 12, vertical: 24)
          : const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 20 : 28),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE7F3FF),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.lock_reset_rounded,
                          color: _primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Change Password',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: _textDark)),
                          Text('Enter current and new password.',
                              style:
                                  TextStyle(fontSize: 12, color: _textMid)),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon:
                          const Icon(Icons.close_rounded, color: _textMid),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Divider(color: _border),
                const SizedBox(height: 18),

                _passField(
                  controller: _currentCtrl,
                  label: 'Current Password',
                  show: _showCurrent,
                  onToggle: () =>
                      setState(() => _showCurrent = !_showCurrent),
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Current password is required.'
                      : null,
                ),
                const SizedBox(height: 14),

                TextFormField(
                  controller: _newCtrl,
                  obscureText: !_showNew,
                  onChanged: _checkStrength,
                  validator: (v) {
                    if (v == null || v.isEmpty)
                      return 'New password is required.';
                    if (v.length < 8)
                      return 'At least 8 characters required.';
                    return null;
                  },
                  style: const TextStyle(fontSize: 14, color: _textDark),
                  decoration: _passDecoration(
                    label: 'New Password',
                    show: _showNew,
                    onToggle: () => setState(() => _showNew = !_showNew),
                  ),
                ),
                if (_newCtrl.text.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: _strengthScore,
                            backgroundColor: _border,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                _strengthColor),
                            minHeight: 5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _strengthLabel,
                        style: TextStyle(
                          color: _strengthColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 14),

                _passField(
                  controller: _confirmCtrl,
                  label: 'Confirm New Password',
                  show: _showConfirm,
                  onToggle: () =>
                      setState(() => _showConfirm = !_showConfirm),
                  validator: (v) {
                    if (v == null || v.isEmpty)
                      return 'Please confirm your password.';
                    if (v != _newCtrl.text) return 'Passwords do not match.';
                    return null;
                  },
                ),
                const SizedBox(height: 22),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _textMid,
                          side: BorderSide(color: _border),
                          padding:
                              const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                        ),
                        child: const Text('Cancel',
                            style:
                                TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primary,
                          foregroundColor: Colors.white,
                          padding:
                              const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          elevation: 0,
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white),
                              )
                            : const Text(
                                'Update Password',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Pulsing dot (active status indicator)
// ─────────────────────────────────────────────
class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 1))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color.lerp(const Color(0xFF81C995),
              const Color(0xFF1E7E34), _anim.value),
        ),
      ),
    );
  }
}