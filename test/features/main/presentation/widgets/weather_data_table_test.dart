import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meteo_examen_l3iage/features/main/presentation/widgets/weather_data_table.dart';
import 'package:meteo_examen_l3iage/features/weather/data/models/weather_model.dart';

WeatherModel _weather(String city, {String countryCode = 'XX'}) => WeatherModel(
      cityName: city,
      countryCode: countryCode,
      temperature: 21,
      feelsLike: 21,
      description: 'ensoleillé',
      iconCode: '01d',
      humidity: 55,
      windSpeed: 2,
      latitude: 0,
      longitude: 0,
      updatedAt: DateTime(2026, 1, 1),
    );

void main() {
  testWidgets('renders one row per city with its temperature and description', (tester) async {
    final cities = [_weather('Dakar'), _weather('Paris')];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WeatherDataTable(cities: cities, onCityTap: (_) {}),
        ),
      ),
    );

    expect(find.text('Dakar'), findsOneWidget);
    expect(find.text('Paris'), findsOneWidget);
    expect(find.text('21°C'), findsNWidgets(2));
    expect(find.text('ensoleillé'), findsNWidgets(2));
  });

  testWidgets('shows each city\'s country code as a badge', (tester) async {
    final cities = [_weather('Dakar', countryCode: 'SN'), _weather('Paris', countryCode: 'FR')];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WeatherDataTable(cities: cities, onCityTap: (_) {}),
        ),
      ),
    );

    expect(find.text('SN'), findsOneWidget);
    expect(find.text('FR'), findsOneWidget);
  });

  testWidgets('tapping a row calls onCityTap with that city', (tester) async {
    final cities = [_weather('Dakar'), _weather('Paris')];
    WeatherModel? tapped;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WeatherDataTable(cities: cities, onCityTap: (city) => tapped = city),
        ),
      ),
    );

    await tester.tap(find.text('Paris'));
    await tester.pump();

    expect(tapped?.cityName, 'Paris');
  });
}
