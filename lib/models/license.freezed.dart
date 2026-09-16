// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'license.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

License _$LicenseFromJson(Map<String, dynamic> json) {
  return _License.fromJson(json);
}

/// @nodoc
mixin _$License {
  @JsonKey(name: 'license_key')
  String? get licenseKey => throw _privateConstructorUsedError;
  @JsonKey(name: 'school')
  String? get school => throw _privateConstructorUsedError;
  @JsonKey(name: 'school_udise')
  String? get schoolUdise => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_devices')
  int? get maxDevices => throw _privateConstructorUsedError;
  @JsonKey(name: 'registered_devices')
  int? get registeredDevices => throw _privateConstructorUsedError;
  @JsonKey(name: 'valid_from')
  String? get validFrom => throw _privateConstructorUsedError;
  @JsonKey(name: 'valid_until')
  String? get validUntil => throw _privateConstructorUsedError;

  /// Serializes this License to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of License
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LicenseCopyWith<License> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LicenseCopyWith<$Res> {
  factory $LicenseCopyWith(License value, $Res Function(License) then) =
      _$LicenseCopyWithImpl<$Res, License>;
  @useResult
  $Res call(
      {@JsonKey(name: 'license_key') String? licenseKey,
      @JsonKey(name: 'school') String? school,
      @JsonKey(name: 'school_udise') String? schoolUdise,
      @JsonKey(name: 'max_devices') int? maxDevices,
      @JsonKey(name: 'registered_devices') int? registeredDevices,
      @JsonKey(name: 'valid_from') String? validFrom,
      @JsonKey(name: 'valid_until') String? validUntil});
}

/// @nodoc
class _$LicenseCopyWithImpl<$Res, $Val extends License>
    implements $LicenseCopyWith<$Res> {
  _$LicenseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of License
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? licenseKey = freezed,
    Object? school = freezed,
    Object? schoolUdise = freezed,
    Object? maxDevices = freezed,
    Object? registeredDevices = freezed,
    Object? validFrom = freezed,
    Object? validUntil = freezed,
  }) {
    return _then(_value.copyWith(
      licenseKey: freezed == licenseKey
          ? _value.licenseKey
          : licenseKey // ignore: cast_nullable_to_non_nullable
              as String?,
      school: freezed == school
          ? _value.school
          : school // ignore: cast_nullable_to_non_nullable
              as String?,
      schoolUdise: freezed == schoolUdise
          ? _value.schoolUdise
          : schoolUdise // ignore: cast_nullable_to_non_nullable
              as String?,
      maxDevices: freezed == maxDevices
          ? _value.maxDevices
          : maxDevices // ignore: cast_nullable_to_non_nullable
              as int?,
      registeredDevices: freezed == registeredDevices
          ? _value.registeredDevices
          : registeredDevices // ignore: cast_nullable_to_non_nullable
              as int?,
      validFrom: freezed == validFrom
          ? _value.validFrom
          : validFrom // ignore: cast_nullable_to_non_nullable
              as String?,
      validUntil: freezed == validUntil
          ? _value.validUntil
          : validUntil // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LicenseImplCopyWith<$Res> implements $LicenseCopyWith<$Res> {
  factory _$$LicenseImplCopyWith(
          _$LicenseImpl value, $Res Function(_$LicenseImpl) then) =
      __$$LicenseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'license_key') String? licenseKey,
      @JsonKey(name: 'school') String? school,
      @JsonKey(name: 'school_udise') String? schoolUdise,
      @JsonKey(name: 'max_devices') int? maxDevices,
      @JsonKey(name: 'registered_devices') int? registeredDevices,
      @JsonKey(name: 'valid_from') String? validFrom,
      @JsonKey(name: 'valid_until') String? validUntil});
}

