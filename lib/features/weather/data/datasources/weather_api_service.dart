import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/open_weather_response.dart';

part 'weather_api_service.g.dart';

/// Retrofit client for OpenWeather's "current weather" endpoint.
@RestApi()
abstract class WeatherApiService {
  factory WeatherApiService(Dio dio, {String baseUrl}) = _WeatherApiService;

  @GET('/weather')
  Future<OpenWeatherResponse> getCurrentWeatherByCityName(
    @Query('q') String cityQuery,
    @Query('appid') String apiKey, {
    @Query('units') String units = 'metric',
  });
}
