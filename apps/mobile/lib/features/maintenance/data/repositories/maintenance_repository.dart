import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/maintenance_schedule_model.dart';
import '../datasources/maintenance_data_source.dart';

abstract class MaintenanceRepository {
  Stream<List<MaintenanceSchedule>> watchSchedules();

  Future<void> refresh({required String estateId});

  Future<void> create({
    required String estateId,
    required String name,
    required int frequencyDays,
    required DateTime nextDueDate,
    String? buildingId,
    String? description,
  });

  Future<void> markPerformed({required String id, required int frequencyDays});
}

@LazySingleton(as: MaintenanceRepository)
class MaintenanceRepositoryImpl implements MaintenanceRepository {
  MaintenanceRepositoryImpl(this._dataSource);

  final MaintenanceDataSource _dataSource;
  final BehaviorSubject<List<MaintenanceSchedule>> _subject =
      BehaviorSubject<List<MaintenanceSchedule>>.seeded(const []);

  String? _lastEstateId;

  @override
  Stream<List<MaintenanceSchedule>> watchSchedules() => _subject.stream;

  @override
  Future<void> refresh({required String estateId}) async {
    _lastEstateId = estateId;
    try {
      final items = await _dataSource.getSchedules(estateId: estateId);
      _subject.add(items);
    } catch (e) {
      debugPrint('❌ [MaintenanceRepository] refresh failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> create({
    required String estateId,
    required String name,
    required int frequencyDays,
    required DateTime nextDueDate,
    String? buildingId,
    String? description,
  }) async {
    await _dataSource.createSchedule(
      estateId: estateId,
      name: name,
      frequencyDays: frequencyDays,
      nextDueDate: nextDueDate,
      buildingId: buildingId,
      description: description,
    );
    await refresh(estateId: estateId);
  }

  @override
  Future<void> markPerformed({
    required String id,
    required int frequencyDays,
  }) async {
    await _dataSource.markPerformed(id: id, frequencyDays: frequencyDays);
    final estateId = _lastEstateId;
    if (estateId != null) {
      await refresh(estateId: estateId);
    }
  }
}
