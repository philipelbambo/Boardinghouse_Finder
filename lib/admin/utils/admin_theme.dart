import 'package:flutter/material.dart';
import 'admin_constants.dart';

class AdminTheme {
  static ThemeData get theme {
    return ThemeData(
      primarySwatch: _createMaterialColor(AdminConstants.primaryColor),
      primaryColor: AdminConstants.primaryColor,
      scaffoldBackgroundColor: AdminConstants.backgroundColor,
      cardColor: AdminConstants.cardColor,
      
      textTheme: TextTheme(
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AdminConstants.textColor,
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AdminConstants.textColor,
          letterSpacing: -0.3,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AdminConstants.textColor,
          letterSpacing: -0.2,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AdminConstants.textColor,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AdminConstants.textSecondaryColor,
          height: 1.4,
        ),
      ),
      
      appBarTheme: AppBarTheme(
        backgroundColor: AdminConstants.cardColor,
        foregroundColor: AdminConstants.textColor,
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.1),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AdminConstants.textColor,
          letterSpacing: -0.3,
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AdminConstants.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ).copyWith(
          overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
            if (states.contains(MaterialState.hovered)) {
              return Colors.white.withOpacity(0.1);
            }
            if (states.contains(MaterialState.pressed)) {
              return Colors.white.withOpacity(0.2);
            }
            return null;
          }),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AdminConstants.textColor,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          side: BorderSide(color: AdminConstants.borderColor, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AdminConstants.primaryColor,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AdminConstants.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AdminConstants.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AdminConstants.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AdminConstants.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AdminConstants.errorColor, width: 2),
        ),
        filled: true,
        fillColor: AdminConstants.cardColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: TextStyle(
          color: AdminConstants.textSecondaryColor,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
      ),
      
      cardTheme: CardThemeData(
        elevation: 0,
        color: AdminConstants.cardColor,
        shadowColor: Colors.black.withOpacity(0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AdminConstants.cardRadius),
        ),
        margin: EdgeInsets.zero,
      ),
      
      dividerTheme: DividerThemeData(
        color: AdminConstants.borderColor,
        thickness: 1,
        space: 1,
      ),
      
      iconTheme: IconThemeData(
        color: AdminConstants.textSecondaryColor,
        size: 20,
      ),
      
      listTileTheme: ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        selectedTileColor: AdminConstants.primaryColor.withOpacity(0.08),
        selectedColor: AdminConstants.primaryColor,
      ),
      
      chipTheme: ChipThemeData(
        backgroundColor: AdminConstants.backgroundColor,
        deleteIconColor: AdminConstants.textSecondaryColor,
        labelStyle: TextStyle(
          color: AdminConstants.textColor,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide.none,
        ),
      ),
      
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.white;
          }
          return Colors.white;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return AdminConstants.primaryColor;
          }
          return AdminConstants.borderColor;
        }),
      ),
      
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return AdminConstants.primaryColor;
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return AdminConstants.primaryColor;
          }
          return AdminConstants.borderColor;
        }),
      ),
    );
  }
  
  // Helper method to create MaterialColor from a single color
  static MaterialColor _createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    
    return MaterialColor(color.value, swatch);
  }
}

// Custom decorations and shadows
class AdminDecorations {
  // Soft card shadow matching Facebook's design
  static BoxDecoration cardDecoration = BoxDecoration(
    color: AdminConstants.cardColor,
    borderRadius: BorderRadius.circular(AdminConstants.cardRadius),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 8,
        offset: Offset(0, 2),
      ),
    ],
  );
  
  // Subtle shadow for elevated elements
  static BoxDecoration elevatedDecoration = BoxDecoration(
    color: AdminConstants.cardColor,
    borderRadius: BorderRadius.circular(AdminConstants.cardRadius),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 4,
        offset: Offset(0, 1),
      ),
    ],
  );
  
  // Border decoration for outlined containers
  static BoxDecoration borderDecoration = BoxDecoration(
    color: AdminConstants.cardColor,
    borderRadius: BorderRadius.circular(AdminConstants.cardRadius),
    border: Border.all(color: AdminConstants.borderColor, width: 1),
  );
}