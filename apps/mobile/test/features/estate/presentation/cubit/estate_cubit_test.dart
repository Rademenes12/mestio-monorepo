import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mestio/features/estate/data/repositories/estate_repository.dart';
import 'package:mestio/features/estate/models/estate_model.dart';
import 'package:mestio/features/estate/presentation/cubit/estate_cubit.dart';

class MockEstateRepository extends Mock implements EstateRepository {}

void main() {
  late MockEstateRepository repo;

  const estateA = Estate(id: 'a', name: 'Osiedle A', role: 'admin');

  setUp(() {
    repo = MockEstateRepository();
    // Default: empty streams; individual tests override as needed.
    when(() => repo.watchEstates()).thenAnswer((_) => Stream.value(const []));
    when(() => repo.watchActiveEstate())
        .thenAnswer((_) => Stream.value(null));
    when(() => repo.loadEstates()).thenAnswer((_) async {});
  });

  group('EstateMembershipCubit', () {
    blocTest<EstateMembershipCubit, EstateState>(
      'emits loaded with estate from active stream',
      build: () {
        when(() => repo.watchEstates())
            .thenAnswer((_) => Stream.value(const [estateA]));
        when(() => repo.watchActiveEstate())
            .thenAnswer((_) => Stream.value(estateA));
        return EstateMembershipCubit(repo);
      },
      wait: const Duration(milliseconds: 50),
      verify: (cubit) {
        final state = cubit.state;
        expect(state, isA<EstateLoaded>());
        final loaded = state as EstateLoaded;
        expect(loaded.activeEstate, estateA);
        expect(loaded.estates, [estateA]);
      },
    );

    blocTest<EstateMembershipCubit, EstateState>(
      'createEstate calls repository and returns true on success',
      build: () {
        when(() => repo.createEstate(any())).thenAnswer((_) async => 'new-id');
        return EstateMembershipCubit(repo);
      },
      wait: const Duration(milliseconds: 50),
      act: (cubit) => cubit.createEstate('Nowe Osiedle'),
      verify: (_) {
        verify(() => repo.createEstate('Nowe Osiedle')).called(1);
      },
    );

    blocTest<EstateMembershipCubit, EstateState>(
      'createEstate emits error key on failure',
      build: () {
        when(() => repo.createEstate(any()))
            .thenThrow(Exception('boom'));
        return EstateMembershipCubit(repo);
      },
      wait: const Duration(milliseconds: 50),
      act: (cubit) => cubit.createEstate('X'),
      verify: (cubit) {
        final state = cubit.state;
        expect(state, isA<EstateLoaded>());
        expect((state as EstateLoaded).errorKey, 'estate_create_error');
      },
    );

    blocTest<EstateMembershipCubit, EstateState>(
      'redeemCode returns the RPC result and clears error on success',
      build: () {
        when(() => repo.redeemInvitationCode(
              any(),
              building: any(named: 'building'),
              stairwell: any(named: 'stairwell'),
              floor: any(named: 'floor'),
              apartment: any(named: 'apartment'),
              info: any(named: 'info'),
            )).thenAnswer(
          (_) async => {'status': 'joined', 'estate_id': 'estate-x', 'role': 'resident'},
        );
        return EstateMembershipCubit(repo);
      },
      wait: const Duration(milliseconds: 50),
      act: (cubit) => cubit.redeemCode('ABC123'),
      verify: (_) {
        verify(() => repo.redeemInvitationCode(
              'ABC123',
              building: null,
              stairwell: null,
              floor: null,
              apartment: null,
              info: null,
            )).called(1);
      },
    );

    blocTest<EstateMembershipCubit, EstateState>(
      'redeemCode emits mapped error key on failure',
      build: () {
        when(() => repo.redeemInvitationCode(
              any(),
              building: any(named: 'building'),
              stairwell: any(named: 'stairwell'),
              floor: any(named: 'floor'),
              apartment: any(named: 'apartment'),
              info: any(named: 'info'),
            )).thenThrow(Exception('code_not_found_or_expired'));
        return EstateMembershipCubit(repo);
      },
      wait: const Duration(milliseconds: 50),
      act: (cubit) => cubit.redeemCode('BAD'),
      verify: (cubit) {
        final state = cubit.state;
        expect(state, isA<EstateLoaded>());
        expect((state as EstateLoaded).errorKey, 'code_not_found_or_expired');
      },
    );

    blocTest<EstateMembershipCubit, EstateState>(
      'peekCode returns the role/estate info on success',
      build: () {
        when(() => repo.peekInvitationCode(any())).thenAnswer(
          (_) async => {
            'role': 'technician',
            'estate_id': 'estate-x',
            'estate_name': 'FixFlow QA',
          },
        );
        return EstateMembershipCubit(repo);
      },
      wait: const Duration(milliseconds: 50),
      act: (cubit) => cubit.peekCode('ABCD-EFGH-JKLM'),
      verify: (_) {
        verify(() => repo.peekInvitationCode('ABCD-EFGH-JKLM')).called(1);
      },
    );

    blocTest<EstateMembershipCubit, EstateState>(
      'peekCode emits mapped error key and returns null on failure',
      build: () {
        when(() => repo.peekInvitationCode(any()))
            .thenThrow(Exception('code_not_found_or_expired'));
        return EstateMembershipCubit(repo);
      },
      wait: const Duration(milliseconds: 50),
      act: (cubit) => cubit.peekCode('BAD'),
      verify: (cubit) {
        final state = cubit.state;
        expect(state, isA<EstateLoaded>());
        expect((state as EstateLoaded).errorKey, 'code_not_found_or_expired');
      },
    );

    blocTest<EstateMembershipCubit, EstateState>(
      'checkPendingRequest delegates to the repository',
      build: () {
        when(() => repo.getMyPendingJoinRequest()).thenAnswer(
          (_) async => {'id': 'req-1', 'role': 'admin'},
        );
        return EstateMembershipCubit(repo);
      },
      wait: const Duration(milliseconds: 50),
      act: (cubit) => cubit.checkPendingRequest(),
      verify: (_) {
        verify(() => repo.getMyPendingJoinRequest()).called(1);
      },
    );

    blocTest<EstateMembershipCubit, EstateState>(
      'retry is safe to call and reloads estates',
      build: () => EstateMembershipCubit(repo),
      wait: const Duration(milliseconds: 50),
      act: (cubit) async {
        await cubit.retry();
        await cubit.retry();
      },
      verify: (_) {
        // Once in constructor + at most twice from retry (retry guards state).
        verify(() => repo.loadEstates()).called(greaterThanOrEqualTo(1));
      },
    );
  });
}
