import 'package:flutter/material.dart';

/// Shared color palette for the light and dark themes.
///
/// Visual language borrows the bold, high-contrast, generously-rounded
/// style of https://socrousty.com (Libre Franklin type, punchy accent on a
/// black/white base) — swapped to a sky-blue/amber palette that fits a
/// weather app instead of their brand pink.
class AppColors {
  const AppColors._();

  static const Color skyBlue = Color(0xFF2F6FED);
  static const Color skyBlueDark = Color(0xFF5B93FF);
  static const Color sunAmber = Color(0xFFFFB020);

  static const Color pureBlack = Color(0xFF0A0A0A);
  static const Color pureWhite = Color(0xFFFFFFFF);

  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF3F5F9);

  static const Color darkBackground = Color(0xFF0A0C10);
  static const Color darkSurface = Color(0xFF15181F);

  static const Color error = Color(0xFFE5484D);
}
