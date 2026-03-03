// import 'dart:async';
// import 'dart:convert';
// import 'dart:ui';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:http/http.dart' as http;
// import 'package:lib17000ft/forms/book_issue/book_issue.dart';
// import 'package:lib17000ft/main.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../configs/app_urls.dart';
// import '../forms/book_issue/book_issue_repository.dart';
// import '../models/book_issue/book_issue_model.dart';
//
// class PushNotificationService {
//
//   static Future<Map<String, String>> getUserContext() async{
//     final prefs = await SharedPreferences.getInstance();
//
//     final userId = prefs.getString('userId') ?? '';
//     final userName = prefs.getString('username') ?? '';
//     final userState = prefs.getString('location') ?? '';
//     final userRole = prefs.getString('role') ?? '';
//     final userSchool = prefs.getString('school') ?? '';
//
//     print("🔍 Loaded user context: userId=$userId, state=$userState, school=$userSchool");
//
//     return{
//       'userId': userId,
//       'userName': userName,
//       'userState': userState,
//       'userRole': userRole,
//       'userSchool': userSchool,
//     };
//   }
//
//   static Future<void> initialize() async {
//     final androidSettings = AndroidInitializationSettings(
//         '@mipmap/ic_launcher');
//     final initSettings = InitializationSettings(android: androidSettings);
//     await flutterLocalNotificationsPlugin.initialize(initSettings);
//
//     int id = DateTime
//         .now()
//         .millisecondsSinceEpoch
//         .remainder(100000);
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       RemoteNotification? notification = message.notification;
//
//       if (notification != null && notification.title != null) {
//         // 1. Show the notification
//         flutterLocalNotificationsPlugin.show(
//           id,
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
//
//         // 2. Save notification to shared_preferences
//         final prefs = await SharedPreferences.getInstance();
//         final List<String> existing =
//             prefs.getStringList('notifications') ?? [];
//
//         final timestamp = DateTime.now().toIso8601String();
//         final newNotification =
//             '${notification.title}|${notification.body}|$timestamp';
//
//         existing.insert(0, newNotification); // newest first
//         await prefs.setStringList('notifications', existing);
//       }
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       // Navigate to NotificationScreen if needed
//     });
//   }
//
//   static Future<void> initializeService() async {
//     final service = FlutterBackgroundService();
//     await service.configure(
//       androidConfiguration: AndroidConfiguration(
//         onStart: onStart,
//         autoStart: true,
//         isForegroundMode: true,
//       ),
//       iosConfiguration: IosConfiguration(
//         onForeground: onStart,
//         //onBackground: onStart,
//       ),
//     );
//     service.startService();
//   }
//
//   static void onStart(ServiceInstance service) {
//     DartPluginRegistrant.ensureInitialized();
//
//     Timer.periodic(const Duration(seconds: 5), (timer) async {
//       try {
//         List<BookIssueModel> issuedBooks = await fetchIssuedBooks();///This is to fetch book from the API
//         final message = notificationFormat(issuedBooks); ///This is to format the book data
//         await PushNotificationService.showNotification(message);///This is to notify notification service that notification is call
//       } catch (w) {
//         print("Error in background task : $w");
//       }
//     });
//   }
//
//
//
//
//   // static Future<List<BookIssueModel>> fetchIssuedBooksFromApi() async {
//   //   final response = await http.get(
//   //       Uri.parse(AppUrls.getIssuedBookapi));
//   //
//   //   print("📦 Raw response status: ${response.statusCode}");
//   //   print("📦 Raw response body: ${response.body}");
//   //
//   //   if (response.statusCode == 200) {
//   //    try{
//   //      final List<dynamic> data = jsonDecode(response.body)['data']; ///have to change according to api structure
//   //      print("📦 Decoded data: $data");
//   //      final books = data.map((json) => BookIssueModel.fromJson(json)).toList();
//   //      print("📦 Decoded data: $data");
//   //      return books;
//   //    } catch(e) {
//   //      print("📦 Error decoding data : $e");
//   //      return [];
//   //    }
//   //   } else {
//   //     print("📦 Error fetching issued books: ${response.statusCode}");
//   //     throw Exception('Failed to fetch issued books');
//   //   }
//   // }
//
//   static Future<List<BookIssueModel>> fetchIssuedBooks() async{
//     final context = await getUserContext();
//
//     if(context['userId']!.isEmpty || context['userState']!.isEmpty){
//       print("❌ Missing userId or state — cannot fetch issued books");
//       return [];
//     }
//     final BookIssueRepository _repo = BookIssueRepository();
//
//     try{
//       final value = await _repo.getIssuedBook(
//         context['userId'],
//         context['userState'],
//         null, ///district
//         null, ///block
//         context['userSchool'],
//         null, ///from
//         null, ///to
//         null, ///level
//         null, ///language
//         page: 1
//       );
//
//       if(value is Map<String , dynamic> && value['error'] == 0){
//         return (value['data'] as List)
//             .map((json) => BookIssueModel.fromJson(json)).toList();
//       } else {
//         print("❌ Error fetching issued books: $value");
//         return [];
//       }
//
//     } catch (e) {
//       print("❌ Error fetching issued books: $e");
//       return [];
//     }
//
//
//   }
//
//   static String notificationFormat(List<BookIssueModel> books){
//     if(books.isEmpty) return "No Books are currently issued.";
//     return books.map((b) => "${b.title} by ${b.author}").join("\n"); ///Need to update details according to api structure
//   }
//
//   static Future<void> showNotification(String message) async {
//     const androidDetails = AndroidNotificationDetails(
//       'library_channel',
//       'Library Notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//
//     const details = NotificationDetails(android: androidDetails);
//     await flutterLocalNotificationsPlugin.show(
//       DateTime.now().millisecondsSinceEpoch.remainder(100000),
//       'Testing Drop',
//       message,
//       details,
//     );
//   }
//
//   static String _detectType(String title) {
//     print('this is title i got for $title');
//     title = title.toLowerCase();
//     if (title.contains("return") || title.contains("issued"))
//       return "Reminder";
//     if (title.contains("warning") || title.contains("missed")) return "Alert";
//     return "Info";
//   }
//
//
//
//
// }
//
// // import 'package:firebase_messaging/firebase_messaging.dart';
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // import 'package:lib17000ft/main.dart'; // Import where your plugin is initialized
//
// // class PushNotificationService {
// //   static void initialize() {
// //     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
// //       RemoteNotification? notification = message.notification;
// //       if (notification != null && notification.title != null) {
// //         flutterLocalNotificationsPlugin.show(
// //           0,
// //           notification.title,
// //           notification.body,
// //           const NotificationDetails(
// //             android: AndroidNotificationDetails(
// //               'library_channel',
// //               'Library Notifications',
// //               importance: Importance.max,
// //               priority: Priority.high,
// //             ),
// //           ),
// //         );
// //       }
// //     });
//
// //     // Optional: Handle taps on notifications when app is in background
// //     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
// //       // TODO: Navigate to specific screen if needed
// //     });
// //   }
// // }
// //     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
// //   RemoteNotification? notification = message.notification;
//
// //   if (notification != null && notification.title != null) {
// //     print('this is notifiation $notification');
// //     // 1. Show push notification in system tray
// //     flutterLocalNotificationsPlugin.show(
// //       0,
// //       notification.title,
// //       notification.body,
// //       const NotificationDetails(
// //         android: AndroidNotificationDetails(
// //           'library_channel',
// //           'Library Notifications',
// //           importance: Importance.max,
// //           priority: Priority.high,
// //         ),
// //       ),
// //     );
//
// //     // 2. Save to local storage (with custom formatted string)
// //     final prefs = await SharedPreferences.getInstance();
// //     final List<String> existing =
// //         prefs.getStringList('notifications') ?? [];
//
// //     // Example: Adding type in title, message in body, and timestamp
// //     final String type = _detectType(notification.title ?? ''); // Optional helper
// //     final String formatted = '$type|${notification.body}|${DateTime.now().toIso8601String()}';
//
// //     existing.insert(0, formatted);
// //     await prefs.setStringList('notifications', existing);
// //   }
// // });
import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../forms/book_issue/book_issue_repository.dart';
import '../models/book_issue/book_issue_model.dart';

