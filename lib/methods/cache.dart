import 'package:shared_preferences/shared_preferences.dart';

// Simple wrapper autour de SharedPreferences pour stocker
// des durées de trajet (utile pour cacher des temps de parcours).

class TravelDurationCache {
  // Préfixe utilisé pour isoler les clés de ce cache dans SharedPreferences
  static const String prefix = 'travelDuration_';

  // --- Enregistrer une durée
  // key : identifiant (ex: 'home_to_station'), duration en minutes
  static Future<void> saveDuration(String key, double duration) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(prefix + key, duration);
  }

  // --- Lire une durée (retourne null si non trouvée)
  static Future<double?> getDuration(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(prefix + key);
  }

  // --- Supprimer une durée particulière
  static Future<void> removeDuration(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(prefix + key);
  }

  // --- Vider tout le cache lié à TravelDurationCache
  // (supprime toutes les clés commençant par le préfixe)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith(prefix)).toList();
    for (var key in keys) {
      await prefs.remove(key);
    }
  }
}
