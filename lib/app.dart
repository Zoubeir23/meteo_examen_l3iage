import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/home/presentation/screens/home_screen.dart';

class WeatherExamApp extends StatelessWidget {
  const WeatherExamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeController(),
      child: Consumer<ThemeController>(
        builder: (context, themeController, _) {
          return MaterialApp(
            title: 'Météo Examen L3IAGE',
            debugShowCheckedModeBanner: false,
            themeMode: themeController.themeMode,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
