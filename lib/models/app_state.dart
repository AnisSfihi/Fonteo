import 'package:aqua_sense/models/history_model.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../models/water_source.dart';

// app_state.dart
// Gestion de l'état global de l'app avec ChangeNotifier.
// On garde ici tout ce qui doit être partagé : position,
// sources d'eau, historique, etc.

class AppState extends ChangeNotifier {
  // --- Variables d'état principales
  // (notifyListeners() appelé à chaque changement)
  List<WaterSource> waterSources = [];
  bool isFetchingSources = false;
  LatLng? userLocation;
  LatLng? proposedLocation;
  String? lastSearchQuery;

  Map<String, double?> travelDurationCache = {};
  List<HistoryItem> history = [];

// --- Gestion de l'historique
// Ajoute une source visitée (évite les doublons)
void addToHistory(String sourceName, LatLng location) {
  // On vérifie d'abord si on l'a pas déjà vue
  final alreadyExists = history.any((item) =>
      item.sourceName == sourceName &&
      item.location.latitude == location.latitude &&
      item.location.longitude == location.longitude);

  if (!alreadyExists) {
    history.add(
      HistoryItem(
        sourceName: sourceName,
        location: location,
        viewedAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}

void clearHistory() {
  history.clear();
  notifyListeners();
}




  // --- Cache des temps de trajet
  // (évite de recalculer les mêmes itinéraires)
    void setTravelDuration(String key, double? value) {
      travelDurationCache[key] = value;
      notifyListeners();
    }

    double? getTravelDuration(String key) {
      return travelDurationCache[key];
    }

  // --- Gestion des sources d'eau trouvées
  void setWaterSources(List<WaterSource> sources) {
    waterSources = sources;
    notifyListeners();
  }

  // --- Position suggérée (via recherche/clic)
  void setProposedLocation(LatLng? location) {
    proposedLocation = location;
    notifyListeners();
  }

  // --- Dernière recherche tapée
  void setLastSearchQuery(String query) {
    lastSearchQuery = query;
    notifyListeners();
  }

  // --- État du chargement des sources
  // (pour afficher un loading si besoin)
  void setIsFetchingSources(bool value) {
    isFetchingSources = value;
    notifyListeners();
  }

  // --- Position GPS de l'utilisateur
  void setUserLocation(LatLng location) {
    userLocation = location;
    notifyListeners();
  }
}
