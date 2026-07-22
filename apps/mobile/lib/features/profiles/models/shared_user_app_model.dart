import 'package:freezed_annotation/freezed_annotation.dart';

part 'shared_user_app_model.freezed.dart';
part 'shared_user_app_model.g.dart';

@freezed
abstract class SharedUserAppModel with _$SharedUserAppModel {
  const SharedUserAppModel._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory SharedUserAppModel({
    required String appId,
    required String appName,
    required DateTime lastSeenAt,
  }) = _SharedUserAppModel;

  factory SharedUserAppModel.fromJson(Map<String, dynamic> json) =>
      _$SharedUserAppModelFromJson(json);
}
