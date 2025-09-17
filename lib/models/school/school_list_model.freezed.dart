// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'school_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SchoolListModel _$SchoolListModelFromJson(Map<String, dynamic> json) {
  return _SchoolListModel.fromJson(json);
}

/// @nodoc
mixin _$SchoolListModel {
  List<String> get schools => throw _privateConstructorUsedError;

  /// Serializes this SchoolListModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SchoolListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SchoolListModelCopyWith<SchoolListModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SchoolListModelCopyWith<$Res> {
  factory $SchoolListModelCopyWith(
          SchoolListModel value, $Res Function(SchoolListModel) then) =
      _$SchoolListModelCopyWithImpl<$Res, SchoolListModel>;
  @useResult
  $Res call({List<String> schools});
}

/// @nodoc
class _$SchoolListModelCopyWithImpl<$Res, $Val extends SchoolListModel>
    implements $SchoolListModelCopyWith<$Res> {
  _$SchoolListModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SchoolListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? schools = null,
  }) {
    return _then(_value.copyWith(
      schools: null == schools
          ? _value.schools
          : schools // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SchoolListModelImplCopyWith<$Res>
    implements $SchoolListModelCopyWith<$Res> {
  factory _$$SchoolListModelImplCopyWith(_$SchoolListModelImpl value,
          $Res Function(_$SchoolListModelImpl) then) =
      __$$SchoolListModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> schools});
}

/// @nodoc
class __$$SchoolListModelImplCopyWithImpl<$Res>
    extends _$SchoolListModelCopyWithImpl<$Res, _$SchoolListModelImpl>
    implements _$$SchoolListModelImplCopyWith<$Res> {
  __$$SchoolListModelImplCopyWithImpl(
      _$SchoolListModelImpl _value, $Res Function(_$SchoolListModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SchoolListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? schools = null,
  }) {
    return _then(_$SchoolListModelImpl(
      schools: null == schools
          ? _value._schools
          : schools // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SchoolListModelImpl implements _SchoolListModel {
  _$SchoolListModelImpl({required final List<String> schools})
      : _schools = schools;

  factory _$SchoolListModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SchoolListModelImplFromJson(json);

  final List<String> _schools;
  @override
  List<String> get schools {
    if (_schools is EqualUnmodifiableListView) return _schools;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_schools);
  }

  @override
  String toString() {
    return 'SchoolListModel(schools: $schools)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SchoolListModelImpl &&
            const DeepCollectionEquality().equals(other._schools, _schools));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_schools));

  /// Create a copy of SchoolListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SchoolListModelImplCopyWith<_$SchoolListModelImpl> get copyWith =>
      __$$SchoolListModelImplCopyWithImpl<_$SchoolListModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SchoolListModelImplToJson(
      this,
    );
  }
}

abstract class _SchoolListModel implements SchoolListModel {
  factory _SchoolListModel({required final List<String> schools}) =
      _$SchoolListModelImpl;

  factory _SchoolListModel.fromJson(Map<String, dynamic> json) =
      _$SchoolListModelImpl.fromJson;

  @override
  List<String> get schools;

  /// Create a copy of SchoolListModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SchoolListModelImplCopyWith<_$SchoolListModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
