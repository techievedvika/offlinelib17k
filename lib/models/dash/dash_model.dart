// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'dash_model.freezed.dart';
part 'dash_model.g.dart';

@freezed
class DashModel with _$DashModel {
  factory DashModel({
    @JsonKey(name: 'error') required bool error,
    @JsonKey(name: 'message') required String message,
    @JsonKey(name: 'students') required int students,
    @JsonKey(name: 'bookIssued') required int bookIssued,
    @JsonKey(name: 'pendingReturn') required int pendingReturn,
    @JsonKey(name: 'green') required int green,
    @JsonKey(name: 'red') required int red,
    @JsonKey(name: 'orange') required int orange,
    @JsonKey(name: 'white') required int white,
    @JsonKey(name: 'na') required int na,
    @JsonKey(name: 'barGraph') required List<dynamic> bargraph,

    
  }) = _DashModel;

  factory DashModel.fromJson(Map<String, dynamic> json) =>
      _$DashModelFromJson(json);
}
