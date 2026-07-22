import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/error_messages.dart';
import '../../data/repositories/auth_repository.dart';

part 'forgot_password_cubit.freezed.dart';

@freezed
abstract class ForgotPasswordState with _$ForgotPasswordState {
  const factory ForgotPasswordState({
    @Default(false) bool isLoading,
    String? submittedEmail,
    String? errorKey,
    String? successKey,
  }) = _ForgotPasswordState;
}

@injectable
class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this._authRepository)
    : super(const ForgotPasswordState());

  final AuthRepository _authRepository;

  Future<void> sendCode({required String email}) async {
    if (state.isLoading) return;

    final normalizedEmail = email.trim();
    if (!_isValidEmail(normalizedEmail)) {
      emit(
        state.copyWith(
          submittedEmail: normalizedEmail,
          errorKey: 'email_error',
          successKey: null,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isLoading: true,
        submittedEmail: normalizedEmail,
        errorKey: null,
        successKey: null,
      ),
    );

    try {
      await _authRepository.sendPasswordResetCode(email: normalizedEmail);
      if (isClosed) return;

      emit(
        state.copyWith(
          isLoading: false,
          submittedEmail: normalizedEmail,
          successKey: 'password_reset_code_sent',
        ),
      );
    } catch (error) {
      debugPrint('❌ [ForgotPasswordCubit] sendCode error: $error');
      if (isClosed) return;

      emit(
        state.copyWith(
          isLoading: false,
          submittedEmail: normalizedEmail,
          errorKey: mapErrorToKey(error),
        ),
      );
    }
  }

  void clearFeedback() {
    if (state.errorKey == null && state.successKey == null) return;
    emit(state.copyWith(errorKey: null, successKey: null));
  }

  bool _isValidEmail(String value) {
    return value.isNotEmpty && value.contains('@');
  }
}
