import 'package:meteo_examen_l3iage/features/weather/data/datasources/weather_api_service.dart';
import 'package:meteo_examen_l3iage/features/weather/data/models/open_weather_response.dart';

/// Test double for [WeatherApiService] that delegates to a handler instead
/// of performing real HTTP calls, so [WeatherRepository] can be tested in
/// isolation.
class FakeWeatherApiService implements WeatherApiService {
  FakeWeatherApiService(this.handler);

  final Future<OpenWeatherResponse> Function(String cityQuery) handler;

  int callCount = 0;

  @override
  Future<OpenWeatherResponse> getCurrentWeatherByCityName(
    String cityQuery,
    String apiKey, {
    String units = 'metric',
  }) {
    callCount++;
    return handler(cityQuery);
  }
}

/// Builds a minimal, valid [OpenWeatherResponse] JSON payload for [cityName],
/// useful as a stand-in success response in repository tests.
Map<String, dynamic> buildOpenWeatherJson(String cityName) => {
      'name': cityName,
      'sys': {'country': 'XX'},
      'main': {'temp': 20.0, 'feels_like': 20.0, 'humidity': 50},
      'weather': [
        {'description': 'clear sky', 'icon': '01d'},
      ],
      'wind': {'speed': 1.0},
      'coord': {'lat': 0.0, 'lon': 0.0},
    };
