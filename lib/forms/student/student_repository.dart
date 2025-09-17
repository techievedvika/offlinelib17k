import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lib17000ft/configs/app_urls.dart';

import '../../data/network/network_api_services.dart';

class StudentRepository {
  final _api = NetworkServicesApi();

  //login method
  Future<dynamic> registerStudent(dynamic data) async {
    final response = await _api.postApi(AppUrls.registerapi, data);
    try {
      if (!response['error']) {
        // Handle the case where credentials are invalid or user is not found
        return {
          "error": 0,
          "message":response['message'],
        };
      }else{
        print('Error occured at Register student');
        print(response['error']);
      }

      return jsonDecode(response);
    } catch (e) {
      print('Error parsing UserModel: $e');
      rethrow; // rethrow the error after logging it
    }
   
  }

  

  //promote Student
  Future<dynamic> promote(dynamic data) async {
    final response = await _api.postApi(AppUrls.promoteStudent, data);
    try {
      if (!response['error']) {
        // Handle the case where credentials are invalid or user is not found
        return {
          "error": 0,
          "message":response['message'],
        };
      }else{
        print('Error occured at Register student');
        print(response['error']);
      }

      return jsonDecode(response);
    } catch (e) {
      print('Error parsing  at promote student: $e');
      rethrow; // rethrow the error after logging it
    }
   
  }
  //get student id function who has no unique id
Future<String> getUniqueId(String? location) async {
  

  final List<dynamic> data = await _api.getApi("${AppUrls.getStudentId}&location=$location"); // Don't call `.body`!

  if (data.isNotEmpty && data.first is String) {
    return data.first; // e.g. "SIK/2025/00001"
  } else {
    throw Exception('Invalid or empty response');
  }
}

  //
  Future<dynamic> getStudents(dynamic id, String? stateName,String? district, String? block,String? school,String? from, String? to,{required int page}) async {
   String url = "${AppUrls.allStudentapi}?id=$id&state=$stateName&district=$district&block=$block&school=$school&from=$from&to=$to";
   print('this is my url for student $url');

    final response = await _api.getApi(url);
   

    try {
      if (!response['error']) {
        // Handle the case where credentials are invalid or user is not found
        return {
          "error": 0,
          "data":response['data'],
        };
      }else{
        return jsonDecode(response);
      }

      // return jsonDecode(response);
    } catch (e) {
      print('Error parsing UserModel: $e');
      rethrow; // rethrow the error after logging it
    }
   
  }
}
