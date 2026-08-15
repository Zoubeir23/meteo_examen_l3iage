import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Google Map centered on a city's coordinates with a single marker.
///
/// NOTE for the maps/navigation owner: this renders a real `GoogleMap`, but
/// the platform API keys (Android `local.properties` / `AndroidManifest`,
/// iOS `AppDelegate.swift`) still need to be configured per
/// https://pub.dev/packages/google_maps_flutter before this will render on
/// device — it will show a blank/gray area until then.
class CityLocationMap extends StatelessWidget {
  const CityLocationMap({
    super.key,
    required this.cityName,
    required this.latitude,
    required this.longitude,
  });

  final String cityName;
  final double latitude;
  final double longitude;

  @override
  Widget build(BuildContext context) {
    final position = LatLng(latitude, longitude);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: GoogleMap(
        initialCameraPosition: CameraPosition(target: position, zoom: 10),
        markers: {
          Marker(markerId: MarkerId(cityName), position: position, infoWindow: InfoWindow(title: cityName)),
        },
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
      ),
    );
  }
}
