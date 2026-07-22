import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mestio/features/auth/data/repositories/auth_repository.dart';
import 'package:mestio/features/auth/presentation/cubit/reset_password_cubit.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository authRepository;

  setUp(() {
    authRepository = MockAuthRepository();
    when(() => authRepository.clearPendingPasswordRecovery())
        .thenAnswer((_) async {});
  });

  group('ResetPasswordCubit', () {
    blocTest<ResetPasswordCubit, ResetPasswordState>(
      'emits loading then success on valid input',
      build: () {
        when(() => authRepository.resetPasswordWithOtp(
              email: any(named: 'email'),
              code: any(named: 'code'),
              newPassword: any(named: 'newPassword'),
            )).thenAnswer((_) async {});
        return ResetPasswordCubit(authRepository);
      },
      act: (cubit) => cubit.resetPassword(
        email: 'user@example.com',
        code: '123456',
        newPassword: 'newpass1',
        confirmPassword: 'newpass1',
      ),
      expect: () => [
        const ResetPasswordState(isLoading: true),
        const ResetPasswordState(
          isLoading: false,
          successKey: 'password_reset_completed',
        ),
      ],
    );

    blocTest<ResetPasswordCubit, ResetPasswordState>(
      'emits email_error for an invalid email without calling the repository',
      build: () => ResetPasswordCubit(authRepository),
      act: (cubit) => cubit.resetPassword(
        email: 'not-an-email',
        code: '123456',
        newPassword: 'newpass1',
        confirmPassword: 'newpass1',
      ),
      expect: () => [
        const ResetPasswordState(errorKey: 'email_error'),
      ],
      verify: (_) {
        verifyNever(() => authRepository.resetPasswordWithOtp(
              email: any(named: 'email'),
              code: any(named: 'code'),
              newPassword: any(named: 'newPassword'),
            ));
      },
    );

    blocTest<ResetPasswordCubit, ResetPasswordState>(
      'emits password_reset_code_required when code is empty',
      build: () => ResetPasswordCubit(authRepository),
      act: (cubit) => cubit.resetPassword(
        email: 'user@example.com',
        code: '',
        newPassword: 'newpass1',
        confirmPassword: 'newpass1',
      ),
      expect: () => [
        const ResetPasswordState(errorKey: 'password_reset_code_required'),
      ],
    );

    blocTest<ResetPasswordCubit, ResetPasswordState>(
      'emits password_too_short for a short password',
      build: () => ResetPasswordCubit(authRepository),
      act: (cubit) => cubit.resetPassword(
        email: 'user@example.com',
        code: '123456',
        newPassword: 'abc',
        confirmPassword: 'abc',
      ),
      expect: () => [
        const ResetPasswordState(errorKey: 'password_too_short'),
      ],
    );

    blocTest<ResetPasswordCubit, ResetPasswordState>(
      'emits passwords_do_not_match when confirmation differs',
      build: () => ResetPasswordCubit(authRepository),
      act: (cubit) => cubit.resetPassword(
        email: 'user@example.com',
        code: '123456',
        newPassword: 'newpass1',
        confirmPassword: 'newpass2',
      ),
      expect: () => [
        const ResetPasswordState(errorKey: 'passwords_do_not_match'),
      ],
    );

    blocTest<ResetPasswordCubit, ResetPasswordState>(
      'emits mapped error when the OTP exchange fails',
      build: () {
        when(() => authRepository.resetPasswordWithOtp(
              email: any(named: 'email'),
              code: any(named: 'code'),
              newPassword: any(named: 'newPassword'),
            )).thenThrow(Exception('invalid otp'));
        return ResetPasswordCubit(authRepository);
      },
      act: (cubit) => cubit.resetPassword(
        email: 'user@example.com',
        code: '000000',
        newPassword: 'newpass1',
        confirmPassword: 'newpass1',
      ),
      expect: () => [
        const ResetPasswordState(isLoading: true),
        isA<ResetPasswordState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.errorKey, 'errorKey', isNotNull),
      ],
    );

    blocTest<ResetPasswordCubit, ResetPasswordState>(
      'clearFeedback resets error and success keys',
      build: () => ResetPasswordCubit(authRepository),
      seed: () => const ResetPasswordState(
        errorKey: 'password_too_short',
        successKey: 'password_reset_completed',
      ),
      act: (cubit) => cubit.clearFeedback(),
      expect: () => [const ResetPasswordState()],
    );

    blocTest<ResetPasswordCubit, ResetPasswordState>(
      'clearFeedback is a no-op when there is nothing to clear',
      build: () => ResetPasswordCubit(authRepository),
      act: (cubit) => cubit.clearFeedback(),
      expect: () => <ResetPasswordState>[],
    );

    blocTest<ResetPasswordCubit, ResetPasswordState>(
      'close() clears pending password recovery when not completed',
      build: () => ResetPasswordCubit(authRepository),
      act: (cubit) => cubit.close(),
      verify: (_) {
        verify(() => authRepository.clearPendingPasswordRecovery()).called(1);
      },
    );

    blocTest<ResetPasswordCubit, ResetPasswordState>(
      'close() does not clear pending recovery once reset succeeded',
      build: () {
        when(() => authRepository.resetPasswordWithOtp(
              email: any(named: 'email'),
              code: any(named: 'code'),
              newPassword: any(named: 'newPassword'),
            )).thenAnswer((_) async {});
        return ResetPasswordCubit(authRepository);
      },
      act: (cubit) async {
        await cubit.resetPassword(
          email: 'user@example.com',
          code: '123456',
          newPassword: 'newpass1',
          confirmPassword: 'newpass1',
        );
        await cubit.close();
      },
      verify: (_) {
        verifyNever(() => authRepository.clearPendingPasswordRecovery());
      },
    );
  });
}
