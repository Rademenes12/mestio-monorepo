import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../features/profiles/models/shared_user_app_model.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/error_messages.dart';
import '../../../session/presentation/cubit/session_cubit.dart';
import '../cubit/account_actions_cubit.dart';
import '../cubit/delete_account_preflight_cubit.dart';

// Brand colours — kept local to avoid coupling UI styles with business logic
const _kCoral = Color(0xFFFF453A);
const _kCanvas = Color(0xFFF5F7FA);
const _kCardBg = Color(0xFFFFFFFF);
const _kTextDark = Color(0xFF1A1A24);
const _kTextMuted = Color(0xFF636375);
const _kBorderLight = Color(0x0D000000); // ~5% black

class DeleteAccountConfirmationScreen extends StatelessWidget {
  const DeleteAccountConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DeleteAccountPreflightCubit>(
          create: (_) => getIt<DeleteAccountPreflightCubit>(),
        ),
        BlocProvider<AccountActionsCubit>(
          create: (_) => getIt<AccountActionsCubit>(),
        ),
      ],
      child: const _ConfirmationView(),
    );
  }
}

class _ConfirmationView extends StatefulWidget {
  const _ConfirmationView();

  @override
  State<_ConfirmationView> createState() => _ConfirmationViewState();
}

class _ConfirmationViewState extends State<_ConfirmationView> {
  bool _checkboxChecked = false;
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sessionState = context.watch<SessionCubit>().state;
    // Anonymous guests have no password to re-verify - the check below is
    // skipped for them (there's nothing to check against).
    final requiresPassword = !sessionState.isAnonymousUser;
    final email = sessionState.emailOrNull;

    return BlocListener<AccountActionsCubit, AccountActionsState>(
      listener: (context, state) {
        if (state.successKey == 'account_deleted') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.deleteAccountSuccessSnackbar)),
          );
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      child: Scaffold(
        backgroundColor: _kCanvas,
        appBar: AppBar(
          backgroundColor: _kCanvas,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          title: Text(
            l10n.deleteAccountConfirmationTitle,
            style: const TextStyle(
              color: _kTextDark,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          iconTheme: const IconThemeData(color: _kTextDark),
        ),
        body: SafeArea(
          child:
              BlocBuilder<
                DeleteAccountPreflightCubit,
                DeleteAccountPreflightState
              >(
                builder: (context, preflightState) {
                  return switch (preflightState) {
                    DeleteAccountPreflightLoading() => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    // Do not silently present an empty apps list on failure. The
                    // user still needs to know account deletion is global.
                    DeleteAccountPreflightError(:final errorKey) =>
                      _DeleteContent(
                        otherApps: const [],
                        preflightErrorKey: errorKey,
                        checkboxChecked: _checkboxChecked,
                        requiresPassword: requiresPassword,
                        email: email,
                        passwordController: _passwordController,
                        onCheckboxChanged: (value) {
                          setState(() => _checkboxChecked = value ?? false);
                        },
                      ),
                    DeleteAccountPreflightLoaded(:final otherApps) =>
                      _DeleteContent(
                        otherApps: otherApps,
                        preflightErrorKey: null,
                        checkboxChecked: _checkboxChecked,
                        requiresPassword: requiresPassword,
                        email: email,
                        passwordController: _passwordController,
                        onCheckboxChanged: (value) {
                          setState(() => _checkboxChecked = value ?? false);
                        },
                      ),
                  };
                },
              ),
        ),
      ),
    );
  }
}

class _DeleteContent extends StatelessWidget {
  const _DeleteContent({
    required this.otherApps,
    required this.preflightErrorKey,
    required this.checkboxChecked,
    required this.onCheckboxChanged,
    required this.requiresPassword,
    required this.email,
    required this.passwordController,
  });

