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
  Future<dynamic> getStudents(
      dynamic id,
      String? stateName,
      String? district,
      String? block,
      String? school,
      String? from,
      String? to,
      {required int page} ) async {
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
   //  final Map<String, String> queryParams = {
   //    'id': id.toString(),
   //    'page': page.toString(), // Assuming pagination is always needed
   //  };
   //
   //  // 2. Add other parameters to the map ONLY if they are not null or empty
   //  if (stateName != null && stateName.isNotEmpty) {
   //    queryParams['state'] = stateName;
   //  }
   //  if (district != null && district.isNotEmpty) {
   //    queryParams['district'] = district;
   //  }
   //  if (block != null && block.isNotEmpty) {
   //    queryParams['block'] = block;
   //  }
   //  if (school != null && school.isNotEmpty) {
   //    queryParams['school'] = school;
   //  }
   //  if (from != null && from.isNotEmpty) {
   //    queryParams['from'] = from;
   //  }
   //  if (to != null && to.isNotEmpty) {
   //    queryParams['to'] = to;
   //  }
   //
   //  // 3. Build the final URI from the base URL and the clean query parameters
   //  final uri = Uri.parse(AppUrls.allStudentapi).replace(queryParameters: queryParams);
   //
   //  print('This is my CORRECT url for student $uri');
   //
   //  // 4. Make the API call with the correctly formed URL
   //  final response = await _api.getApi(uri.toString());
   //
   //  // --- END OF THE FIX ---

    // try {
    //   if (!response['error']) {
    //     return {
    //       "error": 0,
    //       "data": response['data'],
    //     };
    //   } else {
    //     // This part seems to have a potential bug. If error is true,
    //     // response might not be a valid JSON string.
    //     // It's safer to just return the map you received.
    //     return response;
    //   }
    // } catch (e) {
    //   print('Error parsing student response: $e');
    //   rethrow;
    // }
  }

  //This is to fetch Grade list dynamically form database
  Future<List<String>> getGrades() async {
    final response = await _api.getApi(AppUrls.getGradeApi);
    try {
      // Check if the response is a Map and there is no error
      if (response is Map<String, dynamic> && response['error'] == false) {
        // Get the 'message' which is a List<dynamic>
        List<dynamic> messageList = response['message'];

        // Map over the list, extract the 'grade' value from each map, and convert it to a List<String>
        List<String> grades = messageList.map((item) => item['grade'].toString()).toList();

        return grades;
      } else {
        // Handle cases where 'error' is true or the format is unexpected
        throw Exception('Failed to load grades: Invalid data format or API error');
      }
    } catch (e) {
      print('Error parsing grades: $e');
      rethrow;
    }
  }

  Future<dynamic> updateStudent(dynamic data) async {
    // Note: You should add 'updateStudentApi' to your AppUrls config file
    // If not present, you can use a string, but AppUrls.updateStudentApi is better.
    final response = await _api.postApi(AppUrls.studentDetailApi, data);
    print("Raw API Response: $response");

    try {
      // Assuming your API returns { "error": false, "message": "..." } on success
      if (response['error'] == false || response['error'] == 0) {
        return {
          "error": 0,
          "message": response['message'],
        };
      } else {
        return {
          "error": 1,
          "message": response['message'] ?? "Failed to update student",
        };
      }
    } catch (e) {
      print('Error at update student repository: $e');
      rethrow;
    }
  }

}
