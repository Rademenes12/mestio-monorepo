import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../l10n/l10n.dart';
import '../../../models/report_model.dart';
import '../../../models/report_status.dart';
import '../../../utils/format_utils.dart';
import '../../cubit/reports_cubit.dart';
import '../report_detail_screen.dart';
import 'report_photo_widget.dart';

/// Resident's "Zgłoszenia" tab: title, list of own reports (or empty state
/// with a manual offline-sync action).
class ResidentReportsTab extends StatelessWidget {
  const ResidentReportsTab({super.key, required this.reports});

  final List<ReportModel> reports;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Title Header
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppColors.spacingSm,
            AppColors.spacingSm,
            AppColors.spacingSm,
            AppColors.spacingXs,
          ),
          child: Text(
            context.l10n.residentReportsTitle,
            style: const TextStyle(
              color: AppColors.lightTextPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppColors.spacingSm),
          child: Text(
            context.l10n.residentReportsListHeader,
            style: const TextStyle(
              color: AppColors.lightTextSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
        ),
        const SizedBox(height: 6),

        // Reports list
        Expanded(
          child: reports.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.construction_outlined,
                          size: 56,
                          color: AppColors.azure.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          context.l10n.emptyReportsTitle,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          context.l10n.emptyReportsBody,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.lightTextSecondary,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () =>
                              context.read<ReportsCubit>().syncOffline(),
                          icon: const Icon(Icons.sync, size: 18),
                          label: Text(context.l10n.syncOfflineButton),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => context.read<ReportsCubit>().retry(),
                  child: ListView.builder(
                    itemCount: reports.length,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppColors.spacingSm,
                      vertical: 6,
                    ),
                    itemBuilder: (context, index) {
                      return ReportTile(item: reports[index]);
                    },
                  ),
                ),
        ),
      ],
    );
  }
}

/// A single report row in a resident's report list (expandable card with
/// status badge, description, sync status, and a link to full details).
class ReportTile extends StatelessWidget {
  const ReportTile({super.key, required this.item});

  final ReportModel item;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    Color badgeColor = Colors.grey.shade100;
    Color textColor = Colors.black87;

    final status = item.resolvedStatus;
    switch (status) {
      case ReportStatus.newReport:
        badgeColor = const Color(0xFFE0F2FE);
        textColor = const Color(0xFF0369A1);
      case ReportStatus.inProgress:
        badgeColor = const Color(0xFFFEF3C7);
        textColor = const Color(0xFFB45309);
      case ReportStatus.closed:
        badgeColor = const Color(0xFFDCFCE7);
        textColor = const Color(0xFF15803D);
      case ReportStatus.rejected:
        badgeColor = const Color(0xFFF3F4F6);
        textColor = const Color(0xFF4B5563);
    }

    Color cardBg = AppColors.lightCard;
    if (status == ReportStatus.closed) {
      cardBg = const Color(0xFFF0FDF4);
    } else if (status == ReportStatus.rejected) {
      cardBg = const Color(0xFFF9FAFB);
    }

    IconData catIcon = Icons.report_problem;
    if (item.category.contains('Winda')) {
      catIcon = Icons.build;
    } else if (item.category.contains('Elektryczna')) {
      catIcon = Icons.lightbulb_outline;
    } else if (item.category.contains('Wod-Kan')) {
      catIcon = Icons.water_drop_outlined;
    } else if (item.category.contains('Wspólne')) {
      catIcon = Icons.door_front_door_outlined;
    } else if (item.category.contains('Ogrzewanie')) {
      catIcon = Icons.local_fire_department_outlined;
    }

    final String timeLabel = formatTimestamp(item.timestamp);

    return Card(
      key: ValueKey(item.id),
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusCard),
        side: const BorderSide(color: AppColors.lightBorder),
      ),
      child: ExpansionTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.lightCanvas,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(catIcon, color: AppColors.lightTextSecondary),
        ),
        title: Text(
          item.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppColors.lightTextPrimary,
          ),
        ),
        subtitle: Text(
          l10n.reportTileSubtitle(
            shortId(item.id, 4),
            item.reporterFootbridge,
            item.reporterBuilding,
            item.reporterFloor,
          ),
          style: TextStyle(fontSize: 11, color: AppColors.lightTextSecondary),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                item.status.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              timeLabel,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(AppColors.spacingSm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.category.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: AppColors.electricIndigo.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item.category,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.electricIndigo,
                      ),
                    ),
                  ),
                Text(
                  l10n.reportDescriptionInfoLabel(item.description),
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      item.isSynced ? Icons.cloud_done : Icons.cloud_off,
                      size: 16,
                      color: item.isSynced ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.isSynced
                          ? l10n.syncedToServerLabel
                          : l10n.savedOfflineLabel,
                      style: TextStyle(
                        fontSize: 11,
                        color: item.isSynced ? Colors.green : Colors.orange,
                      ),
                    ),
                  ],
                ),
                if (item.photoPath != null && item.photoPath!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  ReportPhotoWidget(photoPath: item.photoPath!),
                ],
                if (item.techNotes != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.technicianNoteTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFB45309),
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.techNotes!,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF78350F),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      final reportsCubit = context.read<ReportsCubit>();
                      final state = reportsCubit.state;
                      final userId = state is ReportsLoaded
                          ? state.userId
                          : null;
                      final userName = state is ReportsLoaded
                          ? state.profile?.name
                          : null;
                      final userRole = state is ReportsLoaded
                          ? (state.profile?.role ?? 'Mieszkaniec')
                          : 'Mieszkaniec';
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BlocProvider<ReportsCubit>.value(
                            value: reportsCubit,
                            child: ReportDetailScreen(
                              report: item,
                              userRole: userRole,
                              userId: userId,
                              userName: userName,
                            ),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.open_in_full, size: 16),
                    label: Text(
                      l10n.detailsButtonLabel,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
