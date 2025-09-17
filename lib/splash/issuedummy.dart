import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lib17000ft/main.dart';

class IssueBookDummyScreen extends StatefulWidget {
  @override
  State<IssueBookDummyScreen> createState() => _IssueBookDummyScreenState();
}

class _IssueBookDummyScreenState extends State<IssueBookDummyScreen> {
  String? fcmToken;

  @override
  void initState() {
    super.initState();
    _getToken();
  }

  Future<void> _getToken() async {
    fcmToken = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $fcmToken");
  }

  void _sendDummyReminder() {
    flutterLocalNotificationsPlugin.show(
      0,
      "📘 Reminder",
      "Book ‘Maths for Class 2’ issued to Anjali is due in 2 days.",
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'library_channel',
          'Library Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  void _sendDummyOverdueAlert() {
    flutterLocalNotificationsPlugin.show(
      1,
      "⚠️ Overdue Book",
      "Book ‘Maths for Class 2’ issued to Anjali is now overdue.",
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'library_channel',
          'Library Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dummy Library App")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _sendDummyReminder,
              child: const Text("Send 2-Day Reminder"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendDummyOverdueAlert,
              child: const Text("Send Overdue Alert"),
            ),
          ],
        ),
      ),
    );
  }
}
