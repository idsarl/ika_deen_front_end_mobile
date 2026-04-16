import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart'; // Note le 'h' ici
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../core/constants/app_constants.dart';

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

// Assure-toi que ce chemin est correct selon ton projet
import '../../core/constants/app_constants.dart';

class QiblaPage extends StatefulWidget {
  const QiblaPage({super.key});

  @override
  State<QiblaPage> createState() => _QiblaPageState();
}

class _QiblaPageState extends State<QiblaPage> {
  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  /// Vérification des permissions au chargement
  void _checkPermissions() async {
    final status = await FlutterQiblah.checkLocationStatus();
    if (status.enabled &&
        (status.status == LocationPermission.denied ||
            status.status == LocationPermission.deniedForever)) {
      await FlutterQiblah.requestPermissions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppConstants.backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back,
              color: AppConstants.primaryColor,
            ),
          ),
          title: const Text(
            "Qibla",
            style: TextStyle(
                color: AppConstants.primaryColor, fontWeight: FontWeight.bold),
          ),
        ),
//       body: StreamBuilder<QiblahDirection>(
//         stream: FlutterQiblah.qiblahStream,
//         builder: (context, snapshot) {
//           /// ⏳ État de chargement
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(color: Color(0xFF52B788)),
//             );
//           }

//           /// ❌ Gestion des erreurs
//           if (snapshot.hasError) {
//             return Center(
//               child: Text(
//                 "Erreur: ${snapshot.error}",
//                 style: const TextStyle(color: AppConstants.primaryColor),
//               ),
//             );
//           }

//           /// ❌ Cas où aucune donnée n'arrive (ex: pas de magnétomètre)
//           if (!snapshot.hasData) {
//             return const Center(
//               child: Text(
//                 "Capteurs indisponibles",
//                 style: TextStyle(color: AppConstants.primaryColor),
//               ),
//             );
//           }

//          final qiblaData = snapshot.data!;

// // 1. Calcul de l'angle relatif (différence entre le téléphone et la Mecque)
// // On utilise le modulo 360 pour rester dans le cercle
// double relativeAngle = (qiblaData.qiblah - qiblaData.direction) % 360;

// // 2. Normalisation (pour éviter que l'aiguille fasse un tour complet brusque au Nord)
// if (relativeAngle > 180) relativeAngle -= 360;
// if (relativeAngle < -180) relativeAngle += 360;

// // 3. Détection de l'alignement
// final bool aligned = relativeAngle.abs() < 5;

//           return Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Spacer(),

//               /// Texte d'indication dynamique
//               AnimatedDefaultTextStyle(
//                 duration: const Duration(milliseconds: 300),
//                 style: TextStyle(
//                   color: aligned ? const Color(0xFF52B788) : AppConstants.primaryColor,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//                 child: Text(aligned ? "Direction Qibla trouvée ✓" : "Tournez votre téléphone"),
//               ),

//               const SizedBox(height: 60),

//               Center(
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     /// 🕌 Icône de la Mosquée (Point de repère fixe en haut)
//                     Transform.translate(
//                       offset: const Offset(0, -160),
//                       child: AnimatedContainer(
//                         duration: const Duration(milliseconds: 300),
//                         child: Icon(
//                           Icons.mosque,
//                           color: aligned ? const Color(0xFF52B788) : AppConstants.primaryColor.withOpacity(0.5),
//                           size: aligned ? 50 : 40,
//                         ),
//                       ),
//                     ),

//                     /// 🧭 Le cadran de la boussole (Tourne pour indiquer le Nord réel)
//                     AnimatedRotation(
//                       turns: (qiblaData.direction * -1) / 360,
//                       duration: const Duration(milliseconds: 300),
//                       child: _buildCompassDial(),
//                     ),

//                     /// 📍 L'aiguille de la Qibla
//                     /// Elle tourne selon la 'diff' relative pour pointer vers la mosquée en haut
//                    /// 📍 Aiguille Qibla
// AnimatedRotation(
//   // On utilise l'angle relatif divisé par 360 pour obtenir le nombre de tours
//   // turns: relativeAngle / 360,
//   turns: (qiblaData.qiblah * -1) / 360,
//   duration: const Duration(milliseconds: 400),
//   curve: Curves.easeOutBack,
//   child: _buildQiblaNeedle(aligned), // Passe 'aligned' pour changer la couleur
// ),
//                   ],
//                 ),
//               ),

//               const Spacer(),

//               /// ℹ️ Texte d'aide
//               _buildInfoText(),

