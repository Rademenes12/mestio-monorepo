import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/resolution_model.dart';

abstract class ResolutionsDataSource {
  /// Lists resolutions for [estateId] with tally + caller's vote via the
  /// `fixflow_list_resolutions` RPC (tally visibility enforced server-side).
  Future<List<Resolution>> getResolutions({required String estateId});

  /// Casts an immutable vote; [choice] is 'for' or 'against'.
  Future<void> castVote({required String resolutionId, required String choice});

  Future<void> createResolution({
    required String estateId,
    required String title,
    String? description,
    DateTime? deadline,
  });

  /// Closes a resolution as 'passed' or 'rejected' (board/admin only via RLS).
  Future<void> closeResolution({required String id, required String status});
}

@LazySingleton(as: ResolutionsDataSource)
class ResolutionsDataSourceImpl implements ResolutionsDataSource {
  ResolutionsDataSourceImpl(this._client);

  final SupabaseClient _client;

  static const String _table = 'fixflow_resolutions';
  static const String _votesTable = 'fixflow_resolution_votes';

  @override
  Future<List<Resolution>> getResolutions({required String estateId}) async {
    try {
      debugPrint('ℹ️ [ResolutionsDataSource] fetching estate=$estateId');
      final response = await _client
          .rpc('fixflow_list_resolutions', params: {'p_estate_id': estateId})
          .timeout(const Duration(seconds: 8));
      final rows = (response as List)
          .map((j) => Resolution.fromJson(Map<String, dynamic>.from(j)))
          .toList();
      debugPrint('ℹ️ [ResolutionsDataSource] fetched ${rows.length} rows');
      return rows;
    } catch (e) {
      debugPrint('❌ [ResolutionsDataSource] getResolutions failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> castVote({
    required String resolutionId,
    required String choice,
  }) async {
    try {
      debugPrint('ℹ️ [ResolutionsDataSource] voting $choice on $resolutionId');
      await _client
          .from(_votesTable)
          .insert({
            'resolution_id': resolutionId,
            'choice': choice,
          })
          .timeout(const Duration(seconds: 8));
      debugPrint('✅ [ResolutionsDataSource] vote cast');
    } catch (e) {
      debugPrint('❌ [ResolutionsDataSource] castVote failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> createResolution({
    required String estateId,
    required String title,
    String? description,
    DateTime? deadline,
  }) async {
    try {
      debugPrint('ℹ️ [ResolutionsDataSource] creating resolution');
      await _client
          .from(_table)
          .insert({
            'estate_id': estateId,
            'title': title,
            'description': description,
            'deadline': deadline?.toIso8601String(),
            'created_by': _client.auth.currentUser?.id,
          })
          .timeout(const Duration(seconds: 8));
      debugPrint('✅ [ResolutionsDataSource] resolution created');
    } catch (e) {
      debugPrint('❌ [ResolutionsDataSource] createResolution failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> closeResolution({
    required String id,
    required String status,
  }) async {
    try {
      debugPrint('ℹ️ [ResolutionsDataSource] closing $id as $status');
      await _client
          .from(_table)
          .update({
            'status': status,
            'closed_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', id)
          .timeout(const Duration(seconds: 8));
      debugPrint('✅ [ResolutionsDataSource] resolution closed');
    } catch (e) {
      debugPrint('❌ [ResolutionsDataSource] closeResolution failed: $e');
      rethrow;
    }
  }
}
