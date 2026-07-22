import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/paywall/presentation/paywall_presenter.dart';
import '../../../../app/developer/ui/developer_screen.dart';
import '../../../../app/locale/models/app_locale_option_model.dart';
import '../../../../app/locale/presentation/cubit/app_locale_cubit.dart';
import '../../../../app/profile/presentation/cubit/account_actions_cubit.dart';
import '../../../../app/profile/presentation/cubit/data_export_cubit.dart';
import '../../../../app/profile/presentation/ui/delete_account_confirmation_screen.dart';
import '../../../../app/session/presentation/cubit/session_cubit.dart';
import '../../../../app/session/presentation/session_localizations.dart';
import '../../../../core/config/revenuecat_config.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../features/auth/presentation/ui/login_screen.dart';
import '../../../../features/auth/presentation/ui/register_screen.dart';
import '../../../../features/estate/presentation/ui/estate_management_screen.dart';
import '../../../../features/estate/presentation/cubit/estate_cubit.dart';
import '../../../../features/estate/data/repositories/estate_repository.dart';
import '../../../../features/reports/presentation/cubit/reports_cubit.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/logout_feedback_sheet.dart';
import '../../../../shared/error_messages.dart';
import '../cubit/profile_cubit.dart';
import 'resident_spaces_card.dart';

