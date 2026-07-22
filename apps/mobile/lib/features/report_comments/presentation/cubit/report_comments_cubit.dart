import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/error_messages.dart';
import '../../data/repositories/report_comments_repository.dart';
import '../../models/report_comment_model.dart';

part 'report_comments_cubit.freezed.dart';

@freezed
sealed class ReportCommentsState with _$ReportCommentsState {
  const factory ReportCommentsState.initial() = ReportCommentsInitial;
  const factory ReportCommentsState.loading() = ReportCommentsLoading;
  const factory ReportCommentsState.loaded({
    required List<ReportComment> comments,
    @Default(false) bool isSubmitting,
    String? errorKey,
  }) = ReportCommentsLoaded;
  const factory ReportCommentsState.error({required String errorKey}) =
      ReportCommentsError;
}

@injectable
class ReportCommentsCubit extends Cubit<ReportCommentsState> {
  ReportCommentsCubit(this._repository)
      : super(const ReportCommentsState.initial());

  final ReportCommentsRepository _repository;

  StreamSubscription<List<ReportComment>>? _subscription;
  String? _currentReportId;

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  void load(String reportId) {
    if (_currentReportId != null &&
        _currentReportId == reportId &&
        state is ReportCommentsLoaded) {
      return;
    }

    _subscription?.cancel();
    _currentReportId = reportId;

    emit(const ReportCommentsState.loading());

    _subscription = _repository.watchComments(reportId).listen(
      (comments) {
        emit(ReportCommentsState.loaded(comments: comments));
      },
      onError: (err) {
        debugPrint('❌ [ReportCommentsCubit] stream error: $err');
        emit(ReportCommentsState.error(errorKey: mapErrorToKey(err)));
      },
    );

    _repository.refresh(reportId).catchError((e) {
      debugPrint('❌ [ReportCommentsCubit] refresh failed: $e');
    });
  }

  Future<void> addComment({
    required String reportId,
    required String authorName,
    required String authorRole,
    required String comment,
    bool isInternal = false,
  }) async {
    final currentState = state;
    if (currentState is! ReportCommentsLoaded) return;

    emit(currentState.copyWith(isSubmitting: true, errorKey: null));

    try {
      await _repository.addComment(
        reportId: reportId,
        authorName: authorName,
        authorRole: authorRole,
        comment: comment,
        isInternal: isInternal,
      );
      // Repository added the comment to the stream; subscriber emits updated
      // list with isSubmitting reset to false via the state default.
    } catch (e) {
      debugPrint('❌ [ReportCommentsCubit] addComment failed: $e');
      final updatedState = state;
      if (updatedState is ReportCommentsLoaded) {
        emit(updatedState.copyWith(
          isSubmitting: false,
          errorKey: mapErrorToKey(e),
        ));
      }
    }
  }
}
