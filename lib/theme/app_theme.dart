import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the mobile resale calculation application.
/// Implements Professional Dark Slate theme with iOS-inspired design principles.
class AppTheme {
  AppTheme._();

  // Professional Dark Slate Color Palette
  static const Color primaryDark = Color(0xFF1C1C1E); // Deep charcoal background
  static const Color secondaryDark = Color(0xFF2C2C2E); // Elevated surface color
  static const Color accentBlue = Color(0xFF007AFF); // iOS blue for primary actions
  static const Color successGreen = Color(0xFF34C759); // Profit indication color
  static const Color warningOrange = Color(0xFFFF9500); // Break-even and low margin alerts
  static const Color errorRed = Color(0xFFFF3B30); // Input validation and calculation errors
  static const Color textPrimary = Color(0xFFFFFFFF); // High contrast white
  static const Color textSecondary = Color(0xFF8E8E93); // Muted gray for labels
  static const Color textTertiary = Color(0xFF48484A); // Subtle gray for timestamps
  static const Color surfaceBlack = Color(0xFF000000); // True black for maximum contrast
  
  // Additional supporting colors
  static const Color borderColor = Color(0xFF3A3A3C); // Minimal borders
  static const Color shadowColor = Color(0x33000000); // 20% opacity black shadows
  static const Color dividerColor = Color(0xFF3A3A3C);
  static const Color cardColor = Color(0xFF2C2C2E);
  static const Color dialogColor = Color(0xFF2C2C2E);

