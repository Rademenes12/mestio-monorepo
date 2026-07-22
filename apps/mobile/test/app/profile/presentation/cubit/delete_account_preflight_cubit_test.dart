import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mestio/app/profile/presentation/cubit/delete_account_preflight_cubit.dart';
import 'package:mestio/features/profiles/data/repositories/shared_user_apps_repository.dart';
import 'package:mestio/features/profiles/models/shared_user_app_model.dart';

class _MockSharedUserAppsRepository extends Mock
    implements SharedUserAppsRepository {}

void main() {
  late SharedUserAppsRepository sharedUserAppsRepository;

  final otherApps = [
    SharedUserAppModel(
      appId: 'other-app',
      appName: 'Other App',
      lastSeenAt: DateTime.utc(2026, 1, 1),
    ),
  ];

  setUp(() {
    sharedUserAppsRepository = _MockSharedUserAppsRepository();
  });

  group('DeleteAccountPreflightCubit', () {
    blocTest<DeleteAccountPreflightCubit, DeleteAccountPreflightState>(
      'loads other apps on start',
      setUp: () {
        when(
          () => sharedUserAppsRepository.getOtherApps(),
        ).thenAnswer((_) async => otherApps);
      },
      build: () => DeleteAccountPreflightCubit(sharedUserAppsRepository),
      wait: const Duration(milliseconds: 1),
      expect: () => [DeleteAccountPreflightState.loaded(otherApps: otherApps)],
      verify: (_) {
        verify(() => sharedUserAppsRepository.getOtherApps()).called(1);
      },
    );

    blocTest<DeleteAccountPreflightCubit, DeleteAccountPreflightState>(
      'emits error when loading other apps fails',
      setUp: () {
        when(
          () => sharedUserAppsRepository.getOtherApps(),
        ).thenAnswer((_) async => throw Exception('network unavailable'));
      },
      build: () => DeleteAccountPreflightCubit(sharedUserAppsRepository),
      wait: const Duration(milliseconds: 1),
      expect: () => const [
        DeleteAccountPreflightState.error(errorKey: 'network_error'),
      ],
    );

    blocTest<DeleteAccountPreflightCubit, DeleteAccountPreflightState>(
      'reloads other apps on retry',
      setUp: () {
        when(
          () => sharedUserAppsRepository.getOtherApps(),
        ).thenAnswer((_) async => otherApps);
      },
      build: () => DeleteAccountPreflightCubit(sharedUserAppsRepository),
      act: (cubit) async {
        await Future<void>.delayed(Duration.zero);
        await cubit.retry();
      },
      wait: const Duration(milliseconds: 1),
      expect: () => [
        DeleteAccountPreflightState.loaded(otherApps: otherApps),
        const DeleteAccountPreflightState.loading(),
        DeleteAccountPreflightState.loaded(otherApps: otherApps),
      ],
      verify: (_) {
        verify(() => sharedUserAppsRepository.getOtherApps()).called(2);
      },
    );
  });
}
