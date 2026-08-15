// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherModel _$WeatherModelFromJson(Map<String, dynamic> json) => WeatherModel(
  cityName: json['cityName'] as String,
  countryCode: json['countryCode'] as String,
  temperature: (json['temperature'] as num).toDouble(),
  feelsLike: (json['feelsLike'] as num).toDouble(),
  description: json['description'] as String,
  iconCode: json['iconCode'] as String,
  humidity: (json['humidity'] as num).toInt(),
  windSpeed: (json['windSpeed'] as num).toDouble(),
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$WeatherModelToJson(WeatherModel instance) =>
    <String, dynamic>{
      'cityName': instance.cityName,
      'countryCode': instance.countryCode,
      'temperature': instance.temperature,
      'feelsLike': instance.feelsLike,
      'description': instance.description,
      'iconCode': instance.iconCode,
      'humidity': instance.humidity,
      'windSpeed': instance.windSpeed,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
