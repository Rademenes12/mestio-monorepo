import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ContentModerationDataSource {
  /// Report content for moderation.
  /// Returns report ID on success.
  /// Throws if rate limit exceeded or already reported.
  Future<String> reportContent({
    required String contentType,
    required String contentId,
    required String reason,
    String? description,
  });

  /// Block a user so their content is hidden from the current user.
  Future<void> blockUser({required String blockedUserId, String? reason});

  /// Returns the set of user IDs the current user has blocked.
  Future<Set<String>> getBlockedUserIds();
}

@LazySingleton(as: ContentModerationDataSource)
class ContentModerationDataSourceImpl implements ContentModerationDataSource {
  ContentModerationDataSourceImpl(this._supabase);

  final SupabaseClient _supabase;

  @override
  Future<String> reportContent({
    required String contentType,
    required String contentId,
    required String reason,
    String? description,
  }) async {
    try {
      debugPrint(
        'ℹ️ [ContentModerationDataSource] reportContent: '
        'type=$contentType id=$contentId reason=$reason',
      );

      final response = await _supabase.rpc(
        'fixflow_report_content',
        params: {
          'p_content_type': contentType,
          'p_content_id': contentId,
          'p_reason': reason,
          'p_description': description,
        },
      ) as Map<String, dynamic>;

      final success = response['success'] as bool? ?? false;

      if (!success) {
        final error = response['error'] as String? ?? 'unknown_error';
        debugPrint('❌ [ContentModerationDataSource] RPC error: $error');
        throw Exception(error);
      }

      final reportId = response['report_id'] as String;
      debugPrint('✅ [ContentModerationDataSource] reportId=$reportId');

      return reportId;
    } catch (error) {
      debugPrint('❌ [ContentModerationDataSource] reportContent error: $error');
      rethrow;
    }
  }

  @override
  Future<void> blockUser({
    required String blockedUserId,
    String? reason,
  }) async {
    try {
      final blockerId = _supabase.auth.currentUser?.id;
      if (blockerId == null) {
        throw Exception('unauthenticated');
      }
      await _supabase.from('fixflow_blocked_users').upsert({
        'blocker_id': blockerId,
        'blocked_id': blockedUserId,
        'reason': reason,
      }, onConflict: 'blocker_id,blocked_id');
      debugPrint('✅ [ContentModerationDataSource] blocked user=$blockedUserId');
    } catch (error) {
      debugPrint('❌ [ContentModerationDataSource] blockUser error: $error');
      rethrow;
    }
  }

  @override
  Future<Set<String>> getBlockedUserIds() async {
    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) return {};

      final rows = await _supabase
          .from('fixflow_blocked_users')
          .select('blocked_id')
          .eq('blocker_id', currentUserId)
          .timeout(const Duration(seconds: 5));

      return (rows as List).map((r) => r['blocked_id'] as String).toSet();
    } catch (error) {
      debugPrint('⚠️ [ContentModerationDataSource] getBlockedUserIds error: $error');
      return {};
    }
  }
}
