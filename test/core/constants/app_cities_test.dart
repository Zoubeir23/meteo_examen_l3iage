import 'package:flutter_test/flutter_test.dart';
import 'package:meteo_examen_l3iage/core/constants/app_cities.dart';

void main() {
  test('exposes exactly 5 distinct cities, as required by the spec', () {
    expect(kAppCities, hasLength(5));
    expect(kAppCities.map((city) => city.name).toSet(), hasLength(5));
  });

  test('query combines the city name and country code for the OpenWeather API', () {
    const city = AppCity(name: 'Dakar', countryCode: 'SN');

    expect(city.query, 'Dakar,SN');
  });
}
