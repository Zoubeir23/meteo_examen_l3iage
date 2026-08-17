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

/// Écran principal : anime la jauge de progression en cadence avec les
/// vrais sondages OpenWeather ([WeatherRepository.watchAllCitiesWeather]),
/// puis révèle le tableau des résultats.
///
/// La cible de progression (`pollIndex / ApiConstants.pollCount`) reste
/// entièrement dérivée du flux réel — seul l'affichage entre deux sondages
/// est interpolé en douceur via [_gaugeController], pas un minuteur
/// indépendant.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key, WeatherRepository? repository}) : _repository = repository;

  /// Injectable for tests; defaults to the real OpenWeather-backed
  /// repository when omitted.
  final WeatherRepository? _repository;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  static const _loadingMessages = [
    'Nous téléchargeons les données…',
    "C'est presque fini…",
    'Plus que quelques secondes avant le résultat…',
  ];

  /// Durée de l'interpolation visuelle entre deux sondages — largement
  /// inférieure à [ApiConstants.pollingInterval] pour ne jamais prendre de
  /// retard sur le prochain résultat réel.
  static const _gaugeAnimationDuration = Duration(milliseconds: 800);

  late final WeatherRepository _repository =
      widget._repository ??
      WeatherRepository(
        apiService: WeatherApiService(buildDioClient()),
        apiKey: EnvConfig.openWeatherApiKey,
      );

  late final AnimationController _gaugeController = AnimationController(
    vsync: this,
    duration: _gaugeAnimationDuration,
  );
  Animation<double> _gaugeAnimation = const AlwaysStoppedAnimation(0);

  _LoadState _state = _LoadState.loading;
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
    _gaugeController.dispose();
    super.dispose();
  }

  /// Anime la jauge de sa position actuelle vers [target] (0.0-1.0). Partir
  /// de la valeur courante (plutôt que de 0) évite tout saut si un nouveau
  /// sondage arrive pendant qu'une interpolation précédente tourne encore.
  Future<void> _animateGaugeTo(double target) async {
    setState(() {
      _gaugeAnimation = Tween<double>(begin: _gaugeAnimation.value, end: target)
          .animate(CurvedAnimation(parent: _gaugeController, curve: Curves.easeOutCubic));
    });
    try {
      await _gaugeController.forward(from: 0).orCancel;
    } on TickerCanceled {
      // Écran démonté ou nouveau cycle relancé pendant l'animation — sans effet.
    }
  }

  void _startLoading() {
    _pollSubscription?.cancel();
    _gaugeController.reset();

    setState(() {
      _state = _LoadState.loading;
      _messageIndex = 0;
      _gaugeAnimation = const AlwaysStoppedAnimation(0);
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
              _messageIndex = (pollIndex - 1) % _loadingMessages.length;
            });
            _animateGaugeTo(pollIndex / ApiConstants.pollCount);
          case WeatherFetchFailure(:final message):
            setState(() {
              _errorMessage = message;
              _state = _LoadState.error;
            });
        }
      },
      onDone: () async {
        if (!mounted || _state == _LoadState.error) return;
        // Attend la fin de l'animation avant de révéler le tableau, pour que
        // la jauge affiche bien 100 % au moment où les résultats apparaissent.
        await _animateGaugeTo(1);
        if (!mounted) return;
        setState(() => _state = _LoadState.success);
      },
    );
  }

  void _openCityDetail(WeatherModel city) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => CityDetailScreen(weather: city)),
    );
  }

  /// Revient directement à [HomeScreen], quelle que soit la profondeur de la
  /// pile de navigation courante (utile depuis la page de détail).
  void _goHome() => Navigator.of(context).popUntil((route) => route.isFirst);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Météo des 5 villes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_rounded),
            tooltip: "Retour à l'accueil",
            onPressed: _goHome,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: AnimatedBuilder(
                  animation: _gaugeAnimation,
                  builder: (context, _) => WeatherProgressGauge(
                    progress: _gaugeAnimation.value,
                    loadingMessage: _loadingMessages[_messageIndex],
                    onRestart: _state == _LoadState.success ? _startLoading : null,
                  ),
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
