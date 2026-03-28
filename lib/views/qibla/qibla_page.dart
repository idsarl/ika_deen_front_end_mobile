// import 'dart:math' as math;
// import 'package:flutter/material.dart';
// import 'package:flutter_qiblah/flutter_qiblah.dart';

// class QiblaPage extends StatefulWidget {
//   const QiblaPage({super.key});

//   @override
//   State<QiblaPage> createState() => _QiblaPageState();
// }

// class _QiblaPageState extends State<QiblaPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0F172A), // Bleu très foncé
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: const Icon(Icons.arrow_back_ios, color: Colors.white),
//         title: const Text("Qibla Finder", style: TextStyle(color: Colors.white)),
//         actions: [
//           IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: Colors.white)),
//           IconButton(onPressed: () {}, icon: const Icon(Icons.grid_view, color: Colors.white)),
//         ],
//       ),
//       body: StreamBuilder(
//         stream: FlutterQibla.qiblaStream,
//         builder: (context, AsyncSnapshot<QiblaDirection> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator(color: Color(0xFF52B788)));
//           }

//           final qiblaDirection = snapshot.data!;

//           return Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Spacer(),
//               // --- Boussole Animée ---
//               Center(
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     // Décoration : L'icône de la Kaaba en haut
//                     Transform.translate(
//                       offset: const Offset(0, -160),
//                       child: const Icon(Icons.mosque, color: Colors.white, size: 40),
//                     ),

//                     // Cercle de la boussole (Rotation inverse du Nord)
//                     AnimatedRotation(
//                       turns: (qiblaDirection.direction * -1) / 360,
//                       duration: const Duration(milliseconds: 300),
//                       child: _buildCompassDial(),
//                     ),

//                     // L'aiguille de la Qibla (Rotation vers la Mecque)
//                     AnimatedRotation(
//                       turns: (qiblaDirection.qibla * -1) / 360,
//                       duration: const Duration(milliseconds: 400),
//                       curve: Curves.easeOutBack,
//                       child: _buildQiblaNeedle(),
//                     ),
//                   ],
//                 ),
//               ),
//               const Spacer(),
//               // --- Texte descriptif ---
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 40.0),
//                 child: Text(
//                   "Alignez l'aiguille avec l'icône de la Kaaba pour trouver la direction exacte.",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Colors.white.withOpacity(0.7),
//                     fontSize: 15,
//                     height: 1.5,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 50),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   // Widget pour le cadran de la boussole (N, S, E, W)
//   Widget _buildCompassDial() {
//     return Container(
//       width: 280,
//       height: 280,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         border: Border.all(color: Colors.white24, width: 2),
//       ),
//       child: Stack(
//         children: [
//           _buildDirectionText("N", 0),
//           _buildDirectionText("E", math.pi / 2),
//           _buildDirectionText("S", math.pi),
//           _buildDirectionText("W", -math.pi / 2),
//           // Petits traits de graduation
//           Center(
//              child: CustomPaint(
//                painter: CompassTicksPainter(),
//                size: const Size(260, 260),
//              ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDirectionText(String label, double angle) {
//     return Align(
//       alignment: Alignment(math.sin(angle) * 0.8, -math.cos(angle) * 0.8),
//       child: Text(label, style: const TextStyle(color: Color(0xFF52B788), fontWeight: FontWeight.bold)),
//     );
//   }

//   // Widget pour l'aiguille centrale
//   Widget _buildQiblaNeedle() {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         // Effet de halo lumineux derrière l'aiguille
//         Container(
//           width: 20,
//           height: 180,
//           decoration: BoxDecoration(
//             boxShadow: [
//               BoxShadow(
//                 color: const Color(0xFF52B788).withOpacity(0.3),
//                 blurRadius: 20,
//                 spreadRadius: 5,
//               ),
//             ],
//           ),
//         ),
//         // L'aiguille elle-même
//         Container(
//           width: 6,
//           height: 150,
//           decoration: BoxDecoration(
//             color: const Color(0xFF52B788),
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//         // Le centre de l'aiguille
//         Container(
//           width: 25,
//           height: 25,
//           decoration: const BoxDecoration(
//             color: Color(0xFF52B788),
//             shape: BoxShape.circle,
//           ),
//         ),
//       ],
//     );
//   }
// }

// // Peintre pour les petits traits de la boussole
// class CompassTicksPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.white10
//       ..strokeWidth = 2;

//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = size.width / 2;

