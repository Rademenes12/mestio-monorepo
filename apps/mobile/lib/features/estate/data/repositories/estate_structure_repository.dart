import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import '../../../reports/models/building_model.dart';
import '../datasources/estate_structure_data_source.dart';

abstract class EstateStructureRepository {
  Stream<List<BuildingWithStairwells>> watchEstateStructure(String estateId);
  Future<List<BuildingWithStairwells>> getEstateStructure(String estateId);
  Future<BuildingModel> addBuilding(String estateId, String name, String? address, {String buildingType = 'residential'});
  Future<void> updateBuilding(BuildingModel building);
  Future<void> deleteBuilding(String id);
  Future<StairwellModel> addStairwell(
    String buildingId, {
    required String name,
    required int floorMin,
    required int floorMax,
    String? garageEntranceLabel,
  });
  Future<void> updateStairwell(StairwellModel stairwell);
  Future<void> deleteStairwell(String id);
}

@LazySingleton(as: EstateStructureRepository)
class EstateStructureRepositoryImpl implements EstateStructureRepository {
  EstateStructureRepositoryImpl(this._dataSource);

  final EstateStructureDataSource _dataSource;

  @override
  Stream<List<BuildingWithStairwells>> watchEstateStructure(String estateId) {
    debugPrint('ℹ️ [EstateStructureRepository] watchEstateStructure subscribed, estateId=$estateId');
    
    return Rx.combineLatest2(
      _dataSource.watchBuildings(estateId),
      _dataSource.watchStairwells(),
      (List<BuildingModel> buildings, List<StairwellModel> stairwells) {
        debugPrint('ℹ️ [EstateStructureRepository] combineLatest2 received buildings=${buildings.length}, stairwells=${stairwells.length}');
        return _combineData(buildings, stairwells);
      },
    ).handleError((error) {
      debugPrint('❌ [EstateStructureRepository] watchEstateStructure error: $error');
      throw error;
    });
  }

  @override
  Future<List<BuildingWithStairwells>> getEstateStructure(String estateId) async {
    debugPrint('ℹ️ [EstateStructureRepository] getEstateStructure started, estateId=$estateId');
    try {
      final buildings = await _dataSource.getBuildings(estateId);
      final stairwells = await _dataSource.getStairwells();
      final result = _combineData(buildings, stairwells);
      debugPrint('✅ [EstateStructureRepository] getEstateStructure succeeded, buildings=${result.length}');
      return result;
    } catch (e) {
      debugPrint('❌ [EstateStructureRepository] getEstateStructure failed: $e');
      rethrow;
    }
  }

  List<BuildingWithStairwells> _combineData(
    List<BuildingModel> buildings,
    List<StairwellModel> stairwells,
  ) {
    final stairwellsByBuilding = <String, List<StairwellModel>>{};
    for (final stairwell in stairwells) {
      stairwellsByBuilding
          .putIfAbsent(stairwell.buildingId, () => [])
          .add(stairwell);
    }

    return buildings.map((building) {
      return BuildingWithStairwells(
        building: building,
        stairwells: stairwellsByBuilding[building.id] ?? [],
      );
    }).toList();
  }

  @override
  Future<BuildingModel> addBuilding(String estateId, String name, String? address, {String buildingType = 'residential'}) async {
    debugPrint('ℹ️ [EstateStructureRepository] addBuilding started estateId=$estateId name=$name type=$buildingType');
    try {
      final building = await _dataSource.createBuilding(estateId, name, address, buildingType: buildingType);
      debugPrint('✅ [EstateStructureRepository] addBuilding succeeded id=${building.id}');
      return building;
    } catch (e) {
      debugPrint('❌ [EstateStructureRepository] addBuilding failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateBuilding(BuildingModel building) async {
    debugPrint('ℹ️ [EstateStructureRepository] updateBuilding started id=${building.id}');
    try {
      await _dataSource.updateBuilding(building);
      debugPrint('✅ [EstateStructureRepository] updateBuilding succeeded');
    } catch (e) {
      debugPrint('❌ [EstateStructureRepository] updateBuilding failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteBuilding(String id) async {
    debugPrint('ℹ️ [EstateStructureRepository] deleteBuilding started id=$id');
    try {
      await _dataSource.deleteBuilding(id);
      debugPrint('✅ [EstateStructureRepository] deleteBuilding succeeded');
    } catch (e) {
      debugPrint('❌ [EstateStructureRepository] deleteBuilding failed: $e');
      rethrow;
    }
  }

  @override
  Future<StairwellModel> addStairwell(
    String buildingId, {
    required String name,
    required int floorMin,
    required int floorMax,
    String? garageEntranceLabel,
  }) async {
    debugPrint('ℹ️ [EstateStructureRepository] addStairwell started buildingId=$buildingId name=$name');
    try {
      final stairwell = await _dataSource.createStairwell(
        buildingId,
        name: name,
        floorMin: floorMin,
        floorMax: floorMax,
        garageEntranceLabel: garageEntranceLabel,
      );
      debugPrint('✅ [EstateStructureRepository] addStairwell succeeded id=${stairwell.id}');
      return stairwell;
    } catch (e) {
      debugPrint('❌ [EstateStructureRepository] addStairwell failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateStairwell(StairwellModel stairwell) async {
    debugPrint('ℹ️ [EstateStructureRepository] updateStairwell started id=${stairwell.id}');
    try {
      await _dataSource.updateStairwell(stairwell);
      debugPrint('✅ [EstateStructureRepository] updateStairwell succeeded');
    } catch (e) {
      debugPrint('❌ [EstateStructureRepository] updateStairwell failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteStairwell(String id) async {
    debugPrint('ℹ️ [EstateStructureRepository] deleteStairwell started id=$id');
    try {
      await _dataSource.deleteStairwell(id);
      debugPrint('✅ [EstateStructureRepository] deleteStairwell succeeded');
    } catch (e) {
      debugPrint('❌ [EstateStructureRepository] deleteStairwell failed: $e');
      rethrow;
    }
  }
}
