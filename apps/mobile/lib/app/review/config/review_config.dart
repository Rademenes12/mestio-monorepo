abstract final class ReviewConfig {
  /// Numeric Apple ID from App Store Connect.
  ///
  /// This is public app metadata, not a secret. It is required only for the
  /// explicit "Rate this app" profile action on iOS.
  static const String appStoreId = '';

  /// Prefix keeps review counters isolated when one developer ships multiple
  /// apps based on this template.
  static const String storageKeyPrefix = 'app_review_';
}
