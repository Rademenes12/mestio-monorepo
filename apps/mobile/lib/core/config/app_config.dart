import 'api_keys.dart';

abstract final class AppConfig {
  static const String supabaseTablePrefix = 'fixflow_';

  static bool get hasSupabaseKeys =>
      ApiKeys.supabaseUrl.trim().isNotEmpty &&
      ApiKeys.supabaseAnonKey.trim().isNotEmpty;


  static String get maskedSupabaseUrl {
    if (!hasSupabaseKeys) return '';
    if (ApiKeys.supabaseUrl.length <= 24) return ApiKeys.supabaseUrl;

    return '${ApiKeys.supabaseUrl.substring(0, 24)}...';
  }
}
