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
      title: 'muslim_guide',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
