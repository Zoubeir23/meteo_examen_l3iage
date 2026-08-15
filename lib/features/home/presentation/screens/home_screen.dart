import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/theme_controller.dart';
import '../../../main/presentation/screens/main_screen.dart';
import '../../../weather/data/repositories/weather_repository.dart';

/// Welcome screen: greets the user and lets them start the weather
/// experience. Navigation to [MainScreen] is a starting point — the final
/// routing/back-stack behavior is owned by the navigation module.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, WeatherRepository? mainScreenRepository})
      : _mainScreenRepository = mainScreenRepository;

  /// Injectable for tests; forwarded to the pushed [MainScreen]. Defaults to
  /// null so [MainScreen] builds its own real, OpenWeather-backed repository.
  final WeatherRepository? _mainScreenRepository;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeController = context.watch<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Météo en direct'),
        actions: [
          IconButton(
            tooltip: 'Changer de thème',
            icon: Icon(themeController.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => context.read<ThemeController>().toggleTheme(),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.wb_sunny_rounded, size: 76, color: theme.colorScheme.primary),
                ),
                const SizedBox(height: 32),
                Text(
                  'Bienvenue !',
                  style: theme.textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  "Découvrez la météo en temps réel de 5 villes à travers le monde, "
                  'présentée avec une jauge de progression animée.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MainScreen(repository: _mainScreenRepository),
                      ),
                    ),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('Lancer l\'expérience'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
