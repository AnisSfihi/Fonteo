import 'package:latlong2/latlong.dart';

// history_model.dart
// Petit modèle pour garder une trace des fontaines consultées.
// Contient le nom, la position et la date où l'utilisateur a vu la source.

// --- Item d'historique
class HistoryItem {
  final String sourceName;
  final LatLng location;
  final DateTime viewedAt;

  HistoryItem({
    required this.sourceName,
    required this.location,
    required this.viewedAt,
  });
}
