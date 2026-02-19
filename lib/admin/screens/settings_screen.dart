import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────
//  COLOR PALETTE  (Facebook-inspired)
// ─────────────────────────────────────────────────────────────
class FBColors {
  static const background   = Color(0xFFF0F2F5);
  static const surface      = Color(0xFFFFFFFF);
  static const primary      = Color(0xFF1877F2);
  static const primaryLight = Color(0xFFE7F0FE);
  static const textMain     = Color(0xFF1C1E21);
  static const textSub      = Color(0xFF65676B);
  static const divider      = Color(0xFFE4E6EB);
  static const inputFill    = Color(0xFFF0F2F5);
  static const success      = Color(0xFF42B883);
  static const successBg    = Color(0xFFECFDF5);
  static const error        = Color(0xFFFA3E3E);
  static const warning      = Color(0xFFF5A623);
  static const purple       = Color(0xFF8B5CF6);
}

// ─────────────────────────────────────────────────────────────
//  BREAKPOINTS
// ─────────────────────────────────────────────────────────────
class BP {
  static bool isMobile(BuildContext ctx)  => MediaQuery.of(ctx).size.width < 600;
  static bool isTablet(BuildContext ctx)  => MediaQuery.of(ctx).size.width >= 600 && MediaQuery.of(ctx).size.width < 1024;
  static bool isDesktop(BuildContext ctx) => MediaQuery.of(ctx).size.width >= 1024;

  static double hPad(BuildContext ctx) {
    if (isMobile(ctx))  return 16;
    if (isTablet(ctx))  return 24;
    return 32;
  }

  static double vPad(BuildContext ctx) => isMobile(ctx) ? 20 : 32;
  static double sectionGap(BuildContext ctx) => isMobile(ctx) ? 14 : 20;
  static double cardPad(BuildContext ctx) => isMobile(ctx) ? 16 : 24;
  static double titleSize(BuildContext ctx) => isMobile(ctx) ? 20.0 : 24.0;
  static double subtitleSize(BuildContext ctx) => isMobile(ctx) ? 12.0 : 14.0;
}

void main() => runApp(const AdminApp());

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BoardingHouse Finder – Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: FBColors.primary,
          brightness: Brightness.light,
        ),
        fontFamily: 'Segoe UI',
        scaffoldBackgroundColor: FBColors.background,
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          color: FBColors.surface,
          margin: EdgeInsets.zero,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: FBColors.inputFill,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: FBColors.divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: FBColors.divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: FBColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: FBColors.error),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          labelStyle: const TextStyle(color: FBColors.textSub, fontSize: 14),
          hintStyle: const TextStyle(color: FBColors.textSub, fontSize: 14),
        ),
      ),
      home: const SettingsScreen(),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  SETTINGS SCREEN
