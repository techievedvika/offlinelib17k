// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StudentModelImpl _$$StudentModelImplFromJson(Map<String, dynamic> json) =>
    _$StudentModelImpl(
      createdBy: _intOrStringToString(json['created_by']),
      name: json['name'] as String,
      rollNo: json['rollno'] as String,
      gender: json['gender'] as String,
      classs: json['class'] as String,
      id: _intOrStringToString(json['id']),
      apaarId: json['apaarId'] as String?,
      penId: json['pen_id'] as String?,
      uniqueId: json['unique_id'] as String?,
      school: json['school'] as String?,
      status: _intOrStringToString(json['status']),
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$$StudentModelImplToJson(_$StudentModelImpl instance) =>
    <String, dynamic>{
      'created_by': instance.createdBy,
      'name': instance.name,
      'rollno': instance.rollNo,
      'gender': instance.gender,
      'class': instance.classs,
      'id': _stringToDynamic(instance.id),
      'apaarId': instance.apaarId,
      'pen_id': instance.penId,
      'unique_id': instance.uniqueId,
      'school': instance.school,
      'status': _stringToDynamic(instance.status),
      'reason': instance.reason,
    };
