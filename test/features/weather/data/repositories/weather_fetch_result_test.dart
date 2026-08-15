import 'package:flutter_test/flutter_test.dart';
import 'package:meteo_examen_l3iage/features/weather/data/models/weather_model.dart';
import 'package:meteo_examen_l3iage/features/weather/data/repositories/weather_fetch_result.dart';

void main() {
  test('WeatherFetchSuccess carries the fetched cities', () {
    final weather = WeatherModel(
      cityName: 'Dakar',
      countryCode: 'SN',
      temperature: 28,
      feelsLike: 28,
      description: 'clear',
      iconCode: '01d',
      humidity: 50,
      windSpeed: 1,
      latitude: 0,
      longitude: 0,
      updatedAt: DateTime(2026),
    );

    const result = WeatherFetchSuccess([]);
    final withCity = WeatherFetchSuccess([weather]);

    expect(result.cities, isEmpty);
    expect(withCity.cities.single.cityName, 'Dakar');
    expect(result, isA<WeatherFetchResult>());
  });

  test('WeatherFetchFailure carries the user-facing message', () {
    const failure = WeatherFetchFailure('Clé API invalide ou manquante.');

    expect(failure.message, 'Clé API invalide ou manquante.');
    expect(failure, isA<WeatherFetchResult>());
  });
}
