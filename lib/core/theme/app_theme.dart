import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Light and dark [ThemeData] for the app. Keep this file as the single
/// source of truth for visual identity so every screen stays consistent.
class AppTheme {
  const AppTheme._();

  static ThemeData get light => _themeFrom(
        brightness: Brightness.light,
        colorScheme: ColorScheme.light(
          primary: AppColors.brandPink,
          onPrimary: AppColors.pureWhite,
          secondary: AppColors.brandBlue,
          onSecondary: AppColors.pureWhite,
          tertiary: AppColors.brandGold,
          onTertiary: AppColors.pureBlack,
          surface: AppColors.lightSurface,
          onSurface: AppColors.pureBlack,
          error: AppColors.error,
        ),
        background: AppColors.lightBackground,
        surface: AppColors.lightSurface,
      );

  static ThemeData get dark => _themeFrom(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: AppColors.brandPink,
          onPrimary: AppColors.pureWhite,
          secondary: AppColors.brandBlue,
          onSecondary: AppColors.pureWhite,
          tertiary: AppColors.brandGold,
          onTertiary: AppColors.pureBlack,
          surface: AppColors.darkSurface,
          onSurface: AppColors.pureWhite,
          error: AppColors.error,
        ),
        background: AppColors.darkBackground,
        surface: AppColors.darkSurface,
      );

  static ThemeData _themeFrom({
    required Brightness brightness,
    required ColorScheme colorScheme,
    required Color background,
    required Color surface,
  }) {
    final baseTextTheme = GoogleFonts.libreFranklinTextTheme(
      brightness == Brightness.dark
          ? ThemeData(brightness: Brightness.dark).textTheme
          : ThemeData(brightness: Brightness.light).textTheme,
    );

    // Bold, oversized headline scale — the "big confident type" signature
    // borrowed from the reference site's hero sections.
    final textTheme = baseTextTheme.copyWith(
      headlineLarge: baseTextTheme.headlineLarge?.copyWith(
        fontWeight: FontWeight.w900,
        letterSpacing: -0.5,
      ),
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w900,
        letterSpacing: -0.5,
      ),
      titleLarge: baseTextTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
      titleMedium: baseTextTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme.copyWith(error: AppColors.error, surface: surface),
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: colorScheme.primary.withValues(alpha: 0.4),
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          textStyle: textTheme.titleMedium,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          side: BorderSide(color: colorScheme.primary, width: 1.5),
          textStyle: textTheme.titleMedium,
        ),
      ),
      dataTableTheme: DataTableThemeData(
        headingRowColor: WidgetStateProperty.all(colorScheme.surfaceContainerHigh),
        dataRowColor: WidgetStateProperty.all(surface),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