// Brand colours — mapped to AppColors to align with global design system
const _kIndigo = AppColors.electricIndigo;
const _kCyan = AppColors.cyanGlow;
const _kCoral = AppColors.crimsonCoral;
const _kCanvas = AppColors.lightCanvas;
const _kCardBg = AppColors.lightCard;
const _kTextDark = AppColors.lightTextPrimary;
const _kTextMuted = AppColors.lightTextSecondary;
const _kBorderLight = AppColors.lightBorder;

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppLocaleCubit>.value(value: getIt<AppLocaleCubit>()),
        BlocProvider<SessionCubit>.value(value: getIt<SessionCubit>()),
        BlocProvider<ProfileCubit>(create: (_) => getIt<ProfileCubit>()),
        BlocProvider<AccountActionsCubit>(
          create: (_) => getIt<AccountActionsCubit>(),
        ),
        BlocProvider<EstateMembershipCubit>.value(
          value: getIt<EstateMembershipCubit>(),
        ),
        BlocProvider<DataExportCubit>(create: (_) => getIt<DataExportCubit>()),
      ],
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView();

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  late final TextEditingController _firstNameController;
  late final FocusNode _firstNameFocusNode;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _firstNameFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _firstNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionCubit>().state;
    final sharedUser = session.sharedUserOrNull;
    final firstName = sharedUser?.firstName ?? '';
    final l10n = context.l10n;

    final reportsState = context.watch<ReportsCubit>().state;
    final profileEmail = reportsState is ReportsLoaded ? reportsState.profile?.email : null;

    if (!_firstNameFocusNode.hasFocus &&
        _firstNameController.text != firstName) {
      _firstNameController.text = firstName;
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state.successKey == 'profile_saved') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.profileSavedSnackbar)),
              );
              context.read<ProfileCubit>().clearFeedback();
            }
          },
        ),
        BlocListener<DataExportCubit, DataExportState>(
          listener: (context, state) {
            if (state.successKey == 'data_exported') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.dataExportedSnackbar)),
              );
              context.read<DataExportCubit>().clearFeedback();
            }
          },
        ),
        BlocListener<AccountActionsCubit, AccountActionsState>(
          listener: (context, state) async {
            if (state.successKey == 'pro_enabled') {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l10n.proEnabledSnackbar)));
              context.read<AccountActionsCubit>().clearFeedback();
            }

            final effect = state.effect;
            if (effect case AccountActionsEffectOpenPaywall()) {
              final result = await getIt<PaywallPresenter>().presentIfNeeded(
                context: context,
              );
              if (!context.mounted) return;
              switch (result) {
                case PaywallPresentationResult.purchased:
                case PaywallPresentationResult.restored:
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.proEnabledSnackbar)),
                  );
                case PaywallPresentationResult.error:
                  context.read<AccountActionsCubit>().setPaywallError(
                    'purchase_error',
                  );
                case PaywallPresentationResult.notPresented:
                case PaywallPresentationResult.cancelled:
                case PaywallPresentationResult.placeholderShown:
                  break;
              }
              context.read<AccountActionsCubit>().clearEffect();
            }
          },
        ),
      ],
      child: PopScope(
        canPop: !_hasUnsavedChanges(firstName),
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop || !_hasUnsavedChanges(firstName)) return;

          final shouldDiscard = await _confirmDiscardChanges(context);
          if (!context.mounted || !shouldDiscard) return;
          Navigator.of(context).pop();
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: _kCanvas,
            appBar: AppBar(
              backgroundColor: _kCanvas,
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              title: Text(
                l10n.profileTitle,
                style: const TextStyle(
                  color: _kTextDark,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              iconTheme: const IconThemeData(color: _kTextDark),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, profileState) {
                        return BlocBuilder<
                          AccountActionsCubit,
                          AccountActionsState
                        >(
                          builder: (context, accountState) {
                            return BlocBuilder<DataExportCubit, DataExportState>(
                              builder: (context, exportState) {
                            final isSavingName = profileState.isSaving;
                            final activeAccountAction =
                                accountState.activeAction;
                            final isInteractionLocked =
                                isSavingName || activeAccountAction != null || exportState.isLoading;
                            final canBuyPro =
                                RevenueCatConfig.isEnabled &&
                                !session.isProUser &&
                                session.userIdOrNull != null;
                            final isSavePrimaryAction =
                                !session.isAnonymousUser && !canBuyPro;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (session.shouldShowProtectProBanner) ...[
                                  const _ProtectProBanner(),
                                  const SizedBox(height: 20),
                                ],

                                // Name field card
                                _SectionCard(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      TextField(
                                        controller: _firstNameController,
                                        focusNode: _firstNameFocusNode,
                                        enabled: !isInteractionLocked,
                                        keyboardType: TextInputType.name,
                                        // Remember to keep it, even when you refactor this widget
                                        textCapitalization:
                                            TextCapitalization.words,
                                        decoration: InputDecoration(
                                          labelText: l10n.firstNameFieldLabel,
                                          prefixIcon: const Icon(
                                            Icons.person_outline,
                                            color: _kCyan,
                                          ),
                                          filled: true,
                                          fillColor: _kCanvas,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide.none,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                              color: _kBorderLight,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                              color: _kCyan,
                                              width: 1.5,
                                            ),
                                          ),
                                          labelStyle: const TextStyle(
                                            color: _kTextMuted,
                                          ),
                                        ),
                                        textInputAction: TextInputAction.done,
                                        onSubmitted: (_) =>
                                            _saveFirstName(context, session),
                                      ),
                                      const SizedBox(height: 12),
                                      _SaveButton(
                                        isSaving: isSavingName,
                                        isPrimary: isSavePrimaryAction,
                                        isLocked: isInteractionLocked,
                                        label: l10n.saveFirstNameButtonLabel,
                                        onPressed: () =>
                                            _saveFirstName(context, session),
                                      ),
                                      if (profileState.errorKey != null) ...[
                                        const SizedBox(height: 12),
                                        SelectableText(
                                          messageForErrorKey(
                                            l10n,
                                            profileState.errorKey,
                                          ),
                                          style: const TextStyle(
                                            color: _kCoral,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // Language section card
                                _SectionCard(
                                  title: l10n.profileLanguageSectionTitle,
                                  child: _AppLanguageDropdown(
                                    isEnabled: !isInteractionLocked,
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // Resident spaces (komórki, piwnice, parking, etc.)
                                if (reportsState is ReportsLoaded &&
                                    reportsState.userId != null &&
                                    reportsState.estateId != null) ...[
                                  ResidentSpacesCard(
                                    userId: reportsState.userId!,
                                    estateId: reportsState.estateId!,
                                  ),
                                  const SizedBox(height: 16),
                                ],

                                // Estate company info + invitation code (replaces Trello section)
                                _EstateCompanySection(
                                  onManageCodes: () =>
                                      Navigator.of(context).push<void>(
                                    MaterialPageRoute<void>(
                                      builder: (_) =>
                                          const EstateManagementScreen(),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // Contact & support section card
                                _SectionCard(
                                  title: l10n.supportSectionTitle,
                                  child: _SupportSection(
                                    userId: session.userIdOrNull,
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // Legal documents section
                                _SectionCard(
                                  title: l10n.legalSectionTitle,
                                  child: _LegalSection(),
                                ),

                                const SizedBox(height: 16),

                                // GDPR data export
                                _SectionCard(
                                  title: l10n.dataExportButtonLabel,
                                  child: _DataExportSection(
                                    userId: session.userIdOrNull,
                                    email: profileEmail,
                                    isLocked: isInteractionLocked,
                                  ),
                                ),

                                if (accountState.errorKey != null) ...[
                                  const SizedBox(height: 12),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    child: SelectableText(
                                      messageForErrorKey(
                                        l10n,
                                        accountState.errorKey,
                                      ),
                                      style: const TextStyle(
                                        color: _kCoral,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],

                                const SizedBox(height: 24),

                                // Account actions
                                if (session.isAnonymousUser) ...[
                                  _GradientButton(
                                    label: l10n.registerButtonLabel,
                                    isLocked: isInteractionLocked,
                                    onPressed: () async {
                                      final result =
                                          await Navigator.of(
                                            context,
                                          ).push<bool>(
                                            MaterialPageRoute<bool>(
                                              builder: (_) =>
                                                  RegisterScreen(initialEmail: profileEmail),
                                            ),
                                          );
                                      if (!context.mounted) return;
                                      if (result == true) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              l10n.accountSecuredSnackbar,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  _OutlineActionButton(
                                    label: l10n.loginButtonLabel,
                                    isLocked: isInteractionLocked,
                                    onPressed: () =>
                                        Navigator.of(context).push<void>(
                                          MaterialPageRoute<void>(
                                            builder: (_) =>
                                                const LoginScreen(),
                                          ),
                                        ),
                                  ),
                                  const SizedBox(height: 12),
                                  if (canBuyPro) ...[
                                    _ProButton(
                                      label: l10n.buyProButtonLabel,
                                      isLocked: isInteractionLocked,
                                      onPressed: () =>
                                          context
                                              .read<AccountActionsCubit>()
                                              .requestProPurchase(),
                                    ),
                                    const SizedBox(height: 12),
                                  ],
                                ],

                                if (!session.isAnonymousUser) ...[
                                  if (canBuyPro) ...[
                                    _ProButton(
                                      label: l10n.buyProButtonLabel,
                                      isLocked: isInteractionLocked,
                                      onPressed: () =>
                                          context
                                              .read<AccountActionsCubit>()
                                              .requestProPurchase(),
                                    ),
                                    const SizedBox(height: 12),
                                  ],
                                  _OutlineActionButton(
                                    label:
                                        activeAccountAction ==
                                            AccountAction.signOut
                                        ? null
                                        : l10n.logoutButtonLabel,
                                    isLocked: isInteractionLocked,
                                    showSpinner:
                                        activeAccountAction ==
                                        AccountAction.signOut,
                                    borderColor: _kCoral.withValues(
                                      alpha: 0.5,
                                    ),
                                    textColor: _kCoral,
                                     onPressed: () => showLogoutFeedbackSheet(
                                       context: context,
                                       onConfirmLogout: () => context
                                           .read<AccountActionsCubit>()
                                           .signOut(),
                                     ),
                                  ),
                                  const SizedBox(height: 12),
                                ],

                                // Danger zone — account deletion
                                const SizedBox(height: 16),
                                _SectionCard(
                                  title: l10n.dangerZoneSectionTitle,
                                  titleColor: _kCoral,
                                  child: TextButton(
                                    onPressed: !isInteractionLocked
                                        ? () => Navigator.of(context).push<void>(
                                            MaterialPageRoute<void>(
                                              builder: (_) =>
                                                  const DeleteAccountConfirmationScreen(),
                                            ),
                                          )
                                        : null,
                                    style: TextButton.styleFrom(
                                      minimumSize: const Size(80, 48),
                                      foregroundColor: _kCoral,
                                    ),
                                    child: Text(l10n.deleteAccountButtonLabel),
                                  ),
                                ),

                                if (kDebugMode) ...[
                                  const Divider(height: 48),
                                  _ProfileSummary(session: session),
                                  const SizedBox(height: 12),
                                  OutlinedButton.icon(
                                    onPressed: !isInteractionLocked
                                        ? () =>
                                              Navigator.of(context).push<void>(
                                                MaterialPageRoute<void>(
                                                  builder: (_) =>
                                                      const DeveloperScreen(),
                                                ),
                                              )
                                        : null,
                                    icon: const Icon(Icons.developer_mode),
                                    label: Text(l10n.developerToolsTitle),
                                  ),
                                ],
                              ],
                            );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _hasUnsavedChanges(String firstName) {
    return _firstNameController.text.trim() != firstName.trim();
  }

  Future<bool> _confirmDiscardChanges(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.discardChangesTitle),
        content: Text(context.l10n.discardChangesBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.l10n.stayButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(context.l10n.discardButtonLabel),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  void _saveFirstName(BuildContext context, SessionState session) {
    final userId = session.userIdOrNull;
    if (userId == null) return;

    FocusScope.of(context).unfocus();
    context.read<ProfileCubit>().saveFirstName(
      userId: userId,
      firstName: _firstNameController.text,
    );
  }
}

// ---------------------------------------------------------------------------
// Reusable UI components (private to this file)
// ---------------------------------------------------------------------------

/// Contact & support: opens the device email client pre-filled with the support
/// address, a localized subject, and a diagnostic footer (user id) to ease debugging.
class _SupportSection extends StatelessWidget {
  const _SupportSection({this.userId});

  static const _supportEmail = 'aivolux@gmail.com';

  final String? userId;

  Future<void> _openEmail(BuildContext context) async {
    final l10n = context.l10n;
    final body = '\n\n---\nUser ID: ${userId ?? '-'}';
    final uri = Uri(
      scheme: 'mailto',
      path: _supportEmail,
      query: _encodeQuery({
        'subject': l10n.supportEmailSubject,
        'body': body,
      }),
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  // Uri query encoding that keeps spaces as %20 (mailto clients dislike '+').
  String _encodeQuery(Map<String, String> params) => params.entries
      .map((e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.supportSectionDescription,
          style: const TextStyle(color: _kTextMuted, fontSize: 13, height: 1.4),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => _openEmail(context),
          icon: const Icon(Icons.mail_outline),
          label: Text(l10n.supportContactButton),
        ),
      ],
    );
  }
}

/// Legal documents: privacy policy and terms of service links.
class _LegalSection extends StatefulWidget {
  const _LegalSection();

  @override
  State<_LegalSection> createState() => _LegalSectionState();
}

class _LegalSectionState extends State<_LegalSection> {
  // Replace these URLs with your actual hosted documents before production
  static const _privacyPolicyUrl = 'https://mestio.pl/privacy-policy';
  static const _termsOfServiceUrl = 'https://mestio.pl/terms-of-service';

  String? _errorKey;

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      if (mounted) setState(() => _errorKey = null);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) setState(() => _errorKey = 'errorUnknown');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.legalSectionDescription,
          style: const TextStyle(color: _kTextMuted, fontSize: 13, height: 1.4),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => _openUrl(_privacyPolicyUrl),
          icon: const Icon(Icons.privacy_tip_outlined),
          label: Text(l10n.privacyPolicyButton),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => _openUrl(_termsOfServiceUrl),
          icon: const Icon(Icons.description_outlined),
          label: Text(l10n.termsOfServiceButton),
        ),
        if (_errorKey != null) ...[
          const SizedBox(height: 8),
          SelectableText(
            l10n.errorUnknown,
            style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
          ),
        ],
      ],
    );
  }
}

/// GDPR data export section: compiles all user data into JSON and copies to clipboard.
class _DataExportSection extends StatelessWidget {
  const _DataExportSection({
    required this.userId,
    required this.email,
    required this.isLocked,
  });

  final String? userId;
  final String? email;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final exportState = context.watch<DataExportCubit>().state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.dataExportDescription,
          style: const TextStyle(color: _kTextMuted, fontSize: 13, height: 1.4),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: isLocked || userId == null
              ? null
              : () => context.read<DataExportCubit>().exportData(
                    userId: userId!,
                    email: email ?? '',
                  ),
          icon: exportState.isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.download_outlined),
          label: Text(l10n.dataExportButtonLabel),
        ),
        if (exportState.errorKey != null) ...[
          const SizedBox(height: 8),
          SelectableText(
            messageForErrorKey(l10n, exportState.errorKey),
            style: const TextStyle(color: _kCoral, fontSize: 13),
          ),
        ],
      ],
    );
  }
}

/// A white card with subtle border and shadow — the base "panel" in this design system.
class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child, this.title, this.titleColor});

  final Widget child;
  final String? title;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _kCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kBorderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null) ...[
              Text(
                title!,
                style: TextStyle(
                  color: titleColor ?? _kTextDark,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 12),
            ],
            child,
          ],
        ),
      ),
    );
  }
}

