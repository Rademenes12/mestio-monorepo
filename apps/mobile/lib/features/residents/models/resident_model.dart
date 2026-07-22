import 'package:freezed_annotation/freezed_annotation.dart';

part 'resident_model.freezed.dart';
part 'resident_model.g.dart';

@freezed
abstract class ResidentModel with _$ResidentModel {
  const factory ResidentModel({
    required String id,
    required String userId,
    String? buildingId,
    String? stairwellId,
    String? apartmentNumber,
    required String firstName,
    required String lastName,
    String? phone,
    required String email,
    DateTime? registeredAt,
    String? invitationCodeUsed,
    @Default(true) bool isActive,
    // Location labels coming from `fixflow_resident_profiles` (e.g.
    // "Budynek 1", "Klatka A", "Piętro 3"). Optional so existing fixtures
    // and the legacy `fixflow_residents` source stay compatible.
    String? building,
    String? footbridge,
    String? floor,
  }) = _ResidentModel;

  factory ResidentModel.fromJson(Map<String, dynamic> json) =>
      _$ResidentModelFromJson(json);
}