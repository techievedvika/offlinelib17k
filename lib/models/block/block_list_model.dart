// state_list_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'block_list_model.freezed.dart';
part 'block_list_model.g.dart';

@freezed
class BlockListModel with _$BlockListModel {
  factory BlockListModel({
    required List<String> blocks,
  }) = _BlockListModel;

  factory BlockListModel.fromJson(List<dynamic> json) =>
      BlockListModel(blocks: List<String>.from(json));
}
