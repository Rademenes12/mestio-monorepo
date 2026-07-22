import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';
import '../../features/reports/data/datasources/reports_local_data_source.dart';
import '../../features/reports/data/datasources/reports_remote_data_source.dart';
import '../../features/reports/models/report_model.dart';
import 'connectivity_service.dart';

/// Offline queue for reports. Stores reports locally and uploads when online.
@LazySingleton()
class ReportOutbox {
  ReportOutbox(
    this._localDataSource,
    this._remoteDataSource,
    this._connectivity,
  );

  final ReportsLocalDataSource _localDataSource;
  final ReportsRemoteDataSource _remoteDataSource;
  final ConnectivityService _connectivity;

  Database? _db;
  StreamSubscription<bool>? _connectivitySubscription;
  bool _isProcessing = false;
  bool _initialized = false;

  static const _tableName = 'report_outbox';

  /// Whether the device is currently online.
  bool get isOnline => _connectivity.isOnline;

  Future<void> init() async {
    if (_initialized) return;
    _db = await _localDataSource.database;
    await _ensureTable();
    
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((online) {
      if (online) {
        _processQueue();
      }
    });

    // Process any pending items on startup if online
    if (_connectivity.isOnline) {
      _processQueue();
    }
    
    _initialized = true;
  }

  Future<void> _ensureTable() async {
    await _db!.execute('''
      CREATE TABLE IF NOT EXISTS $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        report_json TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        retry_count INTEGER DEFAULT 0
      )
    ''');
  }

  /// Enqueues a report for upload. Returns immediately.
  Future<void> enqueue(ReportModel report) async {
    if (_db == null) {
      await init();
    }
    
    await _db!.insert(
      _tableName,
      {
        'report_json': jsonEncode(report.toJson()),
        'created_at': DateTime.now().millisecondsSinceEpoch,
        'retry_count': 0,
      },
    );
    debugPrint('Report enqueued (total: ${await pendingCount()})');

    if (_connectivity.isOnline && !_isProcessing) {
      _processQueue();
    }
  }

  /// Returns count of pending reports.
  Future<int> pendingCount() async {
    if (_db == null) return 0;
    final result = await _db!.rawQuery('SELECT COUNT(*) as count FROM $_tableName');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Processes the queue, uploading pending reports.
  Future<void> _processQueue() async {
    if (_isProcessing || _db == null) return;
    _isProcessing = true;

    try {
      while (_connectivity.isOnline) {
        final pending = await _getPending();
        if (pending.isEmpty) break;

        for (final item in pending) {
          try {
            debugPrint('Uploading queued report ${item['id']}...');
            final reportJson = jsonDecode(item['report_json'] as String);
            final report = ReportModel.fromJson(reportJson);
            await _remoteDataSource.createRemoteReport(report);
            await _db!.delete(_tableName, where: 'id = ?', whereArgs: [item['id']]);
            debugPrint('Queued report ${item['id']} uploaded successfully');
          } catch (e) {
            debugPrint('Failed to upload queued report ${item['id']}: $e');
            await _db!.update(
              _tableName,
              {'retry_count': (item['retry_count'] as int) + 1},
              where: 'id = ?',
              whereArgs: [item['id']],
            );
            // Stop processing on failure to avoid hammering the server
            break;
          }
        }
      }
    } finally {
      _isProcessing = false;
    }
  }

  Future<List<Map<String, dynamic>>> _getPending() async {
    return _db!.query(
      _tableName,
      where: 'retry_count < ?',
      whereArgs: [3], // Max 3 retries
      orderBy: 'created_at ASC',
      limit: 10,
    );
  }

  void dispose() {
    _connectivitySubscription?.cancel();
  }
}
