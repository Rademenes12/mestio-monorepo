import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../../estate/data/repositories/estate_structure_repository.dart';
import '../../models/building_model.dart';

part 'estate_cubit.freezed.dart';

@freezed
sealed class EstateState with _$EstateState {
  const factory EstateState.initial() = EstateInitial;
  const factory EstateState.loading() = EstateLoading;
  const factory EstateState.loaded({
    required List<BuildingWithStairwells> buildings,
    @Default(false) bool isSubmitting,
    String? errorKey,
  }) = EstateLoaded;
  const factory EstateState.error({required String errorKey}) = EstateError;
}

@injectable
class EstateCubit extends Cubit<EstateState> {
  EstateCubit(this._repository) : super(const EstateState.initial());

  final EstateStructureRepository _repository;
  StreamSubscription<List<BuildingWithStairwells>>? _subscription;
  bool _isOfflineMode = false; // Track offline mode
  List<BuildingWithStairwells> _localBuildings = []; // Store local buildings
  String? _currentEstateId;

  /// Sets the active estate ID and loads the estate structure.
  /// Must be called before the cubit can load data.
  Future<void> setEstateId(String estateId) async {
    _currentEstateId = estateId;
    await _init();
  }

  Future<void> _init() async {
    if (_currentEstateId == null) {
      debugPrint('⚠️ [EstateCubit] no estate ID set, waiting for setEstateId()');
      return;
    }

    debugPrint('ℹ️ [EstateCubit] initializing, loading estate structure for estate=$_currentEstateId');
    emit(const EstateState.loading());
    
    try {
      // Hard timeout prevents the Zarząd dashboard from getting stuck on a
      // spinner if Supabase/PostgREST is slow or hangs (sesja 2 / C).
      final buildings = await _repository
          .getEstateStructure(_currentEstateId!)
          .timeout(const Duration(seconds: 10));
      debugPrint('ℹ️ [EstateCubit] loaded buildings count=${buildings.length}');
      _isOfflineMode = false;
      _localBuildings = buildings;
      emit(EstateState.loaded(buildings: buildings));
      
      // TODO: Dodać stream subscription później gdy rozwiążemy problem
      // _subscription = _repository.watchEstateStructure(_currentEstateId!).listen(...);
    } catch (error) {
      debugPrint('❌ [EstateCubit] load error: $error');
      debugPrint('❌ [EstateCubit] error type: ${error.runtimeType}');
      
      // TYMCZASOWE: Gdy Supabase nie działa, użyj lokalnych danych
      if (error.toString().contains('PGRST002') || 
          error.toString().contains('Service Unavailable')) {
        debugPrint('⚠️ [EstateCubit] Supabase unavailable, using local fallback data');
        
        _isOfflineMode = true;
        // Lokalne dane testowe
        _localBuildings = [
          BuildingWithStairwells(
            building: const BuildingModel(
              id: 'local-1',
              name: 'Budynek 1', 
              address: 'ul. Przykładowa 1',
              displayOrder: 1,
            ),
            stairwells: const [
              StairwellModel(
                id: 'local-1-a',
                buildingId: 'local-1',
                name: 'A',
                floorMin: 0,
                floorMax: 4,
                displayOrder: 1,
              ),
              StairwellModel(
                id: 'local-1-b',
                buildingId: 'local-1',
                name: 'B',
                floorMin: 0,
                floorMax: 4,
                displayOrder: 2,
              ),
            ],
          ),
          BuildingWithStairwells(
            building: const BuildingModel(
              id: 'local-2',
              name: 'Budynek 2',
              address: 'ul. Przykładowa 2',
              displayOrder: 2,
            ),
            stairwells: const [
              StairwellModel(
                id: 'local-2-a',
                buildingId: 'local-2',
                name: 'A',
                floorMin: 0,
                floorMax: 2,
                displayOrder: 1,
              ),
            ],
          ),
        ];
        
        emit(EstateState.loaded(
          buildings: _localBuildings,
          errorKey: 'using_local_data', // Info że używamy lokalnych danych
        ));
        return;
      }
      
      emit(const EstateState.error(errorKey: 'estate_load_error'));
    }
  }

  Future<void> retry() async {
    debugPrint('ℹ️ [EstateCubit] retry called');
    await _subscription?.cancel();
    await _init();
  }

