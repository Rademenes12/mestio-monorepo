import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../l10n/l10n.dart';
import '../../../../announcements/presentation/cubit/announcements_cubit.dart';
import '../../../../announcements/models/announcement_model.dart';
import '../../../../profiles/models/resident_profile_model.dart';
import '../../../models/report_model.dart';
import '../../../models/report_status.dart';
import '../widgets/report_tile_widget.dart';

/// Resident home tab — greeting, drill-down cards for reports, announcements,
/// and community.
class ResidentHomeTab extends StatelessWidget {
  final List<ReportModel> reports;
  final ResidentProfileModel? profile;
  final VoidCallback onNavigateToReports;
  final VoidCallback onNavigateToProfile;

  const ResidentHomeTab({
    super.key,
    required this.reports,
    required this.profile,
    required this.onNavigateToReports,
    required this.onNavigateToProfile,
  });

  @override
  Widget build(BuildContext context) {
    final activeReports =
        reports.where((r) => !r.resolvedStatus.isTerminal).toList();
    final role = profile?.role ?? 'Mieszkaniec';
    final l10n = context.l10n;

    final newCount = activeReports.where((r) => r.resolvedStatus == ReportStatus.newReport).length;
    final inProgressCount = activeReports.where((r) => r.resolvedStatus == ReportStatus.inProgress).length;
    final criticalCount = activeReports.where((r) => r.priority == 'Krytyczny').length;

    return ListView(
      padding: const EdgeInsets.all(AppColors.spacingSm),
      children: [
        _GreetingHeader(profile: profile, onTap: onNavigateToProfile),
        const SizedBox(height: AppColors.spacingMd),

        if (role == 'Mieszkaniec') ...[
          _BuildingInfoBar(profile: profile),
          const SizedBox(height: AppColors.spacingSm),
        ] else ...[
          _RoleBadge(role: role),
          const SizedBox(height: AppColors.spacingSm),
        ],

        _DrillDownCard(
          icon: Icons.report_problem_outlined,
          iconColor: AppColors.azure,
          title: l10n.residentMyReportsCardTitle,
          subtitle: activeReports.isEmpty
              ? l10n.noActiveReports
              : '$newCount ${l10n.residentNewLabel}, $inProgressCount ${l10n.residentInProgressLabel}',
          trailing: activeReports.isNotEmpty
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (criticalCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.danger.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$criticalCount ${l10n.residentCriticalLabel}',
                          style: const TextStyle(color: AppColors.danger, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right, color: AppColors.lightTextSecondary),
                  ],
                )
              : const Icon(Icons.chevron_right, color: AppColors.lightTextSecondary),
          onTap: onNavigateToReports,
        ),
        const SizedBox(height: 12),

        BlocBuilder<AnnouncementsCubit, AnnouncementsState>(
          builder: (context, aState) {
            final list = aState is AnnouncementsLoaded
                ? aState.announcements
                : const <Announcement>[];
            final latest = list
                .where((a) => !a.isExpired)
                .cast<Announcement?>()
                .firstWhere((_) => true, orElse: () => null);

            return _DrillDownCard(
              icon: Icons.campaign_outlined,
              iconColor: AppColors.amber,
              title: latest?.title ?? l10n.latestAnnouncementHeader,
              subtitle: latest?.content ?? l10n.noActiveReports,
              subtitleMaxLines: 2,
              badge: list.where((a) => !a.isExpired).length > 1
                  ? '${list.where((a) => !a.isExpired).length}'
                  : null,
              trailing: const Icon(Icons.chevron_right, color: AppColors.lightTextSecondary),
              onTap: onNavigateToReports,
            );
          },
        ),
        const SizedBox(height: 12),

        _DrillDownCard(
          icon: Icons.people_outline,
          iconColor: AppColors.mint,
          title: l10n.residentCommunityTitle,
          subtitle: l10n.residentCommunitySubtitle,
          trailing: const Icon(Icons.chevron_right, color: AppColors.lightTextSecondary),
          onTap: null,
        ),
        const SizedBox(height: 12),

        if (activeReports.isNotEmpty) ...[
          Text(
            l10n.activeReportsHeader,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: AppColors.spacingXs),
          ...activeReports.take(3).map((r) => ReportTileWidget(report: r)),
          TextButton(
            onPressed: onNavigateToReports,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(l10n.seeAllReports),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward, size: 16),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _GreetingHeader extends StatelessWidget {
  final ResidentProfileModel? profile;
  final VoidCallback onTap;

  const _GreetingHeader({required this.profile, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.residentGreetingMorning,
              style: const TextStyle(
                color: AppColors.lightTextSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              profile?.name ?? context.l10n.residentGreetingFallback,
              style: const TextStyle(
                color: AppColors.lightTextPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            backgroundColor: AppColors.electricIndigo.withValues(alpha: 0.1),
            child: Text(
              profile?.name.isNotEmpty == true
                  ? profile!.name[0].toUpperCase()
                  : '👤',
              style: const TextStyle(
                color: AppColors.electricIndigo,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BuildingInfoBar extends StatelessWidget {
  final ResidentProfileModel? profile;

  const _BuildingInfoBar({required this.profile});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppColors.spacingSm,
        vertical: AppColors.spacingXs,
      ),
      decoration: BoxDecoration(
        color: AppColors.mint.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppColors.radiusCard),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: AppColors.mint,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppColors.spacingXs),
              Expanded(
            child: Text(
              profile != null
                  ? '${profile!.building} · ${profile!.footbridge} · ${profile!.apartment}'
                  : l10n.residentAddressUnknown,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.lightTextPrimary,
              ),
            ),
          ),
          Text(
            l10n.residentSystemsOK,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.mint,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final String role;

  const _RoleBadge({required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppColors.spacingSm,
        vertical: AppColors.spacingXs,
      ),
      decoration: BoxDecoration(
        color: AppColors.electricIndigo.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppColors.radiusButton),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.shield_outlined,
            size: 16,
            color: AppColors.electricIndigo,
          ),
          const SizedBox(width: AppColors.spacingXs),
          Text(
            role,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.electricIndigo,
            ),
          ),
        ],
      ),
    );
  }
}

class _DrillDownCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final int? subtitleMaxLines;
  final String? badge;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _DrillDownCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.subtitleMaxLines,
    this.badge,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.lightCard,
      borderRadius: BorderRadius.circular(AppColors.radiusCard),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppColors.radiusCard),
        child: Container(
          padding: const EdgeInsets.all(AppColors.spacingSm),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppColors.radiusCard),
            border: Border.all(color: AppColors.lightBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.lightTextPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null && subtitle!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.lightTextSecondary,
                        ),
                        maxLines: subtitleMaxLines ?? 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (badge != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.azure.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badge!,
                    style: const TextStyle(
                      color: AppColors.azure,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
              ],
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }
}
