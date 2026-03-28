import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:muslim_guide/core/constants/app_constants.dart';
import 'package:muslim_guide/models/Sura.dart';
import 'package:muslim_guide/services/last_read_service.dart';

import '../../widgets/widget_global.dart';
import 'read_quoran.dart';

class QuranDisplayData {
  final List<Sura> suras;
  final Sura lastReadSura;
  QuranDisplayData(this.suras, this.lastReadSura);
}

class QuoranScreen extends StatefulWidget {
  final bool? isback;
  QuoranScreen({super.key, this.isback});

  @override
  State<QuoranScreen> createState() => _QuoranScreenState();
}

class _QuoranScreenState extends State<QuoranScreen> {

  final TextEditingController _searchController = TextEditingController();
String _searchQuery = "";

  // 1. Charger les sourates depuis le fichier JSON
  Future<List<Sura>> _loadSuras() async {
    final String response =
        await rootBundle.loadString('assets/data/quran_fr.json');
    final data = json.decode(response);
    List<Sura> surasList =
        (data['data']['surahs'] as List).map((e) => Sura.fromJson(e)).toList();
    return surasList;
  }

  List<Sura> _filterSuras(List<Sura> suras) {
  if (_searchQuery.isEmpty) return suras;

  return suras.where((sura) {
    // Recherche par nom (phonétique ou arabe) ou par numéro
    final query = _searchQuery.toLowerCase();
    final nameMatch = sura.name.toLowerCase().contains(query);
    final translationMatch = sura.translation.toLowerCase().contains(query);
    final numberMatch = sura.id.toString() == query;

    return nameMatch || translationMatch || numberMatch;
  }).toList();
}

  // 2. Combiner le JSON et la dernière lecture persistée
  Future<QuranDisplayData> _loadAllData() async {
    final List<Sura> allSuras = await _loadSuras();
    final int lastId =
        await LastReadService.getLastRead(); // Récupère l'ID sauvegardé

    // On cherche la sourate correspondante, sinon la première par défaut
    final Sura lastSura =
        allSuras.firstWhere((s) => s.id == lastId, orElse: () => allSuras[0]);

    return QuranDisplayData(allSuras, lastSura);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: FutureBuilder<QuranDisplayData>(
        future: _loadAllData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2D6A4F)),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("Aucune donnée disponible"));
          }

          final allSuras = snapshot.data!.suras;
          final lastRead = snapshot.data!.lastReadSura;

          return SingleChildScrollView(
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
                      _buildLastReadCard(lastRead),
                      const SizedBox(height: 25),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: allSuras.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          return _buildSuraItem(allSuras[index]);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- Header Tabs ---
  Widget _buildTabs() {
    return Container(
      height: 40,
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
        color: isActive ? const Color(0xFF2D6A4F) : Colors.transparent,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey[500],
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  // --- Carte "Last Read" Persistée ---
  Widget _buildLastReadCard(Sura sura) {
    return InkWell(
      onTap: () {
        // Optionnel : naviguer vers la lecture
        Get.to(() => ReadQuoranScreen(sura: sura));
      },
      child: Container(
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
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.menu_book, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text("Continuer la lecture",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(sura.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  Text(sura.translation,
                      style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Opacity(
                opacity: 0.3,
                child: Image.asset('assets/images/quoran_s_t.png',
                    height: 120,
                    errorBuilder: (context, error, stackTrace) => Container()),
              ),
            )
          ],
        ),
      ),
    );
  }

  // --- Item de la liste des Sourates ---
  Widget _buildSuraItem(Sura sura) {
    return InkWell(
      onTap: () async {
        // Sauvegarde de l'ID avant de naviguer
        await LastReadService.setLastRead(sura.id);
        setState(() {});
        Get.to(() => ReadQuoranScreen(sura: sura));
        // Get.to(() => ReadQuoranScreen(suraName: sura.name));
      },
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
        leading: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Icons.circle, size: 40, color: Color(0xFF2D6A4F)),
            Text("${sura.id}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 12)),
          ],
        ),
        title: Text(sura.name,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("${sura.translation} • ${sura.totalVerses} versets",
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: Text(sura.arabicName.replaceAll("سُورَةُ ", ""),
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D6A4F))),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    // Empêche Flutter de mettre un bouton par défaut si on veut que ce soit vide
    automaticallyImplyLeading: false, 
    leading: isBlank == true
        ? null
        : IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back,
              color: AppConstants.primaryColor,
            ),
          ),
    title: const Text(
      "Quran",
      style: TextStyle(
        color: AppConstants.primaryColor, 
        fontWeight: FontWeight.bold,
      ),
    ),
    actions: [
      IconButton(
        onPressed: () {
          // Logique de recherche
        },
        icon: const Icon(Icons.search, color: AppConstants.primaryColor),
      ),
      const SizedBox(width: 10),
    ],
  );
}
}
