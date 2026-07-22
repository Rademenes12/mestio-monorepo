import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../app/profile/presentation/ui/delete_account_confirmation_screen.dart';
import '../../../auth/data/repositories/auth_repository.dart';
import '../../../contacts/presentation/ui/contacts_tab.dart';
import '../../../report_comments/presentation/cubit/report_comments_cubit.dart';
import '../../../report_comments/presentation/ui/correspondence_section.dart';
import '../../../report_comments/presentation/ui/team_notes_section.dart';
import '../../../../l10n/l10n.dart';
import '../../models/report_status.dart';
import '../cubit/reports_cubit.dart';
import 'widgets/report_photo_widget.dart';
import '../../../../shared/widgets/logout_feedback_sheet.dart';
import '../../../../shared/error_messages.dart';
import 'report_detail_screen.dart';

/// Reports that have a category containing "Administrator" are intended only
/// for the board/admin. Serwis and Ochrona should not see them.
bool _isAdminOnlyCategory(String category) {
  final lower = category.toLowerCase();
  return lower.contains('administrator');
}

String _formatTimestamp(int timestampMs) {
  final dt = DateTime.fromMillisecondsSinceEpoch(timestampMs);
  final day = dt.day.toString().padLeft(2, '0');
  final month = dt.month.toString().padLeft(2, '0');
  final hour = dt.hour.toString().padLeft(2, '0');
  final minute = dt.minute.toString().padLeft(2, '0');
  return '$day.$month.${dt.year} $hour:$minute';
}

class TechnicianPortalScreen extends StatefulWidget {
  const TechnicianPortalScreen({super.key});

  @override
  State<TechnicianPortalScreen> createState() => _TechnicianPortalScreenState();
}

