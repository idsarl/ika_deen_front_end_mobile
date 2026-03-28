import 'package:flutter/material.dart';
import 'package:muslim_guide/models/Ayah.dart';
import 'package:muslim_guide/models/Sura.dart'; // Importez votre modèle

class ReadQuoranScreen extends StatefulWidget {
  final Sura sura; // On passe l'objet Sura entier
  const ReadQuoranScreen({super.key, required this.sura});

  @override
  State<ReadQuoranScreen> createState() => _ReadQuoranScreenState();
}

class _ReadQuoranScreenState extends State<ReadQuoranScreen> {
  @override
  Widget build(BuildContext context) {
    final List<Ayah> ayats = widget.sura.ayahs;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      // Utilisation de ListView.builder pour de meilleures performances
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        itemCount: ayats.length + 1, // +1 pour inclure le header
        itemBuilder: (context, index) {
          if (index == 0) return _buildSuraHeaderCard();
          return _buildAyatItem(ayats[index - 1], index);
        },
      ),
    );
  }

  // --- 1. L'AppBar Style Moderne ---
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.grey),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        widget.sura.name, // Dynamique
        style: const TextStyle(
          color: Color(0xFF2D6A4F),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search, color: Colors.grey, size: 22),
        ),
      ],
    );
  }

  // --- 2. La Bannière (Design "Quranly") ---
  Widget _buildSuraHeaderCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF52B788), Color(0xFF2D6A4F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Icône décorative en fond (filigrane)
          Positioned(
            right: -20,
            bottom: -20,
            child: Opacity(
              opacity: 0.1,
              child: Icon(Icons.menu_book, size: 180, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 20),
            child: Column(
              children: [
                Text(
                  widget.sura.name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.sura.translation,
                  style: const TextStyle(color: Colors.white70, fontSize: 15),
                ),
                const SizedBox(height: 12),
                const Divider(color: Colors.white30, indent: 50, endIndent: 50),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.sura.revelationType.toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(Icons.circle, size: 4, color: Colors.white),
                    ),
                    Text("${widget.sura.totalVerses} VERSES",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 25),
                if (widget.sura.id != 9)
                  const Text(
                    "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
                    style: TextStyle(
                        fontFamily: 'Amiri', fontSize: 28, color: Colors.white),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAyatItem(Ayah ayat, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Aligne la traduction à gauche
        children: [
          // --- Barre d'outils (Numéro + Actions) ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color:
                  const Color(0xFFF9F9F9), // Gris très clair comme sur l'image
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // Numéro stylisé (juste le texte en vert)
                Text(
                  "$index.",
                  style: const TextStyle(
                    color: Color(0xFF2D6A4F),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                // Icônes d'actions discrètes
                const Icon(Icons.share_outlined,
                    color: Color(0xFF2D6A4F), size: 20),
                const SizedBox(width: 18),
                const Icon(Icons.play_circle_outline,
                    color: Color(0xFF2D6A4F), size: 22),
                const SizedBox(width: 18),
                const Icon(Icons.bookmark_border,
                    color: Color(0xFF2D6A4F), size: 20),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // --- TEXTE ARABE (Aligné à droite) ---
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              ayat.text,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontFamily: 'Amiri', // Assure-toi d'avoir importé cette police
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B4332),
                height: 2.2, // Important pour l'espacement des voyelles
              ),
            ),
          ),
          const SizedBox(height: 12),

          // --- TRANSCRIPTION (Phonétique en vert) ---
          Text(
            ayat.transliteration ?? "Transcription indisponible",
            style: const TextStyle(
              color: Color(0xFF52B788),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 6),

          // --- TRADUCTION (Gris foncé) ---
          Text(
            ayat.translation ?? "Traduction indisponible",
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
  // --- 3. Item du Verset (Structure de l'image) ---
  // Widget _buildAyatItem(Ayah ayat, int index) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       // Barre d'actions discrète
  //       Row(
  //         children: [
  //           Text("$index.", style: const TextStyle(color: Color(0xFF2D6A4F), fontWeight: FontWeight.bold, fontSize: 15)),
  //           const Spacer(),
  //           const Icon(Icons.share_outlined, color: Colors.grey, size: 18),
  //           const SizedBox(width: 15),
  //           const Icon(Icons.play_arrow_outlined, color: Color(0xFF2D6A4F), size: 22),
  //           const SizedBox(width: 15),
  //           const Icon(Icons.bookmark_border, color: Colors.grey, size: 18),
  //         ],
  //       ),
  //       const SizedBox(height: 15),

  //       // Texte Arabe (Aligné à droite)
  //       Align(
  //         alignment: Alignment.centerRight,
  //         child: Text(
  //           ayat.text,
  //           textAlign: TextAlign.right,
  //           style: const TextStyle(
  //             fontFamily: 'Amiri',
  //             fontSize: 22,
  //             fontWeight: FontWeight.bold,
  //             color: Color(0xFF1B4332),
  //             height: 2.2,
  //           ),
  //         ),
  //       ),
  //       const SizedBox(height: 12),

  //       // Phonétique / Transcription (Couleur verte comme l'image)
  //       Text(
  //         ayat.transliteration ?? "Laisa liwaq'atiha kadzibah", // Exemple dynamique
  //         style: const TextStyle(
  //           color: Color(0xFF52B788),
  //           fontSize: 14,
  //           fontWeight: FontWeight.w500,
  //           fontStyle: FontStyle.italic,
  //         ),
  //       ),
  //       const SizedBox(height: 6),

  //       // Traduction (Gris pour la lisibilité)
  //       Text(
  //         ayat. ?? "Then no one can deny it has come.", // Exemple dynamique
  //         style: TextStyle(
  //           color: Colors.grey[600],
  //           fontSize: 14,
  //           height: 1.4,
  //         ),
  //       ),
  //       const SizedBox(height: 10),
  //       const Divider(height: 40, thickness: 0.5, color: Color(0xFFEEEEEE)),
  //     ],
  //   );
  // }
}