  final List<SharedUserAppModel> otherApps;
  final String? preflightErrorKey;
  final bool checkboxChecked;
  final ValueChanged<bool?> onCheckboxChanged;
  final bool requiresPassword;
  final String? email;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hasOtherApps = otherApps.isNotEmpty;
    final hasPreflightError = preflightErrorKey != null;
    final requiresAllAppsConfirmation = hasOtherApps || hasPreflightError;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Main permanent warning card
              _WarningCard(
                child: Text(
                  l10n.deleteAccountPermanentWarning,
                  style: const TextStyle(
                    color: _kTextDark,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),

              if (hasPreflightError) ...[
                const SizedBox(height: 12),
                _PreflightWarning(errorKey: preflightErrorKey!),
              ],

              if (hasOtherApps) ...[
                const SizedBox(height: 12),
                _OtherAppsWarning(otherApps: otherApps),
              ],

              const SizedBox(height: 16),

              // Confirmation checkbox in a card
              DecoratedBox(
                decoration: BoxDecoration(
                  color: _kCardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _kBorderLight),
                ),
                child: CheckboxListTile(
                  value: checkboxChecked,
                  onChanged: onCheckboxChanged,
                  title: Text(
                    requiresAllAppsConfirmation
                        ? l10n.deleteAccountCheckboxLabel
                        : l10n.deleteAccountCheckboxLabelSimple,
                    style: const TextStyle(color: _kTextDark, fontSize: 14),
                  ),
                  activeColor: _kCoral,
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              if (requiresPassword) ...[
                const SizedBox(height: 16),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: _kCardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _kBorderLight),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.deleteAccountRequiresPassword,
                          style: const TextStyle(
                            color: _kTextDark,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: l10n.deleteAccountPasswordLabel,
                            hintText: l10n.deleteAccountPasswordHint,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              BlocBuilder<AccountActionsCubit, AccountActionsState>(
                builder: (context, accountState) {
                  final isDeleting =
                      accountState.activeAction == AccountAction.deleteAccount;

                  return ValueListenableBuilder<TextEditingValue>(
                    valueListenable: passwordController,
                    builder: (context, passwordValue, _) {
                      final canDelete =
                          checkboxChecked &&
                          !isDeleting &&
                          (!requiresPassword || passwordValue.text.isNotEmpty);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Destructive action button
                          SizedBox(
                            height: 52,
                            child: FilledButton(
                              onPressed: canDelete
                                  ? () => context
                                        .read<AccountActionsCubit>()
                                        .deleteAccount(
                                          email: requiresPassword
                                              ? email
                                              : null,
                                          password: requiresPassword
                                              ? passwordController.text
                                              : null,
                                        )
                                  : null,
                              style: FilledButton.styleFrom(
                                backgroundColor: _kCoral,
                                disabledBackgroundColor: _kCoral.withValues(
                                  alpha: 0.4,
                                ),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: isDeleting
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      l10n.deleteAccountConfirmButton,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                          ),
                          if (accountState.errorKey != null) ...[
                            const SizedBox(height: 12),
                            SelectableText(
                              messageForErrorKey(l10n, accountState.errorKey),
                              style: const TextStyle(
                                color: _kCoral,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A white card with a red left accent bar — used for destructive warnings.
class _WarningCard extends StatelessWidget {
  const _WarningCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _kCardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _kBorderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Red left accent bar
              Container(width: 4, color: _kCoral),
              Expanded(
                child: Padding(padding: const EdgeInsets.all(16), child: child),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreflightWarning extends StatelessWidget {
  const _PreflightWarning({required this.errorKey});

  final String errorKey;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return _WarningCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SelectableText(
            l10n.deleteAccountAppsCheckFailed,
            style: const TextStyle(
              color: _kCoral,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          SelectableText(
            messageForErrorKey(l10n, errorKey),
            style: const TextStyle(color: _kCoral, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _OtherAppsWarning extends StatelessWidget {
  const _OtherAppsWarning({required this.otherApps});

  final List<SharedUserAppModel> otherApps;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return _WarningCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.deleteAccountOtherAppsWarning,
            style: const TextStyle(
              color: _kTextDark,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          ...otherApps.map((app) => _OtherAppRow(appName: app.appName)),
        ],
      ),
    );
  }
}

class _OtherAppRow extends StatelessWidget {
  const _OtherAppRow({required this.appName});

  final String appName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(right: 10),
            decoration: const BoxDecoration(
              color: _kCoral,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              appName,
              style: const TextStyle(color: _kTextMuted, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
