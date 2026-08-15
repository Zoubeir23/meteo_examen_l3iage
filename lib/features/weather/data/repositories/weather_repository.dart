import 'package:dio/dio.dart';

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

  /// Fetches all 5 cities in parallel. Call this on a repeating timer to
  /// satisfy the "poll every few seconds" requirement while the gauge fills.
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
