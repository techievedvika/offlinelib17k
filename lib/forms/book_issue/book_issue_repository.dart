import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lib17000ft/configs/app_urls.dart';

import '../../data/network/network_api_services.dart';

class BookIssueRepository {
  final _api = NetworkServicesApi();

  //login method
  Future<dynamic> bookIssue(dynamic data) async {
    final response = await _api.postApi(AppUrls.bookIssueapi, data);

    //Testing purpose only
    //final response = await _api.postApi(AppUrls.testBookIssueapi, data);


    try {
      if (!response['error']) {
        // Handle the case where credentials are invalid or user is not found
        return {
          "error": 0,
          "message": response['message'],
        };
      } else {
        return {
          "error": 1,
          "message": response['message'],

        };
      }
    } catch (e) {
      print('Error parsing Book Issue model: $e');
      rethrow; // rethrow the error after logging it
    }
  }

//Get book Return Report 
  Future<dynamic> getBookReturn(
      dynamic id,
      String? stateName,
      String? district,
      String? block,
      String? school,
      String? from,
      String? to,
      String? level,
      String? language,
      {required int page}
      ) async {
   String url = "${AppUrls.getReturnedBookapi}?id=$id&state=$stateName&district=$district&block=$block&school=$school&from=$from&to=$to&level=$level&language=$language";

    final response = await _api.getApi(url);
   

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
      print('Error parsing UserModel: $e');
      rethrow; // rethrow the error after logging it
    }
   
  }

  //Get Issue Book Report
 
  Future<dynamic> getIssuedBook(
      dynamic id,
      String? stateName,
      String? district,
      String? block,
      String? school,
      String? from,
      String? to,
      String? level,
      String? language
      ,{required int page}) async {
   String url = "${AppUrls.getIssuedBookapi}?id=$id&state=$stateName&district=$district&block=$block&school=$school&from=$from&to=$to&level=$level&language=$language";

    final response = await _api.getApi(url);
   

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
      print('Error parsing UserModel: $e');
      rethrow; // rethrow the error after logging it
    }
   
  }
}
