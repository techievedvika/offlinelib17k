// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'state_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StateListModel _$StateListModelFromJson(Map<String, dynamic> json) {
  return _StateListModel.fromJson(json);
}

/// @nodoc
mixin _$StateListModel {
  List<String> get states => throw _privateConstructorUsedError;

  /// Serializes this StateListModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StateListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StateListModelCopyWith<StateListModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StateListModelCopyWith<$Res> {
  factory $StateListModelCopyWith(
          StateListModel value, $Res Function(StateListModel) then) =
      _$StateListModelCopyWithImpl<$Res, StateListModel>;
  @useResult
  $Res call({List<String> states});
}

/// @nodoc
class _$StateListModelCopyWithImpl<$Res, $Val extends StateListModel>
    implements $StateListModelCopyWith<$Res> {
  _$StateListModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StateListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? states = null,
  }) {
    return _then(_value.copyWith(
      states: null == states
          ? _value.states
          : states // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StateListModelImplCopyWith<$Res>
    implements $StateListModelCopyWith<$Res> {
  factory _$$StateListModelImplCopyWith(_$StateListModelImpl value,
          $Res Function(_$StateListModelImpl) then) =
      __$$StateListModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> states});
}

/// @nodoc
class __$$StateListModelImplCopyWithImpl<$Res>
    extends _$StateListModelCopyWithImpl<$Res, _$StateListModelImpl>
    implements _$$StateListModelImplCopyWith<$Res> {
  __$$StateListModelImplCopyWithImpl(
      _$StateListModelImpl _value, $Res Function(_$StateListModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of StateListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? states = null,
  }) {
    return _then(_$StateListModelImpl(
      states: null == states
          ? _value._states
          : states // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StateListModelImpl implements _StateListModel {
  _$StateListModelImpl({required final List<String> states}) : _states = states;

  factory _$StateListModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StateListModelImplFromJson(json);

  final List<String> _states;
  @override
  List<String> get states {
    if (_states is EqualUnmodifiableListView) return _states;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_states);
  }

  @override
  String toString() {
    return 'StateListModel(states: $states)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StateListModelImpl &&
            const DeepCollectionEquality().equals(other._states, _states));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_states));

  /// Create a copy of StateListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StateListModelImplCopyWith<_$StateListModelImpl> get copyWith =>
      __$$StateListModelImplCopyWithImpl<_$StateListModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StateListModelImplToJson(
      this,
    );
  }
}

abstract class _StateListModel implements StateListModel {
  factory _StateListModel({required final List<String> states}) =
      _$StateListModelImpl;

  factory _StateListModel.fromJson(Map<String, dynamic> json) =
      _$StateListModelImpl.fromJson;

  @override
  List<String> get states;

  /// Create a copy of StateListModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StateListModelImplCopyWith<_$StateListModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
