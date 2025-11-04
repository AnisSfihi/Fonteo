import 'dart:ui';
import 'package:aqua_sense/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// notif_methods.dart
// Petites fonctions pour envoyer des notifs Android sympa
// (rappels et conseils pour l'utilisateur)

// --- Rappel pour la géoloc
// Notif stylée qui suggère de désactiver le GPS après usage
// (économie de batterie + vie privée)
Future<void> showNotificationDesactivation() async {
  const androidDetails = AndroidNotificationDetails(
    'geo_channel',
    'Conseils GPS',
    channelDescription: 'Notifications liées à la géolocalisation et à l\'utilisation des sources d\'eau',
    importance: Importance.max,
    priority: Priority.high,
    icon: 'ic_stat_source_colored', // Assure-toi que cette icône existe dans ton projet Android
    color: Color(0xFF2196F3), // Bleu AquaSense
    styleInformation: BigTextStyleInformation(
      'Pour préserver votre batterie et votre vie privée, désactivez la géolocalisation après utilisation.',
      contentTitle: '💧 Astuce Fonteo',
      summaryText: 'Géolocalisation active',
    ),
    playSound: true,
  );
  const notifDetails = NotificationDetails(android: androidDetails);
  await flutterLocalNotificationsPlugin.show(
    1,
    '💧 Astuce Fonteo',
    'Pour préserver votre batterie, désactivez la géolocalisation après utilisation.',
    notifDetails,
  );
}
