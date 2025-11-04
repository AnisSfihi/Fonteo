import 'package:latlong2/latlong.dart';

// water_source.dart
// Modèle simple représentant une source d'eau validée
// (nom lisible et coordonnées GPS)

class WaterSource {
  final LatLng location;
  final String name;

  WaterSource({
    required this.location,
    required this.name,
  });
}