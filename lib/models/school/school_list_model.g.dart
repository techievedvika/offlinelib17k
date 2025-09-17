// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'school_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SchoolListModelImpl _$$SchoolListModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SchoolListModelImpl(
      schools:
          (json['schools'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$SchoolListModelImplToJson(
        _$SchoolListModelImpl instance) =>
    <String, dynamic>{
      'schools': instance.schools,
    };
