import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:muslim_guide/core/constants/app_constants.dart';
import 'package:muslim_guide/views/mosque/list_mosque.dart';
import 'package:muslim_guide/views/profile/profil.dart';
import 'package:muslim_guide/views/quoran/quoran.dart';

import '../../widgets/widget_global.dart';
import '../ramadan/routine/ramadan_routine.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _timeString;
  late Timer _timer;

  // TABLEAU DYNAMIQUE DES HEURES DE PRIÈRE (Facile à modifier)
  // Format HH:mm
  final Map<String, String> prayerTimes = {
    "Fajr": "05:12",
    "Dhuhr": "12:41",
    "Asr": "15:58",
    "Maghrib": "18:45",
    "Isha": "20:01",
  };

  String nextPrayerName = "";
  String remainingTimeStr = "";

  late final List<Widget> _pages;

  int _currentIndex = 0; // L'onglet sélectionné par défaut

  // --- LE CONTENU DE L'ACCUEIL (Extrait du body original) ---
  Widget _buildHomeBody() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildAnimatedItem(child: _buildPrayerCard(), delay: 100),
            const SizedBox(height: 20),
            buildAnimatedItem(child: _buildRamadhanBanner(), delay: 200),
            const SizedBox(height: 25),
            buildAnimatedItem(child: _buildFeatureGrid(), delay: 300),
            const SizedBox(height: 30),
            buildAnimatedItem(child: _buildDailyDuaSection(), delay: 400),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _updateTime();
    // Le timer tourne chaque seconde pour mettre à jour l'heure et le compte à rebours
    _timer =
        Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTime());
    // Initialisation de la liste des pages
    _pages = [
      _buildHomeBody(), // Le contenu de l'accueil
      QuoranScreen(
        isback: false,
      ), // Page Cours (ou Mosquées selon ton test)
      const ListMosqueScreen(), // Page Objectifs
      const ProfilScreen(), // Page Profil
    ];
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    final DateTime now = DateTime.now();
    setState(() {
      _timeString = DateFormat('HH:mm').format(now);
      _calculateNextPrayer(now);
    });
  }

  void _calculateNextPrayer(DateTime now) {
    String foundName = "";
    Duration minDifference = const Duration(days: 1);

    prayerTimes.forEach((name, time) {
      // Convertir le string "HH:mm" en objet DateTime pour aujourd'hui
      final parts = time.split(':');
      DateTime prayerDateTime = DateTime(now.year, now.month, now.day,
          int.parse(parts[0]), int.parse(parts[1]));

      // Si l'heure de prière est déjà passée, on regarde pour demain
      if (prayerDateTime.isBefore(now)) {
        prayerDateTime = prayerDateTime.add(const Duration(days: 1));
      }

      final difference = prayerDateTime.difference(now);

      if (difference < minDifference) {
        minDifference = difference;
        foundName = name;
      }
    });

    nextPrayerName = foundName;

    // Formater le temps restant (Heures et Minutes)
    int hours = minDifference.inHours;
    int minutes = minDifference.inMinutes.remainder(60);

    if (hours > 0) {
      remainingTimeStr = "$hours h et $minutes min";
    } else {
      remainingTimeStr = "$minutes minutes";
    }
  }

// --- LE BUILD PRINCIPAL ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // On n'affiche l'AppBar stylisée que si on est sur l'onglet Accueil (0)
      appBar: _currentIndex == 0 ? _buildHomeAppBar() : null,

      bottomNavigationBar: _buildBottomNav(),

      // IndexedStack permet de changer de page sans perdre le scroll
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
    );
  }

  // --- L'APPBAR (Extraite pour plus de clarté) ---
  PreferredSizeWidget _buildHomeAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 90,
      automaticallyImplyLeading: false,
      title: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border:
                    Border.all(color: Colors.green.withOpacity(0.2), width: 2),
              ),
              child: const CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage('assets/images/user_profil.png'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded,
                          size: 14, color: Color(0xFF2D6A4F)),
                      const SizedBox(width: 4),
                      Text("Position actuelle",
                          style: TextStyle(
                              color: Colors.grey.withOpacity(0.8),
                              fontSize: 11)),
                    ],
                  ),
                  const Text("Bamako, Mali",
                      style: TextStyle(
                          color: Color(0xFF1B4332),
                          fontWeight: FontWeight.w800,
                          fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        buildAppBarAction(icon: Icons.search_rounded, onPressed: () {}),
        const SizedBox(width: 8),
        buildAppBarAction(icon: Icons.notes_rounded, onPressed: () {}),
        const SizedBox(width: 15),
      ],
    );
  }

