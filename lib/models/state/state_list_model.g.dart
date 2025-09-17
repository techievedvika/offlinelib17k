// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StateListModelImpl _$$StateListModelImplFromJson(Map<String, dynamic> json) =>
    _$StateListModelImpl(
      states:
          (json['states'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$StateListModelImplToJson(
        _$StateListModelImpl instance) =>
    <String, dynamic>{
      'states': instance.states,
    };
