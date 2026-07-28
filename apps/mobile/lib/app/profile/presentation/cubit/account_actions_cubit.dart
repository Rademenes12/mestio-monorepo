import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../features/auth/data/repositories/auth_repository.dart';
import '../../../../features/subscription/data/repositories/subscription_repository.dart';
import '../../../../shared/error_messages.dart';

part 'account_actions_cubit.freezed.dart';

enum AccountAction { signOut, deleteAccount, developerProOverride }

@freezed
sealed class AccountActionsEffect with _$AccountActionsEffect {
  const factory AccountActionsEffect() = _AccountActionsEffect;
}

@freezed
abstract class AccountActionsState with _$AccountActionsState {
  const factory AccountActionsState({
    AccountAction? activeAction,
    String? errorKey,
    String? successKey,
    AccountActionsEffect? effect,
  }) = _AccountActionsState;
}

@injectable
class AccountActionsCubit extends Cubit<AccountActionsState> {
  AccountActionsCubit(this._authRepository, this._subscriptionRepository)
    : super(const AccountActionsState());

  final AuthRepository _authRepository;
  final SubscriptionRepository _subscriptionRepository;

  Future<void> signOut() async {
    if (state.activeAction != null) return;

    emit(
      state.copyWith(
        activeAction: AccountAction.signOut,
        errorKey: null,
        successKey: null,
      ),
    );

    try {
      await _authRepository.signOut();
      if (isClosed) return;

      emit(state.copyWith(activeAction: null, successKey: 'signed_out'));
    } catch (error) {
      debugPrint('❌ [AccountActionsCubit] signOut error: $error');
      if (isClosed) return;

      emit(state.copyWith(activeAction: null, errorKey: mapErrorToKey(error)));
    }
  }

  Future<void> deleteAccount({String? email, String? password}) async {
    if (state.activeAction != null) return;

    emit(
      state.copyWith(
        activeAction: AccountAction.deleteAccount,
        errorKey: null,
        successKey: null,
      ),
    );

    try {
      if (email != null && password != null) {
        try {
          await _authRepository.loginWithEmail(
            email: email,
            password: password,
          );
        } catch (error) {
          debugPrint(
            '❌ [AccountActionsCubit] deleteAccount password verification failed: $error',
          );
          if (isClosed) return;
          emit(
            state.copyWith(
              activeAction: null,
              errorKey: mapErrorToKey(error),
            ),
          );
          return;
        }
      }

      await _authRepository.deleteAccount();
      await _authRepository.signOut();
      if (isClosed) return;

      emit(state.copyWith(activeAction: null, successKey: 'account_deleted'));
    } catch (error) {
      debugPrint('❌ [AccountActionsCubit] deleteAccount error: $error');
      if (isClosed) return;

      emit(state.copyWith(activeAction: null, errorKey: mapErrorToKey(error)));
    }
  }

  Future<void> setDeveloperProOverride({
    required String userId,
    required bool isPro,
  }) async {
    if (state.activeAction != null) return;

    emit(
      state.copyWith(
        activeAction: AccountAction.developerProOverride,
        errorKey: null,
        successKey: null,
      ),
    );

    try {
      await _subscriptionRepository.setDeveloperProOverride(
        userId: userId,
        isPro: isPro,
      );
      if (isClosed) return;

      emit(
        state.copyWith(
          activeAction: null,
          successKey: isPro ? 'pro_enabled' : 'pro_disabled',
        ),
      );
    } catch (error) {
      debugPrint(
        '❌ [AccountActionsCubit] setDeveloperProOverride error: $error',
      );
      if (isClosed) return;

      emit(state.copyWith(activeAction: null, errorKey: mapErrorToKey(error)));
    }
  }

  void clearFeedback() {
    if (state.errorKey == null &&
        state.successKey == null &&
        state.effect == null) {
      return;
    }
    emit(state.copyWith(errorKey: null, successKey: null, effect: null));
  }

  void clearEffect() {
    if (state.effect == null) return;
    emit(state.copyWith(effect: null));
  }
}
