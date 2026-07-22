import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mestio/features/profiles/models/resident_space_model.dart';

abstract class ResidentSpacesDataSource {
  Future<List<ResidentSpaceModel>> getSpaces(String userId, String estateId);
  Future<ResidentSpaceModel> addSpace(ResidentSpaceModel space);
  Future<void> deleteSpace(String id);
}

@LazySingleton(as: ResidentSpacesDataSource)
class ResidentSpacesDataSourceImpl implements ResidentSpacesDataSource {
  ResidentSpacesDataSourceImpl(this._client);
  final SupabaseClient _client;

  static const String _table = 'fixflow_resident_spaces';

  @override
  Future<List<ResidentSpaceModel>> getSpaces(String userId, String estateId) async {
    try {
      final response = await _client
          .from(_table)
          .select()
          .eq('user_id', userId)
          .eq('estate_id', estateId)
          .order('created_at')
          .timeout(const Duration(seconds: 8));

      return (response as List).map((j) => ResidentSpaceModel.fromJson(j)).toList();
    } catch (e) {
      debugPrint('❌ [ResidentSpacesDataSource] getSpaces failed: $e');
      rethrow;
    }
  }

  @override
  Future<ResidentSpaceModel> addSpace(ResidentSpaceModel space) async {
    try {
      final data = space.toJson()..remove('id');
      final response = await _client
          .from(_table)
          .insert(data)
          .select()
          .single()
          .timeout(const Duration(seconds: 8));

      return ResidentSpaceModel.fromJson(response);
    } catch (e) {
      debugPrint('❌ [ResidentSpacesDataSource] addSpace failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteSpace(String id) async {
    try {
      await _client
          .from(_table)
          .delete()
          .eq('id', id)
          .timeout(const Duration(seconds: 8));
    } catch (e) {
      debugPrint('❌ [ResidentSpacesDataSource] deleteSpace failed: $e');
      rethrow;
    }
  }
}
