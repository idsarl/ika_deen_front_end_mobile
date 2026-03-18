//

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:muslim_guide/views/home/home_screen.dart';
import 'package:muslim_guide/views/onboarding/onboarding.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/constants/app_constants.dart';
import '../../models/dto/permission_type.dart';
import '../../services/local_notification/notification_service.dart';
import '../permission_telephone/DynamicPermissionPage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  

  // On crée une instance unique (ou utilise un Singleton si tu préfères)
final _storage = const FlutterSecureStorage();

void _handleInitialNavigation() async {
  // 1. Lecture sécurisée (renvoie une String ou null)
  String? alreadyAskedValue = await _storage.read(key: "notif_asked");
  bool alreadyAsked = alreadyAskedValue == "true";

  // 2. Vérification du statut système actuel
  PermissionStatus status = await Permission.notification.status;

  if (status.isGranted) {
    // CAS A : Déjà autorisé, on fonce
    await Future.delayed(const Duration(seconds: 2));
    _navigateToNextScreen();
  } 
  else if (!alreadyAsked) {
    // CAS B : Jamais demandé, on affiche TA page Soft
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    _showNotificationPermission(context);
  } 
  else {
    // CAS C : Déjà demandé une fois mais refusé, on ne harcèle plus l'utilisateur
    await Future.delayed(const Duration(seconds: 1));
    _navigateToNextScreen();
  }
}

  void _showNotificationPermission(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DynamicPermissionPage(
          permission: PermissionType(
            title: "Restez connecté spirituellement",
            description:
                "Autorisez les notifications pour ne manquer aucun moment important du Ramadan.",
            icon: Icons.notifications_active_outlined,
            onGrant: () async {
              await NotificationService().requestPermissions();
              _navigateToNextScreen();
            },
          ),
        ),
      ),
    );
  }

  void _navigateToNextScreen() {
    if (!mounted) return;

    // On choisit la destination (Onboarding ou Home)
    final bool showOnboarding = Random().nextBool();
    final Widget nextScreen =
        showOnboarding ? const OnboardingScreen() : const HomeScreen();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    // Configuration de l'animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    // Redirection automatique après 3 secondes
    // Timer(const Duration(seconds: 3), () {
    //   if (mounted) {
    //     Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(builder: (context) => const HomeScreen()),
    //     );
    //   }
    // });
    _handleInitialNavigation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Fond d'écran plein écran
          Positioned.fill(
            child: Image.asset(
              'assets/images/s_im.jpeg',
              fit: BoxFit.cover,
            ),
          ),

          // 2. Overlay dégradé plus intense pour le côté "cinématique"
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),

          // 3. Contenu centré et animé
          FadeTransition(
            opacity: _fadeAnimation,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo IKA DEEN
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: AppConstants.lightGreen,
                      size: 60,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'IKA DEEN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'VOTRE COMPAGNON SPIRITUEL',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. Petit indicateur de chargement discret en bas
          // Positioned(
          //   bottom: 50,
          //   left: 0,
          //   right: 0,
          //   child: Center(
          //     child: SizedBox(
          //       width: 30,
          //       height: 30,
          //       child: CircularProgressIndicator(
          //         strokeWidth: 2,
          //         valueColor: AlwaysStoppedAnimation<Color>(
          //           AppConstants.lightGreen.withOpacity(0.5),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
