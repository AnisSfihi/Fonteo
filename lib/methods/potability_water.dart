import 'package:aqua_sense/models/status.dart';

// potability_water.dart
// Analyse la potabilité de l'eau selon les normes algériennes.
// Compare les paramètres mesurés aux seuils réglementaires.

// --- Évaluation de la potabilité
// Prend tous les paramètres mesurés et renvoie un statut
// avec la liste des éventuels problèmes trouvés
WaterPotabilityResult evaluateWaterPotability({
  required double? pH,
  required double? tds,
  required double? turbidity,
  required double? temperature,
  required double? calcium,
  required double? magnesium,
  required double? potassium,
  required double? sodium,
  required double? bicarbonates,
  required double? sulfates,
  required double? chlorures,
  required double? nitrates,
  required double? nitrites,
  required double? residusSecs,
}) {
  List<String> problems = [];

  List allValues = [
    pH, tds, turbidity, temperature, calcium, magnesium, potassium,
    sodium, bicarbonates, sulfates, chlorures, nitrates, nitrites, residusSecs
  ];
  if (allValues.any((element) => element == null)) {
    return WaterPotabilityResult(
      status: "INDISPONIBLE",
      problems: [],
    );
  }

  // On commence par vérifier les paramètres physiques de base
  // pH (acidité), matières dissoutes, clarté et température
  if (pH != null && (pH < 6.5 || pH > 8.5)) problems.add("pH anormal");

  if (tds != null && tds > 1000) problems.add("TDS élevé");

  if (turbidity != null && turbidity > 5) problems.add("Turbidité élevée");

  if (temperature != null && (temperature < 0 || temperature > 30)) problems.add("Température inhabituelle");


  // Ensuite on vérifie tous les minéraux
  // (seuils selon normes algériennes)
  if (calcium != null && calcium > 200) problems.add("Calcium trop élevé");

  if (magnesium != null && magnesium > 50) problems.add("Magnésium trop élevé");

  if (potassium != null && potassium > 12) problems.add("Potassium trop élevé");

  if (sodium != null && sodium > 200) problems.add("Sodium trop élevé");

  if (bicarbonates != null && bicarbonates > 600) problems.add("Bicarbonates trop élevés");
  
  if (sulfates != null && sulfates > 250) problems.add("Sulfates trop élevés");
  
  if (chlorures != null && chlorures > 250) problems.add("Chlorures trop élevés");
  
  if (nitrates != null && nitrates > 50) problems.add("Nitrates trop élevés"); 
  
  if (nitrites != null && nitrites > 0.1) problems.add("Nitrites trop élevés");
  
  if (residusSecs != null && residusSecs > 1000) problems.add("Résidus secs élevés");

  String status = problems.isEmpty ? "POTABLE" : "NON POTABLE";

  return WaterPotabilityResult(
    status: status,
    problems: problems,
  );
}