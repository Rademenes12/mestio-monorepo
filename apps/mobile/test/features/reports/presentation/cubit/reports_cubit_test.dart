import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mestio/app/session/data/repositories/session_repository.dart';
import 'package:mestio/app/session/models/session_status_model.dart';
import 'package:mestio/app/session/models/user_session_model.dart';
import 'package:mestio/core/reliability/report_outbox.dart';
import 'package:mestio/features/estate/data/repositories/estate_repository.dart';
import 'package:mestio/features/estate/models/estate_model.dart';
import 'package:mestio/features/profiles/models/resident_profile_model.dart';
import 'package:mestio/features/reports/data/repositories/reports_repository.dart';
import 'package:mestio/features/reports/models/report_model.dart';
import 'package:mestio/features/reports/presentation/cubit/reports_cubit.dart';
import 'package:mestio/features/reports/services/fcm_service.dart';
import 'package:mestio/features/residents/data/repositories/residents_repository.dart';
import 'package:mestio/features/residents/models/staff_member_model.dart';

class MockReportsRepository extends Mock implements ReportsRepository {}
class MockSessionRepository extends Mock implements SessionRepository {}
class MockEstateRepository extends Mock implements EstateRepository {}
class MockFcmService extends Mock implements FcmService {}
class MockReportOutbox extends Mock implements ReportOutbox {}
class MockResidentsRepository extends Mock implements ResidentsRepository {}

