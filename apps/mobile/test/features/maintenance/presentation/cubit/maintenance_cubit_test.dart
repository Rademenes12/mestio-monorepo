import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mestio/features/maintenance/data/repositories/maintenance_repository.dart';
import 'package:mestio/features/maintenance/models/maintenance_schedule_model.dart';
import 'package:mestio/features/maintenance/presentation/cubit/maintenance_cubit.dart';

class MockMaintenanceRepository extends Mock implements MaintenanceRepository {}

void main() {
  late MockMaintenanceRepository mockRepository;

  final testSchedules = [
    MaintenanceSchedule(
      id: 'm1',
      estateId: 'estate-1',
      name: 'Przegląd techniczny wind',
      frequencyDays: 30,
      nextDueDate: DateTime(2026, 7, 5),
    ),
  ];

  setUp(() {
    mockRepository = MockMaintenanceRepository();
    when(() => mockRepository.watchSchedules()).thenAnswer(
      (_) => Stream.value(const []),
    );
    when(() => mockRepository.refresh(estateId: any(named: 'estateId')))
        .thenAnswer((_) async {});
  });

  MaintenanceCubit buildCubit() => MaintenanceCubit(mockRepository);

  group('MaintenanceCubit', () {
    blocTest<MaintenanceCubit, MaintenanceState>(
      'load refreshes and emits schedules for the given estate',
      build: () {
        when(() => mockRepository.watchSchedules()).thenAnswer(
          (_) => Stream.value(testSchedules),
        );
        return buildCubit();
      },
      act: (cubit) => cubit.load('estate-1'),
      wait: const Duration(milliseconds: 100),
      verify: (cubit) {
        verify(() => mockRepository.refresh(estateId: 'estate-1')).called(1);
        final state = cubit.state;
        expect(state, isA<MaintenanceLoaded>());
        expect((state as MaintenanceLoaded).schedules, testSchedules);
      },
    );

    blocTest<MaintenanceCubit, MaintenanceState>(
      'load is a no-op when called again for the same already-loaded estate',
      build: () {
        when(() => mockRepository.watchSchedules()).thenAnswer(
          (_) => Stream.value(testSchedules),
        );
        return buildCubit();
      },
      act: (cubit) async {
        cubit.load('estate-1');
        await Future.delayed(const Duration(milliseconds: 100));
        cubit.load('estate-1');
      },
      verify: (_) {
        verify(() => mockRepository.refresh(estateId: 'estate-1')).called(1);
      },
    );

    blocTest<MaintenanceCubit, MaintenanceState>(
      'emits error state when refresh fails',
      build: () {
        // No schedules stream emission here — otherwise its microtask can
        // race with the refresh error and overwrite the resulting state.
        when(() => mockRepository.watchSchedules())
            .thenAnswer((_) => const Stream.empty());
        when(() => mockRepository.refresh(estateId: any(named: 'estateId')))
            .thenThrow(Exception('network'));
        return buildCubit();
      },
      act: (cubit) => cubit.load('estate-1'),
      wait: const Duration(milliseconds: 100),
      verify: (cubit) {
        expect(cubit.state, isA<MaintenanceError>());
        expect(
          (cubit.state as MaintenanceError).errorKey,
          'maintenance_load_error',
        );
      },
    );

    blocTest<MaintenanceCubit, MaintenanceState>(
      'retry reloads schedules via refresh',
      build: () {
        when(() => mockRepository.watchSchedules()).thenAnswer(
          (_) => Stream.value(testSchedules),
        );
        return buildCubit();
      },
      act: (cubit) async {
        cubit.load('estate-1');
        await Future.delayed(const Duration(milliseconds: 100));
        await cubit.retry();
      },
      wait: const Duration(milliseconds: 100),
      verify: (_) {
        verify(() => mockRepository.refresh(estateId: 'estate-1')).called(2);
      },
    );

    blocTest<MaintenanceCubit, MaintenanceState>(
      'retry emits error when refresh fails',
      build: () {
        when(() => mockRepository.watchSchedules())
            .thenAnswer((_) => const Stream.empty());
        when(() => mockRepository.refresh(estateId: any(named: 'estateId')))
            .thenThrow(Exception('network'));
        return buildCubit();
      },
      act: (cubit) async {
        cubit.load('estate-1');
        await Future.delayed(const Duration(milliseconds: 100));
        await cubit.retry();
      },
      wait: const Duration(milliseconds: 100),
      verify: (cubit) {
        expect(cubit.state, isA<MaintenanceError>());
        expect(
          (cubit.state as MaintenanceError).errorKey,
          'maintenance_load_error',
        );
      },
    );

    blocTest<MaintenanceCubit, MaintenanceState>(
      'markPerformed calls repository.markPerformed with the frequency',
      build: () {
        when(() => mockRepository.watchSchedules()).thenAnswer(
          (_) => Stream.value(testSchedules),
        );
        when(() => mockRepository.markPerformed(
              id: any(named: 'id'),
              frequencyDays: any(named: 'frequencyDays'),
            )).thenAnswer((_) async {});
        return buildCubit();
      },
      act: (cubit) async {
        cubit.load('estate-1');
        await Future.delayed(const Duration(milliseconds: 100));
        await cubit.markPerformed('m1', 30);
      },
      verify: (cubit) {
        verify(() => mockRepository.markPerformed(id: 'm1', frequencyDays: 30))
            .called(1);
        final state = cubit.state as MaintenanceLoaded;
        expect(state.isSubmitting, isFalse);
        expect(state.errorKey, isNull);
      },
    );

    blocTest<MaintenanceCubit, MaintenanceState>(
      'create returns true and calls repository.create for the loaded estate',
      build: () {
        when(() => mockRepository.watchSchedules()).thenAnswer(
          (_) => Stream.value(testSchedules),
        );
        when(() => mockRepository.create(
              estateId: any(named: 'estateId'),
              name: any(named: 'name'),
              frequencyDays: any(named: 'frequencyDays'),
              nextDueDate: any(named: 'nextDueDate'),
              buildingId: any(named: 'buildingId'),
              description: any(named: 'description'),
            )).thenAnswer((_) async {});
        return buildCubit();
      },
      act: (cubit) async {
        cubit.load('estate-1');
        await Future.delayed(const Duration(milliseconds: 100));
        await cubit.create(
          name: 'Przegląd gaśnic',
          frequencyDays: 365,
          nextDueDate: DateTime(2026, 12, 1),
        );
      },
      verify: (_) {
        verify(() => mockRepository.create(
              estateId: 'estate-1',
              name: 'Przegląd gaśnic',
              frequencyDays: 365,
              nextDueDate: DateTime(2026, 12, 1),
              buildingId: null,
              description: null,
            )).called(1);
      },
    );
  });
}
