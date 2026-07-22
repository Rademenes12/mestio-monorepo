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
  const factory AccountActionsEffect.openPaywall() =
      AccountActionsEffectOpenPaywall;
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
      // Signing out changes the global session and may remove this route via
      // SessionNavigationObserver before the await completes.
      if (isClosed) return;

      emit(state.copyWith(activeAction: null, successKey: 'signed_out'));
    } catch (error) {
      debugPrint('❌ [AccountActionsCubit] signOut error: $error');
      if (isClosed) return;

      emit(state.copyWith(activeAction: null, errorKey: mapErrorToKey(error)));
    }
  }

  /// Deletes the current account. For non-anonymous accounts, [email] and
  /// [password] must be provided so the password can be re-verified first -
  /// an unlocked/unattended phone with a live session must not be enough to
  /// permanently destroy an account. Anonymous guests have no password to
  /// check, so this step is skipped for them (caller passes null/null).
  ///
  /// This re-verifies via a normal signInWithPassword call (same as
  /// AuthRepository.loginWithEmail), NOT Supabase's reauthenticate()/OTP
  /// flow - that flow is deliberately avoided elsewhere in this cubit
  /// because it fails for some valid emails (see delete-account comment
  /// below); a plain password sign-in has no such issue.
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

      // Identity is verified by the `delete-account` Edge Function via the
      // JWT token in the Authorization header. Supabase OTP-based reauth is
      // not used here — it breaks for emails that pass Supabase sign-in but
      // fail their reauthenticate validator (e.g. short-domain addresses).
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

  void requestProPurchase() {
    emit(
      state.copyWith(
        errorKey: null,
        successKey: null,
        effect: const AccountActionsEffect.openPaywall(),
      ),
    );
  }

  void setPaywallError(String errorKey) {
    emit(state.copyWith(errorKey: errorKey, effect: null));
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
