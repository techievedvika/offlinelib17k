// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      username: json['username'] as String,
      state: json['state'] as String,
      district: json['district'] as String,
      location: json['location'] as String,
      id: (json['id'] as num).toInt(),
      block: json['block'] as String,
      school: json['school'] as String,
      fullName: json['full_name'] as String,
      role: json['role'] as String,
      rights: json['rights'] as String,
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'username': instance.username,
      'state': instance.state,
      'district': instance.district,
      'location': instance.location,
      'id': instance.id,
      'block': instance.block,
      'school': instance.school,
      'full_name': instance.fullName,
      'role': instance.role,
      'rights': instance.rights,
    };
