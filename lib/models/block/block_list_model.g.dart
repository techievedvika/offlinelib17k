// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BlockListModelImpl _$$BlockListModelImplFromJson(Map<String, dynamic> json) =>
    _$BlockListModelImpl(
      blocks:
          (json['blocks'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$BlockListModelImplToJson(
        _$BlockListModelImpl instance) =>
    <String, dynamic>{
      'blocks': instance.blocks,
    };
