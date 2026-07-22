import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../reports/models/building_model.dart';

abstract class EstateStructureDataSource {
  Future<List<BuildingModel>> getBuildings(String estateId);
  Future<List<StairwellModel>> getStairwells();
  Future<List<StairwellModel>> getStairwellsForBuilding(String buildingId);
  Future<BuildingModel> createBuilding(String estateId, String name, String? address, {String buildingType = 'residential'});
  Future<void> updateBuilding(BuildingModel building);
  Future<void> deleteBuilding(String id);
  Future<StairwellModel> createStairwell(
    String buildingId, {
    required String name,
    required int floorMin,
    required int floorMax,
    String? garageEntranceLabel,
  });
  Future<void> updateStairwell(StairwellModel stairwell);
  Future<void> deleteStairwell(String id);
  Stream<List<BuildingModel>> watchBuildings(String estateId);
  Stream<List<StairwellModel>> watchStairwells();
}

@LazySingleton(as: EstateStructureDataSource)
class EstateStructureDataSourceImpl implements EstateStructureDataSource {
  EstateStructureDataSourceImpl(this._supabaseClient);

  final SupabaseClient _supabaseClient;

  static const String _buildingsTable = 'fixflow_buildings';
  static const String _stairwellsTable = 'fixflow_stairwells';

