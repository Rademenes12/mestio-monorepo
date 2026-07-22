import 'package:freezed_annotation/freezed_annotation.dart';

part 'staff_member_model.freezed.dart';
part 'staff_member_model.g.dart';

@freezed
abstract class StaffMemberModel with _$StaffMemberModel {
  const factory StaffMemberModel({
    required String id,
    required String name,
    required String email,
    required String role,
  }) = _StaffMemberModel;

  factory StaffMemberModel.fromJson(Map<String, dynamic> json) =>
      _$StaffMemberModelFromJson(json);
}
