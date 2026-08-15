import 'package:flutter/material.dart';

/// Shared color palette for the light and dark themes.
///
/// Matches the exact brand palette of https://socrousty.com: punchy pink
/// accent, gold and blue secondary accents, on a pure black/white base.
class AppColors {
  const AppColors._();

  static const Color brandPink = Color(0xFFFF008E);
  static const Color brandGold = Color(0xFFFFD65A);
  static const Color brandBlue = Color(0xFF0099FF);

  static const Color pureBlack = Color(0xFF0A0A0A);
  static const Color pureWhite = Color(0xFFFFFFFF);

  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF3F5F9);

  static const Color darkBackground = Color(0xFF101010);
  static const Color darkSurface = Color(0xFF1A1A1A);

  static const Color error = Color(0xFFE5484D);
}
