import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import '../../../core/config/app_config.dart';
import '../../../core/config/revenuecat_config.dart';
import '../../../core/di/injection.dart';
import '../../../features/connectivity/presentation/cubit/connectivity_cubit.dart';
import '../../../l10n/l10n.dart';
import '../../profile/presentation/cubit/account_actions_cubit.dart';
import '../../session/presentation/cubit/session_cubit.dart';
import '../../session/presentation/session_localizations.dart';
import 'screenshots/screenshot_1_screen.dart';
import 'screenshots/screenshot_2_screen.dart';
import 'screenshots/screenshot_3_screen.dart';
import 'screenshots/screenshot_4_screen.dart';
import 'screenshots/screenshot_5_screen.dart';

class DeveloperScreen extends StatelessWidget {
  const DeveloperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SessionCubit>.value(value: getIt<SessionCubit>()),
        BlocProvider<AccountActionsCubit>(
          create: (_) => getIt<AccountActionsCubit>(),
        ),
      ],
      child: const _DeveloperView(),
    );
  }
}

class _DeveloperView extends StatelessWidget {
  const _DeveloperView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final isDebugMissingTestStoreKey =
        kDebugMode &&
        RevenueCatConfig.hasPlatformKey &&
        !RevenueCatConfig.hasTestStoreKey;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.developerToolsTitle)),
      body: SafeArea(
        child: BlocBuilder<SessionCubit, SessionState>(
          builder: (context, session) {
            final userId = session.userIdOrNull;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.developerDiagnosticsTitle,
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.developerDiagnosticsBody,
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 24),
                      if (!RevenueCatConfig.isEnabled) ...[
                        _WarningCard(
                          title: l10n.revenueCatDisconnectedTitle,
                          body: l10n.revenueCatDisconnectedBody,
                        ),
                        const SizedBox(height: 24),
                      ],
                      if (isDebugMissingTestStoreKey) ...[
                        _WarningCard(
                          title: l10n.revenueCatDebugMissingTestStoreTitle,
                          body: l10n.revenueCatDebugMissingTestStoreBody,
                        ),
                        const SizedBox(height: 24),
                      ],
                      _SectionCard(
                        title: l10n.sessionSectionTitle,
                        children: [
                          _SelectableInfoRow(
                            label: l10n.firstNameFieldLabel,
                            value: session.sharedUserOrNull?.firstName ?? '-',
                          ),
                          _InfoRow(
                            label: l10n.loggedInLabel,
                            value: context.booleanLabel(
                              session.isAuthenticated,
                            ),
                          ),
                          _InfoRow(
                            label: l10n.anonymousLabel,
                            value: context.booleanLabel(
                              session.isAnonymousUser,
                            ),
                          ),
                          _InfoRow(
                            label: l10n.limitAccessLabel,
                            value: context.limitAccessLabel(
                              session.limitAccessState,
                            ),
                          ),
                          _InfoRow(
                            label: l10n.proLabel,
                            value: context.booleanLabel(session.isProUser),
                          ),
                          _SelectableInfoRow(
                            label: l10n.userIdLabel,
                            value: session.userIdOrNull ?? '-',
                          ),
                          _SelectableInfoRow(
                            label: l10n.emailLabel,
                            value: session.emailOrNull ?? '-',
                          ),
                          _SelectableInfoRow(
                            label: l10n.displayNameLabel,
                            value: context.sessionDisplayName(session),
                          ),
                          BlocBuilder<ConnectivityCubit, ConnectivityState>(
                            builder: (context, connectivity) {
                              final statusText = switch (connectivity) {
                                ConnectivityConnected() =>
                                  l10n.connectivityStatusConnected,
                                ConnectivityDisconnected() =>
                                  l10n.connectivityStatusDisconnected,
                                ConnectivityUnknown() =>
                                  l10n.connectivityStatusChecking,
                              };
                              return _InfoRow(
                                label: l10n.connectivityLabel,
                                value: statusText,
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _SectionCard(
                        title: l10n.supabaseSectionTitle,
                        children: [
                          _InfoRow(
                            label: l10n.keysConfiguredLabel,
                            value: context.booleanLabel(
                              AppConfig.hasSupabaseKeys,
                            ),
                          ),
                          _SelectableInfoRow(
                            label: l10n.supabaseUrlLabel,
                            value: AppConfig.hasSupabaseKeys
                                ? AppConfig.maskedSupabaseUrl
                                : l10n.missingValueLabel,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _SectionCard(
                        title: l10n.revenueCatSectionTitle,
                        children: [
                          _InfoRow(
                            label: l10n.supportedPlatformLabel,
                            value: context.booleanLabel(
                              RevenueCatConfig.isSupportedPlatform,
                            ),
                          ),
                          _InfoRow(
                            label: l10n.platformKeyConfiguredLabel,
                            value: context.booleanLabel(
                              RevenueCatConfig.hasPlatformKey,
                            ),
                          ),
                          _InfoRow(
                            label: l10n.testStoreKeyConfiguredLabel,
                            value: context.booleanLabel(
                              RevenueCatConfig.hasTestStoreKey,
                            ),
                          ),
                          _InfoRow(
                            label: l10n.sdkActiveLabel,
                            value: context.booleanLabel(
                              RevenueCatConfig.isEnabled,
                            ),
                          ),
                          _InfoRow(
                            label: l10n.activeKeyTypeLabel,
                            value: _activeKeyTypeLabel(
                              l10n,
                              RevenueCatConfig.activeKeyType,
                            ),
                          ),
                          _SelectableInfoRow(
                            label: l10n.activeSdkKeyLabel,
                            value: RevenueCatConfig.activeApiKey.isNotEmpty
                                ? RevenueCatConfig.maskedActiveApiKey
                                : l10n.missingValueLabel,
                          ),
                          _InfoRow(
                            label: l10n.proSourceLabel,
                            value: RevenueCatConfig.isEnabled
                                ? l10n.proSourceRevenueCat
                                : l10n.proSourceDeveloperOverride,
                          ),
                          if (!RevenueCatConfig.isEnabled &&
                              session.isAuthenticated &&
                              userId != null) ...[
                            const SizedBox(height: 8),
                            BlocBuilder<
                              AccountActionsCubit,
                              AccountActionsState
                            >(
                              builder: (context, accountState) {
                                final isLoading =
                                    accountState.activeAction ==
                                    AccountAction.developerProOverride;

                                return SwitchListTile(
                                  value: session.isProUser,
                                  onChanged: isLoading
                                      ? null
                                      : (value) {
                                          context
                                              .read<AccountActionsCubit>()
                                              .setDeveloperProOverride(
                                                userId: userId,
                                                isPro: value,
                                              );
                                        },
                                  title: Text(l10n.debugForceProTitle),
                                  subtitle: Text(l10n.debugForceProSubtitle),
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 20),
                      _SectionCard(
                        title: l10n.storeScreenshotsSectionTitle,
                        children: [
                          _NavigationRow(
                            label: l10n.storeScreenshot1ButtonLabel,
                            builder: (_) => const Screenshot1Screen(),
                          ),
                          _NavigationRow(
                            label: l10n.storeScreenshot2ButtonLabel,
                            builder: (_) => const Screenshot2Screen(),
                          ),
                          _NavigationRow(
                            label: l10n.storeScreenshot3ButtonLabel,
                            builder: (_) => const Screenshot3Screen(),
                          ),
                          _NavigationRow(
                            label: l10n.storeScreenshot4ButtonLabel,
                            builder: (_) => const Screenshot4Screen(),
                          ),
                          _NavigationRow(
                            label: l10n.storeScreenshot5ButtonLabel,
                            builder: (_) => const Screenshot5Screen(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

String _activeKeyTypeLabel(
  AppLocalizations l10n,
  RevenueCatActiveKeyType keyType,
) {
  return switch (keyType) {
    RevenueCatActiveKeyType.none => l10n.activeKeyTypeMissing,
    RevenueCatActiveKeyType.testStore => l10n.activeKeyTypeTestStore,
    RevenueCatActiveKeyType.appStore => l10n.activeKeyTypeAppStore,
    RevenueCatActiveKeyType.googlePlay => l10n.activeKeyTypeGooglePlay,
  };
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onErrorContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              body,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _SelectableInfoRow extends StatelessWidget {
  const _SelectableInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: SelectableText(value)),
        ],
      ),
    );
  }
}

class _NavigationRow extends StatelessWidget {
  const _NavigationRow({required this.label, required this.builder});

  final String label;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) =>
                    _ScreenshotSystemUi(child: builder(context)),
              ),
            );
          },
          child: Text(label),
        ),
      ),
    );
  }
}

class _ScreenshotSystemUi extends StatefulWidget {
  const _ScreenshotSystemUi({required this.child});

  final Widget child;

  @override
  State<_ScreenshotSystemUi> createState() => _ScreenshotSystemUiState();
}

class _ScreenshotSystemUiState extends State<_ScreenshotSystemUi> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: const [],
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
