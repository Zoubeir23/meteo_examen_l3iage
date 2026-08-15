/// The 5 cities whose weather is fetched and displayed by the app.
class AppCity {
  const AppCity({required this.name, required this.countryCode});

  final String name;
  final String countryCode;

  /// Query string expected by the OpenWeather "current weather" endpoint.
  String get query => '$name,$countryCode';
}

const List<AppCity> kAppCities = [
  AppCity(name: 'Dakar', countryCode: 'SN'),
  AppCity(name: 'Paris', countryCode: 'FR'),
  AppCity(name: 'New York', countryCode: 'US'),
  AppCity(name: 'Tokyo', countryCode: 'JP'),
  AppCity(name: 'Nairobi', countryCode: 'KE'),
];
