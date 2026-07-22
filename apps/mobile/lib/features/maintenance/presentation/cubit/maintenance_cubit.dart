import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../data/repositories/maintenance_repository.dart';
import '../../models/maintenance_schedule_model.dart';

part 'maintenance_cubit.freezed.dart';

@freezed
sealed class MaintenanceState with _$MaintenanceState {
  const factory MaintenanceState.initial() = MaintenanceInitial;
  const factory MaintenanceState.loading() = MaintenanceLoading;
  const factory MaintenanceState.loaded({
    required List<MaintenanceSchedule> schedules,
    @Default(false) bool isSubmitting,
    String? errorKey,
  }) = MaintenanceLoaded;
  const factory MaintenanceState.error({required String errorKey}) =
      MaintenanceError;
}

@injectable
class MaintenanceCubit extends Cubit<MaintenanceState> {
  MaintenanceCubit(this._repository) : super(const MaintenanceState.initial());

  final MaintenanceRepository _repository;
  StreamSubscription<List<MaintenanceSchedule>>? _sub;
  String? _estateId;

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }

  /// Idempotent: calling it again for the same estate while already loaded
  /// is a no-op, matching ReportCommentsCubit.load's guard.
  void load(String estateId) {
    if (_estateId == estateId && state is MaintenanceLoaded) return;
    _estateId = estateId;
    _sub?.cancel();
    _sub = _repository.watchSchedules().listen((items) {
      final current = state;
      final submitting = current is MaintenanceLoaded
          ? current.isSubmitting
          : false;
      emit(MaintenanceState.loaded(schedules: items, isSubmitting: submitting));
    });
    _refresh();
  }

  Future<void> _refresh() async {
    final estateId = _estateId;
    if (estateId == null) return;
    if (state is! MaintenanceLoaded) {
      emit(const MaintenanceState.loading());
    }
    try {
      await _repository.refresh(estateId: estateId);
    } catch (e) {
      debugPrint('❌ [MaintenanceCubit] load failed: $e');
      emit(const MaintenanceState.error(errorKey: 'maintenance_load_error'));
    }
  }

  Future<void> retry() => _refresh();

  Future<bool> create({
    required String name,
    required int frequencyDays,
    required DateTime nextDueDate,
    String? description,
  }) async {
    final estateId = _estateId;
    if (estateId == null) return false;
    final current = state;
    if (current is MaintenanceLoaded) {
      emit(current.copyWith(isSubmitting: true, errorKey: null));
    }
    try {
      await _repository.create(
        estateId: estateId,
        name: name,
        frequencyDays: frequencyDays,
        nextDueDate: nextDueDate,
        description: description,
      );
      final after = state;
      if (after is MaintenanceLoaded) {
        emit(after.copyWith(isSubmitting: false));
      }
      return true;
    } catch (e) {
      debugPrint('❌ [MaintenanceCubit] create failed: $e');
      final after = state;
      if (after is MaintenanceLoaded) {
        emit(
          after.copyWith(
            isSubmitting: false,
            errorKey: 'maintenance_create_error',
          ),
        );
      }
      return false;
    }
  }

  Future<void> markPerformed(String id, int frequencyDays) async {
    final current = state;
    if (current is MaintenanceLoaded) {
      emit(current.copyWith(isSubmitting: true, errorKey: null));
    }
    try {
      await _repository.markPerformed(id: id, frequencyDays: frequencyDays);
      final after = state;
      if (after is MaintenanceLoaded) {
        emit(after.copyWith(isSubmitting: false));
      }
    } catch (e) {
      debugPrint('❌ [MaintenanceCubit] markPerformed failed: $e');
      final after = state;
      if (after is MaintenanceLoaded) {
        emit(
          after.copyWith(
            isSubmitting: false,
            errorKey: 'maintenance_mark_error',
          ),
        );
      }
    }
  }
}
