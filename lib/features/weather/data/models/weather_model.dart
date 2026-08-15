import 'package:json_annotation/json_annotation.dart';

part 'weather_model.g.dart';

/// Weather snapshot for a single city, normalized from the OpenWeather
/// "current weather" API response into a flat, easy-to-consume shape.
///
/// This is the shared contract between the API layer, the results table,
/// and the city detail / map screen — field names are final, do not rename
/// without syncing with the rest of the team.
@JsonSerializable()
class WeatherModel {
  const WeatherModel({
    required this.cityName,
    required this.countryCode,
    required this.temperature,
    required this.feelsLike,
    required this.description,
    required this.iconCode,
    required this.humidity,
    required this.windSpeed,
    required this.latitude,
    required this.longitude,
    required this.updatedAt,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) =>
      _$WeatherModelFromJson(json);

  /// City display name, e.g. "Dakar".
  final String cityName;

  /// ISO 3166-1 alpha-2 country code, e.g. "SN".
  final String countryCode;

  /// Current temperature in Celsius.
  final double temperature;

  /// "Feels like" temperature in Celsius.
  final double feelsLike;

  /// Short weather description, e.g. "clear sky".
  final String description;

  /// OpenWeather icon code, e.g. "01d". Build the icon URL with
  /// `https://openweathermap.org/img/wn/$iconCode@2x.png`.
  final String iconCode;

  /// Humidity percentage (0-100).
  final int humidity;

  /// Wind speed in meters/second.
  final double windSpeed;

  /// Latitude, used to place the city marker on Google Maps.
  final double latitude;

  /// Longitude, used to place the city marker on Google Maps.
  final double longitude;

  /// Timestamp of this snapshot (local device time when it was fetched).
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => _$WeatherModelToJson(this);

  /// Convenience for the icon image URL shown in the table and detail page.
  String get iconUrl => 'https://openweathermap.org/img/wn/$iconCode@2x.png';
}
