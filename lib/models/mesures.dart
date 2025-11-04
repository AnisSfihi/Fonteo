// mesures.dart
// Petit modèle représentant une mesure prise sur une source d'eau.
// Contient les paramètres essentiels (pH, TDS) et l'instant de la mesure.
class Mesures {
  // pH mesuré
  final num ph;
  // TDS (Total Dissolved Solids) — matière dissoute, pas la température
  final num tds;
  // Timestamp de la mesure
  final DateTime time; 

  Mesures({
    required this.ph,
    required this.tds,
    required this.time,
  });

  // --- Constructeur depuis une Map (format Firebase / Realtime DB)
  factory Mesures.fromMap(Map<dynamic, dynamic> data) {
    return Mesures(
      ph: data['ph'],
      tds: data['tds'],
      time: DateTime.fromMillisecondsSinceEpoch((data['timestamp'] as int) * 1000),
    );
  }
}
