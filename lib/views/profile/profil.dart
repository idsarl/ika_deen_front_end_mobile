import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import '../../widgets/widget_global.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    // Animation qui part du bas (0.1) vers sa position finale (0)
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    // On lance l'animation dès que le widget est prêt
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundLightPink = Color(0xFFFBE9EF);
    const Color backgroundLightPurple = Color(0xFFE8EAF6);
    const Color cardColor = Colors.white;
    const Color premiumColor = Color(0xFFFFC1D9);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [backgroundLightPink, backgroundLightPurple],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Mon Compte",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 25),

                    // Carte Profil
                    _buildProfileCard(cardColor),
                    const SizedBox(height: 25),

                    // Carte Premium
                    _buildPremiumCard(premiumColor),
                    const SizedBox(height: 25),

                    // // Groupe 1 : Paramètres
                    // buildSettingsGroup([
                    //   buildSettingsTile(Icons.settings_outlined,
                    //       "Paramètres de l'application"),
                    //   buildSettingsTile(
                    //       Icons.ios_share, "Exporter mes données"),
                    //   buildSettingsTile(Icons.history, "Restaurer les données"),
                    // ]),
                    // const SizedBox(height: 20),

                    // // Groupe 2 : Support
                    // buildSettingsGroup([
                    //   buildSettingsTile(
                    //       Icons.bar_chart, "Graphiques et rapports"),
                    //   buildSettingsTile(
                    //       Icons.lock_outline, "Verrouillage de l'app"),
                    //   buildSettingsTile(Icons.notifications_none, "Rappels"),
                    //   buildSettingsTile(
                    //       Icons.headset_mic_outlined, "Aide & Support"),
                    // ]),
                    // --- SECTION : PARAMÈTRES DE PRATIQUE (ISLAM) ---
const Text(
  "Pratique & Prière",
  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
),
const SizedBox(height: 10),
buildSettingsGroup([
  buildSettingsTile(
    Icons.access_time_outlined, 
    "Ajustement des horaires", 
    subtitle: "Calcul des angles, Hanafi/Shafi'i"
  ),
  buildSettingsTile(
    Icons.notifications_active_outlined, 
    "Notifications de l'Adhan", 
    subtitle: "Choisir le Moazzin pour chaque prière"
  ),
  buildSettingsTile(
    Icons.location_on_outlined, 
    "Localisation automatique", 
    subtitle: "Basé sur votre position actuelle"
  ),
]),

const SizedBox(height: 25),

// --- SECTION : COMPTE & DONNÉES (GENERAL) ---
const Text(
  "Compte & Données",
  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
),
const SizedBox(height: 10),
buildSettingsGroup([
  buildSettingsTile(Icons.lock_outline, "Verrouillage de l'application"),
  buildSettingsTile(Icons.cloud_upload_outlined, "Sauvegarde & Restauration"),
  buildSettingsTile(Icons.language_outlined, "Langue de l'application"),
  buildSettingsTile(Icons.dark_mode_outlined, "Mode sombre"),
]),

const SizedBox(height: 25),

// --- SECTION : SUPPORT & INFOS ---
const Text(
  "Autres",
  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
),
const SizedBox(height: 10),
buildSettingsGroup([
  buildSettingsTile(Icons.info_outline, "À propos de l'application"),
  buildSettingsTile(Icons.star_outline, "Noter l'application"),
  buildSettingsTile(Icons.share_outlined, "Partager avec des proches"),
  buildSettingsTile(
   Icons.logout, 
    "Déconnexion", 
    color: Colors.redAccent // Couleur rouge pour la sortie
  ),
]),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: softCardDecoration(color),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage('assets/images/user_profil.png'),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Aly Bah",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("aly@gmail.com",
                    style: TextStyle(fontSize: 14, color: Colors.black54)),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFF0F0F0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Modifier",
                style: TextStyle(color: Colors.black, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumCard(Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: softCardDecoration(color),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Colors.black, shape: BoxShape.circle),
            child: const Icon(Icons.star, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Accès Premium",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("Profitez de toutes les fonctionnalités",
                    style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
