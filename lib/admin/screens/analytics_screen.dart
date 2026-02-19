import 'dart:math';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  ENTRY POINT
// ─────────────────────────────────────────────────────────────────────────────
void main() => runApp(const AdminApp());

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BH Finder – Analytics',
        theme: AppTheme.light,
        home: const AnalyticsScreen(),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
//  RESPONSIVE UTILITY
//  Breakpoints:
//    mobile  : width < 600
//    tablet  : 600 ≤ width < 1024
//    desktop : width ≥ 1024
// ─────────────────────────────────────────────────────────────────────────────
enum _Screen { mobile, tablet, desktop }

class Responsive {
  final double width;
  final double height;

  Responsive(this.width, this.height);

  factory Responsive.of(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Responsive(size.width, size.height);
  }

  _Screen get screen {
    if (width < 600) return _Screen.mobile;
    if (width < 1024) return _Screen.tablet;
    return _Screen.desktop;
  }

  bool get isMobile  => screen == _Screen.mobile;
  bool get isTablet  => screen == _Screen.tablet;
  bool get isDesktop => screen == _Screen.desktop;

  // ── Spacing ──────────────────────────────────────────────────────────────
  double get hPad    => isMobile ? 14 : isTablet ? 20 : 28;
  double get vPad    => isMobile ? 14 : 20;
  double get gutter  => isMobile ? 12 : 16;
  double get cardPad => isMobile ? 14 : 20;

  // ── Chart heights ─────────────────────────────────────────────────────────
  double get chartH  => isMobile ? 160 : isTablet ? 180 : 200;

  // ── Component sizes ───────────────────────────────────────────────────────
  double get iconBox   => isMobile ? 38 : 46;
  double get barRowH   => isMobile ? 16 : 20;
  double get logoSize  => isMobile ? 30 : 34;
  double get topBarVPad => isMobile ? 12 : 14;

  // ── Grid columns ──────────────────────────────────────────────────────────
  int get statCols  => isDesktop ? 3 : isTablet ? 3 : 1;
  int get chartCols => isDesktop ? 2 : isTablet ? 2 : 1;

  // ── Typography scale ──────────────────────────────────────────────────────
  double get fs10 => isMobile ?  9.5 : 10.5;
  double get fs11 => isMobile ? 10.5 : 11.5;
  double get fs12 => isMobile ? 11.0 : 12.0;
  double get fs14 => isMobile ? 13.0 : 14.0;
  double get fs15 => isMobile ? 14.0 : 15.0;
  double get fs20 => isMobile ? 17.0 : isTablet ? 19.0 : 22.0;
}

// ─────────────────────────────────────────────────────────────────────────────
//  THEME — Facebook Settings Palette
// ─────────────────────────────────────────────────────────────────────────────
class AppTheme {
  static const Color bg            = Color(0xFFF0F2F5);
  static const Color surface       = Color(0xFFFFFFFF);
  static const Color primary       = Color(0xFF1877F2);
  static const Color primaryLight  = Color(0xFFE7F0FD);
  static const Color success       = Color(0xFF31A24C);
  static const Color warning       = Color(0xFFF7B928);
  static const Color danger        = Color(0xFFF02849);
  static const Color textPrimary   = Color(0xFF1C1E21);
  static const Color textSecondary = Color(0xFF65676B);
  static const Color border        = Color(0xFFDDDFE3);
  static const Color divider       = Color(0xFFE4E6EB);

  static const List<Color> chartColors = [
    Color(0xFF1877F2),
    Color(0xFF31A24C),
    Color(0xFFF7B928),
    Color(0xFFF02849),
    Color(0xFF0099FF),
    Color(0xFF9B59B6),
  ];

  static ThemeData get light => ThemeData(
        scaffoldBackgroundColor: bg,
        colorScheme: const ColorScheme.light(
          primary: primary,
          secondary: primaryLight,
          surface: surface,
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      );
}

// ─────────────────────────────────────────────────────────────────────────────
//  MOCK DATA
// ─────────────────────────────────────────────────────────────────────────────
class AnalyticsData {
  static const List<double> weeklyBookings   = [12, 19, 14, 22, 18, 25, 20];
  static const List<double> monthlyBookings  = [142, 168, 155, 190, 210, 185, 220, 245, 230, 198, 260, 275];
  static const List<double> yearlyBookings   = [1450, 1820, 2100, 2480, 2850];

