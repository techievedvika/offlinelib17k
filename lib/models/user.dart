// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  factory User({
    @JsonKey(name: 'username') required String username,
    //@JsonKey(name: 'password') required String password,
    @JsonKey(name: 'state') required String state,
    @JsonKey(name: 'district') required String district,
    @JsonKey(name: 'location') required String location,
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'block') required String block,
    @JsonKey(name: 'school') required String school,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'role') required String role,
    @JsonKey(name: 'rights') required String rights,
    
   
   
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

 