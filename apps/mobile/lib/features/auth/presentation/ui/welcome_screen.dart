import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/di/injection.dart';
import '../../../../app/locale/models/app_locale_option_model.dart';
import '../../../../app/locale/presentation/cubit/app_locale_cubit.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/error_messages.dart';
import '../cubit/welcome_cubit.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WelcomeCubit>(create: (_) => getIt<WelcomeCubit>()),
        BlocProvider<AppLocaleCubit>.value(value: getIt<AppLocaleCubit>()),
      ],
      child: const _WelcomeView(),
    );
  }
}

class _WelcomeView extends StatelessWidget {
  const _WelcomeView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.lightCanvas,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;
          final imageHeight = height * 0.35;

          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: height),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Building image
                  SizedBox(
                    height: imageHeight,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ShaderMask(
                          shaderCallback: (rect) => LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black, Colors.transparent],
                            stops: [0.75, 1.0],
                          ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height)),
                          blendMode: BlendMode.dstIn,
                          child: Image.asset(
                            'assets/images/building_image.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Logo overlapping
                  Transform.translate(
                    offset: const Offset(0, -40),
                    child: Center(
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.asset(
                          'assets/images/mestio_logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Title
                  Text(
                    l10n.welcomeTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A24),
                      fontSize: 24,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    l10n.welcomeSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF1A1A24).withValues(alpha: 0.5),
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Error
                  BlocBuilder<WelcomeCubit, WelcomeState>(
                    builder: (context, state) {
                      if (state.errorKey == null) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: SelectableText(
                          messageForErrorKey(l10n, state.errorKey),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: theme.colorScheme.error, fontSize: 12),
                        ),
                      );
                    },
                  ),

                  // Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF0A84FF), Color(0xFF5E5CE6)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF5E5CE6).withValues(alpha: 0.25),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => Navigator.of(context).push<void>(
                                  MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
                                ),
                                borderRadius: BorderRadius.circular(24),
                                child: Center(
                                  child: Text(
                                    l10n.loginButtonLabel,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).push<void>(
                              MaterialPageRoute<void>(builder: (_) => const RegisterScreen()),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF5E5CE6),
                              side: const BorderSide(color: Color(0xFF5E5CE6), width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: Text(
                              l10n.registerButtonLabel,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Guest access (AGENTS.md Auth): signInAnonymously(), no
                        // classic sign-up. Upgrading to a full account happens
                        // later from the Profile screen.
                        BlocBuilder<WelcomeCubit, WelcomeState>(
                          builder: (context, state) {
                            return TextButton(
                              onPressed: state.isLoading
                                  ? null
                                  : () => context.read<WelcomeCubit>().continueAsGuest(),
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF636375),
                              ),
                              child: state.isLoading
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : Text(
                                      l10n.continueAsGuestButton,
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                    ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Privacy & Terms links
                  _PrivacyTerms(isDark: false, l10n: l10n),
                  const SizedBox(height: 8),
                  // Locale picker
                  _LocaleRow(),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PrivacyTerms extends StatefulWidget {
  const _PrivacyTerms({required this.isDark, required this.l10n});
  final bool isDark;
  final AppLocalizations l10n;

  @override
  State<_PrivacyTerms> createState() => _PrivacyTermsState();
}

class _PrivacyTermsState extends State<_PrivacyTerms> {
  late final _privacyTap = TapGestureRecognizer()
          ..onTap = () => _openUrl('https://mestio.pl/privacy-policy');
  late final _termsTap = TapGestureRecognizer()
          ..onTap = () => _openUrl('https://mestio.pl/terms-of-service');

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void dispose() {
    _privacyTap.dispose();
    _termsTap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = const TextStyle(fontSize: 11, color: Color(0xFF636375));
    final linkStyle = baseStyle.copyWith(
      color: AppColors.electricIndigo,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.underline,
    );
    return Center(
      child: RichText(
        text: TextSpan(
          style: baseStyle,
          children: [
            TextSpan(
              text: widget.l10n.privacyPolicyButton,
              style: linkStyle,
              recognizer: _privacyTap,
            ),
            const TextSpan(text: ' · '),
            TextSpan(
              text: widget.l10n.termsOfServiceButton,
              style: linkStyle,
              recognizer: _termsTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _LocaleRow extends StatelessWidget {
  static const _labels = {
    'system': 'System',
    'en': 'EN',
    'pl': 'PL',
    'uk': 'UK',
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppLocaleCubit, AppLocaleState>(
      builder: (context, state) {
        final selected = state.selectedOption;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: AppLocaleOptionModel.values.map((opt) {
            final isSelected = opt == selected;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: TextButton(
                onPressed: isSelected ? null : () => context.read<AppLocaleCubit>().selectLocale(opt),
                style: TextButton.styleFrom(
                  foregroundColor: isSelected ? const Color(0xFF0A84FF) : const Color(0xFF636375),
                  textStyle: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: Text(_labels[opt.storageValue] ?? opt.name.toUpperCase()),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
