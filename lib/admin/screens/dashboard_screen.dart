import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';

void main() {
  runApp(const BoardingHouseAdminApp());
}

// ─────────────────────────────────────────────
//  RESPONSIVE BREAKPOINTS
// ─────────────────────────────────────────────
class Breakpoints {
  static const double mobile  = 480;
  static const double tablet  = 768;
  static const double desktop = 1024;

  static bool isMobile(BuildContext ctx)  => MediaQuery.of(ctx).size.width <  tablet;
  static bool isTablet(BuildContext ctx)  => MediaQuery.of(ctx).size.width >= tablet && MediaQuery.of(ctx).size.width < desktop;
  static bool isDesktop(BuildContext ctx) => MediaQuery.of(ctx).size.width >= desktop;

  /// Fluid value: returns different values depending on screen width.
  static T fluid<T>(BuildContext ctx, {required T mobile, required T tablet, required T desktop}) {
    final w = MediaQuery.of(ctx).size.width;
    if (w < Breakpoints.tablet)  return mobile;
    if (w < Breakpoints.desktop) return tablet;
    return desktop;
  }
}

// ─────────────────────────────────────────────
//  CUSTOM HORIZONTAL SCROLLBAR
// ─────────────────────────────────────────────
class CustomHorizontalScrollbar extends StatefulWidget {
  final Widget child;
  final ScrollController? controller;

  const CustomHorizontalScrollbar({
    super.key,
    required this.child,
    this.controller,
  });

  @override
  State<CustomHorizontalScrollbar> createState() =>
      _CustomHorizontalScrollbarState();
}

