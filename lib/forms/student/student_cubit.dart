import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lib17000ft/models/student_registration/student_model.dart';
import 'student_repository.dart';
part 'student_state.dart';

class StudentCubit extends Cubit<StudentState> {
  StudentCubit() : super(StudentInitial());
  final StudentRepository _studentRepository = StudentRepository();
  bool _isLoading = false; // Flag to prevent multiple simultaneous requests
  int _page = 1; // For pagination, assuming 1 as the starting page
  bool _hasMoreData = true; // Flag to check if there's more data

  void registerStudent(dynamic student) async {
    emit(StudentLoading());
    print('this is student data $student');
    await Future.delayed(const Duration(seconds: 1)); // Simulating API call
    try {
      final value = await _studentRepository.registerStudent(student);
      print('this is got');
      print(value);

      if (value!['error'] == 1) {
        emit(StudentFailure(message: value['message'].toString()));
      } else if (value['error'] == 0) {
        emit(StudentSuccess(message: value['message'].toString()));
      }
    } catch (error) {
      print('this error occured $error');
      emit(StudentFailure(message: error.toString()));
    }
    // emit(StudentRegistered());
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
      "school": student?.school,
      "created_by" : student?.createdBy,
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



  Future<void> fetchStudents({
    required dynamic adminId,
    String? stateName,
    String? district,
    String? block,
    String? school,
    String? from,
    String? to,
  }) async {
    if (_isLoading || !_hasMoreData)
      return; // Prevent multiple simultaneous requests
    _isLoading = true;
    emit(StudentLoading()); // Show loading state

    await Future.delayed(const Duration(seconds: 1)); // Simulating API call

    try {
      final value = await _studentRepository.getStudents(
          adminId, stateName, district, block, school, from, to,
          page: _page); // Pass page number to API

      if (value is Map<String, dynamic>) {
        if (value['error'] == 1) {
          emit(StudentFailure(message: value['message'].toString()));
        } else if (value['error'] == 0) {
          List<StudentModel> students = (value['data'] as List)
              .map((student) => StudentModel.fromJson(student))
              .toList();

          // Check if there are more students to load
          _hasMoreData = value['data'].length >
              0; // Assume if data length is 0, there's no more data

          // If more data exists, increase the page number for the next request
          if (_hasMoreData) {
            _page++;
          }

          emit(StudentListSuccess(
              studentList: students, message: value['message'].toString()));
        }
      } else {
        emit(StudentFailure(message: 'Unexpected response format'));
      }
    } catch (error) {
      emit(StudentFailure(message: error.toString()));
    } finally {
      _isLoading = false; // Reset loading flag
    }
  }


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
      print('catch error $error')
;      emit(StudentFailure(message: error.toString()));
    }
    // emit(StudentRegistered());
  }

  // Add this method inside your StudentCubit class

  Future<void> fetchGrades() async {
    emit(GradesLoading());
    try {
      final grades = await _studentRepository.getGrades();
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
