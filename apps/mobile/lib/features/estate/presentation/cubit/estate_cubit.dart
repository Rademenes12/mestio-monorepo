import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/error_messages.dart';
import '../../data/repositories/estate_repository.dart';
import '../../models/estate_model.dart';

part 'estate_cubit.freezed.dart';

@freezed
sealed class EstateState with _$EstateState {
  const factory EstateState.initial() = EstateInitial;
  const factory EstateState.loading() = EstateLoading;
  const factory EstateState.loaded({
    required List<Estate> estates,
    Estate? activeEstate,
    @Default(false) bool isSubmitting,
    String? errorKey,
  }) = EstateLoaded;
  const factory EstateState.error({required String errorKey}) = EstateError;
}

@injectable
class EstateMembershipCubit extends Cubit<EstateState> {
  EstateMembershipCubit(this._repository)
      : super(const EstateState.initial()) {
    _subscribe();
    _load();
  }

  final EstateRepository _repository;
  StreamSubscription<List<Estate>>? _estatesSub;
  StreamSubscription<Estate?>? _activeSub;

  @override
  Future<void> close() {
    _estatesSub?.cancel();
    _activeSub?.cancel();
    return super.close();
  }

  List<Estate> _estates = const [];
  Estate? _active;

  void _subscribe() {
    _estatesSub = _repository.watchEstates().listen((estates) {
      _estates = estates;
      _emitLoaded();
    });
    _activeSub = _repository.watchActiveEstate().listen((active) {
      _active = active;
      _emitLoaded();
    });
  }

  void _emitLoaded() {
    if (isClosed) return;
    final current = state;
    // Preserve transient submit/error flags when re-emitting from stream updates.
    final isSubmitting = current is EstateLoaded ? current.isSubmitting : false;
    final errorKey = current is EstateLoaded ? current.errorKey : null;
    emit(EstateState.loaded(
      estates: _estates,
      activeEstate: _active,
      isSubmitting: isSubmitting,
      errorKey: errorKey,
    ));
  }

  Future<void> _load() async {
    if (state is! EstateInitial && state is! EstateError) return;
    emit(const EstateState.loading());
    try {
      await _repository.loadEstates();
      if (isClosed) return;
      // Stream listeners emit the loaded state.
      _emitLoaded();
    } catch (e) {
      debugPrint('❌ [EstateMembershipCubit] load failed: $e');
      if (isClosed) return;
      emit(const EstateState.error(errorKey: 'estate_load_error'));
    }
  }

  /// Safe to call multiple times.
  Future<void> retry() => _load();

  Future<bool> createEstate(String name) async {
    _setSubmitting(true);
    try {
      await _repository.createEstate(name);
      _setSubmitting(false);
      return true;
    } catch (e) {
      debugPrint('❌ [EstateMembershipCubit] createEstate failed: $e');
      _setSubmitting(false, errorKey: 'estate_create_error');
      return false;
    }
  }

  /// Validates a code before redeeming it (registration step 0), so the
  /// wizard learns the role + estate WITHOUT the user picking a role.
  /// Returns null (and sets errorKey) if the code is invalid/expired.
  Future<Map<String, dynamic>?> peekCode(String code) async {
    _setSubmitting(true);
    try {
      final result = await _repository.peekInvitationCode(code);
      _setSubmitting(false);
      return result;
    } catch (e) {
      debugPrint('❌ [EstateMembershipCubit] peekCode failed: $e');
      _setSubmitting(false, errorKey: mapErrorToKey(e));
      return null;
    }
  }

  /// Redeems a code. Role/limits/approval routing are decided server-side.
  /// Returns the RPC result {status, estate_id, role} or null on failure.
  Future<Map<String, dynamic>?> redeemCode(
    String code, {
    String? building,
    String? stairwell,
    String? floor,
    String? apartment,
    String? info,
  }) async {
    _setSubmitting(true);
    try {
      final result = await _repository.redeemInvitationCode(
        code,
        building: building,
        stairwell: stairwell,
        floor: floor,
        apartment: apartment,
        info: info,
      );
      _setSubmitting(false);
      return result;
    } catch (e) {
      // User already belongs to the estate behind this code — treat as
      // success since the desired outcome (membership) is already true.
      if (e.toString().contains('already_member')) {
        debugPrint('ℹ️ [EstateMembershipCubit] redeemCode: already a member, treating as success');
        await _repository.loadEstates();
        _setSubmitting(false);
        return const {'status': 'joined'};
      }
      debugPrint('❌ [EstateMembershipCubit] redeemCode failed: $e');
      _setSubmitting(false, errorKey: mapErrorToKey(e));
      return null;
    }
  }

  /// The caller's own pending join request (staff role awaiting office
  /// approval), if any.
  Future<Map<String, dynamic>?> checkPendingRequest() {
    return _repository.getMyPendingJoinRequest();
  }

  void selectEstate(String estateId) =>
      _repository.setActiveEstate(estateId);

  void _setSubmitting(bool value, {String? errorKey}) {
    final current = state;
    if (current is EstateLoaded) {
      emit(current.copyWith(isSubmitting: value, errorKey: errorKey));
    } else {
      emit(EstateState.loaded(
        estates: _estates,
        activeEstate: _active,
        isSubmitting: value,
        errorKey: errorKey,
      ));
    }
  }
}
