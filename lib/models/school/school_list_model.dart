// state_list_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'school_list_model.freezed.dart';
part 'school_list_model.g.dart';

@freezed
class SchoolListModel with _$SchoolListModel {
  factory SchoolListModel({
    required List<String> schools,
  }) = _SchoolListModel;

  factory SchoolListModel.fromJson(List<dynamic> json) =>
      SchoolListModel(schools: List<String>.from(json));
}
