import 'package:flutter/material.dart';

// ─── Design Tokens (Facebook-Inspired) ────────────────────────────────────────
const _kBgColor = Color(0xFFF0F2F5);
const _kCardColor = Color(0xFFFFFFFF);
const _kAccent = Color(0xFF1877F2);
const _kTextPrimary = Color(0xFF1C1E21);
const _kTextSecondary = Color(0xFF65676B);
const _kDivider = Color(0xFFE4E6EB);

List<BoxShadow> _cardShadows() => [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        offset: const Offset(0, 1),
        blurRadius: 2,
      ),
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        offset: const Offset(0, 2),
        blurRadius: 8,
      ),
    ];

// ─── Typography Scale ──────────────────────────────────────────────────────────
class _TextStyles {
  static const hero = TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.bold,
    color: _kTextPrimary,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static const heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: _kTextPrimary,
    height: 1.3,
    letterSpacing: -0.3,
  );

  static const heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: _kTextPrimary,
    height: 1.3,
  );

  static const subtitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: _kTextSecondary,
    height: 1.5,
  );

  static const body = TextStyle(
    fontSize: 16,
    color: _kTextPrimary,
    height: 1.6,
  );

  static const bodySecondary = TextStyle(
    fontSize: 15,
    color: _kTextSecondary,
    height: 1.6,
  );

  static const caption = TextStyle(
    fontSize: 14,
    color: _kTextSecondary,
    height: 1.5,
  );
}

// ─── Spacing Constants ─────────────────────────────────────────────────────────
class _Spacing {
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
  static const xxxl = 64.0;
}

// ─── Main About Screen ─────────────────────────────────────────────────────────
class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: _Spacing.md),
          child: Column(
            children: [
              _HeroSection(),
              const SizedBox(height: _Spacing.xxl),
              _WelcomeSection(),
              const SizedBox(height: _Spacing.xxxl),
              _WhatWeDoSection(),
              const SizedBox(height: _Spacing.xxxl),
              _FeaturesSection(),
              const SizedBox(height: _Spacing.xxxl),
              _MissionSection(),
              const SizedBox(height: _Spacing.xxxl),
              _CallToActionSection(),
              const SizedBox(height: _Spacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Hero Section ──────────────────────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _kAccent,
            _kAccent.withOpacity(0.85),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: _Spacing.xxxl),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.info_outline,
                size: 56,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: _Spacing.lg),
            const Text(
              'About BH Finder',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: _Spacing.sm),
            Text(
              'Your Ultimate Boarding House Solution',
              style: _TextStyles.subtitle.copyWith(color: Colors.white.withOpacity(0.95)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Welcome Section (Image Right) ─────────────────────────────────────────────
class _WelcomeSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SectionWithImage(
      title: 'Welcome to BH Finder',
      subtitle: 'Finding Your Perfect Home Away From Home',
      description:
          'BH Finder is a modern, user-friendly platform designed to help students, '
          'workers, and anyone in search of boarding houses find their perfect home '
          'away from home in Tagoloan and surrounding areas.\n\n'
          'Our mission is to simplify the boarding house search process by providing '
          'comprehensive listings, detailed information, and intuitive tools that '
          'make finding accommodation effortless and stress-free.',
      imagePath: 'assets/images/about_welcome.jpg',
      imageOnRight: true,
    );
  }
}

// ─── What We Do Section ────────────────────────────────────────────────────────
class _WhatWeDoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            title: 'What We Do',
            subtitle: 'Connecting people with their ideal living spaces',
          ),
          const SizedBox(height: _Spacing.xl),
          const Text(
            'BH Finder serves as a comprehensive digital platform that connects people '
            'searching for boarding houses with property owners and managers. Our system '
            'aggregates listings from various sources and presents them in an organized, '
            'searchable format.',
            style: _TextStyles.body,
          ),
          const SizedBox(height: _Spacing.xl),
          _buildInfoGrid(),
        ],
      ),
    );
  }

  Widget _buildInfoGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 800;
        
        final items = [
          _InfoItem(
            icon: Icons.search,
            title: 'Smart Search',
            description:
                'Find boarding houses based on your specific requirements like location, price range, and amenities.',
          ),
          _InfoItem(
            icon: Icons.location_on,
            title: 'Map Integration',
            description:
                'Visualize boarding house locations on interactive maps for better spatial understanding.',
          ),
          _InfoItem(
            icon: Icons.favorite,
            title: 'Save Favorites',
            description:
                'Bookmark your preferred boarding houses for easy comparison and future reference.',
          ),
          _InfoItem(
            icon: Icons.qr_code_scanner,
            title: 'QR Code Scanning',
            description:
                'Quickly access detailed information by scanning QR codes at boarding house locations.',
          ),
        ];

        if (isDesktop) {
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: items[0]),
                  const SizedBox(width: _Spacing.lg),
                  Expanded(child: items[1]),
                ],
              ),
              const SizedBox(height: _Spacing.lg),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: items[2]),
                  const SizedBox(width: _Spacing.lg),
                  Expanded(child: items[3]),
                ],
              ),
            ],
          );
        }

        return Column(
          children: items
              .map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: _Spacing.lg),
                    child: item,
                  ))
              .toList(),
        );
      },
    );
  }
}

// ─── Features Section ──────────────────────────────────────────────────────────
class _FeaturesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(
          title: 'Key Features & Benefits',
          subtitle: 'Everything you need for a seamless search experience',
        ),
        const SizedBox(height: _Spacing.lg),
        _Card(
          child: Column(
            children: [
              _FeatureItem(
                icon: Icons.home_work,
                title: 'Comprehensive Listings',
                description:
                    'Access detailed information about boarding houses including prices, amenities, and photos',
              ),
              _buildDivider(),
              _FeatureItem(
                icon: Icons.filter_alt,
                title: 'Advanced Filtering',
                description:
                    'Narrow down options by price, location, amenities, and other important criteria',
              ),
              _buildDivider(),
              _FeatureItem(
                icon: Icons.compare,
                title: 'Easy Comparison',
                description:
                    'Compare multiple boarding houses side-by-side to make informed decisions',
              ),
              _buildDivider(),
              _FeatureItem(
                icon: Icons.support_agent,
                title: '24/7 Support',
                description: 'Get assistance whenever you need help with your boarding house search',
              ),
              _buildDivider(),
              _FeatureItem(
                icon: Icons.mobile_friendly,
                title: 'Mobile Optimized',
                description: 'Seamless experience across all devices - desktop, tablet, and mobile',
              ),
              _buildDivider(),
              _FeatureItem(
                icon: Icons.security,
                title: 'Verified Listings',
                description: 'All listings are verified for accuracy and quality to ensure trust',
                isLast: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: _Spacing.md),
      child: Divider(height: 1, thickness: 1, color: _kDivider),
    );
  }
}

// ─── Mission Section (Image Left) ──────────────────────────────────────────────
class _MissionSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SectionWithImage(
      title: 'Our Mission & Vision',
      subtitle: 'Building the future of boarding house search',
      description:
          'To become the most trusted and comprehensive platform for boarding house '
          'search in the region, connecting people with their ideal living spaces.\n\n'
          'We believe that finding the right accommodation shouldn\'t be stressful. '
          'Our platform aims to eliminate the guesswork and uncertainty that often '
          'accompanies the boarding house search process. By providing transparent, '
          'verified information and powerful search tools, we empower users to make '
          'confident housing decisions.',
      imagePath: 'assets/images/mission.jpg',
      imageOnRight: false,
      showVisionBadge: true,
    );
  }
}

