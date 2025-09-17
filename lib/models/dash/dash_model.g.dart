// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dash_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashModelImpl _$$DashModelImplFromJson(Map<String, dynamic> json) =>
    _$DashModelImpl(
      error: json['error'] as bool,
      message: json['message'] as String,
      students: (json['students'] as num).toInt(),
      bookIssued: (json['bookIssued'] as num).toInt(),
      pendingReturn: (json['pendingReturn'] as num).toInt(),
      green: (json['green'] as num).toInt(),
      red: (json['red'] as num).toInt(),
      orange: (json['orange'] as num).toInt(),
      white: (json['white'] as num).toInt(),
      na: (json['na'] as num).toInt(),
      bargraph: json['barGraph'] as List<dynamic>,
    );

Map<String, dynamic> _$$DashModelImplToJson(_$DashModelImpl instance) =>
    <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
      'students': instance.students,
      'bookIssued': instance.bookIssued,
      'pendingReturn': instance.pendingReturn,
      'green': instance.green,
      'red': instance.red,
      'orange': instance.orange,
      'white': instance.white,
      'na': instance.na,
      'barGraph': instance.bargraph,
    };
