import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/config/revenuecat_config.dart';
import '../../../../features/auth/data/repositories/auth_repository.dart';
import '../../../../features/auth/models/auth_principal_model.dart';
import '../../../../features/profiles/data/repositories/shared_user_repository.dart';
import '../../../../features/profiles/models/shared_user_model.dart';
import '../../../../features/subscription/data/repositories/subscription_repository.dart';
import '../../models/session_status_model.dart';
import '../../models/user_session_model.dart';

// Keep this repository read-only. It aggregates the current session state
// and must not perform profile creation or any other write-side effects.
abstract class SessionRepository {
  Stream<SessionStatusModel> get sessionStream;

  SessionStatusModel get current;

  Future<void> refresh();

  void dispose();
}

@LazySingleton(as: SessionRepository)
class SessionRepositoryImpl implements SessionRepository {
  SessionRepositoryImpl(
    this._authRepository,
    this._sharedUserRepository,
    this._subscriptionRepository,
  ) {
    _startSessionStream();
  }

  final AuthRepository _authRepository;
  final SharedUserRepository _sharedUserRepository;
  final SubscriptionRepository _subscriptionRepository;

  final BehaviorSubject<SessionStatusModel> _controller =
      BehaviorSubject<SessionStatusModel>.seeded(
        const SessionStatusModel.loading(),
      );
  StreamSubscription<SessionStatusModel>? _sessionSubscription;
  Timer? _bootstrapRetryTimer;
  int _bootstrapRetryCount = 0;
  int _authenticatedExpiredJwtRetryCount = 0;
  String? _lastAuthenticatedUserId;

  @override
  Stream<SessionStatusModel> get sessionStream => _controller.stream;

  @override
  SessionStatusModel get current => _controller.value;

  @override
  Future<void> refresh() async {
    _bootstrapRetryCount = 0;
    _authenticatedExpiredJwtRetryCount = 0;
    _startSessionStream();

    final currentSession = current.sessionOrNull;
    final userId = currentSession?.userId;
    if (userId == null) return;

    try {
      final results = await Future.wait<Object?>([
        _sharedUserRepository.getSharedUser(userId),
        _subscriptionRepository.getIsPro(userId),
      ]);
      final sharedUser = results[0] as SharedUserModel?;
      final isPro = results[1] as bool;

      _controller.add(
        SessionStatusModel.authenticated(
          session: UserSessionModel(
            userId: currentSession!.userId,
            email: currentSession.email,
            isAnonymous: currentSession.isAnonymous,
            sharedUser: sharedUser,
            isPro: isPro,
          ),
        ),
      );
    } catch (error) {
      debugPrint('❌ [SessionRepository] refresh error: $error');
      rethrow;
    }
  }

  @override
  void dispose() {
    _bootstrapRetryTimer?.cancel();
    _sessionSubscription?.cancel();
    _controller.close();
  }

  Stream<SessionStatusModel> _buildSessionStream() {
    return _authRepository.watchPrincipal().distinct(_samePrincipal).switchMap((
      principal,
    ) {
      debugPrint(
        'ℹ️ [SessionRepository] principal received ${_describePrincipal(principal)}',
      );

      if (principal == null) {
        return Stream<SessionStatusModel>.value(
          const SessionStatusModel.unauthenticated(),
        );
      }

      // Sync RevenueCat identity before subscribing to entitlement streams.
      // Uses Stream.fromFuture + switchMap so the async logIn completes first,
      // then the combined streams start emitting.
      return Stream.fromFuture(
        _syncRevenueCatIdentity(principal.userId),
      ).switchMap((_) {
        debugPrint(
          'ℹ️ [SessionRepository] starting combined session streams '
          'userId=${principal.userId}',
        );
        return Rx.combineLatest2<SharedUserModel?, bool, SessionStatusModel>(
          _sharedUserRepository.watchSharedUser(principal.userId),
          _subscriptionRepository.watchIsPro(principal.userId),
          (sharedUser, isPro) {
            return SessionStatusModel.authenticated(
              session: UserSessionModel(
                userId: principal.userId,
                email: principal.email,
                isAnonymous: principal.isAnonymous,
                sharedUser: sharedUser,
                isPro: isPro,
              ),
            );
          },
        );
      });
    });
  }

  /// Calls [Purchases.logIn] to sync RevenueCat identity with Supabase user.id.
  /// Always uses the Supabase user.id — never RevenueCat anonymous IDs.
  /// Errors are logged but do not block the session stream.
  Future<void> _syncRevenueCatIdentity(String userId) async {
    if (!RevenueCatConfig.isEnabled) return;

    try {
      final result = await Purchases.logIn(userId);
      debugPrint(
        'ℹ️ [SessionRepository] RC logIn userId=$userId '
        'created=${result.created}',
      );
    } catch (error) {
      // Non-blocking — RC identity sync failure must not prevent session.
      debugPrint('❌ [SessionRepository] RC logIn error: $error');
    }
  }

