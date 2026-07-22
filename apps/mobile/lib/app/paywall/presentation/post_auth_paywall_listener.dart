import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../l10n/l10n.dart';
import '../../session/presentation/cubit/session_cubit.dart';
import 'paywall_presenter.dart';

/// Shared glue for showing a paywall after an authenticated root screen exists.
mixin PostAuthPaywallMixin<T extends StatefulWidget> on State<T> {
  // Prevents double presentation if multiple listeners fire in the same flow.
  bool _presentingPostAuthPaywall = false;

  Future<void> presentPostAuthPaywallIfNeeded() async {
    // Do nothing if a paywall is already being presented or this widget is gone.
    if (_presentingPostAuthPaywall || !mounted) return;

    // Set the guard before any await can yield.
    _presentingPostAuthPaywall = true;

    try {
      // Read the current session first; it is often already authenticated.
      var session = context.read<SessionCubit>().state;

      // If auth is still propagating, wait for the first authenticated state.
      if (!session.isAuthenticated) {
        session = await context.read<SessionCubit>().stream.firstWhere(
          (state) => state.isAuthenticated,
        );
      }

      // Stop if the widget disappeared or this user already has Pro.
      if (!mounted || session.isProUser) return;

      // Clear pushed auth/onboarding routes so the paywall is shown over Home.
      Navigator.of(
        context,
        rootNavigator: true,
      ).popUntil((route) => route.isFirst);

      // Wait for Home to render before presenting a route/dialog on top of it.
      await WidgetsBinding.instance.endOfFrame;

      // The widget can still be disposed while waiting for the frame.
      if (!mounted) return;

      // Use the existing presenter so RevenueCat/placeholder behavior is shared.
      final result = await getIt<PaywallPresenter>().presentIfNeeded(
        context: context,
      );

      // The widget can be disposed while the paywall is open.
      if (!mounted) return;

      _handlePostAuthPaywallResult(result);
    } catch (error) {
      // Log the raw error, but keep the user on Home.
      debugPrint('❌ [PostAuthPaywallMixin] $error');
    } finally {
      // Always release the guard after success, cancellation, or error.
      _presentingPostAuthPaywall = false;
    }
  }

  void _handlePostAuthPaywallResult(PaywallPresentationResult result) {
    switch (result) {
      case PaywallPresentationResult.purchased:
      case PaywallPresentationResult.restored:
        // Purchases and restores are success events, so a SnackBar is allowed.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.proEnabledSnackbar)),
        );
      case PaywallPresentationResult.error:
        // Errors are logged for debugging. The app should keep the user on Home.
        debugPrint('❌ [PostAuthPaywallMixin] Paywall presentation error');
      case PaywallPresentationResult.cancelled:
      case PaywallPresentationResult.notPresented:
      case PaywallPresentationResult.placeholderShown:
        // No user-facing follow-up is needed for dismissal or no-op outcomes.
        break;
    }
  }
}

class PostAuthPaywallBlocListener<B extends StateStreamable<S>, S>
    extends StatefulWidget {
  const PostAuthPaywallBlocListener({
    required this.listenWhen,
    required this.child,
    super.key,
  });

  final BlocListenerCondition<S> listenWhen;
  final Widget child;

  @override
  State<PostAuthPaywallBlocListener<B, S>> createState() =>
      _PostAuthPaywallBlocListenerState<B, S>();
}

class _PostAuthPaywallBlocListenerState<B extends StateStreamable<S>, S>
    extends State<PostAuthPaywallBlocListener<B, S>>
    with PostAuthPaywallMixin<PostAuthPaywallBlocListener<B, S>> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<B, S>(
      listenWhen: widget.listenWhen,
      listener: (context, state) {
        presentPostAuthPaywallIfNeeded();
      },
      child: widget.child,
    );
  }
}
