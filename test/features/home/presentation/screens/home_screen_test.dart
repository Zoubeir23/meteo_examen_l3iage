import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meteo_examen_l3iage/core/theme/theme_controller.dart';
import 'package:meteo_examen_l3iage/features/home/presentation/screens/home_screen.dart';
import 'package:meteo_examen_l3iage/features/main/presentation/screens/main_screen.dart';
import 'package:provider/provider.dart';

void main() {
  setUpAll(() {
    // MainScreen (pushed by the start button) reads EnvConfig.openWeatherApiKey,
    // which needs dotenv to have been loaded at least once.
    dotenv.testLoad(fileInput: 'OPENWEATHER_API_KEY=test-key');
  });

  testWidgets("tapping the start button navigates to MainScreen", (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeController(),
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    await tester.tap(find.text("Lancer l'expérience"));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(MainScreen), findsOneWidget);
  });

  testWidgets('tapping the theme icon toggles ThemeController to dark mode', (tester) async {
    final themeController = ThemeController();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: themeController,
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    expect(themeController.isDarkMode, isFalse);

    await tester.tap(find.byIcon(Icons.light_mode));
    await tester.pump();

    expect(themeController.isDarkMode, isTrue);
    expect(find.byIcon(Icons.dark_mode), findsOneWidget);
  });
}
