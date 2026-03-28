import 'package:flutter/material.dart';
import 'app.dart';
import 'services/local_notification/notification_service.dart';

void main() async {
  // 1. Indispensable pour les appels asynchrones avant runApp
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialiser le service de notification (Timezones + Settings)
  final notificationService = NotificationService();
  await notificationService.init();
  await notificationService.scheduleRamadanSequence();
  
  runApp(const MyApp());
}
