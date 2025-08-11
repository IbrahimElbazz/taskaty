import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppConfig {
  static const String appName = 'Taskaty';

  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('ar', 'SA'),
  ];

  // Default locale
  static const Locale defaultLocale = Locale('en', 'US');

  // iOS-style color scheme
  static const Color primaryColor = Color(0xFF007AFF); // iOS Blue
  static const Color secondaryColor = Color(0xFF5856D6); // iOS Purple
  static const Color accentColor = Color(0xFFFF9500); // iOS Orange
  static const Color successColor = Color(0xFF34C759); // iOS Green
  static const Color warningColor = Color(0xFFFF9500); // iOS Orange
  static const Color errorColor = Color(0xFFFF3B30); // iOS Red
  static const Color backgroundColor = Color(0xFFF2F2F7); // iOS Light Gray
  static const Color cardColor = Color(0xFFFFFFFF); // White
  static const Color textPrimaryColor = Color(0xFF000000); // Black
  static const Color textSecondaryColor = Color(0xFF8E8E93); // iOS Gray
  static const Color borderColor = Color(0xFFC6C6C8); // iOS Light Gray

  // Dark mode colors
  static const Color darkBackgroundColor = Color(0xFF000000); // Black
  static const Color darkCardColor = Color(0xFF1C1C1E); // iOS Dark Gray
  static const Color darkTextPrimaryColor = Color(0xFFFFFFFF); // White
  static const Color darkTextSecondaryColor = Color(0xFF8E8E93); // iOS Gray
  static const Color darkBorderColor = Color(0xFF38383A); // iOS Dark Gray

  // Theme configuration for Material (fallback)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true, 
        elevation: 0,
        backgroundColor: cardColor,
        foregroundColor: textPrimaryColor,
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      scaffoldBackgroundColor: backgroundColor,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true, 
        elevation: 0,
        backgroundColor: darkCardColor,
        foregroundColor: darkTextPrimaryColor,
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        color: darkCardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      scaffoldBackgroundColor: darkBackgroundColor,
    );
  }

  // Cupertino theme configuration
  static CupertinoThemeData get cupertinoLightTheme {
    return const CupertinoThemeData(
      primaryColor: primaryColor,
      brightness: Brightness.light,
      scaffoldBackgroundColor: backgroundColor,
      barBackgroundColor: cardColor,
      textTheme: CupertinoTextThemeData(
        primaryColor: primaryColor,
        textStyle: TextStyle(
          color: textPrimaryColor,
          fontSize: 17,
          fontWeight: FontWeight.w400,
        ),
        navTitleTextStyle: TextStyle(
          color: textPrimaryColor,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        navLargeTitleTextStyle: TextStyle(
          color: textPrimaryColor,
          fontSize: 34,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  static CupertinoThemeData get cupertinoDarkTheme {
    return const CupertinoThemeData(
      primaryColor: primaryColor,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackgroundColor,
      barBackgroundColor: darkCardColor,
      textTheme: CupertinoTextThemeData(
        primaryColor: primaryColor,
        textStyle: TextStyle(
          color: darkTextPrimaryColor,
          fontSize: 17,
          fontWeight: FontWeight.w400,
        ),
        navTitleTextStyle: TextStyle(
          color: darkTextPrimaryColor,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        navLargeTitleTextStyle: TextStyle(
          color: darkTextPrimaryColor,
          fontSize: 34,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // Screen util configuration
  static void initScreenUtil(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(375, 812), // iPhone X design size
      minTextAdapt: true,
      splitScreenMode: true,
    );
  }

  // iOS-style spacing
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  static const double paddingXXL = 48.0;

  // iOS-style border radius
  static const double radiusS = 6.0;
  static const double radiusM = 8.0;
  static const double radiusL = 12.0;
  static const double radiusXL = 16.0;
  static const double radiusXXL = 24.0;
}
