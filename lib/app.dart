import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_guide/views/onboarding/onboarding.dart';
import 'package:muslim_guide/views/splash/splash_sceen.dart';
import 'views/home_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'IKA_DEEN',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // CONFIGURATION PAR DÉFAUT ICI :
      defaultTransition: Transition.leftToRight,
      transitionDuration: const Duration(
          milliseconds: 400), // Optionnel: pour régler la vitesse
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
