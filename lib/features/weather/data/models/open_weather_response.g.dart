// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_weather_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenWeatherResponse _$OpenWeatherResponseFromJson(Map<String, dynamic> json) =>
    OpenWeatherResponse(
      name: json['name'] as String,
      sys: OpenWeatherSys.fromJson(json['sys'] as Map<String, dynamic>),
      main: OpenWeatherMain.fromJson(json['main'] as Map<String, dynamic>),
      weather: (json['weather'] as List<dynamic>)
          .map((e) => OpenWeatherCondition.fromJson(e as Map<String, dynamic>))
          .toList(),
      wind: OpenWeatherWind.fromJson(json['wind'] as Map<String, dynamic>),
      coord: OpenWeatherCoord.fromJson(json['coord'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OpenWeatherResponseToJson(
  OpenWeatherResponse instance,
) => <String, dynamic>{
  'name': instance.name,
  'sys': instance.sys,
  'main': instance.main,
  'weather': instance.weather,
  'wind': instance.wind,
  'coord': instance.coord,
};

OpenWeatherSys _$OpenWeatherSysFromJson(Map<String, dynamic> json) =>
    OpenWeatherSys(country: json['country'] as String);

Map<String, dynamic> _$OpenWeatherSysToJson(OpenWeatherSys instance) =>
    <String, dynamic>{'country': instance.country};

OpenWeatherMain _$OpenWeatherMainFromJson(Map<String, dynamic> json) =>
    OpenWeatherMain(
      temp: (json['temp'] as num).toDouble(),
      feelsLike: (json['feels_like'] as num).toDouble(),
      humidity: (json['humidity'] as num).toInt(),
    );

Map<String, dynamic> _$OpenWeatherMainToJson(OpenWeatherMain instance) =>
    <String, dynamic>{
      'temp': instance.temp,
      'feels_like': instance.feelsLike,
      'humidity': instance.humidity,
    };

OpenWeatherCondition _$OpenWeatherConditionFromJson(
  Map<String, dynamic> json,
) => OpenWeatherCondition(
  description: json['description'] as String,
  icon: json['icon'] as String,
);

Map<String, dynamic> _$OpenWeatherConditionToJson(
  OpenWeatherCondition instance,
) => <String, dynamic>{
  'description': instance.description,
  'icon': instance.icon,
};

OpenWeatherWind _$OpenWeatherWindFromJson(Map<String, dynamic> json) =>
    OpenWeatherWind(speed: (json['speed'] as num).toDouble());

Map<String, dynamic> _$OpenWeatherWindToJson(OpenWeatherWind instance) =>
    <String, dynamic>{'speed': instance.speed};

OpenWeatherCoord _$OpenWeatherCoordFromJson(Map<String, dynamic> json) =>
    OpenWeatherCoord(
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
    );

Map<String, dynamic> _$OpenWeatherCoordToJson(OpenWeatherCoord instance) =>
    <String, dynamic>{'lat': instance.lat, 'lon': instance.lon};
