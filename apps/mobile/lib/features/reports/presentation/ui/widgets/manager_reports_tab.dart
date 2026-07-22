import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../l10n/l10n.dart';
import '../../../models/report_model.dart';
import '../../../models/report_status.dart';
import '../../cubit/reports_cubit.dart';
import '../report_detail_screen.dart';
import 'manager_report_card.dart';

class ManagerReportsTabWidget extends StatefulWidget {
  final List<ReportModel> reports;
  final String role;

  const ManagerReportsTabWidget({super.key, required this.reports, required this.role});

  @override
  State<ManagerReportsTabWidget> createState() => ManagerReportsTabWidgetState();
}

class ManagerReportsTabWidgetState extends State<ManagerReportsTabWidget> {
  String _searchQuery = '';
  ReportStatus? _statusFilter;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final filtered = widget.reports.where((r) {
      if (_statusFilter != null && r.resolvedStatus != _statusFilter) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesTitle = r.title.toLowerCase().contains(query);
        final matchesDesc = r.description.toLowerCase().contains(query);
        final matchesReporter = r.reporterName.toLowerCase().contains(query);
        final matchesApartment = r.reporterApartment.toLowerCase().contains(
          query,
        );
        return matchesTitle ||
            matchesDesc ||
            matchesReporter ||
            matchesApartment;
      }
      return true;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppColors.spacingSm,
            AppColors.spacingSm,
            AppColors.spacingSm,
            AppColors.spacingXs,
          ),
          child: Text(
            l10n.navReports,
            style: const TextStyle(
              color: AppColors.lightTextPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppColors.spacingSm),
          child: TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: l10n.reportSearchHint,
              prefixIcon: const Icon(Icons.search),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppColors.radiusButton),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppColors.spacingSm),
          child: Row(
            children: [
              FilterChip(
                label: Text('Wszystkie (${widget.reports.length})'),
                selected: _statusFilter == null,
                onSelected: (_) => setState(() => _statusFilter = null),
              ),
              const SizedBox(width: 8),
              ...ReportStatus.values.map((status) {
                final label = status == ReportStatus.newReport
                    ? l10n.statusNowe
                    : status == ReportStatus.inProgress
                    ? l10n.statusWRealizacji
                    : status == ReportStatus.closed
                    ? l10n.statusZamkniete
                    : l10n.statusOdrzucone;
                final count = widget.reports
                    .where((r) => r.resolvedStatus == status)
                    .length;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text('$label ($count)'),
                    selected: _statusFilter == status,
                    selectedColor: status.color.withValues(alpha: 0.2),
                    checkmarkColor: status.color,
                    onSelected: (selected) {
                      setState(() {
                        _statusFilter = selected ? status : null;
                      });
                    },
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Text(
                    l10n.noReportsMatchingFilter,
                    style: const TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: filtered.length,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppColors.spacingSm,
                    vertical: 6,
                  ),
                  itemBuilder: (context, index) {
                    final report = filtered[index];
                    return GestureDetector(
                      onTap: () {
                        final reportsState = context.read<ReportsCubit>().state;
                        final userId = reportsState is ReportsLoaded
                            ? reportsState.userId
                            : null;
                        final userName = reportsState is ReportsLoaded
                            ? reportsState.profile?.name
                            : null;
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BlocProvider<ReportsCubit>.value(
                              value: context.read<ReportsCubit>(),
                              child: ReportDetailScreen(
                                report: report,
                                userRole: widget.role,
                                userId: userId,
                                userName: userName,
                                staff: reportsState is ReportsLoaded
                                    ? reportsState.staff
                                    : const [],
                              ),
                            ),
                          ),
                        );
                      },
                      child: ManagerReportCard(
                        report: report,
                        role: widget.role,
                        onStatusChanged: () => setState(() {}),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
