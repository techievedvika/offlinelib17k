// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'license.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LicenseImpl _$$LicenseImplFromJson(Map<String, dynamic> json) =>
    _$LicenseImpl(
      licenseKey: json['license_key'] as String?,
      school: json['school'] as String?,
      schoolUdise: json['school_udise'] as String?,
      maxDevices: (json['max_devices'] as num?)?.toInt(),
      registeredDevices: (json['registered_devices'] as num?)?.toInt(),
      validFrom: json['valid_from'] as String?,
      validUntil: json['valid_until'] as String?,
    );

Map<String, dynamic> _$$LicenseImplToJson(_$LicenseImpl instance) =>
    <String, dynamic>{
      'license_key': instance.licenseKey,
      'school': instance.school,
      'school_udise': instance.schoolUdise,
      'max_devices': instance.maxDevices,
      'registered_devices': instance.registeredDevices,
      'valid_from': instance.validFrom,
      'valid_until': instance.validUntil,
    };
