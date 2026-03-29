import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_guide/core/constants/app_constants.dart';
import 'package:muslim_guide/models/AllahName.dart';

class NomAllahScreen extends StatefulWidget {
  const NomAllahScreen({super.key});

  @override
  State<NomAllahScreen> createState() => _NomAllahScreenState();
}

class _NomAllahScreenState extends State<NomAllahScreen> {
  String _searchQuery = "";
  
  // Exemple de données (À remplacer par votre JSON complet)
  final List<AllahName> _allNames = [
    AllahName(id: 1, arabic: "الرَّحْمَنُ", transliteration: "Ar-Rahman", translation: "Le Tout-Miséricordieux"),
    AllahName(id: 2, arabic: "الرَّحِيمُ", transliteration: "Ar-Rahim", translation: "Le Très-Miséricordieux"),
    AllahName(id: 3, arabic: "الْمَلِكُ", transliteration: "Al-Malik", translation: "Le Souverain"),
    // ... Ajoutez les autres ici
  ];

  List<AllahName> get _filteredNames {
    if (_searchQuery.isEmpty) return _allNames;
    return _allNames.where((name) {
      return name.transliteration!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             name.translation!.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildFeaturedCard(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${_filteredNames.length} Noms trouvés",
                    style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _filteredNames.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      return _buildNameItem(_filteredNames[index]);
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

  Widget _buildFeaturedCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
                Text("Apprendre", style: TextStyle(color: Colors.white70)),
                SizedBox(height: 5),
                Text("Asma-ul-Husna",
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                Text("Les plus beaux noms appartiennent à Allah",
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
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
    );
  }

  Widget _buildNameItem(AllahName name) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 10),
      leading: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.brightness_4_outlined, size: 45, color: AppConstants.primaryColor.withOpacity(0.2)),
          Text("${name.id}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
      title: Text(name.transliteration!, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(name.translation!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      trailing: Text(
        name.arabic!,
        style: const TextStyle(
          fontSize: 20, 
          fontWeight: FontWeight.bold, 
          color: AppConstants.primaryColor
        ),
      ),
      onTap: () {
        // Optionnel : Afficher une explication détaillée dans un BottomSheet
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(Icons.arrow_back, color: AppConstants.primaryColor),
      ),
      title: const Text(
        "Les 99 Noms d'Allah",
        style: TextStyle(color: AppConstants.primaryColor, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          onPressed: () {
            // Activer un champ de recherche si nécessaire
          },
          icon: const Icon(Icons.search, color: AppConstants.primaryColor),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}

  