/// Gradient primary action button (Cyan Glow → Electric Indigo).
class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.label,
    required this.isLocked,
    required this.onPressed,
  });

  final String label;
  final bool isLocked;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: isLocked
              ? null
              : const LinearGradient(
                  colors: [_kCyan, _kIndigo],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          color: isLocked ? Colors.grey.shade300 : null,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isLocked
              ? null
              : [
                  BoxShadow(
                    color: _kIndigo.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLocked ? null : onPressed,
            borderRadius: BorderRadius.circular(12),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: isLocked ? Colors.grey.shade600 : Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Outlined secondary action button.
class _OutlineActionButton extends StatelessWidget {
  const _OutlineActionButton({
    required this.isLocked,
    required this.onPressed,
    this.label,
    this.showSpinner = false,
    this.borderColor,
    this.textColor,
  });

  final String? label;
  final bool isLocked;
  final bool showSpinner;
  final Color? borderColor;
  final Color? textColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final resolvedBorder = borderColor ?? _kBorderLight;
    final resolvedText = textColor ?? _kTextDark;

    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: isLocked ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: resolvedText,
          side: BorderSide(color: resolvedBorder, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: showSpinner
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: resolvedText,
                ),
              )
            : Text(
                label ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: resolvedText,
                ),
        ),
      ),
    );
  }
}

