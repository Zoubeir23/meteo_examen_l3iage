# Météo en direct — Examen Développement Mobile L3IAGE ISI 2026

Application Flutter qui récupère la météo en temps réel de 5 villes via l'API
OpenWeather, affiche une jauge de progression animée pendant le chargement,
puis présente les résultats dans un tableau interactif avec une page de
détail par ville incluant sa localisation sur Google Maps.

## Membres du groupe

- Zoubeir Ibrahima
- Djamal Taoufik

## Répartition du travail

| Périmètre | Responsable |
|---|---|
| Service API météo (Retrofit/Dio + OpenWeather), modèle de données `WeatherModel`, design (écrans, thème clair/sombre, tableau des 5 villes) | Zoubeir Ibrahima |
| Jauge de progression animée, messages dynamiques, navigation entre écrans, intégration Google Maps, gestion des erreurs + retry, bouton "Recommencer" | Djamal Taoufik |

## Stack technique

- Flutter 3.44 / Dart 3.12
- [`dio`](https://pub.dev/packages/dio) + [`retrofit`](https://pub.dev/packages/retrofit) pour les appels à l'API OpenWeather
- [`provider`](https://pub.dev/packages/provider) pour la gestion du thème clair/sombre
- [`google_fonts`](https://pub.dev/packages/google_fonts) pour la typographie
- [`google_maps_flutter`](https://pub.dev/packages/google_maps_flutter) pour la localisation sur la page de détail

## Structure du projet

```
lib/
  app.dart                        # MaterialApp, thème clair/sombre
  main.dart                       # Point d'entrée, chargement du .env
  core/
    constants/                    # Villes suivies, endpoints API
    network/                      # Client Dio, lecture de la clé API
    theme/                        # AppTheme (clair/sombre), ThemeController
    widgets/                      # Widgets partagés (ex: ApiErrorView)
  features/
    home/                         # Écran d'accueil
    main/                         # Écran principal (jauge + tableau météo)
    detail/                       # Page de détail ville + carte Google Maps
    weather/
      data/
        models/                  # WeatherModel (contrat partagé) + parsing OpenWeather
        datasources/             # WeatherApiService (Retrofit)
        repositories/            # WeatherRepository (appels + gestion d'erreurs)
```

Le modèle `WeatherModel` (`lib/features/weather/data/models/weather_model.dart`)
est le contrat de données partagé entre la couche API, le tableau et la page
de détail : `cityName`, `countryCode`, `temperature`, `feelsLike`,
`description`, `iconCode`, `humidity`, `windSpeed`, `latitude`, `longitude`,
`updatedAt`.

## Configuration

1. Copier `.env.example` vers `.env` à la racine du projet.
2. Renseigner une clé API OpenWeather gratuite : https://openweathermap.org/api
3. Pour Google Maps (page de détail), suivre la configuration par plateforme
   du package [`google_maps_flutter`](https://pub.dev/packages/google_maps_flutter#platform-specific-configuration)
   (clé API Android dans `android/app/src/main/AndroidManifest.xml`, clé iOS
   dans `ios/Runner/AppDelegate.swift`).

## Lancer le projet

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # génère les .g.dart (JSON + Retrofit)
flutter run
```

## Tests

```bash
flutter analyze
flutter test
flutter test --coverage   # génère coverage/lcov.info (≈84% sur le service API + design)
```

Couverture par unit tests (modèles, repository, polling), widget tests (tableau,
jauge, écrans d'accueil/détail/erreur) et un test d'intégration de bout en bout
sur `MainScreen` (chargement → tableau → détail, et cas d'erreur + retry).
