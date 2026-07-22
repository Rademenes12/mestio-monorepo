import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/error_messages.dart';
import '../../data/repositories/content_moderation_repository.dart';
import '../cubit/report_content_cubit.dart';

/// Shows a dialog to report content for moderation.
/// Required for App Store & Google Play compliance.
Future<void> showReportContentDialog({
  required BuildContext context,
  required ContentReportType contentType,
  required String contentId,
  String? authorId,
}) async {
  await showDialog<void>(
    context: context,
    builder: (context) => BlocProvider(
      create: (_) => getIt<ReportContentCubit>(),
      child: _ReportContentDialog(
        contentType: contentType,
        contentId: contentId,
        authorId: authorId,
      ),
    ),
  );
}

class _ReportContentDialog extends StatefulWidget {
  const _ReportContentDialog({
    required this.contentType,
    required this.contentId,
    this.authorId,
  });

  final ContentReportType contentType;
  final String contentId;
  final String? authorId;

  @override
  State<_ReportContentDialog> createState() => _ReportContentDialogState();
}

class _ReportContentDialogState extends State<_ReportContentDialog> {
  ContentReportReason? _selectedReason;
  final _descriptionController = TextEditingController();
  // Inline error for the "block author" action (errors are shown inline,
  // not via SnackBar, per project convention).
  String? _blockErrorKey;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _blockAuthor(BuildContext context) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      await getIt<ContentModerationRepository>().blockUser(
        blockedUserId: widget.authorId!,
      );
      navigator.pop();
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.userBlockedSnackbar)),
      );
    } catch (e) {
      final key = e.toString().replaceFirst('Exception: ', '');
      if (mounted) setState(() => _blockErrorKey = key);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<ReportContentCubit, ReportContentState>(
      listener: (context, state) {
        state.maybeMap(
          success: (_) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.reportContentSuccessSnackbar)),
            );
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        final isLoading = state.maybeMap(
          loading: (_) => true,
          orElse: () => false,
        );

        return AlertDialog(
          title: Text(l10n.reportContentDialogTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Reason dropdown
                Text(
                  l10n.reportContentReasonLabel,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<ContentReportReason>(
                  initialValue: _selectedReason,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: [
                    DropdownMenuItem(
                      value: ContentReportReason.spam,
                      child: Text(l10n.reportContentReasonSpam),
                    ),
                    DropdownMenuItem(
                      value: ContentReportReason.harassment,
                      child: Text(l10n.reportContentReasonHarassment),
                    ),
                    DropdownMenuItem(
                      value: ContentReportReason.inappropriate,
                      child: Text(l10n.reportContentReasonInappropriate),
                    ),
                    DropdownMenuItem(
                      value: ContentReportReason.misinformation,
                      child: Text(l10n.reportContentReasonMisinformation),
                    ),
                    DropdownMenuItem(
                      value: ContentReportReason.privacyViolation,
                      child: Text(l10n.reportContentReasonPrivacy),
                    ),
                    DropdownMenuItem(
                      value: ContentReportReason.other,
                      child: Text(l10n.reportContentReasonOther),
                    ),
                  ],
                  onChanged: isLoading
                      ? null
                      : (value) {
                          setState(() {
                            _selectedReason = value;
                          });
                        },
                ),
                const SizedBox(height: 16),

                // Description field
                Text(
                  l10n.reportContentDescriptionLabel,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: l10n.reportContentDescriptionHint,
                    isDense: true,
                  ),
                  maxLines: 3,
                  enabled: !isLoading,
                ),
                const SizedBox(height: 16),

                // Error message
                state.maybeMap(
                  error: (errorState) => SelectableText(
                    messageForErrorKey(l10n, errorState.errorKey),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 14,
                    ),
                  ),
                  orElse: () => const SizedBox.shrink(),
                ),
                if (_blockErrorKey != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: SelectableText(
                      messageForErrorKey(l10n, _blockErrorKey!),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 14,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            if (widget.authorId != null)
              TextButton(
                onPressed: isLoading ? null : () => _blockAuthor(context),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                child: Text(l10n.blockUserButton),
              ),
            TextButton(
              onPressed: isLoading ? null : () => Navigator.of(context).pop(),
              child: Text(l10n.reportContentCancelButton),
            ),
            FilledButton(
              onPressed: isLoading || _selectedReason == null
                  ? null
                  : () {
                      context.read<ReportContentCubit>().submitReport(
                            contentType: widget.contentType,
                            contentId: widget.contentId,
                            reason: _selectedReason!,
                            description: _descriptionController.text.trim().isEmpty
                                ? null
                                : _descriptionController.text.trim(),
                          );
                    },
              child: isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.reportContentSubmitButton),
            ),
          ],
        );
      },
    );
  }
}
