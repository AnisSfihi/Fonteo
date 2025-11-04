import 'dart:convert';
import 'package:aqua_sense/models/water_source.dart';
import 'package:diacritic/diacritic.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

// api_water_source.dart
// Quelques utilitaires pour récupérer des points d'eau depuis OpenStreetMap
// (via Overpass). Fichier volontairement simple : import / helpers / fetch.

// --- Petites fonctions d'aide
// Ici : heuristique simple pour ignorer les noms non signifiants
bool isInvalidSourceName(String name) {
  final upper = removeDiacritics(name.toUpperCase());
  return upper.contains("VS") ||
      upper.contains("DN") ||
      upper.contains("ADE") ||
      upper.contains("VD") ||
      upper.contains("VANNE") ||
      upper.contains("CHAMBRE") ||
      upper.contains("VIDANGE") ||
      upper.contains("PIQUAGE") ||
      upper.contains("BRANCHEMENT") ||
      upper.contains("ROBINET") ||
      upper.contains("HAMMAM") ||
      upper.contains("HEMMAM") ||
      upper.contains("POLICE") ||
      upper.contains("MECANICIEN");
}

// --- Requête Overpass
// Construction et envoi de la requête, puis parsing des résultats
Future<List<WaterSource>> fetchWaterSources(LatLng center) async {
  // Rayon approximatif autour du centre (en degrés) — ajustable si besoin
  final double delta = 0.4; // ≈ 40 km

    // Requête Overpass : on cherche puits, sources naturelles, points d'eau
    // destinés à la consommation et fontaines.
    final String query = """
      [out:json];
      (
        node
        ["man_made"="water_well"]
        (${center.latitude - delta},${center.longitude - delta},${center.latitude + delta},${center.longitude + delta});

        node
        ["natural"="spring"]
        (${center.latitude - delta},${center.longitude - delta},${center.latitude + delta},${center.longitude + delta});
      
        node
        ["amenity"="drinking_water"]
        (${center.latitude - delta},${center.longitude - delta},${center.latitude + delta},${center.longitude + delta});
        
        node
        ["amenity"="fountain"]
        (${center.latitude - delta},${center.longitude - delta},${center.latitude + delta},${center.longitude + delta});      
      
      );
      out;
    """;

  // Envoi de la requête au serveur public Overpass
  final response = await http.post(
    Uri.parse('https://overpass-api.de/api/interpreter'),
    body: {'data': query},
  );

  if (response.statusCode == 200) {
  final data = jsonDecode(utf8.decode(response.bodyBytes));
  final elements = data['elements'] as List<dynamic>;
    return elements
        .map((e) {
          final lat = e['lat'];
          final lon = e['lon'];
          // On essaie plusieurs tags pour récupérer un nom lisible,
          // sinon on utilise un fallback simple.
          final name =
              e['tags']?['name'] ??
              e['tags']?['name:fr'] ??
              e['tags']?['name:en'] ??
              e['tags']?['name:ar'] ??
              e['tags']?['name:kab'] ??
              e['tags']?['designation'] ??
              e['tags']?['source'] ??
              e['tags']?['operator'] ??
              e['tags']?['ref'] ??
              "Source d'eau";
          return WaterSource(location: LatLng(lat, lon), name: name);
        })
        // On filtre ensuite les noms qui semblent non significatifs
        .where((source) => !isInvalidSourceName(source.name))
        .toList();
  } else {
    // Problème réseau / serveur Overpass
    throw Exception("Erreur de chargement des sources d'eau");
  }
}
