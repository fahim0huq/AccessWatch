import 'package:flutter/material.dart';

class AppColors {
  // Primary Refined Palette
  static const Color background = Color(0xFF080D12);
  static const Color surface = Color(0xFF111A22);
  static const Color surfaceElevated = Color(0xFF17232D);
  static const Color border = Color(0xFF22303D);
  static const Color text = Color(0xFFF2F6F8);
  static const Color textMuted = Color(0xFF91A4B3);

  // Accent Colors
  static const Color accent = Color(0xFF35C9D0); // Cyan/Teal-blue
  static const Color accentSecondary = Color(0xFF4DA3FF); // Blue

  // Flood Depth Colors
  static const Color floodShallow = Color(0xFF7DD3FC);
  static const Color floodMedium = Color(0xFF38A0E8);
  static const Color floodDeep = Color(0xFF1D4ED8);

  // Status & Routes
  static const Color safestRoute = Color(0xFF38D996); // Green SPECIFICALLY for safest route
  static const Color highRisk = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF38BDF8);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        surface: AppColors.surface,
        onSurface: AppColors.text,
        error: AppColors.highRisk,
      ),
      fontFamily: 'Roboto',
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.text,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
