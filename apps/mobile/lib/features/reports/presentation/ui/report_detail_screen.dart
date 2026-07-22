import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/models/user_role.dart';
import '../../../report_comments/presentation/cubit/report_comments_cubit.dart';
import '../../../report_comments/presentation/ui/correspondence_section.dart';
import '../../../report_comments/presentation/ui/team_notes_section.dart';
import '../../../residents/models/staff_member_model.dart';
import '../../data/repositories/reports_repository.dart';
import '../../models/report_model.dart';
import '../../models/report_status.dart';
import '../../models/report_priority.dart';
import '../cubit/reports_cubit.dart';
import 'widgets/report_photo_widget.dart';
import '../../ui/widgets/report_status_timeline.dart';

String _shortId(String id, int length) {
  final end = id.length < length ? id.length : length;
  return id.substring(0, end).toUpperCase();
}

String _formatTimestamp(int timestampMs) {
  final dt = DateTime.fromMillisecondsSinceEpoch(timestampMs);
  final day = dt.day.toString().padLeft(2, '0');
  final month = dt.month.toString().padLeft(2, '0');
  final hour = dt.hour.toString().padLeft(2, '0');
  final minute = dt.minute.toString().padLeft(2, '0');
  return '$day.$month.${dt.year} $hour:$minute';
}

String _formatSlaDeadline(String? isoString) {
  if (isoString == null) return '';
  final dt = DateTime.tryParse(isoString);
  if (dt == null) return '';
  final day = dt.day.toString().padLeft(2, '0');
  final month = dt.month.toString().padLeft(2, '0');
  final hour = dt.hour.toString().padLeft(2, '0');
  final minute = dt.minute.toString().padLeft(2, '0');
  return '$day.$month.${dt.year} $hour:$minute';
}

class ReportDetailScreen extends StatelessWidget {
  final ReportModel report;
  final String userRole;
  final String? userId;
  final String? userName;
  final List<StaffMemberModel> staff;

