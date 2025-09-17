// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
part 'book_issue_model.freezed.dart';
part 'book_issue_model.g.dart';

@freezed
class BookIssueModel with _$BookIssueModel {
  factory BookIssueModel({
   
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'title')  String? title,
    @JsonKey(name: 'school')  String? school,
    @JsonKey(name: 'class')  String? studentnclass,
    @JsonKey(name: 'gender')  String? gender,
    @JsonKey(name: 'unique_id')  String? uniqid,
    @JsonKey(name: 'apaarId')  String? apparId,
    @JsonKey(name: 'issued_date')  String? issuedDate,
    @JsonKey(name: 'returned_date')  String? returnedDate,
    @JsonKey(name: 'created_by')  String? createdBy,
    @JsonKey(name: 'isbn')  String? isbn,
    @JsonKey(name: 'publisher')  String? publisher,
    @JsonKey(name: 'author')  String? author,
    @JsonKey(name: 'language')  String? language,
    @JsonKey(name: 'gener')  String? gener,
    @JsonKey(name: 'level')  String? level,
    @JsonKey(name: 'code')  String? code,
    
    
    
    
  }) = _BookIssueModel;

  factory BookIssueModel.fromJson(Map<String, dynamic> json) =>
      _$BookIssueModelFromJson(json);
}

        
         