  static const List<double> weeklyRevenue    = [32.5, 41.2, 38.8, 55.0, 48.3, 62.1, 58.7];
  static const List<double> monthlyRevenue   = [145, 162, 158, 195, 218, 192, 230, 255, 242, 205, 270, 288];
  static const List<double> yearlyRevenue    = [1200, 1580, 1920, 2340, 2780];

  static const List<double> weeklyOccupancy  = [72, 78, 75, 82, 79, 85, 83];
  static const List<double> monthlyOccupancy = [68, 72, 70, 75, 80, 77, 82, 85, 83, 78, 87, 89];
  static const List<double> yearlyOccupancy  = [65, 70, 74, 80, 84];

  static const List<MapEntry<String, double>> topProperties = [
    MapEntry('Sunshine BH',    145),
    MapEntry('Marigold Lodge', 128),
    MapEntry('Blue Haven',     112),
    MapEntry('Green Nest',      98),
    MapEntry('Casa Mia',        87),
  ];

  static const Map<String, List<String>> labels = {
    'week':  ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    'month': ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
    'year':  ['2021', '2022', '2023', '2024', '2025'],
  };
}

// ─────────────────────────────────────────────────────────────────────────────
//  ANALYTICS SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _filter = 'month';

  List<double> get _bookings  => switch (_filter) {
    'week' => AnalyticsData.weeklyBookings,
    'year' => AnalyticsData.yearlyBookings,
    _      => AnalyticsData.monthlyBookings,
  };
  List<double> get _revenue   => switch (_filter) {
    'week' => AnalyticsData.weeklyRevenue,
    'year' => AnalyticsData.yearlyRevenue,
    _      => AnalyticsData.monthlyRevenue,
  };
  List<double> get _occupancy => switch (_filter) {
    'week' => AnalyticsData.weeklyOccupancy,
    'year' => AnalyticsData.yearlyOccupancy,
    _      => AnalyticsData.monthlyOccupancy,
  };
  List<String> get _labels => AnalyticsData.labels[_filter] ?? AnalyticsData.labels['month']!;

  String _sum(List<double> v) => v.reduce((a, b) => a + b).toStringAsFixed(0);

  @override
  Widget build(BuildContext context) {
    // Re-read on every build so orientation / window resize is captured
    final r = Responsive.of(context);

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(filter: _filter, onFilterChanged: (v) => setState(() => _filter = v), r: r),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: r.hPad, vertical: r.vPad),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── Quick Stat Cards ──────────────────────────────────────
                    _ResponsiveGrid(
                      cols: r.statCols,
                      gutter: r.gutter,
                      children: [
                        _QuickStatCard(r: r, icon: Icons.payments_rounded,    color: AppTheme.primary, label: 'Total Revenue',      value: '₱288,400', change: '+12.4%', up: true),
                        _QuickStatCard(r: r, icon: Icons.bed_rounded,          color: AppTheme.success, label: 'Avg Occupancy',       value: '89%',       change: '+2.1%',  up: true),
                        _QuickStatCard(r: r, icon: Icons.check_circle_rounded, color: AppTheme.warning, label: 'Completed Bookings', value: '275',        change: '+18',    up: true),
                      ],
                    ),

                    SizedBox(height: r.gutter + 4),

                    // ── Section Header ────────────────────────────────────────
                    _SectionHeader(
                      r: r,
                      title: 'Performance Charts',
                      badge: _filter[0].toUpperCase() + _filter.substring(1),
                    ),

                    SizedBox(height: r.gutter),

