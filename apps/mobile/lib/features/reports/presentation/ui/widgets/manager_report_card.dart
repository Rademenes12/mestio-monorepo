import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../l10n/l10n.dart';
import '../../../models/report_model.dart';
import '../../../models/report_status.dart';
import '../../../../residents/models/staff_member_model.dart';
import '../../cubit/reports_cubit.dart';
import 'report_photo_widget.dart';

/// Report card for manager dashboard with inline status dropdown and comments.
class ManagerReportCard extends StatelessWidget {
  final ReportModel report;
  final String role;
  final VoidCallback? onStatusChanged;

  const ManagerReportCard({
    super.key,
    required this.report,
    required this.role,
    this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = report.resolvedStatus;
    final (Color badgeColor, Color textColor) = _statusColors(status);

    Color cardBg = AppColors.lightCard;
    if (status == ReportStatus.closed) {
      cardBg = const Color(0xFFF0FDF4);
    } else if (status == ReportStatus.rejected) {
      cardBg = const Color(0xFFF9FAFB);
    }

    final canChangeStatus =
        role == 'Zarząd' || role == 'Administrator' || role == 'Serwisant';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppColors.radiusCard),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  report.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightTextPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              canChangeStatus
                  ? _StatusDropdown(
                      report: report,
                      badgeColor: badgeColor,
                      textColor: textColor,
                      onChanged: onStatusChanged,
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _statusLabel(status, l10n),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              if (report.category.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.electricIndigo.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    report.category,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.electricIndigo,
                    ),
                  ),
                ),
              if (report.isSlaOverdue)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.schedule,
                        size: 10,
                        color: AppColors.danger,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        l10n.slaOverdueLabel,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.danger,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            report.description,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.lightTextSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            l10n.reporterLabel(
              report.reporterName.isNotEmpty
                  ? report.reporterName
                  : l10n.unknownUserFallback,
            ),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            _formatTimestamp(report.timestamp),
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.location_on,
                size: 14,
                color: AppColors.lightTextSecondary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${report.reporterBuilding}${report.reporterFootbridge.isNotEmpty ? ", kl. ${report.reporterFootbridge}" : ""}${report.reporterFloor.isNotEmpty ? ", p. ${report.reporterFloor}" : ""}${report.reporterApartment.isNotEmpty ? ", m. ${report.reporterApartment}" : ""}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.lightTextSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.person_outline,
                size: 14,
                color: AppColors.lightTextSecondary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: role == 'Zarząd' || role == 'Administrator'
                    ? Row(
                        children: [
                          Text(
                            '${l10n.assignTo}: ',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.lightTextSecondary,
                            ),
                          ),
                          _AssignmentDropdown(
                            report: report,
                            staff:
                                context.watch<ReportsCubit>().state
                                    is ReportsLoaded
                                ? (context.watch<ReportsCubit>().state
                                          as ReportsLoaded)
                                      .staff
                                : const [],
                          ),
                        ],
                      )
                    : Text(
                        report.assignedToName != null &&
                                report.assignedToName!.isNotEmpty
                            ? l10n.assignedToLabel(
                                report.assignedToName!,
                                report.assignedToRole ?? '',
                              )
                            : l10n.unassigned,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
              ),
            ],
          ),
          if (report.photoPath != null && report.photoPath!.isNotEmpty) ...[
            const SizedBox(height: 12),
            ReportPhotoWidget(photoPath: report.photoPath!),
          ],
          const SizedBox(height: 10),
          _StatusProgressBar(status: status),
        ],
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

  static String _formatTimestamp(int timestampMs) {
    final dt = DateTime.fromMillisecondsSinceEpoch(timestampMs);
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$day.$month.${dt.year} $hour:$minute';
  }
}

/// Visual progress toward resolution, matching the redesign prototype's
/// per-status fill (34% new · 67% in progress · 100% closed/rejected).
class _StatusProgressBar extends StatelessWidget {
  final ReportStatus status;

  const _StatusProgressBar({required this.status});

  double get _progress => switch (status) {
    ReportStatus.newReport => 0.34,
    ReportStatus.inProgress => 0.67,
    ReportStatus.closed || ReportStatus.rejected => 1.0,
  };

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: SizedBox(
        height: 4,
        child: LinearProgressIndicator(
          value: _progress,
          backgroundColor: AppColors.mist,
          valueColor: AlwaysStoppedAnimation(status.color),
        ),
      ),
    );
  }
}

