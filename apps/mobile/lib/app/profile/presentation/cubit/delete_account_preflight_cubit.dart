import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../features/profiles/data/repositories/shared_user_apps_repository.dart';
import '../../../../features/profiles/models/shared_user_app_model.dart';
import '../../../../shared/error_messages.dart';

part 'delete_account_preflight_cubit.freezed.dart';

@freezed
sealed class DeleteAccountPreflightState
    with _$DeleteAccountPreflightState {
  const factory DeleteAccountPreflightState.loading() =
      DeleteAccountPreflightLoading;
  const factory DeleteAccountPreflightState.loaded({
    required List<SharedUserAppModel> otherApps,
  }) = DeleteAccountPreflightLoaded;
  const factory DeleteAccountPreflightState.error({
    required String errorKey,
  }) = DeleteAccountPreflightError;
}

@injectable
class DeleteAccountPreflightCubit
    extends Cubit<DeleteAccountPreflightState> {
  DeleteAccountPreflightCubit(this._sharedUserAppsRepository)
    : super(const DeleteAccountPreflightState.loading()) {
    _loadOtherApps();
  }

  final SharedUserAppsRepository _sharedUserAppsRepository;

  Future<void> _loadOtherApps() async {
    try {
      final otherApps = await _sharedUserAppsRepository.getOtherApps();
      emit(DeleteAccountPreflightState.loaded(otherApps: otherApps));
    } catch (error) {
      debugPrint(
        '❌ [DeleteAccountPreflightCubit] _loadOtherApps error: $error',
      );
      emit(
        DeleteAccountPreflightState.error(errorKey: mapErrorToKey(error)),
      );
    }
  }

  Future<void> retry() async {
    emit(const DeleteAccountPreflightState.loading());
    await _loadOtherApps();
  }
}
