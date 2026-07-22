import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/error_messages.dart';
import '../../data/repositories/auth_repository.dart';

part 'register_cubit.freezed.dart';

@freezed
abstract class RegisterState with _$RegisterState {
  const factory RegisterState({
    @Default(false) bool isLoading,
    String? errorKey,
  }) = _RegisterState;
}

@injectable
class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._authRepository) : super(const RegisterState());

  final AuthRepository _authRepository;

  Future<void> register({
    required String email,
    required String password,
  }) async {
    if (state.isLoading) return;

    emit(state.copyWith(isLoading: true, errorKey: null));

    try {
      final principal = _authRepository.currentPrincipal;
      final isGuest = principal?.isAnonymous ?? false;
      if (isGuest) {
        await _authRepository.upgradeAnonymousWithEmail(
          email: email.trim(),
          password: password,
        );
      } else {
        try {
          await _authRepository.signUpWithEmail(
            email: email.trim(),
            password: password,
          );
        } on Exception catch (signUpError) {
          // The synchronous isAnonymous check may have returned false even
          // though a live session exists (e.g. currentPrincipal was briefly
          // null). When signUp fails with user_already_exists, retry as a
          // guest-upgrade instead of showing a confusing error.
          if (principal != null &&
              _looksLikeUserAlreadyExists(signUpError)) {
            debugPrint(
              'ℹ️ [RegisterCubit] signUp failed with user_already_exists, '
              'retrying as guest upgrade',
            );
            await _authRepository.upgradeAnonymousWithEmail(
              email: email.trim(),
              password: password,
            );
          } else {
            rethrow;
          }
        }
      }
      if (isClosed) return;

      emit(state.copyWith(isLoading: false));
    } catch (error) {
      debugPrint('❌ [RegisterCubit] register error: $error');
      if (isClosed) return;

      emit(state.copyWith(isLoading: false, errorKey: mapErrorToKey(error)));
    }
  }

  bool _looksLikeUserAlreadyExists(Object error) =>
      error.toString().contains('user_already_exists');
}
