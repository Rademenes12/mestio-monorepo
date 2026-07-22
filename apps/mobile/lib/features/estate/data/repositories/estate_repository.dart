import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/estate_model.dart';
import '../datasources/estate_data_source.dart';

/// Owns the user's estate membership state and exposes the list of estates and
/// the currently-active estate as streams so multiple screens stay in sync
/// without manual refresh.
abstract class EstateRepository {
  /// All estates the current user belongs to.
  Stream<List<Estate>> watchEstates();

  /// The currently active estate (first admin estate, else first, else null).
  Stream<Estate?> watchActiveEstate();

  Future<void> loadEstates();
  Future<String> createEstate(String name);
  Future<String?> getActiveInvitationCode(String estateId, {String role = 'resident'});
  Future<String> createInvitationCode(String estateId, {String role = 'resident'});

  /// Validates a code before redeeming it, to learn the role + estate name.
  Future<Map<String, dynamic>> peekInvitationCode(String code);

  /// Redeems a code. Reloads memberships and activates the estate only when
  /// the result is an immediate join (residents); staff roles go to
  /// [fixflow_join_requests] pending office approval instead.
  Future<Map<String, dynamic>> redeemInvitationCode(
    String code, {
    String? building,
    String? stairwell,
    String? floor,
    String? apartment,
    String? info,
  });

  Future<Map<String, dynamic>?> getMyPendingJoinRequest();
  Future<List<Map<String, dynamic>>> getPendingJoinRequests(String estateId);
  Future<void> approveJoinRequest(String requestId);
  Future<void> rejectJoinRequest(String requestId);
  Future<DateTime?> getContractValidUntil(String estateId);
  Future<Map<String, dynamic>?> getHealthIndex(String estateId);

  void setActiveEstate(String estateId);
}

@LazySingleton(as: EstateRepository)
class EstateRepositoryImpl implements EstateRepository {
  EstateRepositoryImpl(this._dataSource);

  final EstateDataSource _dataSource;

  final _estatesSubject = BehaviorSubject<List<Estate>>.seeded(const []);
  final _activeEstateSubject = BehaviorSubject<Estate?>.seeded(null);

  @override
  Stream<List<Estate>> watchEstates() => _estatesSubject.stream;

  @override
  Stream<Estate?> watchActiveEstate() => _activeEstateSubject.stream;

  @override
  Future<void> loadEstates() async {
    final rows = await _dataSource.getMyEstates();
    final estates = rows.map(_mapMembershipRow).whereType<Estate>().toList();
    _estatesSubject.add(estates);
    _recomputeActiveEstate(estates);
  }

  // Maps a joined membership row { role, fixflow_estates: {...} } to an Estate.
  Estate? _mapMembershipRow(Map<String, dynamic> row) {
    final estateJson = row['fixflow_estates'];
    if (estateJson is! Map<String, dynamic>) return null;
    return Estate.fromJson({
      ...estateJson,
      'role': row['role'] ?? 'resident',
    });
  }

  // Prefer an estate the user administers; otherwise the first one.
  void _recomputeActiveEstate(List<Estate> estates) {
    if (estates.isEmpty) {
      _activeEstateSubject.add(null);
      return;
    }
    final current = _activeEstateSubject.valueOrNull;
    if (current != null) {
      final stillValid = estates.where((e) => e.id == current.id).firstOrNull;
      if (stillValid != null) {
        _activeEstateSubject.add(stillValid);
        return;
      }
    }
    final admin = estates.where((e) => e.role == 'admin').firstOrNull;
    _activeEstateSubject.add(admin ?? estates.first);
  }

  @override
  Future<String> createEstate(String name) async {
    final id = await _dataSource.createEstate(name);
    await loadEstates();
    setActiveEstate(id);
    return id;
  }

  @override
  Future<String?> getActiveInvitationCode(String estateId, {String role = 'resident'}) {
    return _dataSource.getActiveInvitationCode(estateId, role: role);
  }

  @override
  Future<String> createInvitationCode(String estateId, {String role = 'resident'}) {
    return _dataSource.createEstateInvitationCode(estateId, role: role);
  }

  @override
  Future<Map<String, dynamic>> peekInvitationCode(String code) {
    return _dataSource.peekInvitationCode(code);
  }

  @override
  Future<Map<String, dynamic>> redeemInvitationCode(
    String code, {
    String? building,
    String? stairwell,
    String? floor,
    String? apartment,
    String? info,
  }) async {
    final result = await _dataSource.redeemInvitationCode(
      code,
      building: building,
      stairwell: stairwell,
      floor: floor,
      apartment: apartment,
      info: info,
    );
    // Only an immediate join creates a membership row; pending requests
    // don't, so there's nothing to reload/activate yet.
    if (result['status'] == 'joined') {
      await loadEstates();
      setActiveEstate(result['estate_id'] as String);
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>?> getMyPendingJoinRequest() {
    return _dataSource.getMyPendingJoinRequest();
  }

  @override
  Future<List<Map<String, dynamic>>> getPendingJoinRequests(String estateId) {
    return _dataSource.getPendingJoinRequests(estateId);
  }

  @override
  Future<void> approveJoinRequest(String requestId) {
    return _dataSource.approveJoinRequest(requestId);
  }

  @override
  Future<void> rejectJoinRequest(String requestId) {
    return _dataSource.rejectJoinRequest(requestId);
  }

  @override
  Future<DateTime?> getContractValidUntil(String estateId) {
    return _dataSource.getContractValidUntil(estateId);
  }

  @override
  Future<Map<String, dynamic>?> getHealthIndex(String estateId) {
    return _dataSource.getHealthIndex(estateId);
  }

  @override
  void setActiveEstate(String estateId) {
    final match = _estatesSubject.valueOrNull
        ?.where((e) => e.id == estateId)
        .firstOrNull;
    if (match != null) {
      _activeEstateSubject.add(match);
    } else {
      debugPrint('⚠️ [EstateRepository] setActiveEstate: unknown id $estateId');
    }
  }
}
