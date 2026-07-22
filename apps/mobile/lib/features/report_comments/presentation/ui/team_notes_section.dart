import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';
import '../../models/report_comment_model.dart';
import '../cubit/report_comments_cubit.dart';

/// Internal notes visible only to board/admin/technician — never rendered
/// for residents (the caller in `report_detail_screen.dart` only mounts
/// this for staff roles). Separate from [CorrespondenceSection]: every
/// comment posted here is `is_internal = true`, no checkbox needed.
class TeamNotesSection extends StatefulWidget {
  const TeamNotesSection({
    super.key,
    required this.reportId,
    required this.authorName,
    required this.authorRole,
  });

  final String reportId;
  final String authorName;
  final String authorRole;

  @override
  State<TeamNotesSection> createState() => _TeamNotesSectionState();
}

class _TeamNotesSectionState extends State<TeamNotesSection> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Cubit is shared with CorrespondenceSection (provided once by
    // ReportDetailScreen) — load() is idempotent for the same reportId.
    context.read<ReportCommentsCubit>().load(widget.reportId);
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
      authorName: widget.authorName,
      authorRole: widget.authorRole,
      comment: text,
      isInternal: true,
    );
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F1EA),
        border: Border.all(color: const Color(0xFFE4DCC8)),
        borderRadius: BorderRadius.circular(AppColors.radiusCard),
      ),
      child: BlocBuilder<ReportCommentsCubit, ReportCommentsState>(
        builder: (context, state) {
          final (
            List<ReportComment> notes,
            bool isSubmitting,
          ) = switch (state) {
            ReportCommentsLoaded(:final comments, :final isSubmitting) => (
              comments.where((c) => c.isInternal).toList(),
              isSubmitting,
            ),
            _ => (const <ReportComment>[], false),
          };

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    l10n.teamNotesTitle,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF8A6A2E),
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8A6A2E).withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      l10n.teamNotesHiddenBadge,
                      style: const TextStyle(
                        fontSize: 9,
                        color: Color(0xFF8A6A2E),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 11),
              if (notes.isEmpty)
                Text(
                  l10n.teamNotesEmpty,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF8A6A2E),
                  ),
                )
              else
                ...notes.map(
                  (c) => Padding(
                    padding: const EdgeInsets.only(bottom: 9),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors.cardBorder),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                c.authorName ?? '',
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if (c.authorRole?.isNotEmpty == true) ...[
                                const SizedBox(width: 5),
                                Text(
                                  c.authorRole!,
                                  style: const TextStyle(
                                    fontFamily: 'IBMPlexMono',
                                    fontSize: 9.5,
                                    color: AppColors.lightTextSecondary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            c.comment,
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: AppColors.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled: !isSubmitting,
                      minLines: 1,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: l10n.teamNotesInputHint,
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: const BorderSide(
                            color: AppColors.cardBorder,
                          ),
                        ),
                      ),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: isSubmitting ? null : _send,
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.blueprint,
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
      ),
    );
  }
}
