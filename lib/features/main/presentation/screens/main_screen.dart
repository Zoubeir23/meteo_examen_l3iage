import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/env_config.dart';
import '../../../../core/widgets/api_error_view.dart';
import '../../../detail/presentation/screens/city_detail_screen.dart';
import '../../../weather/data/datasources/weather_api_service.dart';
import '../../../weather/data/models/weather_model.dart';
import '../../../weather/data/repositories/weather_fetch_result.dart';
import '../../../weather/data/repositories/weather_repository.dart';
import '../widgets/weather_data_table.dart';
import '../widgets/weather_progress_gauge.dart';

enum _LoadState { loading, success, error }

/// Main screen: fills the progress gauge in step with the real, repeated
/// OpenWeather polling ([WeatherRepository.watchAllCitiesWeather]), then
/// reveals the results table.
///
/// NOTE for the navigation/gauge owner: the gauge fill here is driven
/// directly by poll progress (`pollIndex / ApiConstants.pollCount`) rather
/// than a dedicated [AnimationController], and the loading messages rotate
/// one per poll. Swap in a smoother `AnimationController`-driven
/// interpolation between polls if desired — [WeatherProgressGauge] and
/// [WeatherRepository] are already decoupled from this wiring, so that
/// change should stay local to this file.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const _loadingMessages = [
    'Nous téléchargeons les données…',
    "C'est presque fini…",
    'Plus que quelques secondes avant le résultat…',
  ];

  late final WeatherRepository _repository = WeatherRepository(
    apiService: WeatherApiService(buildDioClient()),
    apiKey: EnvConfig.openWeatherApiKey,
  );

  _LoadState _state = _LoadState.loading;
  double _progress = 0;
  int _messageIndex = 0;
  List<WeatherModel> _cities = const [];
  String _errorMessage = '';

  StreamSubscription<WeatherFetchResult>? _pollSubscription;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  @override
  void dispose() {
    _pollSubscription?.cancel();
    super.dispose();
  }

  void _startLoading() {
    _pollSubscription?.cancel();

    setState(() {
      _state = _LoadState.loading;
      _progress = 0;
      _messageIndex = 0;
    });

    var pollIndex = 0;
    _pollSubscription = _repository.watchAllCitiesWeather().listen(
      (result) {
        if (!mounted) return;
        pollIndex++;

        switch (result) {
          case WeatherFetchSuccess(:final cities):
            setState(() {
              _cities = cities;
              _progress = pollIndex / ApiConstants.pollCount;
              _messageIndex = (pollIndex - 1) % _loadingMessages.length;
            });
          case WeatherFetchFailure(:final message):
            setState(() {
              _errorMessage = message;
              _state = _LoadState.error;
            });
        }
      },
      onDone: () {
        if (!mounted || _state == _LoadState.error) return;
        setState(() {
          _progress = 1;
          _state = _LoadState.success;
        });
      },
    );
  }

  void _openCityDetail(WeatherModel city) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => CityDetailScreen(weather: city)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Météo des 5 villes')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: WeatherProgressGauge(
                  progress: _progress,
                  loadingMessage: _loadingMessages[_messageIndex],
                  onRestart: _state == _LoadState.success ? _startLoading : null,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_state) {
      case _LoadState.loading:
        return const SizedBox.shrink();
      case _LoadState.error:
        return Center(
          child: ApiErrorView(message: _errorMessage, onRetry: _startLoading),
        );
      case _LoadState.success:
        return SingleChildScrollView(
          child: WeatherDataTable(cities: _cities, onCityTap: _openCityDetail),
        );
    }
  }
}
