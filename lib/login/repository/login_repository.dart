import 'dart:convert';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../configs/app_urls.dart';
import '../../data/network/network_api_services.dart';
import '../../models/user_model.dart';
import '../../core/database/tables/database.dart';

import '../../core/di/service_locator.dart';
import '../../core/sync/sync_engine.dart';


class LoginRepository {
  final _api = NetworkServicesApi();

  // Helper to fetch license device count from SharedPreferences
  Future<Map<String, int?>> getLicenseDeviceCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'registered': prefs.getInt('licenseRegisteredDevices'),
      'max': prefs.getInt('licenseMaxDevices'),
    };
  }

  //login method
  Future<UserModel?> loginApi(dynamic data) async {
    //final response = await _api.postApi(AppUrls.loginapi, data);
    final response = await _api.postApi(AppUrls.loginApi, data);
    print('Response from login API: $response $data');

    try {
      // Sanitize response: ensure status and message exist, and convert empty strings to null
      if (response is Map<String, dynamic>) {
        response['status'] = response['status'] ?? 0;
        response['message'] = response['message'] ?? 'Unexpected response from server';
        if (response['user'] == "") {
          response['user'] = null;
        }
        if (response['license'] == "") {
          response['license'] = null;
        }
      }

      UserModel userModel = UserModel.fromJson(response);

      // If login failed (status == 0), return early without modifying local activation state
      if (userModel.status == 0) {
        return userModel;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Store License info on successful login (status == 1)
      if (userModel.license != null) {
        await prefs.setBool('licenseActivated', true);
        if (userModel.license!.licenseKey != null) {
          await prefs.setString('licenseKey', userModel.license!.licenseKey!);
        }
        if (userModel.license!.schoolUdise != null) {
          await prefs.setString('licenseSchoolUdise', userModel.license!.schoolUdise!);
        }
        if (userModel.license!.validUntil != null) {
          await prefs.setString('licenseValidUntil', userModel.license!.validUntil!);
        }
        if (userModel.license!.maxDevices != null) {
          await prefs.setInt('licenseMaxDevices', userModel.license!.maxDevices!);
        }
        if (userModel.license!.registeredDevices != null) {
          await prefs.setInt('licenseRegisteredDevices', userModel.license!.registeredDevices!);
        }
        if (userModel.license!.allowImageUpload != null) {
          await prefs.setInt('imageAllowed', userModel.license!.allowImageUpload!);
        }
        if (userModel.license!.schoolUdise != null) {
          await prefs.setString('school_udise', userModel.license!.schoolUdise!);
        }
      }

      // Deserialize JSON to UserModel
      if (userModel.user != null) {
        // Store the user ID in SharedPreferences

        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String version = packageInfo.version; // e.g. 1.0.0
        String buildNumber = packageInfo.buildNumber; // e.g. 1

        final currentVersion = "$version+$buildNumber";

        await prefs.setString('currentVersion', currentVersion);
        await prefs.setBool('librarianRegistered', true);
        await prefs.setString('userId', userModel.user!.id.toString());
        await prefs.setString('location', userModel.user!.location.toString());
        await prefs.setString('school', userModel.user!.school.toString());
        await prefs.setString('username', userModel.user!.username.toString());
        await prefs.setString('role', userModel.user!.role.toString());
        await prefs.setString('rights', userModel.user!.rights.toString());

        if (userModel.user!.schoolCodeNew != null) {
          await prefs.setString('schoolCodeNew', userModel.user!.schoolCodeNew!);
        }

        // ---- school scoping ----
        final newUdise = (userModel.license?.schoolUdise ??
            prefs.getString('licenseSchoolUdise') ??
            prefs.getString('schoolCodeNew') ??
            '')
            .trim();
        final previousUdise = prefs.getString('localDataSchoolUdise') ?? '';

        // Different school than the data on this phone -> start clean
        if (newUdise.isNotEmpty && previousUdise.isNotEmpty && newUdise != previousUdise) {
          await getIt<AppDatabase>().clearAllLocalData();
        }
        if (newUdise.isNotEmpty) {
          await prefs.setString('schoolUdise', newUdise);
          await prefs.setString('localDataSchoolUdise', newUdise);
        }


        // Note: runInitialSync is now handled in DashBoard with a flag check 
        // to ensure it only runs on fresh login, not every app open.


        return userModel;
      }
    } catch (e) {
      print('Error parsing UserModel: $e');
      rethrow; // rethrow the error after logging it
    }
    return null;
  }

  Future<UserModel?> passResetApi(dynamic data) async {
    //final response = await _api.postApi(AppUrls.loginapi, data);
    final response = await _api.postApi(AppUrls.passResetApi, data);
    //print('Response from login API: $response $data');

    try{
    if (response['status'] == false){
      
    }
    } catch(e) {
      print('Error parsing UserModel: $e');
      rethrow; // rethrow the error after logging it
    }

    try {
      if (response['status'] == 0 || response['user'] == null) {
        // Handle the case where credentials are invalid or user is not found
        return UserModel(
            message: response['message'],
            status: response['status'],
            user: response['user']
        );
      }

      // Deserialize JSON to UserModel
      if (response['user'] != null) {
        UserModel userModel = UserModel.fromJson(response);

        // Store the user ID in SharedPreferences

        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String version = packageInfo.version; // e.g. 1.0.0
        String buildNumber = packageInfo.buildNumber; // e.g. 1

        final currentVersion = "$version+$buildNumber";

        SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString('currentVersion', currentVersion);
        await prefs.setString('userId', userModel.user!.id.toString());
        await prefs.setString('location', userModel.user!.location.toString());
        await prefs.setString('school', userModel.user!.school.toString());
        await prefs.setString('username', userModel.user!.username.toString());
        await prefs.setString('role', userModel.user!.role.toString());
        await prefs.setString('rights', userModel.user!.rights.toString());
        return userModel;
      }
    } catch (e) {
      print('Error parsing UserModel: $e');
      rethrow; // rethrow the error after logging it
    }
    return null;
  }


  Future<dynamic> setToken(String? id, String? token) async {

    final tokenPayload = {
      "id": id,
      "token": token,
    };

   // String url = "${AppUrls.fcmTokenApi}?id=$id&token=$token";
   String url = AppUrls.fcmTokenApi;

    // final response = await _api.getApi(url);
   final response = await _api.postApi(url, tokenPayload);
   print('this is get by setToken api $response');

    try {
      if (!response['error']) {
        // Handle the case where credentials are invalid or user is not found
        return {
          "error": 0,
          "data":response['data'],
        };
      }else{
        print(response['error']);
      }

      return jsonDecode(response);
    } catch (e) {
      print('Error parsing SetToken: $e');
      rethrow; // rethrow the error after logging it
    }
   
  }

}
