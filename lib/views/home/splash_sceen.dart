//

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:muslim_guide/views/home/home_screen.dart';
import 'package:muslim_guide/views/home/onboarding.dart';
import '../../core/constants/app_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
 
 void _navigateToRandomScreen() async{
  // 1. On attend réellement 3 secondes
  await Future.delayed(const Duration(seconds: 1));

  // 2. On vérifie si l'écran est toujours affiché pour éviter les erreurs de context
  if (!mounted) return;

  // 3. On choisit la destination
  final bool showOnboarding = Random().nextBool();
  final Widget nextScreen = showOnboarding ? const OnboardingScreen() : const HomeScreen();

  // 4. Navigation Directe (Plus fiable que addPostFrameCallback ici)
  Navigator.of(context).pushReplacement(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Animation de fondu ultra fluide de 1 seconde
        return FadeTransition(
          opacity: animation,
          child: child,
        );
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
   // On attend 3 secondes
  Future.delayed(const Duration(seconds: 2), () {
    _navigateToRandomScreen();
  });
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
