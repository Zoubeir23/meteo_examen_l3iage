import '../models/weather_model.dart';

/// Outcome of a call to [WeatherRepository.fetchAllCitiesWeather], so the UI
/// can render a loaded table, a retryable error message, or a loading state
/// without inspecting exception types directly.
sealed class WeatherFetchResult {
  const WeatherFetchResult();
}

class WeatherFetchSuccess extends WeatherFetchResult {
  const WeatherFetchSuccess(this.cities);

  final List<WeatherModel> cities;
}

class WeatherFetchFailure extends WeatherFetchResult {
  const WeatherFetchFailure(this.message);

  /// User-facing error message, ready to display next to a retry button.
  final String message;
}
