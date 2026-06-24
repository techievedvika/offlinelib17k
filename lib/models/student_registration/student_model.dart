// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
part 'student_model.freezed.dart';
part 'student_model.g.dart';

@freezed
class StudentModel with _$StudentModel {
  factory StudentModel({
    @JsonKey(name: 'created_by',fromJson:_intOrStringToString )  String? createdBy,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'rollno') required String rollNo,
    @JsonKey(name: 'gender') required String gender,
    @JsonKey(name: 'class') required String classs,
   @JsonKey(name: 'id', fromJson: _intOrStringToString, toJson: _stringToDynamic) String? id,
    @JsonKey(name: 'apaarId')  String? apaarId,
    @JsonKey(name: 'pen_id')  String? penId,
    @JsonKey(name: 'unique_id')  String? uniqueId,
    @JsonKey(name: 'school')  String? school,
    @JsonKey(name: 'status', fromJson: _intOrStringToString, toJson: _stringToDynamic)  String? status,
    @JsonKey(name: 'reason')  String? reason,
    
    
  }) = _StudentModel;

  factory StudentModel.fromJson(Map<String, dynamic> json) =>
      _$StudentModelFromJson(json);
}
/// ✅ Handles int, string, or null and returns a String
String? _intOrStringToString(dynamic value) {
  if (value == null) return null;
  return value.toString();
}

/// ✅ Returns null if input is null, else returns the string
dynamic _stringToDynamic(String? value) {
  if (value == null || value.isEmpty) return null;
  return value;
}
        