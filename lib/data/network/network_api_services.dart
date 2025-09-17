import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../exceptions/app_exceptions.dart';
import 'base_api_services.dart';


class NetworkServicesApi implements BaseApiServices {
  @override
  Future<dynamic> getApi(String url) async {
     if(kDebugMode){
      print('this is url in get $url');
     
    }
    dynamic jsonResponse;
    try {
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 40));
        jsonResponse = returnResponse(response);


      if (response.statusCode == 200) {
         jsonResponse = returnResponse(response);
         print('this is response i got $jsonResponse');

      }
    } on SocketException {
      throw NoInternetException();
    } on TimeoutException {
      throw TimeoutException();
    }
    return jsonResponse;
  }

  @override
   Future<dynamic> postApi(String url,var data) async {
    dynamic jsonResponse;
    if(kDebugMode){
      print('this is url in post $url');
      print('this is data in post $data');
    }
    try {
      final response =
          await http.post(Uri.parse(url),
          body: data
          ).timeout(const Duration(seconds: 40));
          // print('this is response $response');
         
        jsonResponse = returnResponse(response);
       




      if (response.statusCode == 200) {

      }
    } on SocketException {
      throw NoInternetException();
    } on TimeoutException {
      throw TimeoutException();
    }
    return jsonResponse;
  }
    

  //handle response status code
  dynamic returnResponse(http.Response response) {
    dynamic jsonResponse1 = jsonDecode(response.body);
    switch (response.statusCode) {
      case 200:
        dynamic jsonResponse = jsonDecode(response.body);

        return jsonResponse;
      case 400:
        dynamic jsonResponse = jsonDecode(response.body);

        return jsonResponse;

      case 404:
        throw NotFoundException(jsonResponse1['message']);
      case 500:
        throw PlatformException(jsonResponse1['message']);
      case 401:
        throw UnauthorizedException(jsonResponse1['message']);
      default:
       throw CustomException('Invalid response');
  }
}

}