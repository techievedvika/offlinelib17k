import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as raw;
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/app_feedback.dart';
import '../../configs/app_urls.dart';
import '../../configs/routes/routes_name.dart';
import '../device_id_helper.dart';

class SessionManager {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Server codes that mean "this session is over"
  static const _sessionCodes = {
    'UNAUTHENTICATED',
    'DEVICE_SESSION_REVOKED',
    'USER_LICENSE_INACTIVE',
    'LICENSE_INACTIVE',
    'DEVICE_UUID_REQUIRED',
  };

  static String? _deviceUuid;
  static Future<String> deviceUuid() async =>
      _deviceUuid ??= await DeviceIdHelper.getDeviceUuid();

  static Future<String?> token() async =>
      (await SharedPreferences.getInstance()).getString('authToken');

  static Future<void> saveToken(String token) async =>
      (await SharedPreferences.getInstance()).setString('authToken', token);

  /// Removes only user/session data. License info and the offline database stay.
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    for (final k in [
      'isLoggedIn', 'userId', 'username', 'role', 'rights', 'location',
      'school', 'schoolCodeNew', 'initialSyncDone', 'authToken',
    ]) {
      await prefs.remove(k);
    }
  }

  /// Called by the HTTP wrapper for every 401/403 that carried a token.
  static void handleAuthFailure(int statusCode, String body) {
    String? code;
    String message = 'Please log in again.';
    try {
      final d = jsonDecode(body);
      if (d is Map) {
        code = d['code']?.toString();
        message = d['message']?.toString() ?? message;
      }
    } catch (_) {}

    if (statusCode == 401 || (code != null && _sessionCodes.contains(code))) {
      forceLogout(message);
    }
  }

  static bool _busy = false;

  static Future<void> forceLogout(String message) async {
    if (_busy) return;
    _busy = true;
    try {
      await clearSession();
      final nav = navigatorKey.currentState;
      if (nav != null) {
        nav.pushNamedAndRemoveUntil(RoutesName.loginScreen, (r) => false);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final ctx = navigatorKey.currentContext;
          if (ctx != null) {
            AppFeedback.showError(ctx, title: 'Session Ended', message: message);
          }
        });
      }
    } finally {
      Future.delayed(const Duration(seconds: 3), () => _busy = false);
    }
  }

  /// User-initiated logout: tell the server (best effort), then clear and go to Login.
  static Future<void> logout() async {
    try {
      final t = await token();
      if (t != null && t.isNotEmpty) {
        await raw.post(
          Uri.parse(AppUrls.logoutApi),
          headers: {
            'Authorization': 'Bearer $t',
            'X-Device-UUID': await deviceUuid(),
            'Accept': 'application/json',
          },
        ).timeout(const Duration(seconds: 5));
      }
    } catch (_) {
      // offline or server unreachable — still log out locally
    }
    await clearSession();
    navigatorKey.currentState?.pushNamedAndRemoveUntil(RoutesName.loginScreen, (r) => false);
  }
}