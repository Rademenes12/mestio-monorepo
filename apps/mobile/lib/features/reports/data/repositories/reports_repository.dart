import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/report_model.dart';
import '../../../profiles/models/resident_profile_model.dart';
import '../datasources/reports_local_data_source.dart';
import '../datasources/reports_remote_data_source.dart';

abstract class ReportsRepository {
  Stream<List<ReportModel>> watchReports();
  Future<void> refreshReports();
  Future<void> addReport(ReportModel report);
  Future<void> updateReport(ReportModel report);
  Future<void> deleteReport(String id);
  Future<void> syncOfflineReports();
  Future<ResidentProfileModel?> getResidentProfile(String userId);
  Future<void> saveResidentProfile(String userId, ResidentProfileModel profile);

  /// Sets the active estate ID for filtering reports.
  void setActiveEstateId(String? estateId);

  /// Returns the current active estate ID.
  String? get activeEstateId;

  /// Uploads a photo to Supabase Storage and returns the storage path.
  Future<String> uploadReportPhoto({
    required String localPath,
    required String estateId,
    required String reportId,
  });

  /// Uploads a PDF attachment to Supabase Storage and returns the storage path.
  Future<String> uploadReportPdf({
    required String localPath,
    required String estateId,
    required String reportId,
  });

  /// Creates a signed URL for viewing a photo or PDF (valid for 1 hour).
  Future<String> getReportPhotoUrl(String storagePath);

  /// Records an already-uploaded gallery photo in `fixflow_report_images`.
  Future<void> addReportImage({
    required String reportId,
    required String storagePath,
  });

  /// Lists gallery image storage paths for a report, oldest first.
  Future<List<String>> getReportImages(String reportId);
}

@LazySingleton(as: ReportsRepository)
class ReportsRepositoryImpl implements ReportsRepository {
  ReportsRepositoryImpl(this._localDataSource, this._remoteDataSource) {
    // Initial load from cache
    _loadInitialCache();
  }

  final ReportsLocalDataSource _localDataSource;
  final ReportsRemoteDataSource _remoteDataSource;

  final BehaviorSubject<List<ReportModel>> _reportsSubject =
      BehaviorSubject<List<ReportModel>>.seeded(const []);

  static const String _profileLocalPref = 'cached_resident_profile';

  String? _activeEstateId;

  @override
  String? get activeEstateId => _activeEstateId;

  @override
  void setActiveEstateId(String? estateId) {
    if (_activeEstateId != estateId) {
      _activeEstateId = estateId;
      debugPrint('ℹ️ [ReportsRepository] activeEstateId changed to $estateId');
    }
  }

  Future<void> _loadInitialCache() async {
    try {
      final cached = await _localDataSource.getCachedReports();
      _reportsSubject.add(cached);
    } catch (e) {
      debugPrint('⚠️ [ReportsRepository] failed to load initial cache: $e');
    }
  }

  @override
  Stream<List<ReportModel>> watchReports() => _reportsSubject.stream;

  @override
  Future<void> refreshReports() async {
    debugPrint(
      'ℹ️ [ReportsRepository] refreshReports started, estateId=$_activeEstateId',
    );

    if (_activeEstateId == null) {
      debugPrint(
        '⚠️ [ReportsRepository] no active estate, emitting empty list',
      );
      _reportsSubject.add(const []);
      return;
    }

    // 1. Emit cached content first (filtered by estate)
    final cached = await _localDataSource.getCachedReports();
    final cachedFiltered = cached
        .where((r) => r.estateId == _activeEstateId)
        .toList();
    _reportsSubject.add(cachedFiltered);

    // 2. Try fetching from remote with timeout
    try {
      final remote = await _remoteDataSource
          .getRemoteReports(_activeEstateId!)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              debugPrint(
                '⚠️ [ReportsRepository] refreshReports remote timeout',
              );
              return <ReportModel>[];
            },
          );

