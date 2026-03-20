// Créez une classe pour grouper les données nécessaires à l'écran
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:muslim_guide/models/Sura.dart';
import 'package:muslim_guide/services/last_read_service.dart';

class QuranDisplayData {
  final List<Sura> suras;
  final Sura lastReadSura;
  QuranDisplayData(this.suras, this.lastReadSura);
}

// Dans votre State :
// 1. La fonction pour lire le JSON (Celle qui manquait !)
Future<List<Sura>> _loadSuras() async {
  try {
    // Assurez-vous que le chemin correspond à votre pubspec.yaml
    final String response = await rootBundle.loadString('assets/data/quran_fr.json');
    final data = json.decode(response);
    
    List<Sura> surasList = (data['data']['surahs'] as List)
        .map((e) => Sura.fromJson(e))
        .toList();
    return surasList;
  } catch (e) {
    print("Erreur lors du chargement du JSON: $e");
    return []; // Retourne une liste vide en cas d'erreur
  }
}

// 2. La fonction globale qui combine JSON + Persistance
Future<QuranDisplayData> _loadAllData() async {
  // On appelle la fonction de chargement définie juste au-dessus
  final List<Sura> allSuras = await _loadSuras(); 
  
  if (allSuras.isEmpty) {
    throw Exception("La liste des sourates est vide.");
  }

  // Charger l'ID sauvegardé dans le téléphone
  int lastId = await LastReadService.getLastRead();
  
  // Trouver la sourate qui correspond à cet ID
  Sura lastSura = allSuras.firstWhere(
    (s) => s.id == lastId, 
    orElse: () => allSuras[0]
  );
  
  return QuranDisplayData(allSuras, lastSura);
}