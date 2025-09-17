// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StudentModel _$StudentModelFromJson(Map<String, dynamic> json) {
  return _StudentModel.fromJson(json);
}

/// @nodoc
mixin _$StudentModel {
  @JsonKey(name: 'created_by', fromJson: _intOrStringToString)
  String? get createdBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'rollno')
  String get rollNo => throw _privateConstructorUsedError;
  @JsonKey(name: 'gender')
  String get gender => throw _privateConstructorUsedError;
  @JsonKey(name: 'class')
  String get classs => throw _privateConstructorUsedError;
  @JsonKey(name: 'id', fromJson: _intOrStringToString, toJson: _stringToDynamic)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'apaarId')
  String? get apaarId => throw _privateConstructorUsedError;
  @JsonKey(name: 'school')
  String? get school => throw _privateConstructorUsedError;

  /// Serializes this StudentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StudentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StudentModelCopyWith<StudentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudentModelCopyWith<$Res> {
  factory $StudentModelCopyWith(
          StudentModel value, $Res Function(StudentModel) then) =
      _$StudentModelCopyWithImpl<$Res, StudentModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'created_by', fromJson: _intOrStringToString)
      String? createdBy,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'rollno') String rollNo,
      @JsonKey(name: 'gender') String gender,
      @JsonKey(name: 'class') String classs,
      @JsonKey(
          name: 'id', fromJson: _intOrStringToString, toJson: _stringToDynamic)
      String? id,
      @JsonKey(name: 'apaarId') String? apaarId,
      @JsonKey(name: 'school') String? school});
}

/// @nodoc
class _$StudentModelCopyWithImpl<$Res, $Val extends StudentModel>
    implements $StudentModelCopyWith<$Res> {
  _$StudentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StudentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdBy = freezed,
    Object? name = null,
    Object? rollNo = null,
    Object? gender = null,
    Object? classs = null,
    Object? id = freezed,
    Object? apaarId = freezed,
    Object? school = freezed,
  }) {
    return _then(_value.copyWith(
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      rollNo: null == rollNo
          ? _value.rollNo
          : rollNo // ignore: cast_nullable_to_non_nullable
              as String,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      classs: null == classs
          ? _value.classs
          : classs // ignore: cast_nullable_to_non_nullable
              as String,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      apaarId: freezed == apaarId
          ? _value.apaarId
          : apaarId // ignore: cast_nullable_to_non_nullable
              as String?,
      school: freezed == school
          ? _value.school
          : school // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StudentModelImplCopyWith<$Res>
    implements $StudentModelCopyWith<$Res> {
  factory _$$StudentModelImplCopyWith(
          _$StudentModelImpl value, $Res Function(_$StudentModelImpl) then) =
      __$$StudentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'created_by', fromJson: _intOrStringToString)
      String? createdBy,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'rollno') String rollNo,
      @JsonKey(name: 'gender') String gender,
      @JsonKey(name: 'class') String classs,
      @JsonKey(
          name: 'id', fromJson: _intOrStringToString, toJson: _stringToDynamic)
      String? id,
      @JsonKey(name: 'apaarId') String? apaarId,
      @JsonKey(name: 'school') String? school});
}

