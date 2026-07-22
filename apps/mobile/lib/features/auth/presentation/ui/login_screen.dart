import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/session/presentation/cubit/session_cubit.dart';
import '../../../../core/di/injection.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/error_messages.dart';
import '../cubit/login_cubit.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SessionCubit>.value(value: getIt<SessionCubit>()),
        BlocProvider<LoginCubit>(create: (_) => getIt<LoginCubit>()),
      ],
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionCubit>().state;
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (previous, current) =>
          previous.isLoading && !current.isLoading && current.errorKey == null,
      listener: (context, state) {
        Navigator.of(context, rootNavigator: true).popUntil((route) => route.isFirst);
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: AppColors.lightCanvas,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1A1A24)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SafeArea(
            top: false,
            child: LayoutBuilder(
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

                      const SizedBox(height: 24),

                      // Form section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 420),
                          child: BlocBuilder<LoginCubit, LoginState>(
                            builder: (context, state) {
                              final isLoading = state.isLoading;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if (session.isAuthenticated && session.isAnonymousUser) ...[
                                    const _GuestSwitchWarning(),
                                    const SizedBox(height: 16),
                                  ],
                                  Text(
                                    l10n.loginExistingAccountTitle,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF1A1A24),
                                      fontSize: 24,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    l10n.loginExistingAccountBody,
                                    style: const TextStyle(color: Color(0xFF636375), fontSize: 13),
                                  ),
                                  const SizedBox(height: 20),
                                  TextField(
                                    controller: _emailController,
                                    focusNode: _emailFocusNode,
                                    enabled: !isLoading,
                                    keyboardType: TextInputType.emailAddress,
                                    textCapitalization: TextCapitalization.none,
                                    autofillHints: const [AutofillHints.email],
                                    decoration: InputDecoration(
                                      labelText: l10n.emailFieldLabel,
                                      prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF0A84FF)),
                                      filled: true,
                                      fillColor: const Color(0xFFF5F7FA),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.05)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Color(0xFF0A84FF), width: 1.5),
                                      ),
                                      labelStyle: const TextStyle(color: Color(0xFF636375)),
                                    ),
                                    textInputAction: TextInputAction.next,
                                    onSubmitted: (_) => _passwordFocusNode.requestFocus(),
                                  ),
                                  const SizedBox(height: 14),
                                  TextField(
                                    controller: _passwordController,
                                    focusNode: _passwordFocusNode,
                                    enabled: !isLoading,
                                    keyboardType: TextInputType.visiblePassword,
                                    textCapitalization: TextCapitalization.none,
                                    autofillHints: const [AutofillHints.password],
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      labelText: l10n.passwordFieldLabel,
                                      prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF0A84FF)),
                                      filled: true,
                                      fillColor: const Color(0xFFF5F7FA),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.05)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Color(0xFF0A84FF), width: 1.5),
                                      ),
                                      labelStyle: const TextStyle(color: Color(0xFF636375)),
                                    ),
                                    textInputAction: TextInputAction.done,
                                    onSubmitted: (_) => _submit(context),
                                  ),
                                  const SizedBox(height: 6),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: isLoading ? null : () => Navigator.of(context).push<void>(
                                        MaterialPageRoute<void>(builder: (_) => const ForgotPasswordScreen()),
                                      ),
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      ),
                                      child: Text(
                                        l10n.forgotPasswordButtonLabel,
                                        style: const TextStyle(color: Color(0xFF5E5CE6), fontWeight: FontWeight.w600, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  if (state.errorKey != null) ...[
                                    const SizedBox(height: 8),
                                    SelectableText(
                                      messageForErrorKey(l10n, state.errorKey),
                                      style: TextStyle(color: theme.colorScheme.error, fontSize: 12),
                                    ),
                                  ],
                                  const SizedBox(height: 20),
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
                                          onTap: isLoading ? null : () => _submit(context),
                                          borderRadius: BorderRadius.circular(24),
                                          child: Center(
                                            child: isLoading
                                                ? const SizedBox(
                                                    width: 22, height: 22,
                                                    child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                                                  )
                                                : Text(
                                                    l10n.loginButtonLabel,
                                                    style: const TextStyle(
                                                      color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            ),
          ),
        ),
      ),
    );
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();
    context.read<LoginCubit>().login(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }
}

class _GuestSwitchWarning extends StatelessWidget {
  const _GuestSwitchWarning();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.switchAccountWarningTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onErrorContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.switchAccountWarningBody,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
