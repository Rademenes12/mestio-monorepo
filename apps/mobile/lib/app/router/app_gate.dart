import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/l10n.dart';
import '../ui/shared_users_setup_required_screen.dart';
import '../../shared/error_messages.dart';
import '../../features/auth/presentation/ui/welcome_screen.dart';
import '../../features/home/ui/home_screen.dart';
import '../session/presentation/cubit/session_cubit.dart';

/// AppGate decyduje który ekran pokazać na podstawie stanu sesji.
class AppGate extends StatelessWidget {
  const AppGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, session) {
        debugPrint(
          'ℹ️ [AppGate] building with session state: ${session.runtimeType}',
        );

        if (session.isInitial) {
          debugPrint('ℹ️ [AppGate] showing loading spinner');
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (session.isUnauthenticated) {
          debugPrint('ℹ️ [AppGate] showing WelcomeScreen');
          return const WelcomeScreen();
        }

        if (session.errorKeyOrNull != null) {
          debugPrint('ℹ️ [AppGate] showing error: ${session.errorKeyOrNull}');
          if (session.errorKeyOrNull == 'shared_users_setup_required') {
            return const SharedUsersSetupRequiredScreen();
          }

          return _SessionErrorScreen(
            errorKey: session.errorKeyOrNull!,
            onRetry: () => context.read<SessionCubit>().refresh(),
          );
        }

        debugPrint('ℹ️ [AppGate] showing HomeScreen');
        return const HomeScreen();
      },
    );
  }
}

class _SessionErrorScreen extends StatelessWidget {
  const _SessionErrorScreen({required this.errorKey, required this.onRetry});

  final String errorKey;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.sessionErrorTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  SelectableText(
                    messageForErrorKey(l10n, errorKey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: onRetry,
                    child: Text(l10n.retryButtonLabel),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
