import 'package:shared_preferences/shared_preferences.dart';

class LastReadService {
  static const String _key = 'last_read_sura_id';

  // Sauvegarder l'ID de la sourate
  static Future<void> setLastRead(int suraId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, suraId);
  }

  // Récupérer l'ID sauvegardé (retourne 1 si rien n'est stocké)
  static Future<int> getLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_key) ?? 1; 
  }
}