/// @nodoc
class __$$StudentModelImplCopyWithImpl<$Res>
    extends _$StudentModelCopyWithImpl<$Res, _$StudentModelImpl>
    implements _$$StudentModelImplCopyWith<$Res> {
  __$$StudentModelImplCopyWithImpl(
      _$StudentModelImpl _value, $Res Function(_$StudentModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of StudentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdBy = freezed,
    Object? name = null,
    Object? rollNo = null,
    Object? gender = null,
    Object? classs = null,
    Object? id = freezed,
    Object? apaarId = freezed,
    Object? school = freezed,
  }) {
    return _then(_$StudentModelImpl(
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      rollNo: null == rollNo
          ? _value.rollNo
          : rollNo // ignore: cast_nullable_to_non_nullable
              as String,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      classs: null == classs
          ? _value.classs
          : classs // ignore: cast_nullable_to_non_nullable
              as String,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      apaarId: freezed == apaarId
          ? _value.apaarId
          : apaarId // ignore: cast_nullable_to_non_nullable
              as String?,
      school: freezed == school
          ? _value.school
          : school // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StudentModelImpl implements _StudentModel {
  _$StudentModelImpl(
      {@JsonKey(name: 'created_by', fromJson: _intOrStringToString)
      this.createdBy,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'rollno') required this.rollNo,
      @JsonKey(name: 'gender') required this.gender,
      @JsonKey(name: 'class') required this.classs,
      @JsonKey(
          name: 'id', fromJson: _intOrStringToString, toJson: _stringToDynamic)
      this.id,
      @JsonKey(name: 'apaarId') this.apaarId,
      @JsonKey(name: 'school') this.school});

  factory _$StudentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StudentModelImplFromJson(json);

  @override
  @JsonKey(name: 'created_by', fromJson: _intOrStringToString)
  final String? createdBy;
  @override
  @JsonKey(name: 'name')
  final String name;
  @override
  @JsonKey(name: 'rollno')
  final String rollNo;
  @override
  @JsonKey(name: 'gender')
  final String gender;
  @override
  @JsonKey(name: 'class')
  final String classs;
  @override
  @JsonKey(name: 'id', fromJson: _intOrStringToString, toJson: _stringToDynamic)
  final String? id;
  @override
  @JsonKey(name: 'apaarId')
  final String? apaarId;
  @override
  @JsonKey(name: 'school')
  final String? school;

  @override
  String toString() {
    return 'StudentModel(createdBy: $createdBy, name: $name, rollNo: $rollNo, gender: $gender, classs: $classs, id: $id, apaarId: $apaarId, school: $school)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudentModelImpl &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.rollNo, rollNo) || other.rollNo == rollNo) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.classs, classs) || other.classs == classs) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.apaarId, apaarId) || other.apaarId == apaarId) &&
            (identical(other.school, school) || other.school == school));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, createdBy, name, rollNo, gender,
      classs, id, apaarId, school);

  /// Create a copy of StudentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StudentModelImplCopyWith<_$StudentModelImpl> get copyWith =>
      __$$StudentModelImplCopyWithImpl<_$StudentModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StudentModelImplToJson(
      this,
    );
  }
}

abstract class _StudentModel implements StudentModel {
  factory _StudentModel(
      {@JsonKey(name: 'created_by', fromJson: _intOrStringToString)
      final String? createdBy,
      @JsonKey(name: 'name') required final String name,
      @JsonKey(name: 'rollno') required final String rollNo,
      @JsonKey(name: 'gender') required final String gender,
      @JsonKey(name: 'class') required final String classs,
      @JsonKey(
          name: 'id', fromJson: _intOrStringToString, toJson: _stringToDynamic)
      final String? id,
      @JsonKey(name: 'apaarId') final String? apaarId,
      @JsonKey(name: 'school') final String? school}) = _$StudentModelImpl;

  factory _StudentModel.fromJson(Map<String, dynamic> json) =
      _$StudentModelImpl.fromJson;

  @override
  @JsonKey(name: 'created_by', fromJson: _intOrStringToString)
  String? get createdBy;
  @override
  @JsonKey(name: 'name')
  String get name;
  @override
  @JsonKey(name: 'rollno')
  String get rollNo;
  @override
  @JsonKey(name: 'gender')
  String get gender;
  @override
  @JsonKey(name: 'class')
  String get classs;
  @override
  @JsonKey(name: 'id', fromJson: _intOrStringToString, toJson: _stringToDynamic)
  String? get id;
  @override
  @JsonKey(name: 'apaarId')
  String? get apaarId;
  @override
  @JsonKey(name: 'school')
  String? get school;

  /// Create a copy of StudentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StudentModelImplCopyWith<_$StudentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
