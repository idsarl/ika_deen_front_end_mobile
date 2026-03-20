import 'package:muslim_guide/models/Ayah.dart';

class Sura {
  final int id;
  final String name; // Nom phonétique (Al-Faatiha)
  final String arabicName; // Nom arabe (سُورَةُ...)
  final String translation; // Traduction française
  final String revelationType;
  final int totalVerses;
  final List<Ayah> ayahs; // LA LISTE DES VERSETS EST ICI MAINTENANT

  Sura({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.translation,
    required this.revelationType,
    required this.totalVerses,
    required this.ayahs,
  });

  factory Sura.fromJson(Map<String, dynamic> json) {
    // Transformation de la liste de maps JSON en liste d'objets Ayah
    var ayahsJson = json['ayahs'] as List;
    List<Ayah> ayahsList = ayahsJson.map((i) => Ayah.fromJson(i)).toList();

    return Sura(
      id: json['number'],
      name: json['englishName'],
      arabicName: json['name'],
      translation: json['englishNameTranslation'],
      revelationType: json['revelationType'],
      totalVerses: ayahsList.length,
      ayahs: ayahsList,
    );
  }
}