      if (remote.isNotEmpty) {
        // Update local database with remote reports for this estate
        // Clear only reports for this estate, then re-add
        for (final report in cachedFiltered) {
          await _localDataSource.deleteCachedReport(report.id);
        }
        for (final report in remote) {
          // Since it comes from Supabase, mark as synced
          final syncedReport = report.copyWith(isSynced: true);
          await _localDataSource.cacheReport(syncedReport);
        }

        _reportsSubject.add(
          remote.map((r) => r.copyWith(isSynced: true)).toList(),
        );
        debugPrint(
          '✅ [ReportsRepository] refreshReports succeeded, count=${remote.length}',
        );
      }
    } catch (e) {
      debugPrint('⚠️ [ReportsRepository] refreshReports failed (offline?): $e');
      // Keep emitting local cache on failure (silent fallback)
    }
  }

  @override
  Future<void> addReport(ReportModel report) async {
    debugPrint('ℹ️ [ReportsRepository] addReport started id=${report.id}');
    // 1. Save to local SQLite cache as unsynced
    final localReport = report.copyWith(isSynced: false);
    await _localDataSource.cacheReport(localReport);
    _reportsSubject.add(await _localDataSource.getCachedReports());

    // 2. Try to sync to remote Supabase
    try {
      await _remoteDataSource.createRemoteReport(localReport);

      // Mark local as synced
      final syncedReport = localReport.copyWith(isSynced: true);
      await _localDataSource.cacheReport(syncedReport);
      _reportsSubject.add(await _localDataSource.getCachedReports());
      debugPrint(
        '✅ [ReportsRepository] addReport synced immediately id=${report.id}',
      );
    } catch (e) {
      debugPrint(
        '⚠️ [ReportsRepository] addReport remote sync failed, left unsynced: $e',
      );
      // Left as isSynced: false, will be synced later
    }
  }

  @override
  Future<void> updateReport(ReportModel report) async {
    debugPrint('ℹ️ [ReportsRepository] updateReport started id=${report.id}');
    // 1. Save to local cache as unsynced
    final localReport = report.copyWith(isSynced: false);
    await _localDataSource.cacheReport(localReport);
    _reportsSubject.add(await _localDataSource.getCachedReports());

    // 2. Try updating remote
    try {
      await _remoteDataSource.updateRemoteReport(localReport);

      // Mark local as synced
      final syncedReport = localReport.copyWith(isSynced: true);
      await _localDataSource.cacheReport(syncedReport);
      _reportsSubject.add(await _localDataSource.getCachedReports());
      debugPrint('✅ [ReportsRepository] updateReport synced id=${report.id}');
    } catch (e) {
      debugPrint('⚠️ [ReportsRepository] updateReport remote sync failed: $e');
    }
  }

  @override
  Future<void> deleteReport(String id) async {
    debugPrint('ℹ️ [ReportsRepository] deleteReport started id=$id');
    // 1. Delete from local cache
    await _localDataSource.deleteCachedReport(id);
    _reportsSubject.add(await _localDataSource.getCachedReports());

    // 2. Try deleting from remote
    try {
      await _remoteDataSource.deleteRemoteReport(id);
      debugPrint('✅ [ReportsRepository] deleteReport remote succeeded id=$id');
    } catch (e) {
      debugPrint('⚠️ [ReportsRepository] deleteReport remote failed: $e');
    }
  }

  @override
  Future<void> syncOfflineReports() async {
    debugPrint('ℹ️ [ReportsRepository] syncOfflineReports started');
    try {
      final cached = await _localDataSource.getCachedReports();
      final unsynced = cached.where((report) => !report.isSynced).toList();

      if (unsynced.isEmpty) {
        debugPrint('ℹ️ [ReportsRepository] no unsynced reports found');
        return;
      }

      debugPrint(
        'ℹ️ [ReportsRepository] syncing ${unsynced.length} unsynced reports',
      );
      for (final report in unsynced) {
        try {
          await _remoteDataSource.createRemoteReport(report);

          final syncedReport = report.copyWith(isSynced: true);
          await _localDataSource.cacheReport(syncedReport);
          debugPrint('✅ [ReportsRepository] synced report id=${report.id}');
        } catch (e) {
          debugPrint(
            '⚠️ [ReportsRepository] failed to sync report id=${report.id}: $e',
          );
        }
      }

      _reportsSubject.add(await _localDataSource.getCachedReports());
    } catch (e) {
      debugPrint('❌ [ReportsRepository] syncOfflineReports failed: $e');
    }
  }

  @override
  Future<ResidentProfileModel?> getResidentProfile(String userId) async {
    debugPrint(
      'ℹ️ [ReportsRepository] getResidentProfile started userId=$userId',
    );
    final prefs = await SharedPreferences.getInstance();

    // Remote-first: server-side changes (role, verification) must reach the
    // app. A cache-first strategy served stale profiles forever - e.g. a user
    // verified or promoted by the office never saw the change.
    try {
      final remoteProfile = await _remoteDataSource
          .getResidentProfile(userId)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              debugPrint(
                '⚠️ [ReportsRepository] getResidentProfile remote timeout',
              );
              return null;
            },
          );
      if (remoteProfile != null) {
        // Cache locally for offline fallback
        await prefs.setString(
          '${_profileLocalPref}_$userId',
          jsonEncode(remoteProfile.toJson()),
        );
        debugPrint(
          '✅ [ReportsRepository] getResidentProfile from remote succeeded and cached',
        );
        return remoteProfile;
      }
    } catch (e) {
      debugPrint('⚠️ [ReportsRepository] getResidentProfile remote failed: $e');
    }

    // Offline / remote failure: fall back to the last cached profile.
    final localJson = prefs.getString('${_profileLocalPref}_$userId');
    if (localJson != null) {
      try {
        final profile = ResidentProfileModel.fromJson(
          Map<String, dynamic>.from(jsonDecode(localJson)),
        );
        debugPrint(
          '✅ [ReportsRepository] getResidentProfile from local succeeded',
        );
        return profile;
      } catch (e) {
        debugPrint('⚠️ [ReportsRepository] failed to parse cached profile: $e');
      }
    }

    return null;
  }

  @override
  Future<void> saveResidentProfile(
    String userId,
    ResidentProfileModel profile,
  ) async {
    debugPrint('ℹ️ [ReportsRepository] saveResidentProfile started');
    // 1. Cache locally
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      '${_profileLocalPref}_$userId',
      jsonEncode(profile.toJson()),
    );

    // 2. Try to save remote
    try {
      await _remoteDataSource.saveResidentProfile(userId, profile);
      debugPrint('✅ [ReportsRepository] saveResidentProfile remote succeeded');
    } catch (e) {
      debugPrint(
        '⚠️ [ReportsRepository] saveResidentProfile remote failed (will rely on local cache): $e',
      );
      // Do not rethrow, local cache is saved
    }
  }

  @override
  Future<String> uploadReportPhoto({
    required String localPath,
    required String estateId,
    required String reportId,
  }) async {
    debugPrint('ℹ️ [ReportsRepository] uploadReportPhoto started');
    final file = File(localPath);
    return _remoteDataSource.uploadReportPhoto(
      photo: file,
      estateId: estateId,
      reportId: reportId,
    );
  }

  @override
  Future<String> uploadReportPdf({
    required String localPath,
    required String estateId,
    required String reportId,
  }) async {
    debugPrint('ℹ️ [ReportsRepository] uploadReportPdf started');
    final file = File(localPath);
    return _remoteDataSource.uploadReportPdf(
      pdf: file,
      estateId: estateId,
      reportId: reportId,
    );
  }

  @override
  Future<String> getReportPhotoUrl(String storagePath) {
    return _remoteDataSource.getReportPhotoUrl(storagePath);
  }

  @override
  Future<void> addReportImage({
    required String reportId,
    required String storagePath,
  }) {
    return _remoteDataSource.addReportImage(
      reportId: reportId,
      storagePath: storagePath,
    );
  }

  @override
  Future<List<String>> getReportImages(String reportId) {
    return _remoteDataSource.getReportImages(reportId);
  }
}