  const ReportDetailScreen({
    super.key,
    required this.report,
    required this.userRole,
    this.userId,
    this.userName,
    this.staff = const [],
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = report.resolvedStatus;
    final role = UserRole.fromString(userRole);
    final isManager = role.isManagement;
    final isTechnician = role == UserRole.technician;
    final isResident = role == UserRole.resident;
    final showBoardNotes = isManager ||
        (isTechnician && report.revealBoardNotesToTech);

    // Lifted so _ActionsCard can check whether a resident-visible message
    // already exists (required before closing/rejecting a report) without
    // creating a second cubit instance for the comments section below.
    return BlocProvider<ReportCommentsCubit>(
      create: (_) => getIt<ReportCommentsCubit>()..load(report.id),
      child: Scaffold(
        backgroundColor: AppColors.paper,
        appBar: AppBar(title: Text(l10n.reportDetailScreenTitle)),
        body: ListView(
          padding: const EdgeInsets.all(AppColors.spacingSm),
          children: [
            _ReportHeader(report: report, status: status),
            const SizedBox(height: AppColors.spacingSm),
            ReportStatusTimeline(currentStatus: status),
            const SizedBox(height: AppColors.spacingMd),
            _InfoCard(report: report, isManager: isManager),
            if (report.description.isNotEmpty) ...[
              const SizedBox(height: AppColors.spacingSm),
              _DescriptionCard(description: report.description),
            ],
            if (report.photoPath != null && report.photoPath!.isNotEmpty) ...[
              const SizedBox(height: AppColors.spacingSm),
              _PhotoCard(photoPath: report.photoPath!),
            ],
            // Renders nothing (including no extra spacing) when the report
            // has no additional gallery photos beyond the cover above.
            _GalleryCard(reportId: report.id),
            if (report.attachmentsJson != null &&
                report.attachmentsJson!.isNotEmpty) ...[
              const SizedBox(height: AppColors.spacingSm),
              _AttachmentsCard(attachmentsJson: report.attachmentsJson!),
            ],
            const SizedBox(height: AppColors.spacingSm),
            _PrioritySlaCard(report: report, userRole: userRole),
            const SizedBox(height: AppColors.spacingSm),
            _LocationCard(report: report),
            if (report.additionalInfo != null &&
                report.additionalInfo!.isNotEmpty) ...[
              const SizedBox(height: 8),
              _AdditionalInfoCard(info: report.additionalInfo!),
            ],
            if (report.techNotes != null &&
                report.techNotes!.isNotEmpty &&
                !isResident) ...[
              const SizedBox(height: 8),
              _ServiceNotesCard(techNotes: report.techNotes!),
            ],
            const SizedBox(height: AppColors.spacingMd),
            _AssignCard(report: report, staff: staff, isManager: isManager),
            if (showBoardNotes &&
                report.boardNotes != null &&
                report.boardNotes!.isNotEmpty) ...[
              const SizedBox(height: AppColors.spacingMd),
              Card(
                color: isTechnician ? Colors.amber.shade50 : null,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.boardNotesTitle,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SelectableText(
                        report.boardNotes!,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (isManager || isTechnician) ...[
              const SizedBox(height: AppColors.spacingMd),
              _ActionsCard(report: report, userRole: userRole),
            ],
            if (isResident && status.isTerminal) ...[
              const SizedBox(height: AppColors.spacingMd),
              _CsatCard(report: report),
            ],
            const SizedBox(height: AppColors.spacingMd),
            _CorrespondenceCard(
              reportId: report.id,
              currentUserId: userId,
              currentUserName: userName ?? '',
              currentUserRole: userRole,
            ),
            if (isManager || isTechnician) ...[
              const SizedBox(height: AppColors.spacingMd),
              TeamNotesSection(
                reportId: report.id,
                authorName: userName ?? '',
                authorRole: userRole,
              ),
            ],
            const SizedBox(height: AppColors.spacingMd),
            _AuditTrailCard(report: report),
            const SizedBox(height: AppColors.spacingXl),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// HEADER: ID + status
// ──────────────────────────────────────────────────────────────────────────────

class _ReportHeader extends StatelessWidget {
  final ReportModel report;
  final ReportStatus status;

  const _ReportHeader({required this.report, required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final displayId = report.displayId ?? _shortId(report.id, 8);
    return Row(
      children: [
        Expanded(
          child: Text(
            l10n.reportDetailIdLabel(displayId),
            style: const TextStyle(
              fontFamily: 'IBMPlexMono',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.muted,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: status.color.withValues(alpha: 0.13),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: status.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                _statusLabel(status, l10n),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: status.color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _statusLabel(ReportStatus s, AppLocalizations l10n) {
    return switch (s) {
      ReportStatus.newReport => l10n.statusNowe,
      ReportStatus.inProgress => l10n.statusWRealizacji,
      ReportStatus.closed => l10n.statusZamkniete,
      ReportStatus.rejected => l10n.statusOdrzucone,
    };
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// TITLE + CATEGORY CARD
// ──────────────────────────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final ReportModel report;
  final bool isManager;

  const _InfoCard({required this.report, required this.isManager});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppColors.radiusCard),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            report.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 8),
          if (isManager)
            _CategoryDropdown(report: report)
          else if (report.category.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.azure.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                report.category,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.azure,
                ),
              ),
            ),
          const SizedBox(height: 8),
          Text(
            '${report.reporterName.isNotEmpty ? report.reporterName : "—"} · ${_formatTimestamp(report.timestamp)}',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Editable category picker shown to board/admin in [_InfoCard] instead of
/// the read-only badge — lets them recategorize a report after creation.
class _CategoryDropdown extends StatelessWidget {
  final ReportModel report;

  const _CategoryDropdown({required this.report});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final options = <String>[
      l10n.reportCategoryHydraulika,
      l10n.reportCategoryElektryka,
      l10n.reportCategoryWinda,
      l10n.reportCategoryOgrzewanie,
      l10n.reportCategoryDomofon,
      l10n.reportCategoryOswietlenie,
      l10n.reportCategoryParking,
      l10n.reportCategoryGaraz,
      l10n.reportCategoryDachElewacja,
      l10n.reportCategorySprzatanie,
      l10n.reportCategoryZielen,
      l10n.reportCategoryZarzadAdministrator,
    ];
    // The report's current category might be a legacy/free-text value not in
    // the list (e.g. seeded data) — keep it selectable so the dropdown still
    // shows the real value instead of silently falling back to null.
    final items = options.contains(report.category) || report.category.isEmpty
        ? options
        : [report.category, ...options];

    return DropdownButtonFormField<String>(
      initialValue: report.category.isEmpty ? null : report.category,
      decoration: InputDecoration(
        labelText: l10n.reportCategoryLabel,
        isDense: true,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
      style: const TextStyle(
        fontSize: 12.5,
        fontWeight: FontWeight.w600,
        color: AppColors.azure,
      ),
      items: items
          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
          .toList(),
      onChanged: (category) {
        if (category == null) return;
        context.read<ReportsCubit>().setReportCategory(report.id, category);
      },
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// DESCRIPTION CARD
// ──────────────────────────────────────────────────────────────────────────────

class _DescriptionCard extends StatelessWidget {
  final String description;

  const _DescriptionCard({required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppColors.radiusCard),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Opis',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.lightTextSecondary,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          SelectableText(
            description,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.ink,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// PHOTO CARD
// ──────────────────────────────────────────────────────────────────────────────

class _PhotoCard extends StatelessWidget {
  final String photoPath;

  const _PhotoCard({required this.photoPath});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppColors.radiusCard),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.photoGalleryLabel,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.lightTextSecondary,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          ReportPhotoWidget(photoPath: photoPath),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// GALLERY CARD (photos beyond the single cover photo, from
// fixflow_report_images — populated when the composer attaches more than
// one photo)
// ──────────────────────────────────────────────────────────────────────────────

class _GalleryCard extends StatefulWidget {
  final String reportId;

  const _GalleryCard({required this.reportId});

  @override
  State<_GalleryCard> createState() => _GalleryCardState();
}

class _GalleryCardState extends State<_GalleryCard> {
  late Future<List<String>> _imagesFuture;

  @override
  void initState() {
    super.initState();
    _imagesFuture = getIt<ReportsRepository>().getReportImages(widget.reportId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _imagesFuture,
      builder: (context, snapshot) {
        final images = snapshot.data ?? const <String>[];
        if (images.isEmpty) return const SizedBox.shrink();
        final l10n = context.l10n;
        return Padding(
          padding: const EdgeInsets.only(top: AppColors.spacingSm),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.lightCard,
              borderRadius: BorderRadius.circular(AppColors.radiusCard),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.galleryLabel(images.length),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.lightTextSecondary,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 96,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 9),
                    itemBuilder: (context, index) => ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: ReportPhotoWidget(
                        photoPath: images[index],
                        width: 96,
                        height: 96,
                        borderRadius: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// ATTACHMENTS CARD (PDF documents attached to the report)
// ──────────────────────────────────────────────────────────────────────────────

class _AttachmentsCard extends StatelessWidget {
  final String attachmentsJson;

  const _AttachmentsCard({required this.attachmentsJson});

  List<Map<String, dynamic>> get _attachments {
    try {
      final decoded = jsonDecode(attachmentsJson) as List;
      return decoded
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    } catch (e) {
      debugPrint('❌ [_AttachmentsCard] failed to parse attachmentsJson: $e');
      return const [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final attachments = _attachments;
    if (attachments.isEmpty) return const SizedBox.shrink();
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppColors.radiusCard),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.attachmentsLabel,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.lightTextSecondary,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 10),
          ...attachments.map(
            (a) => _AttachmentTile(
              name: a['name'] as String? ?? 'dokument.pdf',
              storagePath: a['url'] as String? ?? '',
            ),
          ),
        ],
      ),
    );
  }
}

class _AttachmentTile extends StatefulWidget {
  final String name;
  final String storagePath;

  const _AttachmentTile({required this.name, required this.storagePath});

  @override
  State<_AttachmentTile> createState() => _AttachmentTileState();
}

class _AttachmentTileState extends State<_AttachmentTile> {
  // Same bucket used for report photos (fixflow-report-photos) — PDFs are
  // stored there too, no mime-type restriction on the bucket.
  static const String _bucket = 'fixflow-report-photos';

  bool _isOpening = false;
  bool _hasError = false;

  Future<void> _open() async {
    if (widget.storagePath.isEmpty || _isOpening) return;
    setState(() {
      _isOpening = true;
      _hasError = false;
    });
    try {
      final isHttp = widget.storagePath.startsWith('http');
      final url = isHttp
          ? widget.storagePath
          : await Supabase.instance.client.storage
                .from(_bucket)
                .createSignedUrl(widget.storagePath, 3600);
      final launched = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
      if (!launched) throw Exception('launchUrl returned false');
    } catch (e) {
      debugPrint(
        '❌ [_AttachmentTile] failed to open ${widget.storagePath}: $e',
      );
      if (mounted) setState(() => _hasError = true);
    } finally {
      if (mounted) setState(() => _isOpening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: _open,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.paper,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.picture_as_pdf_outlined,
                    size: 18,
                    color: AppColors.danger,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (_isOpening)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    Text(
                      l10n.attachmentOpenLabel,
                      style: const TextStyle(
                        fontFamily: 'IBMPlexMono',
                        fontSize: 11,
                        color: AppColors.azure,
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (_hasError)
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 4),
              child: SelectableText(
                l10n.attachmentOpenError,
                style: const TextStyle(fontSize: 11.5, color: AppColors.danger),
              ),
            ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// PRIORITY + SLA CARD
// ──────────────────────────────────────────────────────────────────────────────

class _PrioritySlaCard extends StatefulWidget {
  final ReportModel report;
  final String userRole;

  const _PrioritySlaCard({required this.report, required this.userRole});

  @override
  State<_PrioritySlaCard> createState() => _PrioritySlaCardState();
}

class _PrioritySlaCardState extends State<_PrioritySlaCard> {
  late ReportPriority _priority;

  @override
  void initState() {
    super.initState();
    _priority = ReportPriority.fromString(widget.report.priority ?? 'normal');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final role = UserRole.fromString(widget.userRole);
    final canChangePriority = role.canSetPriority;
    final isOverdue = widget.report.isSlaOverdue;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppColors.radiusCard),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Priorytet i SLA',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.lightTextSecondary,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (canChangePriority)
                Expanded(
                  child: DropdownButtonFormField<ReportPriority>(
                    initialValue: _priority,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    items: ReportPriority.values.map((p) {
                      return DropdownMenuItem(
                        value: p,
                        child: Row(
                          children: [
                            Icon(p.icon, size: 16, color: p.color),
                            const SizedBox(width: 8),
                            Text(
                              _priorityLabel(p, l10n),
                              style: TextStyle(fontSize: 13, color: p.color),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (p) {
                      if (p == null) return;
                      setState(() => _priority = p);
                      context.read<ReportsCubit>().setReportPriority(
                        widget.report.id,
                        p,
                      );
                    },
                  ),
                )
              else ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _priority.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_priority.icon, size: 16, color: _priority.color),
                      const SizedBox(width: 6),
                      Text(
                        _priorityLabel(_priority, l10n),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _priority.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.slaDeadlineLabel,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            widget.report.slaDeadline != null
                                ? _formatSlaDeadline(widget.report.slaDeadline)
                                : '—',
                            style: const TextStyle(
                              fontFamily: 'IBMPlexMono',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (isOverdue) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.danger.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              l10n.slaOverdueLabel,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.danger,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _priorityLabel(ReportPriority p, AppLocalizations l10n) {
    return switch (p) {
      ReportPriority.low => l10n.priorityLow,
      ReportPriority.normal => l10n.priorityNormal,
      ReportPriority.high => l10n.priorityHigh,
      ReportPriority.critical => l10n.priorityCritical,
    };
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// LOCATION CARD
// ──────────────────────────────────────────────────────────────────────────────

class _LocationCard extends StatelessWidget {
  final ReportModel report;

  const _LocationCard({required this.report});

  @override
  Widget build(BuildContext context) {
    final location = StringBuffer();
    if (report.reporterBuilding.isNotEmpty) {
      location.write(report.reporterBuilding);
    }
    if (report.reporterFootbridge.isNotEmpty) {
      location.write(', kl. ${report.reporterFootbridge}');
    }
    if (report.reporterFloor.isNotEmpty) {
      location.write(', p. ${report.reporterFloor}');
    }
    if (report.reporterApartment.isNotEmpty) {
      location.write(', m. ${report.reporterApartment}');
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppColors.radiusCard),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.location_on_outlined,
            color: AppColors.lightTextSecondary,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              location.toString().isNotEmpty ? location.toString() : '—',
              style: const TextStyle(fontSize: 13, color: AppColors.ink),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// ADDITIONAL INFO CARD (free-text note from the reporter, e.g. "police is
// coming" — set once at creation time in the composer, read-only here)
// ──────────────────────────────────────────────────────────────────────────────

class _AdditionalInfoCard extends StatelessWidget {
  final String info;

  const _AdditionalInfoCard({required this.info});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppColors.radiusCard),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.additionalInfoLabel,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF9a6b00),
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            info,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF7a5800),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// SERVICE NOTES CARD
// ──────────────────────────────────────────────────────────────────────────────

class _ServiceNotesCard extends StatefulWidget {
  final String techNotes;

  const _ServiceNotesCard({required this.techNotes});

  @override
  State<_ServiceNotesCard> createState() => _ServiceNotesCardState();
}

class _ServiceNotesCardState extends State<_ServiceNotesCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(AppColors.radiusCard),
        border: Border.all(color: const Color(0xFFFFD54F)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.build, size: 18, color: Color(0xFFB45309)),
              const SizedBox(width: 8),
              Text(
                context.l10n.serviceNotesLabel,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFB45309),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.techNotes,
            maxLines: _expanded ? null : 3,
            overflow: _expanded ? null : TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF78350F),
              height: 1.5,
            ),
          ),
          if (widget.techNotes.length > 200)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => setState(() => _expanded = !_expanded),
                child: Text(
                  _expanded ? 'Zwiń' : 'Rozwiń',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFFB45309),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// ASSIGNMENT CARD (Manager only)
// ──────────────────────────────────────────────────────────────────────────────

class _AssignCard extends StatelessWidget {
  final ReportModel report;
  final List<StaffMemberModel> staff;
  final bool isManager;

  const _AssignCard({
    required this.report,
    required this.staff,
    required this.isManager,
  });

  @override
  Widget build(BuildContext context) {
    if (!isManager || staff.isEmpty) return const SizedBox.shrink();

    final l10n = context.l10n;
    final hasActiveValue = staff.any((m) => m.id == report.assignedToUserId);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppColors.radiusCard),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Przypisanie',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.lightTextSecondary,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String?>(
            initialValue: hasActiveValue ? report.assignedToUserId : null,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
            items: [
              DropdownMenuItem<String?>(
                value: null,
                child: Text(
                  l10n.unassigned,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
              ...staff.map((member) {
                return DropdownMenuItem<String?>(
                  value: member.id,
                  child: Text(
                    '${member.name} (${member.role})',
                    style: const TextStyle(fontSize: 13),
                  ),
                );
              }),
            ],
            onChanged: (newUserId) {
              final cubit = context.read<ReportsCubit>();
              if (newUserId == null) {
                cubit.assignReportToUser(report.id, null, null, null);
              } else {
                final selected = staff.firstWhere((m) => m.id == newUserId);
                cubit.assignReportToUser(
                  report.id,
                  selected.id,
                  selected.name,
                  selected.role,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// ACTIONS CARD (Manager / Technician status change)
// ──────────────────────────────────────────────────────────────────────────────

class _ActionsCard extends StatefulWidget {
  final ReportModel report;
  final String userRole;

  const _ActionsCard({required this.report, required this.userRole});

  @override
  State<_ActionsCard> createState() => _ActionsCardState();
}

class _ActionsCardState extends State<_ActionsCard> {
  // Set when the user tries to close/reject without a resident-visible
  // message first — shown as an inline warning until they add one.
  bool _blockedAttempt = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = widget.report.resolvedStatus;
    if (status.isTerminal) return const SizedBox.shrink();

    final role = UserRole.fromString(widget.userRole);

    // Build available status options based on role permissions
    final nextStatuses = <String>[
      'Nowe',
      'W realizacji',
      'Zamknięte',
      // Only admin can set "Odrzucone"
      if (role.canReject) 'Odrzucone',
    ];

    // A "message to the resident" is a non-internal comment in the thread
    // below. Closing/rejecting without one first is blocked (the resident
    // must always learn why their report was resolved).
    final commentsState = context.watch<ReportCommentsCubit>().state;
    final hasResidentMessage =
        commentsState is ReportCommentsLoaded &&
        commentsState.comments.any((c) => !c.isInternal);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppColors.radiusCard),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.actionsSectionTitle,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.lightTextSecondary,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: nextStatuses.map((s) {
              final reportStatus = ReportStatus.fromString(s);
              final isCurrent = status == reportStatus;
              final requiresMessage =
                  reportStatus == ReportStatus.closed ||
                  reportStatus == ReportStatus.rejected;
              return ElevatedButton.icon(
                onPressed: isCurrent
                    ? null
                    : () => _onStatusTap(
                        context,
                        s,
                        blockedByMessage:
                            requiresMessage && !hasResidentMessage,
                      ),
                icon: Icon(
                  reportStatus.icon,
                  size: 16,
                  color: isCurrent ? AppColors.muted : Colors.white,
                ),
                label: Text(
                  _actionLabel(reportStatus, l10n),
                  style: TextStyle(
                    color: isCurrent ? AppColors.muted : Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCurrent
                      ? AppColors.mist
                      : reportStatus.color,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          if (_blockedAttempt)
            SelectableText(
              l10n.reportCloseRequiresMessageWarning,
              style: const TextStyle(fontSize: 12, color: AppColors.danger),
            )
          else
            Text(
              l10n.reportCloseRequiresMessageHint,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.lightTextSecondary,
              ),
            ),
        ],
      ),
    );
  }

  void _onStatusTap(
    BuildContext context,
    String status, {
    required bool blockedByMessage,
  }) {
    if (blockedByMessage) {
      setState(() => _blockedAttempt = true);
      return;
    }
    setState(() => _blockedAttempt = false);
    context.read<ReportsCubit>().updateStatus(widget.report.id, status);
  }

  String _actionLabel(ReportStatus s, AppLocalizations l10n) {
    return switch (s) {
      ReportStatus.newReport => l10n.statusNowe,
      ReportStatus.inProgress => l10n.statusWRealizacji,
      ReportStatus.closed => l10n.statusZamkniete,
      ReportStatus.rejected => l10n.statusOdrzucone,
    };
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// CSAT RATING CARD (Resident only, after closure)
// ──────────────────────────────────────────────────────────────────────────────

class _CsatCard extends StatefulWidget {
  final ReportModel report;

  const _CsatCard({required this.report});

  @override
  State<_CsatCard> createState() => _CsatCardState();
}

class _CsatCardState extends State<_CsatCard> {
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final alreadyRated = widget.report.csatRating != null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppColors.radiusCard),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            l10n.csatTitle,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 12),
          if (alreadyRated)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                return Icon(
                  i < widget.report.csatRating!
                      ? Icons.star
                      : Icons.star_border,
                  color: AppColors.amber,
                  size: 32,
                );
              }),
            )
          else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                return GestureDetector(
                  onTap: () => setState(() => _rating = i + 1),
                  child: Icon(
                    i < _rating ? Icons.star : Icons.star_border,
                    color: AppColors.amber,
                    size: 36,
                  ),
                );
              }),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _rating == 0
                  ? null
                  : () {
                      context.read<ReportsCubit>().submitCsatRating(
                        widget.report.id,
                        _rating,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.csatSubmittedSnackbar)),
                      );
                      setState(() {});
                    },
              icon: const Icon(Icons.send, size: 16),
              label: Text(l10n.csatSubmitButton),
            ),
          ],
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// CORRESPONDENCE CARD (resident ↔ office chat — separate from TeamNotesSection)
// ──────────────────────────────────────────────────────────────────────────────

class _CorrespondenceCard extends StatelessWidget {
  final String reportId;
  final String? currentUserId;
  final String currentUserName;
  final String currentUserRole;

  const _CorrespondenceCard({
    required this.reportId,
    required this.currentUserId,
    required this.currentUserName,
    required this.currentUserRole,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppColors.radiusCard),
        border: Border.all(color: AppColors.cardBorder),
      ),
      // ReportCommentsCubit is provided by ReportDetailScreen so _ActionsCard
      // can also read it (required-message-before-closing check) without a
      // second cubit instance querying the same report.
      child: CorrespondenceSection(
        reportId: reportId,
        currentUserId: currentUserId,
        currentUserName: currentUserName.isNotEmpty
            ? currentUserName
            : l10n.unknownUserFallback,
        currentUserRole: currentUserRole,
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// AUDIT TRAIL CARD
// ──────────────────────────────────────────────────────────────────────────────

class _AuditTrailCard extends StatelessWidget {
  final ReportModel report;

  const _AuditTrailCard({required this.report});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final trail = report.auditTrail;
    if (trail == null || trail.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppColors.radiusCard),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.auditTrailTitle,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.lightTextSecondary,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          ...trail.reversed.map((entry) => _AuditTrailEntry(entry: entry)),
        ],
      ),
    );
  }
}

class _AuditTrailEntry extends StatelessWidget {
  final Map<String, dynamic> entry;

  const _AuditTrailEntry({required this.entry});

  @override
  Widget build(BuildContext context) {
    final action = entry['action'] as String? ?? '';
    final l10n = context.l10n;
    final userName = entry['user_name'] as String? ?? l10n.unknownUserFallback;
    final timestamp = entry['timestamp'] as String? ?? '';
    final time = _formatSlaDeadline(timestamp);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.circle, size: 8, color: AppColors.muted),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 12, color: AppColors.ink),
                    children: [
                      TextSpan(
                        text: userName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const TextSpan(text: ' — '),
                      TextSpan(text: action),
                    ],
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(
                    fontFamily: 'IBMPlexMono',
                    fontSize: 10,
                    color: AppColors.lightTextSecondary,
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
