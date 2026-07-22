import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_principal_model.freezed.dart';

@freezed
abstract class AuthPrincipalModel with _$AuthPrincipalModel {
  const AuthPrincipalModel._();

  const factory AuthPrincipalModel({
    required String userId,
    required String? email,
    required bool isAnonymous,
  }) = _AuthPrincipalModel;
}
