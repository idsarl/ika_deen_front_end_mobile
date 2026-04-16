import 'dart:async';

import 'package:flutter/material.dart';
import 'app.dart';
import 'services/local_notification/notification_service.dart';



void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    final notificationService = NotificationService();

    try {
      await notificationService.init();
      // ❗ IMPORTANT : désactive pour test
      // await notificationService.scheduleRamadanSequence();
    } catch (e, stack) {
      print("❌ INIT ERROR: $e");
      print(stack);
    }

    FlutterError.onError = (FlutterErrorDetails details) {
      print("🔥 FLUTTER ERROR: ${details.exception}");
      print(details.stack);
    };

    runApp(const MyApp());
  }, (error, stack) {
    print("💥 ZONE ERROR: $error");
    print(stack);
  });
}