  @override
  Future<List<BuildingModel>> getBuildings(String estateId) async {
    debugPrint('ℹ️ [EstateStructureDataSource] getBuildings started, estateId=$estateId');
    try {
      final response = await _supabaseClient
          .from(_buildingsTable)
          .select()
          .eq('estate_id', estateId)
          .order('display_order', ascending: true);

      final list = (response as List)
          .map((json) => BuildingModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();
      debugPrint('✅ [EstateStructureDataSource] getBuildings succeeded, count=${list.length}');
      return list;
    } catch (e) {
      debugPrint('❌ [EstateStructureDataSource] getBuildings failed: $e');
      rethrow;
    }
  }

  @override
  Future<List<StairwellModel>> getStairwells() async {
    debugPrint('ℹ️ [EstateStructureDataSource] getStairwells started');
    try {
      final response = await _supabaseClient
          .from(_stairwellsTable)
          .select()
          .order('display_order', ascending: true);

      final list = (response as List)
          .map((json) => StairwellModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();
      debugPrint('✅ [EstateStructureDataSource] getStairwells succeeded, count=${list.length}');
      return list;
    } catch (e) {
      debugPrint('❌ [EstateStructureDataSource] getStairwells failed: $e');
      rethrow;
    }
  }

  @override
  Future<List<StairwellModel>> getStairwellsForBuilding(String buildingId) async {
    debugPrint('ℹ️ [EstateStructureDataSource] getStairwellsForBuilding started buildingId=$buildingId');
    try {
      final response = await _supabaseClient
          .from(_stairwellsTable)
          .select()
          .eq('building_id', buildingId)
          .order('display_order', ascending: true);

      final list = (response as List)
          .map((json) => StairwellModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();
      debugPrint('✅ [EstateStructureDataSource] getStairwellsForBuilding succeeded, count=${list.length}');
      return list;
    } catch (e) {
      debugPrint('❌ [EstateStructureDataSource] getStairwellsForBuilding failed: $e');
      rethrow;
    }
  }

  @override
  Future<BuildingModel> createBuilding(String estateId, String name, String? address, {String buildingType = 'residential'}) async {
    debugPrint('ℹ️ [EstateStructureDataSource] createBuilding started estateId=$estateId name=$name type=$buildingType');
    try {
      // Get max display_order for this estate
      final maxOrderResponse = await _supabaseClient
          .from(_buildingsTable)
          .select('display_order')
          .eq('estate_id', estateId)
          .order('display_order', ascending: false)
          .limit(1);
      
      final maxOrder = (maxOrderResponse as List).isEmpty 
          ? 0 
          : (maxOrderResponse[0]['display_order'] as int?) ?? 0;

      final response = await _supabaseClient
          .from(_buildingsTable)
          .insert({
            'estate_id': estateId,
            'name': name,
            'address': address,
            'building_type': buildingType,
            'display_order': maxOrder + 1,
          })
          .select()
          .single();

      final building = BuildingModel.fromJson(Map<String, dynamic>.from(response));
      debugPrint('✅ [EstateStructureDataSource] createBuilding succeeded id=${building.id}');
      return building;
    } catch (e) {
      debugPrint('❌ [EstateStructureDataSource] createBuilding failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateBuilding(BuildingModel building) async {
    debugPrint('ℹ️ [EstateStructureDataSource] updateBuilding started id=${building.id}');
    try {
      await _supabaseClient
          .from(_buildingsTable)
          .update({
            'name': building.name,
            'address': building.address,
            'building_type': building.buildingType,
            'display_order': building.displayOrder,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', building.id);
      debugPrint('✅ [EstateStructureDataSource] updateBuilding succeeded id=${building.id}');
    } catch (e) {
      debugPrint('❌ [EstateStructureDataSource] updateBuilding failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteBuilding(String id) async {
    debugPrint('ℹ️ [EstateStructureDataSource] deleteBuilding started id=$id');
    try {
      await _supabaseClient.from(_buildingsTable).delete().eq('id', id);
      debugPrint('✅ [EstateStructureDataSource] deleteBuilding succeeded id=$id');
    } catch (e) {
      debugPrint('❌ [EstateStructureDataSource] deleteBuilding failed: $e');
      rethrow;
    }
  }

  @override
  Future<StairwellModel> createStairwell(
    String buildingId, {
    required String name,
    required int floorMin,
    required int floorMax,
    String? garageEntranceLabel,
  }) async {
    debugPrint('ℹ️ [EstateStructureDataSource] createStairwell started buildingId=$buildingId name=$name floorMin=$floorMin floorMax=$floorMax');
    try {
      // Get max display_order for this building
      final maxOrderResponse = await _supabaseClient
          .from(_stairwellsTable)
          .select('display_order')
          .eq('building_id', buildingId)
          .order('display_order', ascending: false)
          .limit(1);
      
      final maxOrder = (maxOrderResponse as List).isEmpty 
          ? 0 
          : (maxOrderResponse[0]['display_order'] as int?) ?? 0;

      final response = await _supabaseClient
          .from(_stairwellsTable)
          .insert({
            'building_id': buildingId,
            'name': name,
            'floor_min': floorMin,
            'floor_max': floorMax,
            'garage_entrance_label': garageEntranceLabel,
            'display_order': maxOrder + 1,
          })
          .select()
          .single();

      final stairwell = StairwellModel.fromJson(Map<String, dynamic>.from(response));
      debugPrint('✅ [EstateStructureDataSource] createStairwell succeeded id=${stairwell.id}');
      return stairwell;
    } catch (e) {
      debugPrint('❌ [EstateStructureDataSource] createStairwell failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateStairwell(StairwellModel stairwell) async {
    debugPrint('ℹ️ [EstateStructureDataSource] updateStairwell started id=${stairwell.id}');
    try {
      await _supabaseClient
          .from(_stairwellsTable)
          .update({
            'name': stairwell.name,
            'floor_min': stairwell.floorMin,
            'floor_max': stairwell.floorMax,
            'garage_entrance_label': stairwell.garageEntranceLabel,
            'display_order': stairwell.displayOrder,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', stairwell.id);
      debugPrint('✅ [EstateStructureDataSource] updateStairwell succeeded id=${stairwell.id}');
    } catch (e) {
      debugPrint('❌ [EstateStructureDataSource] updateStairwell failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteStairwell(String id) async {
    debugPrint('ℹ️ [EstateStructureDataSource] deleteStairwell started id=$id');
    try {
      await _supabaseClient.from(_stairwellsTable).delete().eq('id', id);
      debugPrint('✅ [EstateStructureDataSource] deleteStairwell succeeded id=$id');
    } catch (e) {
      debugPrint('❌ [EstateStructureDataSource] deleteStairwell failed: $e');
      rethrow;
    }
  }

  @override
  Stream<List<BuildingModel>> watchBuildings(String estateId) {
    debugPrint('ℹ️ [EstateStructureDataSource] watchBuildings subscribed, estateId=$estateId');
    return _supabaseClient
        .from(_buildingsTable)
        .stream(primaryKey: ['id'])
        .eq('estate_id', estateId)
        .order('display_order', ascending: true)
        .map((list) {
          debugPrint('ℹ️ [EstateStructureDataSource] watchBuildings emitted count=${list.length}');
          return list
              .map((json) => BuildingModel.fromJson(Map<String, dynamic>.from(json)))
              .toList();
        })
        .handleError((error) {
          debugPrint('❌ [EstateStructureDataSource] watchBuildings error: $error');
          throw error;
        });
  }

  @override
  Stream<List<StairwellModel>> watchStairwells() {
    debugPrint('ℹ️ [EstateStructureDataSource] watchStairwells subscribed');
    return _supabaseClient
        .from(_stairwellsTable)
        .stream(primaryKey: ['id'])
        .order('display_order', ascending: true)
        .map((list) {
          debugPrint('ℹ️ [EstateStructureDataSource] watchStairwells emitted count=${list.length}');
          return list
              .map((json) => StairwellModel.fromJson(Map<String, dynamic>.from(json)))
              .toList();
        })
        .handleError((error) {
          debugPrint('❌ [EstateStructureDataSource] watchStairwells error: $error');
          throw error;
        });
  }
}