class _EstateCompanySection extends StatefulWidget {
  const _EstateCompanySection({required this.onManageCodes});

  final VoidCallback onManageCodes;

  @override
  State<_EstateCompanySection> createState() => _EstateCompanySectionState();
}

class _EstateCompanySectionState extends State<_EstateCompanySection> {
  String? _activeInvitationCode;
  bool _loadingCode = false;
  DateTime? _contractValidUntil;
  bool _loadingContract = false;

  @override
  void initState() {
    super.initState();
    _fetchCode();
    _fetchContract();
  }

  String? _activeEstateId() {
    final state = context.read<EstateMembershipCubit>().state;
    return switch (state) {
      EstateLoaded(activeEstate: final e?) => e.id,
      _ => null,
    };
  }

  void _fetchCode() async {
    final estateId = _activeEstateId();
    if (estateId == null) return;

    setState(() => _loadingCode = true);
    final code = await getIt<EstateRepository>().getActiveInvitationCode(estateId);
    if (mounted) {
      setState(() {
        _activeInvitationCode = code;
        _loadingCode = false;
      });
    }
  }

  void _fetchContract() async {
    final estateId = _activeEstateId();
    if (estateId == null) return;

    setState(() => _loadingContract = true);
    final validUntil = await getIt<EstateRepository>().getContractValidUntil(estateId);
    if (mounted) {
      setState(() {
        _contractValidUntil = validUntil;
        _loadingContract = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<EstateMembershipCubit>().state;

    final estate = switch (state) {
      EstateLoaded(activeEstate: final e?) => e,
      _ => null,
    };

    return _SectionCard(
      title: l10n.estateCompanySectionTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (estate != null) ...[
            _InfoRow(label: l10n.estateCompanySectionTitle, value: estate.companyName ?? l10n.estateCompanyNone),
            if (estate.adminName != null || estate.adminEmail != null || estate.adminPhone != null) ...[
              const SizedBox(height: 12),
              Text(
                l10n.estateAdminContact,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: _kTextDark),
              ),
              const SizedBox(height: 4),
              if (estate.adminName != null)
                Text(estate.adminName!, style: const TextStyle(fontSize: 13, color: _kTextMuted)),
              if (estate.adminEmail != null)
                Text(estate.adminEmail!, style: const TextStyle(fontSize: 13, color: _kTextMuted)),
              if (estate.adminPhone != null)
                Text(estate.adminPhone!, style: const TextStyle(fontSize: 13, color: _kTextMuted)),
            ],
            const SizedBox(height: 12),
            _ContractCountdownRow(
              isLoading: _loadingContract,
              validUntil: _contractValidUntil,
            ),
            const SizedBox(height: 12),
            _InfoRow(
              label: l10n.estateInvitationCodeLabel,
              value: _loadingCode
                  ? '…'
                  : (_activeInvitationCode ?? l10n.estateNoInvitationCode),
              trailing: _activeInvitationCode != null
                  ? IconButton(
                      icon: const Icon(Icons.copy, size: 18, color: _kIndigo),
                      tooltip: l10n.estateCopyCodeButton,
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: _activeInvitationCode!));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.estateCodeCopiedSnackbar)),
                        );
                      },
                    )
                  : null,
            ),
          ] else ...[
            Text(
              l10n.errorNoEstate,
              style: const TextStyle(color: _kTextMuted, fontSize: 13),
            ),
          ],
          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: const Icon(Icons.qr_code_2, size: 18),
            label: Text(l10n.estateGenerateCodeButton),
            onPressed: widget.onManageCodes,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, this.trailing});

  final String label;
  final String value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: _kTextDark)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 13, color: _kTextMuted)),
            ],
          ),
        ),
        ?trailing,
      ],
    );
  }
}

