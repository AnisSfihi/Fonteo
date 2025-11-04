import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:latlong2/latlong.dart';
import '../models/mesures.dart';

// latest_mesure.dart
// Récupère la dernière mesure d'une source d'eau depuis Firebase

// --- Lecture dernière mesure
// Cherche dans la base les mesures d'une source à ces coordonnées.
// Renvoie la plus récente, ou null si rien trouvé.
Future<Mesures?> fetchLastMesure(LatLng sourceLocation) async {
  final dbRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: dotenv.env['FIREBASE_DB_URL'],
  ).ref("mesures");

  final snapshot = await dbRef.get();

  if (snapshot.exists) {
    final data = snapshot.value as Map;

    for (var entry in data.entries) {
      final sourceData = entry.value as Map;

      final lat = sourceData['lat']?.toDouble();
      final lon = sourceData['lon']?.toDouble();
      print('Source lat: $lat, lon: $lon');
      print(
        'Paramètre lat: ${sourceLocation.latitude.toStringAsFixed(5)}, lon: ${sourceLocation.longitude.toStringAsFixed(5)}',
      );

      // On arrondit à 5 décimales pour la comparaison (précision ~1m)
      if (lat == double.parse(sourceLocation.latitude.toStringAsFixed(5))  &&
          lon == double.parse(sourceLocation.longitude.toStringAsFixed(5)))  {
        // Source trouvée ! On extrait toutes ses mesures
        final mesuresList =
            sourceData.entries
                .where((e) => e.value is Map)
                .map((e) => Mesures.fromMap(e.value))
                .toList();

        if (mesuresList.isNotEmpty) {
          // On prend la plus récente
          mesuresList.sort((a, b) => b.time.compareTo(a.time));
          return mesuresList.first;
        }
      }
    }
  }

  return null;
}
