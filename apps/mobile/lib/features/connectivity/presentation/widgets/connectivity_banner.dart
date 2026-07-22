import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/l10n.dart';
import '../cubit/connectivity_cubit.dart';

/// Wraps [child] and shows a persistent offline banner at the top of the
/// screen whenever [ConnectivityCubit] reports [ConnectivityDisconnected].
///
/// Place this widget **below** `MaterialApp` (so it has access to
/// `AppLocalizations`) and **above** the main content tree.
///
/// The banner slides in/out with a short animation. It does NOT block
/// user interaction — the user can still navigate, tap buttons, etc.
/// If they try an action while offline, the normal Cubit error handling
/// will catch the failed Supabase request and show an inline error as usual.
///
/// Usage in `app.dart`:
/// ```dart
/// home: ConnectivityBanner(
///   child: _AppShell(hasSupabaseKeys: hasSupabaseKeys),
/// ),
/// ```
class ConnectivityBanner extends StatelessWidget {
  const ConnectivityBanner({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, ConnectivityState>(
      buildWhen: (prev, curr) => prev != curr,
      builder: (context, state) {
        // Show banner only when we're sure the device is offline.
        // "unknown" is treated as connected — no flash on cold start.
        final isOffline = state is ConnectivityDisconnected;

        return Column(
          children: [
            // Animated slide-in/out banner.
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child:
                  isOffline
                      ? _OfflineBannerContent(
                        onRetry:
                            () => context.read<ConnectivityCubit>().retry(),
                      )
                      : const SizedBox.shrink(),
            ),

            // Main content takes all remaining space.
            Expanded(child: child),
          ],
        );
      },
    );
  }
}

class _OfflineBannerContent extends StatelessWidget {
  const _OfflineBannerContent({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    // Red background extends behind the notch / Dynamic Island / camera hole.
    // SafeArea pushes only the text content below the system UI.
    return Material(
      color: Colors.red.shade800,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              const Icon(Icons.wifi_off, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.connectivityOfflineBanner,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              InkWell(
                onTap: onRetry,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  child: Text(
                    l10n.retryButtonLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
