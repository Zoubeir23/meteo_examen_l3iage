import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meteo_examen_l3iage/core/constants/api_constants.dart';
import 'package:meteo_examen_l3iage/core/theme/theme_controller.dart';
import 'package:meteo_examen_l3iage/features/detail/presentation/screens/city_detail_screen.dart';
import 'package:meteo_examen_l3iage/features/home/presentation/screens/home_screen.dart';
import 'package:meteo_examen_l3iage/features/main/presentation/screens/main_screen.dart';
import 'package:meteo_examen_l3iage/features/main/presentation/widgets/weather_data_table.dart';
import 'package:meteo_examen_l3iage/features/weather/data/models/open_weather_response.dart';
import 'package:meteo_examen_l3iage/features/weather/data/repositories/weather_repository.dart';
import 'package:provider/provider.dart';

import '../../../weather/data/support/fake_weather_api_service.dart';

/// Advances through one full [WeatherRepository.watchAllCitiesWeather] poll
/// cycle (default: [ApiConstants.pollCount] polls, [ApiConstants.pollingInterval]
/// apart) inside the fake-async test clock, then lets the gauge's
/// AnimationController finish its final interpolation.
Future<void> _settlePolling(WidgetTester tester) async {
  await tester.pump();
  for (var i = 0; i < ApiConstants.pollCount - 1; i++) {
    await tester.pump(ApiConstants.pollingInterval);
    await tester.pump();
  }
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows the results table once polling completes successfully', (
    tester,
  ) async {
    final repository = WeatherRepository(
      apiService: FakeWeatherApiService(
        (cityQuery) async => OpenWeatherResponse.fromJson(
          buildOpenWeatherJson(cityQuery.split(',').first),
        ),
      ),
      apiKey: 'test-key',
    );

    await tester.pumpWidget(
      MaterialApp(home: MainScreen(repository: repository)),
    );
    await _settlePolling(tester);

    expect(find.text('Dakar'), findsOneWidget);
    expect(find.text('Paris'), findsOneWidget);
    expect(find.text('Recommencer'), findsOneWidget);
  });

  testWidgets(
    'keeps the results table hidden until the final gauge animation completes',
    (tester) async {
      final repository = WeatherRepository(
        apiService: FakeWeatherApiService(
          (cityQuery) async => OpenWeatherResponse.fromJson(
            buildOpenWeatherJson(cityQuery.split(',').first),
          ),
        ),
        apiKey: 'test-key',
      );

      await tester.pumpWidget(
        MaterialApp(home: MainScreen(repository: repository)),
      );

      await tester.pump();
      for (var i = 0; i < ApiConstants.pollCount - 1; i++) {
        await tester.pump(ApiConstants.pollingInterval);
        await tester.pump();
      }
      // Le dernier sondage vient d'arriver : la jauge anime encore vers
      // 100 %, le tableau ne doit pas apparaître avant la fin.
      expect(find.byType(WeatherDataTable), findsNothing);

      await tester.pumpAndSettle();
      expect(find.byType(WeatherDataTable), findsOneWidget);
    },
  );

  testWidgets('tapping a city row opens its detail screen', (tester) async {
    final repository = WeatherRepository(
      apiService: FakeWeatherApiService(
        (cityQuery) async => OpenWeatherResponse.fromJson(
          buildOpenWeatherJson(cityQuery.split(',').first),
        ),
      ),
      apiKey: 'test-key',
    );

    await tester.pumpWidget(
      MaterialApp(home: MainScreen(repository: repository)),
    );
    await _settlePolling(tester);

    await tester.tap(find.text('Dakar'));
    await tester.pumpAndSettle();

    expect(find.byType(CityDetailScreen), findsOneWidget);
  });

  testWidgets(
    'tapping the home button on the detail screen returns directly to the home screen',
    (tester) async {
      final repository = WeatherRepository(
        apiService: FakeWeatherApiService(
          (cityQuery) async => OpenWeatherResponse.fromJson(
            buildOpenWeatherJson(cityQuery.split(',').first),
          ),
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
      await _settlePolling(tester);

      await tester.tap(find.text('Dakar'));
      await tester.pumpAndSettle();
      expect(find.byType(CityDetailScreen), findsOneWidget);

      await tester.tap(find.byIcon(Icons.home_rounded));
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(MainScreen), findsNothing);
      expect(find.byType(CityDetailScreen), findsNothing);
    },
  );

  testWidgets(
    'shows the error view with a working retry button on API failure',
    (tester) async {
      final repository = WeatherRepository(
        apiService: FakeWeatherApiService(
          (cityQuery) async => throw DioException(
            requestOptions: RequestOptions(path: '/weather'),
            response: Response(
              requestOptions: RequestOptions(path: '/weather'),
              statusCode: 401,
            ),
            type: DioExceptionType.badResponse,
          ),
        ),
        apiKey: 'bad-key',
      );

      await tester.pumpWidget(
        MaterialApp(home: MainScreen(repository: repository)),
      );
      await tester.pump();

      expect(find.text('Clé API invalide ou manquante.'), findsOneWidget);

      await tester.tap(find.text('Réessayer'));
      await tester.pump();

      expect(find.text('Clé API invalide ou manquante.'), findsOneWidget);
    },
  );
}
