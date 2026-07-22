import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mestio/features/auth/data/repositories/auth_repository.dart';
import 'package:mestio/features/auth/presentation/cubit/login_cubit.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthRepository authRepository;

  setUp(() {
    authRepository = _MockAuthRepository();
  });

  group('LoginCubit', () {
    blocTest<LoginCubit, LoginState>(
      'emits loading and idle when login succeeds',
      setUp: () {
        when(
          () => authRepository.loginWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async {});
      },
      build: () => LoginCubit(authRepository),
      act: (cubit) =>
          cubit.login(email: ' user@example.com ', password: 'secret123'),
      expect: () => const [LoginState(isLoading: true), LoginState()],
      verify: (_) {
        verify(
          () => authRepository.loginWithEmail(
            email: 'user@example.com',
            password: 'secret123',
          ),
        ).called(1);
      },
    );

    blocTest<LoginCubit, LoginState>(
      'emits invalid credentials error when login fails',
      setUp: () {
        when(
          () => authRepository.loginWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(Exception('invalid login credentials'));
      },
      build: () => LoginCubit(authRepository),
      act: (cubit) =>
          cubit.login(email: 'user@example.com', password: 'wrong-password'),
      expect: () => const [
        LoginState(isLoading: true),
        LoginState(errorKey: 'invalid_credentials'),
      ],
    );

    blocTest<_CompletingLoginCubit, LoginState>(
      'ignores duplicate login while loading',
      setUp: () {},
      build: () {
        final completer = Completer<void>();
        when(
          () => authRepository.loginWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) => completer.future);

        return _CompletingLoginCubit(authRepository, completer);
      },
      act: (cubit) async {
        final firstLogin = cubit.login(
          email: 'user@example.com',
          password: 'secret123',
        );
        await cubit.login(email: 'other@example.com', password: 'secret123');
        cubit.completeLogin();
        await firstLogin;
      },
      expect: () => const [LoginState(isLoading: true), LoginState()],
      verify: (_) {
        verify(
          () => authRepository.loginWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).called(1);
      },
    );

    test('does not emit after close when login completes later', () async {
      final completer = Completer<void>();
      when(
        () => authRepository.loginWithEmail(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) => completer.future);

      final cubit = LoginCubit(authRepository);
      final login = cubit.login(
        email: 'user@example.com',
        password: 'secret123',
      );

      await pumpEventQueue();
      expect(cubit.state, const LoginState(isLoading: true));

      await cubit.close();
      completer.complete();

      await expectLater(login, completes);
    });
  });
}

class _CompletingLoginCubit extends LoginCubit {
  _CompletingLoginCubit(super.authRepository, this._completer);

  final Completer<void> _completer;

  void completeLogin() => _completer.complete();
}
