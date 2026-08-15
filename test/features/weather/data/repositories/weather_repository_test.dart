import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meteo_examen_l3iage/core/constants/app_cities.dart';
import 'package:meteo_examen_l3iage/features/weather/data/models/open_weather_response.dart';
import 'package:meteo_examen_l3iage/features/weather/data/repositories/weather_fetch_result.dart';
import 'package:meteo_examen_l3iage/features/weather/data/repositories/weather_repository.dart';

import '../support/fake_weather_api_service.dart';

DioException _unauthorizedError() => DioException(
      requestOptions: RequestOptions(path: '/weather'),
      response: Response(requestOptions: RequestOptions(path: '/weather'), statusCode: 401),
      type: DioExceptionType.badResponse,
    );

void main() {
  test('fetchAllCitiesWeather returns success with one entry per configured city', () async {
    final fakeApi = FakeWeatherApiService(
      (cityQuery) async => OpenWeatherResponse.fromJson(buildOpenWeatherJson(cityQuery)),
    );
    final repository = WeatherRepository(apiService: fakeApi, apiKey: 'test-key');

    final result = await repository.fetchAllCitiesWeather();

    expect(result, isA<WeatherFetchSuccess>());
    expect((result as WeatherFetchSuccess).cities, hasLength(kAppCities.length));
    expect(fakeApi.callCount, kAppCities.length);
  });

  test('fetchAllCitiesWeather returns a user-facing failure on a 401 response', () async {
    final fakeApi = FakeWeatherApiService((cityQuery) async => throw _unauthorizedError());
    final repository = WeatherRepository(apiService: fakeApi, apiKey: 'bad-key');

    final result = await repository.fetchAllCitiesWeather();

    expect(result, isA<WeatherFetchFailure>());
    expect((result as WeatherFetchFailure).message, contains('Clé API'));
  });

  test('fetchAllCitiesWeather returns a network-error message on connection timeout', () async {
    final fakeApi = FakeWeatherApiService(
      (cityQuery) async => throw DioException(
        requestOptions: RequestOptions(path: '/weather'),
        type: DioExceptionType.connectionTimeout,
      ),
    );
    final repository = WeatherRepository(apiService: fakeApi, apiKey: 'test-key');

    final result = await repository.fetchAllCitiesWeather();

    expect(result, isA<WeatherFetchFailure>());
    expect((result as WeatherFetchFailure).message, contains('expiré'));
  });

  test('fetchAllCitiesWeather returns a connectivity message on connectionError', () async {
    final fakeApi = FakeWeatherApiService(
      (cityQuery) async => throw DioException(
        requestOptions: RequestOptions(path: '/weather'),
        type: DioExceptionType.connectionError,
      ),
    );
    final repository = WeatherRepository(apiService: fakeApi, apiKey: 'test-key');

    final result = await repository.fetchAllCitiesWeather();

    expect(result, isA<WeatherFetchFailure>());
    expect((result as WeatherFetchFailure).message, contains('connexion'));
  });

  test('fetchAllCitiesWeather reports the status code for a non-401 server error', () async {
    final fakeApi = FakeWeatherApiService(
      (cityQuery) async => throw DioException(
        requestOptions: RequestOptions(path: '/weather'),
        response: Response(requestOptions: RequestOptions(path: '/weather'), statusCode: 500),
        type: DioExceptionType.badResponse,
      ),
    );
    final repository = WeatherRepository(apiService: fakeApi, apiKey: 'test-key');

    final result = await repository.fetchAllCitiesWeather();

    expect(result, isA<WeatherFetchFailure>());
    expect((result as WeatherFetchFailure).message, contains('500'));
  });

  test('fetchAllCitiesWeather falls back to a generic message on a non-Dio error', () async {
    final fakeApi = FakeWeatherApiService((cityQuery) async => throw StateError('boom'));
    final repository = WeatherRepository(apiService: fakeApi, apiKey: 'test-key');

    final result = await repository.fetchAllCitiesWeather();

    expect(result, isA<WeatherFetchFailure>());
    expect((result as WeatherFetchFailure).message, contains('inattendue'));
  });

  test('watchAllCitiesWeather emits pollCount results on repeated success', () async {
    final fakeApi = FakeWeatherApiService(
      (cityQuery) async => OpenWeatherResponse.fromJson(buildOpenWeatherJson(cityQuery)),
    );
    final repository = WeatherRepository(apiService: fakeApi, apiKey: 'test-key');

    final results = await repository
        .watchAllCitiesWeather(pollCount: 3, interval: Duration.zero)
        .toList();

    expect(results, hasLength(3));
    expect(results, everyElement(isA<WeatherFetchSuccess>()));
    expect(fakeApi.callCount, 3 * kAppCities.length);
  });

  test('watchAllCitiesWeather stops emitting after the first failure', () async {
    final fakeApi = FakeWeatherApiService((cityQuery) async => throw _unauthorizedError());
    final repository = WeatherRepository(apiService: fakeApi, apiKey: 'bad-key');

    final results = await repository
        .watchAllCitiesWeather(pollCount: 3, interval: Duration.zero)
        .toList();

    expect(results, hasLength(1));
    expect(results.single, isA<WeatherFetchFailure>());
  });

  test('watchAllCitiesWeather with pollCount 1 emits a single result and no delay', () async {
    final fakeApi = FakeWeatherApiService(
      (cityQuery) async => OpenWeatherResponse.fromJson(buildOpenWeatherJson(cityQuery)),
    );
    final repository = WeatherRepository(apiService: fakeApi, apiKey: 'test-key');

    final results = await repository
        .watchAllCitiesWeather(pollCount: 1, interval: const Duration(days: 1))
        .toList();

    expect(results, hasLength(1));
    expect(results.single, isA<WeatherFetchSuccess>());
  });

  test('watchAllCitiesWeather rejects a pollCount below 1', () async {
    final fakeApi = FakeWeatherApiService(
      (cityQuery) async => OpenWeatherResponse.fromJson(buildOpenWeatherJson(cityQuery)),
    );
    final repository = WeatherRepository(apiService: fakeApi, apiKey: 'test-key');

    await expectLater(
      repository.watchAllCitiesWeather(pollCount: 0).toList(),
      throwsArgumentError,
    );
  });

  test('watchAllCitiesWeather rejects a negative interval', () async {
    final fakeApi = FakeWeatherApiService(
      (cityQuery) async => OpenWeatherResponse.fromJson(buildOpenWeatherJson(cityQuery)),
    );
    final repository = WeatherRepository(apiService: fakeApi, apiKey: 'test-key');

    await expectLater(
      repository.watchAllCitiesWeather(interval: const Duration(seconds: -1)).toList(),
      throwsArgumentError,
    );
  });
}
