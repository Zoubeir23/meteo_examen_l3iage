import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // isOptional: true — a missing .env shouldn't crash the app on launch;
  // EnvConfig.openWeatherApiKey falls back to '' and the existing "clé API
  // invalide ou manquante" error screen already handles that gracefully.
  await dotenv.load(fileName: '.env', isOptional: true);
  runApp(const WeatherExamApp());
}
