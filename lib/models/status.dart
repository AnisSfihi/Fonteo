// status.dart
// Résultat simple d'une évaluation de potabilité de l'eau.
class WaterPotabilityResult {
  // Contient le verdict (POTABLE / NON POTABLE / INDISPONIBLE)
  final String status;
  // et une liste de problèmes détectés (si applicable).
  final List<String> problems;

  WaterPotabilityResult({
    required this.status,
    required this.problems,
  });
}