import 'dart:convert';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../configs/app_urls.dart';
import '../../data/network/network_api_services.dart';
import '../../models/user_model.dart';

import '../../core/di/service_locator.dart';
import '../../core/sync/sync_engine.dart';


class LoginRepository {
  final _api = NetworkServicesApi();

  //login method
  Future<UserModel?> loginApi(dynamic data) async {
    //final response = await _api.postApi(AppUrls.loginapi, data);
    final response = await _api.postApi(AppUrls.loginApi, data);
    //print('Response from login API: $response $data');

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


        // NEW — kick off the scoped bulk pull for offline use.
        // Fire-and-forget so login isn't blocked waiting on the full pull;
        // SyncBannerWidget shows progress once home screen loads.
        getIt<SyncEngine>().runInitialSync(
          createdBy: userModel.user!.id.toString(),
          school: userModel.user!.school.toString(),
          role: userModel.user!.role.toString(),
        );


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
