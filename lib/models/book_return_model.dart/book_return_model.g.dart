// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_return_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookReturnModelImpl _$$BookReturnModelImplFromJson(
        Map<String, dynamic> json) =>
    _$BookReturnModelImpl(
      name: json['name'] as String?,
      title: json['title'] as String,
      school: json['school'] as String,
      studentnclass: json['class'] as String,
      gender: json['gender'] as String,
      uniqid: json['unique_id'] as String,
      apparId: json['apaarId'] as String,
      penId: json['pen_id'] as String?,
      rollno: json['rollno'] as String,
      returnedDate: json['created_at'] as String,
      createdBy: json['created_by'] as String,
      isbn: json['isbn'] as String,
      publisher: json['publisher'] as String,
      author: json['author'] as String,
      language: json['language'] as String,
      gener: json['gener'] as String,
      level: json['level'] as String,
      code: json['code'] as String,
    );

Map<String, dynamic> _$$BookReturnModelImplToJson(
        _$BookReturnModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'title': instance.title,
      'school': instance.school,
      'class': instance.studentnclass,
      'gender': instance.gender,
      'unique_id': instance.uniqid,
      'apaarId': instance.apparId,
      'pen_id': instance.penId,
      'rollno': instance.rollno,
      'created_at': instance.returnedDate,
      'created_by': instance.createdBy,
      'isbn': instance.isbn,
      'publisher': instance.publisher,
      'author': instance.author,
      'language': instance.language,
      'gener': instance.gener,
      'level': instance.level,
      'code': instance.code,
    };
