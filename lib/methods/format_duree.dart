import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// format_duree.dart
// Petites utilitaires pour gérer les temps et distances
// - récupération via API (OpenRouteService)
// - formatage lisible pour l'UI

// --- Temps de trajet (marche / voiture)
// Utilise OpenRouteService; nécessite une clé dans .env (API_KEY)
Future<double?> getTravelDuration(
  LatLng start,
  LatLng end,
  String mode, 
) async {
  final apiKey = dotenv.env['API_KEY'];
  final url = Uri.parse(
    'https://api.openrouteservice.org/v2/directions/$mode'
    '?api_key=$apiKey&start=${start.longitude},${start.latitude}&end=${end.longitude},${end.latitude}',
  );

  final response = await http.get(url);
  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    try {
      final durationInSeconds =
          data['features'][0]['properties']['segments'][0]['duration'];
      return durationInSeconds / 60;
    } catch (e) {
      return null;
    }
  } else {
        return null;
  }
}


// --- Formattage lisible d'une durée
// Retourne une chaîne adaptée (jours, heures, minutes, secondes)
String formatDuration(double durationInMinutes) {
  final totalSeconds = (durationInMinutes * 60).round();

  final days = totalSeconds ~/ 86400;
  final hours = (totalSeconds % 86400) ~/ 3600;
  final minutes = (totalSeconds % 3600) ~/ 60;
  final seconds = totalSeconds % 60;

  if (days > 0) {
    if (hours > 0 && minutes > 0) {
      return '${days}j ${hours}h ${minutes}min';
    } else if (hours > 0) {
      return '${days}j ${hours}h';
    } else if (minutes > 0) {
      return '${days}j ${minutes}min';
    } else {
      return '${days}j';
    }
  } else if (hours > 0) {
    if (minutes > 0 && seconds > 0) {
      return '${hours}h ${minutes}min ${seconds}s';
    } else if (minutes > 0) {
      return '${hours}h ${minutes}min';
    } else if (seconds > 0) {
      return '${hours}h ${seconds}s';
    } else {
      return '${hours}h';
    }
  } else if (minutes > 0) {
    if (seconds > 0) {
      return '${minutes}min ${seconds}s';
    } else {
      return '${minutes}min';
    }
  } else {
    return '${seconds}s';
  }
}



// --- Formattage des distances
// Affiche en km si >= 1000 m, sinon en mètres
String formatDistance(double distanceInMeters) {
  if (distanceInMeters >= 1000) {
    double distanceInKm = distanceInMeters / 1000;
    return '${distanceInKm.toStringAsFixed(2)} km';
  } else {
    return '${distanceInMeters.toStringAsFixed(0)} m';
  }
}



// --- Texte 'mis à jour il y a ...'
// Transforme une DateTime en phrase relative pour l'interface
String formatDurationFromDate(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);

  if (difference.inDays > 0) {
    return "Mise à jour il y a ${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}";
  } else if (difference.inHours > 0) {
    return "Mise à jour il y a ${difference.inHours} heure${difference.inHours > 1 ? 's' : ''}";
  } else if (difference.inMinutes > 0) {
    return "Mise à jour il y a ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}";
  } else {
    return "Mise à jour il y a quelques secondes";
  }
}