// ─── Call to Action Section ────────────────────────────────────────────────────
class _CallToActionSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.all(_Spacing.xxl),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _kAccent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.handshake_outlined,
              size: 48,
              color: _kAccent,
            ),
          ),
          const SizedBox(height: _Spacing.lg),
          const Text(
            'Ready to Find Your Perfect Boarding House?',
            style: _TextStyles.heading2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: _Spacing.md),
          Text(
            'Start your search today and discover amazing boarding houses in Tagoloan '
            'and surrounding areas. Your ideal living space is just a few clicks away!',
            style: _TextStyles.bodySecondary,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: _Spacing.xl),
          _PrimaryButton(
            text: 'Start Searching',
            icon: Icons.search,
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─── Reusable Components ───────────────────────────────────────────────────────

/// Responsive two-column section with image and text content
class _SectionWithImage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final String imagePath;
  final bool imageOnRight;
  final bool showVisionBadge;

  const _SectionWithImage({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imagePath,
    this.imageOnRight = true,
    this.showVisionBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 900;
        final isMobile = constraints.maxWidth < 600;

        if (isDesktop) {
          return _Card(
            padding: const EdgeInsets.all(_Spacing.xl),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: imageOnRight
                  ? [
                      Expanded(child: _buildContent()),
                      const SizedBox(width: _Spacing.xxl),
                      Expanded(child: _buildImage()),
                    ]
                  : [
                      Expanded(child: _buildImage()),
                      const SizedBox(width: _Spacing.xxl),
                      Expanded(child: _buildContent()),
                    ],
            ),
          );
        }

        return _Card(
          padding: EdgeInsets.all(isMobile ? _Spacing.lg : _Spacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildContent(),
              const SizedBox(height: _Spacing.xl),
              _buildImage(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: _TextStyles.heading1),
        const SizedBox(height: _Spacing.sm),
        Text(subtitle, style: _TextStyles.subtitle),
        const SizedBox(height: _Spacing.lg),
        if (showVisionBadge) ...[
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: _Spacing.md,
              vertical: _Spacing.xs,
            ),
            decoration: BoxDecoration(
              color: _kAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _kAccent.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lightbulb_outline, size: 16, color: _kAccent),
                const SizedBox(width: 6),
                Text(
                  'Our Vision',
                  style: _TextStyles.caption.copyWith(
                    color: _kAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: _Spacing.md),
        ],
        Text(description, style: _TextStyles.body),
      ],
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: _kBgColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_outlined,
                      size: 64,
                      color: _kTextSecondary.withOpacity(0.3),
                    ),
                    const SizedBox(height: _Spacing.sm),
                    Text(
                      'Image placeholder',
                      style: _TextStyles.caption.copyWith(
                        color: _kTextSecondary.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Section header with title and subtitle
class _SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const _SectionHeader({
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: _TextStyles.heading1),
        if (subtitle != null) ...[
          const SizedBox(height: _Spacing.xs),
          Text(subtitle!, style: _TextStyles.subtitle),
        ],
      ],
    );
  }
}

/// Info item with icon, title, and description
class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _InfoItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _kAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(icon, color: _kAccent, size: 24),
        ),
        const SizedBox(width: _Spacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: _kTextPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(description, style: _TextStyles.caption),
            ],
          ),
        ),
      ],
    );
  }
}

/// Feature item for the features list
class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isLast;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _kAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(icon, size: 26, color: _kAccent),
        ),
        const SizedBox(width: _Spacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: _kTextPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(description, style: _TextStyles.caption),
            ],
          ),
        ),
      ],
    );
  }
}

/// Card wrapper with consistent styling
class _Card extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const _Card({
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(_Spacing.xl),
      decoration: BoxDecoration(
        color: _kCardColor,
        borderRadius: BorderRadius.circular(4),
        boxShadow: _cardShadows(),
      ),
      child: child,
    );
  }
}

/// Primary action button
class _PrimaryButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onPressed;

  const _PrimaryButton({
    required this.text,
    required this.onPressed,
    this.icon,
  });

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: _Spacing.xl,
          vertical: _Spacing.md,
        ),
        decoration: BoxDecoration(
          color: _isPressed ? const Color(0xFF166FE5) : _kAccent,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: _kAccent.withOpacity(_isPressed ? 0.3 : 0.25),
              offset: Offset(0, _isPressed ? 2 : 4),
              blurRadius: _isPressed ? 4 : 8,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.icon != null) ...[
              Icon(widget.icon, color: Colors.white, size: 22),
              const SizedBox(width: _Spacing.sm),
            ],
            Text(
              widget.text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}