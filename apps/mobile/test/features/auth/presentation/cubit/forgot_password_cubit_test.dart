import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mestio/features/auth/data/repositories/auth_repository.dart';
import 'package:mestio/features/auth/presentation/cubit/forgot_password_cubit.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository authRepository;

  setUp(() {
    authRepository = MockAuthRepository();
  });

  group('ForgotPasswordCubit', () {
    blocTest<ForgotPasswordCubit, ForgotPasswordState>(
      'emits loading then success when sendCode succeeds',
      build: () {
        when(() => authRepository.sendPasswordResetCode(
                email: any(named: 'email')))
            .thenAnswer((_) async {});
        return ForgotPasswordCubit(authRepository);
      },
      act: (cubit) => cubit.sendCode(email: 'user@example.com'),
      expect: () => [
        const ForgotPasswordState(
          isLoading: true,
          submittedEmail: 'user@example.com',
        ),
        const ForgotPasswordState(
          isLoading: false,
          submittedEmail: 'user@example.com',
          successKey: 'password_reset_code_sent',
        ),
      ],
    );

    blocTest<ForgotPasswordCubit, ForgotPasswordState>(
      'emits validation error for an invalid email without calling the repository',
      build: () => ForgotPasswordCubit(authRepository),
      act: (cubit) => cubit.sendCode(email: 'not-an-email'),
      expect: () => [
        const ForgotPasswordState(
          submittedEmail: 'not-an-email',
          errorKey: 'email_error',
        ),
      ],
      verify: (_) {
        verifyNever(() => authRepository.sendPasswordResetCode(
            email: any(named: 'email')));
      },
    );

    blocTest<ForgotPasswordCubit, ForgotPasswordState>(
      'emits mapped error when sendCode fails',
      build: () {
        when(() => authRepository.sendPasswordResetCode(
                email: any(named: 'email')))
            .thenThrow(Exception('network unavailable'));
        return ForgotPasswordCubit(authRepository);
      },
      act: (cubit) => cubit.sendCode(email: 'user@example.com'),
      expect: () => [
        const ForgotPasswordState(
          isLoading: true,
          submittedEmail: 'user@example.com',
        ),
        isA<ForgotPasswordState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.errorKey, 'errorKey', isNotNull),
      ],
    );

    blocTest<ForgotPasswordCubit, ForgotPasswordState>(
      'ignores duplicate sendCode calls while loading',
      build: () {
        when(() => authRepository.sendPasswordResetCode(
                email: any(named: 'email')))
            .thenAnswer((_) async {
          await Future<void>.delayed(const Duration(milliseconds: 20));
        });
        return ForgotPasswordCubit(authRepository);
      },
      act: (cubit) async {
        unawaited(cubit.sendCode(email: 'user@example.com'));
        await cubit.sendCode(email: 'user@example.com');
        await Future<void>.delayed(const Duration(milliseconds: 30));
      },
      verify: (_) {
        verify(() => authRepository.sendPasswordResetCode(
            email: any(named: 'email'))).called(1);
      },
    );

    blocTest<ForgotPasswordCubit, ForgotPasswordState>(
      'clearFeedback resets error and success keys',
      build: () => ForgotPasswordCubit(authRepository),
      seed: () => const ForgotPasswordState(
        errorKey: 'email_error',
        successKey: 'password_reset_code_sent',
      ),
      act: (cubit) => cubit.clearFeedback(),
      expect: () => [const ForgotPasswordState()],
    );

    blocTest<ForgotPasswordCubit, ForgotPasswordState>(
      'clearFeedback is a no-op when there is nothing to clear',
      build: () => ForgotPasswordCubit(authRepository),
      act: (cubit) => cubit.clearFeedback(),
      expect: () => <ForgotPasswordState>[],
    );
  });
}
