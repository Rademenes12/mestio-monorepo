import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mestio/features/estate/data/repositories/estate_repository.dart';
import 'package:mestio/features/estate/models/estate_model.dart';
import 'package:mestio/features/residents/data/repositories/residents_repository.dart';
import 'package:mestio/features/residents/models/resident_model.dart';
import 'package:mestio/features/residents/presentation/cubit/residents_cubit.dart';

class MockResidentsRepository extends Mock implements ResidentsRepository {}

class MockEstateRepository extends Mock implements EstateRepository {}

void main() {
  late MockResidentsRepository repo;
  late MockEstateRepository estateRepo;

  const estateA = Estate(id: 'estate-1', name: 'Osiedle A', role: 'admin');
  const residentA = ResidentModel(
    id: 'r1',
    userId: 'u1',
    firstName: 'Jan',
    lastName: 'Kowalski',
    email: 'jan@example.com',
    apartmentNumber: 'M1',
  );

  setUp(() {
    repo = MockResidentsRepository();
    estateRepo = MockEstateRepository();
  });

  group('ResidentsCubit', () {
    blocTest<ResidentsCubit, ResidentsState>(
      'emits empty loaded when there is no active estate',
      build: () {
        when(() => estateRepo.watchActiveEstate())
            .thenAnswer((_) => Stream.value(null));
        return ResidentsCubit(repo, estateRepo);
      },
      act: (_) => pumpEventQueue(),
      verify: (cubit) {
        final state = cubit.state;
        expect(state, isA<ResidentsLoaded>());
        expect((state as ResidentsLoaded).residents, isEmpty);
      },
    );

    blocTest<ResidentsCubit, ResidentsState>(
      'loads residents for the active estate',
      build: () {
        when(() => estateRepo.watchActiveEstate())
            .thenAnswer((_) => Stream.value(estateA));
        when(() => repo.getResidents('estate-1'))
            .thenAnswer((_) async => [residentA]);
        return ResidentsCubit(repo, estateRepo);
      },
      wait: const Duration(milliseconds: 50),
      verify: (cubit) {
        final state = cubit.state;
        expect(state, isA<ResidentsLoaded>());
        expect((state as ResidentsLoaded).residents, [residentA]);
      },
    );

    blocTest<ResidentsCubit, ResidentsState>(
      'falls back to local data on PGRST002',
      build: () {
        when(() => estateRepo.watchActiveEstate())
            .thenAnswer((_) => Stream.value(estateA));
        when(() => repo.getResidents('estate-1'))
            .thenThrow(Exception('PGRST002: Service Unavailable'));
        return ResidentsCubit(repo, estateRepo);
      },
      wait: const Duration(milliseconds: 50),
      verify: (cubit) {
        final state = cubit.state;
        expect(state, isA<ResidentsLoaded>());
        expect((state as ResidentsLoaded).residents, isNotEmpty);
      },
    );

    blocTest<ResidentsCubit, ResidentsState>(
      'emits error state on unknown failure',
      build: () {
        when(() => estateRepo.watchActiveEstate())
            .thenAnswer((_) => Stream.value(estateA));
        when(() => repo.getResidents('estate-1'))
            .thenThrow(Exception('boom'));
        return ResidentsCubit(repo, estateRepo);
      },
      wait: const Duration(milliseconds: 50),
      verify: (cubit) {
        final state = cubit.state;
        expect(state, isA<ResidentsError>());
        expect((state as ResidentsError).errorKey, 'residents_load_error');
      },
    );

    blocTest<ResidentsCubit, ResidentsState>(
      'refresh reloads residents',
      build: () {
        when(() => estateRepo.watchActiveEstate())
            .thenAnswer((_) => Stream.value(estateA));
        when(() => repo.getResidents('estate-1'))
            .thenAnswer((_) async => [residentA]);
        return ResidentsCubit(repo, estateRepo);
      },
      act: (cubit) async {
        await pumpEventQueue();
        await cubit.refresh();
      },
      verify: (_) {
        verify(() => repo.getResidents('estate-1')).called(greaterThanOrEqualTo(2));
      },
    );

    blocTest<ResidentsCubit, ResidentsState>(
      'toggleBoardVisibility flips the flag when loaded',
      build: () {
        when(() => estateRepo.watchActiveEstate())
            .thenAnswer((_) => Stream.value(estateA));
        when(() => repo.getResidents('estate-1'))
            .thenAnswer((_) async => [residentA]);
        return ResidentsCubit(repo, estateRepo);
      },
      act: (cubit) async {
        await pumpEventQueue();
        cubit.toggleBoardVisibility();
      },
      verify: (cubit) {
        final state = cubit.state as ResidentsLoaded;
        expect(state.visibleToBoard, isTrue);
      },
    );

    blocTest<ResidentsCubit, ResidentsState>(
      'toggleBoardVisibility is a no-op when not loaded',
      build: () {
        when(() => estateRepo.watchActiveEstate())
            .thenAnswer((_) => const Stream.empty());
        return ResidentsCubit(repo, estateRepo);
      },
      act: (cubit) => cubit.toggleBoardVisibility(),
      expect: () => <ResidentsState>[],
    );
  });
}
