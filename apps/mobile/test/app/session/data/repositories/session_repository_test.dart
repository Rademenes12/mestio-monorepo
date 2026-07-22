import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mestio/app/session/data/repositories/session_repository.dart';
import 'package:mestio/app/session/models/session_status_model.dart';
import 'package:mestio/features/auth/data/repositories/auth_repository.dart';
import 'package:mestio/features/auth/models/auth_principal_model.dart';
import 'package:mestio/features/profiles/data/repositories/shared_user_repository.dart';
import 'package:mestio/features/profiles/models/shared_user_model.dart';
import 'package:mestio/features/subscription/data/repositories/subscription_repository.dart';

void main() {
  group('SessionRepository', () {
    test(
      'retries expired Realtime JWT after authenticated state without error',
      () async {
        final authRepository = _FakeAuthRepository(
          principal: const AuthPrincipalModel(
            userId: 'user-1',
            email: null,
            isAnonymous: true,
          ),
        );
        final sharedUserRepository = _FakeSharedUserRepository();
        final subscriptionRepository = _FakeSubscriptionRepository();
        final repository = SessionRepositoryImpl(
          authRepository,
          sharedUserRepository,
          subscriptionRepository,
        );
        final errors = <Object>[];
        final subscription = repository.sessionStream.listen(
          (_) {},
          onError: errors.add,
        );

        await pumpEventQueue();

        expect(sharedUserRepository.watchCount, 1);

        sharedUserRepository.emitLatest(const SharedUserModel(id: 'user-1'));
        await pumpEventQueue();

        expect(repository.current.sessionOrNull?.userId, 'user-1');

        sharedUserRepository.errorLatest(
          Exception(
            'RealtimeSubscribeException(status: '
            'RealtimeSubscribeStatus.channelError, details: Exception: '
            '"InvalidJWTToken: Token has expired 6048 seconds ago")',
          ),
        );

        await Future<void>.delayed(const Duration(milliseconds: 550));

        expect(errors, isEmpty);
        expect(sharedUserRepository.watchCount, 2);

        await subscription.cancel();
        repository.dispose();
        authRepository.dispose();
        sharedUserRepository.dispose();
      },
    );
  });
}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({required AuthPrincipalModel? principal})
    : _principal = principal;

  final _controller = StreamController<AuthPrincipalModel?>.broadcast();
  final AuthPrincipalModel? _principal;

  @override
  AuthPrincipalModel? get currentPrincipal => _principal;

  @override
  Stream<AuthPrincipalModel?> watchPrincipal() async* {
    yield _principal;
    yield* _controller.stream;
  }

  void dispose() {
    _controller.close();
  }

  @override
  Future<void> clearPendingPasswordRecovery() => throw UnimplementedError();

  @override
  Future<void> continueAsGuest() => throw UnimplementedError();

  @override
  Future<void> deleteAccount() => throw UnimplementedError();

  @override
  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) => throw UnimplementedError();

  @override
  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) => throw UnimplementedError();

  @override
  Future<void> resetPasswordWithOtp({
    required String email,
    required String code,
    required String newPassword,
  }) => throw UnimplementedError();

  @override
  Future<void> sendPasswordResetCode({required String email}) =>
      throw UnimplementedError();

  @override
  Future<void> signOut() => throw UnimplementedError();

  @override
  Future<void> upgradeAnonymousWithEmail({
    required String email,
    required String password,
  }) => throw UnimplementedError();
}

class _FakeSharedUserRepository implements SharedUserRepository {
  final _controllers = <StreamController<SharedUserModel?>>[];
  var watchCount = 0;

  @override
  Stream<SharedUserModel?> watchSharedUser(String userId) {
    watchCount++;
    final controller = StreamController<SharedUserModel?>.broadcast();
    _controllers.add(controller);
    return controller.stream;
  }

  void emitLatest(SharedUserModel sharedUser) {
    _controllers.last.add(sharedUser);
  }

  void errorLatest(Object error) {
    _controllers.last.addError(error, StackTrace.current);
  }

  void dispose() {
    for (final controller in _controllers) {
      controller.close();
    }
  }

  @override
  Future<SharedUserModel> ensureSharedUser(String userId) =>
      throw UnimplementedError();

  @override
  Future<SharedUserModel?> getSharedUser(String userId) =>
      throw UnimplementedError();

  @override
  Future<void> updateFirstName({
    required String userId,
    required String firstName,
  }) => throw UnimplementedError();
}

class _FakeSubscriptionRepository implements SubscriptionRepository {
  @override
  Stream<bool> watchIsPro(String userId) => Stream<bool>.value(false);

  @override
  Future<bool> getIsPro(String userId) async => false;

  @override
  Future<void> setDeveloperProOverride({
    required String userId,
    required bool isPro,
  }) => throw UnimplementedError();
}
