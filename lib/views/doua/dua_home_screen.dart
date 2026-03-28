import 'package:flutter/material.dart';
import 'dart:ui'; // Pour l'effet de flou

class DuaHomeScreen extends StatefulWidget {
  const DuaHomeScreen({super.key});

  @override
  _DuaHomeScreenState createState() => _DuaHomeScreenState();
}

class _DuaHomeScreenState extends State<DuaHomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _slideAnimation = Tween<Offset>(
            begin: const Offset(0, 1), end: const Offset(0, 0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward(); // Lance l'animation au chargement
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8), // Fond très clair et apaisant
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Catégories populaires",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    _buildDuaCategoryCard("Duas du Matin",
                        Icons.wb_sunny_outlined, "Protections et bénédictions"),
                    _buildDuaCategoryCard("Duas du Soir",
                        Icons.nightlight_round, "Tranquillité et pardon"),
                    _buildDuaCategoryCard("Pour la Famille",
                        Icons.family_restroom, "Santé et bonheur"),
                    _buildDuaCategoryCard(
                        "En cas de Difficulté",
                        Icons.shield_moon_outlined,
                        "Patience et soulagement"), // Icône exemple
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 220.0,
      floating: false,
      pinned: true,
      backgroundColor: Colors.teal, // Ou AppConstants.primaryColor
      flexibleSpace: FlexibleSpaceBar(
        title: const Text("Mes Invocations (Dua)",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Image de fond (ex: mains levées, mosquée douce)
            Image.asset(
                'assets/images/h_doua_a.jpg',
                fit: BoxFit.cover),
            // Dégradé sombre pour le texte
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDuaCategoryCard(String title, IconData icon, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: Colors.teal, size: 28),
        ),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        subtitle: Text(subtitle,
            style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {
          // Naviguer vers la liste précise des duas de cette catégorie
          // Navigator.push(context, MaterialPageRoute(builder: (context) => DuaListScreen(category: title)));
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
