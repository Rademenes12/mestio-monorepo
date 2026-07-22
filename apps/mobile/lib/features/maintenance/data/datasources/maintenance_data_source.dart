import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/maintenance_schedule_model.dart';

abstract class MaintenanceDataSource {
  Future<List<MaintenanceSchedule>> getSchedules({required String estateId});

  Future<void> createSchedule({
    required String estateId,
    required String name,
    required int frequencyDays,
    required DateTime nextDueDate,
    String? buildingId,
    String? description,
  });

  /// Marks a schedule as performed today and pushes the next due date
  /// forward by [frequencyDays].
  Future<void> markPerformed({required String id, required int frequencyDays});
}

@LazySingleton(as: MaintenanceDataSource)
class MaintenanceDataSourceImpl implements MaintenanceDataSource {
  MaintenanceDataSourceImpl(this._client);

  final SupabaseClient _client;

  static const String _table = 'fixflow_maintenance_schedules';

  String _dateOnly(DateTime d) => d.toIso8601String().split('T').first;

  @override
  Future<List<MaintenanceSchedule>> getSchedules({
    required String estateId,
  }) async {
    try {
      debugPrint('ℹ️ [MaintenanceDataSource] fetching estate=$estateId');
      final response = await _client
          .from(_table)
          .select()
          .eq('estate_id', estateId)
          .order('next_due_date', ascending: true)
          .timeout(const Duration(seconds: 8));
      final rows = (response as List)
          .map(
            (j) => MaintenanceSchedule.fromJson(Map<String, dynamic>.from(j)),
          )
          .toList();
      debugPrint('ℹ️ [MaintenanceDataSource] fetched ${rows.length} rows');
      return rows;
    } catch (e) {
      debugPrint('❌ [MaintenanceDataSource] getSchedules failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> createSchedule({
    required String estateId,
    required String name,
    required int frequencyDays,
    required DateTime nextDueDate,
    String? buildingId,
    String? description,
  }) async {
    try {
      debugPrint('ℹ️ [MaintenanceDataSource] creating schedule: $name');
      await _client
          .from(_table)
          .insert({
            'estate_id': estateId,
            'building_id': buildingId,
            'name': name,
            'description': description ?? '',
            'frequency_days': frequencyDays,
            'next_due_date': _dateOnly(nextDueDate),
          })
          .timeout(const Duration(seconds: 8));
      debugPrint('✅ [MaintenanceDataSource] schedule created');
    } catch (e) {
      debugPrint('❌ [MaintenanceDataSource] createSchedule failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> markPerformed({
    required String id,
    required int frequencyDays,
  }) async {
    try {
      debugPrint('ℹ️ [MaintenanceDataSource] marking performed: $id');
      final today = DateTime.now();
      final nextDue = today.add(Duration(days: frequencyDays));
      await _client
          .from(_table)
          .update({
            'last_performed': _dateOnly(today),
            'next_due_date': _dateOnly(nextDue),
          })
          .eq('id', id)
          .timeout(const Duration(seconds: 8));
      debugPrint(
        '✅ [MaintenanceDataSource] marked performed, next due: $nextDue',
      );
    } catch (e) {
      debugPrint('❌ [MaintenanceDataSource] markPerformed failed: $e');
      rethrow;
    }
  }
}
