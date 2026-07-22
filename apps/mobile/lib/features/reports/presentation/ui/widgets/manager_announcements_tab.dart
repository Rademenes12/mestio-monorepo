import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../l10n/l10n.dart';
import '../../../../../shared/error_messages.dart';
import '../../../services/fcm_service.dart';
import '../../../models/building_model.dart';
import '../../cubit/reports_cubit.dart';
import '../../cubit/estate_cubit.dart';
import '../../../../announcements/presentation/cubit/announcements_cubit.dart';

/// Manager "Komunikator" tab: composer form for broadcasting an announcement
/// (with optional expiry and scope targeting) plus the sent-announcements
/// history list. Owns its own composer state (was previously scattered
/// across _DashboardScreenState).
class ManagerAnnouncementsTab extends StatefulWidget {
  const ManagerAnnouncementsTab({super.key});

  @override
  State<ManagerAnnouncementsTab> createState() => ManagerAnnouncementsTabState();
}

class ManagerAnnouncementsTabState extends State<ManagerAnnouncementsTab> {
  final _broadcastTitleController = TextEditingController();
  final _broadcastBodyController = TextEditingController();
  String _selectedScopeKey = 'estate';
  String _selectedScopeType = 'estate';
  String? _selectedScopeBuildingId;
  String? _selectedScopeStairwellId;
  String _selectedScopeLabel = '';
  int? _broadcastExpiryDay;
  int? _broadcastExpiryMonth;
  int? _broadcastExpiryYear;
  bool _broadcastFailed = false;

  @override
  void dispose() {
    _broadcastTitleController.dispose();
    _broadcastBodyController.dispose();
    super.dispose();
  }

