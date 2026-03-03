part of 'student_cubit.dart';

abstract class StudentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class StudentInitial extends StudentState {}

class StudentLoading extends StudentState {}

class StudentFailure extends StudentState {
  final String message;
  StudentFailure({required this.message});
}

class StudentSuccess extends StudentState {
  final String message;
  StudentSuccess({required this.message});
}

class StudentPromote extends StudentState {
  final String message;
  StudentPromote({required this.message});
}
class StudentListSuccess extends StudentState {
  final List<StudentModel>  studentList;
  final String? message;
  StudentListSuccess({required this.studentList,this.message});
}

class StudentIdSuccess extends StudentState {
  final String studentId;

  StudentIdSuccess({required this.studentId});
}


class StudentRegistered extends StudentState {
  StudentRegistered();
}

// Add these to your student_state.dart file

class GradesLoading extends StudentState {}

class GradesSuccess extends StudentState {
  final List<String> grades;
  GradesSuccess(this.grades);

  @override
  List<Object> get props => [grades];
}

class GradesFailure extends StudentState {
  final String message;
  GradesFailure(this.message);

  @override
  List<Object> get props => [message];
}

