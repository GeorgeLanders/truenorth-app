import 'package:flutter/material.dart';

class AppTheme {
  // ── TrueNorth V4: Warm Amethyst + Rose Gold ──
  // Deeper, warmer background
  static const Color deepSpace = Color(0xFF0A0615);
  static const Color deepPurple = Color(0xFF160C2A);
  static const Color darkNavy = Color(0xFF0F0A20);

  // Primary - warm amethyst (richer, more feminine)
  static const Color primaryPurple = Color(0xFF9B59B6);
  static const Color primaryLight = Color(0xFFC39BD3);

  // Rose gold - the new warm accent
  static const Color roseGold = Color(0xFFE8A87C);
  static const Color roseGoldLight = Color(0xFFF5D5C0);

  // Secondary - warm coral/pink (softer than hot coral)
  static const Color warmCoral = Color(0xFFE8625E);
  static const Color warmCoralLight = Color(0xFFF4A7A7);
  static const Color blushPink = Color(0xFFF4B8B8);

  // Accents
  static const Color warmGold = Color(0xFFF0C27A);  // warmer gold
  static const Color cyanTeal = Color(0xFF7EC8E3);   // softer teal-cyan
  static const Color vibrantGreen = Color(0xFF6EE7B7); // softer mint-green

  // Cream - warm white for text containers
  static const Color creamWhite = Color(0xFFFFF8F0);

  // Glass - warmer effect
  static const Color glassWhite = Color(0x14FFFFFF);
  static const Color glassWhiteMed = Color(0x1EFFFFFF);
  static const Color glassWhiteHi = Color(0x2AFFFFFF);
  static const Color glassRose = Color(0x1AF5D5C0); // rose-tinted glass

  // Text
  static const Color textPrimary = Color(0xFFFFF8F0); // warm white
  static const Color textSecondary = Color(0xCCFFF8F0);
  static const Color textMuted = Color(0x88FFF8F0);

  // Gradient backgrounds - warmer contrast
  static const List<Color> bgGradient = [
    Color(0xFF0A0615),
    Color(0xFF160C2A),
    Color(0xFF0F0A20),
  ];

  // Blob colors - warmer, more saturated with rose gold
  static const List<Color> blobColors = [
    Color(0xFF9B59B6),  // warm amethyst
    Color(0xFFE8A87C),  // rose gold
    Color(0xFFE8625E),  // warm coral
    Color(0xFFF4B8B8),  // blush pink
    Color(0xFF7EC8E3),  // soft teal
  ];

  // ── Theme Data ──
  
  // ── Backward Compatibility ──
  static const Color deepNavy = deepSpace;
  static const Color softSand = textSecondary;
  static const Color warmAmber = warmGold;
  static const Color darkTeal = cyanTeal;
  static const Color softMint = vibrantGreen;
  static const Color charcoal = Color(0xFF2D2D2D);
  static const Color glassBorder = Color(0x1AFFFFFF);
  
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: deepSpace,
      primaryColor: primaryPurple,
      colorScheme: const ColorScheme.dark(
        primary: primaryPurple,
        secondary: warmCoral,
        tertiary: warmGold,
        surface: glassWhite,
        error: warmCoral,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF0F0B20),
        selectedItemColor: roseGold,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 20,
      ),
      cardTheme: CardThemeData(
        color: glassWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: textPrimary),
        bodyMedium: TextStyle(color: textSecondary),
        labelLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: glassWhiteMed,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryPurple, width: 2),
        ),
        labelStyle: const TextStyle(color: textSecondary),
        hintStyle: const TextStyle(color: textMuted),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPurple,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          shadowColor: primaryPurple.withValues(alpha: 0.6),
        ),
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: primaryPurple,
        thumbColor: primaryPurple,
        overlayColor: Color(0x298B5CF6),
        valueIndicatorColor: primaryPurple,
        valueIndicatorTextStyle: TextStyle(color: Colors.white),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primaryPurple;
          return Colors.grey;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primaryPurple.withValues(alpha: 0.5);
          return Colors.grey.withValues(alpha: 0.3);
        }),
      ),
    );
  }
}
