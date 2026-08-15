import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meteo_examen_l3iage/features/detail/presentation/screens/city_detail_screen.dart';
import 'package:meteo_examen_l3iage/features/weather/data/models/weather_model.dart';

void main() {
  testWidgets('shows the city weather details', (tester) async {
    final weather = WeatherModel(
      cityName: 'Dakar',
      countryCode: 'SN',
      temperature: 29,
      feelsLike: 31,
      description: 'ciel dégagé',
      iconCode: '01d',
      humidity: 60,
      windSpeed: 3.4,
      latitude: 14.6928,
      longitude: -17.4467,
      updatedAt: DateTime(2026, 8, 15, 10, 30),
    );

    await tester.pumpWidget(MaterialApp(home: CityDetailScreen(weather: weather)));

    expect(find.text('Dakar'), findsOneWidget);
    expect(find.text('29°C'), findsOneWidget);
    expect(find.text('ciel dégagé'), findsOneWidget);
    expect(find.text('31°C'), findsOneWidget);
    expect(find.text('60%'), findsOneWidget);
    expect(find.text('3.4 m/s'), findsOneWidget);
    expect(find.text('Localisation'), findsOneWidget);
  });
}
