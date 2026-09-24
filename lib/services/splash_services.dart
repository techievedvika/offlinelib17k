import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../configs/routes/routes_name.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    Timer(
        const Duration(seconds: 4),
        () => Navigator.pushNamedAndRemoveUntil(
            context, RoutesName.loginScreen, (route) => false));
  }

  // Future<void> decideInitialRoute(BuildContext context) async {
  //   // final prefs = await SharedPreferences.getInstance();
  //   // final licenseActivated = prefs.getBool('licenseActivated') ?? false;
  //   //
  //   // if (!licenseActivated) {
  //   //   Navigator.pushReplacementNamed(context, RoutesName.licenseActivationScreen);
  //   //   return;
  //   // }
  //   //
  //   // final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  //   // Navigator.pushReplacementNamed(context, isLoggedIn ? RoutesName.dashboard : RoutesName.loginScreen);
  //   Timer(const Duration(seconds: 4), () async {
  //     final prefs = await SharedPreferences.getInstance();
  //     final librarianRegistered = prefs.getBool('librarianRegistered') ?? false;
  //     final licenseActivated = prefs.getBool('licenseActivated') ?? false;
  //
  //     if (!context.mounted) return;
  //
  //     if (!librarianRegistered) {
  //       Navigator.pushNamedAndRemoveUntil(context, RoutesName.librarianRegistrationScreen, (route) => false);
  //     } else if (!licenseActivated) {
  //       Navigator.pushNamedAndRemoveUntil(context, RoutesName.licenseActivationScreen, (route) => false);
  //     } else {
  //       Navigator.pushNamedAndRemoveUntil(context, RoutesName.loginScreen, (route) => false);
  //     }
  //   });
  // }

  Future<void> decideInitialRoute(BuildContext context) async {
    Timer(const Duration(seconds: 4), () async {
      final prefs = await SharedPreferences.getInstance();

      final licenseActivated =
          prefs.getBool('licenseActivated') ?? false;

      final librarianRegistered =
          prefs.getBool('librarianRegistered') ?? false;

      if (!context.mounted) return;

      if (!licenseActivated) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesName.licenseActivationScreen,
              (route) => false,
        );
      } else if (!librarianRegistered) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesName.librarianRegistrationScreen,
              (route) => false,
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesName.loginScreen,
              (route) => false,
        );
      }
    });
  }
}