  Future<void> addBuilding(String name, String? address, {String buildingType = 'residential'}) async {
    final currentState = state;
    if (currentState is! EstateLoaded) return;

    debugPrint('ℹ️ [EstateCubit] addBuilding name=$name type=$buildingType, offlineMode=$_isOfflineMode');
    emit(currentState.copyWith(isSubmitting: true, errorKey: null));

    try {
      if (_isOfflineMode) {
        // W trybie offline dodaj tylko lokalnie
        final newBuilding = BuildingModel(
          id: 'local-${DateTime.now().millisecondsSinceEpoch}',
          name: name,
          address: address,
          buildingType: buildingType,
          displayOrder: _localBuildings.length + 1,
        );
        
        _localBuildings = [
          ..._localBuildings,
          BuildingWithStairwells(
            building: newBuilding,
            stairwells: const [],
          ),
        ];
        
        debugPrint('✅ [EstateCubit] addBuilding succeeded (offline mode)');
        emit(EstateState.loaded(
          buildings: _localBuildings,
          errorKey: 'using_local_data',
        ));
      } else {
        await _repository.addBuilding(_currentEstateId!, name, address, buildingType: buildingType);
        debugPrint('✅ [EstateCubit] addBuilding succeeded');
        // Reload data after successful add
        final buildings = await _repository.getEstateStructure(_currentEstateId!);
        _localBuildings = buildings;
        emit(EstateState.loaded(buildings: buildings));
      }
    } catch (e) {
      debugPrint('❌ [EstateCubit] addBuilding failed: $e');
      emit(currentState.copyWith(
        isSubmitting: false,
        errorKey: _mapBuildingError(e),
      ));
    }
  }

  String _mapBuildingError(Object error) {
    final message = error.toString().toLowerCase();
    if (message.contains('42501') || message.contains('row-level security')) {
      return 'building_add_rls_error';
    }
    if (message.contains('pgrst002') ||
        message.contains('service unavailable') ||
        message.contains('socketexception') ||
        message.contains('network') ||
        message.contains('connection')) {
      return 'network_error';
    }
    return 'building_add_error';
  }

  Future<void> updateBuilding(BuildingModel building) async {
    final currentState = state;
    if (currentState is! EstateLoaded) return;

    debugPrint('ℹ️ [EstateCubit] updateBuilding id=${building.id}, offlineMode=$_isOfflineMode');
    emit(currentState.copyWith(isSubmitting: true, errorKey: null));

    try {
      if (_isOfflineMode) {
        // W trybie offline zaktualizuj tylko lokalnie
        _localBuildings = _localBuildings.map((bws) {
          if (bws.building.id == building.id) {
            return bws.copyWith(building: building);
          }
          return bws;
        }).toList();
        
        debugPrint('✅ [EstateCubit] updateBuilding succeeded (offline mode)');
        emit(EstateState.loaded(
          buildings: _localBuildings,
          errorKey: 'using_local_data',
        ));
      } else {
        await _repository.updateBuilding(building);
        debugPrint('✅ [EstateCubit] updateBuilding succeeded');
        // Reload data after successful update
        final buildings = await _repository.getEstateStructure(_currentEstateId!);
        _localBuildings = buildings;
        emit(EstateState.loaded(buildings: buildings));
      }
    } catch (e) {
      debugPrint('❌ [EstateCubit] updateBuilding failed: $e');
      emit(currentState.copyWith(isSubmitting: false, errorKey: 'building_update_error'));
    }
  }

  Future<void> deleteBuilding(String id) async {
    final currentState = state;
    if (currentState is! EstateLoaded) return;

    debugPrint('ℹ️ [EstateCubit] deleteBuilding id=$id, offlineMode=$_isOfflineMode');
    emit(currentState.copyWith(isSubmitting: true, errorKey: null));

    try {
      if (_isOfflineMode) {
        // W trybie offline usuń tylko lokalnie
        _localBuildings = _localBuildings.where((bws) => bws.building.id != id).toList();
        
        debugPrint('✅ [EstateCubit] deleteBuilding succeeded (offline mode)');
        emit(EstateState.loaded(
          buildings: _localBuildings,
          errorKey: 'using_local_data',
        ));
      } else {
        await _repository.deleteBuilding(id);
        debugPrint('✅ [EstateCubit] deleteBuilding succeeded');
        // Reload data after successful delete
        final buildings = await _repository.getEstateStructure(_currentEstateId!);
        _localBuildings = buildings;
        emit(EstateState.loaded(buildings: buildings));
      }
    } catch (e) {
      debugPrint('❌ [EstateCubit] deleteBuilding failed: $e');
      emit(currentState.copyWith(isSubmitting: false, errorKey: 'building_delete_error'));
    }
  }