/// Contract-end countdown (MASTER_BUILD par.16): green when comfortably
/// active, amber inside the last 30 days, red inside the last 7 - or when
/// already expired.
class _ContractCountdownRow extends StatelessWidget {
  const _ContractCountdownRow({required this.isLoading, required this.validUntil});

  final bool isLoading;
  final DateTime? validUntil;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    String value;
    Color color;
    if (isLoading) {
      value = '…';
      color = _kTextMuted;
    } else if (validUntil == null) {
      value = l10n.estateContractNone;
      color = _kTextMuted;
    } else {
      final daysLeft = validUntil!.difference(DateTime.now()).inDays;
      if (daysLeft < 0) {
        value = l10n.estateContractExpired;
        color = const Color(0xFFC0392B);
      } else {
        value = l10n.estateContractDaysLeft(daysLeft);
        color = daysLeft <= 7
            ? const Color(0xFFC0392B)
            : daysLeft <= 30
                ? const Color(0xFFF2A900)
                : const Color(0xFF2E9E6B);
      }
    }

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.estateContractValidUntilLabel,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: _kTextDark),
              ),
              const SizedBox(height: 2),
              Text(value, style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}

/// Premium PRO upgrade button with a golden/indigo glow icon.
class _ProButton extends StatelessWidget {
  const _ProButton({
    required this.label,
    required this.isLocked,
    required this.onPressed,
  });