  Future<void> _sendBroadcastMessage() async {
    final title = _broadcastTitleController.text.trim();
    final content = _broadcastBodyController.text.trim();
    if (title.isEmpty || content.isEmpty) return;

    DateTime? expiresAt;
    if (_broadcastExpiryDay != null &&
        _broadcastExpiryMonth != null &&
        _broadcastExpiryYear != null) {
      try {
        expiresAt = DateTime(
          _broadcastExpiryYear!,
          _broadcastExpiryMonth!,
          _broadcastExpiryDay!,
          23,
          59,
        );
      } catch (_) {
        // Invalid date (e.g. 31 Feb) - ignore expiry.
      }
    }

    final reportsState = context.read<ReportsCubit>().state;
    final profile = reportsState is ReportsLoaded ? reportsState.profile : null;

    final cubit = context.read<AnnouncementsCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final targetLabel = _selectedScopeLabel.isEmpty
        ? context.l10n.announcementScopeEstate
        : _selectedScopeLabel;
    final ok = await cubit.create(
      title: '📢 $title',
      content: content,
      authorName: profile?.name ?? '—',
      authorRole: profile?.role ?? 'Zarząd',
      targetLabel: targetLabel,
      expiresAt: expiresAt,
      scopeType: _selectedScopeType,
      scopeBuildingId: _selectedScopeBuildingId,
      scopeStairwellId: _selectedScopeStairwellId,
    );

    if (!mounted) return;

    if (!ok) {
      setState(() => _broadcastFailed = true);
      return;
    }
    if (_broadcastFailed) {
      setState(() => _broadcastFailed = false);
    }

    final l10n = context.l10n;

    getIt<FcmService>().simulateIncomingNotification(
      title: l10n.announcementPushNotificationPrefix(title),
      body: content,
      reportId: "broadcast-id",
      status: "Broadcast",
      topic: "admin_reports",
    );

    setState(() {
      _broadcastExpiryDay = null;
      _broadcastExpiryMonth = null;
      _broadcastExpiryYear = null;
    });
    _broadcastTitleController.clear();
    _broadcastBodyController.clear();
    messenger.showSnackBar(
      SnackBar(
        content: Text(l10n.announcementSentSnackbar),
        backgroundColor: AppColors.neonMint,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final estateId = context.read<ReportsCubit>().currentEstateId;
    return BlocProvider<EstateCubit>(
      create: (_) {
        final cubit = getIt<EstateCubit>();
        if (estateId != null) cubit.setEstateId(estateId);
        return cubit;
      },
      child: _announcementsListView(context),
    );
  }

  Widget _announcementsListView(BuildContext context) {
    final l10n = context.l10n;
    return ListView(
      padding: const EdgeInsets.all(AppColors.spacingSm),
      children: [
        Text(
          l10n.navAnnouncements,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Send announcement form
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.lightCard,
            borderRadius: BorderRadius.circular(AppColors.radiusCard),
            border: Border.all(color: AppColors.lightBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.sendAnnouncementFormTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  letterSpacing: 1.1,
                  color: AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _broadcastTitleController,
                decoration: InputDecoration(
                  labelText: l10n.announcementTitleLabel,
                  hintText: l10n.announcementTitleHint,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _broadcastBodyController,
                decoration: InputDecoration(
                  labelText: l10n.announcementContentLabel,
                  hintText: l10n.announcementContentHint,
                  border: const OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                minLines: 3,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.announcementExpiryLabel,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      initialValue: _broadcastExpiryDay,
                      decoration: InputDecoration(
                        labelText: l10n.dayLabel,
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                      ),
                      items: [
                        for (var d = 1; d <= 31; d++)
                          DropdownMenuItem(value: d, child: Text('$d')),
                      ],
                      onChanged: (v) => setState(() => _broadcastExpiryDay = v),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      initialValue: _broadcastExpiryMonth,
                      decoration: InputDecoration(
                        labelText: l10n.monthLabel,
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                      ),
                      items: [
                        for (var m = 1; m <= 12; m++)
                          DropdownMenuItem(value: m, child: Text('$m')),
                      ],
                      onChanged: (v) =>
                          setState(() => _broadcastExpiryMonth = v),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Builder(
                      builder: (_) {
                        final thisYear = DateTime.now().year;
                        return DropdownButtonFormField<int>(
                          initialValue: _broadcastExpiryYear,
                          decoration: InputDecoration(
                            labelText: l10n.yearLabel,
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                          ),
                          items: [
                            for (var y = thisYear; y <= thisYear + 5; y++)
                              DropdownMenuItem(value: y, child: Text('$y')),
                          ],
                          onChanged: (v) =>
                              setState(() => _broadcastExpiryYear = v),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              BlocBuilder<EstateCubit, EstateState>(
                builder: (context, estateState) {
                  final buildings = estateState is EstateLoaded
                      ? estateState.buildings
                      : const <BuildingWithStairwells>[];

                  final items = <DropdownMenuItem<String>>[
                    DropdownMenuItem(
                      value: 'estate',
                      child: Text(l10n.announcementScopeEstate),
                    ),
                    for (final b in buildings) ...[
                      DropdownMenuItem(
                        value: 'building:${b.building.id}',
                        child: Text(
                          l10n.announcementScopeBuilding(b.building.name),
                        ),
                      ),
                      for (final s in b.stairwells)
                        DropdownMenuItem(
                          value: 'stairwell:${b.building.id}:${s.id}',
                          child: Padding(
                            padding: const EdgeInsets.only(left: 14),
                            child: Text(
                              l10n.announcementScopeStairwell(
                                s.name,
                                b.building.name,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                    ],
                  ];
                  final validKeys = items.map((i) => i.value).toSet();
                  final currentKey = validKeys.contains(_selectedScopeKey)
                      ? _selectedScopeKey
                      : 'estate';

                  return DropdownButtonFormField<String>(
                    initialValue: currentKey,
                    style: const TextStyle(
                      color: AppColors.lightTextPrimary,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      labelText: l10n.announcementScopeLabel,
                      border: const OutlineInputBorder(),
                    ),
                    items: items,
                    onChanged: (key) {
                      if (key == null) return;
                      setState(() {
                        _selectedScopeKey = key;
                        if (key == 'estate') {
                          _selectedScopeType = 'estate';
                          _selectedScopeBuildingId = null;
                          _selectedScopeStairwellId = null;
                          _selectedScopeLabel = l10n.announcementScopeEstate;
                        } else if (key.startsWith('building:')) {
                          final buildingId = key.substring(9);
                          final b = buildings.firstWhere(
                            (x) => x.building.id == buildingId,
                          );
                          _selectedScopeType = 'building';
                          _selectedScopeBuildingId = buildingId;
                          _selectedScopeStairwellId = null;
                          _selectedScopeLabel = l10n.announcementScopeBuilding(
                            b.building.name,
                          );
                        } else {
                          final parts = key.split(':');
                          final buildingId = parts[1];
                          final stairwellId = parts[2];
                          final b = buildings.firstWhere(
                            (x) => x.building.id == buildingId,
                          );
                          final s = b.stairwells.firstWhere(
                            (x) => x.id == stairwellId,
                          );
                          _selectedScopeType = 'stairwell';
                          _selectedScopeBuildingId = buildingId;
                          _selectedScopeStairwellId = stairwellId;
                          _selectedScopeLabel = l10n.announcementScopeStairwell(
                            s.name,
                            b.building.name,
                          );
                        }
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              Container(
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00F2FE), Color(0xFF4FACFE)],
                  ),
                  borderRadius: BorderRadius.circular(AppColors.radiusButton),
                ),
                child: ElevatedButton.icon(
                  onPressed: _sendBroadcastMessage,
                  icon: const Icon(Icons.send, color: Colors.white, size: 18),
                  label: Text(
                    l10n.sendAnnouncementButton,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppColors.radiusButton,
                      ),
                    ),
                  ),
                ),
              ),
              if (_broadcastFailed) ...[
                const SizedBox(height: 8),
                SelectableText(
                  l10n.errorUnknown,
                  style: const TextStyle(color: AppColors.crimsonCoral, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Sent announcements history
        Text(
          l10n.sentAnnouncementsTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 11,
            letterSpacing: 1.1,
            color: AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 12),
        BlocBuilder<AnnouncementsCubit, AnnouncementsState>(
          builder: (context, state) {
            if (state is AnnouncementsLoading ||
                state is AnnouncementsInitial) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (state is AnnouncementsError) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    SelectableText(
                      messageForErrorKey(l10n, state.errorKey),
                      style: const TextStyle(color: AppColors.crimsonCoral),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<AnnouncementsCubit>().retry(),
                      child: Text(l10n.retryButtonLabel),
                    ),
                  ],
                ),
              );
            }
            final loaded = state as AnnouncementsLoaded;
            if (loaded.announcements.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.campaign_outlined,
                        size: 48,
                        color: AppColors.azure.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.emptyAnnouncementsTitle,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.emptyAnnouncementsBody,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.lightTextSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Column(
              children: loaded.announcements.map((ann) {
                final exp = ann.expiresAt;
                final expLabel = exp != null
                    ? l10n.announcementExpiresOnLabel(
                        '${exp.day.toString().padLeft(2, '0')}.'
                        '${exp.month.toString().padLeft(2, '0')}.'
                        '${exp.year}',
                      )
                    : null;
                final isExpired = ann.isExpired;
                return Card(
                  color: AppColors.lightCard,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppColors.radiusCard),
                    side: BorderSide(
                      color: isExpired
                          ? AppColors.lightTextSecondary.withValues(alpha: 0.3)
                          : AppColors.lightBorder,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                ann.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isExpired
                                      ? AppColors.lightTextSecondary
                                      : null,
                                ),
                              ),
                            ),
                            if ((ann.targetLabel ?? '').isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.electricIndigo.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  ann.targetLabel!,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.electricIndigo,
                                  ),
                                ),
                              ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                size: 20,
                                color: AppColors.crimsonCoral,
                              ),
                              tooltip: l10n.deleteAnnouncementTooltip,
                              onPressed: () => context
                                  .read<AnnouncementsCubit>()
                                  .delete(ann.id),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          ann.content,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.lightTextSecondary,
                          ),
                        ),
                        if (expLabel != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            isExpired
                                ? l10n.announcementExpiredSuffix(expLabel)
                                : expLabel,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: isExpired
                                  ? AppColors.crimsonCoral
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