                    // ── Charts Grid ───────────────────────────────────────────
                    _ResponsiveGrid(
                      cols: r.chartCols,
                      gutter: r.gutter,
                      children: [
                        _ChartCard(
                          r: r,
                          title: 'Bookings Trend',
                          subtitle: 'Total booking requests over time',
                          badge: _sum(_bookings),
                          child: _BarChart(values: _bookings, labels: _labels, barColor: AppTheme.primary, unit: ''),
                        ),
                        _ChartCard(
                          r: r,
                          title: 'Revenue Growth',
                          subtitle: 'Total revenue in PHP (thousands)',
                          badge: '₱${_sum(_revenue)}k',
                          child: _LineChart(values: _revenue, labels: _labels, lineColor: AppTheme.primary, unit: '₱'),
                        ),
                        _ChartCard(
                          r: r,
                          title: 'Occupancy Rate',
                          subtitle: 'Average occupancy percentage',
                          badge: '${_occupancy.last.toStringAsFixed(0)}%',
                          child: _LineChart(values: _occupancy, labels: _labels, lineColor: AppTheme.primary, unit: '%', maxY: 100),
                        ),
                        _ChartCard(
                          r: r,
                          title: 'Top Properties',
                          subtitle: 'Most booked — this period',
                          badge: '#1 ${AnalyticsData.topProperties.first.key}',
                          child: _HorizontalBarChart(data: AnalyticsData.topProperties, r: r),
                        ),
                      ],
                    ),

                    SizedBox(height: r.vPad),
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

// ─────────────────────────────────────────────────────────────────────────────
//  RESPONSIVE GRID
//  Builds rows of `cols` items using Row + Expanded — no fixed pixel widths.
//  Single-column degrades to a simple Column.
// ─────────────────────────────────────────────────────────────────────────────
class _ResponsiveGrid extends StatelessWidget {
  final int cols;
  final double gutter;
  final List<Widget> children;

  const _ResponsiveGrid({required this.cols, required this.gutter, required this.children});

  @override
  Widget build(BuildContext context) {
    if (cols <= 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(height: gutter),
            children[i],
          ],
        ],
      );
    }

    final rows = <Widget>[];
    for (int i = 0; i < children.length; i += cols) {
      final rowChildren = <Widget>[];
      for (int j = 0; j < cols; j++) {
        if (j > 0) rowChildren.add(SizedBox(width: gutter));
        final idx = i + j;
        rowChildren.add(
          Expanded(child: idx < children.length ? children[idx] : const SizedBox.shrink()),
        );
      }
      if (rows.isNotEmpty) rows.add(SizedBox(height: gutter));
      rows.add(Row(crossAxisAlignment: CrossAxisAlignment.start, children: rowChildren));
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: rows);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  SECTION HEADER
// ─────────────────────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final Responsive r;
  final String title;
  final String badge;
  const _SectionHeader({required this.r, required this.title, required this.badge});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: r.fs15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary, letterSpacing: -0.1),
        ),
        const SizedBox(width: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: r.isMobile ? 8 : 10, vertical: 3),
          decoration: BoxDecoration(color: AppTheme.primaryLight, borderRadius: BorderRadius.circular(20)),
          child: Text(badge, style: TextStyle(fontSize: r.fs10, color: AppTheme.primary, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  TOP BAR
// ─────────────────────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final String filter;
  final ValueChanged<String> onFilterChanged;
  final Responsive r;
  const _TopBar({required this.filter, required this.onFilterChanged, required this.r});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: r.hPad, vertical: r.topBarVPad),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          // Logo mark
          Container(
            width: r.logoSize, height: r.logoSize,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(r.isMobile ? 7 : 8),
            ),
            child: Icon(Icons.home_work_rounded, color: Colors.white, size: r.isMobile ? 16 : 18),
          ),
          SizedBox(width: r.isMobile ? 10 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BH Finder',
                  style: TextStyle(fontSize: r.fs15, fontWeight: FontWeight.w800, color: AppTheme.textPrimary, letterSpacing: -0.3),
                ),
                // Hide subtitle on very small phones to save bar space
                if (r.width > 360)
                  Text('Analytics Overview', style: TextStyle(fontSize: r.fs11, color: AppTheme.textSecondary)),
              ],
            ),
          ),
          _FilterToggle(current: filter, onChanged: onFilterChanged, r: r),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  FILTER TOGGLE