class _CustomHorizontalScrollbarState
    extends State<CustomHorizontalScrollbar> {
  late ScrollController _scrollController;
  bool _showScrollbar = false;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.controller ?? ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    if (widget.controller == null) _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_showScrollbar) setState(() => _showScrollbar = true);
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showScrollbar = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: widget.child,
        ),
        if (_showScrollbar)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 8,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: AppColors.border.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final pos = _scrollController.position;
                  if (!pos.haveDimensions) return const SizedBox();
                  final scrollExtent = pos.maxScrollExtent;
                  if (scrollExtent <= 0) return const SizedBox();
                  final viewportExtent = pos.viewportDimension;
                  final scrollOffset  = pos.pixels;
                  final thumbWidth = math.max(
                    40.0,
                    (viewportExtent / (scrollExtent + viewportExtent)) *
                        viewportExtent,
                  );
                  final thumbPosition =
                      (scrollOffset / scrollExtent) * (viewportExtent - thumbWidth);
                  return Stack(
                    children: [
                      Positioned(
                        left: thumbPosition,
                        top: 0,
                        bottom: 0,
                        width: thumbWidth,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.textSecond.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  APP
// ─────────────────────────────────────────────
class BoardingHouseAdminApp extends StatelessWidget {
  const BoardingHouseAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tagoloan BH Finder Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1877F2),
          brightness: Brightness.light,
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

// ─────────────────────────────────────────────
//  DESIGN TOKENS
// ─────────────────────────────────────────────
class AppColors {
  static const background     = Color(0xFFF0F2F5);
  static const surface        = Color(0xFFFFFFFF);
  static const surfaceAlt     = Color(0xFFF7F8FA);
  static const border         = Color(0xFFE4E6EB);

  static const textPrimary    = Color(0xFF1C1E21);
  static const textSecond     = Color(0xFF65676B);
  static const textMuted      = Color(0xFF8A8D91);

  static const accent         = Color(0xFF1877F2);
  static const accentHover    = Color(0xFF166FE5);
  static const accentLight    = Color(0xFFE7F0FE);

  static const teal           = Color(0xFF00A400);
  static const tealLight      = Color(0xFFE6F5E6);
  static const violet         = Color(0xFF7B68EE);
  static const violetLight    = Color(0xFFF0EFFE);
  static const amber          = Color(0xFFE67700);
  static const amberLight     = Color(0xFFFFF3E0);

  static const statusPaid        = Color(0xFF00A400);
  static const statusPaidBg      = Color(0xFFE6F5E6);
  static const statusPending     = Color(0xFFE67700);
  static const statusPendingBg   = Color(0xFFFFF3E0);
  static const statusFailed      = Color(0xFFFA3E3E);
  static const statusFailedBg    = Color(0xFFFFEBEB);
  static const statusConfirmed   = Color(0xFF1877F2);
  static const statusConfirmedBg = Color(0xFFE7F0FE);
  static const statusReview      = Color(0xFF7B68EE);
  static const statusReviewBg    = Color(0xFFF0EFFE);

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 12,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> accentShadow = [
    BoxShadow(
      color: accent.withOpacity(0.18),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];
}

// ─────────────────────────────────────────────
//  MODELS
// ─────────────────────────────────────────────
class StatCard {
  final String label, value;
  final double growth;
  final IconData icon;
  final Color color, colorLight;
  const StatCard({
    required this.label, required this.value, required this.growth,
    required this.icon,  required this.color,  required this.colorLight,
  });
}

class BookingRow {
  final String tenant, avatar, property, checkIn, payStatus, bookStatus;
  const BookingRow({
    required this.tenant,    required this.avatar,     required this.property,
    required this.checkIn,   required this.payStatus,  required this.bookStatus,
  });
}

class PropertyCard {
  final String name, address, price, addedDate, tagLabel;
  final double rating;
  final int reviews;
  final Color tagColor;
  const PropertyCard({
    required this.name,      required this.address,  required this.price,
    required this.rating,    required this.reviews,  required this.addedDate,
    required this.tagColor,  required this.tagLabel,
  });
}

// ─────────────────────────────────────────────
//  SAMPLE DATA
// ─────────────────────────────────────────────
final statCards = [
  const StatCard(label: 'Total Properties', value: '1,248', growth: 12.4,
      icon: Icons.apartment_rounded, color: AppColors.accent, colorLight: AppColors.accentLight),
  const StatCard(label: 'Total Bookings', value: '3,819', growth: 8.7,
      icon: Icons.book_online_rounded, color: AppColors.teal, colorLight: AppColors.tealLight),
  const StatCard(label: 'Active Tenants', value: '2,563', growth: -3.2,
      icon: Icons.people_alt_rounded, color: AppColors.violet, colorLight: AppColors.violetLight),
  const StatCard(label: 'Monthly Revenue', value: '₱ 842K', growth: 21.0,
      icon: Icons.payments_rounded, color: AppColors.amber, colorLight: AppColors.amberLight),
];

final recentBookings = [
  const BookingRow(tenant: 'Rhea Mae Labordo',   avatar: 'RL', property: 'Liwayway Boarding House',
      checkIn: 'Feb 20, 2026', payStatus: 'Paid',    bookStatus: 'Confirmed'),
  const BookingRow(tenant: 'Jomar Estrada',       avatar: 'JE', property: 'Tagoloan Grand BH',
      checkIn: 'Feb 22, 2026', payStatus: 'Pending', bookStatus: 'Under Review'),
  const BookingRow(tenant: 'Kristine Opolento',  avatar: 'KO', property: 'Poblacion Transient House',
      checkIn: 'Feb 25, 2026', payStatus: 'Paid',    bookStatus: 'Confirmed'),
  const BookingRow(tenant: 'Arnel Cabagay',       avatar: 'AC', property: 'Balacanas Rest House',
      checkIn: 'Mar 01, 2026', payStatus: 'Failed',  bookStatus: 'Cancelled'),
  const BookingRow(tenant: 'Lenie Dumapias',      avatar: 'LD', property: 'Mohon Student Lodging',
      checkIn: 'Mar 03, 2026', payStatus: 'Pending', bookStatus: 'Under Review'),
];

final recentProperties = [
  const PropertyCard(name: 'Liwayway Boarding House',  address: 'Poblacion, Tagoloan, Mis. Or.',
      price: '₱ 2,500 / mo', rating: 4.8, reviews: 34, addedDate: 'Added Feb 15',
      tagColor: AppColors.accent, tagLabel: 'Featured'),
  const PropertyCard(name: 'Tagoloan Grand BH',        address: 'Barangay Mohon, Tagoloan, Mis. Or.',
      price: '₱ 1,800 / mo', rating: 4.5, reviews: 21, addedDate: 'Added Feb 16',
      tagColor: AppColors.teal,   tagLabel: 'New'),
  const PropertyCard(name: 'Balacanas Rest House',     address: 'Barangay Balacanas, Tagoloan, Mis. Or.',
      price: '₱ 3,200 / mo', rating: 4.9, reviews: 57, addedDate: 'Added Feb 17',
      tagColor: AppColors.violet, tagLabel: 'Premium'),
  const PropertyCard(name: 'Mohon Student Lodging',   address: 'Barangay Mohon, Tagoloan, Mis. Or.',
      price: '₱ 1,500 / mo', rating: 4.2, reviews: 12, addedDate: 'Added Feb 17',
      tagColor: AppColors.amber,  tagLabel: 'Budget'),
];

final List<int> bookingTrend30 = [
  14, 22, 18, 30, 25, 19, 35, 28, 20, 32,
  40, 33, 27, 38, 45, 30, 22, 41, 36, 29,
  48, 52, 44, 38, 55, 60, 49, 42, 58, 63,
];
final List<int> bookingTrend7 = [38, 42, 29, 55, 60, 49, 63];

// ─────────────────────────────────────────────
//  DASHBOARD SCREEN
// ─────────────────────────────────────────────
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  bool _show7Days = true;
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500))
      ..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fluid horizontal padding
    final hPad = Breakpoints.fluid<double>(context,
      mobile: 12, tablet: 16, desktop: 20);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Stat cards ──
                _StatCardsRow(),
                const SizedBox(height: 20),

                // ── Main content ──
                _ResponsiveMainContent(
                  show7Days: _show7Days,
                  onToggle: (v) => setState(() => _show7Days = v),
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
//  STAT CARDS ROW — 2-col on mobile, 4-col on wide
// ─────────────────────────────────────────────
class _StatCardsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.isMobile(context);

    if (isMobile) {
      // 2×2 grid on small phones
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: Padding(padding: const EdgeInsets.only(right: 8), child: _StatCardTile(card: statCards[0]))),
              Expanded(child: _StatCardTile(card: statCards[1])),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: Padding(padding: const EdgeInsets.only(right: 8), child: _StatCardTile(card: statCards[2]))),
              Expanded(child: _StatCardTile(card: statCards[3])),
            ],
          ),
        ],
      );
    }

    // Single row on tablet+
    return Row(
      children: statCards.asMap().entries.map((e) {
        final isLast = e.key == statCards.length - 1;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 14),
            child: _StatCardTile(card: e.value),
          ),
        );
      }).toList(),
    );
  }
}