class _StatusDropdown extends StatelessWidget {
  final ReportModel report;
  final Color badgeColor;
  final Color textColor;
  final VoidCallback? onChanged;

  const _StatusDropdown({
    required this.report,
    required this.badgeColor,
    required this.textColor,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const statuses = <String>['Nowe', 'W realizacji', 'Zamknięte', 'Odrzucone'];

    String displayStatus(String s) {
      switch (s) {
        case 'Nowe':
          return l10n.statusNowe;
        case 'W realizacji':
          return l10n.statusWRealizacji;
        case 'Zamknięte':
          return l10n.statusZamkniete;
        case 'Odrzucone':
          return l10n.statusOdrzucone;
        default:
          return s;
      }
    }

    Color itemColor(String s) {
      final lower = s.toLowerCase();
      if (lower == 'nowe') return const Color(0xFF0369A1);
      if (lower.contains('realiz')) return const Color(0xFFB45309);
      if (lower == 'zamknięte' || lower == 'zamkniete') {
        return const Color(0xFF15803D);
      }
      return const Color(0xFF4B5563);
    }

    Color itemBg(String s) {
      final lower = s.toLowerCase();
      if (lower == 'nowe') return const Color(0xFFE0F2FE);
      if (lower.contains('realiz')) return const Color(0xFFFEF3C7);
      if (lower == 'zamknięte' || lower == 'zamkniete') {
        return const Color(0xFFDCFCE7);
      }
      return const Color(0xFFF3F4F6);
    }

    final cubitState = context.watch<ReportsCubit>().state;
    final isLoading = cubitState is ReportsLoaded
        ? cubitState.isSubmitting
        : false;

    return DropdownButton<String>(
      value: statuses.contains(report.status) ? report.status : null,
      hint: Text(
        displayStatus(report.status),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
      underline: const SizedBox.shrink(),
      isDense: true,
      icon: const Icon(Icons.arrow_drop_down, size: 16),
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      items: statuses.map((status) {
        return DropdownMenuItem(
          value: status,
          enabled: !isLoading,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: itemBg(status),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              displayStatus(status),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: itemColor(status),
              ),
            ),
          ),
        );
      }).toList(),
      onChanged: isLoading
          ? null
          : (newValue) {
              if (newValue == null) return;
              context.read<ReportsCubit>().updateStatus(report.id, newValue);
              onChanged?.call();
            },
      dropdownColor: AppColors.lightCard,
      borderRadius: BorderRadius.circular(12),
    );
  }
}

class _AssignmentDropdown extends StatelessWidget {
  final ReportModel report;
  final List<StaffMemberModel> staff;

  const _AssignmentDropdown({required this.report, required this.staff});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final cubitState = context.watch<ReportsCubit>().state;
    final isLoading = cubitState is ReportsLoaded
        ? cubitState.isSubmitting
        : false;

    // Check if current value exists in staff list
    final hasActiveValue = staff.any(
      (member) => member.id == report.assignedToUserId,
    );
    final selectedValue = hasActiveValue ? report.assignedToUserId : null;

    return DropdownButton<String?>(
      value: selectedValue,
      hint: Text(
        l10n.unassigned,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.lightTextSecondary,
        ),
      ),
      underline: const SizedBox.shrink(),
      isDense: true,
      icon: const Icon(Icons.arrow_drop_down, size: 16),
      style: const TextStyle(fontSize: 11, color: AppColors.lightTextPrimary),
      items: [
        DropdownMenuItem<String?>(
          value: null,
          enabled: !isLoading,
          child: Text(
            l10n.unassigned,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.lightTextSecondary,
            ),
          ),
        ),
        ...staff.map((member) {
          return DropdownMenuItem<String?>(
            value: member.id,
            enabled: !isLoading,
            child: Text(
              '${member.name} (${member.role})',
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.lightTextPrimary,
              ),
            ),
          );
        }),
      ],
      onChanged: isLoading
          ? null
          : (newUserId) {
              final cubit = context.read<ReportsCubit>();
              if (newUserId == null) {
                cubit.assignReportToUser(report.id, null, null, null);
              } else {
                final selectedMember = staff.firstWhere(
                  (m) => m.id == newUserId,
                );
                cubit.assignReportToUser(
                  report.id,
                  selectedMember.id,
                  selectedMember.name,
                  selectedMember.role,
                );
              }
            },
      dropdownColor: AppColors.lightCard,
      borderRadius: BorderRadius.circular(12),
    );
  }
}
