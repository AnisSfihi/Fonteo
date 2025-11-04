import 'dart:io';
import 'package:geolocator/geolocator.dart';

// wifi_location.dart
// Vérifications rapides de la connexion et du GPS
// (pour éviter les surprises pendant l'utilisation)

// --- Vérif de la connexion Internet
// Un simple ping vers example.com pour voir si on est en ligne
Future<bool> hasActiveInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } on SocketException catch (_) {
      return false;
    }
  }

  // --- Vérif des permissions GPS
  // Demande l'autorisation si pas déjà donnée
  // (renvoie false si refusé)
  Future<bool> checkLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }