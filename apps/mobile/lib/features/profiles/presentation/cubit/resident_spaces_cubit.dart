import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import 'package:mestio/features/profiles/data/datasources/resident_spaces_data_source.dart';
import 'package:mestio/features/profiles/models/resident_space_model.dart';

part 'resident_spaces_cubit.freezed.dart';

@freezed
sealed class ResidentSpacesState with _$ResidentSpacesState {
  const factory ResidentSpacesState.initial() = Initial;
  const factory ResidentSpacesState.loading() = Loading;
  const factory ResidentSpacesState.loaded({required List<ResidentSpaceModel> spaces}) = Loaded;
  const factory ResidentSpacesState.error({required String errorKey}) = Error;
}

@injectable
class ResidentSpacesCubit extends Cubit<ResidentSpacesState> {
  ResidentSpacesCubit(this._dataSource) : super(const ResidentSpacesState.initial());

  final ResidentSpacesDataSource _dataSource;

  Future<void> loadSpaces({required String userId, required String estateId}) async {
    emit(const ResidentSpacesState.loading());
    try {
      final spaces = await _dataSource.getSpaces(userId, estateId);
      emit(ResidentSpacesState.loaded(spaces: spaces));
    } catch (e) {
      debugPrint('❌ [ResidentSpacesCubit] loadSpaces error: $e');
      emit(const ResidentSpacesState.error(errorKey: 'spaces_load_failed'));
    }
  }

  Future<void> addSpace({
    required String userId,
    required String estateId,
    required String type,
    required String label,
  }) async {
    final current = state;
    if (current is! Loaded) return;

    final temp = ResidentSpaceModel(
      id: '',
      userId: userId,
      estateId: estateId,
      type: type,
      label: label,
    );

    try {
      final created = await _dataSource.addSpace(temp);
      final updated = [...current.spaces, created];
      emit(ResidentSpacesState.loaded(spaces: updated));
    } catch (e) {
      debugPrint('❌ [ResidentSpacesCubit] addSpace error: $e');
      emit(ResidentSpacesState.error(errorKey: 'spaces_add_failed'));
      emit(ResidentSpacesState.loaded(spaces: current.spaces));
    }
  }

  Future<void> deleteSpace(String id) async {
    final current = state;
    if (current is! Loaded) return;

    final previous = current.spaces;
    final filtered = previous.where((s) => s.id != id).toList();
    emit(ResidentSpacesState.loaded(spaces: filtered));

    try {
      await _dataSource.deleteSpace(id);
    } catch (e) {
      debugPrint('❌ [ResidentSpacesCubit] deleteSpace error: $e');
      emit(ResidentSpacesState.loaded(spaces: previous));
      emit(ResidentSpacesState.error(errorKey: 'spaces_delete_failed'));
    }
  }
}
