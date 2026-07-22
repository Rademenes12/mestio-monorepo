import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/session/presentation/cubit/session_cubit.dart';
import '../../../../core/di/injection.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/error_messages.dart';
import '../../../../shared/widgets/consent_text.dart';
import '../cubit/register_cubit.dart';

class RegisterScreen extends StatelessWidget {
  final String? initialEmail;

  const RegisterScreen({super.key, this.initialEmail});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SessionCubit>.value(value: getIt<SessionCubit>()),
        BlocProvider<RegisterCubit>(create: (_) => getIt<RegisterCubit>()),
      ],
      child: _RegisterView(initialEmail: initialEmail),
    );
  }
}

class _RegisterView extends StatefulWidget {
  final String? initialEmail;
  const _RegisterView({this.initialEmail});

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmController;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  late final FocusNode _confirmFocusNode;
  String? _localErrorKey;
  // GDPR / App Store 5.1.1(i): require explicit consent before account creation.
  bool _acceptedTerms = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail);
    _passwordController = TextEditingController();
    _confirmController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _confirmFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<SessionCubit, SessionState>(
      listenWhen: (previous, current) =>
          !previous.isAuthenticated && current.isAuthenticated,
      listener: (context, state) {
        Navigator.of(context).pop(true);
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
              final imageContainerHeight = height * 0.28;
              final theme = Theme.of(context);

              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: height),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Top gradient header
                        Container(
                          height: imageContainerHeight,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFF0A84FF).withValues(alpha: 0.1),
                                const Color(0xFF5E5CE6).withValues(alpha: 0.05),
                              ],
                            ),
                          ),
                        ),

                        // Form Section
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 420),
                                child: BlocBuilder<RegisterCubit, RegisterState>(
                                  builder: (context, state) {
                                    final isLoading = state.isLoading;

                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          l10n.createAccountTitle,
                                          style: theme.textTheme.headlineMedium?.copyWith(
                                            fontWeight: FontWeight.w800,
                                            color: const Color(0xFF1A1A24),
                                            fontSize: 26,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          l10n.createAccountBody,
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            color: const Color(0xFF636375),
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        TextField(
                                          controller: _emailController,
                                          focusNode: _emailFocusNode,
                                          enabled: !isLoading && (widget.initialEmail == null || widget.initialEmail!.isEmpty),
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
                                          onSubmitted: (_) =>
                                              _passwordFocusNode.requestFocus(),
                                        ),
                                        const SizedBox(height: 16),
                                        TextField(
                                          controller: _passwordController,
                                          focusNode: _passwordFocusNode,
                                          enabled: !isLoading,
                                          keyboardType: TextInputType.visiblePassword,
                                          textCapitalization: TextCapitalization.none,
                                          autofillHints: const [AutofillHints.newPassword],
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
                                          textInputAction: TextInputAction.next,
                                          onSubmitted: (_) =>
                                              _confirmFocusNode.requestFocus(),
                                        ),
                                        const SizedBox(height: 16),
                                        TextField(
                                          controller: _confirmController,
                                          focusNode: _confirmFocusNode,
                                          enabled: !isLoading,
                                          keyboardType: TextInputType.visiblePassword,
                                          textCapitalization: TextCapitalization.none,
                                          autofillHints: const [AutofillHints.newPassword],
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            labelText: l10n.passwordConfirmFieldLabel,
                                            prefixIcon: const Icon(Icons.lock_reset, color: Color(0xFF0A84FF)),
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
                                        if (_localErrorKey != null) ...[
                                          const SizedBox(height: 16),
                                          SelectableText(
                                            messageForErrorKey(l10n, _localErrorKey),
                                            style: TextStyle(
                                              color: theme.colorScheme.error,
                                            ),
                                          ),
                                        ] else if (state.errorKey != null) ...[
                                          const SizedBox(height: 16),
                                          SelectableText(
                                            messageForErrorKey(l10n, state.errorKey),
                                            style: TextStyle(
                                              color: theme.colorScheme.error,
                                            ),
                                          ),
                                        ],
                                        const SizedBox(height: 16),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 24,
                                              width: 24,
                                              child: Checkbox(
                                                value: _acceptedTerms,
                                                onChanged: isLoading
                                                    ? null
                                                    : (v) => setState(
                                                        () => _acceptedTerms = v ?? false),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 2),
                                                child: ConsentText(
                                                  isDark: false,
                                                  l10n: l10n,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 24),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 56,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [Color(0xFF0A84FF), Color(0xFF5E5CE6)],
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                              ),
                                              borderRadius: BorderRadius.circular(28),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(0xFF5E5CE6).withValues(alpha: 0.25),
                                                  blurRadius: 16,
                                                  offset: const Offset(0, 6),
                                                ),
                                              ],
                                            ),
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                onTap: isLoading ? null : () => _submit(context),
                                                borderRadius: BorderRadius.circular(28),
                                                child: Center(
                                                  child: isLoading
                                                      ? const SizedBox(
                                                          width: 24,
                                                          height: 24,
                                                          child: CircularProgressIndicator(
                                                            strokeWidth: 2.5,
                                                            color: Colors.white,
                                                          ),
                                                        )
                                              : Text(
                                                  l10n.registerSubmitButton,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
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
                          ),
                        ),
                      ],
                    ),
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
    // Local validation for matching password confirmation. We surface this
    // through `_localErrorKey` so it uses the same red-text channel as
    // server-side auth errors.
    if (_passwordController.text != _confirmController.text) {
      setState(() => _localErrorKey = 'passwords_do_not_match');
      return;
    }
    if (!_acceptedTerms) {
      setState(() => _localErrorKey = 'terms_not_accepted');
      return;
    }
    setState(() => _localErrorKey = null);
    context.read<RegisterCubit>().register(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }
}
