// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
part 'book_return_model.freezed.dart';
part 'book_return_model.g.dart';

@freezed
class BookReturnModel with _$BookReturnModel {
  factory BookReturnModel({
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'school') required String school,
    @JsonKey(name: 'class') required String studentnclass,
    @JsonKey(name: 'gender') required String gender,
    @JsonKey(name: 'unique_id') required String uniqid,
    @JsonKey(name: 'apaarId') required String apparId,
    @JsonKey(name: 'created_at') required String returnedDate,
    //@JsonKey(name: 'issued_date') required String returnedDate,
    @JsonKey(name: 'created_by') required String createdBy,
    @JsonKey(name: 'isbn') required String isbn,
    @JsonKey(name: 'publisher') required String publisher,
    @JsonKey(name: 'author') required String author,
    @JsonKey(name: 'language') required String language,
    @JsonKey(name: 'gener') required String gener,
    @JsonKey(name: 'level') required String level,
    @JsonKey(name: 'code') required String code,
  }) = _BookReturnModel;

  factory BookReturnModel.fromJson(Map<String, dynamic> json) =>
      _$BookReturnModelFromJson(json);
}
