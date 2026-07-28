import 'package:flutter/material.dart';

/// Mixin used to show the paywall after authentication — currently a no-op
/// since RevenueCat and paywalls have been removed. All users get unlimited
/// access without any purchase flow.
mixin PostAuthPaywallMixin<T extends StatefulWidget> on State<T> {
  Future<void> presentPostAuthPaywallIfNeeded() async {
    // No-op: paywall has been removed from the app.
  }
}
