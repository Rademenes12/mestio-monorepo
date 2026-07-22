import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mestio/features/announcements/data/repositories/announcements_repository.dart';
import 'package:mestio/features/announcements/models/announcement_model.dart';
import 'package:mestio/features/announcements/presentation/cubit/announcements_cubit.dart';
import 'package:mestio/features/estate/data/repositories/estate_repository.dart';
import 'package:mestio/features/estate/models/estate_model.dart';

class MockAnnouncementsRepository extends Mock implements AnnouncementsRepository {}

class MockEstateRepository extends Mock implements EstateRepository {}

void main() {
  late MockAnnouncementsRepository mockRepository;
  late MockEstateRepository mockEstateRepo;

  const testEstate = Estate(id: 'estate-1', name: 'Test', role: 'admin');

  final testAnnouncement = Announcement(
    id: 'a1',
    title: 'Przerwa w dostawie wody',
    content: 'Szczegóły',
  );

  setUp(() {
    mockRepository = MockAnnouncementsRepository();
    mockEstateRepo = MockEstateRepository();
    when(() => mockEstateRepo.watchActiveEstate()).thenAnswer(
      (_) => Stream.value(testEstate),
    );
    when(() => mockRepository.watchAnnouncements()).thenAnswer(
      (_) => Stream.value(const []),
    );
    when(() => mockRepository.refresh(estateId: any(named: 'estateId')))
        .thenAnswer((_) async {});
  });

  AnnouncementsCubit buildCubit() =>
      AnnouncementsCubit(mockRepository, mockEstateRepo);

  group('AnnouncementsCubit', () {
    blocTest<AnnouncementsCubit, AnnouncementsState>(
      'loads announcements for the active estate on start',
      build: () {
        when(() => mockRepository.watchAnnouncements()).thenAnswer(
          (_) => Stream.value([testAnnouncement]),
        );
        return buildCubit();
      },
      wait: const Duration(milliseconds: 100),
      verify: (cubit) {
        verify(() => mockRepository.refresh(estateId: 'estate-1')).called(1);
        final state = cubit.state;
        expect(state, isA<AnnouncementsLoaded>());
        expect((state as AnnouncementsLoaded).announcements, [testAnnouncement]);
      },
    );

    blocTest<AnnouncementsCubit, AnnouncementsState>(
      'create passes the structured scope through to the repository',
      build: () {
        when(() => mockRepository.watchAnnouncements()).thenAnswer(
          (_) => Stream.value([testAnnouncement]),
        );
        when(() => mockRepository.create(
              title: any(named: 'title'),
              content: any(named: 'content'),
              authorName: any(named: 'authorName'),
              authorRole: any(named: 'authorRole'),
              targetLabel: any(named: 'targetLabel'),
              estateId: any(named: 'estateId'),
              expiresAt: any(named: 'expiresAt'),
              scopeType: any(named: 'scopeType'),
              scopeBuildingId: any(named: 'scopeBuildingId'),
              scopeStairwellId: any(named: 'scopeStairwellId'),
            )).thenAnswer((_) async => testAnnouncement);
        return buildCubit();
      },
      wait: const Duration(milliseconds: 100),
      act: (cubit) async {
        await Future.delayed(const Duration(milliseconds: 100));
        await cubit.create(
          title: 'Nowe ogłoszenie',
          content: 'Treść',
          authorName: 'Biuro',
          authorRole: 'Zarząd',
          targetLabel: 'Budynek A',
          scopeType: 'building',
          scopeBuildingId: 'b1',
        );
      },
      verify: (_) {
        verify(() => mockRepository.create(
              title: 'Nowe ogłoszenie',
              content: 'Treść',
              authorName: 'Biuro',
              authorRole: 'Zarząd',
              targetLabel: 'Budynek A',
              estateId: 'estate-1',
              expiresAt: null,
              scopeType: 'building',
              scopeBuildingId: 'b1',
              scopeStairwellId: null,
            )).called(1);
      },
    );

    blocTest<AnnouncementsCubit, AnnouncementsState>(
      'create sets errorKey when the repository throws',
      build: () {
        when(() => mockRepository.watchAnnouncements()).thenAnswer(
          (_) => Stream.value([testAnnouncement]),
        );
        when(() => mockRepository.create(
              title: any(named: 'title'),
              content: any(named: 'content'),
              authorName: any(named: 'authorName'),
              authorRole: any(named: 'authorRole'),
              targetLabel: any(named: 'targetLabel'),
              estateId: any(named: 'estateId'),
              expiresAt: any(named: 'expiresAt'),
              scopeType: any(named: 'scopeType'),
              scopeBuildingId: any(named: 'scopeBuildingId'),
              scopeStairwellId: any(named: 'scopeStairwellId'),
            )).thenThrow(Exception('boom'));
        return buildCubit();
      },
      wait: const Duration(milliseconds: 100),
      act: (cubit) async {
        await Future.delayed(const Duration(milliseconds: 100));
        await cubit.create(
          title: 'Nowe ogłoszenie',
          content: 'Treść',
          authorName: 'Biuro',
          authorRole: 'Zarząd',
        );
      },
      verify: (cubit) {
        final state = cubit.state as AnnouncementsLoaded;
        expect(state.isSubmitting, isFalse);
        expect(state.errorKey, 'announcement_create_error');
      },
    );

    blocTest<AnnouncementsCubit, AnnouncementsState>(
      'retry reloads announcements via refresh when loaded',
      build: () {
        when(() => mockRepository.watchAnnouncements()).thenAnswer(
          (_) => Stream.value([testAnnouncement]),
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

    blocTest<AnnouncementsCubit, AnnouncementsState>(
      'retry emits error when refresh fails',
      build: () {
        when(() => mockRepository.watchAnnouncements())
            .thenAnswer((_) => const Stream.empty());
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
        expect(cubit.state, isA<AnnouncementsError>());
        expect(
          (cubit.state as AnnouncementsError).errorKey,
          'announcements_load_error',
        );
      },
    );

    blocTest<AnnouncementsCubit, AnnouncementsState>(
      'delete calls repository.softDelete',
      build: () {
        when(() => mockRepository.watchAnnouncements()).thenAnswer(
          (_) => Stream.value([testAnnouncement]),
        );
        when(() => mockRepository.softDelete(any())).thenAnswer((_) async {});
        return buildCubit();
      },
      wait: const Duration(milliseconds: 100),
      act: (cubit) async {
        await Future.delayed(const Duration(milliseconds: 100));
        await cubit.delete('a1');
      },
      verify: (_) {
        verify(() => mockRepository.softDelete('a1')).called(1);
      },
    );
  });
}
