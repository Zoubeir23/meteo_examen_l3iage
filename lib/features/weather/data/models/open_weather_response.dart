import 'package:json_annotation/json_annotation.dart';

import 'weather_model.dart';

part 'open_weather_response.g.dart';

/// Raw shape of OpenWeather's "current weather by city name" endpoint.
/// https://openweathermap.org/current
@JsonSerializable()
class OpenWeatherResponse {
  const OpenWeatherResponse({
    required this.name,
    required this.sys,
    required this.main,
    required this.weather,
    required this.wind,
    required this.coord,
  });

  factory OpenWeatherResponse.fromJson(Map<String, dynamic> json) =>
      _$OpenWeatherResponseFromJson(json);

  final String name;
  final OpenWeatherSys sys;
  final OpenWeatherMain main;
  final List<OpenWeatherCondition> weather;
  final OpenWeatherWind wind;
  final OpenWeatherCoord coord;

  Map<String, dynamic> toJson() => _$OpenWeatherResponseToJson(this);

  /// Flattens the raw API response into the app's shared [WeatherModel].
  WeatherModel toWeatherModel() => WeatherModel(
        cityName: name,
        countryCode: sys.country,
        temperature: main.temp,
        feelsLike: main.feelsLike,
        description: weather.isNotEmpty ? weather.first.description : '',
        iconCode: weather.isNotEmpty ? weather.first.icon : '01d',
        humidity: main.humidity,
        windSpeed: wind.speed,
        latitude: coord.lat,
        longitude: coord.lon,
        updatedAt: DateTime.now(),
      );
}

@JsonSerializable()
class OpenWeatherSys {
  const OpenWeatherSys({required this.country});

  factory OpenWeatherSys.fromJson(Map<String, dynamic> json) =>
      _$OpenWeatherSysFromJson(json);

  final String country;

  Map<String, dynamic> toJson() => _$OpenWeatherSysToJson(this);
}

@JsonSerializable()
class OpenWeatherMain {
  const OpenWeatherMain({
    required this.temp,
    required this.feelsLike,
    required this.humidity,
  });

  factory OpenWeatherMain.fromJson(Map<String, dynamic> json) =>
      _$OpenWeatherMainFromJson(json);

  final double temp;

  @JsonKey(name: 'feels_like')
  final double feelsLike;

  final int humidity;

  Map<String, dynamic> toJson() => _$OpenWeatherMainToJson(this);
}

@JsonSerializable()
class OpenWeatherCondition {
  const OpenWeatherCondition({required this.description, required this.icon});

  factory OpenWeatherCondition.fromJson(Map<String, dynamic> json) =>
      _$OpenWeatherConditionFromJson(json);

  final String description;
  final String icon;

  Map<String, dynamic> toJson() => _$OpenWeatherConditionToJson(this);
}

@JsonSerializable()
class OpenWeatherWind {
  const OpenWeatherWind({required this.speed});

  factory OpenWeatherWind.fromJson(Map<String, dynamic> json) =>
      _$OpenWeatherWindFromJson(json);

  final double speed;

  Map<String, dynamic> toJson() => _$OpenWeatherWindToJson(this);
}

@JsonSerializable()
class OpenWeatherCoord {
  const OpenWeatherCoord({required this.lat, required this.lon});

  factory OpenWeatherCoord.fromJson(Map<String, dynamic> json) =>
      _$OpenWeatherCoordFromJson(json);

  final double lat;
  final double lon;

  Map<String, dynamic> toJson() => _$OpenWeatherCoordToJson(this);
}
