// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'block_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BlockListModel _$BlockListModelFromJson(Map<String, dynamic> json) {
  return _BlockListModel.fromJson(json);
}

/// @nodoc
mixin _$BlockListModel {
  List<String> get blocks => throw _privateConstructorUsedError;

  /// Serializes this BlockListModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BlockListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BlockListModelCopyWith<BlockListModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlockListModelCopyWith<$Res> {
  factory $BlockListModelCopyWith(
          BlockListModel value, $Res Function(BlockListModel) then) =
      _$BlockListModelCopyWithImpl<$Res, BlockListModel>;
  @useResult
  $Res call({List<String> blocks});
}

/// @nodoc
class _$BlockListModelCopyWithImpl<$Res, $Val extends BlockListModel>
    implements $BlockListModelCopyWith<$Res> {
  _$BlockListModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BlockListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? blocks = null,
  }) {
    return _then(_value.copyWith(
      blocks: null == blocks
          ? _value.blocks
          : blocks // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BlockListModelImplCopyWith<$Res>
    implements $BlockListModelCopyWith<$Res> {
  factory _$$BlockListModelImplCopyWith(_$BlockListModelImpl value,
          $Res Function(_$BlockListModelImpl) then) =
      __$$BlockListModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> blocks});
}

/// @nodoc
class __$$BlockListModelImplCopyWithImpl<$Res>
    extends _$BlockListModelCopyWithImpl<$Res, _$BlockListModelImpl>
    implements _$$BlockListModelImplCopyWith<$Res> {
  __$$BlockListModelImplCopyWithImpl(
      _$BlockListModelImpl _value, $Res Function(_$BlockListModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of BlockListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? blocks = null,
  }) {
    return _then(_$BlockListModelImpl(
      blocks: null == blocks
          ? _value._blocks
          : blocks // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BlockListModelImpl implements _BlockListModel {
  _$BlockListModelImpl({required final List<String> blocks}) : _blocks = blocks;

  factory _$BlockListModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BlockListModelImplFromJson(json);

  final List<String> _blocks;
  @override
  List<String> get blocks {
    if (_blocks is EqualUnmodifiableListView) return _blocks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_blocks);
  }

  @override
  String toString() {
    return 'BlockListModel(blocks: $blocks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlockListModelImpl &&
            const DeepCollectionEquality().equals(other._blocks, _blocks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_blocks));

  /// Create a copy of BlockListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BlockListModelImplCopyWith<_$BlockListModelImpl> get copyWith =>
      __$$BlockListModelImplCopyWithImpl<_$BlockListModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BlockListModelImplToJson(
      this,
    );
  }
}

abstract class _BlockListModel implements BlockListModel {
  factory _BlockListModel({required final List<String> blocks}) =
      _$BlockListModelImpl;

  factory _BlockListModel.fromJson(Map<String, dynamic> json) =
      _$BlockListModelImpl.fromJson;

  @override
  List<String> get blocks;

  /// Create a copy of BlockListModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BlockListModelImplCopyWith<_$BlockListModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
