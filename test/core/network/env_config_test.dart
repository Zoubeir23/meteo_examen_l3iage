import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meteo_examen_l3iage/core/network/env_config.dart';

void main() {
  test('hasValidApiKey is false when the key is missing', () {
    dotenv.testLoad(fileInput: '');

    expect(EnvConfig.openWeatherApiKey, isEmpty);
    expect(EnvConfig.hasValidApiKey, isFalse);
  });

  test('hasValidApiKey is false for the unfilled placeholder value', () {
    dotenv.testLoad(fileInput: 'OPENWEATHER_API_KEY=your_api_key_here');

    expect(EnvConfig.hasValidApiKey, isFalse);
  });

  test('hasValidApiKey is true once a real key is configured', () {
    dotenv.testLoad(fileInput: 'OPENWEATHER_API_KEY=abc123');

    expect(EnvConfig.openWeatherApiKey, 'abc123');
    expect(EnvConfig.hasValidApiKey, isTrue);
  });
}
