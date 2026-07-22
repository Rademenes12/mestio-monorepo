import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mestio/features/profiles/data/repositories/shared_user_repository.dart';
import 'package:mestio/features/profiles/presentation/cubit/profile_cubit.dart';

class _MockSharedUserRepository extends Mock implements SharedUserRepository {}

void main() {
  late SharedUserRepository sharedUserRepository;

  setUp(() {
    sharedUserRepository = _MockSharedUserRepository();
  });

  group('ProfileCubit', () {
    blocTest<ProfileCubit, ProfileState>(
      'emits saving and success when first name is saved',
      setUp: () {
        when(
          () => sharedUserRepository.updateFirstName(
            userId: any(named: 'userId'),
            firstName: any(named: 'firstName'),
          ),
        ).thenAnswer((_) async {});
      },
      build: () => ProfileCubit(sharedUserRepository),
      act: (cubit) => cubit.saveFirstName(userId: 'user-1', firstName: 'Adam'),
      expect: () => const [
        ProfileState(isSaving: true),
        ProfileState(successKey: 'profile_saved'),
      ],
      verify: (_) {
        verify(
          () => sharedUserRepository.updateFirstName(
            userId: 'user-1',
            firstName: 'Adam',
          ),
        ).called(1);
      },
    );

    blocTest<ProfileCubit, ProfileState>(
      'emits error when saving first name fails',
      setUp: () {
        when(
          () => sharedUserRepository.updateFirstName(
            userId: any(named: 'userId'),
            firstName: any(named: 'firstName'),
          ),
        ).thenThrow(Exception('network failed'));
      },
      build: () => ProfileCubit(sharedUserRepository),
      act: (cubit) => cubit.saveFirstName(userId: 'user-1', firstName: 'Adam'),
      expect: () => const [
        ProfileState(isSaving: true),
        ProfileState(errorKey: 'network_error'),
      ],
    );

    blocTest<_CompletingProfileCubit, ProfileState>(
      'ignores duplicate save while saving',
      build: () {
        final completer = Completer<void>();
        when(
          () => sharedUserRepository.updateFirstName(
            userId: any(named: 'userId'),
            firstName: any(named: 'firstName'),
          ),
        ).thenAnswer((_) => completer.future);

        return _CompletingProfileCubit(sharedUserRepository, completer);
      },
      act: (cubit) async {
        final firstSave = cubit.saveFirstName(
          userId: 'user-1',
          firstName: 'Adam',
        );
        await cubit.saveFirstName(userId: 'user-1', firstName: 'Ewa');
        cubit.completeSave();
        await firstSave;
      },
      expect: () => const [
        ProfileState(isSaving: true),
        ProfileState(successKey: 'profile_saved'),
      ],
      verify: (_) {
        verify(
          () => sharedUserRepository.updateFirstName(
            userId: any(named: 'userId'),
            firstName: any(named: 'firstName'),
          ),
        ).called(1);
      },
    );

    blocTest<ProfileCubit, ProfileState>(
      'clears feedback',
      build: () => ProfileCubit(sharedUserRepository),
      seed: () => const ProfileState(successKey: 'profile_saved'),
      act: (cubit) => cubit.clearFeedback(),
      expect: () => const [ProfileState()],
    );

    blocTest<ProfileCubit, ProfileState>(
      'does not emit when clearing empty feedback',
      build: () => ProfileCubit(sharedUserRepository),
      act: (cubit) => cubit.clearFeedback(),
      expect: () => const <ProfileState>[],
    );
  });
}

class _CompletingProfileCubit extends ProfileCubit {
  _CompletingProfileCubit(super.sharedUserRepository, this._completer);

  final Completer<void> _completer;

  void completeSave() => _completer.complete();
}