// ─────────────────────────────────────────────────────────────────────────────
class _FilterToggle extends StatelessWidget {
  final String current;
  final ValueChanged<String> onChanged;
  final Responsive r;
  const _FilterToggle({required this.current, required this.onChanged, required this.r});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppTheme.bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: ['week', 'month', 'year'].map((f) {
          final active = f == current;
          return GestureDetector(
            onTap: () => onChanged(f),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: EdgeInsets.symmetric(
                horizontal: r.isMobile ? 9.0 : 14.0,
                vertical:   r.isMobile ?  5.0 :  6.0,
              ),
              decoration: BoxDecoration(
                color: active ? AppTheme.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(7),
                boxShadow: active
                    ? [BoxShadow(color: AppTheme.primary.withOpacity(0.28), blurRadius: 6, offset: const Offset(0, 2))]
                    : null,
              ),
              child: Text(
                f[0].toUpperCase() + f.substring(1),
                style: TextStyle(
                  fontSize: r.isMobile ? 11.0 : 12.0,
                  fontWeight: FontWeight.w700,
                  color: active ? Colors.white : AppTheme.textSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  QUICK STAT CARD
// ─────────────────────────────────────────────────────────────────────────────
class _QuickStatCard extends StatelessWidget {
  final Responsive r;
  final IconData icon;
  final Color color;
  final String label;
  final String value;
  final String change;
  final bool up;

  const _QuickStatCard({
    required this.r, required this.icon, required this.color,
    required this.label, required this.value, required this.change, required this.up,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(r.cardPad),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          // Icon box
          Container(
            width: r.iconBox, height: r.iconBox,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(r.isMobile ? 10 : 12),
            ),
            child: Icon(icon, color: color, size: r.isMobile ? 19 : 22),
          ),
          SizedBox(width: r.isMobile ? 12 : 14),
          // Label + value
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: r.fs11, color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
                const SizedBox(height: 3),
                Text(value, style: TextStyle(fontSize: r.fs20, fontWeight: FontWeight.w800, color: AppTheme.textPrimary, letterSpacing: -0.5)),
              ],
            ),
          ),
          // Change badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: r.isMobile ? 6 : 8, vertical: 4),
            decoration: BoxDecoration(
              color: (up ? AppTheme.success : AppTheme.danger).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  up ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                  size: r.isMobile ? 10 : 11,
                  color: up ? AppTheme.success : AppTheme.danger,
                ),
                const SizedBox(width: 2),
                Text(
                  change,
                  style: TextStyle(
                    fontSize: r.isMobile ? 10.0 : 11.0,
                    fontWeight: FontWeight.w700,
                    color: up ? AppTheme.success : AppTheme.danger,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  CHART CARD WRAPPER
// ─────────────────────────────────────────────────────────────────────────────
class _ChartCard extends StatelessWidget {
  final Responsive r;
  final String title;
  final String subtitle;
  final String badge;
  final Widget child;

  const _ChartCard({required this.r, required this.title, required this.subtitle, required this.badge, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(r.cardPad),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                      style: TextStyle(fontSize: r.fs14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary, letterSpacing: -0.2)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                      style: TextStyle(fontSize: r.fs11, color: AppTheme.textSecondary)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: r.isMobile ? 7 : 9, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.bg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Text(badge,
                  style: TextStyle(fontSize: r.fs10, color: AppTheme.textSecondary, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const Divider(color: AppTheme.divider, height: 20),
          SizedBox(height: r.chartH, child: child),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  BAR CHART  (custom painter — fully size-aware)
// ─────────────────────────────────────────────────────────────────────────────
class _BarChart extends StatelessWidget {
  final List<double> values;
  final List<String> labels;
  final Color barColor;
  final String unit;
  const _BarChart({required this.values, required this.labels, required this.barColor, required this.unit});

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _BarChartPainter(values: values, labels: labels, barColor: barColor, unit: unit),
        child: const SizedBox.expand(),
      );
}

class _BarChartPainter extends CustomPainter {
  final List<double> values;
  final List<String> labels;
  final Color barColor;
  final String unit;
  const _BarChartPainter({required this.values, required this.labels, required this.barColor, required this.unit});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    // Left padding scales with available width to keep Y-labels fitting
    final pL = size.width < 220 ? 28.0 : 36.0;
    const pB = 26.0, pT = 10.0, pR = 8.0;
    final chartW = size.width  - pL - pR;
    final chartH = size.height - pB - pT;
    final maxVal = values.reduce(max) * 1.15;

    final gridPaint = Paint()..color = AppTheme.divider..strokeWidth = 0.6;

    // Horizontal grid lines + Y labels
    for (int i = 0; i <= 4; i++) {
      final y = pT + chartH - (i / 4) * chartH;
      canvas.drawLine(Offset(pL, y), Offset(pL + chartW, y), gridPaint);
      _drawText(canvas, '$unit${((maxVal * i / 4)).toStringAsFixed(maxVal < 10 ? 1 : 0)}',
          Offset(0, y - 7), size.width < 280 ? 7.5 : 9.0, AppTheme.textSecondary, maxW: pL - 4);
    }
    canvas.drawLine(Offset(pL, pT), Offset(pL, pT + chartH), gridPaint);

    final n = values.length;
    final slotW = chartW / n;
    final barW  = slotW * 0.52;

    // Adaptive x-label font / skip logic
    final labelFs = slotW < 22 ? 7.5 : (slotW < 34 ? 8.5 : 9.0);

    for (int i = 0; i < n; i++) {
      final barH = (values[i] / maxVal) * chartH;
      final x = pL + i * slotW + (slotW - barW) / 2;
      final y = pT + chartH - barH;

      canvas.drawRRect(
        RRect.fromRectAndCorners(Rect.fromLTWH(x, y, barW, barH),
            topLeft: const Radius.circular(4), topRight: const Radius.circular(4)),
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [barColor, barColor.withOpacity(i == n - 1 ? 1.0 : 0.55)],
          ).createShader(Rect.fromLTWH(x, y, barW, barH)),
      );

      // Show every label unless slots are very narrow
      if ((slotW >= 20 || i % 2 == 0) && i < labels.length) {
        _drawText(canvas, labels[i], Offset(x + barW / 2 - 10, pT + chartH + 6),
            labelFs, AppTheme.textSecondary, maxW: slotW);
      }
    }
  }

  void _drawText(Canvas canvas, String text, Offset offset, double fontSize, Color color, {double maxW = 80}) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: fontSize)),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxW);
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter old) => old.values != values || old.labels != labels;
}

// ─────────────────────────────────────────────────────────────────────────────
//  LINE CHART  — Facebook-style Catmull-Rom smooth curve + gradient fill
// ─────────────────────────────────────────────────────────────────────────────
class _LineChart extends StatelessWidget {
  final List<double> values;
  final List<String> labels;
  final Color lineColor;
  final String unit;
  final double? maxY;
  const _LineChart({required this.values, required this.labels, required this.lineColor, required this.unit, this.maxY});

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _LineChartPainter(values: values, labels: labels, lineColor: lineColor, unit: unit, maxY: maxY),
        child: const SizedBox.expand(),
      );
}

class _LineChartPainter extends CustomPainter {
  final List<double> values;
  final List<String> labels;
  final Color lineColor;
  final String unit;
  final double? maxY;
  const _LineChartPainter({required this.values, required this.labels, required this.lineColor, required this.unit, this.maxY});

  /// Catmull-Rom → cubic Bézier for ultra-smooth Facebook-style curves
  Path _smoothPath(List<Offset> pts) {
    final path = Path()..moveTo(pts[0].dx, pts[0].dy);
    for (int i = 0; i < pts.length - 1; i++) {
      final p0 = i > 0 ? pts[i - 1] : pts[i];
      final p1 = pts[i];
      final p2 = pts[i + 1];
      final p3 = i + 2 < pts.length ? pts[i + 2] : pts[i + 1];
      final cp1 = Offset(p1.dx + (p2.dx - p0.dx) / 6.0, p1.dy + (p2.dy - p0.dy) / 6.0);
      final cp2 = Offset(p2.dx - (p3.dx - p1.dx) / 6.0, p2.dy - (p3.dy - p1.dy) / 6.0);
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p2.dx, p2.dy);
    }
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;

    const pL = 4.0, pR = 14.0, pT = 16.0, pB = 26.0;
    final chartW = size.width  - pL - pR;
    final chartH = size.height - pT - pB;

    final rawMax = maxY ?? values.reduce(max);
    final rawMin = values.reduce(min);
    final pad     = (rawMax - rawMin) * 0.18;
    final maxVal  = rawMax + pad;
    final minVal  = (rawMin - pad).clamp(0.0, double.infinity);
    final range   = (maxVal - minVal).clamp(1.0, double.infinity);
    final n = values.length;

    final pts = List.generate(n, (i) => Offset(
      pL + i * (chartW / (n - 1)),
      pT + chartH - ((values[i] - minVal) / range) * chartH,
    ));

    // Thin grid lines
    final grid = Paint()..color = const Color(0xFFE4E6EB)..strokeWidth = 0.6;
    for (int i = 0; i <= 4; i++) {
      final y = pT + (i / 4) * chartH;
      canvas.drawLine(Offset(pL, y), Offset(pL + chartW, y), grid);
    }

    final linePath = _smoothPath(pts);

    // Gradient area fill
    final fillPath = Path.from(linePath)
      ..lineTo(pts.last.dx,  pT + chartH)
      ..lineTo(pts.first.dx, pT + chartH)
      ..close();

    canvas.drawPath(fillPath, Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [lineColor.withOpacity(0.30), lineColor.withOpacity(0.10), lineColor.withOpacity(0.0)],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Rect.fromLTWH(0, pT, size.width, chartH))
      ..style = PaintingStyle.fill);

    // Stroke
    canvas.drawPath(linePath, Paint()
      ..color = lineColor
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke);

    // Endpoint dot — outer glow → white → colored ring
    final last = pts.last;
    canvas.drawCircle(last, 10,  Paint()..color = lineColor.withOpacity(0.10));
    canvas.drawCircle(last, 5.5, Paint()..color = Colors.white..style = PaintingStyle.fill);
    canvas.drawCircle(last, 5.5, Paint()..color = lineColor..strokeWidth = 2.2..style = PaintingStyle.stroke);

    // X labels — adaptive step to prevent overlap at narrow widths
    final pixelsPerPt  = chartW / (n - 1);
    final minSpacing   = 28.0;
    final spacingStep  = (minSpacing / pixelsPerPt).ceil().clamp(1, n);
    final naturalStep  = (n / 5).ceil().clamp(1, n);
    final step         = max(naturalStep, spacingStep);
    final labelFs      = size.width < 250 ? 8.0 : 9.5;

    for (int i = 0; i < n; i += step) {
      if (i < labels.length) {
        _drawText(canvas, labels[i], Offset(pts[i].dx - 10, pT + chartH + 7), labelFs, const Color(0xFF8A8D91));
      }
    }
    final lastIdx = n - 1;
    if (lastIdx % step != 0 && labels.isNotEmpty) {
      _drawText(canvas, labels[lastIdx], Offset(pts[lastIdx].dx - 14, pT + chartH + 7), labelFs, const Color(0xFF8A8D91));
    }
  }

  void _drawText(Canvas canvas, String text, Offset offset, double fontSize, Color color) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: fontSize)),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 60);
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter old) => old.values != values || old.labels != labels;
}

