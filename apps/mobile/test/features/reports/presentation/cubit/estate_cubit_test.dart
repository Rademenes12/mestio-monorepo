import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mestio/features/estate/data/repositories/estate_structure_repository.dart';
import 'package:mestio/features/reports/models/building_model.dart';
import 'package:mestio/features/reports/presentation/cubit/estate_cubit.dart';

class MockEstateRepository extends Mock implements EstateStructureRepository {}

void main() {
  late MockEstateRepository repo;

  const buildingA = BuildingModel(id: 'b1', name: 'Budynek A', displayOrder: 1);
  const stairwellA = StairwellModel(
    id: 's1',
    buildingId: 'b1',
    name: 'A',
    floorMin: 0,
    floorMax: 4,
  );
  const buildingsWithStairwells = [
    BuildingWithStairwells(building: buildingA, stairwells: [stairwellA]),
  ];

  setUpAll(() {
    registerFallbackValue(buildingA);
    registerFallbackValue(stairwellA);
  });

  setUp(() {
    repo = MockEstateRepository();
  });

  group('EstateCubit (reports)', () {
    blocTest<EstateCubit, EstateState>(
      'starts as initial',
      build: () => EstateCubit(repo),
      verify: (cubit) {
        expect(cubit.state, isA<EstateInitial>());
      },
    );

    blocTest<EstateCubit, EstateState>(
      'setEstateId loads the estate structure',
      build: () {
        when(() => repo.getEstateStructure('estate-1'))
            .thenAnswer((_) async => buildingsWithStairwells);
        return EstateCubit(repo);
      },
      act: (cubit) => cubit.setEstateId('estate-1'),
      expect: () => [
        const EstateState.loading(),
        const EstateState.loaded(buildings: buildingsWithStairwells),
      ],
      verify: (_) {
        verify(() => repo.getEstateStructure('estate-1')).called(1);
      },
    );

    blocTest<EstateCubit, EstateState>(
      'setEstateId falls back to local data on PGRST002',
      build: () {
        when(() => repo.getEstateStructure('estate-1'))
            .thenThrow(Exception('PGRST002: Service Unavailable'));
        return EstateCubit(repo);
      },
      act: (cubit) => cubit.setEstateId('estate-1'),
      verify: (cubit) {
        final state = cubit.state;
        expect(state, isA<EstateLoaded>());
        final loaded = state as EstateLoaded;
        expect(loaded.errorKey, 'using_local_data');
        expect(loaded.buildings, isNotEmpty);
      },
    );

    blocTest<EstateCubit, EstateState>(
      'setEstateId emits error state on unknown failure',
      build: () {
        when(() => repo.getEstateStructure('estate-1'))
            .thenThrow(Exception('boom'));
        return EstateCubit(repo);
      },
      act: (cubit) => cubit.setEstateId('estate-1'),
      expect: () => [
        const EstateState.loading(),
        const EstateState.error(errorKey: 'estate_load_error'),
      ],
    );

    blocTest<EstateCubit, EstateState>(
      'retry is safe to call multiple times and reloads',
      build: () {
        when(() => repo.getEstateStructure('estate-1'))
            .thenAnswer((_) async => buildingsWithStairwells);
        return EstateCubit(repo);
      },
      act: (cubit) async {
        await cubit.setEstateId('estate-1');
        await cubit.retry();
        await cubit.retry();
      },
      verify: (_) {
        verify(() => repo.getEstateStructure('estate-1')).called(3);
      },
    );

    blocTest<EstateCubit, EstateState>(
      'addBuilding calls repository and reloads structure',
      build: () {
        when(() => repo.getEstateStructure('estate-1'))
            .thenAnswer((_) async => buildingsWithStairwells);
        when(() => repo.addBuilding('estate-1', 'Budynek B', 'Adres',
            buildingType: 'residential')).thenAnswer((_) async => buildingA);
        return EstateCubit(repo);
      },
      act: (cubit) async {
        await cubit.setEstateId('estate-1');
        await cubit.addBuilding('Budynek B', 'Adres');
      },
      verify: (_) {
        verify(() => repo.addBuilding('estate-1', 'Budynek B', 'Adres',
            buildingType: 'residential')).called(1);
        verify(() => repo.getEstateStructure('estate-1')).called(2);
      },
    );

    blocTest<EstateCubit, EstateState>(
      'addBuilding maps RLS error',
      build: () {
        when(() => repo.getEstateStructure('estate-1'))
            .thenAnswer((_) async => buildingsWithStairwells);
        when(() => repo.addBuilding(any(), any(), any(),
                buildingType: any(named: 'buildingType')))
            .thenThrow(Exception('42501 row-level security violation'));
        return EstateCubit(repo);
      },
      act: (cubit) async {
        await cubit.setEstateId('estate-1');
        await cubit.addBuilding('Budynek B', null);
      },
      verify: (cubit) {
        final state = cubit.state as EstateLoaded;
        expect(state.errorKey, 'building_add_rls_error');
      },
    );

    blocTest<EstateCubit, EstateState>(
      'addBuilding in offline mode adds locally without calling repository.addBuilding',
      build: () {
        when(() => repo.getEstateStructure('estate-1'))
            .thenThrow(Exception('PGRST002: Service Unavailable'));
        return EstateCubit(repo);
      },
      act: (cubit) async {
        await cubit.setEstateId('estate-1');
        await cubit.addBuilding('Lokalny budynek', null);
      },
      verify: (cubit) {
        final state = cubit.state as EstateLoaded;
        expect(
          state.buildings.any((b) => b.building.name == 'Lokalny budynek'),
          isTrue,
        );
        verifyNever(() => repo.addBuilding(any(), any(), any(),
            buildingType: any(named: 'buildingType')));
      },
    );

    blocTest<EstateCubit, EstateState>(
      'updateBuilding calls repository and reloads structure',
      build: () {
        when(() => repo.getEstateStructure('estate-1'))
            .thenAnswer((_) async => buildingsWithStairwells);
        when(() => repo.updateBuilding(any())).thenAnswer((_) async {});
        return EstateCubit(repo);
      },
      act: (cubit) async {
        await cubit.setEstateId('estate-1');
        await cubit.updateBuilding(buildingA.copyWith(name: 'Nowa nazwa'));
      },
      verify: (_) {
        verify(() => repo.updateBuilding(any())).called(1);
        verify(() => repo.getEstateStructure('estate-1')).called(2);
      },
    );

    blocTest<EstateCubit, EstateState>(
      'updateBuilding emits error key on failure',
      build: () {
        when(() => repo.getEstateStructure('estate-1'))
            .thenAnswer((_) async => buildingsWithStairwells);
        when(() => repo.updateBuilding(any())).thenThrow(Exception('boom'));
        return EstateCubit(repo);
      },
      act: (cubit) async {
        await cubit.setEstateId('estate-1');
        await cubit.updateBuilding(buildingA);
      },
      verify: (cubit) {
        final state = cubit.state as EstateLoaded;
        expect(state.errorKey, 'building_update_error');
      },
    );

    blocTest<EstateCubit, EstateState>(
      'deleteBuilding calls repository and reloads structure',
      build: () {
        when(() => repo.getEstateStructure('estate-1'))
            .thenAnswer((_) async => buildingsWithStairwells);
        when(() => repo.deleteBuilding(any())).thenAnswer((_) async {});
        return EstateCubit(repo);
      },
      act: (cubit) async {
        await cubit.setEstateId('estate-1');
        await cubit.deleteBuilding('b1');
      },
      verify: (_) {
        verify(() => repo.deleteBuilding('b1')).called(1);
        verify(() => repo.getEstateStructure('estate-1')).called(2);
      },
    );

    blocTest<EstateCubit, EstateState>(
      'deleteBuilding emits error key on failure',
      build: () {
        when(() => repo.getEstateStructure('estate-1'))
            .thenAnswer((_) async => buildingsWithStairwells);
        when(() => repo.deleteBuilding(any())).thenThrow(Exception('boom'));
        return EstateCubit(repo);
      },
      act: (cubit) async {
        await cubit.setEstateId('estate-1');
        await cubit.deleteBuilding('b1');
      },
      verify: (cubit) {
        final state = cubit.state as EstateLoaded;
        expect(state.errorKey, 'building_delete_error');
      },
    );

    blocTest<EstateCubit, EstateState>(
      'addStairwell calls repository and reloads structure',
      build: () {
        when(() => repo.getEstateStructure('estate-1'))
            .thenAnswer((_) async => buildingsWithStairwells);
        when(() => repo.addStairwell(
              any(),
              name: any(named: 'name'),
              floorMin: any(named: 'floorMin'),
              floorMax: any(named: 'floorMax'),
              garageEntranceLabel: any(named: 'garageEntranceLabel'),
            )).thenAnswer((_) async => stairwellA);
        return EstateCubit(repo);
      },
      act: (cubit) async {
        await cubit.setEstateId('estate-1');
        await cubit.addStairwell('b1', name: 'B', floorMin: 0, floorMax: 4);
      },
      verify: (_) {
        verify(() => repo.addStairwell(
              'b1',
              name: 'B',
              floorMin: 0,
              floorMax: 4,
              garageEntranceLabel: null,
            )).called(1);
        verify(() => repo.getEstateStructure('estate-1')).called(2);
      },
    );

    blocTest<EstateCubit, EstateState>(
      'addStairwell in offline mode adds locally',
      build: () {
        when(() => repo.getEstateStructure('estate-1'))
            .thenThrow(Exception('PGRST002: Service Unavailable'));
        return EstateCubit(repo);
      },
      act: (cubit) async {
        await cubit.setEstateId('estate-1');
        await cubit.addStairwell('local-1', name: 'C', floorMin: 0, floorMax: 2);
      },
      verify: (cubit) {
        final state = cubit.state as EstateLoaded;
        final target = state.buildings.firstWhere((b) => b.building.id == 'local-1');
        expect(target.stairwells.any((s) => s.name == 'C'), isTrue);
        verifyNever(() => repo.addStairwell(
              any(),
              name: any(named: 'name'),
              floorMin: any(named: 'floorMin'),
              floorMax: any(named: 'floorMax'),
              garageEntranceLabel: any(named: 'garageEntranceLabel'),
            ));
      },
    );

    blocTest<EstateCubit, EstateState>(
      'updateStairwell calls repository and reloads structure',
      build: () {
        when(() => repo.getEstateStructure('estate-1'))
            .thenAnswer((_) async => buildingsWithStairwells);
        when(() => repo.updateStairwell(any())).thenAnswer((_) async {});
        return EstateCubit(repo);
      },
      act: (cubit) async {
        await cubit.setEstateId('estate-1');
        await cubit.updateStairwell(stairwellA.copyWith(name: 'AA'));
      },
      verify: (_) {
        verify(() => repo.updateStairwell(any())).called(1);
        verify(() => repo.getEstateStructure('estate-1')).called(2);
      },
    );

    blocTest<EstateCubit, EstateState>(
      'updateStairwell emits error key on failure',
      build: () {
        when(() => repo.getEstateStructure('estate-1'))
            .thenAnswer((_) async => buildingsWithStairwells);
        when(() => repo.updateStairwell(any())).thenThrow(Exception('boom'));
        return EstateCubit(repo);
      },
      act: (cubit) async {
        await cubit.setEstateId('estate-1');
        await cubit.updateStairwell(stairwellA);
      },
      verify: (cubit) {
        final state = cubit.state as EstateLoaded;
        expect(state.errorKey, 'stairwell_update_error');
      },
    );

    blocTest<EstateCubit, EstateState>(
      'deleteStairwell calls repository and reloads structure',
      build: () {
        when(() => repo.getEstateStructure('estate-1'))
            .thenAnswer((_) async => buildingsWithStairwells);
        when(() => repo.deleteStairwell(any())).thenAnswer((_) async {});
        return EstateCubit(repo);
      },
      act: (cubit) async {
        await cubit.setEstateId('estate-1');
        await cubit.deleteStairwell('s1');
      },
      verify: (_) {
        verify(() => repo.deleteStairwell('s1')).called(1);
        verify(() => repo.getEstateStructure('estate-1')).called(2);
      },
    );

    blocTest<EstateCubit, EstateState>(
      'deleteStairwell emits error key on failure',
      build: () {
        when(() => repo.getEstateStructure('estate-1'))
            .thenAnswer((_) async => buildingsWithStairwells);
        when(() => repo.deleteStairwell(any())).thenThrow(Exception('boom'));
        return EstateCubit(repo);
      },
      act: (cubit) async {
        await cubit.setEstateId('estate-1');
        await cubit.deleteStairwell('s1');
      },
      verify: (cubit) {
        final state = cubit.state as EstateLoaded;
        expect(state.errorKey, 'stairwell_delete_error');
      },
    );
  });
}