  bool _samePrincipal(AuthPrincipalModel? previous, AuthPrincipalModel? next) {
    return previous?.userId == next?.userId &&
        previous?.email == next?.email &&
        previous?.isAnonymous == next?.isAnonymous;
  }

  void _startSessionStream() {
    debugPrint(
      'ℹ️ [SessionRepository] starting session stream '
      'current=${_describeStatus(current)}',
    );
    _bootstrapRetryTimer?.cancel();
    _sessionSubscription?.cancel();
    _sessionSubscription = _buildSessionStream().listen(
      (status) {
        debugPrint(
          'ℹ️ [SessionRepository] emitting status=${_describeStatus(status)}',
        );
        _trackStableStatus(status);
        _controller.add(status);
      },
      onError: (Object error, StackTrace stackTrace) {
        if (_shouldRetryBootstrapError(error)) {
          _scheduleBootstrapRetry(error);
          return;
        }

        debugPrint(
          '❌ [SessionRepository] stream error: $error '
          'current=${_describeStatus(current)}',
        );
        _controller.addError(error, stackTrace);
      },
    );
  }

  bool _shouldRetryBootstrapError(Object error) {
    final message = error.toString().toLowerCase();
    // Setup errors are persistent and should reach the UI immediately.
    // Retrying them would hide actionable configuration problems.
    if (_isPersistentSetupError(message)) {
      return false;
    }

    if (_controller.value.isLoading) {
      if (_bootstrapRetryCount >= 2) return false;

      // Supabase can emit transient auth/realtime errors while restoring an
      // expired persisted session. Retry only during bootstrap, before the
      // first stable session state reaches the app.
      return _isTransientBootstrapError(message);
    }

    // Realtime can subscribe with the persisted expired JWT milliseconds before
    // Supabase emits tokenRefreshed. If the session is already visible as
    // authenticated, restart once or twice with the fresh token instead of
    // surfacing a recoverable startup race to the user.
    return _isExpiredRealtimeJwtError(message) &&
        _authenticatedExpiredJwtRetryCount < 2;
  }

  void _scheduleBootstrapRetry(Object error) {
    final message = error.toString().toLowerCase();
    final isAuthenticatedExpiredJwtRetry =
        !_controller.value.isLoading && _isExpiredRealtimeJwtError(message);

    if (isAuthenticatedExpiredJwtRetry) {
      _authenticatedExpiredJwtRetryCount++;
    } else {
      _bootstrapRetryCount++;
    }

    final retryCount = isAuthenticatedExpiredJwtRetry
        ? _authenticatedExpiredJwtRetryCount
        : _bootstrapRetryCount;
    final delay = retryCount == 1
        ? const Duration(milliseconds: 500)
        : const Duration(milliseconds: 1500);

    debugPrint(
      '⚠️ [SessionRepository] transient session stream error; retry '
      '$retryCount/2 in ${delay.inMilliseconds}ms: $error',
    );

    _bootstrapRetryTimer?.cancel();
    _bootstrapRetryTimer = Timer(delay, () {
      if (_controller.isClosed) return;
      _startSessionStream();
    });
  }

  void _trackStableStatus(SessionStatusModel status) {
    switch (status) {
      case SessionStatusLoading():
        return;
      case SessionStatusUnauthenticated():
        _bootstrapRetryCount = 0;
        _authenticatedExpiredJwtRetryCount = 0;
        _lastAuthenticatedUserId = null;
      case SessionStatusAuthenticated(:final session):
        _bootstrapRetryCount = 0;
        if (_lastAuthenticatedUserId != session.userId) {
          _authenticatedExpiredJwtRetryCount = 0;
          _lastAuthenticatedUserId = session.userId;
        }
    }
  }

  bool _isPersistentSetupError(String message) {
    return message.contains('shared_users') ||
        message.contains('schema cache') ||
        message.contains('relation') ||
        message.contains('column');
  }

  bool _isTransientBootstrapError(String message) {
    return _isExpiredRealtimeJwtError(message) ||
        message.contains('access token is expired') ||
        message.contains('socketexception') ||
        message.contains('network') ||
        message.contains('timeout') ||
        message.contains('connection');
  }

  bool _isExpiredRealtimeJwtError(String message) {
    return message.contains('realtimesubscribeexception') &&
        (message.contains('invalidjwttoken') ||
            (message.contains('jwt') && message.contains('expired')));
  }

  String _describePrincipal(AuthPrincipalModel? principal) {
    if (principal == null) return 'none';

    return 'userId=${principal.userId} '
        'email=${principal.email ?? "-"} '
        'anonymous=${principal.isAnonymous}';
  }

  String _describeStatus(SessionStatusModel status) {
    return switch (status) {
      SessionStatusLoading() => 'loading',
      SessionStatusUnauthenticated() => 'unauthenticated',
      SessionStatusAuthenticated(:final session) =>
        'authenticated(userId=${session.userId}, '
            'anonymous=${session.isAnonymous}, '
            'isPro=${session.isPro})',
    };
  }
}
