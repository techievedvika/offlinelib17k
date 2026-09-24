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
      lotCode: json['lot_code'] as String?,
      lotName: json['lot_name'] as String?,
      lotStatus: (json['lot_status'] as num?)?.toInt(),
      allowImageUpload: (json['allow_image_upload'] as num?)?.toInt(),
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
      'lot_code': instance.lotCode,
      'lot_name': instance.lotName,
      'lot_status': instance.lotStatus,
      'allow_image_upload': instance.allowImageUpload,
    };
