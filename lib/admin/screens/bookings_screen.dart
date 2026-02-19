import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────
//  BREAKPOINTS
// ─────────────────────────────────────────────────────────────────

class _BP {
  static const double mobile = 600;
  static const double tablet = 900;

  static bool isMobile(BuildContext ctx) =>
      MediaQuery.of(ctx).size.width < mobile;
  static bool isTablet(BuildContext ctx) =>
      MediaQuery.of(ctx).size.width >= mobile &&
      MediaQuery.of(ctx).size.width < tablet;
  static bool isDesktop(BuildContext ctx) =>
      MediaQuery.of(ctx).size.width >= tablet;
}

// ─────────────────────────────────────────────────────────────────
//  DATA MODELS
// ─────────────────────────────────────────────────────────────────

enum BookingStatus { pending, approved, rejected, completed }

enum PaymentStatus { paid, unpaid, partial, refunded }

class Booking {
  final String id;
  final String tenantName;
  final String tenantAvatar;
  final String propertyName;
  final DateTime checkIn;
  final int durationDays;
  PaymentStatus paymentStatus;
  BookingStatus bookingStatus;

  Booking({
    required this.id,
    required this.tenantName,
    required this.tenantAvatar,
    required this.propertyName,
    required this.checkIn,
    required this.durationDays,
    required this.paymentStatus,
    required this.bookingStatus,
  });
}

// ─────────────────────────────────────────────────────────────────
//  COLOR PALETTE
// ─────────────────────────────────────────────────────────────────

class _C {
  static const bg = Color(0xFFF0F2F5);
  static const card = Color(0xFFFFFFFF);
  static const divider = Color(0xFFE4E6EB);

  static const blue = Color(0xFF1877F2);
  static const blueSoft = Color(0xFFE7F0FD);

  static const textPrimary = Color(0xFF1C1E21);
  static const textSecondary = Color(0xFF65676B);
  static const textMuted = Color(0xFF8A8D91);

  static const pendingBg = Color(0xFFFFF4E0);
  static const pendingFg = Color(0xFFB85C00);
  static const approvedBg = Color(0xFFE6F4EA);
  static const approvedFg = Color(0xFF1E7E34);
  static const rejectedBg = Color(0xFFFFEBEB);
  static const rejectedFg = Color(0xFFCC0000);
  static const completedBg = Color(0xFFE7F0FD);
  static const completedFg = Color(0xFF1877F2);

  static const paidBg = Color(0xFFE6F4EA);
  static const paidFg = Color(0xFF1E7E34);
  static const unpaidBg = Color(0xFFFFEBEB);
  static const unpaidFg = Color(0xFFCC0000);
  static const partialBg = Color(0xFFFFF4E0);
  static const partialFg = Color(0xFFB85C00);
  static const refundedBg = Color(0xFFF0F2F5);
  static const refundedFg = Color(0xFF65676B);

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2)),
        BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 2,
            offset: const Offset(0, 1)),
      ];
}

