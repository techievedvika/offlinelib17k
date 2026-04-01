import 'package:flutter/material.dart';
import 'package:lib17000ft/forms/book_return/all_bookReturn.dart';
import 'package:lib17000ft/forms/dashboard/dash.dart';
import 'package:lib17000ft/forms/student/all_student.dart';
import 'package:lib17000ft/forms/student/promte_student.dart';
import 'package:lib17000ft/home/home.dart';
import 'package:lib17000ft/models/book_issue/all_bookIssue.dart';
import 'package:lib17000ft/splash/splash.dart';

import '../../forms/book_issue/book_issue.dart';
import '../../forms/book_return/book_return.dart';
import '../../forms/lib_activity_log/screen/lib_activity_form_screen.dart';
import '../../forms/student/student_edit.dart';
import '../../forms/student/student_registration.dart';
import '../../login/login.dart';
import '../../models/student_registration/student_model.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/home_screen':
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case '/login_screen':
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case '/all_student':
        return MaterialPageRoute(builder: (context) =>  AllStudentList());
      case '/dashboard':
        return MaterialPageRoute(builder: (context) => const DashBoard());
      case '/splash_screen':
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case '/student_registration':
        return MaterialPageRoute(
            builder: (context) => const StudentRegistration());
      case '/student_edit':
        final student = settings.arguments as StudentModel?;
        return MaterialPageRoute(
          builder: (context) => EditStudentScreen(student: student),
        );
      case '/book_issue':
        return MaterialPageRoute(builder: (context) => const BookIssue());
      case '/book_return':
        return MaterialPageRoute(builder: (context) => const BookReturn());
      case '/all_bookIssue':
        return MaterialPageRoute(builder: (context) =>  AllBookIssueList());
      case '/all_bookReturn':
        return MaterialPageRoute(builder: (context) =>   AllBookReturnList());
       case '/promote_student':
        return MaterialPageRoute(builder: (context) => const PromoteStudentList());
      case '/testhome':
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case '/lib_activity_log':
        return MaterialPageRoute(builder: (context) => const LibActivityFormScreen());
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('No Route Generated'),
            ),
          ),
        );
    }
  }
}