class FakeReportModel extends Fake implements ReportModel {}
class FakeResidentProfileModel extends Fake implements ResidentProfileModel {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeReportModel());
    registerFallbackValue(FakeResidentProfileModel());
  });

  group('ReportsCubit', () {
    late MockReportsRepository reportsRepository;
    late MockSessionRepository sessionRepository;
    late MockEstateRepository estateRepository;
    late MockFcmService fcmService;
    late MockReportOutbox reportOutbox;
    late MockResidentsRepository residentsRepository;
    late StreamController<SessionStatusModel> sessionStreamController;
    late StreamController<List<ReportModel>> reportsStreamController;
    late StreamController<Estate?> estateStreamController;

    const testEstate = Estate(
      id: 'estate-1',
      name: 'Test Estate',
      role: 'admin',
    );

    final profile = ResidentProfileModel(
      name: 'Jan Kowalski',
      email: 'jan@example.com',
      verificationCode: 'XYZ',
      building: 'Budynek 1',
      footbridge: 'Kładka A',
      floor: 'Parter',
      apartment: 'Mieszkanie 3',
      isVerified: true,
    );

    setUp(() {
      reportsRepository = MockReportsRepository();
      sessionRepository = MockSessionRepository();
      estateRepository = MockEstateRepository();
      fcmService = MockFcmService();
      reportOutbox = MockReportOutbox();
      residentsRepository = MockResidentsRepository();

      sessionStreamController = StreamController<SessionStatusModel>.broadcast();
      reportsStreamController = StreamController<List<ReportModel>>.broadcast();
      estateStreamController = StreamController<Estate?>.broadcast();

      when(() => sessionRepository.sessionStream)
          .thenAnswer((_) => sessionStreamController.stream);
      when(() => reportsRepository.watchReports())
          .thenAnswer((_) => reportsStreamController.stream);
      when(() => reportsRepository.refreshReports())
          .thenAnswer((_) => Future.value());
      when(() => reportsRepository.setActiveEstateId(any()))
          .thenReturn(null);
      when(() => reportsRepository.activeEstateId)
          .thenReturn('estate-1');
      when(() => estateRepository.watchActiveEstate())
          .thenAnswer((_) => estateStreamController.stream);
      when(() => fcmService.updateUserSubscriptions(role: any(named: 'role'), email: any(named: 'email')))
          .thenAnswer((_) => Future.value());
      when(() => fcmService.initialize())
          .thenAnswer((_) => Future.value());
      when(() => fcmService.fcmToken).thenReturn(null);
      when(() => reportOutbox.isOnline).thenReturn(true);
      when(() => residentsRepository.getEstateStaff(any()))
          .thenAnswer((_) => Future.value(const <StaffMemberModel>[]));
    });

    tearDown(() {
      sessionStreamController.close();
      reportsStreamController.close();
      estateStreamController.close();
    });

    blocTest<ReportsCubit, ReportsState>(
      'starts with ReportsInitial',
      build: () => ReportsCubit(reportsRepository, sessionRepository, estateRepository, fcmService, reportOutbox, residentsRepository),
      expect: () => const <ReportsState>[],
    );

    blocTest<ReportsCubit, ReportsState>(
      'loads data when session is authenticated and estate is set',
      build: () {
        when(() => reportsRepository.getResidentProfile('user-1'))
            .thenAnswer((_) => Future.value(null));
        when(() => fcmService.updateUserSubscriptions(
              role: any(named: 'role'),
              email: any(named: 'email'),
            )).thenAnswer((_) => Future.value());

        return ReportsCubit(reportsRepository, sessionRepository, estateRepository, fcmService, reportOutbox, residentsRepository);
      },
      act: (cubit) async {
        sessionStreamController.add(const SessionStatusModel.authenticated(
          session: UserSessionModel(
            userId: 'user-1',
            email: 'resident@example.com',
            isAnonymous: false,
            sharedUser: null,
          ),
        ));
        await Future.delayed(Duration.zero);
        // Simulate estate becoming active
        estateStreamController.add(testEstate);
        await Future.delayed(const Duration(milliseconds: 10));
      },
      expect: () => [
        const ReportsState.loading(),
      ],
      verify: (_) {
        verify(() => reportsRepository.setActiveEstateId('estate-1')).called(1);
        verify(() => reportsRepository.getResidentProfile('user-1')).called(1);
        verify(() => reportsRepository.refreshReports()).called(1);
      },
    );

    blocTest<ReportsCubit, ReportsState>(
      'emits ReportsLoaded when reports watch stream emits lists',
      build: () {
        when(() => reportsRepository.getResidentProfile('user-1'))
            .thenAnswer((_) => Future.value(profile));
        when(() => fcmService.updateUserSubscriptions(
              role: any(named: 'role'),
              email: any(named: 'email'),
            )).thenAnswer((_) => Future.value());

        return ReportsCubit(reportsRepository, sessionRepository, estateRepository, fcmService, reportOutbox, residentsRepository);
      },
      act: (cubit) async {
        sessionStreamController.add(SessionStatusModel.authenticated(
          session: UserSessionModel(
            userId: 'user-1',
            email: 'jan@example.com',
            isAnonymous: false,
            sharedUser: null,
          ),
        ));
        await Future.delayed(Duration.zero);
        estateStreamController.add(testEstate);
        await Future.delayed(Duration.zero);
        reportsStreamController.add([]);
      },
      expect: () => [
        const ReportsState.loading(),
        ReportsState.loaded(reports: [], profile: profile, userId: 'user-1', estateId: 'estate-1'),
      ],
    );

    group('with authenticated session', () {
      late ReportsCubit cubit;

      setUp(() async {
        when(() => reportsRepository.getResidentProfile('user-1'))
            .thenAnswer((_) => Future.value(profile));
        when(() => fcmService.updateUserSubscriptions(
              role: any(named: 'role'),
              email: any(named: 'email'),
            )).thenAnswer((_) => Future.value());

        cubit = ReportsCubit(reportsRepository, sessionRepository, estateRepository, fcmService, reportOutbox, residentsRepository);

        sessionStreamController.add(SessionStatusModel.authenticated(
          session: UserSessionModel(
            userId: 'user-1',
            email: 'jan@example.com',
            isAnonymous: false,
            sharedUser: null,
          ),
        ));
        await Future.delayed(Duration.zero);
        // Set active estate so reports can be loaded
        estateStreamController.add(testEstate);
        // Wait for estate subscription to process
        await Future.delayed(const Duration(milliseconds: 20));
      });

      blocTest<ReportsCubit, ReportsState>(
        'addReport fails when no estate is active',
        build: () {
          // Use a fresh cubit without estate set
          final freshSessionController = StreamController<SessionStatusModel>.broadcast();
          final freshEstateController = StreamController<Estate?>.broadcast();
          when(() => sessionRepository.sessionStream)
              .thenAnswer((_) => freshSessionController.stream);
          when(() => estateRepository.watchActiveEstate())
              .thenAnswer((_) => freshEstateController.stream);

          final freshCubit = ReportsCubit(reportsRepository, sessionRepository, estateRepository, fcmService, reportOutbox, residentsRepository);
          return freshCubit;
        },
        seed: () => ReportsState.loaded(reports: [], profile: profile),
        act: (cubit) => cubit.addReport(
          title: 'Zepsuta winda',
          description: 'Nie działa na parterze',
          category: 'Winda i Schody Ruchome',
        ),
        expect: () => [
          ReportsState.loaded(reports: [], profile: profile, isSubmitting: true),
          ReportsState.loaded(reports: [], profile: profile, isSubmitting: false, errorKey: 'error_no_estate'),
        ],
      );

      blocTest<ReportsCubit, ReportsState>(
        'addReport calls reportsRepository.addReport and fcmService.triggerAssignmentNotification',
        build: () {
          when(() => reportsRepository.addReport(any()))
              .thenAnswer((_) => Future.value());
          when(() => fcmService.triggerAssignmentNotification(
                reportTitle: any(named: 'reportTitle'),
                assignedRole: any(named: 'assignedRole'),
                reportId: any(named: 'reportId'),
              )).thenAnswer((_) => Future.value());
          return cubit;
        },
        seed: () => ReportsState.loaded(reports: [], profile: profile),
        act: (cubit) async {
          await cubit.addReport(
            title: 'Zepsuta winda',
            description: 'Nie działa na parterze',
            category: 'Winda i Schody Ruchome',
          );
        },
        expect: () => [
          ReportsState.loaded(reports: [], profile: profile, isSubmitting: true),
          ReportsState.loaded(reports: [], profile: profile, isSubmitting: false),
        ],
        verify: (_) {
          verify(() => reportsRepository.addReport(any())).called(1);
          verify(() => fcmService.triggerAssignmentNotification(
                reportTitle: 'Zepsuta winda',
                assignedRole: 'Winda i Schody Ruchome',
                reportId: any(named: 'reportId'),
              )).called(1);
        },
      );

      blocTest<ReportsCubit, ReportsState>(
        'addReport uploads the PDF to Storage and stores the resulting path in attachmentsJson',
        build: () {
          when(() => reportsRepository.addReport(any()))
              .thenAnswer((_) => Future.value());
          when(() => reportsRepository.uploadReportPdf(
                localPath: any(named: 'localPath'),
                estateId: any(named: 'estateId'),
                reportId: any(named: 'reportId'),
              )).thenAnswer((_) => Future.value('estate-1/report-uuid/123.pdf'));
          when(() => fcmService.triggerAssignmentNotification(
                reportTitle: any(named: 'reportTitle'),
                assignedRole: any(named: 'assignedRole'),
                reportId: any(named: 'reportId'),
              )).thenAnswer((_) => Future.value());
          return cubit;
        },
        seed: () => ReportsState.loaded(reports: [], profile: profile),
        act: (cubit) => cubit.addReport(
          title: 'Awaria domofonu',
          description: 'Nie działa',
          category: 'Domofon',
          pdfPath: '/local/protokol.pdf',
        ),
        verify: (_) {
          verify(() => reportsRepository.uploadReportPdf(
                localPath: '/local/protokol.pdf',
                estateId: 'estate-1',
                reportId: any(named: 'reportId'),
              )).called(1);
          final captured = verify(() => reportsRepository.addReport(captureAny()))
              .captured
              .single as ReportModel;
          expect(captured.attachmentsJson, contains('estate-1/report-uuid/123.pdf'));
          expect(captured.attachmentsJson, isNot(contains('/local/protokol.pdf')));
        },
      );

      blocTest<ReportsCubit, ReportsState>(
        'addReport with isPriority=true sets high priority, SLA deadline and additionalInfo',
        build: () {
          when(() => reportsRepository.addReport(any()))
              .thenAnswer((_) => Future.value());
          when(() => fcmService.triggerAssignmentNotification(
                reportTitle: any(named: 'reportTitle'),
                assignedRole: any(named: 'assignedRole'),
                reportId: any(named: 'reportId'),
              )).thenAnswer((_) => Future.value());
          return cubit;
        },
        seed: () => ReportsState.loaded(reports: [], profile: profile),
        act: (cubit) => cubit.addReport(
          title: 'Zalany garaż',
          description: 'Woda stoi',
          category: 'Parking',
          additionalInfo: 'Przyjedzie straż pożarna z pompą',
          isPriority: true,
        ),
        verify: (_) {
          final captured = verify(() => reportsRepository.addReport(captureAny()))
              .captured
              .single as ReportModel;
          expect(captured.priority, 'high');
          expect(captured.slaDeadline, isNotNull);
          expect(captured.additionalInfo, 'Przyjedzie straż pożarna z pompą');
        },
      );

      blocTest<ReportsCubit, ReportsState>(
        'addReport with isPriority=false defaults to normal priority and no additionalInfo',
        build: () {
          when(() => reportsRepository.addReport(any()))
              .thenAnswer((_) => Future.value());
          when(() => fcmService.triggerAssignmentNotification(
                reportTitle: any(named: 'reportTitle'),
                assignedRole: any(named: 'assignedRole'),
                reportId: any(named: 'reportId'),
              )).thenAnswer((_) => Future.value());
          return cubit;
        },
        seed: () => ReportsState.loaded(reports: [], profile: profile),
        act: (cubit) => cubit.addReport(
          title: 'Cieknący kran',
          description: 'Kapie woda',
          category: 'Hydraulika',
        ),
        verify: (_) {
          final captured = verify(() => reportsRepository.addReport(captureAny()))
              .captured
              .single as ReportModel;
          expect(captured.priority, 'normal');
          expect(captured.slaDeadline, isNull);
          expect(captured.additionalInfo, isNull);
        },
      );

      blocTest<ReportsCubit, ReportsState>(
        'addReport uploads extraPhotoPaths and records each in fixflow_report_images',
        build: () {
          when(() => reportsRepository.addReport(any()))
              .thenAnswer((_) async {});
          when(() => reportsRepository.uploadReportPhoto(
                localPath: any(named: 'localPath'),
                estateId: any(named: 'estateId'),
                reportId: any(named: 'reportId'),
              )).thenAnswer(
            (inv) async =>
                'estate-1/report-uuid/${inv.namedArguments[#localPath]}.jpg',
          );
          when(() => reportsRepository.addReportImage(
                reportId: any(named: 'reportId'),
                storagePath: any(named: 'storagePath'),
              )).thenAnswer((_) async {});
          when(() => fcmService.triggerAssignmentNotification(
                reportTitle: any(named: 'reportTitle'),
                assignedRole: any(named: 'assignedRole'),
                reportId: any(named: 'reportId'),
              )).thenAnswer((_) async {});
          return cubit;
        },
        seed: () => ReportsState.loaded(reports: [], profile: profile),
        act: (cubit) => cubit.addReport(
          title: 'Zalany garaż',
          description: 'Woda stoi',
          category: 'Parking',
          extraPhotoPaths: ['/local/2.jpg', '/local/3.jpg'],
        ),
        verify: (_) {
          verify(() => reportsRepository.uploadReportPhoto(
                localPath: '/local/2.jpg',
                estateId: 'estate-1',
                reportId: any(named: 'reportId'),
              )).called(1);
          verify(() => reportsRepository.uploadReportPhoto(
                localPath: '/local/3.jpg',
                estateId: 'estate-1',
                reportId: any(named: 'reportId'),
              )).called(1);
          verify(() => reportsRepository.addReportImage(
                reportId: any(named: 'reportId'),
                storagePath: any(named: 'storagePath'),
              )).called(2);
        },
      );

      blocTest<ReportsCubit, ReportsState>(
        'saveProfile calls reportsRepository.saveResidentProfile and emits saved profile',
        build: () {
          when(() => reportsRepository.saveResidentProfile('user-1', any()))
              .thenAnswer((_) => Future.value());
          return cubit;
        },
        seed: () => ReportsState.loaded(reports: [], profile: profile),
        act: (cubit) => cubit.saveProfile(profile),
        expect: () => [
          ReportsState.loaded(reports: [], profile: profile, isSubmitting: true),
          ReportsState.loaded(reports: [], profile: profile, isSubmitting: false),
        ],
        verify: (_) {
          verify(() => reportsRepository.saveResidentProfile('user-1', any())).called(1);
        },
      );

      blocTest<ReportsCubit, ReportsState>(
        // Role is now assigned server-side by the invitation-code RPCs
        // (fixflow_redeem_invitation_code / fixflow_approve_join_request),
        // never by the client — saveProfile just persists the profile as-is.
        'saveProfile persists a staff role as-is without touching user_estates',
        build: () {
          when(() => reportsRepository.saveResidentProfile('user-1', any()))
              .thenAnswer((_) => Future.value());
          return cubit;
        },
        seed: () => ReportsState.loaded(
          reports: [],
          profile: profile.copyWith(role: 'Administrator'),
        ),
        act: (cubit) => cubit.saveProfile(profile.copyWith(role: 'Administrator')),
        expect: () => [
          ReportsState.loaded(
            reports: [],
            profile: profile.copyWith(role: 'Administrator'),
            isSubmitting: true,
          ),
          ReportsState.loaded(
            reports: [],
            profile: profile.copyWith(role: 'Administrator'),
            isSubmitting: false,
          ),
        ],
        verify: (_) {
          verify(() => reportsRepository.saveResidentProfile('user-1', any())).called(1);
        },
      );

      blocTest<ReportsCubit, ReportsState>(
        'syncOffline calls reportsRepository.syncOfflineReports',
        build: () {
          when(() => reportsRepository.syncOfflineReports())
              .thenAnswer((_) => Future.value());
          return cubit;
        },
        seed: () => ReportsState.loaded(reports: [], profile: profile),
        act: (cubit) => cubit.syncOffline(),
        expect: () => [
          ReportsState.loaded(reports: [], profile: profile, isSubmitting: true),
          ReportsState.loaded(reports: [], profile: profile, isSubmitting: false),
        ],
        verify: (_) {
          verify(() => reportsRepository.syncOfflineReports()).called(1);
        },
      );

      blocTest<ReportsCubit, ReportsState>(
        'assignReportToUser updates report and calls reportsRepository.updateReport',
        build: () {
          when(() => reportsRepository.updateReport(any()))
              .thenAnswer((_) => Future.value());
          return cubit;
        },
        seed: () => ReportsState.loaded(
          reports: [
            ReportModel(
              id: 'report-123',
              title: 'Winda',
              description: 'Opis',
              category: 'Serwis',
              timestamp: 12345,
              estateId: 'estate-1',
            ),
          ],
          profile: profile,
        ),
        act: (cubit) => cubit.assignReportToUser('report-123', 'tech-uuid', 'Tomasz Lis', 'Serwisant'),
        expect: () => [
          ReportsState.loaded(
            reports: [
              ReportModel(
                id: 'report-123',
                title: 'Winda',
                description: 'Opis',
                category: 'Serwis',
                timestamp: 12345,
                estateId: 'estate-1',
              ),
            ],
            profile: profile,
            isSubmitting: true,
          ),
          ReportsState.loaded(
            reports: [
              ReportModel(
                id: 'report-123',
                title: 'Winda',
                description: 'Opis',
                category: 'Serwis',
                timestamp: 12345,
                estateId: 'estate-1',
              ),
            ],
            profile: profile,
            isSubmitting: false,
          ),
        ],
        verify: (_) {
          verify(() => reportsRepository.updateReport(any(
            that: isA<ReportModel>()
                .having((r) => r.assignedToUserId, 'assignedToUserId', 'tech-uuid')
                .having((r) => r.assignedToName, 'assignedToName', 'Tomasz Lis')
                .having((r) => r.assignedToRole, 'assignedToRole', 'Serwisant'),
          ))).called(1);
        },
      );

      blocTest<ReportsCubit, ReportsState>(
        'retry emits loading and reloads data via _loadDataForUser',
        build: () {
          when(() => reportsRepository.getResidentProfile('user-1'))
              .thenAnswer((_) => Future.value(profile));
          when(() => reportsRepository.refreshReports())
              .thenAnswer((_) => Future.value());
          return cubit;
        },
        seed: () => ReportsState.loaded(reports: [], profile: profile),
        act: (cubit) async {
          await cubit.retry();
          await Future.delayed(const Duration(milliseconds: 20));
          reportsStreamController.add([]);
        },
        expect: () => [
          const ReportsState.loading(),
          ReportsState.loaded(
            reports: [],
            profile: profile,
            userId: 'user-1',
            estateId: 'estate-1',
          ),
        ],
        verify: (_) {
          verify(() => reportsRepository.getResidentProfile('user-1')).called(greaterThan(1));
          verify(() => reportsRepository.refreshReports()).called(greaterThan(1));
        },
      );

      blocTest<ReportsCubit, ReportsState>(
        'retry is a no-op when no user is authenticated',
        build: () => ReportsCubit(reportsRepository, sessionRepository, estateRepository, fcmService, reportOutbox, residentsRepository),
        act: (cubit) => cubit.retry(),
        expect: () => const <ReportsState>[],
      );

      blocTest<ReportsCubit, ReportsState>(
        'setReportCategory calls reportsRepository.updateReport with the new category',
        build: () {
          when(() => reportsRepository.updateReport(any()))
              .thenAnswer((_) => Future.value());
          return cubit;
        },
        seed: () => ReportsState.loaded(
          reports: [
            ReportModel(
              id: 'report-123',
              title: 'Winda',
              description: 'Opis',
              category: 'Serwis',
              timestamp: 12345,
              estateId: 'estate-1',
            ),
          ],
          profile: profile.copyWith(role: 'Administrator'),
        ),
        act: (cubit) => cubit.setReportCategory('report-123', 'Winda'),
        verify: (_) {
          verify(() => reportsRepository.updateReport(any(
            that: isA<ReportModel>()
                .having((r) => r.category, 'category', 'Winda'),
          ))).called(1);
        },
      );
    });
  });
}
