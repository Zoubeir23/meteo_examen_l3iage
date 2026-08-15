import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/app_cities.dart';
import '../datasources/weather_api_service.dart';
import 'weather_fetch_result.dart';

/// Fetches current weather for [kAppCities] and exposes it in the flat
/// [WeatherModel] shape shared with the rest of the app (gauge screen,
/// results table, city detail / map screen).
class WeatherRepository {
  WeatherRepository({required WeatherApiService apiService, required String apiKey})
      : _apiService = apiService,
        _apiKey = apiKey;

  final WeatherApiService _apiService;
  final String _apiKey;

  /// Polls all 5 cities' weather [pollCount] times, [interval] apart,
  /// satisfying the "appels API répétés toutes les quelques secondes"
  /// requirement. Emits one [WeatherFetchResult] per poll so the caller
  /// (gauge/progress UI) can advance in step with real network activity;
  /// stops early — without further emissions — on the first failure.
  Stream<WeatherFetchResult> watchAllCitiesWeather({
    int pollCount = ApiConstants.pollCount,
    Duration interval = ApiConstants.pollingInterval,
  }) async* {
    if (pollCount < 1) {
      throw ArgumentError.value(pollCount, 'pollCount', 'must be at least 1');
    }
    if (interval.isNegative) {
      throw ArgumentError.value(interval, 'interval', 'must not be negative');
    }
    for (var i = 0; i < pollCount; i++) {
      final result = await fetchAllCitiesWeather();
      yield result;
      if (result is WeatherFetchFailure) return;
      if (i < pollCount - 1) {
        await Future.delayed(interval);
      }
    }
  }

  /// Fetches all 5 cities in parallel once. Prefer [watchAllCitiesWeather]
  /// to satisfy the "poll every few seconds" requirement.
  Future<WeatherFetchResult> fetchAllCitiesWeather() async {
    try {
      final responses = await Future.wait(
        kAppCities.map(
          (city) => _apiService.getCurrentWeatherByCityName(city.query, _apiKey),
        ),
      );
      return WeatherFetchSuccess(
        responses.map((response) => response.toWeatherModel()).toList(),
      );
    } on DioException catch (error) {
      return WeatherFetchFailure(_messageFor(error));
    } catch (_) {
      return const WeatherFetchFailure(
        'Une erreur inattendue est survenue. Veuillez réessayer.',
      );
    }
  }

  String _messageFor(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'La connexion a expiré. Vérifiez votre réseau et réessayez.';
      case DioExceptionType.connectionError:
        return 'Impossible de contacter le serveur météo. Vérifiez votre connexion.';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) {
          return 'Clé API invalide ou manquante.';
        }
        return 'Le serveur météo a renvoyé une erreur ($statusCode).';
      default:
        return 'Le chargement des données météo a échoué. Réessayez.';
    }
  }
}
