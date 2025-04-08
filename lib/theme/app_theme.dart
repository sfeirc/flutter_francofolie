import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const primaryColor = Color(0xFF2196F3);
  static const secondaryColor = Color(0xFF03A9F4);
  static const accentColor = Color(0xFF00BCD4);
  static const backgroundColor = Color(0xFFF5F9FF);
  static const cardColor = Colors.white;
  static const textColor = Color(0xFF1A237E);
  static const subtitleColor = Color(0xFF546E7A);
  static const gradientStart = Color(0xFF2196F3);
  static const gradientEnd = Color(0xFF00BCD4);
  static const shimmerBaseColor = Color(0xFFE3F2FD);
  static const shimmerHighlightColor = Color(0xFFBBDEFB);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        background: backgroundColor,
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      cardTheme: CardTheme(
        color: cardColor,
        elevation: 2,
        shadowColor: primaryColor.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: TextTheme(
        headlineMedium: GoogleFonts.poppins(
          color: textColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: GoogleFonts.poppins(
          color: textColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: GoogleFonts.poppins(
          color: textColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: GoogleFonts.inter(
          color: textColor,
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.inter(
          color: textColor,
          fontSize: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          shadowColor: primaryColor.withOpacity(0.3),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: primaryColor.withOpacity(0.1),
        labelStyle: const TextStyle(color: primaryColor),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
} 