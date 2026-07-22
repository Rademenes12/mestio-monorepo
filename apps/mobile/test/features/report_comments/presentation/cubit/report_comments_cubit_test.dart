import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';

import 'package:mestio/features/report_comments/data/repositories/report_comments_repository.dart';
import 'package:mestio/features/report_comments/models/report_comment_model.dart';
import 'package:mestio/features/report_comments/presentation/cubit/report_comments_cubit.dart';

class MockReportCommentsRepository extends Mock
    implements ReportCommentsRepository {}

void main() {
  late MockReportCommentsRepository repository;
  late BehaviorSubject<List<ReportComment>> subject;

  final testReportId = 'rep-1';

  final testComment = ReportComment(
    id: 'c1',
    reportId: testReportId,
    authorName: 'Admin',
    authorRole: 'Administrator',
    comment: 'Test comment',
  );

  setUp(() {
    repository = MockReportCommentsRepository();
    subject = BehaviorSubject<List<ReportComment>>.seeded(const []);
    when(() => repository.watchComments(testReportId)).thenAnswer(
      (_) => subject.stream,
    );
    when(() => repository.refresh(testReportId)).thenAnswer(
      (_) async {},
    );
  });

  tearDown(() {
    subject.close();
  });

  group('ReportCommentsCubit', () {
    blocTest<ReportCommentsCubit, ReportCommentsState>(
      'starts with initial',
      build: () => ReportCommentsCubit(repository),
      verify: (cubit) =>
          expect(cubit.state, const ReportCommentsState.initial()),
    );

    blocTest<ReportCommentsCubit, ReportCommentsState>(
      'loads comments for report via stream',
      build: () => ReportCommentsCubit(repository),
      act: (cubit) => cubit.load(testReportId),
      expect: () => [
        const ReportCommentsState.loading(),
        const ReportCommentsState.loaded(comments: []),
      ],
      verify: (_) {
        verify(() => repository.watchComments(testReportId)).called(1);
        verify(() => repository.refresh(testReportId)).called(1);
      },
    );

    blocTest<ReportCommentsCubit, ReportCommentsState>(
      'emits isSubmitting true when adding comment',
      build: () => ReportCommentsCubit(repository),
      seed: () => ReportCommentsState.loaded(comments: [testComment]),
      setUp: () {
        when(() => repository.addComment(
              reportId: any(named: 'reportId'),
              authorName: any(named: 'authorName'),
              authorRole: any(named: 'authorRole'),
              comment: any(named: 'comment'),
            )).thenAnswer((_) async => testComment);
      },
      act: (cubit) => cubit.addComment(
        reportId: testReportId,
        authorName: 'Admin',
        authorRole: 'Administrator',
        comment: 'Hi',
      ),
      expect: () => [
        ReportCommentsState.loaded(
          comments: [testComment],
          isSubmitting: true,
        ),
      ],
    );

    blocTest<ReportCommentsCubit, ReportCommentsState>(
      'handles error when adding comment fails',
      build: () => ReportCommentsCubit(repository),
      seed: () => ReportCommentsState.loaded(comments: [testComment]),
      setUp: () {
        when(() => repository.addComment(
              reportId: any(named: 'reportId'),
              authorName: any(named: 'authorName'),
              authorRole: any(named: 'authorRole'),
              comment: any(named: 'comment'),
            )).thenThrow(Exception('db error'));
      },
      act: (cubit) => cubit.addComment(
        reportId: testReportId,
        authorName: 'Admin',
        authorRole: 'Administrator',
        comment: 'Fail',
      ),
      expect: () => [
        ReportCommentsState.loaded(
          comments: [testComment],
          isSubmitting: true,
        ),
        predicate<ReportCommentsState>((s) =>
            s is ReportCommentsLoaded &&
            s.isSubmitting == false &&
            s.errorKey != null),
      ],
    );

    blocTest<ReportCommentsCubit, ReportCommentsState>(
      'skips adding when state is not loaded',
      build: () => ReportCommentsCubit(repository),
      act: (cubit) => cubit.addComment(
        reportId: testReportId,
        authorName: 'Admin',
        authorRole: 'Administrator',
        comment: 'Should not add',
      ),
      expect: () => [],
    );
  });
}
