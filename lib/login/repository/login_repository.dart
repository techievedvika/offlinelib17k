import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../../configs/app_urls.dart';
import '../../data/network/network_api_services.dart';
import '../../models/user_model.dart';


class LoginRepository {
  final _api = NetworkServicesApi();

  //login method
  Future<UserModel?> loginApi(dynamic data) async {
    final response = await _api.postApi(AppUrls.loginapi, data);
    //  print('Response from login API: $response $data');

    try {
      if (response['status'] == 0 || response['user'] == null) {
        // Handle the case where credentials are invalid or user is not found
        return UserModel(
            message: response['message'],
            status: response['status'],
            user: response['user']);
      }

      // Deserialize JSON to UserModel
      if (response['user'] != null) {
        UserModel userModel = UserModel.fromJson(response);

        // Store the user ID in SharedPreferences
       

        SharedPreferences prefs = await SharedPreferences.getInstance();
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
   String url = "${AppUrls.fcmTokenApi}?id=$id&token=$token";

    final response = await _api.getApi(url);
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
