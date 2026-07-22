import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../reports/services/fcm_service.dart';

abstract class AuthDataSource {
  Stream<Map<String, dynamic>?> watchPrincipal();

  Map<String, dynamic>? get currentPrincipal;

  Future<void> sendPasswordResetCode({required String email});

  Future<void> clearPendingPasswordRecovery();

  Future<void> resetPasswordWithOtp({
    required String email,
    required String code,
    required String newPassword,
  });

  Future<void> signInAnonymously();

  Future<void> signInWithEmail({
    required String email,
    required String password,
  });

  Future<void> signUpWithEmail({
    required String email,
    required String password,
  });

  Future<void> upgradeAnonymousWithEmail({
    required String email,
    required String password,
  });

  Future<void> deleteAccount();

  Future<void> signOut();


}

@LazySingleton(as: AuthDataSource)
class SupabaseAuthDataSource implements AuthDataSource {
  SupabaseAuthDataSource(this._supabaseClient, this._fcmService);

  final SupabaseClient _supabaseClient;
  final FcmService _fcmService;
  final PublishSubject<Map<String, dynamic>?> _manualPrincipalEvents =
      PublishSubject<Map<String, dynamic>?>();
  bool _suspendAuthStateEvents = false;
  bool _hasPendingPasswordRecovery = false;

  @override
  Stream<Map<String, dynamic>?> watchPrincipal() {
    final initialSession = _supabaseClient.auth.currentSession;
    final initialPrincipal = _mapUser(_supabaseClient.auth.currentUser);
    debugPrint(
      'ℹ️ [AuthDataSource] watchPrincipal subscribed '
      'initial=${_describeAuthSnapshot(initialPrincipal, initialSession)}',
    );

    return Rx.merge<Map<String, dynamic>?>([
      _supabaseClient.auth.onAuthStateChange
          .where((_) => !_suspendAuthStateEvents)
          .map((authState) {
            final principal = _mapUser(authState.session?.user);
            debugPrint(
              'ℹ️ [AuthDataSource] auth event=${authState.event} '
              'principal=${_describeAuthSnapshot(principal, authState.session)}',
            );
            return principal;
          }),
      _manualPrincipalEvents,
    ]).startWith(initialPrincipal);
  }

  @override
  Map<String, dynamic>? get currentPrincipal =>
      _mapUser(_supabaseClient.auth.currentUser);

  @override
  Future<void> sendPasswordResetCode({required String email}) async {
    debugPrint(
      'ℹ️ [AuthDataSource] sendPasswordResetCode started email=$email',
    );
    await _supabaseClient.auth.resetPasswordForEmail(email);
    debugPrint(
      '✅ [AuthDataSource] sendPasswordResetCode succeeded email=$email',
    );
  }

  @override
  Future<void> clearPendingPasswordRecovery() async {
    if (!_hasPendingPasswordRecovery) return;

    debugPrint('ℹ️ [AuthDataSource] clearPendingPasswordRecovery started');

    try {
      await _supabaseClient.auth.signOut();
      debugPrint('✅ [AuthDataSource] clearPendingPasswordRecovery succeeded');
    } finally {
      _hasPendingPasswordRecovery = false;
    }
  }

  @override
  Future<void> resetPasswordWithOtp({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    debugPrint('ℹ️ [AuthDataSource] resetPasswordWithOtp started email=$email');
    _suspendAuthStateEvents = true;
    var shouldEmitPrincipal = false;

    try {
      if (!_hasPendingPasswordRecovery ||
          _supabaseClient.auth.currentSession == null) {
        final response = await _supabaseClient.auth.verifyOTP(
          email: email,
          token: code,
          type: OtpType.recovery,
        );

        if (response.session == null &&
            _supabaseClient.auth.currentSession == null) {
          throw StateError('password_reset_session_missing');
        }

        _hasPendingPasswordRecovery = true;
      }

      await _supabaseClient.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      _hasPendingPasswordRecovery = false;
      shouldEmitPrincipal = true;
      debugPrint(
        '✅ [AuthDataSource] resetPasswordWithOtp succeeded email=$email',
      );
    } finally {
      _suspendAuthStateEvents = false;

      if (shouldEmitPrincipal) {
        Future<void>.microtask(() {
          _manualPrincipalEvents.add(
            _mapUser(_supabaseClient.auth.currentUser),
          );
        });
      }
    }
  }

  @override
  Future<void> signInAnonymously() async {
    debugPrint('ℹ️ [AuthDataSource] signInAnonymously started');
    await _supabaseClient.auth.signInAnonymously();
    debugPrint('✅ [AuthDataSource] signInAnonymously succeeded');
  }

  @override
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    debugPrint('ℹ️ [AuthDataSource] signInWithEmail started email=$email');
    await _supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
    debugPrint('✅ [AuthDataSource] signInWithEmail succeeded email=$email');
  }

