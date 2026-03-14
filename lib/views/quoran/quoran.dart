import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_guide/core/constants/app_constants.dart';

import '../../widgets/widget_global.dart';

class QuoranScreen extends StatefulWidget {
  const QuoranScreen({super.key});

  @override
  State<QuoranScreen> createState() => _QuoranScreenState();
}

class _QuoranScreenState extends State<QuoranScreen> {
  // Liste fictive pour l'exemple
  final List<Map<String, String>> suras = [
    {
      "id": "1",
      "name": "Al Fatihah",
      "mean": "The Opener",
      "verses": "7 Verses",
      "arabic": "الفاتحة"
    },
    {
      "id": "2",
      "name": "Al Baqarah",
      "mean": "The Cow",
      "verses": "283 Verses",
      "arabic": "البقرة"
    },
    {
      "id": "3",
      "name": "Āli 'Imrān",
      "mean": "The Family Of Imran",
      "verses": "200 Verses",
      "arabic": "آل عمران"
    },
    {
      "id": "4",
      "name": "An-Nisā'",
      "mean": "The Women",
      "verses": "176 Verses",
      "arabic": "النِّسَاء"
    },
    {
      "id": "5",
      "name": "Al-Mā'idah",
      "mean": "The Table Spread",
      "verses": "120 Verses",
      "arabic": "المائدة"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTabs(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Dernière lecture",
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  buildAnimatedItem(child: _buildLastReadCard(), delay: 100),
                  const SizedBox(height: 25),
                  // Liste des Sourates animées une par une
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: suras.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      return buildAnimatedItem(
                        delay: 200 + (index * 50), // Animation en cascade
                        child: _buildSuraItem(suras[index]),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Header Tabs (Sura, Juz, Story...) ---
  Widget _buildTabs() {
    return Container(
      height: 40, // Hauteur ajustée pour un look plus fin
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _tabItem("Sura", isActive: true),
          _tabItem("Juz"),
          _tabItem("Story"),
          _tabItem("Fact"),
          _tabItem("Bookmark"),
        ],
      ),
    );
  }

  Widget _tabItem(String label, {bool isActive = false}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 2),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        // Couleur de fond : Vert plein si actif, transparent sinon
        color: isActive ? const Color(0xFF2D6A4F) : Colors.transparent,
        borderRadius:
            BorderRadius.circular(25), // Bords très arrondis (style capsule)
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            // Texte blanc si actif, gris si inactif
            color: isActive ? Colors.white : Colors.grey[500],
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  // --- Carte "Last Read" (La bannière verte) ---
  Widget _buildLastReadCard() {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2D6A4F), Color(0xFF52B788)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(Icons.menu_book, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text("Continue Reading",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500)),
                  ],
                ),
                SizedBox(height: 15),
                Text("Al-Baqarah",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                Text("Verse No: 12", style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset('assets/images/quoran_s_t.png',
                height: 120), // Utilise ton image de coran
          )
        ],
      ),
    );
  }

  // --- Item de la liste des Sourates ---
  Widget _buildSuraItem(Map<String, String> sura) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(Icons.circle,
              size: 40,
              color: AppConstants.primaryColor), // Forme octogonale simulée
          Text(sura['id']!,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppConstants.backgroundColor,
                  fontSize: 12)),
        ],
      ),
      title: Text(sura['name']!,
          style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text("${sura['mean']} • ${sura['verses']}",
          style: const TextStyle(fontSize: 12, color: Colors.grey)),
      trailing: Text(sura['arabic']!,
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D6A4F),
              fontFamily: 'Amiri' // Si tu as une police arabe
              )),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppConstants.primaryColor,
          )),
      title: const Text("Quran",
          style: TextStyle(
              color: AppConstants.primaryColor, fontWeight: FontWeight.bold)),
      actions: [
        IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: AppConstants.primaryColor)),
        const SizedBox(width: 10),
      ],
    );
  }
}