//               const SizedBox(height: 50),
//             ],
//           );
//         },
//       ),
        body: FutureBuilder(
            future: FlutterQiblah.androidDeviceSensorSupport(),
            builder: (context, AsyncSnapshot<bool?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // Si le capteur n'est pas supporté (ex: pas de magnétomètre)
              if (snapshot.hasData && snapshot.data == false) {
                return const Center(
                  child: Text(
                      "Votre appareil ne possède pas de magnétomètre (boussole)."),
                );
              }

              // Si supporté, on affiche le StreamBuilder
              return StreamBuilder<QiblahDirection>(
                stream: FlutterQiblah.qiblahStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData) {
                    return const Center(
                        child: Text("En attente des données du capteur..."));
                  }

                  final qiblaData = snapshot.data!;

// Normalisation des angles
                  double direction = qiblaData.direction % 360;
                  double qiblah = qiblaData.qiblah % 360;

// Calcul de l'écart réel
                  double relativeAngle = qiblah - direction;

                  if (relativeAngle > 180) relativeAngle -= 360;
                  if (relativeAngle < -180) relativeAngle += 360;

// Alignement
                  final bool aligned = relativeAngle.abs() < 8;

                  // --- PRINTS TEMPS RÉEL ---
                  print("---------------------------------------");
                  print(
                      "Nord Téléphone (direction): ${qiblaData.direction.toStringAsFixed(2)}°");
                  print(
                      "Angle Qibla (qiblah): ${qiblaData.qiblah.toStringAsFixed(2)}°");
                  print("Écart Relatif: ${relativeAngle.toStringAsFixed(2)}°");
                  print("Statut: ${aligned ? 'ALIGNÉ ✓' : 'EN ROTATION...'}");

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: TextStyle(
                          color: aligned
                              ? const Color(0xFF52B788)
                              : AppConstants.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        child: Text(aligned
                            ? "Direction Qibla trouvée ✓"
                            : "Tournez votre téléphone"),
                      ),
                      const SizedBox(height: 60),
                      Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Icône Mosquée Fixe
                            Transform.translate(
                              offset: const Offset(0, -160),
                              child: Icon(
                                Icons.mosque,
                                color: aligned
                                    ? const Color(0xFF52B788)
                                    : AppConstants.primaryColor
                                        .withOpacity(0.5),
                                size: aligned ? 50 : 40,
                              ),
                            ),

                            // Boussole (Tourne selon le Nord)
                            AnimatedRotation(
                              turns: (qiblaData.direction * -1) / 360,
                              duration: const Duration(milliseconds: 300),
                              child: _buildCompassDial(),
                            ),

                            // Aiguille Qibla (CORRECTION ICI)
                            // On utilise relativeAngle pour qu'elle rejoigne l'icône en haut
                            AnimatedRotation(
                              turns: (qiblaData.qiblah * -1) / 360,
                              // turns: (-relativeAngle) / 360,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOutBack,
                              child: _buildQiblaNeedle(aligned),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      _buildInfoText(),
                      const SizedBox(height: 50),
                    ],
                  );
                },
              );
            }));
  }

  Widget _buildInfoText() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: Text(
        "Alignez l'aiguille verte avec l'icône de la mosquée pour trouver la Kaaba.",
        textAlign: TextAlign.center,
        style: TextStyle(color: AppConstants.primaryColor, fontSize: 14),
      ),
    );
  }

  /// Widget du cadran (N, E, S, O)
  Widget _buildCompassDial() {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
            color: AppConstants.primaryColor.withOpacity(0.2), width: 2),
      ),
      child: Stack(
        children: [
          _buildDirectionText("N", 0),
          _buildDirectionText("E", math.pi / 2),
          _buildDirectionText("S", math.pi),
          _buildDirectionText("O", -math.pi / 2),
        ],
      ),
    );
  }

  Widget _buildDirectionText(String label, double angle) {
    return Align(
      alignment: Alignment(math.sin(angle) * 0.8, -math.cos(angle) * 0.8),
      child: Text(
        label,
        style: const TextStyle(
          color: AppConstants.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  /// Widget de l'aiguille avec changement de couleur si aligné
  Widget _buildQiblaNeedle(bool isAligned) {
    final color = isAligned ? const Color(0xFF00FF88) : const Color(0xFF52B788);
    return Container(
      width: 6,
      height: 140,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: isAligned ? 15 : 5,
            spreadRadius: isAligned ? 2 : 0,
          )
        ],
      ),
    );
  }
}