class _StatCardTile extends StatelessWidget {
  final StatCard card;
  const _StatCardTile({required this.card});

  @override
  Widget build(BuildContext context) {
    final isMobile  = Breakpoints.isMobile(context);
    final isPositive = card.growth >= 0;

    return Container(
      padding: EdgeInsets.all(isMobile ? 11 : 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: isMobile ? 30 : 36,
                height: isMobile ? 30 : 36,
                decoration: BoxDecoration(
                  color: card.colorLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(card.icon, color: card.color, size: isMobile ? 14 : 16),
              ),
              // Growth badge
              Container(
                constraints: const BoxConstraints(maxWidth: 68),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: isPositive
                      ? AppColors.statusPaidBg
                      : AppColors.statusFailedBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      size: 8,
                      color: isPositive
                          ? AppColors.statusPaid
                          : AppColors.statusFailed,
                    ),
                    const SizedBox(width: 2),
                    Flexible(
                      child: Text(
                        '${card.growth.abs()}%',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: isPositive
                              ? AppColors.statusPaid
                              : AppColors.statusFailed,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 8 : 10),
          Text(
            card.value,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: isMobile ? 17 : 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            card.label,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: isMobile ? 10 : 11,
              color: AppColors.textSecond,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: isMobile ? 8 : 10),
          Container(
            height: 2,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(1),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (card.growth.abs() / 25).clamp(0.1, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: card.color,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  RESPONSIVE MAIN CONTENT
// ─────────────────────────────────────────────
class _ResponsiveMainContent extends StatelessWidget {
  final bool show7Days;
  final ValueChanged<bool> onToggle;
  const _ResponsiveMainContent({required this.show7Days, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Breakpoints.isDesktop(context);
    final isTablet  = Breakpoints.isTablet(context);

    if (isDesktop) {
      return Column(
        children: [
          _SectionCard(
            title: 'Recent Bookings',
            icon: Icons.receipt_long_rounded,
            iconColor: AppColors.accent,
            action: _ViewAllButton(),
            child: _BookingsTable(),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: _SectionCard(
                  title: 'Booking Trend',
                  icon: Icons.show_chart_rounded,
                  iconColor: AppColors.teal,
                  action: _ChartToggle(show7Days: show7Days, onToggle: onToggle),
                  child: _BookingChart(show7Days: show7Days),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 4,
                child: _SectionCard(
                  title: 'Recently Added',
                  icon: Icons.apartment_rounded,
                  iconColor: AppColors.violet,
                  action: _ViewAllButton(),
                  child: _PropertiesList(),
                ),
              ),
            ],
          ),
        ],
      );
    }

    if (isTablet) {
      // Tablet: bookings table scrollable horizontally, chart + properties side by side
      return Column(
        children: [
          _SectionCard(
            title: 'Recent Bookings',
            icon: Icons.receipt_long_rounded,
            iconColor: AppColors.accent,
            action: _ViewAllButton(),
            child: _BookingsTable(),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: _SectionCard(
                  title: 'Booking Trend',
                  icon: Icons.show_chart_rounded,
                  iconColor: AppColors.teal,
                  action: _ChartToggle(show7Days: show7Days, onToggle: onToggle),
                  child: _BookingChart(show7Days: show7Days),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                flex: 2,
                child: _SectionCard(
                  title: 'Recently Added',
                  icon: Icons.apartment_rounded,
                  iconColor: AppColors.violet,
                  action: _ViewAllButton(),
                  child: _PropertiesList(),
                ),
              ),
            ],
          ),
        ],
      );
    }

    // Mobile: stacked, bookings as cards
    return Column(
      children: [
        _SectionCard(
          title: 'Booking Trend',
          icon: Icons.show_chart_rounded,
          iconColor: AppColors.teal,
          action: _ChartToggle(show7Days: show7Days, onToggle: onToggle),
          child: _BookingChart(show7Days: show7Days),
        ),
        const SizedBox(height: 16),
        _SectionCard(
          title: 'Recent Bookings',
          icon: Icons.receipt_long_rounded,
          iconColor: AppColors.accent,
          action: _ViewAllButton(),
          child: _BookingCardsMobile(),   // card-based on mobile
        ),
        const SizedBox(height: 16),
        _SectionCard(
          title: 'Recently Added',
          icon: Icons.apartment_rounded,
          iconColor: AppColors.violet,
          action: _ViewAllButton(),
          child: _PropertiesList(),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  SECTION CARD WRAPPER
// ─────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Widget? action;
  final Widget child;
  const _SectionCard({
    required this.title,    required this.icon,
    required this.iconColor, this.action,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.isMobile(context);
    final hPad = isMobile ? 14.0 : 18.0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(hPad, 14, 12, 0),
            child: Row(
              children: [
                Container(
                  width: isMobile ? 28 : 32,
                  height: isMobile ? 28 : 32,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: iconColor, size: isMobile ? 14 : 17),
                ),
                SizedBox(width: isMobile ? 8 : 10),
                Expanded(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isMobile ? 13.5 : 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                if (action != null) action!,
              ],
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: const Divider(height: 20, color: AppColors.border),
          ),
          child,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  VIEW ALL BUTTON
// ─────────────────────────────────────────────
Widget _ViewAllButton() {
  return TextButton(
    onPressed: () {},
    style: TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: AppColors.accentLight,
      foregroundColor: AppColors.accent,
    ),
    child: const Text(
      'See all',
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.accent,
      ),
    ),
  );
}

// ─────────────────────────────────────────────
//  BOOKINGS TABLE — tablet/desktop (horizontal scroll on tablet)
// ─────────────────────────────────────────────
class _BookingsTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDesktop = Breakpoints.isDesktop(context);

    final table = Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          decoration: const BoxDecoration(color: AppColors.surfaceAlt),
          child: const Row(
            children: [
              SizedBox(width: 150, child: _TH('Tenant')),
              SizedBox(width: 170, child: _TH('Property')),
              SizedBox(width: 120, child: _TH('Check-In')),
              SizedBox(width: 90,  child: _TH('Payment')),
              SizedBox(width: 110, child: _TH('Status')),
            ],
          ),
        ),
        ...recentBookings.asMap().entries.map((e) =>
            _BookingTableRow(row: e.value, isLast: e.key == recentBookings.length - 1)),
        const SizedBox(height: 6),
      ],
    );

    if (isDesktop) {
      // On desktop expand columns to fill space
      return _BookingsTableExpanded();
    }

    // On tablet: wrap in horizontal scrollbar with fixed-width columns
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: CustomHorizontalScrollbar(
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 640),
          child: table,
        ),
      ),
    );
  }
}

/// Expanded version for desktop (uses Expanded / flex)
class _BookingsTableExpanded extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          decoration: const BoxDecoration(color: AppColors.surfaceAlt),
          child: const Row(
            children: [
              Expanded(flex: 4, child: _TH('Tenant')),
              Expanded(flex: 4, child: _TH('Property')),
              Expanded(flex: 3, child: _TH('Check-In')),
              Expanded(flex: 3, child: _TH('Payment')),
              Expanded(flex: 3, child: _TH('Status')),
            ],
          ),
        ),
        ...recentBookings.asMap().entries.map((e) =>
            _BookingTableRowExpanded(row: e.value, isLast: e.key == recentBookings.length - 1)),
        const SizedBox(height: 6),
      ],
    );
  }
}

