import 'package:freezed_annotation/freezed_annotation.dart';

part 'resident_profile_model.freezed.dart';
part 'resident_profile_model.g.dart';

@freezed
abstract class ResidentProfileModel with _$ResidentProfileModel {
  const ResidentProfileModel._();

  // All text fields default to '' because office roles (Zarzad/Administrator/
  // Serwisant/Ochrona) have NULL location columns in fixflow_resident_profiles
  // - they have no apartment. A strict `required String` made fromJson throw
  // "type 'Null' is not a subtype of type 'String'" for such rows.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ResidentProfileModel({
    @Default('') String name,
    @Default('') String email,
    @Default('') String phone,
    @Default('') String verificationCode,
    @Default('') String building,
    @Default('') String footbridge,
    @Default('') String floor,
    @Default('') String apartment,
    @Default(false) bool isVerified,
    @Default('Mieszkaniec') String role,
    @Default('') String companyName,
    // GDPR Article 7(1): persisted proof of consent, captured once in
    // lock_screen.dart (the screen every new user - guest or registered -
    // passes through before providing real PII).
    DateTime? termsAcceptedAt,
  }) = _ResidentProfileModel;

  factory ResidentProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ResidentProfileModelFromJson(json);

  factory ResidentProfileModel.empty() => const ResidentProfileModel(
        name: '',
        email: '',
        phone: '',
        verificationCode: '',
        building: '',
        footbridge: '',
        floor: '',
        apartment: '',
        isVerified: false,
        role: 'Mieszkaniec',
        companyName: '',
      );
}
