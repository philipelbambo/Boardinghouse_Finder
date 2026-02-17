import 'package:flutter/material.dart';
import 'admin/utils/admin_constants.dart';
import 'screens/home_screen.dart';
import 'screens/boardinghouse_detail_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/map_screen.dart';
import 'screens/qr_scan_screen.dart';
import 'screens/about_screen.dart';
import 'widgets/sidebar_layout.dart';
import 'models/boardinghouse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'admin/screens/admin_main_screen.dart';
import 'admin/screens/admin_login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize shared preferences for mobile storage
  await SharedPreferences.getInstance();
  runApp(const BoardinghouseFinderApp());
}

class BoardinghouseFinderApp extends StatelessWidget {
  const BoardinghouseFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tagoloan Boardinghouse Finder',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF6E026F),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Color(0xFF6E026F),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF6E026F),
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          type: BottomNavigationBarType.fixed,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6E026F),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AdminConstants.cardRadius),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF6E026F),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AdminConstants.cardRadius),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: Color(0xFF6E026F), width: 2),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        chipTheme: ChipThemeData(
          backgroundColor: Colors.grey[200],
          selectedColor: const Color(0xFF6E026F),
          labelStyle: const TextStyle(color: Colors.white),
          secondaryLabelStyle: const TextStyle(color: Color(0xFF6E026F)),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AdminConstants.cardRadius * 4)),
        ),
      ),
      home: const MainScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return MaterialPageRoute(builder: (_) => const MainScreen());
          case '/detail':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => BoardinghouseDetailScreen(
                boardinghouse: args['boardinghouse'] as Boardinghouse,
                onFavoriteToggle: () {},
              ),
            );
          case '/favorites':
            return MaterialPageRoute(builder: (_) => const MainScreen(selectedScreen: 'favorites'));
          case '/map':
            return MaterialPageRoute(builder: (_) => const MainScreen(selectedScreen: 'map'));
          case '/qr-scan':
            return MaterialPageRoute(builder: (_) => const MainScreen(selectedScreen: 'qr-scan'));
          case '/about':
            return MaterialPageRoute(builder: (_) => const AboutScreen());
          case '/admin':
            return MaterialPageRoute(builder: (_) => const AdminLoginScreen());
          case '/admin/login':
            return MaterialPageRoute(builder: (_) => const AdminLoginScreen());
          case '/admin/dashboard':
            return MaterialPageRoute(builder: (_) => const AdminMainScreen());
          case '/admin/properties':
            return MaterialPageRoute(builder: (_) => const AdminMainScreen());
          case '/admin/bookings':
            return MaterialPageRoute(builder: (_) => const AdminMainScreen());
          case '/admin/analytics':
            return MaterialPageRoute(builder: (_) => const AdminMainScreen());
          case '/admin/settings':
            return MaterialPageRoute(builder: (_) => const AdminMainScreen());

          default:
            return MaterialPageRoute(builder: (_) => const MainScreen());
        }
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  final String selectedScreen;
  
  const MainScreen({super.key, this.selectedScreen = 'home'});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _currentScreen = 'home';
  
  @override
  void initState() {
    super.initState();
    _currentScreen = widget.selectedScreen;
  }

  Widget _getCurrentScreen() {
    switch (_currentScreen) {
      case 'home':
        return const HomeScreen();
      case 'map':
        return const MapScreen();
      case 'favorites':
        return const FavoritesScreen();
      case 'qr-scan':
        return const QrScanScreen();
      case 'about':
        return const AboutScreen();
      default:
        return const HomeScreen();
    }
  }

  String _getTitle() {
    switch (_currentScreen) {
      case 'home':
        return 'Home';
      case 'map':
        return 'Map';
      case 'favorites':
        return 'Favorites';
      case 'qr-scan':
        return 'Scan QR';
      case 'about':
        return 'About';
      default:
        return 'Home';
    }
  }

  void _navigateTo(String screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SidebarLayout(
      title: _getTitle(),
      onNavigate: _navigateTo,
      child: _getCurrentScreen(),
    );
  }
} 