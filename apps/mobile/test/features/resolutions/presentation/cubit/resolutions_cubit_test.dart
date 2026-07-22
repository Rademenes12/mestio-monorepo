import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mestio/features/estate/data/repositories/estate_repository.dart';
import 'package:mestio/features/estate/models/estate_model.dart';
import 'package:mestio/features/resolutions/data/repositories/resolutions_repository.dart';
import 'package:mestio/features/resolutions/models/resolution_model.dart';
import 'package:mestio/features/resolutions/presentation/cubit/resolutions_cubit.dart';

class MockResolutionsRepository extends Mock implements ResolutionsRepository {}

class MockEstateRepository extends Mock implements EstateRepository {}

void main() {
  late MockResolutionsRepository mockRepository;
  late MockEstateRepository mockEstateRepo;

  const testEstate = Estate(id: 'estate-1', name: 'Test', role: 'admin');

  final testResolutions = [
    const Resolution(
      id: 'r1',
      title: 'Wymiana oświetlenia na LED',
      status: 'open',
      votesFor: null,
      votesAgainst: null,
    ),
    const Resolution(
      id: 'r2',
      title: 'Montaż stojaków rowerowych',
      status: 'passed',
      votesFor: 71,
      votesAgainst: 5,
      myVote: 'for',
    ),
  ];

  setUp(() {
    mockRepository = MockResolutionsRepository();
    mockEstateRepo = MockEstateRepository();
    when(() => mockEstateRepo.watchActiveEstate()).thenAnswer(
      (_) => Stream.value(testEstate),
    );
    when(() => mockRepository.watchResolutions()).thenAnswer(
      (_) => Stream.value(const []),
    );
    when(() => mockRepository.refresh(estateId: any(named: 'estateId')))
        .thenAnswer((_) async {});
  });

  ResolutionsCubit buildCubit() =>
      ResolutionsCubit(mockRepository, mockEstateRepo);

  group('ResolutionsCubit', () {
    blocTest<ResolutionsCubit, ResolutionsState>(
      'loads resolutions for the active estate on start',
      build: () {
        when(() => mockRepository.watchResolutions()).thenAnswer(
          (_) => Stream.value(testResolutions),
        );
        return buildCubit();
      },
      wait: const Duration(milliseconds: 100),
      verify: (cubit) {
        verify(() => mockRepository.refresh(estateId: 'estate-1')).called(1);
        final state = cubit.state;
        expect(state, isA<ResolutionsLoaded>());
        expect((state as ResolutionsLoaded).resolutions, testResolutions);
      },
    );

    blocTest<ResolutionsCubit, ResolutionsState>(
      'emits error state when refresh fails',
      build: () {
        when(() => mockRepository.refresh(estateId: any(named: 'estateId')))
            .thenThrow(Exception('network'));
        return buildCubit();
      },
      wait: const Duration(milliseconds: 100),
      verify: (cubit) {
        expect(cubit.state, isA<ResolutionsError>());
        expect(
          (cubit.state as ResolutionsError).errorKey,
          'resolutions_load_error',
        );
      },
    );

    blocTest<ResolutionsCubit, ResolutionsState>(
      'retry reloads resolutions via refresh when loaded',
      build: () {
        when(() => mockRepository.watchResolutions()).thenAnswer(
          (_) => Stream.value(testResolutions),
        );
        return buildCubit();
      },
      wait: const Duration(milliseconds: 100),
      act: (cubit) async {
        await Future.delayed(const Duration(milliseconds: 100));
        await cubit.retry();
      },
      verify: (_) {
        verify(() => mockRepository.refresh(estateId: 'estate-1')).called(2);
      },
    );

    blocTest<ResolutionsCubit, ResolutionsState>(
      'retry emits error when refresh fails',
      build: () {
        when(() => mockRepository.refresh(estateId: any(named: 'estateId')))
            .thenThrow(Exception('network'));
        return buildCubit();
      },
      wait: const Duration(milliseconds: 100),
      act: (cubit) async {
        await Future.delayed(const Duration(milliseconds: 100));
        await cubit.retry();
      },
      verify: (cubit) {
        expect(cubit.state, isA<ResolutionsError>());
        expect(
          (cubit.state as ResolutionsError).errorKey,
          'resolutions_load_error',
        );
      },
    );

    blocTest<ResolutionsCubit, ResolutionsState>(
      'vote casts the vote and clears isSubmitting on success',
      build: () {
        when(() => mockRepository.watchResolutions()).thenAnswer(
          (_) => Stream.value(testResolutions),
        );
        when(() => mockRepository.castVote(
              resolutionId: any(named: 'resolutionId'),
              choice: any(named: 'choice'),
            )).thenAnswer((_) async {});
        return buildCubit();
      },
      wait: const Duration(milliseconds: 100),
      act: (cubit) async {
        await Future.delayed(const Duration(milliseconds: 100));
        await cubit.vote('r1', 'for');
      },
      verify: (cubit) {
        verify(() => mockRepository.castVote(
              resolutionId: 'r1',
              choice: 'for',
            )).called(1);
        final state = cubit.state as ResolutionsLoaded;
        expect(state.isSubmitting, isFalse);
        expect(state.errorKey, isNull);
      },
    );

    blocTest<ResolutionsCubit, ResolutionsState>(
      'vote sets errorKey when the repository throws',
      build: () {
        when(() => mockRepository.watchResolutions()).thenAnswer(
          (_) => Stream.value(testResolutions),
        );
        when(() => mockRepository.castVote(
              resolutionId: any(named: 'resolutionId'),
              choice: any(named: 'choice'),
            )).thenThrow(Exception('boom'));
        return buildCubit();
      },
      wait: const Duration(milliseconds: 100),
      act: (cubit) async {
        await Future.delayed(const Duration(milliseconds: 100));
        await cubit.vote('r1', 'for');
      },
      verify: (cubit) {
        final state = cubit.state as ResolutionsLoaded;
        expect(state.isSubmitting, isFalse);
        expect(state.errorKey, 'resolution_vote_error');
      },
    );

    blocTest<ResolutionsCubit, ResolutionsState>(
      'create returns true and calls repository.create with active estate',
      build: () {
        when(() => mockRepository.watchResolutions()).thenAnswer(
          (_) => Stream.value(testResolutions),
        );
        when(() => mockRepository.create(
              estateId: any(named: 'estateId'),
              title: any(named: 'title'),
              description: any(named: 'description'),
              deadline: any(named: 'deadline'),
            )).thenAnswer((_) async {});
        return buildCubit();
      },
      wait: const Duration(milliseconds: 100),
      act: (cubit) async {
        await Future.delayed(const Duration(milliseconds: 100));
        await cubit.create(title: 'Nowa uchwała');
      },
      verify: (cubit) {
        verify(() => mockRepository.create(
              estateId: 'estate-1',
              title: 'Nowa uchwała',
              description: null,
              deadline: null,
            )).called(1);
      },
    );

    blocTest<ResolutionsCubit, ResolutionsState>(
      'closeResolution calls repository.close with passed status',
      build: () {
        when(() => mockRepository.watchResolutions()).thenAnswer(
          (_) => Stream.value(testResolutions),
        );
        when(() => mockRepository.close(
              id: any(named: 'id'),
              status: any(named: 'status'),
            )).thenAnswer((_) async {});
        return buildCubit();
      },
      wait: const Duration(milliseconds: 100),
      act: (cubit) async {
        await Future.delayed(const Duration(milliseconds: 100));
        await cubit.closeResolution('r1', passed: true);
      },
      verify: (cubit) {
        verify(() => mockRepository.close(id: 'r1', status: 'passed'))
            .called(1);
      },
    );
  });
}
