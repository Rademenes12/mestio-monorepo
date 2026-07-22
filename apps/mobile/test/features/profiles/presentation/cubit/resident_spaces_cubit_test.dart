import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mestio/features/profiles/data/datasources/resident_spaces_data_source.dart';
import 'package:mestio/features/profiles/models/resident_space_model.dart';
import 'package:mestio/features/profiles/presentation/cubit/resident_spaces_cubit.dart';

class MockResidentSpacesDataSource extends Mock implements ResidentSpacesDataSource {}

void main() {
  late MockResidentSpacesDataSource dataSource;

  const spaceA = ResidentSpaceModel(
    id: 'sp1',
    userId: 'u1',
    estateId: 'e1',
    type: 'storage',
    label: 'Komórka 3',
  );

  setUpAll(() {
    registerFallbackValue(spaceA);
  });

  setUp(() {
    dataSource = MockResidentSpacesDataSource();
  });

  group('ResidentSpacesCubit', () {
    blocTest<ResidentSpacesCubit, ResidentSpacesState>(
      'starts as initial',
      build: () => ResidentSpacesCubit(dataSource),
      verify: (cubit) => expect(cubit.state, isA<Initial>()),
    );

    blocTest<ResidentSpacesCubit, ResidentSpacesState>(
      'loadSpaces emits loading then loaded on success',
      build: () {
        when(() => dataSource.getSpaces('u1', 'e1'))
            .thenAnswer((_) async => [spaceA]);
        return ResidentSpacesCubit(dataSource);
      },
      act: (cubit) => cubit.loadSpaces(userId: 'u1', estateId: 'e1'),
      expect: () => [
        const ResidentSpacesState.loading(),
        const ResidentSpacesState.loaded(spaces: [spaceA]),
      ],
    );

    blocTest<ResidentSpacesCubit, ResidentSpacesState>(
      'loadSpaces emits error on failure',
      build: () {
        when(() => dataSource.getSpaces('u1', 'e1'))
            .thenThrow(Exception('network'));
        return ResidentSpacesCubit(dataSource);
      },
      act: (cubit) => cubit.loadSpaces(userId: 'u1', estateId: 'e1'),
      expect: () => [
        const ResidentSpacesState.loading(),
        const ResidentSpacesState.error(errorKey: 'spaces_load_failed'),
      ],
    );

    blocTest<ResidentSpacesCubit, ResidentSpacesState>(
      'addSpace appends the created space when loaded',
      build: () {
        when(() => dataSource.getSpaces('u1', 'e1'))
            .thenAnswer((_) async => []);
        when(() => dataSource.addSpace(any())).thenAnswer((_) async => spaceA);
        return ResidentSpacesCubit(dataSource);
      },
      act: (cubit) async {
        await cubit.loadSpaces(userId: 'u1', estateId: 'e1');
        await cubit.addSpace(
          userId: 'u1',
          estateId: 'e1',
          type: 'storage',
          label: 'Komórka 3',
        );
      },
      verify: (cubit) {
        final state = cubit.state as Loaded;
        expect(state.spaces, [spaceA]);
      },
    );

    blocTest<ResidentSpacesCubit, ResidentSpacesState>(
      'addSpace is a no-op when not loaded',
      build: () => ResidentSpacesCubit(dataSource),
      act: (cubit) => cubit.addSpace(
        userId: 'u1',
        estateId: 'e1',
        type: 'storage',
        label: 'X',
      ),
      expect: () => <ResidentSpacesState>[],
      verify: (_) {
        verifyNever(() => dataSource.addSpace(any()));
      },
    );

    blocTest<ResidentSpacesCubit, ResidentSpacesState>(
      'addSpace restores previous list and emits error on failure',
      build: () {
        when(() => dataSource.getSpaces('u1', 'e1'))
            .thenAnswer((_) async => [spaceA]);
        when(() => dataSource.addSpace(any())).thenThrow(Exception('boom'));
        return ResidentSpacesCubit(dataSource);
      },
      act: (cubit) async {
        await cubit.loadSpaces(userId: 'u1', estateId: 'e1');
        await cubit.addSpace(
          userId: 'u1',
          estateId: 'e1',
          type: 'garage',
          label: 'Garaż 1',
        );
      },
      verify: (cubit) {
        final state = cubit.state;
        expect(state, isA<Loaded>());
        expect((state as Loaded).spaces, [spaceA]);
      },
    );

    blocTest<ResidentSpacesCubit, ResidentSpacesState>(
      'deleteSpace removes optimistically and stays removed on success',
      build: () {
        when(() => dataSource.getSpaces('u1', 'e1'))
            .thenAnswer((_) async => [spaceA]);
        when(() => dataSource.deleteSpace('sp1')).thenAnswer((_) async {});
        return ResidentSpacesCubit(dataSource);
      },
      act: (cubit) async {
        await cubit.loadSpaces(userId: 'u1', estateId: 'e1');
        await cubit.deleteSpace('sp1');
      },
      verify: (cubit) {
        final state = cubit.state as Loaded;
        expect(state.spaces, isEmpty);
      },
    );

    blocTest<ResidentSpacesCubit, ResidentSpacesState>(
      'deleteSpace restores the list and emits error on failure',
      build: () {
        when(() => dataSource.getSpaces('u1', 'e1'))
            .thenAnswer((_) async => [spaceA]);
        when(() => dataSource.deleteSpace('sp1'))
            .thenThrow(Exception('boom'));
        return ResidentSpacesCubit(dataSource);
      },
      act: (cubit) async {
        await cubit.loadSpaces(userId: 'u1', estateId: 'e1');
        await cubit.deleteSpace('sp1');
      },
      verify: (cubit) {
        final state = cubit.state;
        expect(state, isA<Error>());
      },
    );

    blocTest<ResidentSpacesCubit, ResidentSpacesState>(
      'deleteSpace is a no-op when not loaded',
      build: () => ResidentSpacesCubit(dataSource),
      act: (cubit) => cubit.deleteSpace('sp1'),
      expect: () => <ResidentSpacesState>[],
      verify: (_) {
        verifyNever(() => dataSource.deleteSpace(any()));
      },
    );
  });
}
