import 'package:flutter/material.dart';

import '../../../weather/data/models/weather_model.dart';

/// Interactive table of the 5 cities' weather. Tapping a row is meant to
/// open the city detail / map screen — wire [onCityTap] to the navigation
/// module's route for that screen.
class WeatherDataTable extends StatelessWidget {
  const WeatherDataTable({super.key, required this.cities, required this.onCityTap});

  final List<WeatherModel> cities;
  final ValueChanged<WeatherModel> onCityTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Ville')),
            DataColumn(label: Text('')),
            DataColumn(label: Text('Température')),
            DataColumn(label: Text('Description')),
            DataColumn(label: Text('Humidité')),
          ],
          rows: cities
              .map(
                (city) => DataRow(
                  onSelectChanged: (_) => onCityTap(city),
                  cells: [
                    DataCell(Text(city.cityName, style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ))),
                    DataCell(
                      Image.network(
                        city.iconUrl,
                        width: 32,
                        height: 32,
                        errorBuilder: (_, __, ___) => const Icon(Icons.cloud_outlined, size: 24),
                      ),
                    ),
                    DataCell(Text('${city.temperature.round()}°C')),
                    DataCell(Text(city.description)),
                    DataCell(Text('${city.humidity}%')),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
