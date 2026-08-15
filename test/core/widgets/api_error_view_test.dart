import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meteo_examen_l3iage/core/widgets/api_error_view.dart';

void main() {
  testWidgets('shows the error message and calls onRetry when tapped', (tester) async {
    var retried = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ApiErrorView(
            message: 'Clé API invalide ou manquante.',
            onRetry: () => retried = true,
          ),
        ),
      ),
    );

    expect(find.text('Clé API invalide ou manquante.'), findsOneWidget);

    await tester.tap(find.text('Réessayer'));
    await tester.pump();

    expect(retried, isTrue);
  });
}
