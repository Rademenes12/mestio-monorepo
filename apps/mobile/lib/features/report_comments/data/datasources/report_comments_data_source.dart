import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/report_comment_model.dart';

abstract class ReportCommentsDataSource {
  Future<List<ReportComment>> getComments(String reportId);

  Future<ReportComment> addComment({
    required String reportId,
    required String authorName,
    required String authorRole,
    required String comment,
    bool isInternal = false,
  });
}

@LazySingleton(as: ReportCommentsDataSource)
class ReportCommentsDataSourceImpl implements ReportCommentsDataSource {
  ReportCommentsDataSourceImpl(this._client);

  final SupabaseClient _client;

  static const String _table = 'fixflow_report_comments';

  @override
  Future<List<ReportComment>> getComments(String reportId) async {
    try {
      final response = await _client
          .from(_table)
          .select()
          .eq('report_id', reportId)
          .order('created_at', ascending: true)
          .timeout(const Duration(seconds: 8));
      return (response as List)
          .map((j) => ReportComment.fromJson(Map<String, dynamic>.from(j)))
          .toList();
    } catch (e) {
      debugPrint('❌ [ReportCommentsDataSource] getComments failed: $e');
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
    try {
      final userId = _client.auth.currentUser?.id;
      final response = await _client
          .from(_table)
          .insert({
            'report_id': reportId,
            'user_id': userId,
            'author_name': authorName,
            'author_role': authorRole,
            'comment': comment,
            'is_internal': isInternal,
          })
          .select()
          .single()
          .timeout(const Duration(seconds: 8));
      debugPrint('✅ [ReportCommentsDataSource] comment added (internal: $isInternal)');
      return ReportComment.fromJson(Map<String, dynamic>.from(response));
    } catch (e) {
      debugPrint('❌ [ReportCommentsDataSource] addComment failed: $e');
      rethrow;
    }
  }
}
