import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mestio/app/profile/presentation/cubit/account_actions_cubit.dart';
import 'package:mestio/features/auth/data/repositories/auth_repository.dart';
import 'package:mestio/features/subscription/data/repositories/subscription_repository.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockSubscriptionRepository extends Mock
    implements SubscriptionRepository {}

void main() {
  late AuthRepository authRepository;
  late SubscriptionRepository subscriptionRepository;

  setUp(() {
    authRepository = _MockAuthRepository();
    subscriptionRepository = _MockSubscriptionRepository();
  });

  group('AccountActionsCubit', () {
    blocTest<AccountActionsCubit, AccountActionsState>(
      'emits loading and success when sign out succeeds',
      setUp: () {
        when(() => authRepository.signOut()).thenAnswer((_) async {});
      },
      build: () => AccountActionsCubit(authRepository, subscriptionRepository),
      act: (cubit) => cubit.signOut(),
      expect: () => const [
        AccountActionsState(activeAction: AccountAction.signOut),
        AccountActionsState(successKey: 'signed_out'),
      ],
      verify: (_) {
        verify(() => authRepository.signOut()).called(1);
      },
    );

    blocTest<AccountActionsCubit, AccountActionsState>(
      'emits error when sign out fails',
      setUp: () {
        when(
          () => authRepository.signOut(),
        ).thenThrow(Exception('network unavailable'));
      },
      build: () => AccountActionsCubit(authRepository, subscriptionRepository),
      act: (cubit) => cubit.signOut(),
      expect: () => const [
        AccountActionsState(activeAction: AccountAction.signOut),
        AccountActionsState(errorKey: 'network_error'),
      ],
    );

    blocTest<AccountActionsCubit, AccountActionsState>(
      'deletes account and signs out when delete succeeds',
      setUp: () {
        when(() => authRepository.deleteAccount()).thenAnswer((_) async {});
        when(() => authRepository.signOut()).thenAnswer((_) async {});
      },
      build: () => AccountActionsCubit(authRepository, subscriptionRepository),
      act: (cubit) => cubit.deleteAccount(),
      expect: () => const [
        AccountActionsState(activeAction: AccountAction.deleteAccount),
        AccountActionsState(successKey: 'account_deleted'),
      ],
      verify: (_) {
        verify(() => authRepository.deleteAccount()).called(1);
        verify(() => authRepository.signOut()).called(1);
      },
    );

    blocTest<AccountActionsCubit, AccountActionsState>(
      'emits error when account deletion fails',
      setUp: () {
        when(
          () => authRepository.deleteAccount(),
        ).thenThrow(Exception('network unavailable'));
      },
      build: () => AccountActionsCubit(authRepository, subscriptionRepository),
      act: (cubit) => cubit.deleteAccount(),
      expect: () => const [
        AccountActionsState(activeAction: AccountAction.deleteAccount),
        AccountActionsState(errorKey: 'network_error'),
      ],
      verify: (_) {
        verify(() => authRepository.deleteAccount()).called(1);
        verifyNever(() => authRepository.signOut());
      },
    );

    blocTest<AccountActionsCubit, AccountActionsState>(
      'verifies the password before deleting when email/password are provided',
      setUp: () {
        when(
          () => authRepository.loginWithEmail(
            email: 'user@example.com',
            password: 'correct-password',
          ),
        ).thenAnswer((_) async {});
        when(() => authRepository.deleteAccount()).thenAnswer((_) async {});
        when(() => authRepository.signOut()).thenAnswer((_) async {});
      },
      build: () => AccountActionsCubit(authRepository, subscriptionRepository),
      act: (cubit) => cubit.deleteAccount(
        email: 'user@example.com',
        password: 'correct-password',
      ),
      expect: () => const [
        AccountActionsState(activeAction: AccountAction.deleteAccount),
        AccountActionsState(successKey: 'account_deleted'),
      ],
      verify: (_) {
        verify(
          () => authRepository.loginWithEmail(
            email: 'user@example.com',
            password: 'correct-password',
          ),
        ).called(1);
        verify(() => authRepository.deleteAccount()).called(1);
      },
    );

    blocTest<AccountActionsCubit, AccountActionsState>(
      'does not delete the account when password verification fails',
      setUp: () {
        when(
          () => authRepository.loginWithEmail(
            email: 'user@example.com',
            password: 'wrong-password',
          ),
        ).thenThrow(Exception('Invalid login credentials'));
      },
      build: () => AccountActionsCubit(authRepository, subscriptionRepository),
      act: (cubit) => cubit.deleteAccount(
        email: 'user@example.com',
        password: 'wrong-password',
      ),
      expect: () => const [
        AccountActionsState(activeAction: AccountAction.deleteAccount),
        AccountActionsState(errorKey: 'invalid_credentials'),
      ],
      verify: (_) {
        verifyNever(() => authRepository.deleteAccount());
        verifyNever(() => authRepository.signOut());
      },
    );

    blocTest<AccountActionsCubit, AccountActionsState>(
      'emits openPaywall effect when pro purchase is requested',
      build: () => AccountActionsCubit(authRepository, subscriptionRepository),
      act: (cubit) => cubit.requestProPurchase(),
      expect: () => [
        const AccountActionsState(effect: AccountActionsEffect.openPaywall()),
      ],
    );

    blocTest<AccountActionsCubit, AccountActionsState>(
      'updates developer pro override',
      setUp: () {
        when(
          () => subscriptionRepository.setDeveloperProOverride(
            userId: any(named: 'userId'),
            isPro: any(named: 'isPro'),
          ),
        ).thenAnswer((_) async {});
      },
      build: () => AccountActionsCubit(authRepository, subscriptionRepository),
      act: (cubit) =>
          cubit.setDeveloperProOverride(userId: 'user-id', isPro: true),
      expect: () => const [
        AccountActionsState(activeAction: AccountAction.developerProOverride),
        AccountActionsState(successKey: 'pro_enabled'),
      ],
      verify: (_) {
        verify(
          () => subscriptionRepository.setDeveloperProOverride(
            userId: 'user-id',
            isPro: true,
          ),
        ).called(1);
      },
    );

    blocTest<AccountActionsCubit, AccountActionsState>(
      'clears effect without touching other fields',
      build: () => AccountActionsCubit(authRepository, subscriptionRepository),
      seed: () =>
          const AccountActionsState(effect: AccountActionsEffect.openPaywall()),
      act: (cubit) => cubit.clearEffect(),
      expect: () => [const AccountActionsState()],
    );
  });
}
