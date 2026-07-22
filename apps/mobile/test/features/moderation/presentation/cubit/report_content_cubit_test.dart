import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mestio/features/moderation/data/repositories/content_moderation_repository.dart';
import 'package:mestio/features/moderation/presentation/cubit/report_content_cubit.dart';

class MockContentModerationRepository extends Mock
    implements ContentModerationRepository {}

void main() {
  late MockContentModerationRepository repository;

  setUpAll(() {
    registerFallbackValue(ContentReportType.announcement);
    registerFallbackValue(ContentReportReason.spam);
  });

  setUp(() {
    repository = MockContentModerationRepository();
  });

  group('ReportContentCubit', () {
    blocTest<ReportContentCubit, ReportContentState>(
      'starts as initial',
      build: () => ReportContentCubit(repository),
      verify: (cubit) {
        expect(cubit.state, const ReportContentState.initial());
      },
    );

    blocTest<ReportContentCubit, ReportContentState>(
      'emits loading then success when reportContent succeeds',
      build: () {
        when(() => repository.reportContent(
              contentType: any(named: 'contentType'),
              contentId: any(named: 'contentId'),
              reason: any(named: 'reason'),
              description: any(named: 'description'),
            )).thenAnswer((_) async => 'report-1');
        return ReportContentCubit(repository);
      },
      act: (cubit) => cubit.submitReport(
        contentType: ContentReportType.announcement,
        contentId: 'ann-1',
        reason: ContentReportReason.spam,
      ),
      expect: () => [
        const ReportContentState.loading(),
        const ReportContentState.success(),
      ],
      verify: (_) {
        verify(() => repository.reportContent(
              contentType: ContentReportType.announcement,
              contentId: 'ann-1',
              reason: ContentReportReason.spam,
              description: null,
            )).called(1);
      },
    );

    blocTest<ReportContentCubit, ReportContentState>(
      'emits loading then error when reportContent fails',
      build: () {
        when(() => repository.reportContent(
              contentType: any(named: 'contentType'),
              contentId: any(named: 'contentId'),
              reason: any(named: 'reason'),
              description: any(named: 'description'),
            )).thenThrow(Exception('error_moderation_rate_limit'));
        return ReportContentCubit(repository);
      },
      act: (cubit) => cubit.submitReport(
        contentType: ContentReportType.reportComment,
        contentId: 'comment-1',
        reason: ContentReportReason.harassment,
        description: 'opis',
      ),
      expect: () => [
        const ReportContentState.loading(),
        isA<ReportContentState>(),
      ],
      verify: (cubit) {
        expect(cubit.state, isA<ReportContentState>());
      },
    );

    blocTest<ReportContentCubit, ReportContentState>(
      'reset returns to initial from any state',
      build: () {
        when(() => repository.reportContent(
              contentType: any(named: 'contentType'),
              contentId: any(named: 'contentId'),
              reason: any(named: 'reason'),
              description: any(named: 'description'),
            )).thenAnswer((_) async => 'report-1');
        return ReportContentCubit(repository);
      },
      act: (cubit) async {
        await cubit.submitReport(
          contentType: ContentReportType.emergencyContact,
          contentId: 'contact-1',
          reason: ContentReportReason.other,
        );
        cubit.reset();
      },
      expect: () => [
        const ReportContentState.loading(),
        const ReportContentState.success(),
        const ReportContentState.initial(),
      ],
    );
  });
}
