import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../l10n/l10n.dart';
import '../../../models/report_model.dart';
import '../widgets/report_tile_widget.dart';

/// Security (Ochrona) patrol dashboard with quick-report and emergency alarm.
class SecurityDashboardTab extends StatelessWidget {
  final List<ReportModel> securityReports;
  final VoidCallback onReportToManager;
  final VoidCallback onTriggerEmergency;

  const SecurityDashboardTab({
    super.key,
    required this.securityReports,
    required this.onReportToManager,
    required this.onTriggerEmergency,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListView(
      padding: const EdgeInsets.all(AppColors.spacingSm),
      children: [
        // Patrol header
        Row(
          children: [
            const Icon(Icons.security, color: AppColors.electricIndigo, size: 28),
            const SizedBox(width: 8),
            Text(
              l10n.securityPatrolTitle,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppColors.spacingLg),

        // Quick report card
        GestureDetector(
          onTap: onReportToManager,
          child: Container(
            height: 90,
            decoration: BoxDecoration(
              color: AppColors.lightCard,
              borderRadius: BorderRadius.circular(AppColors.radiusCard),
              border: Border.all(color: AppColors.lightBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.assignment_late_outlined,
                  size: 32,
                  color: AppColors.electricIndigo,
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.securityReportToBoardButton,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Emergency alarm button
        GestureDetector(
          onTap: onTriggerEmergency,
          child: Container(
            height: 90,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF5252), Color(0xFFFF1744)],
              ),
              borderRadius: BorderRadius.circular(AppColors.radiusCard),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.campaign, size: 36, color: Colors.white),
                const SizedBox(width: 12),
                Text(
                  l10n.securityEmergencyAlarmButton,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppColors.spacingLg),

        // Patrol history
        Text(
          l10n.securityPatrolHistoryTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 11,
            color: AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 8),
        if (securityReports.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                l10n.securityPatrolHistoryEmpty,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          ...securityReports.map(
            (report) => ReportTileWidget(report: report),
          ),
      ],
    );
  }
}