class _TH extends StatelessWidget {
  final String text;
  const _TH(this.text);
  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: const TextStyle(
      fontSize: 10.5, fontWeight: FontWeight.w700,
      color: AppColors.textMuted, letterSpacing: 0.6,
    ),
  );
}

// Fixed-width row (used when horizontally scrollable)
class _BookingTableRow extends StatelessWidget {
  final BookingRow row;
  final bool isLast;
  const _BookingTableRow({required this.row, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Row(
            children: [
              SizedBox(
                width: 150,
                child: Row(
                  children: [
                    _Avatar(initials: row.avatar),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(row.tenant,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5, fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 170,
                child: Text(row.property, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecond)),
              ),
              SizedBox(
                width: 120,
                child: Text(row.checkIn, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecond)),
              ),
              SizedBox(width: 90,  child: _PayChip(status: row.payStatus)),
              SizedBox(width: 110, child: _BookChip(status: row.bookStatus)),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1, color: AppColors.border, indent: 18),
      ],
    );
  }
}

// Flex-expanded row (desktop)
class _BookingTableRowExpanded extends StatelessWidget {
  final BookingRow row;
  final bool isLast;
  const _BookingTableRowExpanded({required this.row, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
          child: Row(
            children: [
              Expanded(flex: 4, child: Row(
                children: [
                  _Avatar(initials: row.avatar),
                  const SizedBox(width: 9),
                  Expanded(child: Text(row.tenant, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary))),
                ],
              )),
              Expanded(flex: 4, child: Text(row.property, overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12.5, color: AppColors.textSecond))),
              Expanded(flex: 3, child: Text(row.checkIn, overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecond))),
              Expanded(flex: 3, child: _PayChip(status: row.payStatus)),
              Expanded(flex: 3, child: _BookChip(status: row.bookStatus)),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1, color: AppColors.border, indent: 18),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  final String initials;
  const _Avatar({required this.initials});