class PushNotificationService {
  /// Singleton instance of FlutterLocalNotificationsPlugin
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  /// Load user-related info from shared preferences
  static Future<Map<String, String>> getUserContext() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? '';
    final userName = prefs.getString('username') ?? '';
    final userState = prefs.getString('location') ?? '';
    final userRole = prefs.getString('role') ?? '';
    final userSchool = prefs.getString('school') ?? '';

    print(
        "🔍 Loaded user context: userId=$userId, state=$userState, school=$userSchool");
    return {
      'userId': userId,
      'userName': userName,
      'userState': userState,
      'userRole': userRole,
      'userSchool': userSchool,
    };
  }

  /// Initialize Firebase messaging & local notifications
  static Future<void> initialize() async {
    // ✅ iOS-specific initialization (required to prevent crashes on iOS)
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      // onDidReceiveLocalNotification can be set if you want custom behavior
      //onDidReceiveLocalNotification: null,
    );

    // ✅ Android-specific initialization
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // ✅ Combine initialization settings
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      macOS: null,
    );

    // Initialize the plugin
    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        // Handle notification tap if needed
        print("Notification tapped: ${response.payload}");
      },
    );

    // Handle foreground messages from Firebase
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;

      if (notification != null && notification.title != null) {
        int id = DateTime.now().millisecondsSinceEpoch.remainder(100000);

        // 1️⃣ Show notification in system tray
        await flutterLocalNotificationsPlugin.show(
          id,
          notification.title,
          notification.body,
          NotificationDetails(
            android: const AndroidNotificationDetails(
              'library_channel',
              'Library Notifications',
              importance: Importance.max,
              priority: Priority.high,
            ),
            iOS: const DarwinNotificationDetails(),
          ),
        );

        // 2️⃣ Save notification locally
        final prefs = await SharedPreferences.getInstance();
        final List<String> existing =
            prefs.getStringList('notifications') ?? [];
        final timestamp = DateTime.now().toIso8601String();
        final newNotification =
            '${notification.title}|${notification.body}|$timestamp';
        existing.insert(0, newNotification);
        await prefs.setStringList('notifications', existing);
      }
    });

    // Handle when app is opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("App opened from notification: ${message.notification?.title}");
      // Navigate to specific screen if needed
    });
  }

  /// Initialize background service for periodic tasks
  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
      ),
      iosConfiguration: IosConfiguration(
        onForeground: onStart,
        // Uncomment if needed: onBackground: onStart,
      ),
    );
    service.startService();
  }

  /// Background task execution
  static void onStart(ServiceInstance service) {
    DartPluginRegistrant.ensureInitialized();

    Timer.periodic(const Duration(seconds: 5), (timer) async {
      try {
        List<BookIssueModel> issuedBooks = await fetchIssuedBooks();
        final message = notificationFormat(issuedBooks);
        await showNotification(message);
      } catch (e) {
        print("Error in background task: $e");
      }
    });
  }

  /// Fetch issued books from repository
  static Future<List<BookIssueModel>> fetchIssuedBooks() async {
    final context = await getUserContext();

    if (context['userId']!.isEmpty || context['userState']!.isEmpty) {
      print("❌ Missing userId or state — cannot fetch issued books");
      return [];
    }
    final BookIssueRepository _repo = BookIssueRepository();

    try {
      final value = await _repo.getIssuedBook(
        context['userId'],
        context['userState'],
        null,
        null,
        context['userSchool'],
        null,
        null,
        null,
        null,
        page: 1,
      );

      if (value is Map<String, dynamic> && value['error'] == 0) {
        return (value['data'] as List)
            .map((json) => BookIssueModel.fromJson(json))
            .toList();
      } else {
        print("❌ Error fetching issued books: $value");
        return [];
      }
    } catch (e) {
      print("❌ Error fetching issued books: $e");
      return [];
    }
  }

  /// Format the notification message
  static String notificationFormat(List<BookIssueModel> books) {
    if (books.isEmpty) return "No Books are currently issued.";
    return books.map((b) => "${b.title} by ${b.author}").join("\n");
  }

  /// Show a notification manually (used in background service)
  static Future<void> showNotification(String message) async {
    final androidDetails = const AndroidNotificationDetails(
      'library_channel',
      'Library Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    final iosDetails = const DarwinNotificationDetails();

    final details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      'Library Update',
      message,
      details,
    );
  }
}
