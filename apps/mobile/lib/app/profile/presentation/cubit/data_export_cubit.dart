import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../features/estate/data/repositories/estate_repository.dart';
import '../../../../features/profiles/data/repositories/shared_user_repository.dart';
import '../../../../features/reports/data/repositories/reports_repository.dart';
import '../../../../shared/error_messages.dart';

part 'data_export_cubit.freezed.dart';

@freezed
abstract class DataExportState with _$DataExportState {
  const factory DataExportState({
    @Default(false) bool isLoading,
    String? errorKey,
    String? successKey,
  }) = _DataExportState;
}

@injectable
class DataExportCubit extends Cubit<DataExportState> {
  DataExportCubit(
    this._reportsRepository,
    this._sharedUserRepository,
    this._estateRepository,
  ) : super(const DataExportState());

  final ReportsRepository _reportsRepository;
  final SharedUserRepository _sharedUserRepository;
  final EstateRepository _estateRepository;

  Future<void> exportData({
    required String userId,
    required String email,
  }) async {
    if (state.isLoading) return;

    emit(state.copyWith(isLoading: true, errorKey: null, successKey: null));

    try {
      final data = <String, dynamic>{
        'exportedAt': DateTime.now().toIso8601String(),
        'appName': 'Mestio',
        'userId': userId,
        'email': email,
      };

      try {
        final sharedUser = await _sharedUserRepository.getSharedUser(userId);
        if (sharedUser != null) {
          data['firstName'] = sharedUser.firstName;
        }
      } catch (_) {
        data['profileWarning'] = 'Could not load shared user profile';
      }

      try {
        final estates = await _estateRepository.watchEstates().first;
        data['estates'] = estates.map((e) => {
          'id': e.id,
          'name': e.name,
          'role': e.role,
        }).toList();
      } catch (_) {
        data['estatesWarning'] = 'Could not load estate memberships';
      }

      try {
        final reports = await _reportsRepository.watchReports().first;
        data['reports'] = reports.map((r) => <String, dynamic>{
          'id': r.id,
          'title': r.title,
          'description': r.description,
          'category': r.category,
          'status': r.status,
          'priority': r.priority,
          'csatRating': r.csatRating,
          'timestamp': r.timestamp,
        }).toList();
      } catch (_) {
        data['reportsWarning'] = 'Could not load reports';
      }

      await Clipboard.setData(ClipboardData(
        text: const JsonEncoder.withIndent('  ').convert(data),
      ));

      emit(state.copyWith(isLoading: false, successKey: 'data_exported'));
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorKey: mapErrorToKey(error)));
    }
  }

  void clearFeedback() {
    if (state.errorKey == null && state.successKey == null) return;
    emit(state.copyWith(errorKey: null, successKey: null));
  }
}