class _TechnicianPortalScreenState extends State<TechnicianPortalScreen> {
  int _tabIndex = 0; // 0=Home, 1=Contacts, 2=Profile
  bool _viewAllReports = false;
  int _statusTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportsCubit, ReportsState>(
      builder: (context, state) {
        final l10n = context.l10n;
        if (state is ReportsError) {
          return Scaffold(
            backgroundColor: AppColors.lightCanvas,
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SelectableText(
                        messageForErrorKey(l10n, state.errorKey),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => context.read<ReportsCubit>().retry(),
                        icon: const Icon(Icons.refresh),
                        label: Text(l10n.retryButton),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        if (state is! ReportsLoaded) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final profile = state.profile;
        final tabs = [
          _homeTab(state, profile, l10n),
          const ContactsTab(isAdmin: false),
          _profileTab(profile),
        ];

        return Scaffold(
          backgroundColor: AppColors.lightCanvas,
          body: SafeArea(child: tabs[_tabIndex]),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.lightBorder, width: 1),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: _tabIndex,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppColors.electricIndigo,
              unselectedItemColor: AppColors.lightTextSecondary,
              backgroundColor: AppColors.lightCard,
              elevation: 0,
              selectedFontSize: 11,
              unselectedFontSize: 11,
              onTap: (i) => setState(() => _tabIndex = i),
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home_outlined, size: 26),
                  activeIcon: const Icon(Icons.home, size: 26),
                  label: l10n.navHome,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.contact_phone_outlined, size: 26),
                  activeIcon: const Icon(Icons.contact_phone, size: 26),
                  label: l10n.navContacts,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.person_outline, size: 26),
                  activeIcon: const Icon(Icons.person, size: 26),
                  label: l10n.navProfile,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _homeTab(
    ReportsLoaded state,
    dynamic profile,
    AppLocalizations l10n,
  ) {
    final reports = state.reports;
    final currentUserId = state.userId;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Filter: show reports assigned to this technician OR unassigned
    // service/security-category reports. Admin-only categories are hidden.
    final filteredReports = reports.where((r) {
      if (_isAdminOnlyCategory(r.category)) return false;
      final isAssignedToMe = r.assignedToUserId == currentUserId;
      final isUnassignedService = r.assignedToUserId == null;
      if (!isAssignedToMe && !isUnassignedService) return false;

      final status = r.resolvedStatus;
      if (!_viewAllReports && status.isTerminal) {
        return false;
      }
      bool matchesStatus = true;
      if (_statusTabIndex == 0) {
        matchesStatus = status == ReportStatus.newReport;
      } else if (_statusTabIndex == 1) {
        matchesStatus = status == ReportStatus.inProgress;
      } else if (_statusTabIndex == 2) {
        matchesStatus = status == ReportStatus.closed;
      }
      return matchesStatus;
    }).toList();

    return Column(
      children: [
        // Banner
        Container(
          color: isDark ? AppColors.darkCard : AppColors.electricIndigo,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.electricIndigo.withValues(
                  alpha: 0.2,
                ),
                child: profile?.name.isNotEmpty == true
                    ? Text(
                        profile!.name[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : const Icon(Icons.build, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile != null
                          ? l10n.technicianLoggedInNamed(profile.name)
                          : l10n.technicianLoggedInFallback,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          l10n.showClosedToggleLabel,
                          style: const TextStyle(fontSize: 10, color: Colors.white54),
                        ),
                        SizedBox(
                          height: 24,
                          child: Switch(
                            value: _viewAllReports,
                            activeThumbColor: Colors.orangeAccent,
                            onChanged: (val) =>
                                setState(() => _viewAllReports = val),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Status filter tabs
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppColors.spacingSm),
          child: Row(
            children: [
              _statusTab(l10n.statusNowe, 0, Colors.blueAccent, isDark),
              _statusTab(
                l10n.statusWRealizacji,
                1,
                AppColors.amberAlert,
                isDark,
              ),
              _statusTab(
                l10n.statusZamkniete,
                2,
                AppColors.neonMint,
                isDark,
              ),
              _statusTab(l10n.allFilterLabel, 3, Colors.grey, isDark),
            ],
          ),
        ),

        // Reports list
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => context.read<ReportsCubit>().retry(),
            child: filteredReports.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(32),
                    children: [
                      const SizedBox(height: 80),
                      Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 56,
                              color: AppColors.mint.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.emptyTechReportsTitle,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.lightTextPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.emptyTechReportsBody,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.lightTextSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: filteredReports.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      final item = filteredReports[index];
                      final status = item.resolvedStatus;
                      Color badgeColor = Colors.grey.shade300;
                      Color textColor = Colors.black87;

                      switch (status) {
                        case ReportStatus.newReport:
                          badgeColor = Colors.blue.shade100;
                          textColor = Colors.blue.shade900;
                        case ReportStatus.inProgress:
                          badgeColor = Colors.orange.shade100;
                          textColor = Colors.orange.shade900;
                        case ReportStatus.closed:
                          badgeColor = Colors.green.shade100;
                          textColor = Colors.green.shade900;
                        case ReportStatus.rejected:
                          badgeColor = Colors.grey.shade300;
                          textColor = Colors.grey.shade800;
                      }

                      const statuses = <String>[
                        'Nowe',
                        'W realizacji',
                        'Zamknięte',
                      ];

                      return Card(
                        key: ValueKey(item.id),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        color: isDark
                            ? AppColors.darkCard
                            : AppColors.lightCard,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppColors.radiusCard,
                          ),
                          side: const BorderSide(color: AppColors.lightBorder),
                        ),
                        elevation: 0,
                        child: ExpansionTile(
                          leading: const Icon(
                            Icons.assignment,
                            color: Colors.blueGrey,
                          ),
                          title: Text(
                            item.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          subtitle: Text(
                            _formatTimestamp(item.timestamp),
                            style: const TextStyle(fontSize: 11),
                          ),
                          trailing: DropdownButton<String>(
                            value: statuses.contains(item.status)
                                ? item.status
                                : null,
                            hint: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: badgeColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _statusDisplay(item.status, l10n),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ),
                            underline: const SizedBox.shrink(),
                            isDense: true,
                            icon: const Icon(Icons.arrow_drop_down, size: 16),
                            items: statuses
                                .map(
                                  (s) => DropdownMenuItem(
                                    value: s,
                                    child: Text(
                                      _statusDisplay(s, l10n),
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (newStatus) async {
                              if (newStatus == null ||
                                  newStatus == item.status) {
                                return;
                              }
                              if (newStatus == 'Zamknięte') {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text(l10n.reportCloseRequiresMessageWarning),
                                    content: Text(l10n.reportCloseRequiresMessageHint),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx, false),
                                        child: Text(l10n.cancelButton),
                                      ),
                                      FilledButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: Text(l10n.statusZamkniete),
                                    ),
                                    ],
                                  ),
                                );
                                if (confirm != true) return;
                              }
                              if (!mounted) return;
                              // ignore: use_build_context_synchronously
                              context.read<ReportsCubit>().updateStatus(
                                item.id,
                                newStatus,
                              );
                            },
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
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
                                        color: AppColors.electricIndigo
                                            .withValues(alpha: 0.08),
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
                                    l10n.reporterInfoLabel(item.reporterName, item.reporterEmail),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    l10n.reportLocationInfoLabel(
                                      '${item.reporterBuilding}'
                                      '${item.reporterFootbridge.isNotEmpty ? ", ${l10n.stairwellAbbreviationLabel(item.reporterFootbridge)}" : ""}'
                                      ', ${l10n.apartmentAbbreviationLabel(item.reporterApartment)}',
                                    ),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    l10n.reportDescriptionInfoLabel(item.description),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  if (item.photoPath != null &&
                                      item.photoPath!.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    ReportPhotoWidget(
                                      photoPath: item.photoPath!,
                                    ),
                                  ],
                                  const SizedBox(height: 12),
                                  BlocProvider(
                                    create: (_) => getIt<ReportCommentsCubit>(),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CorrespondenceSection(
                                          reportId: item.id,
                                          currentUserId: currentUserId,
                                          currentUserName:
                                              profile?.name ?? 'Serwis',
                                          currentUserRole: 'Serwisant',
                                        ),
                                        const SizedBox(height: 12),
                                        TeamNotesSection(
                                          reportId: item.id,
                                          authorName: profile?.name ?? 'Serwis',
                                          authorRole: 'Serwisant',
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton.icon(
                                      onPressed: () {
                                        final reportsCubit = context
                                            .read<ReportsCubit>();
                                        final state = reportsCubit.state;
                                        final userId = state is ReportsLoaded
                                            ? state.userId
                                            : null;
                                        final userName = state is ReportsLoaded
                                            ? state.profile?.name
                                            : null;
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                BlocProvider<
                                                  ReportsCubit
                                                >.value(
                                                  value: reportsCubit,
                                                  child: ReportDetailScreen(
                                                    report: item,
                                                    userRole: 'Serwisant',
                                                    userId: userId,
                                                    userName: userName,
                                                  ),
                                                ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.open_in_full,
                                        size: 16,
                                      ),
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
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Widget _profileTab(dynamic profile) {
    final l10n = context.l10n;
    return ListView(
      padding: const EdgeInsets.all(AppColors.spacingSm),
      children: [
        Text(
          l10n.navProfile,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: AppColors.spacingMd),
        Card(
          color: AppColors.lightCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppColors.radiusCard),
            side: const BorderSide(color: AppColors.lightBorder),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.electricIndigo.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.build,
                        color: AppColors.electricIndigo,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            // 'Serwis' is a fallback display name (mirrors the
                            // role-label mapping in role_display.dart), not a
                            // standalone UI label — kept as-is intentionally.
                            profile?.name ?? 'Serwis',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          if (profile != null && profile.email.isNotEmpty)
                            Text(
                              profile.email,
                              style: const TextStyle(
                                color: AppColors.lightTextSecondary,
                                fontSize: 13,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (profile != null && profile.phone.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    l10n.technicianPhoneLabel(profile.phone),
                    style: const TextStyle(
                      color: AppColors.lightTextSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: AppColors.spacingMd),
        Card(
          color: AppColors.lightCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppColors.radiusCard),
            side: const BorderSide(color: AppColors.lightBorder),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.deleteAccountSectionTitle,
                  style: const TextStyle(
                    color: AppColors.crimsonCoral,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.technicianDeleteAccountWarning,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).push<void>(
                      MaterialPageRoute<void>(
                        builder: (_) => const DeleteAccountConfirmationScreen(),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.crimsonCoral,
                      side: const BorderSide(color: AppColors.crimsonCoral),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(l10n.deleteAccountButtonLabel),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppColors.spacingMd),
        ElevatedButton.icon(
          onPressed: () => showLogoutFeedbackSheet(
            context: context,
            onConfirmLogout: () => getIt<AuthRepository>().signOut(),
          ),
          icon: const Icon(Icons.exit_to_app),
          label: Text(l10n.logoutFeedbackLogoutButton),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.crimsonCoral,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppColors.radiusButton),
            ),
          ),
        ),
      ],
    );
  }

  Widget _statusTab(String label, int index, Color color, bool isDark) {
    final selected = _statusTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _statusTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppColors.spacingXs),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected ? color : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              color: selected
                  ? color
                  : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary),
            ),
          ),
        ),
      ),
    );
  }

  String _statusDisplay(String status, AppLocalizations l10n) {
    switch (status.toLowerCase()) {
      case 'nowe':
        return l10n.statusNowe;
      case 'w realizacji':
        return l10n.statusWRealizacji;
      case 'zamknięte':
        return l10n.statusZamkniete;
      case 'odrzucone':
        return l10n.statusOdrzucone;
      default:
        return status;
    }
  }
}
