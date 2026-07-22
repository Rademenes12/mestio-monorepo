import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/announcement_model.dart';

abstract class AnnouncementsDataSource {
  /// Fetches active announcements scoped to [estateId] (or global if null).
  /// Server-side RLS already filters by `is_active = true` and estate
  /// membership; we still apply ordering and a defensive client-side filter.
  Future<List<Announcement>> getAnnouncements({String? estateId});

  Future<Announcement> createAnnouncement({
    required String title,
    required String content,
    required String authorName,
    required String authorRole,
    String? targetLabel,
    String? estateId,
    DateTime? expiresAt,
    // 'estate' | 'building' | 'stairwell' — picked from the real estate
    // structure by the composer, not free text.
    String scopeType = 'estate',
    String? scopeBuildingId,
    String? scopeStairwellId,
  });

  /// Soft delete - sets `is_active = false`. Anyone with the board/admin RLS
  /// privilege can call this.
  Future<void> softDeleteAnnouncement(String id);
}

@LazySingleton(as: AnnouncementsDataSource)
class AnnouncementsDataSourceImpl implements AnnouncementsDataSource {
  AnnouncementsDataSourceImpl(this._client);

  final SupabaseClient _client;

  static const String _table = 'fixflow_announcements';

  @override
  Future<List<Announcement>> getAnnouncements({String? estateId}) async {
    try {
      debugPrint('ℹ️ [AnnouncementsDataSource] fetching estate=$estateId');
      final query = _client.from(_table).select().eq('is_active', true);
      final filtered = estateId != null
          ? query.eq('estate_id', estateId)
          : query.isFilter('estate_id', null);
      final response = await filtered
          .order('created_at', ascending: false)
          .limit(200)
          .timeout(const Duration(seconds: 8));
      debugPrint(
        'ℹ️ [AnnouncementsDataSource] fetched ${response.length} rows',
      );
      return (response as List)
          .map((j) => Announcement.fromJson(Map<String, dynamic>.from(j)))
          .toList();
    } catch (e) {
      debugPrint('❌ [AnnouncementsDataSource] getAnnouncements failed: $e');
      rethrow;
    }
  }

  @override
  Future<Announcement> createAnnouncement({
    required String title,
    required String content,
    required String authorName,
    required String authorRole,
    String? targetLabel,
    String? estateId,
    DateTime? expiresAt,
    String scopeType = 'estate',
    String? scopeBuildingId,
    String? scopeStairwellId,
  }) async {
    try {
      debugPrint('ℹ️ [AnnouncementsDataSource] creating announcement');
      final userId = _client.auth.currentUser?.id;
      final response = await _client
          .from(_table)
          .insert({
            'title': title,
            'content': content,
            'author_id': userId,
            'author_name': authorName,
            'author_role': authorRole,
            'target_label': targetLabel,
            'estate_id': estateId,
            'expires_at': expiresAt?.toIso8601String(),
            'is_active': true,
            'scope_type': scopeType,
            'scope_building_id': scopeBuildingId,
            'scope_stairwell_id': scopeStairwellId,
          })
          .select()
          .single()
          .timeout(const Duration(seconds: 8));
      debugPrint('✅ [AnnouncementsDataSource] announcement created');
      return Announcement.fromJson(Map<String, dynamic>.from(response));
    } catch (e) {
      debugPrint('❌ [AnnouncementsDataSource] createAnnouncement failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> softDeleteAnnouncement(String id) async {
    try {
      debugPrint('ℹ️ [AnnouncementsDataSource] soft-deleting $id');
      await _client
          .from(_table)
          .update({'is_active': false})
          .eq('id', id)
          .timeout(const Duration(seconds: 8));
      debugPrint('✅ [AnnouncementsDataSource] soft-deleted');
    } catch (e) {
      debugPrint('❌ [AnnouncementsDataSource] softDelete failed: $e');
      rethrow;
    }
  }
}
