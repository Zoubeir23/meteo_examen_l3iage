import 'package:flutter_test/flutter_test.dart';
import 'package:meteo_examen_l3iage/features/weather/data/models/open_weather_response.dart';

void main() {
  // Trimmed real-shape sample from OpenWeather's "current weather" endpoint.
  final rawJson = <String, dynamic>{
    'name': 'Paris',
    'sys': {'country': 'FR'},
    'main': {'temp': 18.3, 'feels_like': 17.9, 'humidity': 72},
    'weather': [
      {'description': 'nuageux', 'icon': '03d'},
    ],
    'wind': {'speed': 4.1},
    'coord': {'lat': 48.8566, 'lon': 2.3522},
  };

  test('fromJson parses the nested OpenWeather response shape', () {
    final response = OpenWeatherResponse.fromJson(rawJson);

    expect(response.name, 'Paris');
    expect(response.sys.country, 'FR');
    expect(response.main.temp, 18.3);
    expect(response.main.feelsLike, 17.9);
    expect(response.main.humidity, 72);
    expect(response.weather.single.description, 'nuageux');
    expect(response.weather.single.icon, '03d');
    expect(response.wind.speed, 4.1);
    expect(response.coord.lat, 48.8566);
    expect(response.coord.lon, 2.3522);
  });

  test('toWeatherModel flattens the response into the shared WeatherModel shape', () {
    final weather = OpenWeatherResponse.fromJson(rawJson).toWeatherModel();

    expect(weather.cityName, 'Paris');
    expect(weather.countryCode, 'FR');
    expect(weather.temperature, 18.3);
    expect(weather.feelsLike, 17.9);
    expect(weather.description, 'nuageux');
    expect(weather.iconCode, '03d');
    expect(weather.humidity, 72);
    expect(weather.windSpeed, 4.1);
    expect(weather.latitude, 48.8566);
    expect(weather.longitude, 2.3522);
  });

  test('toWeatherModel falls back to a default icon when weather list is empty', () {
    final emptyWeatherJson = Map<String, dynamic>.from(rawJson)..['weather'] = <dynamic>[];

    final weather = OpenWeatherResponse.fromJson(emptyWeatherJson).toWeatherModel();

    expect(weather.description, '');
    expect(weather.iconCode, '01d');
  });
}