// ─────────────────────────────────────────────────────────────────
//  MAIN SCREEN
// ─────────────────────────────────────────────────────────────────

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  BookingStatus? _selectedStatus;

  final List<Booking> _bookings = [
    Booking(
      id: 'BK-001',
      tenantName: 'Marcus Rivera',
      tenantAvatar: 'MR',
      propertyName: 'Sunset Villa, Unit 4B',
      checkIn: DateTime(2025, 3, 15),
      durationDays: 30,
      paymentStatus: PaymentStatus.unpaid,
      bookingStatus: BookingStatus.pending,
    ),
    Booking(
      id: 'BK-002',
      tenantName: 'Aisha Okonkwo',
      tenantAvatar: 'AO',
      propertyName: 'Greenleaf Apt, Studio 2',
      checkIn: DateTime(2025, 3, 20),
      durationDays: 14,
      paymentStatus: PaymentStatus.paid,
      bookingStatus: BookingStatus.pending,
    ),
    Booking(
      id: 'BK-003',
      tenantName: 'James Holloway',
      tenantAvatar: 'JH',
      propertyName: 'The Pinnacle, Suite 12',
      checkIn: DateTime(2025, 2, 28),
      durationDays: 60,
      paymentStatus: PaymentStatus.paid,
      bookingStatus: BookingStatus.approved,
    ),
    Booking(
      id: 'BK-004',
      tenantName: 'Sofia Delgado',
      tenantAvatar: 'SD',
      propertyName: 'Harbor Loft, Unit 7',
      checkIn: DateTime(2025, 1, 10),
      durationDays: 90,
      paymentStatus: PaymentStatus.partial,
      bookingStatus: BookingStatus.approved,
    ),
    Booking(
      id: 'BK-005',
      tenantName: 'Ethan Brooks',
      tenantAvatar: 'EB',
      propertyName: 'Cedarwood Condo 3A',
      checkIn: DateTime(2025, 2, 1),
      durationDays: 7,
      paymentStatus: PaymentStatus.refunded,
      bookingStatus: BookingStatus.rejected,
    ),
    Booking(
      id: 'BK-006',
      tenantName: 'Nina Patel',
      tenantAvatar: 'NP',
      propertyName: 'Skybridge Flat, 18F',
      checkIn: DateTime(2025, 1, 5),
      durationDays: 45,
      paymentStatus: PaymentStatus.paid,
      bookingStatus: BookingStatus.completed,
    ),
    Booking(
      id: 'BK-007',
      tenantName: 'Liam Chen',
      tenantAvatar: 'LC',
      propertyName: 'Sunset Villa, Unit 2A',
      checkIn: DateTime(2025, 3, 22),
      durationDays: 21,
      paymentStatus: PaymentStatus.unpaid,
      bookingStatus: BookingStatus.pending,
    ),
    Booking(
      id: 'BK-008',
      tenantName: 'Priya Sharma',
      tenantAvatar: 'PS',
      propertyName: 'Elm Street Residences, 6B',
      checkIn: DateTime(2025, 4, 1),
      durationDays: 30,
      paymentStatus: PaymentStatus.partial,
      bookingStatus: BookingStatus.pending,
    ),
  ];

  List<Booking> get _filtered => _bookings.where((b) {
        final matchStatus =
            _selectedStatus == null || b.bookingStatus == _selectedStatus;
        final q = _searchQuery.toLowerCase();
        final matchSearch = q.isEmpty ||
            b.tenantName.toLowerCase().contains(q) ||
            b.propertyName.toLowerCase().contains(q);
        return matchStatus && matchSearch;
      }).toList();

  int _count(BookingStatus? s) => s == null
      ? _bookings.length
      : _bookings.where((b) => b.bookingStatus == s).length;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(
        () => setState(() => _searchQuery = _searchController.text));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _setFilter(BookingStatus? s) => setState(() => _selectedStatus = s);

  void _approve(Booking b) {
    setState(() => b.bookingStatus = BookingStatus.approved);
    _snack('Booking ${b.id} approved.', _C.approvedFg);
  }

  void _reject(Booking b) {
    setState(() => b.bookingStatus = BookingStatus.rejected);
    _snack('Booking ${b.id} rejected.', _C.rejectedFg);
  }

  void _snack(String msg, Color color) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 13)),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    ));
  }

  void _viewDetails(Booking b) => showDialog(
        context: context,
        builder: (_) => _DetailsDialog(booking: b),
      );

  @override
  Widget build(BuildContext context) {
    final isMobile = _BP.isMobile(context);
    final list = _filtered;

    return Scaffold(
      backgroundColor: _C.bg,
      body: Column(
        children: [
          _buildTopBar(isMobile),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                isMobile ? 12 : 20,
                16,
                isMobile ? 12 : 20,
                24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryRow(isMobile),
                  const SizedBox(height: 16),
                  isMobile
                      ? _buildCardList(list)
                      : _buildTableCard(list, context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Top Bar ────────────────────────────────────────────────────
  Widget _buildTopBar(bool isMobile) {
    return Container(
      padding: EdgeInsets.fromLTRB(isMobile ? 12 : 20, 16, isMobile ? 12 : 20, 0),
      decoration: const BoxDecoration(
        color: _C.card,
        border: Border(bottom: BorderSide(color: _C.divider, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _C.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.calendar_month_rounded,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bookings Management',
                      style: TextStyle(
                        color: _C.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      'Review and process all booking requests',
                      style:
                          TextStyle(color: _C.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _TabPill(
                  label: 'All',
                  count: _count(null),
                  isActive: _selectedStatus == null,
                  onTap: () => _setFilter(null),
                ),
                _TabPill(
                  label: 'Pending',
                  count: _count(BookingStatus.pending),
                  isActive: _selectedStatus == BookingStatus.pending,
                  onTap: () => _setFilter(BookingStatus.pending),
                ),
                _TabPill(
                  label: 'Approved',
                  count: _count(BookingStatus.approved),
                  isActive: _selectedStatus == BookingStatus.approved,
                  onTap: () => _setFilter(BookingStatus.approved),
                ),
                _TabPill(
                  label: 'Rejected',
                  count: _count(BookingStatus.rejected),
                  isActive: _selectedStatus == BookingStatus.rejected,
                  onTap: () => _setFilter(BookingStatus.rejected),
                ),
                _TabPill(
                  label: 'Completed',
                  count: _count(BookingStatus.completed),
                  isActive: _selectedStatus == BookingStatus.completed,
                  onTap: () => _setFilter(BookingStatus.completed),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Summary stats ──────────────────────────────────────────────
  Widget _buildSummaryRow(bool isMobile) {
    final stats = [
      (Icons.pending_actions_rounded, 'Pending', _count(BookingStatus.pending),
          _C.pendingFg, _C.pendingBg),
      (Icons.check_circle_outline_rounded, 'Approved',
          _count(BookingStatus.approved), _C.approvedFg, _C.approvedBg),
      (Icons.cancel_outlined, 'Rejected', _count(BookingStatus.rejected),
          _C.rejectedFg, _C.rejectedBg),
      (Icons.task_alt_rounded, 'Completed', _count(BookingStatus.completed),
          _C.completedFg, _C.completedBg),
    ];

    if (isMobile) {
      // 2×2 grid on mobile
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                    icon: stats[0].$1,
                    label: stats[0].$2,
                    count: stats[0].$3,
                    fg: stats[0].$4,
                    bg: stats[0].$5),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SummaryCard(
                    icon: stats[1].$1,
                    label: stats[1].$2,
                    count: stats[1].$3,
                    fg: stats[1].$4,
                    bg: stats[1].$5),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                    icon: stats[2].$1,
                    label: stats[2].$2,
                    count: stats[2].$3,
                    fg: stats[2].$4,
                    bg: stats[2].$5),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SummaryCard(
                    icon: stats[3].$1,
                    label: stats[3].$2,
                    count: stats[3].$3,
                    fg: stats[3].$4,
                    bg: stats[3].$5),
              ),
            ],
          ),
        ],
      );
    }

    // Single row for tablet / desktop
    return Row(
      children: stats.asMap().entries.map((e) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: e.key == 0 ? 0 : 10),
            child: _SummaryCard(
              icon: e.value.$1,
              label: e.value.$2,
              count: e.value.$3,
              fg: e.value.$4,
              bg: e.value.$5,
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Mobile: card list ──────────────────────────────────────────
  Widget _buildCardList(List<Booking> list) {
    if (list.isEmpty) return _emptyState();
    return Column(
      children: [
        // Search bar
        _buildSearchField(),
        const SizedBox(height: 12),
        ...list.map((b) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _BookingCard(
                booking: b,
                onApprove: () => _approve(b),
                onReject: () => _reject(b),
                onView: () => _viewDetails(b),
              ),
            )),
      ],
    );
  }

  // ── Desktop/tablet: table card ─────────────────────────────────
  Widget _buildTableCard(List<Booking> list, BuildContext context) {
    final isTablet = _BP.isTablet(context);

    return Container(
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: _C.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Toolbar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: [
                const Text(
                  'All Bookings',
                  style: TextStyle(
                      color: _C.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _C.blueSoft,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('${list.length}',
                      style: const TextStyle(
                          color: _C.blue,
                          fontSize: 11,
                          fontWeight: FontWeight.w700)),
                ),
                const Spacer(),
                SizedBox(
                  width: isTablet ? 200 : 260,
                  height: 38,
                  child: _buildSearchField(),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: _C.divider),

          // Column headers — hide some on tablet
          Container(
            color: _C.bg,
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                const Expanded(flex: 3, child: _ColLabel('TENANT')),
                if (!isTablet)
                  const Expanded(flex: 3, child: _ColLabel('PROPERTY')),
                const Expanded(flex: 2, child: _ColLabel('CHECK-IN')),
                if (!isTablet)
                  const Expanded(flex: 2, child: _ColLabel('DURATION')),
                const Expanded(flex: 2, child: _ColLabel('PAYMENT')),
                const Expanded(flex: 2, child: _ColLabel('STATUS')),
                const Expanded(flex: 3, child: _ColLabel('ACTIONS')),
              ],
            ),
          ),

          const Divider(height: 1, color: _C.divider),

          if (list.isEmpty)
            _emptyState()
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: _C.divider),
              itemBuilder: (_, i) => _BookingRow(
                booking: list[i],
                showProperty: !isTablet,
                showDuration: !isTablet,
                onApprove: () => _approve(list[i]),
                onReject: () => _reject(list[i]),
                onView: () => _viewDetails(list[i]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      style: const TextStyle(color: _C.textPrimary, fontSize: 13),
      decoration: InputDecoration(
        hintText: 'Search tenant or property…',
        hintStyle: const TextStyle(color: _C.textMuted, fontSize: 13),
        prefixIcon: const Icon(Icons.search_rounded,
            color: _C.textMuted, size: 17),
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close_rounded,
                    size: 15, color: _C.textMuted),
                onPressed: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                },
              )
            : null,
        filled: true,
        fillColor: _C.bg,
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _C.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _C.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _C.blue, width: 1.5),
        ),
      ),
    );
  }

  Widget _emptyState() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 52),
        child: Center(
          child: Column(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                    color: _C.bg,
                    borderRadius: BorderRadius.circular(27)),
                child: const Icon(Icons.inbox_rounded,
                    color: _C.textMuted, size: 26),
              ),
              const SizedBox(height: 12),
              const Text('No bookings found',
                  style: TextStyle(
                      color: _C.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              const Text('Try adjusting your filter or search query.',
                  style: TextStyle(color: _C.textMuted, fontSize: 12)),
            ],
          ),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────
//  MOBILE BOOKING CARD
// ─────────────────────────────────────────────────────────────────

class _BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onView;

  const _BookingCard({
    required this.booking,
    required this.onApprove,
    required this.onReject,
    required this.onView,
  });

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final b = booking;
    final canApprove = b.bookingStatus == BookingStatus.pending;
    final canReject = b.bookingStatus == BookingStatus.pending ||
        b.bookingStatus == BookingStatus.approved;

    return Container(
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: _C.cardShadow,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              _Avatar(initials: b.tenantAvatar),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(b.tenantName,
                        style: const TextStyle(
                            color: _C.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700)),
                    Text(b.id,
                        style: const TextStyle(
                            color: _C.textMuted, fontSize: 11)),
                  ],
                ),
              ),
              _BookingBadge(status: b.bookingStatus),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: _C.divider),
          const SizedBox(height: 12),

          // Property
          _CardRow(
            icon: Icons.home_outlined,
            label: 'Property',
            value: b.propertyName,
          ),
          const SizedBox(height: 8),
          // Check-in & duration
          Row(
            children: [
              Expanded(
                child: _CardRow(
                  icon: Icons.login_rounded,
                  label: 'Check-in',
                  value: _fmt(b.checkIn),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CardRow(
                  icon: Icons.schedule_rounded,
                  label: 'Duration',
                  value: '${b.durationDays} days',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _CardRow(
            icon: Icons.payments_outlined,
            label: 'Payment',
            valueWidget: _PaymentBadge(status: b.paymentStatus),
          ),

          const SizedBox(height: 14),

          // Action buttons
          Row(
            children: [
              if (canApprove) ...[
                Expanded(
                  child: _FullWidthBtn(
                    label: 'Approve',
                    icon: Icons.check_rounded,
                    color: _C.approvedFg,
                    bgColor: _C.approvedBg,
                    onTap: onApprove,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              if (canReject) ...[
                Expanded(
                  child: _FullWidthBtn(
                    label: 'Reject',
                    icon: Icons.close_rounded,
                    color: _C.rejectedFg,
                    bgColor: _C.rejectedBg,
                    onTap: onReject,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: _FullWidthBtn(
                  label: 'Details',
                  icon: Icons.open_in_new_rounded,
                  color: _C.blue,
                  bgColor: _C.blueSoft,
                  onTap: onView,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final Widget? valueWidget;

  const _CardRow({
    required this.icon,
    required this.label,
    this.value,
    this.valueWidget,
  });

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: _C.textMuted),
          const SizedBox(width: 6),
          Text('$label: ',
              style: const TextStyle(color: _C.textMuted, fontSize: 12)),
          Expanded(
            child: valueWidget ??
                Text(
                  value ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: _C.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
          ),
        ],
      );
}

class _FullWidthBtn extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const _FullWidthBtn({
    required this.label,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  @override
  State<_FullWidthBtn> createState() => _FullWidthBtnState();
}

class _FullWidthBtnState extends State<_FullWidthBtn> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding:
              const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: _pressed ? widget.color : widget.bgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon,
                  size: 13,
                  color: _pressed ? Colors.white : widget.color),
              const SizedBox(width: 5),
              Text(widget.label,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _pressed ? Colors.white : widget.color)),
            ],
          ),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────
//  TABLE ROW WIDGET (tablet / desktop)
// ─────────────────────────────────────────────────────────────────

class _BookingRow extends StatefulWidget {
  final Booking booking;
  final bool showProperty;
  final bool showDuration;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onView;

  const _BookingRow({
    required this.booking,
    this.showProperty = true,
    this.showDuration = true,
    required this.onApprove,
    required this.onReject,
    required this.onView,
  });

  @override
  State<_BookingRow> createState() => _BookingRowState();
}

class _BookingRowState extends State<_BookingRow> {
  bool _hovered = false;

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final b = widget.booking;
    final canApprove = b.bookingStatus == BookingStatus.pending;
    final canReject = b.bookingStatus == BookingStatus.pending ||
        b.bookingStatus == BookingStatus.approved;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        color: _hovered ? const Color(0xFFF7F8FA) : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            // Tenant
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  _Avatar(initials: b.tenantAvatar),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(b.tenantName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: _C.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                        Text(b.id,
                            style: const TextStyle(
                                color: _C.textMuted, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            if (widget.showProperty)
              Expanded(
                flex: 3,
                child: Text(b.propertyName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: _C.textSecondary, fontSize: 13)),
              ),

            Expanded(
              flex: 2,
              child: Text(_fmt(b.checkIn),
                  style: const TextStyle(
                      color: _C.textSecondary, fontSize: 13)),
            ),

            if (widget.showDuration)
              Expanded(
                flex: 2,
                child: Text('${b.durationDays} days',
                    style: const TextStyle(
                        color: _C.textSecondary, fontSize: 13)),
              ),

            Expanded(
                flex: 2, child: _PaymentBadge(status: b.paymentStatus)),
            Expanded(
                flex: 2, child: _BookingBadge(status: b.bookingStatus)),

            Expanded(
              flex: 3,
              child: Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  if (canApprove)
                    _ActionBtn(
                      label: 'Approve',
                      icon: Icons.check_rounded,
                      color: _C.approvedFg,
                      bgColor: _C.approvedBg,
                      onTap: widget.onApprove,
                    ),
                  if (canReject)
                    _ActionBtn(
                      label: 'Reject',
                      icon: Icons.close_rounded,
                      color: _C.rejectedFg,
                      bgColor: _C.rejectedBg,
                      onTap: widget.onReject,
                    ),
                  _ActionBtn(
                    label: 'Details',
                    icon: Icons.open_in_new_rounded,
                    color: _C.blue,
                    bgColor: _C.blueSoft,
                    onTap: widget.onView,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
//  SMALL REUSABLE WIDGETS
// ─────────────────────────────────────────────────────────────────

class _ColLabel extends StatelessWidget {
  final String text;
  const _ColLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          color: _C.textMuted,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6));
}

class _Avatar extends StatelessWidget {
  final String initials;
  const _Avatar({required this.initials});
  @override
  Widget build(BuildContext context) => Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: _C.blueSoft,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(initials,
            style: const TextStyle(
                color: _C.blue,
                fontSize: 11,
                fontWeight: FontWeight.w700)),
      );
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color fg;
  final Color bg;
  const _SummaryCard(
      {required this.icon,
      required this.label,
      required this.count,
      required this.fg,
      required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: _C.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
                color: bg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: fg, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$count',
                    style: TextStyle(
                        color: fg,
                        fontSize: 20,
                        fontWeight: FontWeight.w800)),
                Text(label,
                    style: const TextStyle(
                        color: _C.textSecondary, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabPill extends StatelessWidget {
  final String label;
  final int count;
  final bool isActive;
  final VoidCallback onTap;
  const _TabPill(
      {required this.label,
      required this.count,
      required this.isActive,
      required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          margin: const EdgeInsets.only(right: 2),
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? _C.blue : Colors.transparent,
                width: 2.5,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isActive ? _C.blue : _C.textSecondary,
                  fontSize: 13,
                  fontWeight:
                      isActive ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              const SizedBox(width: 5),
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(
                    horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isActive ? _C.blue : _C.divider,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    color: isActive ? Colors.white : _C.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

// ── Status badges ────────────────────────────────────────────────

class _BookingBadge extends StatelessWidget {
  final BookingStatus status;
  const _BookingBadge({required this.status});
  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (status) {
      BookingStatus.pending => ('Pending', _C.pendingBg, _C.pendingFg),
      BookingStatus.approved => ('Approved', _C.approvedBg, _C.approvedFg),
      BookingStatus.rejected => ('Rejected', _C.rejectedBg, _C.rejectedFg),
      BookingStatus.completed =>
        ('Completed', _C.completedBg, _C.completedFg),
    };
    return _Badge(label: label, bg: bg, fg: fg);
  }
}

class _PaymentBadge extends StatelessWidget {
  final PaymentStatus status;
  const _PaymentBadge({required this.status});
  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (status) {
      PaymentStatus.paid => ('Paid', _C.paidBg, _C.paidFg),
      PaymentStatus.unpaid => ('Unpaid', _C.unpaidBg, _C.unpaidFg),
      PaymentStatus.partial => ('Partial', _C.partialBg, _C.partialFg),
      PaymentStatus.refunded =>
        ('Refunded', _C.refundedBg, _C.refundedFg),
    };
    return _Badge(label: label, bg: bg, fg: fg);
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  const _Badge({required this.label, required this.bg, required this.fg});
  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        decoration:
            BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
        child: Text(label,
            style: TextStyle(
                color: fg, fontSize: 11, fontWeight: FontWeight.w600)),
      );
}

// ── Action button (table rows) ───────────────────────────────────

class _ActionBtn extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;
  const _ActionBtn(
      {required this.label,
      required this.icon,
      required this.color,
      required this.bgColor,
      required this.onTap});
  @override
  State<_ActionBtn> createState() => _ActionBtnState();
}

class _ActionBtnState extends State<_ActionBtn> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 130),
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: _hovered ? widget.color : widget.bgColor,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon,
                    size: 13,
                    color: _hovered ? Colors.white : widget.color),
                const SizedBox(width: 4),
                Text(widget.label,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _hovered ? Colors.white : widget.color)),
              ],
            ),
          ),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────
//  DETAILS DIALOG
// ─────────────────────────────────────────────────────────────────

class _DetailsDialog extends StatelessWidget {
  final Booking booking;
  const _DetailsDialog({required this.booking});

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final isMobile = _BP.isMobile(context);
    return Dialog(
      backgroundColor: _C.card,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 60,
        vertical: isMobile ? 24 : 40,
      ),
      elevation: 6,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 20 : 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _Avatar(initials: booking.tenantAvatar),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(booking.tenantName,
                            style: const TextStyle(
                                color: _C.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w700)),
                        Text(booking.id,
                            style: const TextStyle(
                                color: _C.textMuted, fontSize: 12)),
                      ],
                    ),
                  ),
                  _BookingBadge(status: booking.bookingStatus),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(color: _C.divider, height: 1),
              const SizedBox(height: 20),
              _DetailRow('Property', booking.propertyName,
                  icon: Icons.home_outlined),
              _DetailRow('Check-in', _fmt(booking.checkIn),
                  icon: Icons.login_rounded),
              _DetailRow(
                  'Check-out',
                  _fmt(booking.checkIn
                      .add(Duration(days: booking.durationDays))),
                  icon: Icons.logout_rounded),
              _DetailRow('Duration', '${booking.durationDays} days',
                  icon: Icons.schedule_rounded),
              _DetailRow('Payment', booking.paymentStatus.name.capitalize(),
                  icon: Icons.payments_outlined),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _C.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 10),
                    elevation: 0,
                  ),
                  child: const Text('Close',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  const _DetailRow(this.label, this.value, {this.icon});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          children: [
            if (icon != null) ...[
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    color: _C.blueSoft,
                    borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: _C.blue, size: 15),
              ),
              const SizedBox(width: 10),
            ],
            SizedBox(
              width: 80,
              child: Text(label,
                  style: const TextStyle(
                      color: _C.textSecondary, fontSize: 13)),
            ),
            Expanded(
              child: Text(value,
                  style: const TextStyle(
                      color: _C.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      );
}

// ─────────────────────────────────────────────────────────────────
//  STRING EXTENSION
// ─────────────────────────────────────────────────────────────────

extension StringEx on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}

// ─────────────────────────────────────────────────────────────────
//  ENTRY POINT
// ─────────────────────────────────────────────────────────────────

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(body: BookingsScreen()),
  ));
}