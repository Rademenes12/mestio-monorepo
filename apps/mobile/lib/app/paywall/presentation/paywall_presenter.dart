import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

/// Result of presenting the paywall.
enum PaywallPresentationResult {
  /// No paywall was shown — the current state didn't need it.
  notPresented,
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
    // Paywall has been removed — always return notPresented.
    debugPrint('ℹ️ [PaywallPresenter] Paywall disabled — returning notPresented');
    return PaywallPresentationResult.notPresented;
  }
}
