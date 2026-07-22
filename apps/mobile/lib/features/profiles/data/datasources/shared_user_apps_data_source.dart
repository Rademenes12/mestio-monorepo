import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SharedUserAppsDataSource {
  /// Whether the app identity placeholders have been replaced.
  bool get isConfigured;

  /// The current app's unique identifier.
  String get appId;

  /// The current app's display name.
  String get appName;

  Future<void> upsertCurrentApp({required String userId});

  Future<List<Map<String, dynamic>>> getOtherApps();
}

@LazySingleton(as: SharedUserAppsDataSource)
class SupabaseSharedUserAppsDataSource implements SharedUserAppsDataSource {
  SupabaseSharedUserAppsDataSource(this._supabaseClient);

  final SupabaseClient _supabaseClient;

  // Provided during setup.
  static const _appId = 'fixflow_';
  static const _appName = 'Mestio';

  @override
  bool get isConfigured => _appId != '<app_id>' && _appName != '<app_name>';

  @override
  String get appId => _appId;

  @override
  String get appName => _appName;

  @override
  Future<void> upsertCurrentApp({required String userId}) async {
    debugPrint(
      'ℹ️ [SharedUserAppsDataSource] upsertCurrentApp userId=$userId appId=$_appId',
    );
    await _supabaseClient.from('shared_user_apps').upsert({
      'user_id': userId,
      'app_id': _appId,
      'app_name': _appName,
      'last_seen_at': DateTime.now().toUtc().toIso8601String(),
    });
    debugPrint('✅ [SharedUserAppsDataSource] upsertCurrentApp succeeded');
  }

  @override
  Future<List<Map<String, dynamic>>> getOtherApps() async {
    debugPrint(
      'ℹ️ [SharedUserAppsDataSource] getOtherApps currentAppId=$_appId',
    );
    final response = await _supabaseClient
        .from('shared_user_apps')
        .select()
        .neq('app_id', _appId);

    debugPrint(
      '✅ [SharedUserAppsDataSource] getOtherApps count=${response.length}',
    );
    return List<Map<String, dynamic>>.from(
      response.map((row) => Map<String, dynamic>.from(row as Map)),
    );
  }
}
