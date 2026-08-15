import 'package:flutter_test/flutter_test.dart';
import 'package:meteo_examen_l3iage/features/weather/data/models/weather_model.dart';

void main() {
  final weather = WeatherModel(
    cityName: 'Dakar',
    countryCode: 'SN',
    temperature: 29.5,
    feelsLike: 31.2,
    description: 'ciel dégagé',
    iconCode: '01d',
    humidity: 60,
    windSpeed: 3.4,
    latitude: 14.6928,
    longitude: -17.4467,
    updatedAt: DateTime.utc(2026, 8, 15, 10, 30),
  );

  test('toJson/fromJson round-trips without losing data', () {
    final restored = WeatherModel.fromJson(weather.toJson());

    expect(restored.cityName, weather.cityName);
    expect(restored.countryCode, weather.countryCode);
    expect(restored.temperature, weather.temperature);
    expect(restored.feelsLike, weather.feelsLike);
    expect(restored.description, weather.description);
    expect(restored.iconCode, weather.iconCode);
    expect(restored.humidity, weather.humidity);
    expect(restored.windSpeed, weather.windSpeed);
    expect(restored.latitude, weather.latitude);
    expect(restored.longitude, weather.longitude);
    expect(restored.updatedAt, weather.updatedAt);
  });

  test('iconUrl builds the OpenWeather icon URL from iconCode', () {
    expect(weather.iconUrl, 'https://openweathermap.org/img/wn/01d@2x.png');
  });
}
