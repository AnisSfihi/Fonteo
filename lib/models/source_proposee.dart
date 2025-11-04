// source_proposee.dart
// Représente une source suggérée par un utilisateur (avant validation).
// Contient le nom, la région et les coordonnées GPS fournies.

// --- Modèle d'une source proposée
class SourceProposee {
  // Nom et région renseignés par l'utilisateur
  final String sourceName;
  final String sourceRegion;
  // Coordonnées GPS (latitude / longitude)
  final double latitude;
  final double longitude;

  SourceProposee({
    required this.sourceName,
    required this.sourceRegion,
    required this.latitude,
    required this.longitude,
  });

  // Création depuis une Map (format Firestore / RealtimeDB)
  factory SourceProposee.fromMap(Map<dynamic, dynamic> data) {
    return SourceProposee(
      sourceName: data['sourceName'],
      sourceRegion: data['sourceRegion'],
      latitude: data['latitude'],
      longitude: data['longitude'],
    );
  }
}