// ─────────────────────────────────────────────────────────────
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey    = GlobalKey<FormState>();
  final _scrollCtrl = ScrollController();

  // General Info
  final _systemNameCtrl = TextEditingController(text: 'BoardingHouse Finder');
  final _emailCtrl      = TextEditingController(text: 'admin@bhfinder.com');
  final _phoneCtrl      = TextEditingController(text: '+63 912 345 6789');
  final _addressCtrl    = TextEditingController(text: '123 Bonifacio St., CDO City');

  // Booking
  bool   _instantBooking       = true;
  bool   _requireAdminApproval = false;
  String _cancellationPolicy   = '24 Hours';
  final  _cancellationOptions  = ['Non-refundable', '24 Hours', '48 Hours', '7 Days', 'Flexible'];

  // Notifications
  bool _emailNotifs = true;
  bool _inAppNotifs = true;

  // Security
  bool   _twoFactor      = false;
  String _sessionTimeout = '30 Minutes';
  final  _sessionOptions = ['15 Minutes', '30 Minutes', '1 Hour', '2 Hours', '8 Hours'];

  bool _isSaving = false;

  @override
  void dispose() {
    _systemNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 900));
    setState(() => _isSaving = false);
    if (!mounted) return;
    _showSuccessBanner();
  }

  void _showSuccessBanner() {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        backgroundColor: FBColors.successBg,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        content: Row(
          children: const [
            Icon(Icons.check_circle_rounded, color: FBColors.success, size: 20),
            SizedBox(width: 10),
            Text('Settings saved successfully!',
                style: TextStyle(
                    color: Color(0xFF065F46),
                    fontWeight: FontWeight.w600,
                    fontSize: 14)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
            child: const Text('Dismiss',
                style: TextStyle(color: FBColors.success)),
          ),
        ],
      ),
    );
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    });
  }

  void _showChangePasswordDialog() {
    final oldCtrl     = TextEditingController();
    final newCtrl     = TextEditingController();
    final confirmCtrl = TextEditingController();
    final fKey        = GlobalKey<FormState>();
    bool obscOld = true, obscNew = true, obscConf = true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, set) => AlertDialog(
          backgroundColor: FBColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          actionsPadding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: FBColors.primaryLight,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.lock_outline_rounded,
                    color: FBColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('Change Password',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: FBColors.textMain)),
              ),
            ],
          ),
          content: SizedBox(
            width: 420,
            child: Form(
              key: fKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _passField(
                    ctrl: oldCtrl,
                    label: 'Current Password',
                    obscure: obscOld,
                    toggle: () => set(() => obscOld = !obscOld),
                    val: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  _passField(
                    ctrl: newCtrl,
                    label: 'New Password',
                    obscure: obscNew,
                    toggle: () => set(() => obscNew = !obscNew),
                    val: (v) => (v == null || v.length < 8) ? 'At least 8 characters' : null,
                  ),
                  const SizedBox(height: 16),
                  _passField(
                    ctrl: confirmCtrl,
                    label: 'Confirm New Password',
                    obscure: obscConf,
                    toggle: () => set(() => obscConf = !obscConf),
                    val: (v) => v != newCtrl.text ? 'Passwords do not match' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              style: TextButton.styleFrom(foregroundColor: FBColors.textSub),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: FBColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              ),
              onPressed: () {
                if (fKey.currentState!.validate()) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Password updated successfully'),
                      backgroundColor: FBColors.success,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                  );
                }
              },
              child: const Text('Update Password',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _passField({
    required TextEditingController ctrl,
    required String label,
    required bool obscure,
    required VoidCallback toggle,
    String? Function(String?)? val,
  }) {
    return TextFormField(
      controller: ctrl,
      obscureText: obscure,
      validator: val,
      style: const TextStyle(fontSize: 14, color: FBColors.textMain),
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            size: 18, color: FBColors.textSub,
          ),
          onPressed: toggle,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final hPad = BP.hPad(context);
    final vPad = BP.vPad(context);
    final gap  = BP.sectionGap(context);

    return Scaffold(
      backgroundColor: FBColors.background,
      body: Form(
        key: _formKey,
        child: Scrollbar(
          controller: _scrollCtrl,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _scrollCtrl,
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _section(context, 'General Information',    Icons.info_outline_rounded,       _buildGeneralInfo(context)),
                SizedBox(height: gap),
                _section(context, 'Booking Configuration',  Icons.event_available_rounded,    _buildBookingConfig(context)),
                SizedBox(height: gap),
                _section(context, 'Notification Settings',  Icons.notifications_none_rounded, _buildNotifications(context)),
                SizedBox(height: gap),
                _section(context, 'Security',               Icons.shield_outlined,            _buildSecurity(context)),
                SizedBox(height: gap * 2),
                _buildActions(context),
                SizedBox(height: vPad),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  //  SECTION WRAPPER
  // ─────────────────────────────────────────────────────────────
  Widget _section(BuildContext context, String title, IconData icon, Widget content) {
    final cPad = BP.cardPad(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FBColors.surface,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(cPad, 16, cPad, 14),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: FBColors.divider)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: FBColors.primaryLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(icon, color: FBColors.primary, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(title,
                      style: TextStyle(
                          fontSize: BP.isMobile(context) ? 14 : 15,
                          fontWeight: FontWeight.w700,
                          color: FBColors.textMain)),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(cPad),
            child: content,
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  //  GENERAL INFO
  // ─────────────────────────────────────────────────────────────
  Widget _buildGeneralInfo(BuildContext context) {
    final isMobile = BP.isMobile(context);
    final fields = [
      _field(label: 'System Name',    ctrl: _systemNameCtrl, hint: 'e.g. BoardingHouse Finder',
          validator: (v) => (v == null || v.trim().isEmpty) ? 'System name is required' : null),
      _field(label: 'Contact Email',  ctrl: _emailCtrl,      hint: 'admin@example.com',
          keyboardType: TextInputType.emailAddress,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Required';
            return RegExp(r'^[\w.-]+@[\w.-]+\.\w+$').hasMatch(v) ? null : 'Invalid email';
          }),
      _field(label: 'Contact Phone',  ctrl: _phoneCtrl,      hint: '+63 9XX XXX XXXX',
          keyboardType: TextInputType.phone,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null),
      _field(label: 'Business Address', ctrl: _addressCtrl,  hint: 'Street, City, Province',
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null),
    ];

    if (isMobile) {
      return Column(
        children: fields
            .map((f) => Padding(padding: const EdgeInsets.only(bottom: 16), child: f))
            .toList(),
      );
    }

    return Column(
      children: [
        Row(children: [
          Expanded(child: fields[0]),
          const SizedBox(width: 20),
          Expanded(child: fields[1]),
        ]),
        const SizedBox(height: 20),
        Row(children: [
          Expanded(child: fields[2]),
          const SizedBox(width: 20),
          Expanded(child: fields[3]),
        ]),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  //  BOOKING CONFIG
  // ─────────────────────────────────────────────────────────────
  Widget _buildBookingConfig(BuildContext context) {
    final isMobile = BP.isMobile(context);
    return Column(
      children: [
        _switchRow(
          icon: Icons.flash_on_rounded,
          iconBg: const Color(0xFFFFF8E1),
          iconColor: FBColors.warning,
          title: 'Enable Instant Booking',
          subtitle: 'Tenants can confirm bookings immediately without waiting.',
          value: _instantBooking,
          onChanged: (v) => setState(() {
            _instantBooking = v;
            if (v) _requireAdminApproval = false;
          }),
        ),
        _fbDivider(),
        _switchRow(
          icon: Icons.admin_panel_settings_outlined,
          iconBg: const Color(0xFFF3E8FF),
          iconColor: FBColors.purple,
          title: 'Require Admin Approval',
          subtitle: 'All booking requests must be reviewed before confirmation.',
          value: _requireAdminApproval,
          onChanged: (v) => setState(() {
            _requireAdminApproval = v;
            if (v) _instantBooking = false;
          }),
        ),
        _fbDivider(),
        // Cancellation Policy — stacks on mobile
        isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3E0),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(Icons.cancel_outlined, color: Color(0xFFF57C00), size: 18),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Cancellation Policy',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: FBColors.textMain)),
                            Text('Set the free cancellation window for tenants.',
                                style: TextStyle(fontSize: 12, color: FBColors.textSub)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: _fbDropdown(
                      value: _cancellationPolicy,
                      items: _cancellationOptions,
                      onChanged: (v) => setState(() => _cancellationPolicy = v!),
                      fullWidth: true,
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.cancel_outlined, color: Color(0xFFF57C00), size: 18),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Cancellation Policy',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: FBColors.textMain)),
                        Text('Set the free cancellation window for tenants.',
                            style: TextStyle(fontSize: 13, color: FBColors.textSub)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  _fbDropdown(
                    value: _cancellationPolicy,
                    items: _cancellationOptions,
                    onChanged: (v) => setState(() => _cancellationPolicy = v!),
                  ),
                ],
              ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  //  NOTIFICATIONS
  // ─────────────────────────────────────────────────────────────
  Widget _buildNotifications(BuildContext context) {
    return Column(
      children: [
        _switchRow(
          icon: Icons.email_outlined,
          iconBg: FBColors.primaryLight,
          iconColor: FBColors.primary,
          title: 'Email Notifications',
          subtitle: 'Receive booking, cancellation, and system alerts via email.',
          value: _emailNotifs,
          onChanged: (v) => setState(() => _emailNotifs = v),
        ),
        _fbDivider(),
        _switchRow(
          icon: Icons.notifications_active_outlined,
          iconBg: const Color(0xFFE6F9F0),
          iconColor: FBColors.success,
          title: 'In-App Notifications',
          subtitle: 'Show real-time alerts within the admin dashboard.',
          value: _inAppNotifs,
          onChanged: (v) => setState(() => _inAppNotifs = v),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  //  SECURITY
  // ─────────────────────────────────────────────────────────────
  Widget _buildSecurity(BuildContext context) {
    final isMobile = BP.isMobile(context);
    return Column(
      children: [
        // Change password
        isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: FBColors.primaryLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(Icons.lock_outline_rounded, color: FBColors.primary, size: 18),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Change Password',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: FBColors.textMain)),
                            Text('Update your admin account password securely.',
                                style: TextStyle(fontSize: 12, color: FBColors.textSub)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _showChangePasswordDialog,
                      icon: const Icon(Icons.edit_outlined, size: 15),
                      label: const Text('Change Password',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: FBColors.primary,
                        side: const BorderSide(color: FBColors.primary, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: FBColors.primaryLight,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.lock_outline_rounded, color: FBColors.primary, size: 18),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Change Password',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: FBColors.textMain)),
                        Text('Update your admin account password securely.',
                            style: TextStyle(fontSize: 13, color: FBColors.textSub)),
                      ],
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: _showChangePasswordDialog,
                    icon: const Icon(Icons.edit_outlined, size: 15),
                    label: const Text('Change',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: FBColors.primary,
                      side: const BorderSide(color: FBColors.primary, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
                    ),
                  ),
                ],
              ),
        _fbDivider(),
        _switchRow(
          icon: Icons.verified_user_outlined,
          iconBg: const Color(0xFFE6F9F0),
          iconColor: FBColors.success,
          title: 'Two-Factor Authentication',
          subtitle: 'Add an extra layer of security to your admin account.',
          value: _twoFactor,
          onChanged: (v) => setState(() => _twoFactor = v),
        ),
        _fbDivider(),
        // Session Timeout
        isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3E8FF),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(Icons.timer_outlined, color: FBColors.purple, size: 18),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Session Timeout',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: FBColors.textMain)),
                            Text('Auto-logout after a period of inactivity.',
                                style: TextStyle(fontSize: 12, color: FBColors.textSub)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: _fbDropdown(
                      value: _sessionTimeout,
                      items: _sessionOptions,
                      onChanged: (v) => setState(() => _sessionTimeout = v!),
                      fullWidth: true,
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E8FF),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.timer_outlined, color: FBColors.purple, size: 18),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Session Timeout',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: FBColors.textMain)),
                        Text('Auto-logout after a period of inactivity.',
                            style: TextStyle(fontSize: 13, color: FBColors.textSub)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  _fbDropdown(
                    value: _sessionTimeout,
                    items: _sessionOptions,
                    onChanged: (v) => setState(() => _sessionTimeout = v!),
                  ),
                ],
              ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  //  ACTION BUTTONS
  // ─────────────────────────────────────────────────────────────
  Widget _buildActions(BuildContext context) {
    final isMobile = BP.isMobile(context);

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton.icon(
            onPressed: _isSaving ? null : _saveChanges,
            icon: _isSaving
                ? const SizedBox(
                    width: 16, height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.save_rounded, size: 18),
            label: Text(
              _isSaving ? 'Saving...' : 'Save Changes',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: FBColors.primary,
              disabledBackgroundColor: const Color(0xFF8BB8F8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () {
              _formKey.currentState?.reset();
              setState(() {});
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: FBColors.textSub,
              side: const BorderSide(color: FBColors.divider, width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Discard Changes',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: () {
            _formKey.currentState?.reset();
            setState(() {});
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: FBColors.textSub,
            side: const BorderSide(color: FBColors.divider, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
          ),
          child: const Text('Discard Changes',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(width: 14),
        FilledButton.icon(
          onPressed: _isSaving ? null : _saveChanges,
          icon: _isSaving
              ? const SizedBox(
                  width: 16, height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Icon(Icons.save_rounded, size: 18),
          label: Text(
            _isSaving ? 'Saving...' : 'Save Changes',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          style: FilledButton.styleFrom(
            backgroundColor: FBColors.primary,
            disabledBackgroundColor: const Color(0xFF8BB8F8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  //  HELPERS
  // ─────────────────────────────────────────────────────────────
  Widget _field({
    required String label,
    required TextEditingController ctrl,
    String? hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600, color: FBColors.textMain)),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(fontSize: 14, color: FBColors.textMain),
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }

  Widget _switchRow({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600, color: FBColors.textMain)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(fontSize: 13, color: FBColors.textSub)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: FBColors.primary,
            activeTrackColor: FBColors.primaryLight,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: FBColors.divider,
          ),
        ],
      ),
    );
  }

  Widget _fbDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool fullWidth = false,
  }) {
    final inner = DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        isExpanded: fullWidth,
        icon: const Icon(Icons.keyboard_arrow_down_rounded,
            color: FBColors.textSub, size: 20),
        style: const TextStyle(
            fontSize: 13, color: FBColors.textMain, fontWeight: FontWeight.w500),
        dropdownColor: FBColors.surface,
        borderRadius: BorderRadius.circular(4),
        items: items
            .map((o) => DropdownMenuItem(value: o, child: Text(o)))
            .toList(),
        onChanged: onChanged,
      ),
    );

    return Container(
      width: fullWidth ? double.infinity : 190,
      decoration: BoxDecoration(
        color: FBColors.inputFill,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: FBColors.divider),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: inner,
    );
  }

  Widget _fbDivider() => const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Divider(color: FBColors.divider, height: 1),
      );
}