import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/error_messages.dart';
import '../cubit/forgot_password_cubit.dart';
import 'reset_password_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ForgotPasswordCubit>(
      create: (_) => getIt<ForgotPasswordCubit>(),
      child: const _ForgotPasswordView(),
    );
  }
}

class _ForgotPasswordView extends StatefulWidget {
  const _ForgotPasswordView();

  @override
  State<_ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<_ForgotPasswordView> {
  late final TextEditingController _emailController;
  late final FocusNode _emailFocusNode;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _emailFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state.successKey != 'password_reset_code_sent') return;

        context.read<ForgotPasswordCubit>().clearFeedback();
        Navigator.of(context).push<void>(
          MaterialPageRoute<void>(
            builder: (_) => ResetPasswordScreen(
              email: state.submittedEmail ?? _emailController.text.trim(),
            ),
          ),
        );
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
                        // Top Building Header with Fade
                        SizedBox(
                          height: imageContainerHeight,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: ShaderMask(
                                  shaderCallback: (rect) {
                                    return const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Colors.black, Colors.transparent],
                                      stops: [0.65, 1.0],
                                    ).createShader(
                                      Rect.fromLTRB(0, 0, rect.width, rect.height),
                                    );
                                  },
                                  blendMode: BlendMode.dstIn,
                                  child: Image.asset(
                                    'assets/images/building_image.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Form Section
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 420),
                                child: BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
                                  builder: (context, state) {
                                    final isLoading = state.isLoading;

                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          l10n.forgotPasswordTitle,
                                          style: theme.textTheme.headlineMedium?.copyWith(
                                            fontWeight: FontWeight.w800,
                                            color: const Color(0xFF1A1A24),
                                            fontSize: 26,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          l10n.forgotPasswordBody,
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            color: const Color(0xFF636375),
                                          ),
                                        ),
                                        const SizedBox(height: 24),
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
                                          textInputAction: TextInputAction.done,
                                          onSubmitted: (_) => _submit(context),
                                        ),
                                        if (state.errorKey != null) ...[
                                          const SizedBox(height: 16),
                                          SelectableText(
                                            messageForErrorKey(l10n, state.errorKey),
                                            style: TextStyle(
                                              color: theme.colorScheme.error,
                                            ),
                                          ),
                                        ],
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
                                                          l10n.sendResetCodeButtonLabel,
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
    context.read<ForgotPasswordCubit>().sendCode(
      email: _emailController.text,
    );
  }
}
