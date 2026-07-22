import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../l10n/l10n.dart';
import '../../../models/report_model.dart';
import '../../../../estate/models/estate_model.dart';
import '../../../../estate/presentation/cubit/estate_cubit.dart' as membership;
import 'notification_bell_button.dart';

/// AppBar with the multi-estate switcher dropdown (shown when the user
/// belongs to more than one estate) and the notifications bell.
class EstateSwitcherAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EstateSwitcherAppBar({
    super.key,
    required this.estates,
    required this.active,
    required this.reports,
  });

  final List<Estate> estates;
  final Estate? active;
  final List<ReportModel> reports;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppBar(
      backgroundColor: AppColors.lightCanvas,
      elevation: 0,
      titleSpacing: AppColors.spacingSm,
      leadingWidth: 0,
      leading: const SizedBox.shrink(),
      actions: [
        NotificationBellButton(reports: reports),
        const SizedBox(width: 4),
      ],
      title: PopupMenuButton<Estate>(
        offset: const Offset(0, 40),
        color: AppColors.lightCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        itemBuilder: (_) {
          return [
            ...estates.map((e) {
              final isActive = active?.id == e.id;
              final color = Color(e.accentColorValue);
              return PopupMenuItem<Estate>(
                value: e,
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        e.shortCode,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: color,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        e.name,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isActive
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                    if (isActive) Icon(Icons.check, size: 16, color: color),
                  ],
                ),
              );
            }),
            const PopupMenuDivider(),
            PopupMenuItem<Estate>(
              enabled: false,
              child: Text(
                l10n.addAnotherEstateMenuLabel,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.lightTextSecondary,
                ),
              ),
            ),
          ];
        },
        onSelected: (estate) {
          context.read<membership.EstateMembershipCubit>().selectEstate(
            estate.id,
          );
        },
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (active != null) ...[
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(active!.accentColorValue),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Color(
                      active!.accentColorValue,
                    ).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    active!.shortCode,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Color(active!.accentColorValue),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    active!.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.lightTextPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: 4),
              ],
              const Icon(
                Icons.keyboard_arrow_down,
                size: 18,
                color: AppColors.lightTextSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
