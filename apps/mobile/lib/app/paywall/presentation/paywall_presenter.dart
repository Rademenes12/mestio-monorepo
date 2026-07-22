import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

import '../../../core/config/revenuecat_config.dart';
import '../ui/pro_purchase_placeholder_screen.dart';

enum PaywallPresentationResult {
  // The user completed a purchase on the paywall.
  purchased,
  // The user restored an existing purchase from the paywall.
  restored,
  // No paywall was shown because the current state did not need it.
  notPresented,
  // The user closed the RevenueCat paywall without buying.
  cancelled,
  // RevenueCat or the wrapper hit an error while trying to show the paywall.
  error,
  // The local placeholder screen was shown because RevenueCat is not configured.
  placeholderShown,
}

/// Shows the app paywall using the currently active implementation.
abstract class PaywallPresenter {
  Future<PaywallPresentationResult> presentIfNeeded({
    required BuildContext context,
  });
}

@LazySingleton(as: PaywallPresenter)
class AppPaywallPresenter implements PaywallPresenter {
  @override
  Future<PaywallPresentationResult> presentIfNeeded({
    required BuildContext context,
  }) async {
    // Without RevenueCat keys, show the local placeholder so the Pro flow can
    // be tested before RevenueCat is configured.
    if (!RevenueCatConfig.isEnabled) {
      // Push a fullscreen placeholder route and wait until the user closes it.
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => const ProPurchasePlaceholderScreen(),
          fullscreenDialog: true,
        ),
      );
      // Record that the fallback path was used.
      debugPrint('ℹ️ [PaywallPresenter] Placeholder shown');
      return PaywallPresentationResult.placeholderShown;
    }

    late final PaywallResult result;
    try {
      // RevenueCat is configured, so show the real Paywalls V2 UI.
      result = await RevenueCatUI.presentPaywallIfNeeded(
        RevenueCatConfig.entitlementId,
        displayCloseButton: true,
      );
    } catch (error) {
      debugPrint('❌ [PaywallPresenter] Paywall exception: $error');
      return PaywallPresentationResult.error;
    }

    // Normalize RevenueCat SDK results into app-level results.
    switch (result) {
      case PaywallResult.purchased:
        // The purchase completed successfully.
        debugPrint('✅ [PaywallPresenter] Paywall purchase completed');
        return PaywallPresentationResult.purchased;
      case PaywallResult.restored:
        // A previous purchase was restored successfully.
        debugPrint('✅ [PaywallPresenter] Paywall restore completed');
        return PaywallPresentationResult.restored;
      case PaywallResult.notPresented:
        // RevenueCat decided there was nothing to present.
        debugPrint('ℹ️ [PaywallPresenter] Paywall not presented');
        return PaywallPresentationResult.notPresented;
      case PaywallResult.cancelled:
        // The user dismissed the paywall without purchasing.
        debugPrint('ℹ️ [PaywallPresenter] Paywall cancelled');
        return PaywallPresentationResult.cancelled;
      case PaywallResult.error:
        // RevenueCat reported an error.
        debugPrint('❌ [PaywallPresenter] Paywall error');
        return PaywallPresentationResult.error;
    }
  }
}
