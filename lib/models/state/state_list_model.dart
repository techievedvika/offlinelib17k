// state_list_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state_list_model.freezed.dart';
part 'state_list_model.g.dart';

@freezed
class StateListModel with _$StateListModel {
  factory StateListModel({
    required List<String> states,
  }) = _StateListModel;

  factory StateListModel.fromJson(List<dynamic> json) =>
      StateListModel(states: List<String>.from(json));
}
