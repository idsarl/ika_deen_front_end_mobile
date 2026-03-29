
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart'; // N'oublie pas d'ajouter intl dans pubspec.yaml

class MosqueController extends GetxController {
  // Tes horaires de référence
  final Map<String, String> prayerTimes = {
    "Fajr": "05:12",
    "Dhuhr": "12:41",
    "Asr": "15:58",
    "Maghrib": "18:45",
    "Isha": "20:01",
  };

  final List<Map<String, dynamic>> manualMosques = [
    {
      "name": "Grande Mosquée de Bamako",
      "address": "Avenue de l'Indépendance",
      "lat": 12.6458,
      "lng": -7.9922,
    },
    {
      "name": "Mosquée d'Hamdallaye",
      "address": "ACI 2000, Bamako",
      "lat": 12.6322,
      "lng": -8.0254,
    },
    {
      "name": "Mosquée King Fahd",
      "address": "Boulkassoumbougou",
      "lat": 12.6650,
      "lng": -7.9550,
    },
  ].obs;

  var selectedMosque = {}.obs;
  var nextPrayerName = "".obs;
  var minutesRemaining = 0.obs;

  void selectMosque(Map<String, dynamic> mosque) {
    selectedMosque.value = mosque;
    _calculateNextPrayer();
  }

  void _calculateNextPrayer() {
    DateTime now = DateTime.now();
    DateTime? nextPrayerDateTime;
    String nextName = "";

    // On parcourt les prières pour trouver la prochaine
    prayerTimes.forEach((name, time) {
      List<String> parts = time.split(':');
      DateTime pTime = DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));

      // Si la prière est après maintenant ET (on n'a pas encore de candidate OU elle est plus tôt que la candidate actuelle)
      if (pTime.isAfter(now)) {
        if (nextPrayerDateTime == null || pTime.isBefore(nextPrayerDateTime!)) {
          nextPrayerDateTime = pTime;
          nextName = name;
        }
      }
    });

    // Si aucune prière n'est trouvée (après Isha), la prochaine est le Fajr de demain
    if (nextPrayerDateTime == null) {
      nextName = "Fajr";
      List<String> parts = prayerTimes["Fajr"]!.split(':');
      nextPrayerDateTime = DateTime(now.year, now.month, now.day + 1, int.parse(parts[0]), int.parse(parts[1]));
    }

    nextPrayerName.value = nextName;
    minutesRemaining.value = nextPrayerDateTime!.difference(now).inMinutes;
  }
}