  @override
  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    debugPrint('ℹ️ [AuthDataSource] signUpWithEmail started email=$email');
    await _supabaseClient.auth.signUp(
      email: email,
      password: password,
    );
    debugPrint('✅ [AuthDataSource] signUpWithEmail succeeded email=$email');
  }

  @override
  Future<void> upgradeAnonymousWithEmail({
    required String email,
    required String password,
  }) async {
    debugPrint(
      'ℹ️ [AuthDataSource] upgradeAnonymousWithEmail started email=$email',
    );
    await _supabaseClient.auth.updateUser(
      UserAttributes(email: email, password: password),
    );
    // onAuthStateChange may not fire synchronously — manually emit the updated
    // principal so downstream consumers (SessionCubit → HomeScreen → LockScreen)
    // immediately see the new email.
    _manualPrincipalEvents.add(_mapUser(_supabaseClient.auth.currentUser));
    debugPrint(
      '✅ [AuthDataSource] upgradeAnonymousWithEmail succeeded email=$email',
    );
  }

  @override
  Future<void> deleteAccount() async {
    debugPrint('ℹ️ [AuthDataSource] deleteAccount started');

    // Unsubscribe from all FCM topics before cleanup so no push
    // notifications are delivered after account data is wiped.
    await _fcmService.clearSubscriptions();

    try {
      // First, clean up FixFlow-specific data
      try {
        final cleanupResponse = await _supabaseClient.functions.invoke('fixflow-cleanup');
        debugPrint(
          '✅ [AuthDataSource] fixflow-cleanup succeeded status=${cleanupResponse.status}',
        );
      } on FunctionException catch (cleanupError) {
        debugPrint('⚠️ [AuthDataSource] fixflow-cleanup failed: $cleanupError');
        // 404 means the function is not deployed — continue anyway.
        // Any other error means data cleanup was incomplete; abort to avoid
        // leaving orphaned user data after the auth account is deleted.
        if (cleanupError.status == 404) {
          debugPrint('⚠️ [AuthDataSource] fixflow-cleanup not deployed, continuing');
        } else {
          debugPrint('⛔ [AuthDataSource] Aborting deleteAccount due to cleanup failure');
          throw StateError('delete_account_failed');
        }
      }

      // Then delete the auth account. This requires the Supabase Edge Function
      // `delete-account` because the client SDK cannot delete its own user
      // without a service_role key (admin API is not available to mobile apps).
      try {
        final response = await _supabaseClient.functions.invoke('delete-account');
        debugPrint(
          '✅ [AuthDataSource] delete-account succeeded status=${response.status}',
        );
      } on FunctionException catch (error) {
        debugPrint('⚠️ [AuthDataSource] delete-account function failed: $error');

        if (error.status == 404) {
          // Edge Function is not deployed. Tell the user instead of silently
          // failing or trying the impossible client-side admin.deleteUser.
          throw StateError('delete_account_setup_required');
        }

        if (error.details is Map &&
            (error.details as Map)['error'] == 'delete_account_failed') {
          throw StateError('delete_account_failed');
        }

        throw StateError('delete_account_failed');
      }
    } catch (error) {
      debugPrint('❌ [AuthDataSource] deleteAccount unexpected error: $error');
      // Check if it's a network error
      if (error.toString().contains('SocketException') || 
          error.toString().contains('Network') ||
          error.toString().contains('connection')) {
        throw StateError('network_error');
      }
      throw StateError('delete_account_failed');
    }
  }



  @override
  Future<void> signOut() async {
    debugPrint('ℹ️ [AuthDataSource] signOut started');
    try {
      await _supabaseClient.auth.signOut();
      debugPrint('✅ [AuthDataSource] signOut succeeded');
    } catch (error) {
      // Network/auth-endpoint failures must not leave the user "stuck logged in".
      // Fall back to a local-only sign out so the session is cleared on device.
      // Surfaced bug: AuthRetryableFetchException (Connection refused) during
      // logout was bubbling up as an unhandled Future and crashing the UI
      // with a red error overlay (sesja 2 logs).
      debugPrint(
        '⚠️ [AuthDataSource] signOut remote failed, falling back to local: $error',
      );
      await _supabaseClient.auth.signOut(scope: SignOutScope.local);
      debugPrint('✅ [AuthDataSource] signOut (local) succeeded');
    }
  }

  Map<String, dynamic>? _mapUser(User? user) {
    if (user == null) return null;

    return {
      'user_id': user.id,
      'email': user.email,
      'is_anonymous': user.isAnonymous,
    };
  }

  String _describeRawPrincipal(Map<String, dynamic>? rawPrincipal) {
    if (rawPrincipal == null) return 'none';

    return 'userId=${rawPrincipal['user_id']} email=${rawPrincipal['email'] ?? "-"} anonymous=${rawPrincipal['is_anonymous'] ?? false}';
  }

  String _describeAuthSnapshot(
    Map<String, dynamic>? rawPrincipal,
    Session? session,
  ) {
    final expiresAt = session?.expiresAt;
    final expiresAtDateTime = expiresAt == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(expiresAt * 1000);
    final secondsUntilExpiry = expiresAtDateTime?.difference(DateTime.now());
    final token = session?.accessToken;
    final tokenTail = token == null || token.isEmpty
        ? '-'
        : token.substring(token.length > 8 ? token.length - 8 : 0);

    return '${_describeRawPrincipal(rawPrincipal)} '
        'expiresAt=${expiresAtDateTime?.toIso8601String() ?? "-"} '
        'secondsUntilExpiry=${secondsUntilExpiry?.inSeconds ?? "-"} '
        'isExpired=${session?.isExpired ?? false} '
        'tokenTail=$tokenTail';
  }

}
