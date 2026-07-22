import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';
import '../../../moderation/data/repositories/content_moderation_repository.dart';
import '../../../moderation/presentation/ui/report_content_dialog.dart';
import '../../models/report_comment_model.dart';
import '../cubit/report_comments_cubit.dart';

/// Resident ↔ office chat, separate from [TeamNotesSection]. Everyone
/// (resident, board, technician, security) can read and write here — only
/// non-internal comments (`is_internal = false`) are shown. Visually a chat
/// thread: the current viewer's own messages are right-aligned/blue,
/// everyone else's are left-aligned/grey.
class CorrespondenceSection extends StatefulWidget {
  const CorrespondenceSection({
    super.key,
    required this.reportId,
    required this.currentUserId,
    required this.currentUserName,
    required this.currentUserRole,
  });

  final String reportId;
  final String? currentUserId;
  final String currentUserName;
  final String currentUserRole;

  @override
  State<CorrespondenceSection> createState() => _CorrespondenceSectionState();
}

class _CorrespondenceSectionState extends State<CorrespondenceSection> {
  final _controller = TextEditingController();
  Set<String> _blockedUserIds = {};

  bool get _isResident => widget.currentUserRole == 'Mieszkaniec';

  @override
  void initState() {
    super.initState();
    context.read<ReportCommentsCubit>().load(widget.reportId);
    _loadBlockedUserIds();
  }

  Future<void> _loadBlockedUserIds() async {
    final ids = await getIt<ContentModerationRepository>().getBlockedUserIds();
    if (mounted) setState(() => _blockedUserIds = ids);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    context.read<ReportCommentsCubit>().addComment(
      reportId: widget.reportId,
      authorName: widget.currentUserName,
      authorRole: widget.currentUserRole,
      comment: text,
      isInternal: false,
    );
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<ReportCommentsCubit, ReportCommentsState>(
      builder: (context, state) {
        final (
          List<ReportComment> messages,
          bool isSubmitting,
          String? errorKey,
        ) = switch (state) {
          ReportCommentsLoaded(
            :final comments,
            :final isSubmitting,
            :final errorKey,
          ) =>
            (
              comments
                  .where(
                    (c) => !c.isInternal && !_blockedUserIds.contains(c.userId),
                  )
                  .toList(),
              isSubmitting,
              errorKey,
            ),
          _ => (const <ReportComment>[], false, null),
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.correspondenceTitle,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.lightTextSecondary,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 10),
            if (state is ReportCommentsInitial ||
                state is ReportCommentsLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            else if (messages.isEmpty)
              Text(
                l10n.correspondenceEmpty,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: AppColors.lightTextSecondary,
                  fontStyle: FontStyle.italic,
                ),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 340),
                child: SingleChildScrollView(
                  child: Column(
                    children: messages
                        .map(
                          (c) => _ChatBubble(
                            comment: c,
                            isMine:
                                widget.currentUserId != null &&
                                c.userId == widget.currentUserId,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            if (errorKey != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SelectableText(
                  errorKey,
                  style: const TextStyle(fontSize: 11, color: AppColors.danger),
                ),
              ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    enabled: !isSubmitting,
                    minLines: 1,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: _isResident
                          ? l10n.correspondenceHintResident
                          : l10n.correspondenceHintStaff,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: isSubmitting ? null : _send,
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.electricIndigo,
                    foregroundColor: Colors.white,
                  ),
                  icon: isSubmitting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send, size: 18),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.comment, required this.isMine});

  final ReportComment comment;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    final time = comment.createdAt != null
        ? '${comment.createdAt!.day}.${comment.createdAt!.month} ${comment.createdAt!.hour}:${comment.createdAt!.minute.toString().padLeft(2, '0')}'
        : '';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isMine
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isMine)
            Padding(
              padding: const EdgeInsets.only(right: 6, top: 4),
              child: CircleAvatar(
                radius: 10,
                backgroundColor: AppColors.mist,
                child: Text(
                  (comment.authorName?.isNotEmpty == true
                          ? comment.authorName!.substring(0, 1)
                          : '?')
                      .toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blueprint,
                  ),
                ),
              ),
            ),
          Flexible(
            child: Column(
              crossAxisAlignment: isMine
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: isMine
                        ? AppColors.azure.withValues(alpha: 0.16)
                        : AppColors.paper,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(14),
                      topRight: const Radius.circular(14),
                      bottomLeft: Radius.circular(isMine ? 14 : 4),
                      bottomRight: Radius.circular(isMine ? 4 : 14),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isMine)
                        Text(
                          comment.authorName ?? '',
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.blueprint,
                          ),
                        ),
                      Text(
                        comment.comment,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2, left: 4, right: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        time,
                        style: const TextStyle(
                          fontFamily: 'IBMPlexMono',
                          fontSize: 9.5,
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Tooltip(
                        message: context.l10n.reportContentButton,
                        child: InkWell(
                          onTap: () => showReportContentDialog(
                            context: context,
                            contentType: ContentReportType.reportComment,
                            contentId: comment.id,
                            authorId: comment.userId,
                          ),
                          child: Icon(
                            Icons.flag_outlined,
                            size: 11,
                            color: AppColors.lightTextSecondary.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                      ),
                    ],
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
