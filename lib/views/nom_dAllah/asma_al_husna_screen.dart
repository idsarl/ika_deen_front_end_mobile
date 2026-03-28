import 'package:flutter/material.dart';
import 'package:muslim_guide/models/AllahName.dart';

class AsmaAlHusnaScreen extends StatelessWidget {
     AsmaAlHusnaScreen({super.key});

  // Exemple de données (à compléter jusqu'à 99)
  final List<AllahName> names = [
    AllahName(
        id: 1,
        transliteration: "Ar-Rahmān",
        meaning: "Le Tout-Miséricordieux",
        arabic: "الرحمن"),
    AllahName(
        id: 2,
        transliteration: "Ar-Rahīm",
        meaning: "Le Très-Miséricordieux",
        arabic: "الرحيم"),
    AllahName(
        id: 3,
        transliteration: "Al-Malik",
        meaning: "Le Souverain",
        arabic: "الملك"),
    AllahName(
        id: 4,
        transliteration: "Al-Quddūs",
        meaning: "Le Saint",
        arabic: "القدوس"),
    AllahName(
        id: 5,
        transliteration: "As-Salām",
        meaning: "La Paix",
        arabic: "السلام"),
    AllahName(
        id: 6,
        transliteration: "Al-Mu'min",
        meaning: "La Sauvegarde",
        arabic: "المؤمن"),
    AllahName(
        id: 7,
        transliteration: "Al-Muhaymin",
        meaning: "Le Préservateur",
        arabic: "المهيمن"),
    AllahName(
        id: 8,
        transliteration: "Al-Azīz",
        meaning: "Le Tout-Puissant",
        arabic: "العزيز"),
    AllahName(
        id: 9,
        transliteration: "Al-Jabbār",
        meaning: "Le Contraignant",
        arabic: "الجبار"),
    AllahName(
        id: 10,
        transliteration: "Al-Mutakabbir",
        meaning: "Le Superbe",
        arabic: "المتكبر"),
    // ... Continue la liste ici jusqu'à 99
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Asma Al-Husna",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: names.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final name = names[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Index
                      SizedBox(
                        width: 30,
                        child: Text(
                          "${name.id}.",
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                      // Contenu Textuel (Transliteration + Signification)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name.transliteration,
                              style: const TextStyle(
                                color: Color(
                                    0xFF2ECC71), // Couleur verte de l'image
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              name.meaning,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Calligraphie Arabe
                      Text(
                        name.arabic,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily:
                              'ArabicFont', // Assurez-vous d'avoir une police arabe
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Barre de lecture en bas (Optionnel, comme sur l'image)
          _buildAudioPlayerBar(),
        ],
      ),
    );
  }

  Widget _buildAudioPlayerBar() {
    return Container(
      color: const Color(0xFF1A1A1A),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: const Row(
        children: [
          Icon(Icons.play_arrow, color: Colors.white, size: 30),
          // Barre de progression ici si nécessaire
        ],
      ),
    );
  }
}
