import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meteo_examen_l3iage/core/constants/api_constants.dart';
import 'package:meteo_examen_l3iage/core/theme/theme_controller.dart';
import 'package:meteo_examen_l3iage/features/home/presentation/screens/home_screen.dart';
import 'package:meteo_examen_l3iage/features/main/presentation/screens/main_screen.dart';
import 'package:meteo_examen_l3iage/features/weather/data/models/open_weather_response.dart';
import 'package:meteo_examen_l3iage/features/weather/data/repositories/weather_repository.dart';
import 'package:provider/provider.dart';

import '../../../weather/data/support/fake_weather_api_service.dart';

void main() {
  testWidgets("tapping the start button navigates to MainScreen", (tester) async {
    // Inject a fake repository so MainScreen's initial poll uses deterministic
    // test data instead of issuing real OpenWeather HTTP requests.
    final repository = WeatherRepository(
      apiService: FakeWeatherApiService(
        (cityQuery) async => OpenWeatherResponse.fromJson(buildOpenWeatherJson(cityQuery)),
      ),
      apiKey: 'test-key',
    );

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeController(),
        child: MaterialApp(home: HomeScreen(mainScreenRepository: repository)),
      ),
    );

    await tester.tap(find.text("Lancer l'expérience"));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(MainScreen), findsOneWidget);

    // Drain MainScreen's polling stream so no timers are left pending when
    // the test ends (it starts polling for real as soon as it's pushed),
    // and let its gauge AnimationController finish animating.
    for (var i = 0; i < ApiConstants.pollCount; i++) {
      await tester.pump(ApiConstants.pollingInterval);
      await tester.pump();
    }
    await tester.pumpAndSettle();
  });

  testWidgets(
    'tapping the home button on MainScreen returns to the home screen',
    (tester) async {
      final repository = WeatherRepository(
        apiService: FakeWeatherApiService(
          (cityQuery) async => OpenWeatherResponse.fromJson(buildOpenWeatherJson(cityQuery)),
        ),
        apiKey: 'test-key',
      );

      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => ThemeController(),
          child: MaterialApp(home: HomeScreen(mainScreenRepository: repository)),
        ),
      );

      await tester.tap(find.text("Lancer l'expérience"));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(MainScreen), findsOneWidget);

      // Drain the polling stream fully before navigating away: an
      // in-flight Future.delayed inside the stream would otherwise leave a
      // pending Timer when MainScreen is popped, failing the test.
      for (var i = 0; i < ApiConstants.pollCount; i++) {
        await tester.pump(ApiConstants.pollingInterval);
        await tester.pump();
      }
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.home_rounded));
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(MainScreen), findsNothing);
    },
  );

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
