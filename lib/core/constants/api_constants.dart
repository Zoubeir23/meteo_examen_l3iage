/// Endpoints and shared constants for the OpenWeather API.
class ApiConstants {
  const ApiConstants._();

  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  /// How often the weather data for the 5 cities is refreshed while the
  /// progress gauge is filling up on the main screen.
  static const Duration pollingInterval = Duration(seconds: 5);
}
