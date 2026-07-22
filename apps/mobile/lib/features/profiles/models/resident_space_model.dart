import 'package:freezed_annotation/freezed_annotation.dart';

part 'resident_space_model.freezed.dart';
part 'resident_space_model.g.dart';

@freezed
abstract class ResidentSpaceModel with _$ResidentSpaceModel {
  const ResidentSpaceModel._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ResidentSpaceModel({
    required String id,
    required String userId,
    required String estateId,
    required String type,
    required String label,
    @Default('resident') String createdBy,
    DateTime? createdAt,
  }) = _ResidentSpaceModel;

  factory ResidentSpaceModel.fromJson(Map<String, dynamic> json) =>
      _$ResidentSpaceModelFromJson(json);
}
