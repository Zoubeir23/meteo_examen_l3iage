import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../weather/data/models/weather_model.dart';
import '../widgets/city_location_map.dart';

/// City detail screen: full weather info plus the city's exact location on
/// Google Maps. Reached by tapping a row in [WeatherDataTable].
class CityDetailScreen extends StatelessWidget {
  const CityDetailScreen({super.key, required this.weather});

  final WeatherModel weather;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeFormat = DateFormat.Hms();

    return Scaffold(
      appBar: AppBar(title: Text(weather.cityName)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Image.network(
                      weather.iconUrl,
                      width: 72,
                      height: 72,
                      errorBuilder: (_, _, _) => const Icon(Icons.cloud_outlined, size: 56),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${weather.temperature.round()}°C',
                            style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            weather.description,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _DetailRow(label: 'Ressenti', value: '${weather.feelsLike.round()}°C'),
                    _DetailRow(label: 'Humidité', value: '${weather.humidity}%'),
                    _DetailRow(label: 'Vent', value: '${weather.windSpeed.toStringAsFixed(1)} m/s'),
                    _DetailRow(
                      label: 'Mise à jour',
                      value: timeFormat.format(weather.updatedAt),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Localisation', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            SizedBox(
              height: 260,
              child: CityLocationMap(
                cityName: weather.cityName,
                latitude: weather.latitude,
                longitude: weather.longitude,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
