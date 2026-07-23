import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../l10n/l10n.dart';
import '../../../models/report_model.dart';
import '../../../models/report_status.dart';
import '../widgets/manager_report_card.dart';

/// Erste Mobile-inspired manager dashboard home tab.
///
/// Features:
/// - Welcome header with privacy toggle
/// - Quick action shortcuts ("Twoje skróty")
/// - KPI summary tiles with trends
/// - Recent activity timeline
/// - Filtered report list
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
  bool _privacyMode = false;

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
    final urgentCount =
        widget.reports.where((r) => r.priority == 'critical' || r.priority == 'high')
            .where((r) => r.resolvedStatus != ReportStatus.closed && r.resolvedStatus != ReportStatus.rejected)
            .length;

    final filtered = widget.reports.where((r) {
      if (_statusFilter == null) return true;
      if (_statusFilter == 'nowe') return r.resolvedStatus == ReportStatus.newReport;
      if (_statusFilter == 'w_realizacji') return r.resolvedStatus == ReportStatus.inProgress;
      if (_statusFilter == 'zamkniete') return r.resolvedStatus == ReportStatus.closed;
      if (_statusFilter == 'odrzucone') return r.resolvedStatus == ReportStatus.rejected;
      return true;
    }).toList();

    // Recent urgent reports for timeline
    final urgentReports = widget.reports
        .where((r) => (r.priority == 'critical' || r.priority == 'high') &&
            r.resolvedStatus != ReportStatus.closed)
        .take(3)
        .toList();

    return ListView(
      padding: const EdgeInsets.all(AppColors.spacingSm),
      children: [
        // ── Header ──
        _HeaderSection(
          userName: widget.userName,
          role: widget.role,
          privacyMode: _privacyMode,
          onTogglePrivacy: () => setState(() => _privacyMode = !_privacyMode),
        ),

        const SizedBox(height: AppColors.spacingMd),

        // ── Quick actions ("Twoje skróty") ──
        _ShortcutsRow(
          onNewReport: () {
            // Trigger FAB from dashboard_screen — handled externally
          },
        ),

        const SizedBox(height: AppColors.spacingMd),

        // ── KPI Cards row ──
        SizedBox(
          height: 100,
          child: Row(
            children: [
              Expanded(
                child: _KpiTile(
                  label: l10n.statusNowe,
                  value: _privacyMode ? '••' : '$newCount',
                  color: AppColors.info,
                  trend: newCount > 5 ? Trend.up : Trend.flat,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _KpiTile(
                  label: l10n.statusWRealizacji,
                  value: _privacyMode ? '••' : '$inProgressCount',
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _KpiTile(
                  label: 'Pilne',
                  value: _privacyMode ? '••' : '$urgentCount',
                  color: AppColors.error,
                  trend: urgentCount > 0 ? Trend.down : Trend.flat,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _KpiTile(
                  label: 'Zamknięte',
                  value: _privacyMode ? '••' : '$closedCount',
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // ── Wide KPI: Odrzucone ──
        _KpiWideTile(
          label: l10n.statusOdrzucone,
          value: _privacyMode ? '••' : '$rejectedCount',
          color: AppColors.textMuted,
          onTap: () => setState(() =>
              _statusFilter = _statusFilter == 'odrzucone' ? null : 'odrzucone'),
          isSelected: _statusFilter == 'odrzucone',
        ),

        const SizedBox(height: AppColors.spacingMd),

        // ── Activity Timeline ──
        if (urgentReports.isNotEmpty) ...[
          _SectionHeader(
            title: 'Wymagają uwagi',
            count: urgentReports.length,
            countColor: AppColors.error,
          ),
          const SizedBox(height: 8),
          ...urgentReports.map((r) => _AttentionItem(
            report: r,
            privacyMode: _privacyMode,
          )),
          const SizedBox(height: AppColors.spacingMd),
        ],

        // ── Report list header ──
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _SectionHeader(
              title: l10n.navReports,
              count: filtered.length,
              countColor: AppColors.accent,
            ),
            if (_statusFilter != null)
              GestureDetector(
                onTap: () => setState(() => _statusFilter = null),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Wyczyść filtr',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),

        // ── Status filter pills ──
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _FilterChip(
                label: l10n.statusNowe,
                count: newCount,
                color: AppColors.info,
                isSelected: _statusFilter == 'nowe',
                onTap: () => setState(() =>
                    _statusFilter = _statusFilter == 'nowe' ? null : 'nowe'),
              ),
              const SizedBox(width: 6),
              _FilterChip(
                label: l10n.statusWRealizacji,
                count: inProgressCount,
                color: AppColors.warning,
                isSelected: _statusFilter == 'w_realizacji',
                onTap: () => setState(() =>
                    _statusFilter = _statusFilter == 'w_realizacji' ? null : 'w_realizacji'),
              ),
              const SizedBox(width: 6),
              _FilterChip(
                label: l10n.statusZamkniete,
                count: closedCount,
                color: AppColors.success,
                isSelected: _statusFilter == 'zamkniete',
                onTap: () => setState(() =>
                    _statusFilter = _statusFilter == 'zamkniete' ? null : 'zamkniete'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // ── Report cards ──
        if (filtered.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  Icon(Icons.check_circle_outline,
                      size: 48, color: AppColors.textMuted.withValues(alpha: 0.4)),
                  const SizedBox(height: 12),
                  Text(
                    l10n.noReportsYet,
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
                  ),
                ],
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

// ═══════════════════════════════════════════
// Private Widgets
// ═══════════════════════════════════════════

/// Welcome header with privacy toggle (Erste "tryb dyskretny").
class _HeaderSection extends StatelessWidget {
  final String userName;
  final String role;
  final bool privacyMode;
  final VoidCallback onTogglePrivacy;

  const _HeaderSection({
    required this.userName,
    required this.role,
    required this.privacyMode,
    required this.onTogglePrivacy,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.loggedInAsNamedLabel(userName),
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              role == 'Administrator'
                  ? l10n.adminDashboardTitle
                  : l10n.managerDashboardTitle,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        Row(
          children: [
            // Privacy toggle
            GestureDetector(
              onTap: onTogglePrivacy,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: privacyMode
                      ? AppColors.error.withValues(alpha: 0.1)
                      : AppColors.accent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: privacyMode
                        ? AppColors.error.withValues(alpha: 0.2)
                        : AppColors.accent.withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      privacyMode ? Icons.visibility_off : Icons.visibility,
                      size: 16,
                      color: privacyMode ? AppColors.error : AppColors.accent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      privacyMode ? 'Ukryto' : 'Pokaż',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: privacyMode ? AppColors.error : AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.purple.withValues(alpha: 0.15),
              child: Text(
                userName.isNotEmpty ? userName[0].toUpperCase() : 'A',
                style: const TextStyle(
                  color: AppColors.purple,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Quick action shortcuts ("Twoje skróty").
class _ShortcutsRow extends StatelessWidget {
  final VoidCallback onNewReport;

  const _ShortcutsRow({required this.onNewReport});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Twoje skróty',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _ShortcutChip(
              icon: Icons.add_circle_outline,
              label: 'Nowe zgłoszenie',
              color: AppColors.accent,
              onTap: onNewReport,
            ),
            const SizedBox(width: 8),
            _ShortcutChip(
              icon: Icons.message_outlined,
              label: 'Wiadomości',
              color: AppColors.info,
            ),
            const SizedBox(width: 8),
            _ShortcutChip(
              icon: Icons.checklist_rtl,
              label: 'Zadania',
              color: AppColors.warning,
            ),
          ],
        ),
      ],
    );
  }
}

/// Small shortcut button.
class _ShortcutChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _ShortcutChip({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.15)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Trend indicator.
enum Trend { up, down, flat }

/// KPI tile with optional trend.
class _KpiTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Trend? trend;

  const _KpiTile({
    required this.label,
    required this.value,
    required this.color,
    this.trend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppColors.radiusCard),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              if (trend != null && trend != Trend.flat) ...[
                const SizedBox(width: 4),
                Icon(
                  trend == Trend.up ? Icons.trending_up : Icons.trending_down,
                  size: 14,
                  color: trend == Trend.up ? AppColors.success : AppColors.error,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Wide KPI tile (selectable).
class _KpiWideTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final VoidCallback onTap;
  final bool isSelected;

  const _KpiWideTile({
    required this.label,
    required this.value,
    required this.color,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppColors.radiusCard),
          border: Border.all(
            color: isSelected ? color : AppColors.cardBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label.toUpperCase(),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.textMuted,
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

/// Section header with optional count badge.
class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  final Color countColor;

  const _SectionHeader({
    required this.title,
    required this.count,
    required this.countColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            letterSpacing: 1.1,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: countColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: countColor,
            ),
          ),
        ),
      ],
    );
  }
}

/// Urgent report timeline item.
class _AttentionItem extends StatelessWidget {
  final ReportModel report;
  final bool privacyMode;

  const _AttentionItem({required this.report, required this.privacyMode});

  @override
  Widget build(BuildContext context) {
    final priColor = report.priority == 'critical' ? AppColors.error :
        report.priority == 'high' ? AppColors.warning : AppColors.info;
    final priLabel = report.priority == 'critical' ? 'Krytyczny' :
        report.priority == 'high' ? 'Wysoki' : 'Średni';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: priColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '#${report.displayId ?? report.id.substring(0, 6)}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontFamily: 'IBMPlexMono',
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: priColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              priLabel,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: priColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Filter chip for status.
class _FilterChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.count,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.12) : AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : AppColors.cardBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? color : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withValues(alpha: 0.2)
                    : AppColors.textMuted.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? color : AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
