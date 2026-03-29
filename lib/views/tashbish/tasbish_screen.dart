// --- 1. MODÈLE DE DONNÉES DYNAMIQUE ---
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:muslim_guide/core/constants/app_constants.dart';

class RamadanColors {
  static const Color primaryGreen = Color(0xFF1E5631);
  static const Color lightGreenBG = Color(0xFFF8FAF9); // Blanc cassé très doux
  static const Color white = Colors.white;
  static const Color softGrey = Color(0xFF98A2B3);
  static const Color darkText = Color(0xFF101828);
  static const Color beadColor = Color(0xFFFFB057); // Orange chaud
}

class ZikrItem {
  final String arabic;
  final String transliteration;
  final String translation;
  ZikrItem(
      {required this.arabic,
      required this.transliteration,
      required this.translation});
}

class SoftTasbihPage extends StatefulWidget {
  const SoftTasbihPage({super.key});
  @override
  State<SoftTasbihPage> createState() => _SoftTasbihPageState();
}

class _SoftTasbihPageState extends State<SoftTasbihPage>
    with SingleTickerProviderStateMixin {
  int _counter = 0;
  int _zikrIndex = 0;
  late AnimationController _beadController;

  final List<ZikrItem> _zikrs = [
    ZikrItem(
        arabic: "الحمد لله",
        transliteration: "Alhamdulillah",
        translation: "Louange à Allah"),
    ZikrItem(
        arabic: "سبحان الله",
        transliteration: "Subhanallah",
        translation: "Gloire à Allah"),
    ZikrItem(
        arabic: "الله أكبر",
        transliteration: "Allahu Akbar",
        translation: "Allah est le plus Grand"),
  ];

  @override
  void initState() {
    super.initState();
    _beadController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  void _handleTap() {
    if (_beadController.isAnimating) return;

    HapticFeedback.mediumImpact(); // Vibration physique
    _beadController.forward(from: 0).then((_) {
      setState(() {
        _counter++;
      });
    });
  }

  void _nextZikr() {
    setState(() {
      _zikrIndex = (_zikrIndex + 1) % _zikrs.length;
      _counter = 0; // Reset le compteur pour le nouveau Zikr
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentZikr = _zikrs[_zikrIndex];

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppConstants.backgroundColor,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: AppConstants.primaryColor,
            )),
        centerTitle: true,
        title: const Text("Tasbih",
            style: TextStyle(
                color: AppConstants.primaryColor, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // 1. CARTE DE ZIKR DYNAMIQUE
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: RamadanColors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 20,
                      offset: const Offset(0, 10))
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: _nextZikr,
                        icon: const Icon(Icons.refresh,
                            size: 18, color: RamadanColors.primaryGreen),
                        label: const Text("Changer",
                            style:
                                TextStyle(color: RamadanColors.primaryGreen)),
                      ),
                    ],
                  ),
                  Text(currentZikr.arabic,
                      style: const TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                          color: RamadanColors.primaryGreen)),
                  const SizedBox(height: 10),
                  Text(currentZikr.transliteration,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                  Text(currentZikr.translation,
                      style: const TextStyle(color: RamadanColors.softGrey)),
                ],
              ),
            ),
          ),

          const Spacer(),

          // 2. LE COMPTEUR SOFT
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: ScaleTransition(scale: anim, child: child)),
            child: Text(
              '$_counter',
              key: ValueKey(_counter),
              style: const TextStyle(
                  fontSize: 90,
                  fontWeight: FontWeight.w900,
                  color: RamadanColors.darkText,
                  letterSpacing: -2),
            ),
          ),

          const Spacer(),

          // 3. LE CHAPELET ANIMÉ (PERLES)
          GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity! > 0)
                _handleTap(); // Swipe vers la droite
            },
            onTap: _handleTap,
            child: Container(
              height: 200,
              width: double.infinity,
              color: Colors.transparent,
              child: AnimatedBuilder(
                animation: _beadController,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Corde du chapelet
                      Positioned(
                        top: 90,
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 2,
                            color: RamadanColors.softGrey.withOpacity(0.2)),
                      ),
                      // Perles à GAUCHE (Équipe attente)
                      _buildBead(-2, 0),
                      _buildBead(-1, 0),
                      // Perle CENTRALE qui bouge
                      _buildBead(0, _beadController.value),
                      // Perles à DROITE (Équipe comptée)
                      _buildBead(1, _beadController.value),
                      _buildBead(2, 0),
                    ],
                  );
                },
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: Text("Glissez ou tapez pour compter",
                style: TextStyle(color: RamadanColors.softGrey)),
          ),
        ],
      ),
    );
  }

  // Fonction pour construire une perle avec une position relative
  Widget _buildBead(int position, double animValue) {
    // Calcul de la position X
    // On décale chaque perle selon son index + l'avancement de l'animation
    double spacing = 80.0;
    double xOffset = (position + animValue) * spacing;

    // Opacité : disparait à droite, apparait à gauche
    double opacity = 1.0;
    if (xOffset > 150) opacity = (200 - xOffset) / 50;
    if (xOffset < -150) opacity = (xOffset + 200) / 50;

    return Transform.translate(
      offset: Offset(xOffset, 0),
      child: Opacity(
        opacity: opacity.clamp(0.0, 1.0),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: RamadanColors.beadColor,
            gradient: RadialGradient(
              colors: [
                RamadanColors.beadColor,
                RamadanColors.beadColor.withOpacity(0.8)
              ],
              center: const Alignment(-0.3, -0.3),
            ),
            boxShadow: [
              BoxShadow(
                  color: RamadanColors.beadColor.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 5))
            ],
          ),
        ),
      ),
    );
  }
}
