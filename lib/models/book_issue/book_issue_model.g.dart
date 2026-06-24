// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_issue_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookIssueModelImpl _$$BookIssueModelImplFromJson(Map<String, dynamic> json) =>
    _$BookIssueModelImpl(
      name: json['name'] as String?,
      title: json['title'] as String?,
      school: json['school'] as String?,
      studentnclass: json['class'] as String?,
      gender: json['gender'] as String?,
      uniqid: json['unique_id'] as String?,
      apparId: json['apaarId'] as String?,
      issuedDate: json['issued_date'] as String?,
      returnedDate: json['returned_date'] as String?,
      createdBy: json['created_by'] as String?,
      isbn: json['isbn'] as String?,
      publisher: json['publisher'] as String?,
      author: json['author'] as String?,
      language: json['language'] as String?,
      gener: json['gener'] as String?,
      level: json['level'] as String?,
      code: json['code'] as String?,
      studentCreatedAt: json['student_created_at'] as String?,
    );

Map<String, dynamic> _$$BookIssueModelImplToJson(
        _$BookIssueModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'title': instance.title,
      'school': instance.school,
      'class': instance.studentnclass,
      'gender': instance.gender,
      'unique_id': instance.uniqid,
      'apaarId': instance.apparId,
      'issued_date': instance.issuedDate,
      'returned_date': instance.returnedDate,
      'created_by': instance.createdBy,
      'isbn': instance.isbn,
      'publisher': instance.publisher,
      'author': instance.author,
      'language': instance.language,
      'gener': instance.gener,
      'level': instance.level,
      'code': instance.code,
      'student_created_at': instance.studentCreatedAt,
    };
