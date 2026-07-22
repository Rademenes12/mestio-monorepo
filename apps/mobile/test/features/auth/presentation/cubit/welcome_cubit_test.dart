import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mestio/features/auth/data/repositories/auth_repository.dart';
import 'package:mestio/features/auth/presentation/cubit/welcome_cubit.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthRepository authRepository;

  setUp(() {
    authRepository = _MockAuthRepository();
  });

  group('WelcomeCubit', () {
    blocTest<WelcomeCubit, WelcomeState>(
      'emits loading and idle when continuing as guest succeeds',
      setUp: () {
        when(() => authRepository.continueAsGuest()).thenAnswer((_) async {});
      },
      build: () => WelcomeCubit(authRepository),
      act: (cubit) => cubit.continueAsGuest(),
      expect: () => const [WelcomeState(isLoading: true), WelcomeState()],
      verify: (_) {
        verify(() => authRepository.continueAsGuest()).called(1);
      },
    );

    blocTest<WelcomeCubit, WelcomeState>(
      'emits error when continuing as guest fails',
      setUp: () {
        when(
          () => authRepository.continueAsGuest(),
        ).thenThrow(Exception('anonymous sign-ins are disabled'));
      },
      build: () => WelcomeCubit(authRepository),
      act: (cubit) => cubit.continueAsGuest(),
      expect: () => const [
        WelcomeState(isLoading: true),
        WelcomeState(errorKey: 'anonymous_auth_disabled'),
      ],
    );

    blocTest<_CompletingWelcomeCubit, WelcomeState>(
      'ignores duplicate guest continuation while loading',
      build: () {
        final completer = Completer<void>();
        when(
          () => authRepository.continueAsGuest(),
        ).thenAnswer((_) => completer.future);

        return _CompletingWelcomeCubit(authRepository, completer);
      },
      act: (cubit) async {
        final firstContinuation = cubit.continueAsGuest();
        await cubit.continueAsGuest();
        cubit.completeContinuation();
        await firstContinuation;
      },
      expect: () => const [WelcomeState(isLoading: true), WelcomeState()],
      verify: (_) {
        verify(() => authRepository.continueAsGuest()).called(1);
      },
    );
  });
}

class _CompletingWelcomeCubit extends WelcomeCubit {
  _CompletingWelcomeCubit(super.authRepository, this._completer);

  final Completer<void> _completer;

  void completeContinuation() => _completer.complete();
}
