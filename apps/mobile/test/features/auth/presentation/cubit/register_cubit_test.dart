import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mestio/features/auth/data/repositories/auth_repository.dart';
import 'package:mestio/features/auth/models/auth_principal_model.dart';
import 'package:mestio/features/auth/presentation/cubit/register_cubit.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthRepository authRepository;

  setUp(() {
    authRepository = _MockAuthRepository();
  });

  group('RegisterCubit', () {
    blocTest<RegisterCubit, RegisterState>(
      'emits loading and idle when registration succeeds',
      setUp: () {
        when(
          () => authRepository.signUpWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async {});
      },
      build: () => RegisterCubit(authRepository),
      act: (cubit) =>
          cubit.register(email: ' user@example.com ', password: 'secret123'),
      expect: () => const [RegisterState(isLoading: true), RegisterState()],
      verify: (_) {
        verify(
          () => authRepository.signUpWithEmail(
            email: 'user@example.com',
            password: 'secret123',
          ),
        ).called(1);
      },
    );

    blocTest<RegisterCubit, RegisterState>(
      'emits error when registration fails',
      setUp: () {
        when(
          () => authRepository.signUpWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(Exception('password is too weak'));
      },
      build: () => RegisterCubit(authRepository),
      act: (cubit) =>
          cubit.register(email: 'user@example.com', password: '123'),
      expect: () => const [
        RegisterState(isLoading: true),
        RegisterState(errorKey: 'password_too_short'),
      ],
    );

    blocTest<RegisterCubit, RegisterState>(
      'calls upgradeAnonymousWithEmail when user is a guest',
      setUp: () {
        when(() => authRepository.currentPrincipal)
            .thenReturn(const AuthPrincipalModel(
          userId: 'u1',
          email: null,
          isAnonymous: true,
        ));
        when(
          () => authRepository.upgradeAnonymousWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async {});
      },
      build: () => RegisterCubit(authRepository),
      act: (cubit) =>
          cubit.register(email: 'guest@example.com', password: 'secret123'),
      expect: () => const [RegisterState(isLoading: true), RegisterState()],
      verify: (_) {
        verify(
          () => authRepository.upgradeAnonymousWithEmail(
            email: 'guest@example.com',
            password: 'secret123',
          ),
        ).called(1);
        verifyNever(
          () => authRepository.signUpWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        );
      },
    );

    blocTest<RegisterCubit, RegisterState>(
      'falls back to upgradeAnonymousWithEmail when signUp fails with '
      'user_already_exists and a session exists',
      setUp: () {
        when(() => authRepository.currentPrincipal)
            .thenReturn(const AuthPrincipalModel(
          userId: 'u1',
          email: null,
          isAnonymous: false,
        ));
        when(
          () => authRepository.signUpWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(Exception('user_already_exists'));
        when(
          () => authRepository.upgradeAnonymousWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async {});
      },
      build: () => RegisterCubit(authRepository),
      act: (cubit) =>
          cubit.register(email: 'existing@example.com', password: 'secret123'),
      expect: () => const [RegisterState(isLoading: true), RegisterState()],
      verify: (_) {
        verify(
          () => authRepository.upgradeAnonymousWithEmail(
            email: 'existing@example.com',
            password: 'secret123',
          ),
        ).called(1);
      },
    );

    blocTest<RegisterCubit, RegisterState>(
      'emits error when signUp fails with user_already_exists but no session '
      'exists',
      setUp: () {
        when(
          () => authRepository.signUpWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(Exception('user_already_exists'));
      },
      build: () => RegisterCubit(authRepository),
      act: (cubit) =>
          cubit.register(email: 'existing@example.com', password: 'secret123'),
      expect: () => const [
        RegisterState(isLoading: true),
        RegisterState(errorKey: 'email_already_registered'),
      ],
    );

    blocTest<_CompletingRegisterCubit, RegisterState>(
      'ignores duplicate registration while loading',
      build: () {
        final completer = Completer<void>();
        when(
          () => authRepository.signUpWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) => completer.future);

        return _CompletingRegisterCubit(authRepository, completer);
      },
      act: (cubit) async {
        final firstRegistration = cubit.register(
          email: 'user@example.com',
          password: 'secret123',
        );
        await cubit.register(email: 'other@example.com', password: 'secret123');
        cubit.completeRegistration();
        await firstRegistration;
      },
      expect: () => const [RegisterState(isLoading: true), RegisterState()],
      verify: (_) {
        verify(
          () => authRepository.signUpWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).called(1);
      },
    );
  });
}

class _CompletingRegisterCubit extends RegisterCubit {
  _CompletingRegisterCubit(super.authRepository, this._completer);

  final Completer<void> _completer;

  void completeRegistration() => _completer.complete();
}
