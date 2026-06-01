import 'package:flutter/material.dart';

/// Surface/text colors that swap between light and dark mode.
/// Category accent colors (gold, green, category pastels) stay the same
/// because they read fine on both backgrounds.
class AppColors {
  final Color scaffold;
  final Color surface; // cards, headers, app bars
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color border;
  final Color searchFill;

  const AppColors({
    required this.scaffold,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.border,
    required this.searchFill,
  });

  static const light = AppColors(
    scaffold: Color(0xFFF0F4F8),
    surface: Colors.white,
    textPrimary: Color(0xFF1A2744),
    textSecondary: Color(0xFF64748B),
    textMuted: Color(0xFF94A3B8),
    border: Color(0xFFE2E8F0),
    searchFill: Color(0xFFF1F5F9),
  );

  static const dark = AppColors(
    scaffold: Color(0xFF0F172A),
    surface: Color(0xFF1E293B),
    textPrimary: Color(0xFFF1F5F9),
    textSecondary: Color(0xFF94A3B8),
    textMuted: Color(0xFF64748B),
    border: Color(0xFF334155),
    searchFill: Color(0xFF334155),
  );

  static AppColors of(bool dark) => dark ? AppColors.dark : AppColors.light;
}

/// Builds the MaterialApp theme for a given brightness.
ThemeData buildTheme(bool dark) {
  final c = AppColors.of(dark);
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    brightness: dark ? Brightness.dark : Brightness.light,
    scaffoldBackgroundColor: c.scaffold,
    cardColor: c.surface,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF2563EB),
      brightness: dark ? Brightness.dark : Brightness.light,
      surface: c.surface,
    ),
    cardTheme: CardThemeData(
      color: c.surface,
      elevation: dark ? 0 : 1,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: c.surface,
      foregroundColor: c.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 1,
      titleTextStyle: TextStyle(
        color: c.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: c.surface,
      indicatorColor: const Color(0xFF2563EB).withOpacity(dark ? 0.30 : 0.12),
    ),
  );
}
