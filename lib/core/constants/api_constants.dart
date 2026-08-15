/// Endpoints and shared constants for the OpenWeather API.
class ApiConstants {
  const ApiConstants._();

  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  /// How often the weather data for the 5 cities is refreshed while the
  /// progress gauge is filling up on the main screen.
  static const Duration pollingInterval = Duration(seconds: 5);

  /// How many times the 5 cities are polled before the gauge is considered
  /// full — satisfies the "appels API répétés toutes les quelques secondes"
  /// requirement (as opposed to a single one-shot fetch).
  static const int pollCount = 3;
}
