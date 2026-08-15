import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meteo_examen_l3iage/core/theme/theme_controller.dart';

void main() {
  test('starts in system mode', () {
    expect(ThemeController().themeMode, ThemeMode.system);
  });

  test('toggleTheme switches between light and dark and notifies listeners', () {
    final controller = ThemeController();
    var notifications = 0;
    controller.addListener(() => notifications++);

    controller.toggleTheme();
    expect(controller.themeMode, ThemeMode.dark);
    expect(controller.isDarkMode, isTrue);

    controller.toggleTheme();
    expect(controller.themeMode, ThemeMode.light);
    expect(controller.isDarkMode, isFalse);

    expect(notifications, 2);
  });

  test('setThemeMode is a no-op when the mode is unchanged', () {
    final controller = ThemeController();
    controller.setThemeMode(ThemeMode.dark);
    var notifications = 0;
    controller.addListener(() => notifications++);

    controller.setThemeMode(ThemeMode.dark);

    expect(notifications, 0);
  });
}