  @override
  Widget build(BuildContext context) => Container(
    width: 30, height: 30,
    decoration: const BoxDecoration(
      color: AppColors.accentLight,
      shape: BoxShape.circle,
    ),
    child: Center(
      child: Text(initials,
        style: const TextStyle(
          fontSize: 9.5, fontWeight: FontWeight.w800,
          color: AppColors.accent)),
    ),
  );
}

// ─────────────────────────────────────────────
//  BOOKING CARDS — mobile only (replaces table)
// ─────────────────────────────────────────────
class _BookingCardsMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...recentBookings.asMap().entries.map((e) =>
          _BookingCardMobile(row: e.value, isLast: e.key == recentBookings.length - 1)),
        const SizedBox(height: 6),
      ],
    );
  }
}

class _BookingCardMobile extends StatelessWidget {
  final BookingRow row;
  final bool isLast;
  const _BookingCardMobile({required this.row, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Avatar(initials: row.avatar),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + pay chip
                    Row(
                      children: [
                        Expanded(
                          child: Text(row.tenant,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary)),
                        ),
                        const SizedBox(width: 8),
                        _PayChip(status: row.payStatus),
                      ],
                    ),
                    const SizedBox(height: 3),
                    // Property
                    Row(children: [
                      const Icon(Icons.apartment_rounded, size: 11, color: AppColors.textMuted),
                      const SizedBox(width: 3),
                      Expanded(child: Text(row.property, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11.5, color: AppColors.textSecond))),
                    ]),
                    const SizedBox(height: 3),
                    // Check-in + booking chip
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded, size: 10, color: AppColors.textMuted),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(row.checkIn,
                            style: const TextStyle(fontSize: 11, color: AppColors.textMuted))),
                        _BookChip(status: row.bookStatus),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1, color: AppColors.border, indent: 14),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  STATUS CHIPS
