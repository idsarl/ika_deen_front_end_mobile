import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_guide/core/constants/app_constants.dart';
import 'package:muslim_guide/views/home/home_screen.dart';

import '../../widgets/widget_global.dart';

// Modèle simple pour les données des pages
class OnboardingData {
  final String title;
  final String description;
  final String image;

  OnboardingData(
      {required this.title, required this.description, required this.image});
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  int _currentPage = 0;

// Liste des pages en Français - Focus Religion Globale
  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Le Noble Coran\nà portée de main',
      description:
          'Lisez, écoutez et étudiez le Coran avec des traductions et des récitations de qualité, où que vous soyez.',
      image: 'assets/images/s_im.jpeg',
    ),
    OnboardingData(
      title: 'Ne perdez jamais\nvotre Direction',
      description:
          'Une boussole précise pour la Qibla et la localisation des mosquées les plus proches de vous en un clic.',
      image: 'assets/images/s_im.jpeg',
    ),
    OnboardingData(
      title: 'Vivez votre Foi\nau quotidien',
      description:
          'Horaires de prière précis, rappels d\'Adhkars et outils spirituels pour enrichir votre pratique de l\'Islam.',
      image: 'assets/images/s_im.jpeg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Image d'arrière-plan avec transition douce
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Container(
              key: ValueKey<int>(_currentPage),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(_pages[_currentPage].image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // 2. Dégradé sombre
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.85),
                ],
              ),
            ),
          ),

          // 3. Contenu dynamique (PageView)
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Logo Header Fixe
                _buildHeader(),

                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      return _buildPageContent(_pages[index]);
                    },
                  ),
                ),

                // 4. Indicateurs et Boutons Fixes
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: [
                      _buildTrackers(),
                      const SizedBox(height: 40),
                      // _buildActionButtons(),
                      btnSmall2ByRow(
                          "Connexion",
                          AppConstants.backgroundColor,
                          AppConstants.textPrimary,
                          () {},
                          "Passer",
                          AppConstants.primaryColor,
                          AppConstants.lightGreen, () {
                        Get.to(const HomeScreen());
                      }),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white24),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_awesome, color: Color(0xFFD4AF37), size: 20),
          SizedBox(width: 8),
          Text(
            'IKA DEEN',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent(OnboardingData page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            page.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
              fontFamily: 'Serif',
              height: 1.1,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            page.description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildTrackers() {
    return Row(
      children: List.generate(
        _pages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(right: 8),
          height: 4,
          width: _currentPage == index ? 40 : 20,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? Colors.white
                : Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text('S\'INSCRIRE',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
              side: const BorderSide(color: Colors.white24),
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text(
              'CONNEXION',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
