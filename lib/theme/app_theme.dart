import 'package:flutter/material.dart';

class AppTheme {
  // ── TrueNorth V5: Vibrant Living Warmth ──
  // Background: rich dark with visible warm tones (NOT pitch black)
  static const Color deepSpace    = Color(0xFF120B1A);
  static const Color deepPurple   = Color(0xFF1E1235);
  static const Color darkNavy     = Color(0xFF15102A);

  // ── Primary palette (vibrant, alive) ──
  // Main brand: rich amethyst
  static const Color primaryPurple  = Color(0xFFB47AE8);
  static const Color primaryLight   = Color(0xFFD4A8F0);

  // Rose gold: warm feminine accent, used heavily
  static const Color roseGold       = Color(0xFFE8A87C);
  static const Color roseGoldLight  = Color(0xFFF5D5C0);

  // Coral: celebration / energy (not angry red)
  static const Color warmCoral      = Color(0xFFF07B72);
  static const Color warmCoralLight = Color(0xFFFFB0AA);
  static const Color blushPink      = Color(0xFFFFC0CB);

  // Accents
  static const Color warmGold       = Color(0xFFF5CC66);
  static const Color cyanTeal       = Color(0xFF6DD5C8);
  static const Color vibrantGreen   = Color(0xFF5FE8A0);

  // Warm white / cream
  static const Color creamWhite     = Color(0xFFFFF5E6);

  // ── Cards: VISIBLE colored glass (not invisible at 8%) ──
  static const Color glassWhite     = Color(0x35FFFFFF);     // was 0x14 — now 3x+ more visible
  static const Color glassWhiteMed  = Color(0x45FFFFFF);
  static const Color glassWhiteHi   = Color(0x55FFFFFF);
  static const Color glassRose      = Color(0x30F5D5C0);
  static const Color glassGold      = Color(0x25F5CC66);
  static const Color glassTeal      = Color(0x256DD5C8);
  static const Color glassPurple    = Color(0x25B47AE8);
  static const Color glassCoral     = Color(0x25F07B72);
  static const Color glassGreen     = Color(0x205FE8A0);

  // Text: bright and clear
  static const Color textPrimary    = Color(0xFFFFF5E6);
  static const Color textSecondary  = Color(0xDDFFF5E6);
  static const Color textMuted      = Color(0x88FFF5E6);

  // ── Background gradient: richer, more visible color ──
  static const List<Color> bgGradient = [
    Color(0xFF120B1A),
    Color(0xFF251540),
    Color(0xFF1A1230),
  ];

  // ── Blob colors: VISIBLE and vibrant ──
  static const List<Color> blobColors = [
    Color(0xFFB47AE8),  // amethyst
    Color(0xFFE8A87C),  // rose gold
    Color(0xFFF07B72),  // coral
    Color(0xFF6DD5C8),  // teal
    Color(0xFFF5CC66),  // gold
  ];

  // ── Per-tab accent colors (makes each tab feel distinct!) ──
  static const Color tabHome     = Color(0xFFB47AE8);  // amethyst
  static const Color tabMove     = Color(0xFF5FE8A0);  // green
  static const Color tabNourish  = Color(0xFFE8A87C);  // rose gold
  static const Color tabCoach    = Color(0xFF6DD5C8);  // teal

  // ── Backward compat (keep old constant names working) ──
  static const Color deepNavy = deepSpace;
  static const Color softSand     = textSecondary;
  static const Color warmAmber    = warmGold;
  static const Color darkTeal     = cyanTeal;
  static const Color softMint     = vibrantGreen;
  static const Color charcoal     = Color(0xFF2D2D2D);
  static const Color glassBorder  = Color(0x2AFFFFFF);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: deepSpace,
      primaryColor: primaryPurple,
      colorScheme: const ColorScheme.dark(
        primary: primaryPurple,
        secondary: roseGold,
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
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF0F0A1A),
        selectedItemColor: roseGold,
        unselectedItemColor: Color(0x66FFFFFF),
        type: BottomNavigationBarType.fixed,
        elevation: 24,
      ),
      cardTheme: CardThemeData(
        color: glassWhiteMed,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge:  TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 28),
        headlineMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.w700, fontSize: 22),
        bodyLarge:      TextStyle(color: textPrimary, fontSize: 16),
        bodyMedium:     TextStyle(color: textSecondary, fontSize: 14),
        labelLarge:    TextStyle(color: textPrimary, fontWeight: FontWeight.w600, fontSize: 15),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: glassWhiteMed,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: roseGold, width: 2),
        ),
        labelStyle: const TextStyle(color: textSecondary),
        hintStyle: const TextStyle(color: textMuted),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: roseGold,
          foregroundColor: Color(0xFF1A0A2A),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 10,
          shadowColor: roseGold.withValues(alpha: 0.5),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: roseGold,
        foregroundColor: Color(0xFF1A0A2A),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: roseGold,
        thumbColor: roseGold,
        overlayColor: roseGold.withValues(alpha: 0.2),
        valueIndicatorColor: roseGold,
        valueIndicatorTextStyle: const TextStyle(color: Color(0xFF1A0A2A)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return roseGold;
          return Colors.grey;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return roseGold.withValues(alpha: 0.4);
          return Colors.grey.withValues(alpha: 0.3);
        }),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        elevation: 12,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Color(0xFF1E1235),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0x22FFFFFF),
        thickness: 1,
      ),
    );
  }
}
