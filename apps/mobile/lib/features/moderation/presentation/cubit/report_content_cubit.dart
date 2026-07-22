import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/error_messages.dart';
import '../../data/repositories/content_moderation_repository.dart';

part 'report_content_cubit.freezed.dart';

@injectable
class ReportContentCubit extends Cubit<ReportContentState> {
  ReportContentCubit(this._repository) : super(const ReportContentState.initial());

  final ContentModerationRepository _repository;

  Future<void> submitReport({
    required ContentReportType contentType,
    required String contentId,
    required ContentReportReason reason,
    String? description,
  }) async {
    try {
      debugPrint(
        'ℹ️ [ReportContentCubit] submitReport: '
        'type=$contentType id=$contentId reason=$reason',
      );

      emit(const ReportContentState.loading());

      await _repository.reportContent(
        contentType: contentType,
        contentId: contentId,
        reason: reason,
        description: description,
      );

      debugPrint('✅ [ReportContentCubit] submitReport succeeded');
      emit(const ReportContentState.success());
    } catch (error) {
      debugPrint('❌ [ReportContentCubit] submitReport error: $error');
      final errorKey = mapErrorToKey(error);
      emit(ReportContentState.error(errorKey));
    }
  }

  void reset() {
    debugPrint('ℹ️ [ReportContentCubit] reset');
    emit(const ReportContentState.initial());
  }
}

@freezed
sealed class ReportContentState with _$ReportContentState {
  const factory ReportContentState.initial() = _Initial;
  const factory ReportContentState.loading() = _Loading;
  const factory ReportContentState.success() = _Success;
  const factory ReportContentState.error(String errorKey) = _Error;
}
