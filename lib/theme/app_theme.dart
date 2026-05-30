import 'package:flutter/material.dart';

class AppTheme {
  // ── TrueNorth V3: Super-Shiny Premium Palette ──
  // Deeper, more dramatic background
  static const Color deepSpace = Color(0xFF050515);
  static const Color deepPurple = Color(0xFF120825);
  static const Color darkNavy = Color(0xFF081525);

  // Primary - electric purple (more vibrant)
  static const Color primaryPurple = Color(0xFF8B5CF6);
  static const Color primaryLight = Color(0xFFB794FF);

  // Secondary - hot coral/pink (more saturated)
  static const Color warmCoral = Color(0xFFFF3366);
  static const Color warmCoralLight = Color(0xFFFF5C8A);

  // Accents - super vibrant
  static const Color warmGold = Color(0xFFFFB800);  // punchier gold
  static const Color cyanTeal = Color(0xFF00F5FF);   // bright neon cyan
  static const Color vibrantGreen = Color(0xFF00F593); // bright neon green

  // Glass - stronger effect
  static const Color glassWhite = Color(0x12FFFFFF);
  static const Color glassWhiteMed = Color(0x1EFFFFFF);
  static const Color glassWhiteHi = Color(0x2AFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xCCFFFFFF);
  static const Color textMuted = Color(0x88FFFFFF);

  // Gradient backgrounds - deeper contrast
  static const List<Color> bgGradient = [
    Color(0xFF050515),
    Color(0xFF120825),
    Color(0xFF081525),
  ];

  // 3D blob gradient colors - super saturated for maximum glow
  static const List<Color> blobColors = [
    Color(0xFF8B5CF6),  // electric purple
    Color(0xFFFF3366),  // hot coral
    Color(0xFFFFB800),  // bright gold
    Color(0xFF00F5FF),  // neon cyan
    Color(0xFF00F593),  // neon green
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
        backgroundColor: Color(0xFF0D0D25),
        selectedItemColor: warmCoral,
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
