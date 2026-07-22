import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/l10n.dart';
import '../cubit/estate_cubit.dart';

/// Shown when the authenticated user does not yet belong to any estate.
/// Residents join with an invitation code; administrators create a new estate.
class EstateOnboardingScreen extends StatefulWidget {
  const EstateOnboardingScreen({super.key});

  @override
  State<EstateOnboardingScreen> createState() => _EstateOnboardingScreenState();
}

class _EstateOnboardingScreenState extends State<EstateOnboardingScreen> {
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.estateOnboardingTitle)),
      body: SafeArea(
        child: BlocConsumer<EstateMembershipCubit, EstateState>(
          listener: (context, state) {
            if (state is EstateLoaded && state.activeEstate != null) {
              // Joined/created successfully; AppGate will route forward.
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.estateJoinedSnackbar)),
              );
            }
          },
          builder: (context, state) {
            final isSubmitting =
                state is EstateLoaded && state.isSubmitting;
            final errorKey =
                state is EstateLoaded ? state.errorKey : null;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.estateOnboardingSubtitle,
                    style: const TextStyle(fontSize: 14, height: 1.4),
                  ),
                  const SizedBox(height: 24),
                  _JoinCard(
                    controller: _codeController,
                    isSubmitting: isSubmitting,
                    onJoin: () => context
                        .read<EstateMembershipCubit>()
                        .redeemCode(_codeController.text.trim()),
                  ),
                  if (errorKey != null) ...[
                    const SizedBox(height: 12),
                    SelectableText(
                      _mapEstateError(l10n, errorKey),
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ],
                  const SizedBox(height: 24),
                  _CreateCard(
                    controller: _nameController,
                    isSubmitting: isSubmitting,
                    onCreate: () => context
                        .read<EstateMembershipCubit>()
                        .createEstate(_nameController.text.trim()),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _mapEstateError(AppLocalizations l10n, String key) {
    // Errors are shown inline. Reuse the onboarding subtitle as a safe generic
    // fallback; a dedicated error string can be added later if needed.
    return l10n.estateOnboardingSubtitle;
  }
}

class _JoinCard extends StatelessWidget {
  const _JoinCard({
    required this.controller,
    required this.isSubmitting,
    required this.onJoin,
  });

  final TextEditingController controller;
  final bool isSubmitting;
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.estateJoinSectionTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              textCapitalization: TextCapitalization.characters,
              enabled: !isSubmitting,
              decoration: InputDecoration(
                labelText: l10n.estateCodeFieldLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: isSubmitting ? null : onJoin,
              child: isSubmitting
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.estateJoinButton),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateCard extends StatelessWidget {
  const _CreateCard({
    required this.controller,
    required this.isSubmitting,
    required this.onCreate,
  });

  final TextEditingController controller;
  final bool isSubmitting;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.estateCreateSectionTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              enabled: !isSubmitting,
              decoration: InputDecoration(
                labelText: l10n.estateNameFieldLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: isSubmitting ? null : onCreate,
              child: Text(l10n.estateCreateButton),
            ),
          ],
        ),
      ),
    );
  }
}
