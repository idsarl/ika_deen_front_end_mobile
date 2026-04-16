import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

import 'package:flutter_timezone/flutter_timezone.dart'; // Ajoute ce package



class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> requestPermissions() async {
    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      await androidImplementation?.requestNotificationsPermission();
    }
  }

  Future<void> init() async {
  tz.initializeTimeZones();

  // Récupérer le nom du fuseau horaire local (ex: "Africa/Bamako")
  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  
  // Configurer la localisation locale pour que tz.local fonctionne
  tz.setLocalLocation(tz.getLocation(timeZoneName));

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // --- AJOUT CRUCIAL ICI ---
  // On crée le canal de force pour Android
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'default_channel', // L'ID que tu utilises dans _scheduleNotification
    'Rappels de Prière', 
    description: 'Notifications pour le Ramadan',
    importance: Importance.max, // Indispensable pour que ça "pop" à l'écran
    // playSound: true,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}


  // Fonction pour envoyer une notification immédiate (Test)
  Future<void> showInstantNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'ikadeen_channel',
      'IKADEEN Routine',
      importance: Importance.max,
      priority: Priority.high,
      // Design soft : on peut ajouter un son personnalisé ici
    );

    const NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails, iOS: DarwinNotificationDetails());

    await flutterLocalNotificationsPlugin.show(0, title, body, platformDetails);
  }

  Future<void> showIslamicNotification(String title, String body) async {
    // 1. Définition du son pour Android (sans l'extension)
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'ikandeen_prayer_channel', // ID unique pour ce type de son
      'IKADEEN Prayers',
      importance: Importance.max,
      priority: Priority.high,
      // sound: RawResourceAndroidNotificationSound(
      //     'islamic_tone'), // Nom du fichier dans /raw
      // playSound: true,
    );

    // 2. Définition du son pour iOS (avec l'extension)
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentSound: true,
      // sound:
      //     'islamic_tone.aiff', // iOS préfère .aiff ou .caf, mais .mp3 marche souvent
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      1, // ID de la notification
      title,
      body,
      platformDetails,
    );
  }

  Future<void> _scheduleNotification({
  required int id,
  required String title,
  required String body,
  required DateTime scheduledTime,
  String? sound,
}) async {
  if (scheduledTime.isBefore(DateTime.now())) return;

  await flutterLocalNotificationsPlugin.zonedSchedule(
    id,
    title,
    body,
    tz.TZDateTime.from(scheduledTime, tz.local),
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'default_channel', // DOIT être identique à celui dans init()
        'Rappels de Prière',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        // sound: sound != null ? RawResourceAndroidNotificationSound(sound) : null,
      ),
      iOS: DarwinNotificationDetails(presentAlert: true, presentSound: true),
    ),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  );
}

  Future<void> scheduleDailyPrayers(Map<String, String> prayerTimings) async {
  final now = DateTime.now();

  for (final entry in prayerTimings.entries) {
    final prayerName = entry.key;
    final time = entry.value;

    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    final prayerTime = DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // 🔥 Si l'heure est déjà passée → on programme pour demain
    final scheduledTime = prayerTime.isBefore(now)
        ? prayerTime.add(const Duration(days: 1))
        : prayerTime;

    final int baseId = prayerName.hashCode;

    // ✅ Notification principale
    await _scheduleNotification(
      id: baseId,
      title: "C'est l'heure du $prayerName 🕌",
      body: "Qu'Allah accepte vos prières.",
      scheduledTime: scheduledTime,
    );

    // ✅ Rappel 5 min avant
    final reminderTime = scheduledTime.subtract(const Duration(minutes: 5));

    if (reminderTime.isAfter(now)) {
      await _scheduleNotification(
        id: baseId + 1,
        title: "$prayerName dans 5 minutes",
        body: "Préparez-vous pour la prière ✨",
        scheduledTime: reminderTime,
      );
    }
  }

  print("✅ Notifications journalières programmées !");
}

  Future<void> scheduleRamadanSequence() async {
    // 1. Définition des horaires types
    final Map<String, String> prayerTimings = {
      "Imsak (Fin Sahoor)": "05:05:00",
      "Fajr": "05:15:00",
      "Dhuhr": "14:37:00",
      "Asr": "15:20:00",
      "Maghrib (Iftar)": "18:50:00",
      "Isha": "20:10:00",
    };

    // --- AJOUT TEST RAPIDE ---
    // On crée une notification qui sonne dans 8 minutes à partir de MAINTENANT
    final DateTime testTime = DateTime.now().add(const Duration(minutes: 1));
    await _scheduleNotification(
      id: 9999, // ID unique pour le test
      title: "Test Notification (8 min) 🚀",
      body: "Bravo ! Le système de rappel fonctionne parfaitement même si l'app est fermée.",
      scheduledTime: testTime,
    );
    print("🔔 Notification de test programmée pour : ${testTime.hour}:${testTime.minute}");
    // ------------------------

    // 2. Ta boucle habituelle pour les 7 jours
    for (int i = 0; i < 7; i++) {
      final targetDate = DateTime.now().add(Duration(days: i));

      // prayerTimings.forEach((prayerName, time) async {

     for (final entry in prayerTimings.entries) {
  final prayerName = entry.key;
  final time = entry.value;
        final parts = time.split(':');
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);

        final scheduledDateTime = DateTime(
            targetDate.year, targetDate.month, targetDate.day, hour, minute);

        int mainId = (i * 100) + (prayerName.hashCode % 100);

        await _scheduleNotification(
          id: mainId,
          title: "C'est l'heure du $prayerName 🕌",
          body: "Prenez un moment pour votre prière et vos invocations.",
          scheduledTime: scheduledDateTime,
        );

        int reminderId = mainId + 500;
        final reminderTime = scheduledDateTime.subtract(const Duration(minutes: 5));

        if (reminderTime.isAfter(DateTime.now())) {
          await _scheduleNotification(
            id: reminderId,
            title: "Rappel : $prayerName",
            body: "La prière commence dans 5 minutes. Préparez-vous ✨",
            scheduledTime: reminderTime,
          );
        }
      }
    }

    print("✅ Programmation de 7 jours terminée !");
  }

  // Future<void> scheduleRamadanSequence() async {
  //   // 1. Définition des horaires types (Format 24h)
  //   // Dans une vraie app, cela viendrait d'une API ou d'un package comme 'adhan'
  //   final Map<String, String> prayerTimings = {
  //     "Imsak (Fin Sahoor)": "05:05",
  //     "Fajr": "05:15",
  //     "Dhuhr": "12:55",
  //     "Asr": "15:20",
  //     // "Asr": "16:15",
  //     "Maghrib (Iftar)": "18:50",
  //     "Isha": "20:10",
  //   };

  //   // 2. On planifie pour les 7 prochains jours (pour respecter la limite iOS de 64 notifs)
  //   for (int i = 0; i < 7; i++) {
  //     final targetDate = DateTime.now().add(Duration(days: i));

  //     prayerTimings.forEach((prayerName, time) async {
  //       final parts = time.split(':');
  //       final hour = int.parse(parts[0]);
  //       final minute = int.parse(parts[1]);

  //       // Création de l'objet DateTime pour ce jour précis
  //       final scheduledDateTime = DateTime(
  //           targetDate.year, targetDate.month, targetDate.day, hour, minute);

  //       // --- A. Notification Pile à l'heure ---
  //       // ID unique combinant l'index du jour et le nom de la prière
  //       int mainId = (i * 100) + prayerName.hashCode % 100;

  //       await _scheduleNotification(
  //         id: mainId,
  //         title: "C'est l'heure du $prayerName 🕌",
  //         body: "Prenez un moment pour votre prière et vos invocations.",
  //         scheduledTime: scheduledDateTime,
  //         sound: 'islamic_tone', // Ton fichier dans res/raw
  //       );

  //       // --- B. Rappel "Soft" 5 minutes avant ---
  //       int reminderId = mainId + 500; // ID décalé pour ne pas écraser
  //       final reminderTime =
  //           scheduledDateTime.subtract(const Duration(minutes: 5));

  //       if (reminderTime.isAfter(DateTime.now())) {
  //         await _scheduleNotification(
  //           id: reminderId,
  //           title: "Rappel : $prayerName",
  //           body: "La prière commence dans 5 minutes. Préparez-vous ✨",
  //           scheduledTime: reminderTime,
  //           // Ici on peut utiliser le son par défaut pour différencier de l'Adhan
  //         );
  //       }
  //     });
  //   }

  //   print("✅ Programmation de 7 jours terminée !");
  // }

}
