// lib/license/license_repository.dart
import '../configs/app_urls.dart';
import '../data/network/network_api_services.dart';
import '../core/device_id_helper.dart';

class LicenseRepository {
  final _api = NetworkServicesApi();

  Future<Map<String, dynamic>> activateLicense({
    required String username,
    required String password,
    required String licenseKey,
  }) async {
    final deviceUuid = await DeviceIdHelper.getDeviceUuid();
    final deviceName = await DeviceIdHelper.getDeviceName();

    final response = await _api.postApi(AppUrls.activateLicenseApi, {
      'username': username,
      'password': password,
      'license_key': licenseKey,
      'device_uuid': deviceUuid,
      'device_name': deviceName,
    });

    return response;
  }
}