// ─────────────────────────────────────────────
class _PayChip extends StatelessWidget {
  final String status;
  const _PayChip({required this.status});
  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (status) {
      'Paid'   => (AppColors.statusPaidBg,    AppColors.statusPaid),
      'Failed' => (AppColors.statusFailedBg,  AppColors.statusFailed),
      _        => (AppColors.statusPendingBg, AppColors.statusPending),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(status,
        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: fg)),
    );
  }
}

class _BookChip extends StatelessWidget {
  final String status;
  const _BookChip({required this.status});
  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (status) {
      'Confirmed' => (AppColors.statusConfirmedBg, AppColors.statusConfirmed),
      'Cancelled' => (AppColors.statusFailedBg,    AppColors.statusFailed),
      _           => (AppColors.statusReviewBg,    AppColors.statusReview),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(status, overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: fg)),
    );
  }
}

// ─────────────────────────────────────────────
//  PROPERTIES LIST
// ─────────────────────────────────────────────
class _PropertiesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: recentProperties.asMap().entries.map((e) =>
        _PropertyTile(prop: e.value, isLast: e.key == recentProperties.length - 1)).toList(),
    );
  }
}

class _PropertyTile extends StatelessWidget {
  final PropertyCard prop;
  final bool isLast;
  const _PropertyTile({required this.prop, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.isMobile(context);
    final hPad = isMobile ? 14.0 : 18.0;
    final iconSize = isMobile ? 44.0 : 52.0;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(hPad, 12, hPad, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: iconSize, height: iconSize,
                decoration: BoxDecoration(
                  color: prop.tagColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.apartment_rounded, color: prop.tagColor, size: isMobile ? 22 : 26),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(
                        child: Text(prop.name, overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: isMobile ? 12.5 : 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary)),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: prop.tagColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(prop.tagLabel,
                          style: TextStyle(
                            fontSize: 9, fontWeight: FontWeight.w800,
                            color: prop.tagColor, letterSpacing: 0.3)),
                      ),
                    ]),
                    const SizedBox(height: 3),
                    Row(children: [
                      const Icon(Icons.location_on_rounded, size: 11, color: AppColors.textMuted),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(prop.address, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11, color: AppColors.textMuted))),
                    ]),
                    const SizedBox(height: 7),
                    Row(children: [
                      Text(prop.price,
                        style: TextStyle(
                          fontSize: isMobile ? 12.5 : 13,
                          fontWeight: FontWeight.w800,
                          color: prop.tagColor)),
                      const Spacer(),
                      const Icon(Icons.star_rounded, size: 12, color: Color(0xFFFFB800)),
                      const SizedBox(width: 2),
                      Text(prop.rating.toString(),
                        style: const TextStyle(
                          fontSize: 11.5, fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary)),
                      const SizedBox(width: 3),
                      Text('(${prop.reviews})',
                        style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast) Divider(height: 1, color: AppColors.border, indent: hPad),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  CHART TOGGLE
// ─────────────────────────────────────────────
class _ChartToggle extends StatelessWidget {
  final bool show7Days;
  final ValueChanged<bool> onToggle;
  const _ChartToggle({required this.show7Days, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleBtn(label: '7D',  active: show7Days,  onTap: () => onToggle(true)),
          _ToggleBtn(label: '30D', active: !show7Days, onTap: () => onToggle(false)),
        ],
      ),
    );
  }
}

class _ToggleBtn extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _ToggleBtn({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: active ? AppColors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          boxShadow: active ? AppColors.accentShadow : null,
        ),
        child: Text(label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: active ? Colors.white : AppColors.textMuted,
          )),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  BOOKING TREND CHART — adaptive height
