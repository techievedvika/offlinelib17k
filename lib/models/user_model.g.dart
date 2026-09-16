// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      message: json['message'] as String,
      status: (json['status'] as num).toInt(),
      code: json['code'] as String?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      license: json['license'] == null
          ? null
          : License.fromJson(json['license'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
      'code': instance.code,
      'user': instance.user,
      'license': instance.license,
    };
