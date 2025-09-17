import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lib17000ft/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushNotificationService {
  static void initialize() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//   RemoteNotification? notification = message.notification;

//   if (notification != null && notification.title != null) {
//     print('this is notifiation $notification');
//     // 1. Show push notification in system tray
//     flutterLocalNotificationsPlugin.show(
//       0,
//       notification.title,
//       notification.body,
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'library_channel',
//           'Library Notifications',
//           importance: Importance.max,
//           priority: Priority.high,
//         ),
//       ),
//     );

//     // 2. Save to local storage (with custom formatted string)
//     final prefs = await SharedPreferences.getInstance();
//     final List<String> existing =
//         prefs.getStringList('notifications') ?? [];

//     // Example: Adding type in title, message in body, and timestamp
//     final String type = _detectType(notification.title ?? ''); // Optional helper
//     final String formatted = '$type|${notification.body}|${DateTime.now().toIso8601String()}';

//     existing.insert(0, formatted);
//     await prefs.setStringList('notifications', existing);
//   }
// });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;

      if (notification != null && notification.title != null) {
        // 1. Show the notification
        flutterLocalNotificationsPlugin.show(
          0,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'library_channel',
              'Library Notifications',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
        );

        // 2. Save notification to shared_preferences
        final prefs = await SharedPreferences.getInstance();
        final List<String> existing =
            prefs.getStringList('notifications') ?? [];

        final timestamp = DateTime.now().toIso8601String();
        final newNotification =
            '${notification.title}|${notification.body}|$timestamp';

        existing.insert(0, newNotification); // newest first
        await prefs.setStringList('notifications', existing);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Navigate to NotificationScreen if needed
    });
  }

  static String _detectType(String title) {
    print('this is title i got for $title');
    title = title.toLowerCase();
    if (title.contains("return") || title.contains("due")) return "Reminder";
    if (title.contains("warning") || title.contains("missed")) return "Alert";
    return "Info";
  }
}


// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:lib17000ft/main.dart'; // Import where your plugin is initialized

// class PushNotificationService {
//   static void initialize() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification? notification = message.notification;
//       if (notification != null && notification.title != null) {
//         flutterLocalNotificationsPlugin.show(
//           0,
//           notification.title,
//           notification.body,
//           const NotificationDetails(
//             android: AndroidNotificationDetails(
//               'library_channel',
//               'Library Notifications',
//               importance: Importance.max,
//               priority: Priority.high,
//             ),
//           ),
//         );
//       }
//     });

//     // Optional: Handle taps on notifications when app is in background
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       // TODO: Navigate to specific screen if needed
//     });
//   }
// }
