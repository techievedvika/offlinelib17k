import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      // For Android 11 (API 30) and above
      if (await Permission.manageExternalStorage.isGranted) return true;

      final status = await Permission.manageExternalStorage.request();
      if (status.isGranted) return true;

      // Fallback for older Android versions (API < 30)
      final legacyStatus = await Permission.storage.request();
      if (legacyStatus.isGranted) return true;

      // If permanently denied, open app settings
      if (status.isPermanentlyDenied || legacyStatus.isPermanentlyDenied) {
        await openAppSettings();
      }

      return false;
    } else if (Platform.isIOS) {
      // iOS doesn't require special permissions for saving to the app's directory.
      return true;
    } else {
      // For other platforms, assume no permission is needed or handle as necessary.
      return true;
    }
  }
}