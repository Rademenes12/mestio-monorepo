import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../l10n/l10n.dart';
import '../../../models/report_model.dart';
import '../../../models/report_status.dart';
import '../../../utils/format_utils.dart';
import '../../cubit/reports_cubit.dart';
import '../report_detail_screen.dart';

class NotificationBellButton extends StatelessWidget {
  final List<ReportModel> reports;

  const NotificationBellButton({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: context.l10n.notificationsPanelTitle,
      onPressed: () => _openPanel(context),
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(
            Icons.notifications_outlined,
            color: AppColors.lightTextSecondary,
          ),
          if (reports.isNotEmpty)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.amber,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _openPanel(BuildContext context) {
    final reportsCubit = context.read<ReportsCubit>();
    final state = reportsCubit.state;
    final role = state is ReportsLoaded
        ? (state.profile?.role ?? 'Mieszkaniec')
        : 'Mieszkaniec';
    final userId = state is ReportsLoaded ? state.userId : null;
    final userName = state is ReportsLoaded ? state.profile?.name : null;
    final isOwnView = role == 'Mieszkaniec' || role == 'Ochrona';

    final recent = List<ReportModel>.of(reports)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => NotificationsSheet(
        recent: recent.take(5).toList(),
        isOwnView: isOwnView,
        onTapNotification: (report) {
          Navigator.of(sheetContext).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider<ReportsCubit>.value(
                value: reportsCubit,
                child: ReportDetailScreen(
                  report: report,
                  userRole: role,
                  userId: userId,
                  userName: userName,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class NotificationsSheet extends StatelessWidget {
  final List<ReportModel> recent;
  final bool isOwnView;
  final ValueChanged<ReportModel> onTapNotification;

  const NotificationsSheet({
    super.key,
    required this.recent,
    required this.isOwnView,
    required this.onTapNotification,
  });

  String _statusLabel(ReportStatus status, AppLocalizations l10n) {
    return switch (status) {
      ReportStatus.newReport => l10n.statusNowe,
      ReportStatus.inProgress => l10n.statusWRealizacji,
      ReportStatus.closed => l10n.statusZamkniete,
      ReportStatus.rejected => l10n.statusOdrzucone,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        decoration: const BoxDecoration(
          color: AppColors.lightCanvas,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.lightBorder,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 6),
              child: Text(
                l10n.notificationsPanelTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Flexible(
              child: recent.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        l10n.notificationsEmpty,
                        style: const TextStyle(
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.fromLTRB(14, 4, 14, 18),
                      itemCount: recent.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 9),
                      itemBuilder: (context, i) {
                        final r = recent[i];
                        final status = r.resolvedStatus;
                        final displayId =
                            r.displayId ?? r.id.substring(0, 8).toUpperCase();
                        final isUrgent =
                            r.priority == 'high' || r.priority == 'critical';
                        final title = isOwnView
                            ? l10n.notificationYourReport(displayId)
                            : (isUrgent
                                  ? l10n.notificationUrgentPrefix(r.title)
                                  : l10n.notificationReportPrefix(displayId));
                        final subtitle = isOwnView
                            ? l10n.notificationCurrentStatus(
                                _statusLabel(status, l10n),
                              )
                            : r.title;
                        return InkWell(
                          onTap: () => onTapNotification(r),
                          borderRadius: BorderRadius.circular(13),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 13,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.lightCard,
                              borderRadius: BorderRadius.circular(13),
                              border: Border.all(color: AppColors.lightBorder),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.only(top: 5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: status.color,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        subtitle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 11.5,
                                          color: AppColors.lightTextSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  formatTimestamp(r.timestamp),
                                  style: const TextStyle(
                                    fontFamily: 'IBMPlexMono',
                                    fontSize: 9.5,
                                    color: AppColors.lightTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
