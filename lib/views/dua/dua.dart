import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_guide/core/constants/app_constants.dart';

class Dua extends StatefulWidget {
  const Dua({super.key});

  @override
  State<Dua> createState() => _DuaState();
}

class _DuaState extends State<Dua> {
  String _selectedCategory = "Toutes";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Réutilisation du design des onglets (Tabs)
            _buildTabs(),
            
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Dua du moment",
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  
                  // Carte en dégradé (Style "Last Read")
                  _buildFeaturedDuaCard(),
                  
                  const SizedBox(height: 25),
                  
                  // Liste des Duas
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 10, // À dynamiser avec tes données
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      return _buildDuaItem("Invocation n°${index + 1}", "Catégorie");
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

  // --- Design des Catégories (Inspiré de _buildTabs du Coran) ---
  Widget _buildTabs() {
    List<String> categories = ["Toutes", "Matin", "Soir", "Voyage", "Protection"];
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          bool isActive = _selectedCategory == categories[index];
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = categories[index]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? AppConstants.primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isActive ? AppConstants.primaryColor : Colors.grey.shade300,
                ),
              ),
              child: Center(
                child: Text(
                  categories[index],
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.grey[500],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // --- Carte Vedette (Style dégradé du Coran) ---
  Widget _buildFeaturedDuaCard() {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppConstants.primaryColor, Color(0xFF52B788)],
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
              children: const [
                Text("Protection",
                    style: TextStyle(color: Colors.white70, fontSize: 14)),
                SizedBox(height: 5),
                Text("Ayatul Kursi",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                Text("Le verset du Trône",
                    style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          // Petit rappel visuel comme l'image du Coran
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
    );
  }

  // --- Item de liste (Inspiré de _buildSuraItem) ---
  Widget _buildDuaItem(String title, String category) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: AppConstants.primaryColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Icon(Icons.auto_awesome, color: AppConstants.primaryColor, size: 20),
        ),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(category, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: () {
        // Logique de navigation
      },
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
      "Duas",
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