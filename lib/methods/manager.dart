import 'package:shared_preferences/shared_preferences.dart';

// manager.dart
// Gestion des fontaines visitées (historique) et favorites.
// Stockage simple avec SharedPreferences.

// --- Gestion de l'historique des visites
class HistoriqueManager {
  // Clé utilisée dans SharedPreferences
  static const String _key = 'historique_fontaines';

  // Ajoute une fontaine à la liste des visites 
  // (évite auto. les doublons)
  static Future<void> addToHistorique(String fontaineInfo) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> historique = prefs.getStringList(_key) ?? [];

    // Éviter les doublons
    if (!historique.contains(fontaineInfo)) {
      historique.add(fontaineInfo);
      await prefs.setStringList(_key, historique);
    }
  }

  // Renvoie la liste complète des fontaines visitées
  static Future<List<String>> getHistorique() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  // Retire une fontaine de l'historique (si présente)
  static Future<void> removeFromHistorique(String fontaineInfo) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> historique = prefs.getStringList(_key) ?? [];

    historique.remove(fontaineInfo);
    await prefs.setStringList(_key, historique);
  }

  // Reset l'historique (supprime toutes les visites)
  static Future<void> clearHistorique() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}


// --- Gestion des favoris
class FavorisManager {
  // Clé pour les favoris dans SharedPreferences
  static const String _key = 'favoris_fontaines';

  // Ajoute une fontaine aux favoris 
  // (pas de doublons)
  static Future<void> addToFavoris(String fontaineFavoris) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoris = prefs.getStringList(_key) ?? [];

    // On vérifie si pas déjà favorite
    if (!favoris.contains(fontaineFavoris)) {
      favoris.add(fontaineFavoris);
      await prefs.setStringList(_key, favoris);
    }
  }

  // Liste toutes les fontaines favorites
  static Future<List<String>> getFavoris() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  // Retire des favoris (si présente)
  static Future<void> removeFromFavoris(String fontaineFavoris) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoris = prefs.getStringList(_key) ?? [];

    favoris.remove(fontaineFavoris);
    await prefs.setStringList(_key, favoris);
  }

  // Supprime tous les favoris
  static Future<void> clearFavoris() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

