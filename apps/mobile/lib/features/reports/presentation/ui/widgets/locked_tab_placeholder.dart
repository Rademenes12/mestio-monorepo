import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../app/paywall/presentation/paywall_presenter.dart';
import '../../../../../l10n/l10n.dart';

/// Shown instead of a Pro-only tab (Finance/Communicator/Phone) when the
/// estate does not have an active subscription.
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
              const SizedBox(height: 32),
              Container(
                height: 52,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0072FF).withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await getIt<PaywallPresenter>().presentIfNeeded(
                      context: context,
                    );
                  },
                  icon: const Icon(
                    Icons.workspace_premium,
                    color: Colors.white,
                  ),
                  label: Text(
                    l10n.proLockUnlockButton,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
