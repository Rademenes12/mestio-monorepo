import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/error_messages.dart';
import '../../data/repositories/auth_repository.dart';

part 'reset_password_cubit.freezed.dart';

@freezed
abstract class ResetPasswordState with _$ResetPasswordState {
  const factory ResetPasswordState({
    @Default(false) bool isLoading,
    String? errorKey,
    String? successKey,
  }) = _ResetPasswordState;
}

@injectable
class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit(this._authRepository) : super(const ResetPasswordState());

  final AuthRepository _authRepository;

  @override
  Future<void> close() async {
    if (isClosed) return;

    if (!state.isLoading && state.successKey != 'password_reset_completed') {
      await _authRepository.clearPendingPasswordRecovery();
    }

    return super.close();
  }

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (state.isLoading) return;

    final normalizedEmail = email.trim();
    final normalizedCode = code.trim();

    final validationError = _validateInput(
      email: normalizedEmail,
      code: normalizedCode,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
    if (validationError != null) {
      emit(state.copyWith(errorKey: validationError, successKey: null));
      return;
    }

    emit(state.copyWith(isLoading: true, errorKey: null, successKey: null));

    try {
      await _authRepository.resetPasswordWithOtp(
        email: normalizedEmail,
        code: normalizedCode,
        newPassword: newPassword,
      );
      if (isClosed) return;

      emit(
        state.copyWith(
          isLoading: false,
          successKey: 'password_reset_completed',
        ),
      );
    } catch (error) {
      debugPrint('❌ [ResetPasswordCubit] resetPassword error: $error');
      if (isClosed) return;

      emit(state.copyWith(isLoading: false, errorKey: mapErrorToKey(error)));
    }
  }

  void clearFeedback() {
    if (state.errorKey == null && state.successKey == null) return;
    emit(state.copyWith(errorKey: null, successKey: null));
  }

  String? _validateInput({
    required String email,
    required String code,
    required String newPassword,
    required String confirmPassword,
  }) {
    if (email.isEmpty || !email.contains('@')) {
      return 'email_error';
    }

    if (code.isEmpty) {
      return 'password_reset_code_required';
    }

    if (newPassword.length < 6) {
      return 'password_too_short';
    }

    if (newPassword != confirmPassword) {
      return 'passwords_do_not_match';
    }

    return null;
  }
}
