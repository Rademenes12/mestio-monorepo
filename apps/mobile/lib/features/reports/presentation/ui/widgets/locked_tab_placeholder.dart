import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../l10n/l10n.dart';

/// Shown instead of a Pro-only tab (Finance/Communicator/Phone) when the
/// estate does not have an active subscription.
///
/// Note: Since RevenueCat has been removed and all users get unlimited Pro
/// access, this placeholder should rarely (if ever) be shown.
class LockedTabPlaceholder extends StatelessWidget {
  const LockedTabPlaceholder({super.key, required this.featureType});

  final String featureType;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    String title = '';
    String desc = '';
    IconData icon = Icons.lock_outline;

    if (featureType == 'finanse') {
      title = l10n.proLockFinanceTitle;
      desc = l10n.proLockFinanceDesc;
      icon = Icons.monetization_on_outlined;
    } else if (featureType == 'komunikator') {
      title = l10n.proLockCommunicatorTitle;
      desc = l10n.proLockCommunicatorDesc;
      icon = Icons.chat_outlined;
    } else if (featureType == 'telefon') {
      title = l10n.proLockPhoneTitle;
      desc = l10n.proLockPhoneDesc;
      icon = Icons.phone_outlined;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.electricIndigo.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.electricIndigo, size: 40),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                desc,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.lightTextSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
