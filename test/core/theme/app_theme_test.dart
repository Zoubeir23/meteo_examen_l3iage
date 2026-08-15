import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meteo_examen_l3iage/core/theme/app_colors.dart';
import 'package:meteo_examen_l3iage/core/theme/app_theme.dart';

void main() {
  setUpAll(() {
    // Avoid real network font fetches in the test sandbox.
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('light theme uses the exact brand palette as primary/secondary/tertiary', (
    tester,
  ) async {
    late ColorScheme scheme;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Builder(
          builder: (context) {
            scheme = Theme.of(context).colorScheme;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(scheme.primary, AppColors.brandPink);
    expect(scheme.secondary, AppColors.brandBlue);
    expect(scheme.tertiary, AppColors.brandGold);
    expect(AppTheme.light.scaffoldBackgroundColor, AppColors.lightBackground);
  });

  testWidgets('dark theme uses the exact brand palette on a near-black background', (
    tester,
  ) async {
    late ColorScheme scheme;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: Builder(
          builder: (context) {
            scheme = Theme.of(context).colorScheme;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(scheme.primary, AppColors.brandPink);
    expect(scheme.secondary, AppColors.brandBlue);
    expect(scheme.tertiary, AppColors.brandGold);
    expect(AppTheme.dark.scaffoldBackgroundColor, AppColors.darkBackground);
  });
}