//     for (var i = 0; i < 360; i += 10) {
//       final angle = i * math.pi / 180;
//       final start = Offset(center.dx + math.cos(angle) * (radius - 10), center.dy + math.sin(angle) * (radius - 10));
//       final end = Offset(center.dx + math.cos(angle) * radius, center.dy + math.sin(angle) * radius);
//       canvas.drawLine(start, end, paint);
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart'; // Note le 'h' ici
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

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

  void _checkPermissions() async {
    final status = await FlutterQiblah.checkLocationStatus();
    if (status.enabled && status.status == LocationPermission.denied) {
      await FlutterQiblah.requestPermissions();
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: const Color(0xFF0F172A),
  //     appBar: AppBar(
  //       backgroundColor: Colors.transparent,
  //       elevation: 0,
  //       title:
  //           const Text("Qibla Finder", style: TextStyle(color: Colors.white)),
  //     ),
  //     body: StreamBuilder(
  //       // Le nom exact de la classe est FlutterQiblah (avec h)
  //       stream: FlutterQiblah.qiblahStream,
  //       builder: (context, AsyncSnapshot<QiblahDirection> snapshot) {
  //         // <-- QiblahDirection avec h
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return const Center(
  //               child: CircularProgressIndicator(color: Color(0xFF52B788)));
  //         }

  //         if (snapshot.data == false) {
  //           return const Center(
  //             child: Text(
  //                 "Ce appareil ne possède pas de magnétomètre (boussole).",
  //                 style: TextStyle(color: Colors.white)),
  //           );
  //         }

  //            if (!snapshot.hasData) {
  //     return const Center(
  //       child: Text(
  //         "Impossible de récupérer la direction de la Qibla",
  //         style: TextStyle(color: Colors.white),
  //       ),
  //     );
  //   }

  //         if (snapshot.hasError) {
  //           return Center(
  //               child: Text("Erreur: ${snapshot.error}",
  //                   style: const TextStyle(color: Colors.white)));
  //         }

  //         // L'objet snapshot.data contient les angles
  //         final qiblaData = snapshot.data;

  //         return Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             const Spacer(),
  //             Center(
  //               child: Stack(
  //                 alignment: Alignment.center,
  //                 children: [
  //                   // Kaaba Icon fixe en haut
  //                   Transform.translate(
  //                     offset: const Offset(0, -160),
  //                     child: const Icon(Icons.mosque,
  //                         color: Colors.white, size: 40),
  //                   ),

  //                   // La boussole qui tourne selon le Nord
  //                   AnimatedRotation(
  //                     // On utilise .direction
  //                     turns: (qiblaData!.direction * -1) / 360,
  //                     duration: const Duration(milliseconds: 300),
  //                     child: _buildCompassDial(),
  //                   ),

  //                   // L'aiguille qui tourne vers la Qibla
  //                   AnimatedRotation(
  //                     // On utilise .qibla
  //                     turns: (qiblaData.qiblah * -1) / 360,
  //                     duration: const Duration(milliseconds: 400),
  //                     curve: Curves.easeOutBack,
  //                     child: _buildQiblaNeedle(),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             const Spacer(),
  //             _buildInfoText(),
  //             const SizedBox(height: 50),
  //           ],
  //         );
  //       },
  //     ),
  //   );
  // }

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
          style: TextStyle(color: AppConstants.primaryColor),
        ),
      ),
      body: StreamBuilder<QiblahDirection>(
        stream: FlutterQiblah.qiblahStream,
        builder: (context, snapshot) {
          /// ⏳ Chargement
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF52B788),
              ),
            );
          }

          /// ❌ Erreur
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Erreur: ${snapshot.error}",
                style: const TextStyle(color: AppConstants.primaryColor),
              ),
            );
          }

          /// ❌ Pas de données
          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                "Impossible de récupérer la direction de la Qibla",
                style: TextStyle(color: AppConstants.primaryColor),
              ),
            );
          }

          /// ✅ Données disponibles
          final qiblaData = snapshot.data!;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    /// 🕌 Kaaba en haut
                    Transform.translate(
                      offset: const Offset(0, -160),
                      child: const Icon(
                        Icons.mosque,
                        color: AppConstants.primaryColor,
                        size: 40,
                      ),
                    ),

                    /// 🧭 Boussole (tourne selon le nord)
                    AnimatedRotation(
                      turns: (qiblaData.direction * -1) / 360,
                      duration: const Duration(milliseconds: 300),
                      child: _buildCompassDial(),
                    ),

                    /// 📍 Aiguille Qibla
                    AnimatedRotation(
                      turns: (qiblaData.qiblah * -1) / 360,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutBack,
                      child: _buildQiblaNeedle(),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              /// ℹ️ Info texte
              _buildInfoText(),

              const SizedBox(height: 50),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoText() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: Text(
        "Alignez l'aiguille verte avec l'icône de la mosquée.",
        textAlign: TextAlign.center,
        style: TextStyle(color: AppConstants.primaryColor, fontSize: 14),
      ),
    );
  }

  // --- LES WIDGETS DE DESSIN ---

  Widget _buildCompassDial() {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppConstants.primaryColor, width: 2),
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
      child: Text(label,
          style: const TextStyle(
              color: AppConstants.primaryColor, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildQiblaNeedle() {
    return Container(
      width: 6,
      height: 140,
      decoration: BoxDecoration(
        color: const Color(0xFF52B788),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF52B788).withOpacity(0.5), blurRadius: 10)
        ],
      ),
    );
  }
}