  /// Dark theme optimized for mobile resale calculation
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: accentBlue,
      onPrimary: textPrimary,
      primaryContainer: secondaryDark,
      onPrimaryContainer: textPrimary,
      secondary: secondaryDark,
      onSecondary: textPrimary,
      secondaryContainer: primaryDark,
      onSecondaryContainer: textSecondary,
      tertiary: accentBlue,
      onTertiary: textPrimary,
      tertiaryContainer: secondaryDark,
      onTertiaryContainer: textPrimary,
      error: errorRed,
      onError: textPrimary,
      surface: primaryDark,
      onSurface: textPrimary,
      onSurfaceVariant: textSecondary,
      outline: borderColor,
      outlineVariant: dividerColor,
      shadow: shadowColor,
      scrim: shadowColor,
      inverseSurface: textPrimary,
      onInverseSurface: primaryDark,
      inversePrimary: primaryDark,
    ),
    scaffoldBackgroundColor: primaryDark,
    cardColor: cardColor,
    dividerColor: dividerColor,
    
    // AppBar theme for professional presentation
    appBarTheme: AppBarTheme(
      backgroundColor: primaryDark,
      foregroundColor: textPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: -0.41,
      ),
      iconTheme: const IconThemeData(
        color: textPrimary,
        size: 24,
      ),
      actionsIconTheme: const IconThemeData(
        color: accentBlue,
        size: 24,
      ),
    ),
    
    // Card theme for calculation history and results
    cardTheme: CardTheme(
      color: cardColor,
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    
    // Bottom navigation for main app navigation
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: secondaryDark,
      selectedItemColor: accentBlue,
      unselectedItemColor: textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.12,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.12,
      ),
    ),
    
    // Floating action button for quick calculations
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: accentBlue,
      foregroundColor: textPrimary,
      elevation: 4,
      focusElevation: 6,
      hoverElevation: 6,
      highlightElevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    
    // Button themes for calculation actions
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: textPrimary,
        backgroundColor: accentBlue,
        disabledForegroundColor: textTertiary,
        disabledBackgroundColor: secondaryDark,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        minimumSize: const Size(88, 44),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.32,
        ),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: accentBlue,
        disabledForegroundColor: textTertiary,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        minimumSize: const Size(88, 44),
        side: const BorderSide(color: borderColor, width: 0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.32,
        ),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accentBlue,
        disabledForegroundColor: textTertiary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        minimumSize: const Size(64, 44),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.32,
        ),
      ),
    ),
    
    // Typography theme using Inter font family
    textTheme: _buildTextTheme(),
    
    // Input decoration for calculation fields
    inputDecorationTheme: InputDecorationTheme(
      fillColor: secondaryDark,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: borderColor, width: 0.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: borderColor, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: accentBlue, width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: errorRed, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: errorRed, width: 1),
      ),
      labelStyle: GoogleFonts.inter(
        color: textSecondary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: textTertiary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: GoogleFonts.inter(
        color: errorRed,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
    
    // Switch theme for settings
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentBlue;
        }
        return textSecondary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentBlue.withValues(alpha: 0.3);
        }
        return textTertiary.withValues(alpha: 0.3);
      }),
    ),
    
    // Checkbox theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentBlue;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(textPrimary),
      side: const BorderSide(color: borderColor, width: 0.5),
    ),
    
    // Radio theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentBlue;
        }
        return textSecondary;
      }),
    ),
    
    // Progress indicator theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: accentBlue,
      linearTrackColor: secondaryDark,
      circularTrackColor: secondaryDark,
    ),
    
    // Slider theme
    sliderTheme: SliderThemeData(
      activeTrackColor: accentBlue,
      thumbColor: accentBlue,
      overlayColor: accentBlue.withValues(alpha: 0.2),
      inactiveTrackColor: secondaryDark,
      trackHeight: 2,
    ),
    
    // Tab bar theme
    tabBarTheme: TabBarTheme(
      labelColor: textPrimary,
      unselectedLabelColor: textSecondary,
      indicatorColor: accentBlue,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.32,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.32,
      ),
    ),
    
    // Tooltip theme
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: surfaceBlack.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(4),
      ),
      textStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    ),
    
    // SnackBar theme for feedback
    snackBarTheme: SnackBarThemeData(
      backgroundColor: secondaryDark,
      contentTextStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: accentBlue,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 4,
    ),
    
    // List tile theme for calculation history
    listTileTheme: ListTileThemeData(
      tileColor: cardColor,
      selectedTileColor: secondaryDark,
      textColor: textPrimary,
      iconColor: textSecondary,
      selectedColor: accentBlue,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    
    // Divider theme
    dividerTheme: const DividerThemeData(
      color: dividerColor,
      thickness: 0.5,
      space: 1,
    ), dialogTheme: DialogThemeData(backgroundColor: dialogColor),
  );

  /// Light theme (minimal implementation for system compatibility)
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: accentBlue,
      onPrimary: textPrimary,
      primaryContainer: const Color(0xFFF0F0F0),
      onPrimaryContainer: primaryDark,
      secondary: const Color(0xFFF0F0F0),
      onSecondary: primaryDark,
      secondaryContainer: const Color(0xFFE0E0E0),
      onSecondaryContainer: primaryDark,
      tertiary: accentBlue,
      onTertiary: textPrimary,
      tertiaryContainer: const Color(0xFFF0F0F0),
      onTertiaryContainer: primaryDark,
      error: errorRed,
      onError: textPrimary,
      surface: textPrimary,
      onSurface: primaryDark,
      onSurfaceVariant: const Color(0xFF666666),
      outline: const Color(0xFFCCCCCC),
      outlineVariant: const Color(0xFFE0E0E0),
      shadow: const Color(0x1A000000),
      scrim: const Color(0x1A000000),
      inverseSurface: primaryDark,
      onInverseSurface: textPrimary,
      inversePrimary: accentBlue,
    ),
    scaffoldBackgroundColor: textPrimary,
    textTheme: _buildTextTheme(isLight: true),
  );

  /// Helper method to build text theme using Inter font family
  static TextTheme _buildTextTheme({bool isLight = false}) {
    final Color textColor = isLight ? primaryDark : textPrimary;
    final Color secondaryTextColor = isLight ? const Color(0xFF666666) : textSecondary;
    final Color tertiaryTextColor = isLight ? const Color(0xFF999999) : textTertiary;

    return TextTheme(
      // Display styles for large headings
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: -0.25,
        height: 1.12,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: 0,
        height: 1.16,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: 0,
        height: 1.22,
      ),
      
      // Headline styles for section headers
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textColor,
        letterSpacing: 0,
        height: 1.25,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textColor,
        letterSpacing: 0,
        height: 1.29,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textColor,
        letterSpacing: 0,
        height: 1.33,
      ),
      
      // Title styles for cards and dialogs
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0,
        height: 1.27,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.15,
        height: 1.50,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      
      // Body styles for main content
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: 0.5,
        height: 1.50,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: 0.25,
        height: 1.43,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondaryTextColor,
        letterSpacing: 0.4,
        height: 1.33,
      ),
      
      // Label styles for buttons and form elements
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: secondaryTextColor,
        letterSpacing: 0.5,
        height: 1.33,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: tertiaryTextColor,
        letterSpacing: 0.5,
        height: 1.45,
      ),
    );
  }
}