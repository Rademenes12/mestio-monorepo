import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/report_comment_model.dart';
import '../datasources/report_comments_data_source.dart';

abstract class ReportCommentsRepository {
  Stream<List<ReportComment>> watchComments(String reportId);

  Future<void> refresh(String reportId);

  Future<ReportComment> addComment({
    required String reportId,
    required String authorName,
    required String authorRole,
    required String comment,
    bool isInternal = false,
  });
}

@LazySingleton(as: ReportCommentsRepository)
class ReportCommentsRepositoryImpl implements ReportCommentsRepository {
  ReportCommentsRepositoryImpl(this._dataSource);

  final ReportCommentsDataSource _dataSource;
  final Map<String, BehaviorSubject<List<ReportComment>>> _subjects = {};

  BehaviorSubject<List<ReportComment>> _subjectFor(String reportId) {
    return _subjects.putIfAbsent(
      reportId,
      () => BehaviorSubject<List<ReportComment>>.seeded(const []),
    );
  }

  @override
  Stream<List<ReportComment>> watchComments(String reportId) {
    return _subjectFor(reportId).stream;
  }

  @override
  Future<void> refresh(String reportId) async {
    try {
      final comments = await _dataSource.getComments(reportId);
      _subjectFor(reportId).add(comments);
    } catch (e) {
      debugPrint('❌ [ReportCommentsRepository] refresh failed: $e');
      rethrow;
    }
  }

  @override
  Future<ReportComment> addComment({
    required String reportId,
    required String authorName,
    required String authorRole,
    required String comment,
    bool isInternal = false,
  }) async {
    final created = await _dataSource.addComment(
      reportId: reportId,
      authorName: authorName,
      authorRole: authorRole,
      comment: comment,
      isInternal: isInternal,
    );
    final subject = _subjectFor(reportId);
    subject.add([...subject.value, created]);
    return created;
  }
}
