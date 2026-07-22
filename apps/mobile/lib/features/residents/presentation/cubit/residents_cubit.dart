import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../data/repositories/residents_repository.dart';
import '../../models/resident_model.dart';
import '../../../estate/data/repositories/estate_repository.dart';
import '../../../estate/models/estate_model.dart';

part 'residents_cubit.freezed.dart';

@freezed
sealed class ResidentsState with _$ResidentsState {
  const factory ResidentsState.initial() = ResidentsInitial;
  const factory ResidentsState.loading() = ResidentsLoading;
  const factory ResidentsState.loaded({
    required List<ResidentModel> residents,
    @Default(false) bool visibleToBoard,
  }) = ResidentsLoaded;
  const factory ResidentsState.error({required String errorKey}) = ResidentsError;
}

@injectable
class ResidentsCubit extends Cubit<ResidentsState> {
  ResidentsCubit(this._repository, this._estateRepository) 
      : super(const ResidentsState.initial()) {
    _subscribeToEstate();
  }

  final ResidentsRepository _repository;
  final EstateRepository _estateRepository;
  List<ResidentModel> _localResidents = [];
  String? _currentEstateId;
  bool _hasLoadedOnce = false;
  StreamSubscription<Estate?>? _estateSubscription;

  @override
  Future<void> close() {
    _estateSubscription?.cancel();
    return super.close();
  }

  void _subscribeToEstate() {
    _estateSubscription = _estateRepository.watchActiveEstate().listen((estate) {
      final newEstateId = estate?.id;
      // `!_hasLoadedOnce` guards against the edge case where the very first
      // stream emission already equals the initial `null` estate id, which
      // would otherwise skip loading entirely (e.g. user has no estate yet).
      if (newEstateId != _currentEstateId || !_hasLoadedOnce) {
        _hasLoadedOnce = true;
        _currentEstateId = newEstateId;
        _loadResidents();
      }
    });
  }

  Future<void> _loadResidents() async {
    if (_currentEstateId == null) {
      debugPrint('⚠️ [ResidentsCubit] no active estate, emitting empty list');
      emit(const ResidentsState.loaded(residents: [], visibleToBoard: false));
      return;
    }

    debugPrint('ℹ️ [ResidentsCubit] loading residents for estate=$_currentEstateId');
    emit(const ResidentsState.loading());
    
    try {
      final residents = await _repository.getResidents(_currentEstateId!);
      
      // TODO: Load visibleToBoard from permissions table
      final visibleToBoard = false; // Default
      
      _localResidents = residents;
      
      debugPrint('ℹ️ [ResidentsCubit] loaded ${residents.length} residents');
      emit(ResidentsState.loaded(
        residents: residents, 
        visibleToBoard: visibleToBoard,
      ));
    } catch (e) {
      debugPrint('❌ [ResidentsCubit] load error: $e');
      
      // Fallback: use local test data when Supabase is unavailable
      if (e.toString().contains('PGRST002') || e.toString().contains('Service Unavailable')) {
        debugPrint('⚠️ [ResidentsCubit] Using local fallback data');
        _localResidents = [
          const ResidentModel(
            id: 'local-1',
            userId: 'test-user-1',
            firstName: 'Jan',
            lastName: 'Kowalski',
            email: 'jan.kowalski@example.com',
            phone: '+48 601 234 567',
            apartmentNumber: 'M12',
          ),
          const ResidentModel(
            id: 'local-2',
            userId: 'test-user-2',
            firstName: 'Anna',
            lastName: 'Nowak',
            email: 'anna.nowak@example.com',
            phone: '+48 602 345 678',
            apartmentNumber: 'M34',
          ),
          const ResidentModel(
            id: 'local-3',
            userId: 'test-user-3',
            firstName: 'Piotr',
            lastName: 'Wiśniewski',
            email: 'piotr.wisniewski@example.com',
            phone: '+48 603 456 789',
            apartmentNumber: 'M56',
          ),
        ];
        emit(ResidentsState.loaded(
          residents: _localResidents,
          visibleToBoard: false,
        ));
        return;
      }
      
      emit(const ResidentsState.error(errorKey: 'residents_load_error'));
    }
  }

  Future<void> refresh() async {
    await _loadResidents();
  }

  void toggleBoardVisibility() {
    final currentState = state;
    if (currentState is! ResidentsLoaded) return;
    
    final newVisibility = !currentState.visibleToBoard;
    debugPrint('ℹ️ [ResidentsCubit] toggling board visibility to: $newVisibility');
    
    // TODO: Save to permissions table
    emit(currentState.copyWith(visibleToBoard: newVisibility));
  }
}