import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Application font families.
///
/// Downloaded as offline .ttf assets in assets/fonts/.
class AppFonts {
  AppFonts._();

  /// Space Grotesk — headers, titles
  static const String header = 'SpaceGrotesk';

  /// IBM Plex Sans — body text (default)
  static const String body = 'IBMPlexSans';

  /// IBM Plex Mono — technical labels, IDs, timestamps
  static const String mono = 'IBMPlexMono';
}

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        fontFamily: AppFonts.body,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.azure,
          primary: AppColors.azure,
          secondary: AppColors.blueprint,
          error: AppColors.danger,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.paper,
        cardTheme: CardThemeData(
          color: AppColors.lightCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppColors.radiusCard),
            side: const BorderSide(color: AppColors.cardBorder),
          ),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: AppColors.azure,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.azure,
            foregroundColor: Colors.white,
            minimumSize: const Size(0, AppColors.minTouchHeight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppColors.radiusButton),
            ),
            elevation: 0,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.azure,
            side: const BorderSide(color: AppColors.azure),
            minimumSize: const Size(0, AppColors.minTouchHeight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppColors.radiusButton),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.lightCard,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppColors.radiusButton),
            borderSide: const BorderSide(color: AppColors.mist),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppColors.radiusButton),
            borderSide: const BorderSide(color: AppColors.mist),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppColors.radiusButton),
            borderSide: const BorderSide(color: AppColors.azure, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppColors.spacingSm,
            vertical: AppColors.spacingXs,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.azure,
          unselectedItemColor: AppColors.lightTextSecondary,
          backgroundColor: AppColors.lightCard,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontFamily: AppFonts.header,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.ink,
          ),
          headlineMedium: TextStyle(
            fontFamily: AppFonts.header,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
          ),
          titleLarge: TextStyle(
            fontFamily: AppFonts.header,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
          ),
          titleMedium: TextStyle(
            fontFamily: AppFonts.header,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.ink,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.ink,
          ),
          bodySmall: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: AppColors.lightTextSecondary,
          ),
          labelSmall: TextStyle(
            fontFamily: AppFonts.mono,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.muted,
            letterSpacing: 0.5,
          ),
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: AppFonts.body,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.azure,
          primary: AppColors.azure,
          secondary: AppColors.cyanGlow,
          error: AppColors.danger,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: AppColors.darkCanvas,
        cardTheme: CardThemeData(
          color: AppColors.darkCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppColors.radiusCard),
          ),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: AppColors.darkCard,
          foregroundColor: AppColors.darkTextPrimary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.azure,
            foregroundColor: Colors.white,
            minimumSize: const Size(0, AppColors.minTouchHeight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppColors.radiusButton),
            ),
            elevation: 0,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.azure,
            side: const BorderSide(color: AppColors.azure),
            minimumSize: const Size(0, AppColors.minTouchHeight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppColors.radiusButton),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.darkCard,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppColors.radiusButton),
            borderSide: const BorderSide(color: AppColors.darkBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppColors.radiusButton),
            borderSide: const BorderSide(color: AppColors.darkBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppColors.radiusButton),
            borderSide: const BorderSide(color: AppColors.azure, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppColors.spacingSm,
            vertical: AppColors.spacingXs,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.azure,
          unselectedItemColor:
              AppColors.darkTextSecondary.withValues(alpha: 0.6),
          backgroundColor: AppColors.darkCard,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontFamily: AppFonts.header,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.darkTextPrimary,
          ),
          headlineMedium: TextStyle(
            fontFamily: AppFonts.header,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.darkTextPrimary,
          ),
          titleLarge: TextStyle(
            fontFamily: AppFonts.header,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.darkTextPrimary,
          ),
          titleMedium: TextStyle(
            fontFamily: AppFonts.header,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.darkTextPrimary,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.darkTextPrimary,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.darkTextPrimary,
          ),
          bodySmall: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: AppColors.darkTextSecondary,
          ),
          labelSmall: TextStyle(
            fontFamily: AppFonts.mono,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.darkTextSecondary,
            letterSpacing: 0.5,
          ),
        ),
      );
}
