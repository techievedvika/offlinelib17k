import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;
import 'package:lib17000ft/configs/app_urls.dart';
import 'package:uuid/uuid.dart';

import '../../core/database/tables/database.dart';
import '../../core/di/service_locator.dart';
import '../../data/network/network_api_services.dart';
import '../../models/response_model.dart';
import '../../models/student_registration/student_model.dart';

class StudentRepository {
  final _api = NetworkServicesApi();
  final AppDatabase _db = getIt<AppDatabase>();

  //login method
  // Future<dynamic> registerStudent(dynamic data) async {
  //   //final response = await _api.postApi(AppUrls.registerapi, data);
  //   final response = await _api.postApi(AppUrls.testregisterapi, data);
  //   //final response = await _api.postApi(AppUrls.registerApi, data);
  //   try {
  //     if (!response['error']) {
  //       // Handle the case where credentials are invalid or user is not found
  //       return {
  //         "error": 0,
  //         "message":response['message'],
  //       };
  //     }else{
  //       print('Error occured at Register student');
  //       print(response['error']);
  //     }
  //
  //     return jsonDecode(response);
  //   } catch (e) {
  //     print('Error parsing UserModel: $e');
  //     rethrow; // rethrow the error after logging it
  //   }
  //
  // }

  Future<dynamic> registerStudent(dynamic data) async {
    // Ensure AppUrls.registerApi is correct
    final response = await _api.postApi(AppUrls.registerApi, data);

    try {
      // Laravel returns 'error' => true (bool) or false (bool)
      // We convert this to 0/1 for your Cubit logic
      if (response['error'] == false) {
        return {
          "error": 0,
          "message": response['message'] ?? "Success",
        };
      } else {
        return {
          "error": 1,
          "message": response['message'] ?? "Registration failed",
        };
      }
    } catch (e) {
      print('Repository Error: $e');
      return {
        "error": 1,
        "message": "Data parsing error",
      };
    }
  }

  // Future<ApiResponse> registerStudent(data) async {
  //   final response = await _api.postApi(AppUrls.registerApi, data);
  //
  //   return ApiResponse.fromJson(response);
  // }

  

  //promote Student
  Future<dynamic> promote(dynamic data) async {
    //final response = await _api.postApi(AppUrls.promoteStudent, data);
    //final response = await _api.postApi(AppUrls.testpromoteStudent, data);
    final response = await _api.postApi(AppUrls.promoteStudentApi, data);
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
  

  //final List<dynamic> data = await _api.getApi("${AppUrls.getStudentId}&location=$location"); // Don't call `.body`!
  final List<dynamic> data = await _api.getApi("${AppUrls.getUniqueIdApi}?location=$location&getUniqueId");

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
   //String url = "${AppUrls.allStudentapi}?id=$id&state=$stateName&district=$district&block=$block&school=$school&from=$from&to=$to";
   // String url = "${AppUrls.testallStudentapi}?id=$id&state=$stateName&district=$district&block=$block&school=$school&from=$from&to=$to";
   // print('this is my url for student $url');
   //
   //  final response = await _api.getApi(url);
   //
   //
   //  try {
   //    if (!response['error']) {
   //      // Handle the case where credentials are invalid or user is not found
   //      return {
   //        "error": 0,
   //        "data":response['data'],
   //      };
   //    }else{
   //      return jsonDecode(response);
   //    }
   //
   //    // return jsonDecode(response);
   //  } catch (e) {
   //    print('Error parsing UserModel: $e');
   //    rethrow; // rethrow the error after logging it
   //  }
    final Map<String, String> queryParams = {
      'id': id.toString(),
      'page': page.toString(), // Assuming pagination is always needed
    };

    // 2. Add other parameters to the map ONLY if they are not null or empty
    if (stateName != null && stateName.isNotEmpty) {
      queryParams['state'] = stateName;
    }
    if (district != null && district.isNotEmpty) {
      queryParams['district'] = district;
    }
    if (block != null && block.isNotEmpty) {
      queryParams['block'] = block;
    }
    if (school != null && school.isNotEmpty) {
      queryParams['school'] = school;
    }
    if (from != null && from.isNotEmpty) {
      queryParams['from'] = from;
    }
    if (to != null && to.isNotEmpty) {
      queryParams['to'] = to;
    }

    // 3. Build the final URI from the base URL and the clean query parameters
    final uri = Uri.parse(AppUrls.allStudentsApi);

    print('This is my CORRECT url for student $uri');

    // 4. Make the API call with the correctly formed URL
    final response = await _api.postApi(uri.toString(),queryParams);

    print(response);

    // --- END OF THE FIX ---

    try {
      if (!response['error']) {
        return {
          "error": 0,
          "data": response['data'],
        };
      } else {
        // This part seems to have a potential bug. If error is true,
        // response might not be a valid JSON string.
        // It's safer to just return the map you received.
        return response;
      }
    } catch (e) {
      print('Error parsing student response: $e');
      rethrow;
    }
  }

