import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meteo_examen_l3iage/features/main/presentation/widgets/weather_progress_gauge.dart';

void main() {
  testWidgets('shows the percentage and loading message while in progress', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: WeatherProgressGauge(
            progress: 0.4,
            loadingMessage: 'Nous téléchargeons les données…',
          ),
        ),
      ),
    );

    expect(find.text('40%'), findsOneWidget);
    expect(find.text('Nous téléchargeons les données…'), findsOneWidget);
    expect(find.text('Recommencer'), findsNothing);
  });

  testWidgets('turns into a Recommencer button and calls onRestart once complete', (
    tester,
  ) async {
    var restarted = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WeatherProgressGauge(
            progress: 1.0,
            loadingMessage: 'peu importe',
            onRestart: () => restarted = true,
          ),
        ),
      ),
    );

    expect(find.text('Recommencer'), findsOneWidget);
    expect(find.text('Données prêtes !'), findsOneWidget);

    await tester.tap(find.text('Recommencer'));
    await tester.pump();

    expect(restarted, isTrue);
  });
}
