import 'package:flutter/material.dart';

class PermissionType {
  final String title;
  final String description;
  final IconData icon;
  final String lottieAsset; // Optionnel si tu veux ajouter des animations Lottie
  final VoidCallback onGrant;

  PermissionType({
    required this.title,
    required this.description,
    required this.icon,
    this.lottieAsset = '',
    required this.onGrant,
  });
}