import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../l10n/l10n.dart';
import '../../../models/report_model.dart';
import '../../../models/report_status.dart';

/// Compact report tile used on resident and security home tabs.
class ReportTileWidget extends StatelessWidget {
  final ReportModel report;
  final VoidCallback? onTap;

  const ReportTileWidget({super.key, required this.report, this.onTap});

  @override
  Widget build(BuildContext context) {
    final status = report.resolvedStatus;
    final (Color badgeColor, Color textColor) = _statusColors(status);

    IconData catIcon = Icons.report_problem;
    if (report.category.contains('Winda')) {
      catIcon = Icons.elevator;
    } else if (report.category.contains('Elektryczna')) {
      catIcon = Icons.lightbulb_outline;
    } else if (report.category.contains('Wod-Kan')) {
      catIcon = Icons.water_drop_outlined;
    } else if (report.category.contains('Wspólne')) {
      catIcon = Icons.door_front_door_outlined;
    } else if (report.category.contains('Ogrzewanie')) {
      catIcon = Icons.local_fire_department_outlined;
    }

    return Card(
      color: AppColors.lightCard,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusCard),
        side: const BorderSide(color: AppColors.lightBorder),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppColors.radiusCard),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.lightCanvas,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(catIcon, color: AppColors.lightTextSecondary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.lightTextPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    if (report.category.isNotEmpty)
                      Text(
                        report.category,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _statusLabel(status, context.l10n),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _statusLabel(ReportStatus status, AppLocalizations l10n) {
    switch (status) {
      case ReportStatus.newReport:
        return l10n.statusNowe;
      case ReportStatus.inProgress:
        return l10n.statusWRealizacji;
      case ReportStatus.closed:
        return l10n.statusZamkniete;
      case ReportStatus.rejected:
        return l10n.statusOdrzucone;
    }
  }

  (Color, Color) _statusColors(ReportStatus status) {
    switch (status) {
      case ReportStatus.newReport:
        return (const Color(0xFFE0F2FE), const Color(0xFF0369A1));
      case ReportStatus.inProgress:
        return (const Color(0xFFFEF3C7), const Color(0xFFB45309));
      case ReportStatus.closed:
        return (const Color(0xFFDCFCE7), const Color(0xFF15803D));
      case ReportStatus.rejected:
        return (const Color(0xFFF3F4F6), const Color(0xFF4B5563));
    }
  }
}
