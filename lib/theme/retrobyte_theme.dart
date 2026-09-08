import 'package:flutter/material.dart';

class RetroByteTheme {
  // Light mode color palette
  static const Color lightBackground = Color(0xFFF5F7FA);
  static const Color lightPrimary = Color(0xFF2196F3); // Arcade Blue
  static const Color lightSecondary = Color(0xFFF50057); // Neon Magenta Action
  static const Color lightSurface = Colors.white;
  static const Color lightCardBorder = Color(0xFF90CAF9);

  // Dark mode color palette
  static const Color darkBackground = Color(0xFF07090E); // Pitch Black / Deep Space
  static const Color darkPrimary = Color(0xFF00E5FF); // Neon Arcade Cyan
  static const Color darkSecondary = Color(0xFFF50057); // Neon Magenta Action
  static const Color darkSurface = Color(0xFF131722); // Deep Charcoal
  static const Color darkCardBorder = Color(0xFF00E5FF);

  static ThemeData light() {
    final colorScheme = ColorScheme.light(
      primary: lightPrimary,
      secondary: lightSecondary,
      surface: lightSurface,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: const Color(0xFF131722),
      surfaceContainerLowest: Colors.white,
      surfaceContainerHighest: const Color(0xFFE8EDF5),
      outline: const Color(0xFF8B95A5),
      error: const Color(0xFFD32F2F),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: lightBackground,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: lightPrimary,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: lightCardBorder, width: 1.5),
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w900,
          color: Color(0xFF10141E),
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: Color(0xFF10141E),
        ),
        titleMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: Color(0xFF10141E),
        ),
        bodyMedium: TextStyle(
          fontSize: 13,
          height: 1.35,
          color: Color(0xFF5A6275),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightSecondary,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: const TextStyle(color: Color(0xFF8B95A5), fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: lightCardBorder, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: lightCardBorder, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: lightPrimary, width: 2),
        ),
      ),
    );
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.dark(
      primary: darkPrimary,
      secondary: darkSecondary,
      surface: darkSurface,
      onPrimary: const Color(0xFF03070E),
      onSecondary: Colors.white,
      onSurface: const Color(0xFFF3F5FA),
      surfaceContainerLowest: Colors.white,
      surfaceContainerHighest: const Color(0xFF1C2230),
      outline: const Color(0xFF6B7485),
      error: const Color(0xFFEF5350),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: darkBackground,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.black,
        foregroundColor: darkPrimary,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
          color: darkPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: darkCardBorder.withValues(alpha: 0.45),
            width: 1.5,
          ),
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w900,
          color: Color(0xFFF3F5FA),
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: Color(0xFFF3F5FA),
        ),
        titleMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: Color(0xFFF3F5FA),
        ),
        bodyMedium: TextStyle(
          fontSize: 13,
          height: 1.35,
          color: Color(0xFFA6AFBF),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkSecondary,
          foregroundColor: Colors.white,
          elevation: 3,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF10141D),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: const TextStyle(color: Color(0xFF6B7485), fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: darkCardBorder.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: darkCardBorder.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: darkPrimary, width: 2),
        ),
      ),
    );
  }
}