  Future<void> addStairwell(
    String buildingId, {
    required String name,
    required int floorMin,
    required int floorMax,
    String? garageEntranceLabel,
  }) async {
    final currentState = state;
    if (currentState is! EstateLoaded) return;

    debugPrint('ℹ️ [EstateCubit] addStairwell buildingId=$buildingId name=$name floorMin=$floorMin floorMax=$floorMax, offlineMode=$_isOfflineMode');
    emit(currentState.copyWith(isSubmitting: true, errorKey: null));

    try {
      if (_isOfflineMode) {
        // W trybie offline dodaj tylko lokalnie
        final newStairwell = StairwellModel(
          id: 'local-s-${DateTime.now().millisecondsSinceEpoch}',
          buildingId: buildingId,
          name: name,
          floorMin: floorMin,
          floorMax: floorMax,
          garageEntranceLabel: garageEntranceLabel,
          displayOrder: _localBuildings
              .firstWhere((bws) => bws.building.id == buildingId)
              .stairwells.length + 1,
        );
        
        _localBuildings = _localBuildings.map((bws) {
          if (bws.building.id == buildingId) {
            return bws.copyWith(stairwells: [...bws.stairwells, newStairwell]);
          }
          return bws;
        }).toList();
        
        debugPrint('✅ [EstateCubit] addStairwell succeeded (offline mode)');
        emit(EstateState.loaded(
          buildings: _localBuildings,
          errorKey: 'using_local_data',
        ));
      } else {
        await _repository.addStairwell(
          buildingId,
          name: name,
          floorMin: floorMin,
          floorMax: floorMax,
          garageEntranceLabel: garageEntranceLabel,
        );
        debugPrint('✅ [EstateCubit] addStairwell succeeded');
        // Reload data after successful add
        final buildings = await _repository.getEstateStructure(_currentEstateId!);
        _localBuildings = buildings;
        emit(EstateState.loaded(buildings: buildings));
      }
    } catch (e) {
      debugPrint('❌ [EstateCubit] addStairwell failed: $e');
      emit(currentState.copyWith(isSubmitting: false, errorKey: _mapStairwellError(e)));
    }
  }

  String _mapStairwellError(Object error) {
    final message = error.toString().toLowerCase();
    if (message.contains('42501') || message.contains('row-level security')) {
      return 'stairwell_add_rls_error';
    }
    if (message.contains('pgrst002') ||
        message.contains('service unavailable') ||
        message.contains('socketexception') ||
        message.contains('network') ||
        message.contains('connection')) {
      return 'network_error';
    }
    return 'stairwell_add_error';
  }

  Future<void> updateStairwell(StairwellModel stairwell) async {
    final currentState = state;
    if (currentState is! EstateLoaded) return;

    debugPrint('ℹ️ [EstateCubit] updateStairwell id=${stairwell.id}, offlineMode=$_isOfflineMode');
    emit(currentState.copyWith(isSubmitting: true, errorKey: null));

    try {
      if (_isOfflineMode) {
        // W trybie offline zaktualizuj tylko lokalnie
        _localBuildings = _localBuildings.map((bws) {
          if (bws.building.id == stairwell.buildingId) {
            final updatedStairwells = bws.stairwells.map((s) {
              if (s.id == stairwell.id) {
                return stairwell;
              }
              return s;
            }).toList();
            return bws.copyWith(stairwells: updatedStairwells);
          }
          return bws;
        }).toList();
        
        debugPrint('✅ [EstateCubit] updateStairwell succeeded (offline mode)');
        emit(EstateState.loaded(
          buildings: _localBuildings,
          errorKey: 'using_local_data',
        ));
      } else {
        await _repository.updateStairwell(stairwell);
        debugPrint('✅ [EstateCubit] updateStairwell succeeded');
        // Reload data after successful update
        final buildings = await _repository.getEstateStructure(_currentEstateId!);
        _localBuildings = buildings;
        emit(EstateState.loaded(buildings: buildings));
      }
    } catch (e) {
      debugPrint('❌ [EstateCubit] updateStairwell failed: $e');
      emit(currentState.copyWith(isSubmitting: false, errorKey: 'stairwell_update_error'));
    }
  }

  Future<void> deleteStairwell(String id) async {
    final currentState = state;
    if (currentState is! EstateLoaded) return;

    debugPrint('ℹ️ [EstateCubit] deleteStairwell id=$id, offlineMode=$_isOfflineMode');
    emit(currentState.copyWith(isSubmitting: true, errorKey: null));

    try {
      if (_isOfflineMode) {
        // W trybie offline usuń tylko lokalnie - znajdź budynek który ma tę klatkę
        _localBuildings = _localBuildings.map((bws) {
          final hasStairwell = bws.stairwells.any((s) => s.id == id);
          if (hasStairwell) {
            final updatedStairwells = bws.stairwells.where((s) => s.id != id).toList();
            return bws.copyWith(stairwells: updatedStairwells);
          }
          return bws;
        }).toList();
        
        debugPrint('✅ [EstateCubit] deleteStairwell succeeded (offline mode)');
        emit(EstateState.loaded(
          buildings: _localBuildings,
          errorKey: 'using_local_data',
        ));
      } else {
        await _repository.deleteStairwell(id);
        debugPrint('✅ [EstateCubit] deleteStairwell succeeded');
        // Reload data after successful delete
        final buildings = await _repository.getEstateStructure(_currentEstateId!);
        _localBuildings = buildings;
        emit(EstateState.loaded(buildings: buildings));
      }
    } catch (e) {
      debugPrint('❌ [EstateCubit] deleteStairwell failed: $e');
      emit(currentState.copyWith(isSubmitting: false, errorKey: 'stairwell_delete_error'));
    }
  }

  @override
  Future<void> close() {
    debugPrint('ℹ️ [EstateCubit] close called, canceling subscription');
    _subscription?.cancel();
    return super.close();
  }
}
