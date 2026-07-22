import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../estate/data/repositories/estate_repository.dart';
import '../../../estate/models/estate_model.dart';
import '../../data/repositories/announcements_repository.dart';
import '../../models/announcement_model.dart';

part 'announcements_cubit.freezed.dart';

@freezed
sealed class AnnouncementsState with _$AnnouncementsState {
  const factory AnnouncementsState.initial() = AnnouncementsInitial;
  const factory AnnouncementsState.loading() = AnnouncementsLoading;
  const factory AnnouncementsState.loaded({
    required List<Announcement> announcements,
    @Default(false) bool isSubmitting,
    String? errorKey,
  }) = AnnouncementsLoaded;
  const factory AnnouncementsState.error({required String errorKey}) =
      AnnouncementsError;
}

@injectable
class AnnouncementsCubit extends Cubit<AnnouncementsState> {
  AnnouncementsCubit(this._repository, this._estateRepository)
      : super(const AnnouncementsState.initial()) {
    _subscribe();
    _load();
  }

  final AnnouncementsRepository _repository;
  final EstateRepository _estateRepository;
  StreamSubscription<List<Announcement>>? _annSub;
  StreamSubscription<Estate?>? _estateSub;
  String? _activeEstateId;

  @override
  Future<void> close() {
    _annSub?.cancel();
    _estateSub?.cancel();
    return super.close();
  }

  void _subscribe() {
    _annSub = _repository.watchAnnouncements().listen((items) {
      final current = state;
      final submitting =
          current is AnnouncementsLoaded ? current.isSubmitting : false;
      emit(AnnouncementsState.loaded(
        announcements: items,
        isSubmitting: submitting,
      ));
    });
    _estateSub = _estateRepository.watchActiveEstate().listen((estate) {
      _activeEstateId = estate?.id;
      _load();
    });
  }

  Future<void> _load() async {
    if (state is! AnnouncementsLoaded) {
      emit(const AnnouncementsState.loading());
    }
    try {
      await _repository.refresh(estateId: _activeEstateId);
    } catch (e) {
      debugPrint('❌ [AnnouncementsCubit] load failed: $e');
      emit(const AnnouncementsState.error(
        errorKey: 'announcements_load_error',
      ));
    }
  }

  Future<void> retry() => _load();

  Future<bool> create({
    required String title,
    required String content,
    required String authorName,
    required String authorRole,
    String? targetLabel,
    DateTime? expiresAt,
    String scopeType = 'estate',
    String? scopeBuildingId,
    String? scopeStairwellId,
  }) async {
    final current = state;
    if (current is AnnouncementsLoaded) {
      emit(current.copyWith(isSubmitting: true, errorKey: null));
    }
    try {
      await _repository.create(
        title: title,
        content: content,
        authorName: authorName,
        authorRole: authorRole,
        targetLabel: targetLabel,
        estateId: _activeEstateId,
        expiresAt: expiresAt,
        scopeType: scopeType,
        scopeBuildingId: scopeBuildingId,
        scopeStairwellId: scopeStairwellId,
      );
      final after = state;
      if (after is AnnouncementsLoaded) {
        emit(after.copyWith(isSubmitting: false));
      }
      return true;
    } catch (e) {
      debugPrint('❌ [AnnouncementsCubit] create failed: $e');
      final after = state;
      if (after is AnnouncementsLoaded) {
        emit(after.copyWith(
          isSubmitting: false,
          errorKey: 'announcement_create_error',
        ));
      }
      return false;
    }
  }

  Future<void> delete(String id) async {
    try {
      await _repository.softDelete(id);
    } catch (e) {
      debugPrint('❌ [AnnouncementsCubit] delete failed: $e');
      final current = state;
      if (current is AnnouncementsLoaded) {
        emit(current.copyWith(errorKey: 'announcement_delete_error'));
      }
    }
  }
}
