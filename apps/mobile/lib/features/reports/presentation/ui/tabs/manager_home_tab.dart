import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../l10n/l10n.dart';
import '../../../models/report_model.dart';
import '../../../models/report_status.dart';
import '../widgets/manager_report_card.dart';

/// Manager dashboard home tab with KPI summary tiles and filtered report list.
class ManagerHomeTab extends StatefulWidget {
  final List<ReportModel> reports;
  final String role;
  final String userName;

  const ManagerHomeTab({
    super.key,
    required this.reports,
    required this.role,
    required this.userName,
  });

  @override
  State<ManagerHomeTab> createState() => _ManagerHomeTabState();
}

class _ManagerHomeTabState extends State<ManagerHomeTab> {
  String? _statusFilter;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final newCount =
        widget.reports.where((r) => r.resolvedStatus == ReportStatus.newReport).length;
    final inProgressCount =
        widget.reports.where((r) => r.resolvedStatus == ReportStatus.inProgress).length;
    final closedCount =
        widget.reports.where((r) => r.resolvedStatus == ReportStatus.closed).length;
    final rejectedCount =
        widget.reports.where((r) => r.resolvedStatus == ReportStatus.rejected).length;

    final filtered = widget.reports.where((r) {
      if (_statusFilter == null) return true;
      if (_statusFilter == 'nowe') return r.resolvedStatus == ReportStatus.newReport;
      if (_statusFilter == 'w_realizacji') return r.resolvedStatus == ReportStatus.inProgress;
      if (_statusFilter == 'zamkniete') return r.resolvedStatus == ReportStatus.closed;
      if (_statusFilter == 'odrzucone') return r.resolvedStatus == ReportStatus.rejected;
      return true;
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(AppColors.spacingSm),
      children: [
        // Header with initials avatar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.loggedInAsNamedLabel(widget.userName),
                  style: const TextStyle(
                    color: AppColors.lightTextSecondary,
                    fontSize: 12,
                  ),
                ),
                Text(
                  widget.role == 'Administrator'
                      ? l10n.adminDashboardTitle
                      : l10n.managerDashboardTitle,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            CircleAvatar(
              backgroundColor: AppColors.electricIndigo.withValues(alpha: 0.1),
              child: Text(
                widget.userName.isNotEmpty
                    ? widget.userName[0].toUpperCase()
                    : 'A',
                style: const TextStyle(
                  color: AppColors.electricIndigo,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppColors.spacingMd),

        // KPI tiles
        Row(
          children: [
            Expanded(
              child: _KpiCard(
                label: l10n.statusNowe.toUpperCase(),
                value: '$newCount',
                color: AppColors.cyanGlow,
                filterKey: 'nowe',
                selectedFilter: _statusFilter,
                onTap: (key) => setState(() => _statusFilter = key),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _KpiCard(
                label: l10n.statusWRealizacji.toUpperCase(),
                value: '$inProgressCount',
                color: AppColors.amberAlert,
                filterKey: 'w_realizacji',
                selectedFilter: _statusFilter,
                onTap: (key) => setState(() => _statusFilter = key),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _KpiCard(
                label: l10n.statusZamkniete.toUpperCase(),
                value: '$closedCount',
                color: AppColors.neonMint,
                filterKey: 'zamkniete',
                selectedFilter: _statusFilter,
                onTap: (key) => setState(() => _statusFilter = key),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _KpiWideCard(
          label: l10n.statusOdrzucone.toUpperCase(),
          value: '$rejectedCount',
          color: AppColors.crimsonCoral,
          filterKey: 'odrzucone',
          selectedFilter: _statusFilter,
          onTap: (key) => setState(() => _statusFilter = key),
        ),
        const SizedBox(height: AppColors.spacingMd),

        // Filter header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.navReports.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 1.1,
                color: AppColors.lightTextSecondary,
              ),
            ),
            if (_statusFilter != null)
              IconButton(
                icon: const Icon(Icons.clear_all, size: 18),
                onPressed: () => setState(() => _statusFilter = null),
              ),
          ],
        ),
        const SizedBox(height: 8),

        if (filtered.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Text(
                l10n.noReportsYet,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          ...filtered.map(
            (report) => ManagerReportCard(
              report: report,
              role: widget.role,
              onStatusChanged: () => setState(() {}),
            ),
          ),
      ],
    );
  }

}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.label,
    required this.value,
    required this.color,
    required this.filterKey,
    required this.selectedFilter,
    required this.onTap,
  });

  final String label;
  final String value;
  final Color color;
  final String filterKey;
  final String? selectedFilter;
  final ValueChanged<String?> onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedFilter == filterKey;
    return GestureDetector(
      onTap: () => onTap(isSelected ? null : filterKey),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.lightCard,
          borderRadius: BorderRadius.circular(AppColors.radiusCard),
          border: Border.all(
            color: isSelected ? color : AppColors.lightBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KpiWideCard extends StatelessWidget {
  const _KpiWideCard({
    required this.label,
    required this.value,
    required this.color,
    required this.filterKey,
    required this.selectedFilter,
    required this.onTap,
  });

  final String label;
  final String value;
  final Color color;
  final String filterKey;
  final String? selectedFilter;
  final ValueChanged<String?> onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedFilter == filterKey;
    return GestureDetector(
      onTap: () => onTap(isSelected ? null : filterKey),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.lightCard,
          borderRadius: BorderRadius.circular(AppColors.radiusCard),
          border: Border.all(
            color: isSelected ? color : AppColors.lightBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.lightTextSecondary,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