  //This is to fetch Grade list dynamically form database
  // Future<List<String>> getGrades() async {
  //   //final response = await _api.getApi(AppUrls.getGradeApi);
  //   final response = await _api.postApi(AppUrls.getGradeApi,{});
  //   try {
  //     // Check if the response is a Map and there is no error
  //     if (response is Map<String, dynamic> && response['error'] == false) {
  //       // Get the 'message' which is a List<dynamic>
  //       List<dynamic> messageList = response['message'];
  //
  //       // Map over the list, extract the 'grade' value from each map, and convert it to a List<String>
  //       List<String> grades = messageList.map((item) => item['grade'].toString()).toList();
  //
  //       return grades;
  //     } else {
  //       // Handle cases where 'error' is true or the format is unexpected
  //       throw Exception('Failed to load grades: Invalid data format or API error');
  //     }
  //   } catch (e) {
  //     print('Error parsing grades: $e');
  //     rethrow;
  //   }
  // }
  // This is to fetch Grade list dynamically from database
  Future<List<String>> getGrades() async {
    final response = await _api.postApi(AppUrls.getGradeApi, {});
    try {
      // Check if the response is a Map and there is no error
      if (response is Map<String, dynamic> && response['error'] == false) {

        // messageList is List<dynamic>, but contains Strings: ["Grade 1", "Grade 2"]
        List<dynamic> messageList = response['message'];

        // FIX: Map directly to string. 'item' is the grade string itself.
        List<String> grades = messageList.map((item) => item.toString()).toList();

        return grades;
      } else {
        throw Exception('Failed to load grades: ${response['message']}');
      }
    } catch (e) {
      print('Error parsing grades: $e');
      rethrow;
    }
  }

  // NEW — offline grades, reads from local cache populated by initial_sync
  Future<List<String>> getGradesOffline() async {
    final rows = await _db.select(_db.grades).get();
    return rows.map((r) => r.grade).toList();
  }

  Future<dynamic> updateStudent(dynamic data) async {
    // Note: You should add 'updateStudentApi' to your AppUrls config file
    // If not present, you can use a string, but AppUrls.updateStudentApi is better.
    //final response = await _api.postApi(AppUrls.studentDetailApi, data);
    // final response = await _api.postApi(AppUrls.teststudentDetailApi, data);
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

  Future<Map<String, dynamic>> registerStudentOffline(Map<String, dynamic> data) async {
    final apaarId = (data['apaarId']?.toString().trim().isNotEmpty ?? false) ? data['apaarId'].toString() : null;
    final penId = (data['pen_id']?.toString().trim().isNotEmpty ?? false) ? data['pen_id'].toString() : null;
    final rollnoInput = (data['rollno']?.toString().trim().isNotEmpty ?? false) ? data['rollno'].toString() : null;

    // Mirror server's priority formula exactly
    final rollno = rollnoInput ?? apaarId ?? penId;
    if (rollno == null || rollno.isEmpty) {
      return {"error": 1, "message": "Please provide at least one ID (rollno, apaarId, pen_id)"};
    }

    // Duplicate check against LOCAL cache — natural key
    final existing = await (_db.select(_db.students)..where((t) => t.rollno.equals(rollno))).getSingleOrNull();
    if (existing != null) {
      return {"error": 1, "message": "Student already exists with ID $rollno"};
    }

    final school = data['school']?.toString() ?? '';
    final schoolCodeNew = data['schoolCodeNew']?.toString() ?? '';
    final uniqueId = await generateUniqueId(schoolCodeNew, school);
    final now = DateTime.now();
    final uuid = const Uuid().v4();
    final createdBy = int.tryParse(data['created_by']?.toString() ?? '') ?? 0;

    await _db.transaction(() async {
      await _db.into(_db.students).insert(StudentsCompanion.insert(
        uuid: uuid,
        apaarId: Value(apaarId),
        penId: Value(penId),
        uniqueId: Value(uniqueId),
        school: school,
        name: data['name'].toString(),
        studentClass: data['class'].toString(),
        rollno: rollno,
        gender: data['gender'].toString(),
        createdAt: now,
        updatedAt: now,
        createdBy: createdBy,
        syncStatus: const Value('pending'),
      ));

      await _db.into(_db.syncOutbox).insert(SyncOutboxCompanion.insert(
        entityType: 'student',
        entityKey: rollno,
        operation: 'create',
        payloadJson: jsonEncode({
          'apaarId': apaarId, 'pen_id': penId, 'unique_id': uniqueId,
          'school': school, 'name': data['name'], 'class': data['class'],
          'rollno': rollno, 'gender': data['gender'], 'created_by': createdBy,
          'created_at': now.toIso8601String(), 'updated_at': now.toIso8601String(),
          'uuid': uuid,
        }),
        createdAt: now,
      ));
    });

    return {"error": 0, "message": "Student saved offline, will sync when online"};
  }

  Future<String> generateUniqueId(String schoolCodeNew, String school) async {
    final students = await (_db.select(_db.students)..where((t) => t.school.equals(school))).get();
    int maxSerial = 0;
    for (final s in students) {
      final id = s.uniqueId;
      if (id != null && id.startsWith('$schoolCodeNew-')) {
        final serial = int.tryParse(id.split('-').last) ?? 0;
        if (serial > maxSerial) maxSerial = serial;
      }
    }
    return '$schoolCodeNew-${(maxSerial + 1).toString().padLeft(5, '0')}';
  }

  // NEW — offline student list
  // CHANGED signature — school now optional, ignored if blank/null
  Future<List<StudentModel>> getStudentsOffline([String? school]) async {
    final query = _db.select(_db.students);
    if (school != null && school.trim().isNotEmpty) {
      query.where((t) => t.school.equals(school));
      // query.where((t) => t.status.equals(1));
    }
    final rows = await query.get();
    return rows.map((r) => StudentModel(
      createdBy: r.createdBy.toString(),
      name: r.name,
      rollNo: r.rollno,
      gender: r.gender,
      classs: r.studentClass,
      apaarId: r.apaarId,
      penId: r.penId,
      uniqueId: r.uniqueId,
      school: r.school,
      status: r.status,
      reason: r.reason,
    )).toList();
  }
}
