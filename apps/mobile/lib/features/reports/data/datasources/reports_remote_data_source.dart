import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/reliability/reliability.dart';
import '../../models/report_model.dart';
import '../../../profiles/models/resident_profile_model.dart';

abstract class ReportsRemoteDataSource {
  Future<List<ReportModel>> getRemoteReports(String estateId);
  Future<void> createRemoteReport(ReportModel report);
  Future<void> updateRemoteReport(ReportModel report);
  Future<void> deleteRemoteReport(String id);
  Future<ResidentProfileModel?> getResidentProfile(String userId);
  Future<void> saveResidentProfile(String userId, ResidentProfileModel profile);

  /// Uploads a photo to Supabase Storage and returns the storage path.
  /// Path convention: {estateId}/{reportId}/{filename}
  Future<String> uploadReportPhoto({
    required File photo,
    required String estateId,
    required String reportId,
  });

  /// Uploads a PDF attachment to the same bucket/path convention as photos.
  Future<String> uploadReportPdf({
    required File pdf,
    required String estateId,
    required String reportId,
  });

  /// Creates a signed URL for a storage path (valid for 1 hour). Works for
  /// any file in the report photos/attachments bucket, not just images.
  Future<String> getReportPhotoUrl(String storagePath);

  /// Records an already-uploaded gallery photo (beyond the single cover
  /// [ReportModel.photoPath]) in `fixflow_report_images`.
  Future<void> addReportImage({
    required String reportId,
    required String storagePath,
  });

  /// Lists gallery image storage paths for a report, oldest first.
  Future<List<String>> getReportImages(String reportId);
}

@LazySingleton(as: ReportsRemoteDataSource)
class ReportsRemoteDataSourceImpl implements ReportsRemoteDataSource {
  ReportsRemoteDataSourceImpl(this._supabaseClient);

  final SupabaseClient _supabaseClient;

  String get _reportsTable => '${AppConfig.supabaseTablePrefix}reports';
  String get _profilesTable =>
      '${AppConfig.supabaseTablePrefix}resident_profiles';

  static const _timeout = Duration(seconds: 10);

