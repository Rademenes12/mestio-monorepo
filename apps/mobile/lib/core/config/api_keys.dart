/// API keys injected via --dart-define-from-file=config/api-keys.json.
///
/// Copy config/api-keys.example.json → config/api-keys.json and fill in values.
/// VS Code launch.json already passes --dart-define-from-file.
/// For CLI: flutter run --dart-define-from-file=config/api-keys.json
class ApiKeys {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
}