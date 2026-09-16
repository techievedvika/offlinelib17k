import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceIdHelper {
  static Future<String> getDeviceUuid() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // Android's build-time ID, stable across app reinstalls on the same device
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? 'unknown-ios-device';
    }
    return 'unknown-device';
  }

  static Future<String> getDeviceName() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return '${androidInfo.manufacturer} ${androidInfo.model}';
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.name;
    }
    return 'Unknown Device';
  }
}