// ─────────────────────────────────────────────
class _BookingChart extends StatefulWidget {
  final bool show7Days;
  const _BookingChart({required this.show7Days});
  @override
  State<_BookingChart> createState() => _BookingChartState();
}

class _BookingChartState extends State<_BookingChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl.forward();
  }

  @override
  void didUpdateWidget(_BookingChart old) {
    super.didUpdateWidget(old);
    if (old.show7Days != widget.show7Days) {
      _ctrl.reset();
      _ctrl.forward();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data   = widget.show7Days ? bookingTrend7 : bookingTrend30;
    final labels = widget.show7Days
        ? ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
        : List.generate(30, (i) => (i + 1).toString());

    // Adaptive chart height
    final chartHeight = Breakpoints.fluid<double>(context,
      mobile: 150, tablet: 170, desktop: 180);

    final hPad = Breakpoints.isMobile(context) ? 8.0 : 10.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, 4, 18, 14),
      child: Column(
        children: [
          SizedBox(
            height: chartHeight,
            child: AnimatedBuilder(
              animation: _anim,
              builder: (_, __) => CustomPaint(
                painter: _BarChartPainter(
                  data: data,
                  progress: _anim.value,
                  barColor: AppColors.accent,
                  barColorLight: AppColors.accentLight,
                  gridColor: AppColors.border,
                ),
                child: Container(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (widget.show7Days)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: labels.map((l) => Text(l,
                style: const TextStyle(
                  fontSize: 10, color: AppColors.textMuted,
                  fontWeight: FontWeight.w600))).toList(),
            ),
          if (!widget.show7Days)
            const Text('Last 30 days — daily bookings',
              style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  CHART PAINTER (unchanged logic, kept const)
// ─────────────────────────────────────────────
class _BarChartPainter extends CustomPainter {
  final List<int> data;
  final double progress;
  final Color barColor, barColorLight, gridColor;

  const _BarChartPainter({
    required this.data,     required this.progress,
    required this.barColor, required this.barColorLight,
    required this.gridColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final maxVal = data.reduce(math.max).toDouble();
    final minVal = data.reduce(math.min).toDouble();
    final range  = (maxVal - minVal).clamp(1.0, double.infinity);
    final n      = data.length;
    const paddingTop    = 12.0;
    const paddingBottom = 4.0;
    final chartH = size.height - paddingTop - paddingBottom;

    Offset pointAt(int i) {
      final x = n == 1 ? size.width / 2 : (i / (n - 1)) * size.width;
      final frac = (data[i] - minVal) / range;
      final y    = paddingTop + chartH * (1.0 - frac * progress);
      return Offset(x, y);
    }

    // Grid
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;
    for (var i = 0; i <= 4; i++) {
      final y = paddingTop + (1 - i / 4) * chartH;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Bezier paths
    final linePath = Path();
    final fillPath = Path();
    for (var i = 0; i < n; i++) {
      final p = pointAt(i);
      if (i == 0) {
        linePath.moveTo(p.dx, p.dy);
        fillPath.moveTo(p.dx, size.height);
        fillPath.lineTo(p.dx, p.dy);
      } else {
        final prev = pointAt(i - 1);
        final cpX  = (prev.dx + p.dx) / 2;
        linePath.cubicTo(cpX, prev.dy, cpX, p.dy, p.dx, p.dy);
        fillPath.cubicTo(cpX, prev.dy, cpX, p.dy, p.dx, p.dy);
      }
    }
    final lastP = pointAt(n - 1);
    fillPath.lineTo(lastP.dx, size.height);
    fillPath.close();

    // Fill gradient
    canvas.drawPath(fillPath, Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [
          barColor.withOpacity(0.35),
          barColor.withOpacity(0.08),
          barColor.withOpacity(0.0),
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill);

    // Line
    canvas.drawPath(linePath, Paint()
      ..color = barColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round);

    // Dot
    final dot = pointAt(n - 1);
    canvas.drawCircle(dot, 4.5, Paint()..color = AppColors.surface);
    canvas.drawCircle(dot, 4.5, Paint()
      ..color = barColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(_BarChartPainter old) =>
      old.progress != progress || old.data != data;
}