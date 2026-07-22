import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../estate/data/repositories/estate_repository.dart';
import '../../../estate/models/estate_model.dart';
import '../../data/repositories/resolutions_repository.dart';
import '../../models/resolution_model.dart';

part 'resolutions_cubit.freezed.dart';

@freezed
sealed class ResolutionsState with _$ResolutionsState {
  const factory ResolutionsState.initial() = ResolutionsInitial;
  const factory ResolutionsState.loading() = ResolutionsLoading;
  const factory ResolutionsState.loaded({
    required List<Resolution> resolutions,
    @Default(false) bool isSubmitting,
    String? errorKey,
  }) = ResolutionsLoaded;
  const factory ResolutionsState.error({required String errorKey}) =
      ResolutionsError;
}

@injectable
class ResolutionsCubit extends Cubit<ResolutionsState> {
  ResolutionsCubit(this._repository, this._estateRepository)
      : super(const ResolutionsState.initial()) {
    _subscribe();
  }

  final ResolutionsRepository _repository;
  final EstateRepository _estateRepository;
  StreamSubscription<List<Resolution>>? _resSub;
  StreamSubscription<Estate?>? _estateSub;
  String? _activeEstateId;

  @override
  Future<void> close() {
    _resSub?.cancel();
    _estateSub?.cancel();
    return super.close();
  }

  void _subscribe() {
    _resSub = _repository.watchResolutions().listen((items) {
      final current = state;
      final submitting =
          current is ResolutionsLoaded ? current.isSubmitting : false;
      emit(ResolutionsState.loaded(
        resolutions: items,
        isSubmitting: submitting,
      ));
    });
    _estateSub = _estateRepository.watchActiveEstate().listen((estate) {
      _activeEstateId = estate?.id;
      _load();
    });
  }

  Future<void> _load() async {
    final estateId = _activeEstateId;
    if (estateId == null) {
      return;
    }
    if (state is! ResolutionsLoaded) {
      emit(const ResolutionsState.loading());
    }
    try {
      await _repository.refresh(estateId: estateId);
    } catch (e) {
      debugPrint('❌ [ResolutionsCubit] load failed: $e');
      emit(const ResolutionsState.error(errorKey: 'resolutions_load_error'));
    }
  }

  Future<void> retry() => _load();

  Future<void> vote(String resolutionId, String choice) async {
    final current = state;
    if (current is ResolutionsLoaded) {
      emit(current.copyWith(isSubmitting: true, errorKey: null));
    }
    try {
      await _repository.castVote(resolutionId: resolutionId, choice: choice);
      final after = state;
      if (after is ResolutionsLoaded) {
        emit(after.copyWith(isSubmitting: false));
      }
    } catch (e) {
      debugPrint('❌ [ResolutionsCubit] vote failed: $e');
      final after = state;
      if (after is ResolutionsLoaded) {
        emit(after.copyWith(
          isSubmitting: false,
          errorKey: 'resolution_vote_error',
        ));
      }
    }
  }

  Future<bool> create({
    required String title,
    String? description,
    DateTime? deadline,
  }) async {
    final estateId = _activeEstateId;
    if (estateId == null) return false;
    final current = state;
    if (current is ResolutionsLoaded) {
      emit(current.copyWith(isSubmitting: true, errorKey: null));
    }
    try {
      await _repository.create(
        estateId: estateId,
        title: title,
        description: description,
        deadline: deadline,
      );
      final after = state;
      if (after is ResolutionsLoaded) {
        emit(after.copyWith(isSubmitting: false));
      }
      return true;
    } catch (e) {
      debugPrint('❌ [ResolutionsCubit] create failed: $e');
      final after = state;
      if (after is ResolutionsLoaded) {
        emit(after.copyWith(
          isSubmitting: false,
          errorKey: 'resolution_create_error',
        ));
      }
      return false;
    }
  }

  Future<void> closeResolution(String id, {required bool passed}) async {
    final current = state;
    if (current is ResolutionsLoaded) {
      emit(current.copyWith(isSubmitting: true, errorKey: null));
    }
    try {
      await _repository.close(id: id, status: passed ? 'passed' : 'rejected');
      final after = state;
      if (after is ResolutionsLoaded) {
        emit(after.copyWith(isSubmitting: false));
      }
    } catch (e) {
      debugPrint('❌ [ResolutionsCubit] closeResolution failed: $e');
      final after = state;
      if (after is ResolutionsLoaded) {
        emit(after.copyWith(
          isSubmitting: false,
          errorKey: 'resolution_close_error',
        ));
      }
    }
  }
}
