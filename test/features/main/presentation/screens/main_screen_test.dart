import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meteo_examen_l3iage/features/detail/presentation/screens/city_detail_screen.dart';
import 'package:meteo_examen_l3iage/features/main/presentation/screens/main_screen.dart';
import 'package:meteo_examen_l3iage/features/weather/data/models/open_weather_response.dart';
import 'package:meteo_examen_l3iage/features/weather/data/repositories/weather_repository.dart';

import '../../../weather/data/support/fake_weather_api_service.dart';

/// Advances through one full [WeatherRepository.watchAllCitiesWeather] poll
/// cycle (default: 3 polls, 5s apart) inside the fake-async test clock.
Future<void> _settlePolling(WidgetTester tester) async {
  await tester.pump();
  for (var i = 0; i < 2; i++) {
    await tester.pump(const Duration(seconds: 5));
    await tester.pump();
  }
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
