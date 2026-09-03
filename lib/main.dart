import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lib17000ft/forms/book_issue/book_issue_cubit.dart';
import 'package:lib17000ft/forms/dashboard/dash_cubit.dart';
import 'package:lib17000ft/forms/filters/filter_cubit.dart';
import 'package:lib17000ft/services/push_notification_service.dart';

import 'configs/color/color.dart';
import 'configs/routes/routes.dart';
import 'configs/routes/routes_name.dart';
import 'core/di/service_locator.dart';
import 'core/sync/sync_status_cubit.dart';
import 'forms/student/student_cubit.dart';
import 'login/bloc/login_cubit.dart';
import 'login/bloc/network_cubit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// This must be a top-level function
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase or any services if needed
  print("Handling background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler); // <-- Add this
  await PushNotificationService.initialize(); // 👈 Setup notification handler
  //await PushNotificationService.initializeService();
  // await _initNotifications();

  await setupLocator();

  runApp(const MyApp());
}

FirebaseMessaging messaging = FirebaseMessaging.instance;

// Local notification setup
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<NetworkCubit>(
            create: (context) => NetworkCubit(Connectivity()),
          ),
          BlocProvider<LoginCubit>(
            create: (context) => LoginCubit(),
          ),
          BlocProvider<StudentCubit>(
            create: (context) => StudentCubit(),
          ),
          BlocProvider<BookIssueCubit>(
            create: (context) => BookIssueCubit(),
          ),
          BlocProvider<DashCubit>(
            create: (context) => DashCubit(),
          ),
          BlocProvider<FilterCubit>(
            create: (context) => FilterCubit(),
          ),
          BlocProvider<SyncStatusCubit>(
            lazy: false,
            create: (context) => SyncStatusCubit(getIt()),
          ),
          // Add other Blocs here if needed
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Library App 17000ft Foundation',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
              useMaterial3: true,
            ),
            initialRoute: RoutesName.splashScreen,
            //home: IssueBookDummyScreen(),

            onGenerateRoute: Routes.generateRoute)
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("🔧 Handling background message: ${message.messageId}");
}
