import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:meteo_examen_l3iage/core/theme/app_theme.dart';
import 'package:meteo_examen_l3iage/core/theme/theme_controller.dart';
import 'package:meteo_examen_l3iage/features/home/presentation/screens/home_screen.dart';

void main() {
  testWidgets('HomeScreen shows welcome message and start button', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeController(),
        child: MaterialApp(theme: AppTheme.light, home: const HomeScreen()),
      ),
    );

    expect(find.text('Bienvenue !'), findsOneWidget);
    expect(find.text("Lancer l'expérience"), findsOneWidget);
  });
}
