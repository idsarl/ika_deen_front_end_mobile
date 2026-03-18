import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_guide/views/home/home_screen.dart';

import '../../models/dto/permission_type.dart';

class DynamicPermissionPage extends StatelessWidget {
  final PermissionType permission;

  const DynamicPermissionPage({super.key, required this.permission});

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icône animée ou illustrée
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(seconds: 1),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E5631).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        permission.icon,
                        size: 80,
                        color: const Color(0xFF1E5631),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),

              // Texte Dynamique
              Text(
                permission.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                permission.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const Spacer(),

              // Bouton Autoriser (Soft & Large)
              ElevatedButton(
                onPressed: () {
                  permission.onGrant();
                  Navigator.pop(context); // Retour après action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E5631),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Autoriser",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),

              // Bouton Refuser (Discret)
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Future.delayed(const Duration(milliseconds: 300), () {
                    Get.to(const HomeScreen(),
                        transition: Transition.leftToRight);
                  });
                },
                child: Text(
                  "Plus tard",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
