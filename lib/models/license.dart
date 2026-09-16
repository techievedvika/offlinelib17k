// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'license.freezed.dart';
part 'license.g.dart';

@freezed
class License with _$License {
  factory License({
    @JsonKey(name: 'license_key') String? licenseKey,
    @JsonKey(name: 'school') String? school,
    @JsonKey(name: 'school_udise') String? schoolUdise,
    @JsonKey(name: 'max_devices') int? maxDevices,
    @JsonKey(name: 'registered_devices') int? registeredDevices,
    @JsonKey(name: 'valid_from') String? validFrom,
    @JsonKey(name: 'valid_until') String? validUntil,
  }) = _License;

  factory License.fromJson(Map<String, dynamic> json) => _$LicenseFromJson(json);
}
