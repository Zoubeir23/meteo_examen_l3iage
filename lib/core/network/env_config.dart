import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Reads secrets from the `.env` file loaded at app startup.
///
/// See `.env.example` at the project root for the expected keys.
class EnvConfig {
  const EnvConfig._();

  static String get openWeatherApiKey =>
      dotenv.env['OPENWEATHER_API_KEY'] ?? '';

  static bool get hasValidApiKey =>
      openWeatherApiKey.isNotEmpty && openWeatherApiKey != 'your_api_key_here';
}
