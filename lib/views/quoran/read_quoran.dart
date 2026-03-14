import 'package:flutter/material.dart';

class ReadQuoranScreen extends StatefulWidget {
  final String suraName;
  const ReadQuoranScreen({super.key, required this.suraName});

  @override
  State<ReadQuoranScreen> createState() => _ReadQuoranScreenState();
}

class _ReadQuoranScreenState extends State<ReadQuoranScreen> {
  
  
  // Liste fictive d'Ayats pour l'exemple
  final List<Map<String, String>> ayats = [
    {
      "id": "1",
      "arabic": "اِذَا وَقَعَتِ الْوَاقِعَةُۙ",
      "latin": "Iżā waqa'atil-wāqi'ah(tu)."
    },
    {
      "id": "2",
      "arabic": "لَيْسَ لِوَقْعَتِهَا كَاذِبَةٌۘ",
      "latin": "Laisa liwaq'atihā kāżibah(tun)."
    },
    {
      "id": "3",
      "arabic": "خَافِضَةٌ رَّافِعَةٌۙ",
      "latin": "Khāfiḍatur-rāfi'ah(tun)."
    },
    {
      "id": "4",
      "arabic": "اِذَا رُجَّتِ الْاَرْضُ رَجًّـاۙ",
      "latin": "Iżā rujjatil-arḍu rajjā(n)."
    },
    {
      "id": "5",
      "arabic": "وَبُسَّتِ الْجِبَالُ بَسًّـاۙ",
      "latin": "Wa bussatil-jibālu bassā(n)."
    },
    {
      "id": "6",
      "arabic": "فَكَانَتْ هَبَاۤءً مُّنْبَثًّـاۙ",
      "latin": "Fa kānat habā'am mumbaśśā(n)."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Column(
          children: [
            // 1. La Bannière de Titre Vert
            _buildSuraHeaderCard(),
            const SizedBox(height: 25),
            // 2. La Liste des Versets
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ayats.length,
              separatorBuilder: (context, index) => const Divider(height: 30),
              itemBuilder: (context, index) {
                return _buildAyatItem(ayats[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- 1. L'AppBar ---
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.grey),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        widget.suraName,
        style: const TextStyle(
          color: Color(0xFF2D6A4F),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.translate, color: Colors.grey, size: 20), // Icône traduction
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.bookmark_border_rounded, color: Colors.grey, size: 22),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  // --- 2. La Bannière de Titre (style "Last Read") ---
  Widget _buildSuraHeaderCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          colors: [Color(0xFF2D6A4F), Color(0xFF52B788)], // Même dégradé
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2D6A4F).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Texte et Infos
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                Text(
                  widget.suraName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "The Event That Will Happen", // Signification (statique ici)
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  height: 1.5,
                  width: double.infinity,
                  color: Colors.white.withOpacity(0.4),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "MECCAN", // Type
                      style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
                    ),
                    const SizedBox(width: 8),
                    Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Text(
                      "96 VERSES", // Nombre versets
                      style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Bismillah stylisé
                const Opacity(
                  opacity: 0.9,
                  child: Text(
                    "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Amiri', // Police Arabe requise
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Motif de fond (discret)
          Positioned(
            left: -30,
            bottom: -30,
            child: Opacity(
              opacity: 0.08,
              child: Image.asset(
                'assets/images/quoran_s_t.png', // Image de motif à ajouter
                height: 180,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 3. Item du Verset (Numéro, Arabe, Latin) ---
  Widget _buildAyatItem(Map<String, String> ayat) {
    return Column(
      children: [
        // La Barre d'outils du verset (Numéro, Actions)
        Row(
          children: [
            // Numéro du verset
            _buildAyatNumberIcon(ayat['id']!),
            const Spacer(),
            // Actions (Jouer, Favori)
            Row(
              children: [
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () {},
                  icon: const Icon(Icons.share_outlined, color: Color(0xFF2D6A4F), size: 18),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () {},
                  icon: const Icon(Icons.play_arrow_outlined, color: Color(0xFF2D6A4F), size: 18),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () {},
                  icon: const Icon(Icons.bookmark_border_rounded, color: Color(0xFF2D6A4F), size: 18),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 15),
        // Texte Arabe
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            ayat['arabic']!,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontFamily: 'Amiri', // Police Arabe requise
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B4332), // Vert très sombre
              height: 1.6, // Espacement de ligne soft
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Texte Latin / Traduction
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            ayat['latin']!,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black.withOpacity(0.8),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  // --- Icône Numéro de Verset stylisée (Hexagone/Etoile) ---
  Widget _buildAyatNumberIcon(String id) {
  return SizedBox(
    width: 35,
    height: 35,
    child: Stack(
      alignment: Alignment.center,
      children: [
        // Premier carré
        Transform.rotate(
          angle: 0,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFC5A358), width: 1.5),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        // Deuxième carré incliné (crée l'étoile)
        Transform.rotate(
          angle: 45 * (3.14159 / 180), // 45 degrés
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFC5A358), width: 1.5),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        Text(id, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}
}