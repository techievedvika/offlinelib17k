import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lib17000ft/models/student_registration/student_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'student_repository.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
part 'student_state.dart';

class StudentCubit extends Cubit<StudentState> {
  StudentCubit() : super(StudentInitial());
  final StudentRepository _studentRepository = StudentRepository();
  bool _isLoading = false; // Flag to prevent multiple simultaneous requests
  int _page = 1; // For pagination, assuming 1 as the starting page
  bool _hasMoreData = true; // Flag to check if there's more data

  Future<bool> _isOnline() async {
    final result = await Connectivity().checkConnectivity();
    return result.isNotEmpty && !result.contains(ConnectivityResult.none);
  }


  // void registerStudent(dynamic data) async {
  // //   emit(StudentLoading());
  // //   print('this is student data $student');
  // //   await Future.delayed(const Duration(seconds: 1)); // Simulating API call
  // //   try {
  // //     final value = await _studentRepository.registerStudent(student);
  // //     print('this is got');
  // //     print('This is the Value : $value');
  // //
  // //     if (value!['error'] == 1) {
  // //       emit(StudentFailure(message: value['message'].toString()));
  // //     } else if (value['error'] == 0) {
  // //       emit(StudentSuccess(message: value['message'].toString()));
  // //     }
  // //   } catch (error) {
  // //     print('this error occured $error');
  // //     emit(StudentFailure(message: error.toString()));
  // //   }
  // //   // emit(StudentRegistered());
  // // }
  //   emit(StudentLoading());
  //   try {
  //     // FIX: Ensure data['created_by'] is converted to String BEFORE parsing
  //     // This handles cases where created_by is already an int OR a String.
  //     // final String rawCreatedBy = data['created_by']?.toString() ?? '0';
  //     // final int creatorId = int.parse(rawCreatedBy);
  //
  //     // Construct payload ensuring all String fields are actually Strings
  //     final payload = {
  //       'name': data['name']?.toString() ?? '',
  //       'class': data['class']?.toString() ?? '',
  //       'gender': data['gender']?.toString() ?? '',
  //       'created_by': data['created_by']?.toString() ?? '0',
  //       'apaarId': (data['apaarId'] == null || data['apaarId'].toString().trim().isEmpty)
  //           ? 'NA'
  //           : data['apaarId'].toString(),
  //       'pen_id': (data['pen_id'] == null || data['pen_id'].toString().trim().isEmpty)
  //           ? 'NA'
  //           : data['pen_id'].toString(),
  //       'rollno': (data['rollno'] == null || data['rollno'].toString().trim().isEmpty)
  //           ? 'NA'
  //           : data['rollno'].toString(),
  //     };
  //
  //     print("Sending Payload to API: $payload");
  //
  //     final value = await _studentRepository.registerStudent(payload);
  //
  //     if (value['error'] == 1) {
  //       emit(StudentFailure(message: value['message'].toString()));
  //     } else {
  //       emit(StudentSuccess(message: value['message'].toString()));
  //     }
  //   } catch (error) {
  //     print("Cubit Error Trace: $error");
  //     emit(StudentFailure(message: "Registration Error: ${error.toString()}"));
  //   }
  // }

  void registerStudent(dynamic data) async {
    emit(StudentLoading());
    try {
      final payload = {
        'name': data['name']?.toString() ?? '',
        'class': data['class']?.toString() ?? '',
        'gender': data['gender']?.toString() ?? '',
        'created_by': data['created_by']?.toString() ?? '0',
        'apaarId': (data['apaarId'] == null || data['apaarId'].toString().trim().isEmpty) ? 'NA' : data['apaarId'].toString(),
        'pen_id': (data['pen_id'] == null || data['pen_id'].toString().trim().isEmpty) ? 'NA' : data['pen_id'].toString(),
        'rollno': (data['rollno'] == null || data['rollno'].toString().trim().isEmpty) ? 'NA' : data['rollno'].toString(),
        'school': data['school']?.toString() ?? '',
        'schoolCodeNew': data['schoolCodeNew']?.toString() ?? '',
      };

      // NEW — branch on connectivity
      final online = await _isOnline();
      final value = online
          ? await _studentRepository.registerStudent(payload)
          : await _studentRepository.registerStudentOffline(payload);

      if (value['error'] == 1) {
        emit(StudentFailure(message: value['message'].toString()));
      } else {
        emit(StudentSuccess(message: value['message'].toString()));
      }
    } catch (error) {
      emit(StudentFailure(message: "Registration Error: ${error.toString()}"));
    }
  }

  Future<void> fetchStudents({
    required dynamic adminId,
    String? stateName, String? district, String? block, String? school, String? from, String? to,
  }) async {
    if (_isLoading || !_hasMoreData) return;
    _isLoading = true;
    emit(StudentLoading());

    try {
      final online = await _isOnline();
      if (!online) {
        final students = await _studentRepository.getStudentsOffline(school); // pass through as-is, null is fine now
        emit(StudentListSuccess(studentList: students, message: 'Loaded from offline cache'));
        _hasMoreData = false;
        return;
      }

      final value = await _studentRepository.getStudents(
          adminId, stateName, district, block, school, from, to, page: _page);

      if (value is Map<String, dynamic>) {
        if (value['error'] == 1) {
          emit(StudentFailure(message: value['message'].toString()));
        } else if (value['error'] == 0) {
          List<StudentModel> students = (value['data'] as List).map((s) => StudentModel.fromJson(s)).toList();
          _hasMoreData = value['data'].length > 0;
          if (_hasMoreData) _page++;
          emit(StudentListSuccess(studentList: students, message: value['message'].toString()));
        }
      }
    } catch (error) {
      emit(StudentFailure(message: error.toString()));
    } finally {
      _isLoading = false;
    }
  }

