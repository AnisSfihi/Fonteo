import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

// get_route_polyline.dart
// Petit utilitaire pour récupérer la polyline (liste de LatLng)
// d'un itinéraire via OpenRouteService.

// --- Récupération de la polyline
// Appelle OpenRouteService avec la clé API (voir .env). Retourne une liste
// de LatLng représentant le tracé (vide en cas d'erreur).
Future<List<LatLng>> getRoutePolyline(
  LatLng start,
  LatLng end,
  String mode,
) async {
  try {
    final apiKey = dotenv.env['API_KEY'];
    final url = Uri.parse(
      'https://api.openrouteservice.org/v2/directions/$mode?api_key=$apiKey&start=${start.longitude},${start.latitude}&end=${end.longitude},${end.latitude}',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Les coordonnées OSM sont [lon, lat], on inverse pour LatLng
      final coords = data['features'][0]['geometry']['coordinates'] as List;
      return coords.map((point) => LatLng(point[1], point[0])).toList();
    } else {
      return [];
    }
  } catch (e) {
    // En cas d'exception on renvoie une liste vide — l'appelant gère ça
    return [];
  }
}