  final String label;
  final bool isLocked;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: isLocked
              ? null
              : const LinearGradient(
                  colors: [Color(0xFFFF9F0A), _kIndigo],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          color: isLocked ? Colors.grey.shade300 : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLocked ? null : onPressed,
            borderRadius: BorderRadius.circular(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.workspace_premium_outlined,
                  color: isLocked ? Colors.grey.shade600 : Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: isLocked ? Colors.grey.shade600 : Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Save button that shows either a filled or outlined style depending on context.
class _SaveButton extends StatelessWidget {
  const _SaveButton({
    required this.isSaving,
    required this.isPrimary,
    required this.isLocked,
    required this.label,
    required this.onPressed,
  });

  final bool isSaving;
  final bool isPrimary;
  final bool isLocked;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final child = isSaving
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
        : Text(label);

    if (isPrimary) {
      return SizedBox(
        height: 48,
        child: FilledButton(
          onPressed: isLocked ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: _kIndigo,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: child,
        ),
      );
    }

    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed: isLocked ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: _kIndigo),
          foregroundColor: _kIndigo,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isSaving
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: _kIndigo,
                ),
              )
            : Text(label),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Language dropdown
// ---------------------------------------------------------------------------

class _AppLanguageDropdown extends StatelessWidget {
  const _AppLanguageDropdown({required this.isEnabled});

  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<AppLocaleCubit, AppLocaleState>(
      builder: (context, state) {
        final isSelectionEnabled = isEnabled && !state.isSaving;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<AppLocaleOptionModel>(
              initialValue: state.selectedOption,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.language_outlined,
                  color: _kCyan,
                ),
                helperText: l10n.profileLanguageSectionDescription,
                filled: true,
                fillColor: _kCanvas,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _kBorderLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _kCyan, width: 1.5),
                ),
              ),
              items: [
                DropdownMenuItem(
                  value: AppLocaleOptionModel.system,
                  child: Text(l10n.languageOptionSystem),
                ),
                DropdownMenuItem(
                  value: AppLocaleOptionModel.polish,
                  child: Text(l10n.languageOptionPolish),
                ),
                DropdownMenuItem(
                  value: AppLocaleOptionModel.english,
                  child: Text(l10n.languageOptionEnglish),
                ),
                DropdownMenuItem(
                  value: AppLocaleOptionModel.ukrainian,
                  child: Text(l10n.languageOptionUkrainian),
                ),
              ],
              onChanged: isSelectionEnabled
                  ? (option) {
                      if (option == null) return;
                      context.read<AppLocaleCubit>().selectLocale(option);
                    }
                  : null,
            ),
            if (state.selectedOption == AppLocaleOptionModel.system) ...[
              const SizedBox(height: 4),
              Text(
                l10n.languageOptionSystemDescription,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _kTextMuted,
                ),
              ),
            ],
            if (state.errorKey != null) ...[
              const SizedBox(height: 8),
              SelectableText(
                messageForErrorKey(l10n, state.errorKey),
                style: const TextStyle(color: _kCoral, fontSize: 13),
              ),
            ],
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Debug-only session summary
// ---------------------------------------------------------------------------

class _ProfileSummary extends StatelessWidget {
  const _ProfileSummary({required this.session});

  final SessionState session;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: _kCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kBorderLight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.sessionDisplayName(session),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: _kTextDark,
              ),
            ),
            const SizedBox(height: 12),
            SelectableText(l10n.sessionUserId(session.userIdOrNull ?? '-')),
            const SizedBox(height: 8),
            SelectableText(l10n.sessionEmail(session.emailOrNull ?? '-')),
            const SizedBox(height: 8),
            SelectableText(
              l10n.sessionAccountType(context.accountTypeLabel(session)),
            ),
            const SizedBox(height: 8),
            SelectableText(
              l10n.sessionPro(context.booleanLabel(session.isProUser)),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// PRO protection banner (shown when user has Pro but is anonymous)
// ---------------------------------------------------------------------------

class _ProtectProBanner extends StatelessWidget {
  const _ProtectProBanner();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: _kCoral.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kCoral.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.warning_amber_rounded, color: _kCoral, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.protectProBannerTitle,
                    style: const TextStyle(
                      color: _kCoral,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.protectProBannerBody,
                    style: TextStyle(
                      color: _kCoral.withValues(alpha: 0.85),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