  void updateStudent(StudentModel? student) async {
    emit(StudentLoading());

    // Prepare the data map for the API
    final data = {
      "action": "update",
      "id": student?.id,
      "rollno": student?.rollNo,
      "name": student?.name,
      "gender": student?.gender,
      "class": student?.classs,
      "apaarId": student?.apaarId,
      "penId": student?.penId,
      "uniqueId": student?.uniqueId,
      "school": student?.school,
      "created_by" : student?.createdBy,
      "status" : student?.status,
      "reason" : student?.reason,
    };

    try {
      final value = await _studentRepository.updateStudent(data);

      if (value['error'] == false) {
        emit(StudentSuccess(message: value['message'].toString()));
      } else {
        emit(StudentFailure(message: value['message'].toString()));
      }
    } catch (error) {
      print('Update error: $error');
      emit(StudentFailure(message: error.toString()));
    }
  }

  Future<void> getStudentId(String state) async {
  print('this is student id for state $state');
  emit(StudentLoading());
  await Future.delayed(const Duration(seconds: 1)); // Simulate delay
  try {
    final String studentId = await _studentRepository.getUniqueId(state);

    if (studentId.isNotEmpty) {
     
      emit(StudentIdSuccess(studentId: studentId));
    } else {
      emit(StudentFailure(message: 'Empty student ID returned'));
    }
  } catch (error) {
    print(error);
    emit(StudentFailure(message: error.toString()));
  }
}

  Future<void> getOfflineStudentId() async {
    emit(StudentLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final school = prefs.getString('school') ?? '';
      final schoolCodeNew = prefs.getString('schoolCodeNew') ?? '';

      if (schoolCodeNew.isEmpty) {
        emit(StudentFailure(message: 'School code not available yet — please sync once while online'));
        return;
      }

      final studentId = await _studentRepository.generateUniqueId(schoolCodeNew, school);
      emit(StudentIdSuccess(studentId: studentId));
    } catch (error) {
      emit(StudentFailure(message: error.toString()));
    }
  }



  // Future<void> fetchStudents({
  //   required dynamic adminId,
  //   String? stateName,
  //   String? district,
  //   String? block,
  //   String? school,
  //   String? from,
  //   String? to,
  // }) async {
  //   if (_isLoading || !_hasMoreData)
  //     return; // Prevent multiple simultaneous requests
  //   _isLoading = true;
  //   emit(StudentLoading()); // Show loading state
  //
  //   await Future.delayed(const Duration(seconds: 1)); // Simulating API call
  //
  //   try {
  //     final value = await _studentRepository.getStudents(
  //         adminId, stateName, district, block, school, from, to,
  //         page: _page); // Pass page number to API
  //
  //     if (value is Map<String, dynamic>) {
  //       if (value['error'] == 1) {
  //         emit(StudentFailure(message: value['message'].toString()));
  //       } else if (value['error'] == 0) {
  //         List<StudentModel> students = (value['data'] as List)
  //             .map((student) => StudentModel.fromJson(student))
  //             .toList();
  //
  //         // Check if there are more students to load
  //         _hasMoreData = value['data'].length >
  //             0; // Assume if data length is 0, there's no more data
  //
  //         // If more data exists, increase the page number for the next request
  //         if (_hasMoreData) {
  //           _page++;
  //         }
  //
  //         emit(StudentListSuccess(
  //             studentList: students, message: value['message'].toString()));
  //       }
  //     } else {
  //       emit(StudentFailure(message: 'Unexpected response format'));
  //     }
  //   } catch (error) {
  //     emit(StudentFailure(message: error.toString()));
  //   } finally {
  //     _isLoading = false; // Reset loading flag
  //   }
  // }


 void promoteStudent(dynamic data) async {
    emit(StudentLoading());
    await Future.delayed(const Duration(seconds: 1)); // Simulating API call
    try {
      final value = await _studentRepository.promote(data);
      print('value of promote Student $value');

      if (value!['error'] == 1) {
        print('Error occured at promotion');
        emit(StudentFailure(message: value['message'].toString()));
      } else if (value['error'] == 0) {
         print('success occured at promotion');
        emit(StudentPromote(message: value['message'].toString()));
      }
    } catch (error) {
      print('catch error $error');
      emit(StudentFailure(message: error.toString()));
    }
    // emit(StudentRegistered());
  }

  // Add this method inside your StudentCubit class

  Future<void> fetchGrades() async {
    emit(GradesLoading());
    try {
      final online = await _isOnline();
      final grades = online
          ? await _studentRepository.getGrades()
          : await _studentRepository.getGradesOffline(); // NEW
      emit(GradesSuccess(grades));
    } catch (e) {
      emit(GradesFailure('Failed to fetch grades: ${e.toString()}'));
    }
  }



}



class RadioCubit extends Cubit<String?> {
  RadioCubit() : super(null);

  void selectOption(String option) => emit(option);
  void reset() => emit(null);
}
