import 'package:flutter/material.dart';

/// Centralized theme configuration for CodeMiner app
/// Consistent brown/amber color scheme inspired by mining aesthetics
class AppTheme {
  // Primary Colors
  static const Color deepBrown = Color(0xFF5D4037);
  static const Color mediumBrown = Color(0xFF8D6E63);
  static const Color amberHighlight = Color(0xFFFFCC80);

  // Accent Colors
  static final Color darkBrown = Colors.brown.shade900;
  static final Color accentBrown = Colors.brown.shade700;
  static final Color buttonBrown = Colors.brown.shade600;
  static final Color amberAccent = Colors.amber.shade400;

  // Text Colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;

  // Background Gradient
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [deepBrown, mediumBrown, amberHighlight],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Get the main theme for the app
  static ThemeData get themeData {
    return ThemeData(
      fontFamily: 'PixelCraft',
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: deepBrown,
        brightness: Brightness.dark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkBrown,
        foregroundColor: textPrimary,
        iconTheme: const IconThemeData(color: textPrimary),
        titleTextStyle: const TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: accentBrown,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonBrown,
          foregroundColor: textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  /// Background container with gradient
  static Widget backgroundContainer({required Widget child}) {
    return Container(
      decoration: const BoxDecoration(gradient: backgroundGradient),
      child: child,
    );
  }
}
