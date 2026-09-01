import 'dart:async';
import 'dart:convert';
import 'dart:io';
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
           print('this is response $response');

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

  // Future<dynamic> postMultipartApi(String url, Map<String, dynamic> data) async {
  //   dynamic jsonResponse;
  //   print("this is url in post $url");
  //   print("this is data in post $data");
  //   try {
  //     var request = http.MultipartRequest('POST', Uri.parse(url));
  //
  //     // Loop through data to separate fields and files
  //     for (var entry in data.entries) {
  //       if (entry.key == 'cover_page' &&
  //           entry.value != null &&
  //           entry.value.toString().isNotEmpty) {
  //
  //         File imageFile = File(entry.value);
  //
  //         print("Image Path: ${imageFile.path}");
  //         print("Image Exists: ${await imageFile.exists()}");
  //
  //         if (await imageFile.exists()) {
  //           request.files.add(
  //             await http.MultipartFile.fromPath(
  //               'cover_page',
  //               imageFile.path,
  //             ),
  //           );
  //         }
  //       } else {
  //         // Handle Text Fields
  //         request.fields[entry.key] = entry.value.toString();
  //       }
  //     }
  //
  //     final streamedResponse = await request.send().timeout(const Duration(seconds: 40));
  //     final response = await http.Response.fromStream(streamedResponse);
  //     jsonResponse = returnResponse(response);
  //
  //   } on SocketException {
  //     throw NoInternetException();
  //   } catch (e) {
  //     print("Custom Exception : ${e.toString()}");
  //     throw CustomException(e.toString());
  //   }
  //   return jsonResponse;
  // }

  Future<dynamic> postMultipartApi(
      String url,
      Map<String, dynamic> data,
      ) async {
    try {
      print("👉 URL: $url");
      print("👉 DATA: $data");

      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Optional but recommended for Laravel APIs
      request.headers.addAll({
        "Accept": "application/json",
      });

      for (var entry in data.entries) {
        final key = entry.key;
        final value = entry.value;

        // 📸 Handle image file
        if (key == 'cover_page' &&
            value != null &&
            value.toString().trim().isNotEmpty) {

          final filePath = value.toString();
          final file = File(filePath);

          print("📸 Image Path: $filePath");
          print("📸 Exists: ${await file.exists()}");

          if (await file.exists()) {
            request.files.add(
              await http.MultipartFile.fromPath(
                'cover_page',
                filePath,
              ),
            );
          } else {
            print("⚠️ File not found: $filePath");
          }

        } else {
          // 📝 Handle normal fields safely
          request.fields[key] = value?.toString() ?? "";
        }
      }

      final streamedResponse = await request
          .send()
          .timeout(const Duration(seconds: 40));

      final response = await http.Response.fromStream(streamedResponse);

      print("✅ Status Code: ${response.statusCode}");
      print("✅ Response Body: ${response.body}");

      return returnResponse(response);

    } on SocketException {
      throw NoInternetException();

    } on TimeoutException {
      throw CustomException("Request timeout");

    } catch (e) {
      print("❌ Custom Exception: $e");
      throw CustomException(e.toString());
    }
  }

  // Future<dynamic> postApi(String url, var data) async {
  //   try {
  //     if (kDebugMode) {
  //       print('URL: $url');
  //       print('DATA: $data');
  //     }
  //
  //     final response = await http
  //         .post(
  //       Uri.parse(url),
  //       body: data,
  //     )
  //         .timeout(const Duration(seconds: 40));
  //
  //     if (kDebugMode) {
  //       print('STATUS: ${response.statusCode}');
  //       print('BODY: ${response.body}');
  //     }
  //
  //     if (response.body.isEmpty) {
  //       throw Exception("Empty response from server");
  //     }
  //
  //     final decoded = jsonDecode(response.body);
  //
  //     return decoded;
  //   } on SocketException {
  //     throw Exception("No Internet Connection");
  //   } on TimeoutException {
  //     throw Exception("Request Timeout");
  //   } catch (e) {
  //     throw Exception("API Error: $e");
  //   }
  // }
    

  //handle response status code
  // dynamic returnResponse(http.Response response) {
  //   dynamic jsonResponse1 = jsonDecode(response.body);
  //   switch (response.statusCode) {
  //     case 200:
  //       dynamic jsonResponse = jsonDecode(response.body);
  //
  //       return jsonResponse;
  //     case 400:
  //       dynamic jsonResponse = jsonDecode(response.body);
  //
  //       return jsonResponse;
  //
  //     case 404:
  //       throw NotFoundException(jsonResponse1['message']);
  //     case 500:
  //       throw PlatformException(jsonResponse1['message']);
  //     case 401:
  //       throw UnauthorizedException(jsonResponse1['message']);
  //     default:
  //      throw CustomException('Invalid response');
  // }
  dynamic returnResponse(http.Response response) {
    // Decode body once at the top to avoid multiple decodes
    final dynamic jsonResponse = jsonDecode(response.body);

    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonResponse;

      case 400:
      case 404:
      case 409:
        return jsonResponse;

      case 401:
        throw UnauthorizedException(jsonResponse['message'] ?? "Unauthorized");

      case 500:
        throw PlatformException(jsonResponse['message'] ?? "Internal Server Error");

      default:
      // Include the status code to help with debugging
        throw CustomException('Error ${response.statusCode}: Invalid response');
    }
  }

}