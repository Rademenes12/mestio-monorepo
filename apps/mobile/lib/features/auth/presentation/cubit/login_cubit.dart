import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/error_messages.dart';
import '../../data/repositories/auth_repository.dart';

part 'login_cubit.freezed.dart';

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState({@Default(false) bool isLoading, String? errorKey}) =
      _LoginState;
}

@injectable
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authRepository) : super(const LoginState());

  final AuthRepository _authRepository;

  Future<void> login({required String email, required String password}) async {
    if (state.isLoading) return;

    emit(state.copyWith(isLoading: true, errorKey: null));

    try {
      await _authRepository.loginWithEmail(
        email: email.trim(),
        password: password,
      );
      if (isClosed) return;

      emit(state.copyWith(isLoading: false));
    } catch (error) {
      debugPrint('❌ [LoginCubit] login error: $error');
      if (isClosed) return;

      emit(state.copyWith(isLoading: false, errorKey: mapErrorToKey(error)));
    }
  }
}