// --- 3. Carte de Prière DYNAMIQUE ---
  Widget _buildPrayerCard() {
    return Container(
      width: double.infinity,
      height: 180,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2D6A4F),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2D6A4F).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _timeString, // Heure actuelle réelle
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Heure de $nextPrayerName", // Nom dynamique de la prochaine prière
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                "$nextPrayerName dans $remainingTimeStr", // Compte à rebours dynamique
                style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Positioned(
            right: -10,
            bottom: -30,
            child: Opacity(
              opacity: 0.8,
              child: Image.asset(
                'assets/images/mosque_3d.png',
                height: 210,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 4. Bannière Ramadhan Routine ---
  Widget _buildRamadhanBanner() {
    return GestureDetector(
      onTap: () {
        Get.to(const RamadhanRoutinePage(), transition: Transition.downToUp);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.withOpacity(0.05), Colors.white],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          border: Border.all(color: Colors.green.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Row(
          children: [
            Icon(Icons.star, color: Colors.orange, size: 20),
            SizedBox(width: 10),
            Text(
              "Set Ramadhan Routine",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF2D6A4F)),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // --- 5. Grille des fonctionnalités ---
  Widget _buildFeatureGrid() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            featureIcon(Icons.history, "Last Read", AppConstants.primaryColor,
                onTap: () {}),
            featureIcon(
              Icons.menu_book,
              "Quran",
              AppConstants.primaryColor,
              onTap: () {
                Get.to(
                    QuoranScreen(
                      isback: false,
                    ),
                    transition: Transition.leftToRight);
              },
            ),
            featureIcon(
                Icons.explore_outlined, "Qibla", AppConstants.primaryColor),
            featureIcon(
                Icons.volunteer_activism, "Zakat", AppConstants.primaryColor),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            featureIcon(Icons.notifications_none, "Reminder",
                AppConstants.primaryColor),
            featureIcon(Icons.reorder, "Tasbih", AppConstants.primaryColor),
            featureIcon(Icons.pan_tool_alt, "Dua", AppConstants.primaryColor),
            featureIcon(Icons.mosque, "Umra", AppConstants.primaryColor),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(),
      ],
    );
  }

  // --- 6. Section Daily Dua ---
  Widget _buildDailyDuaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.menu_book_rounded, color: Colors.green),
                SizedBox(width: 8),
                Text("Daily Dua",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            TextButton(
                onPressed: () {},
                child:
                    const Text("Tous >", style: TextStyle(color: Colors.grey))),
          ],
        ),
        const Text("1. Morning Prayer",
            style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Colors.grey[50], borderRadius: BorderRadius.circular(10)),
          child: const Text(
            "اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ النُّشُورُ",
            textAlign: TextAlign.right,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, height: 1.5),
          ),
        ),
      ],
    );
  }

  // --- 7. Bottom Navigation Bar ---
  // --- 7. Bottom Navigation Bar avec Redirection ---
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex, // L'index actuel
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Change l'écran au clic
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF2D6A4F),
        unselectedItemColor: Colors.grey.shade400,
        showUnselectedLabels: true,
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              activeIcon: Icon(Icons.home_filled),
              label: "Accueil"),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              activeIcon: Icon(
                Icons.menu_book,
              ),
              label: "Coran"),
          BottomNavigationBarItem(
              icon: Icon(Icons.home_work_outlined), 
               activeIcon: Icon(Icons.home_work_rounded), 
              
              label: "Mosque"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: "Profil"),
        ],
      ),
    );
  }
}
