import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mestio/core/config/revenuecat_config.dart';

void main() {
  group('RevenueCatConfig.fixflowB2bMode', () {
    test(
      'MUST stay true - flipping it silently re-enables the "Kup Pro" '
      'paywall (profile_screen.dart) and full RevenueCat/StoreKit '
      'integration. docs/REVIEW_NOTES.md and docs/DATA_SAFETY.md both '
      'tell App Store/Google Play reviewers this app has NO in-app '
      'purchases - if this flag is ever flipped intentionally, update '
      'those two documents (and this test) in the SAME change, not after.',
      () {
        expect(RevenueCatConfig.fixflowB2bMode, isTrue);
      },
    );
  });

  group('RevenueCatConfig.resolveKeys', () {
    test('uses Test Store key on Android debug when platform key exists', () {
      final resolution = RevenueCatConfig.resolveKeys(
        isWeb: false,
        platform: TargetPlatform.android,
        isDebug: true,
        appleApiKey: '',
        googleApiKey: ' goog_android ',
        testStoreApiKey: ' test_store ',
      );

      expect(resolution.isSupportedPlatform, isTrue);
      expect(resolution.hasPlatformApiKey, isTrue);
      expect(resolution.platformApiKey, 'goog_android');
      expect(resolution.activeApiKey, 'test_store');
      expect(resolution.activeKeyType, RevenueCatActiveKeyType.testStore);
      expect(resolution.isUsingTestStore, isTrue);
      expect(resolution.canConfigure, isTrue);
    });

    test('uses Test Store key on iOS debug when platform key exists', () {
      final resolution = RevenueCatConfig.resolveKeys(
        isWeb: false,
        platform: TargetPlatform.iOS,
        isDebug: true,
        appleApiKey: 'appl_ios',
        googleApiKey: '',
        testStoreApiKey: 'test_store',
      );

      expect(resolution.platformApiKey, 'appl_ios');
      expect(resolution.activeApiKey, 'test_store');
      expect(resolution.activeKeyType, RevenueCatActiveKeyType.testStore);
      expect(resolution.isUsingTestStore, isTrue);
      expect(resolution.canConfigure, isTrue);
    });

    test('uses Google key on Android release', () {
      final resolution = RevenueCatConfig.resolveKeys(
        isWeb: false,
        platform: TargetPlatform.android,
        isDebug: false,
        appleApiKey: '',
        googleApiKey: 'goog_android',
        testStoreApiKey: 'test_store',
      );

      expect(resolution.activeApiKey, 'goog_android');
      expect(resolution.activeKeyType, RevenueCatActiveKeyType.googlePlay);
      expect(resolution.isUsingTestStore, isFalse);
      expect(resolution.canConfigure, isTrue);
    });

    test('uses Apple key on iOS release', () {
      final resolution = RevenueCatConfig.resolveKeys(
        isWeb: false,
        platform: TargetPlatform.iOS,
        isDebug: false,
        appleApiKey: 'appl_ios',
        googleApiKey: '',
        testStoreApiKey: 'test_store',
      );

      expect(resolution.activeApiKey, 'appl_ios');
      expect(resolution.activeKeyType, RevenueCatActiveKeyType.appStore);
      expect(resolution.isUsingTestStore, isFalse);
      expect(resolution.canConfigure, isTrue);
    });

    test('does not configure debug RevenueCat without a Test Store key', () {
      final resolution = RevenueCatConfig.resolveKeys(
        isWeb: false,
        platform: TargetPlatform.android,
        isDebug: true,
        appleApiKey: '',
        googleApiKey: 'goog_android',
        testStoreApiKey: '',
      );

      expect(resolution.hasPlatformApiKey, isTrue);
      expect(resolution.activeApiKey, isEmpty);
      expect(resolution.activeKeyType, RevenueCatActiveKeyType.none);
      expect(resolution.isUsingTestStore, isFalse);
      expect(resolution.canConfigure, isFalse);
    });

    test('does not configure from Test Store key without platform key', () {
      final resolution = RevenueCatConfig.resolveKeys(
        isWeb: false,
        platform: TargetPlatform.android,
        isDebug: true,
        appleApiKey: '',
        googleApiKey: '',
        testStoreApiKey: 'test_store',
      );

      expect(resolution.hasPlatformApiKey, isFalse);
      expect(resolution.activeApiKey, isEmpty);
      expect(resolution.activeKeyType, RevenueCatActiveKeyType.none);
      expect(resolution.canConfigure, isFalse);
    });

    test(
      'does not fallback to Test Store key on release without platform key',
      () {
        final resolution = RevenueCatConfig.resolveKeys(
          isWeb: false,
          platform: TargetPlatform.android,
          isDebug: false,
          appleApiKey: '',
          googleApiKey: '',
          testStoreApiKey: 'test_store',
        );

        expect(resolution.hasPlatformApiKey, isFalse);
        expect(resolution.activeApiKey, isEmpty);
        expect(resolution.activeKeyType, RevenueCatActiveKeyType.none);
        expect(resolution.canConfigure, isFalse);
      },
    );

    test('does not configure unsupported platforms', () {
      final resolution = RevenueCatConfig.resolveKeys(
        isWeb: false,
        platform: TargetPlatform.macOS,
        isDebug: false,
        appleApiKey: 'appl_ios',
        googleApiKey: 'goog_android',
        testStoreApiKey: 'test_store',
      );

      expect(resolution.isSupportedPlatform, isFalse);
      expect(resolution.platformApiKey, isEmpty);
      expect(resolution.activeApiKey, isEmpty);
      expect(resolution.activeKeyType, RevenueCatActiveKeyType.none);
      expect(resolution.canConfigure, isFalse);
    });

    test('does not configure web', () {
      final resolution = RevenueCatConfig.resolveKeys(
        isWeb: true,
        platform: TargetPlatform.android,
        isDebug: false,
        appleApiKey: '',
        googleApiKey: 'goog_android',
        testStoreApiKey: 'test_store',
      );

      expect(resolution.isSupportedPlatform, isFalse);
      expect(resolution.hasPlatformApiKey, isFalse);
      expect(resolution.activeApiKey, isEmpty);
      expect(resolution.activeKeyType, RevenueCatActiveKeyType.none);
      expect(resolution.canConfigure, isFalse);
    });
  });
}
