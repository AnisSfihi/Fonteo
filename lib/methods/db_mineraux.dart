import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:latlong2/latlong.dart';

// db_mineraux.dart
// Petit utilitaire pour lire les analyses minérales d'une fontaine
// (on interroge Firestore et on retourne un map des éléments si trouvé).

// --- Lecture des données minérales en base
Future<Map<String, dynamic>?> fetchMineralDataByName(
  LatLng sourceLocation,
) async {
  try {
    // On cherche une fontaine dont les coordonnées correspondent
    // (on arrondit pour éviter les différences minuscules)
    final querySnapshot =
        await FirebaseFirestore.instance
            .collection('fountains')
            .where(
              'latitude',
              isEqualTo: double.parse(
                sourceLocation.latitude.toStringAsFixed(5),
              ),
            )
            .where(
              'longitude',
              isEqualTo: double.parse(
                sourceLocation.longitude.toStringAsFixed(5),
              ),
            )
            .get();

    if (querySnapshot.docs.isNotEmpty) {
      final data = querySnapshot.docs.first.data();
      // On extrait les champs minéraux connus et on les retourne
      return {
        'Bicarbonates': data['Bicarbonates'],
        'Calcium': data['Calcium'],
        'Chlorures': data['Chlorures'],
        'Magnésium': data['Magnésium'],
        'Nitrates': data['Nitrates'],
        'Nitrites': data['Nitrites'],
        'Potassium': data['Potassium'],
        'Résidus secs': data['Résidus secs'],
        'Sodium': data['Sodium'],
        'Sulfates': data['Sulfates'],
      };
    } else {
      // Rien trouvé pour ces coordonnées
      return null;
    }
  } catch (e) {
    // On prévient l'utilisateur d'un problème réseau / lecture
    Fluttertoast.showToast(
      msg: "Erreur lors de la récupération des données.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM, // ou CENTER, TOP
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
    );
    return null;
  }
}
