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

  Future<void> decideInitialRoute(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final licenseActivated = prefs.getBool('licenseActivated') ?? false;

    if (!licenseActivated) {
      Navigator.pushReplacementNamed(context, RoutesName.licenseActivationScreen);
      return;
    }

    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    Navigator.pushReplacementNamed(context, isLoggedIn ? RoutesName.dashboard : RoutesName.loginScreen);
  }
}
