import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'api_keys.dart';

enum RevenueCatActiveKeyType { none, testStore, appStore, googlePlay }

class RevenueCatKeyResolution {
  const RevenueCatKeyResolution({
    required this.isSupportedPlatform,
    required this.platformApiKey,
    required this.testStoreApiKey,
    required this.activeApiKey,
    required this.activeKeyType,
    required this.isUsingTestStore,
  });

  final bool isSupportedPlatform;
  final String platformApiKey;
  final String testStoreApiKey;
  final String activeApiKey;
  final RevenueCatActiveKeyType activeKeyType;
  final bool isUsingTestStore;

  bool get hasPlatformApiKey =>
      isSupportedPlatform && platformApiKey.isNotEmpty;

  bool get canConfigure => activeApiKey.isNotEmpty;
}

abstract class RevenueCatConfig {
  static bool isEnabled = false;
  static bool isTestStore = false;

  /// FixFlow B2B mode: monetization happens outside the app (Stripe on website).
  /// When true, RevenueCat/IAP is completely disabled regardless of API keys.
  /// Set to false only if you want to re-enable IAP monetization.
  static const bool fixflowB2bMode = true;

  /// RevenueCat entitlement identifier. Hardcoded because each app has its
  /// own RC project, so `pro` is unique within that project.
  static const String entitlementId = 'pro';

  static bool get isSupportedPlatform =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android);

  static RevenueCatKeyResolution get keys => resolveKeys(
    isWeb: kIsWeb,
    platform: defaultTargetPlatform,
    isDebug: kDebugMode,
    appleApiKey: ApiKeys.revenueCatAppleApiKey,
    googleApiKey: ApiKeys.revenueCatGoogleApiKey,
    testStoreApiKey: ApiKeys.revenueCatTestStoreApiKey,
  );

  static String get platformApiKey => keys.platformApiKey;

  static bool get hasPlatformKey => keys.hasPlatformApiKey;

  static String get testStoreApiKey => ApiKeys.revenueCatTestStoreApiKey.trim();

  static bool get hasTestStoreKey => testStoreApiKey.isNotEmpty;

  static String get activeApiKey => keys.activeApiKey;

  static RevenueCatActiveKeyType get activeKeyType => keys.activeKeyType;

  static bool get isUsingTestStore => keys.isUsingTestStore;

  static bool get canConfigure => keys.canConfigure;

  @visibleForTesting
  static RevenueCatKeyResolution resolveKeys({
    required bool isWeb,
    required TargetPlatform platform,
    required bool isDebug,
    required String appleApiKey,
    required String googleApiKey,
    required String testStoreApiKey,
  }) {
    final isSupportedPlatform =
        !isWeb &&
        (platform == TargetPlatform.iOS || platform == TargetPlatform.android);
    final platformApiKey = switch (platform) {
      TargetPlatform.iOS => appleApiKey.trim(),
      TargetPlatform.android => googleApiKey.trim(),
      _ => '',
    };
    final trimmedTestStoreApiKey = testStoreApiKey.trim();

    // A platform SDK key is the signal that RevenueCat is configured for this
    // target. The Test Store key only chooses the debug billing environment.
    if (!isSupportedPlatform || platformApiKey.isEmpty) {
      return RevenueCatKeyResolution(
        isSupportedPlatform: isSupportedPlatform,
        platformApiKey: platformApiKey,
        testStoreApiKey: trimmedTestStoreApiKey,
        activeApiKey: '',
        activeKeyType: RevenueCatActiveKeyType.none,
        isUsingTestStore: false,
      );
    }

    // Debug builds intentionally require the Test Store key. This prevents a
    // template app from accidentally using real store billing while debugging.
    if (isDebug) {
      return RevenueCatKeyResolution(
        isSupportedPlatform: isSupportedPlatform,
        platformApiKey: platformApiKey,
        testStoreApiKey: trimmedTestStoreApiKey,
        activeApiKey: trimmedTestStoreApiKey,
        activeKeyType: trimmedTestStoreApiKey.isNotEmpty
            ? RevenueCatActiveKeyType.testStore
            : RevenueCatActiveKeyType.none,
        isUsingTestStore: trimmedTestStoreApiKey.isNotEmpty,
      );
    }

    final activeKeyType = switch (platform) {
      TargetPlatform.iOS => RevenueCatActiveKeyType.appStore,
      TargetPlatform.android => RevenueCatActiveKeyType.googlePlay,
      _ => RevenueCatActiveKeyType.none,
    };

    return RevenueCatKeyResolution(
      isSupportedPlatform: isSupportedPlatform,
      platformApiKey: platformApiKey,
      testStoreApiKey: trimmedTestStoreApiKey,
      activeApiKey: platformApiKey,
      activeKeyType: activeKeyType,
      isUsingTestStore: false,
    );
  }

  static String get maskedActiveApiKey {
    if (activeApiKey.isEmpty) return '';
    if (activeApiKey.length <= 8) {
      return activeApiKey;
    }

    return '${activeApiKey.substring(0, 4)}...${activeApiKey.substring(activeApiKey.length - 4)}';
  }
}

Future<bool> configureRevenueCat() async {
  // FixFlow B2B mode: skip RevenueCat entirely, monetization via Stripe on website
  if (RevenueCatConfig.fixflowB2bMode) {
    RevenueCatConfig.isEnabled = false;
    RevenueCatConfig.isTestStore = false;
    debugPrint('ℹ️ [RC] RevenueCat disabled (B2B mode - monetization via Stripe)');
    return false;
  }

  final rcApiKey = RevenueCatConfig.activeApiKey;
  if (rcApiKey.isNotEmpty) {
    // The platform key proves RevenueCat is configured for this target.
    // RevenueCatConfig may still choose the Test Store key for debug builds.
    await Purchases.configure(PurchasesConfiguration(rcApiKey));
    RevenueCatConfig.isEnabled = true;
    RevenueCatConfig.isTestStore = RevenueCatConfig.isUsingTestStore;
    if (RevenueCatConfig.isTestStore) {
      debugPrint('ℹ️ [RC] Using Test Store key (debug mode)');
    }
    return true;
  }

  RevenueCatConfig.isEnabled = false;
  RevenueCatConfig.isTestStore = false;
  debugPrint(
    '⚠️ [RC] RevenueCat disabled '
    '(web=$kIsWeb, platform=$defaultTargetPlatform, '
    'hasPlatformKey=${RevenueCatConfig.hasPlatformKey}, '
    'hasTestStoreKey=${RevenueCatConfig.hasTestStoreKey})',
  );
  return false;
}