  @override
  Future<List<ReportModel>> getRemoteReports(String estateId) async {
    debugPrint(
      'ℹ️ [ReportsRemoteDataSource] getRemoteReports started, estateId=$estateId',
    );
    try {
      // Cap at 500 most-recent reports to bound memory/bandwidth on large estates.
      // Older reports remain accessible via search; UI shows newest first.
      // Wrapped in retry() to survive transient network/5xx errors on cold start.
      final response = await retry(
        () => _supabaseClient
            .from(_reportsTable)
            .select()
            .eq('estate_id', estateId)
            .order('timestamp', ascending: false)
            .limit(500)
            .timeout(_timeout),
      );

      final list = (response as List)
          .map((json) => ReportModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();
      debugPrint(
        '✅ [ReportsRemoteDataSource] getRemoteReports succeeded, count=${list.length}',
      );
      return list;
    } catch (e) {
      debugPrint('❌ [ReportsRemoteDataSource] getRemoteReports failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> createRemoteReport(ReportModel report) async {
    debugPrint(
      'ℹ️ [ReportsRemoteDataSource] createRemoteReport started id=${report.id}',
    );
    try {
      await _supabaseClient
          .from(_reportsTable)
          .insert(report.toJson())
          .timeout(_timeout);
      debugPrint(
        '✅ [ReportsRemoteDataSource] createRemoteReport succeeded id=${report.id}',
      );
    } catch (e) {
      debugPrint('❌ [ReportsRemoteDataSource] createRemoteReport failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateRemoteReport(ReportModel report) async {
    debugPrint(
      'ℹ️ [ReportsRemoteDataSource] updateRemoteReport started id=${report.id}',
    );
    try {
      await _supabaseClient
          .from(_reportsTable)
          .update(report.toJson())
          .eq('id', report.id)
          .timeout(_timeout);
      debugPrint(
        '✅ [ReportsRemoteDataSource] updateRemoteReport succeeded id=${report.id}',
      );
    } catch (e) {
      debugPrint('❌ [ReportsRemoteDataSource] updateRemoteReport failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteRemoteReport(String id) async {
    debugPrint(
      'ℹ️ [ReportsRemoteDataSource] deleteRemoteReport started id=$id',
    );
    try {
      await _supabaseClient
          .from(_reportsTable)
          .delete()
          .eq('id', id)
          .timeout(_timeout);
      debugPrint(
        '✅ [ReportsRemoteDataSource] deleteRemoteReport succeeded id=$id',
      );
    } catch (e) {
      debugPrint('❌ [ReportsRemoteDataSource] deleteRemoteReport failed: $e');
      rethrow;
    }
  }

  @override
  Future<ResidentProfileModel?> getResidentProfile(String userId) async {
    debugPrint(
      'ℹ️ [ReportsRemoteDataSource] getResidentProfile started userId=$userId',
    );
    try {
      final response = await _supabaseClient
          .from(_profilesTable)
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) {
        debugPrint(
          '⚠️ [ReportsRemoteDataSource] getResidentProfile: Profile not found for userId=$userId',
        );
        return null;
      }

      final profile = ResidentProfileModel.fromJson(
        Map<String, dynamic>.from(response),
      );
      debugPrint('✅ [ReportsRemoteDataSource] getResidentProfile succeeded');
      return profile;
    } catch (e) {
      debugPrint('❌ [ReportsRemoteDataSource] getResidentProfile failed: $e');
      // If table doesn't exist yet, return null
      return null;
    }
  }

  @override
  Future<void> saveResidentProfile(
    String userId,
    ResidentProfileModel profile,
  ) async {
    debugPrint(
      'ℹ️ [ReportsRemoteDataSource] saveResidentProfile started userId=$userId',
    );
    try {
      final json = profile.toJson();
      json['id'] = userId; // Map primary key
      await _supabaseClient.from(_profilesTable).upsert(json);
      debugPrint('✅ [ReportsRemoteDataSource] saveResidentProfile succeeded');
    } catch (e) {
      debugPrint('❌ [ReportsRemoteDataSource] saveResidentProfile failed: $e');
      rethrow;
    }
  }

  static const String _photoBucket = 'fixflow-report-photos';
  static const String _imagesTable = 'fixflow_report_images';

  @override
  Future<String> uploadReportPhoto({
    required File photo,
    required String estateId,
    required String reportId,
  }) async {
    debugPrint('ℹ️ [ReportsRemoteDataSource] uploadReportPhoto started');
    try {
      final ext = photo.path.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$ext';
      final storagePath = '$estateId/$reportId/$fileName';

      await _supabaseClient.storage
          .from(_photoBucket)
          .upload(
            storagePath,
            photo,
            fileOptions: const FileOptions(upsert: false),
          );

      debugPrint(
        '✅ [ReportsRemoteDataSource] uploadReportPhoto succeeded: $storagePath',
      );
      return storagePath;
    } catch (e) {
      debugPrint('❌ [ReportsRemoteDataSource] uploadReportPhoto failed: $e');
      rethrow;
    }
  }

  @override
  Future<String> uploadReportPdf({
    required File pdf,
    required String estateId,
    required String reportId,
  }) async {
    debugPrint('ℹ️ [ReportsRemoteDataSource] uploadReportPdf started');
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.pdf';
      final storagePath = '$estateId/$reportId/$fileName';

      await _supabaseClient.storage
          .from(_photoBucket)
          .upload(
            storagePath,
            pdf,
            fileOptions: const FileOptions(
              upsert: false,
              contentType: 'application/pdf',
            ),
          );

      debugPrint(
        '✅ [ReportsRemoteDataSource] uploadReportPdf succeeded: $storagePath',
      );
      return storagePath;
    } catch (e) {
      debugPrint('❌ [ReportsRemoteDataSource] uploadReportPdf failed: $e');
      rethrow;
    }
  }

  @override
  Future<String> getReportPhotoUrl(String storagePath) async {
    debugPrint(
      'ℹ️ [ReportsRemoteDataSource] getReportPhotoUrl for: $storagePath',
    );
    try {
      final url = await _supabaseClient.storage
          .from(_photoBucket)
          .createSignedUrl(storagePath, 3600); // 1 hour validity
      debugPrint('✅ [ReportsRemoteDataSource] getReportPhotoUrl succeeded');
      return url;
    } catch (e) {
      debugPrint('❌ [ReportsRemoteDataSource] getReportPhotoUrl failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> addReportImage({
    required String reportId,
    required String storagePath,
  }) async {
    debugPrint('ℹ️ [ReportsRemoteDataSource] addReportImage report=$reportId');
    try {
      await _supabaseClient
          .from(_imagesTable)
          .insert({'report_id': reportId, 'image_path': storagePath})
          .timeout(_timeout);
      debugPrint('✅ [ReportsRemoteDataSource] addReportImage succeeded');
    } catch (e) {
      debugPrint('❌ [ReportsRemoteDataSource] addReportImage failed: $e');
      rethrow;
    }
  }

  @override
  Future<List<String>> getReportImages(String reportId) async {
    debugPrint('ℹ️ [ReportsRemoteDataSource] getReportImages report=$reportId');
    try {
      final response = await _supabaseClient
          .from(_imagesTable)
          .select('image_path')
          .eq('report_id', reportId)
          .order('created_at', ascending: true)
          .timeout(_timeout);
      final paths = (response as List)
          .map((row) => row['image_path'] as String)
          .toList();
      debugPrint(
        '✅ [ReportsRemoteDataSource] getReportImages succeeded: ${paths.length}',
      );
      return paths;
    } catch (e) {
      debugPrint('❌ [ReportsRemoteDataSource] getReportImages failed: $e');
      rethrow;
    }
  }
}