// ─────────────────────────────────────────────────────────────────────────────
//  HORIZONTAL BAR CHART
// ─────────────────────────────────────────────────────────────────────────────
class _HorizontalBarChart extends StatelessWidget {
  final List<MapEntry<String, double>> data;
  final Responsive r;
  const _HorizontalBarChart({required this.data, required this.r});

  @override
  Widget build(BuildContext context) {
    final maxVal  = data.map((e) => e.value).reduce(max);
    final labelW  = r.isMobile ? 80.0 : 96.0;
    final valueW  = r.isMobile ? 26.0 : 32.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(data.length, (idx) {
        final item  = data[idx];
        final frac  = item.value / maxVal;
        final color = AppTheme.chartColors[idx % AppTheme.chartColors.length];
        final isTop = idx == 0;

        return Padding(
          padding: EdgeInsets.symmetric(vertical: r.isMobile ? 3 : 4),
          child: Row(
            children: [
              SizedBox(
                width: labelW,
                child: Text(item.key,
                  style: TextStyle(
                    fontSize: r.fs11,
                    color: isTop ? AppTheme.textPrimary : AppTheme.textSecondary,
                    fontWeight: isTop ? FontWeight.w700 : FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Stack(children: [
                  Container(
                    height: r.barRowH,
                    decoration: BoxDecoration(
                      color: AppTheme.bg,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: AppTheme.border),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: frac,
                    child: Container(
                      height: r.barRowH,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ]),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: valueW,
                child: Text(item.value.toInt().toString(),
                  style: TextStyle(
                    fontSize: r.fs11,
                    fontWeight: isTop ? FontWeight.w800 : FontWeight.w600,
                    color: isTop ? AppTheme.primary : AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.right),
              ),
            ],
          ),
        );
      }),
    );
  }
}