/// @nodoc
class __$$LicenseImplCopyWithImpl<$Res>
    extends _$LicenseCopyWithImpl<$Res, _$LicenseImpl>
    implements _$$LicenseImplCopyWith<$Res> {
  __$$LicenseImplCopyWithImpl(
      _$LicenseImpl _value, $Res Function(_$LicenseImpl) _then)
      : super(_value, _then);

  /// Create a copy of License
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? licenseKey = freezed,
    Object? school = freezed,
    Object? schoolUdise = freezed,
    Object? maxDevices = freezed,
    Object? registeredDevices = freezed,
    Object? validFrom = freezed,
    Object? validUntil = freezed,
  }) {
    return _then(_$LicenseImpl(
      licenseKey: freezed == licenseKey
          ? _value.licenseKey
          : licenseKey // ignore: cast_nullable_to_non_nullable
              as String?,
      school: freezed == school
          ? _value.school
          : school // ignore: cast_nullable_to_non_nullable
              as String?,
      schoolUdise: freezed == schoolUdise
          ? _value.schoolUdise
          : schoolUdise // ignore: cast_nullable_to_non_nullable
              as String?,
      maxDevices: freezed == maxDevices
          ? _value.maxDevices
          : maxDevices // ignore: cast_nullable_to_non_nullable
              as int?,
      registeredDevices: freezed == registeredDevices
          ? _value.registeredDevices
          : registeredDevices // ignore: cast_nullable_to_non_nullable
              as int?,
      validFrom: freezed == validFrom
          ? _value.validFrom
          : validFrom // ignore: cast_nullable_to_non_nullable
              as String?,
      validUntil: freezed == validUntil
          ? _value.validUntil
          : validUntil // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LicenseImpl implements _License {
  _$LicenseImpl(
      {@JsonKey(name: 'license_key') this.licenseKey,
      @JsonKey(name: 'school') this.school,
      @JsonKey(name: 'school_udise') this.schoolUdise,
      @JsonKey(name: 'max_devices') this.maxDevices,
      @JsonKey(name: 'registered_devices') this.registeredDevices,
      @JsonKey(name: 'valid_from') this.validFrom,
      @JsonKey(name: 'valid_until') this.validUntil});

  factory _$LicenseImpl.fromJson(Map<String, dynamic> json) =>
      _$$LicenseImplFromJson(json);

  @override
  @JsonKey(name: 'license_key')
  final String? licenseKey;
  @override
  @JsonKey(name: 'school')
  final String? school;
  @override
  @JsonKey(name: 'school_udise')
  final String? schoolUdise;
  @override
  @JsonKey(name: 'max_devices')
  final int? maxDevices;
  @override
  @JsonKey(name: 'registered_devices')
  final int? registeredDevices;
  @override
  @JsonKey(name: 'valid_from')
  final String? validFrom;
  @override
  @JsonKey(name: 'valid_until')
  final String? validUntil;

  @override
  String toString() {
    return 'License(licenseKey: $licenseKey, school: $school, schoolUdise: $schoolUdise, maxDevices: $maxDevices, registeredDevices: $registeredDevices, validFrom: $validFrom, validUntil: $validUntil)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LicenseImpl &&
            (identical(other.licenseKey, licenseKey) ||
                other.licenseKey == licenseKey) &&
            (identical(other.school, school) || other.school == school) &&
            (identical(other.schoolUdise, schoolUdise) ||
                other.schoolUdise == schoolUdise) &&
            (identical(other.maxDevices, maxDevices) ||
                other.maxDevices == maxDevices) &&
            (identical(other.registeredDevices, registeredDevices) ||
                other.registeredDevices == registeredDevices) &&
            (identical(other.validFrom, validFrom) ||
                other.validFrom == validFrom) &&
            (identical(other.validUntil, validUntil) ||
                other.validUntil == validUntil));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, licenseKey, school, schoolUdise,
      maxDevices, registeredDevices, validFrom, validUntil);

  /// Create a copy of License
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LicenseImplCopyWith<_$LicenseImpl> get copyWith =>
      __$$LicenseImplCopyWithImpl<_$LicenseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LicenseImplToJson(
      this,
    );
  }
}

abstract class _License implements License {
  factory _License(
      {@JsonKey(name: 'license_key') final String? licenseKey,
      @JsonKey(name: 'school') final String? school,
      @JsonKey(name: 'school_udise') final String? schoolUdise,
      @JsonKey(name: 'max_devices') final int? maxDevices,
      @JsonKey(name: 'registered_devices') final int? registeredDevices,
      @JsonKey(name: 'valid_from') final String? validFrom,
      @JsonKey(name: 'valid_until') final String? validUntil}) = _$LicenseImpl;

  factory _License.fromJson(Map<String, dynamic> json) = _$LicenseImpl.fromJson;

  @override
  @JsonKey(name: 'license_key')
  String? get licenseKey;
  @override
  @JsonKey(name: 'school')
  String? get school;
  @override
  @JsonKey(name: 'school_udise')
  String? get schoolUdise;
  @override
  @JsonKey(name: 'max_devices')
  int? get maxDevices;
  @override
  @JsonKey(name: 'registered_devices')
  int? get registeredDevices;
  @override
  @JsonKey(name: 'valid_from')
  String? get validFrom;
  @override
  @JsonKey(name: 'valid_until')
  String? get validUntil;

  /// Create a copy of License
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LicenseImplCopyWith<_$LicenseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
