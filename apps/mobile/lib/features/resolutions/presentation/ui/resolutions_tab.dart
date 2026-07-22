import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/error_messages.dart';
import '../../models/resolution_model.dart';
import '../cubit/resolutions_cubit.dart';

/// "Uchwały" tab — residents vote For/Against, board/admin creates and
/// closes resolutions. Tally is hidden from a resident until they vote
/// (enforced server-side; here we only render the placeholder note).
class ResolutionsTab extends StatelessWidget {
  const ResolutionsTab({super.key, this.canManage = false});

  /// True for board/admin: shows the create button and close actions.
  final bool canManage;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<ResolutionsCubit, ResolutionsState>(
      builder: (context, state) {
        return switch (state) {
          ResolutionsInitial() ||
          ResolutionsLoading() =>
            const Center(child: CircularProgressIndicator()),
          ResolutionsError(:final errorKey) => Center(
              child: Padding(
                padding: const EdgeInsets.all(AppColors.spacingMd),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SelectableText(
                      messageForErrorKey(l10n, errorKey),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.danger),
                    ),
                    const SizedBox(height: AppColors.spacingSm),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<ResolutionsCubit>().retry(),
                      child: Text(l10n.retryButtonLabel),
                    ),
                  ],
                ),
              ),
            ),
          ResolutionsLoaded(
            :final resolutions,
            :final isSubmitting,
            :final errorKey,
          ) =>
            RefreshIndicator(
              onRefresh: () => context.read<ResolutionsCubit>().retry(),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                children: [
                  _Header(canManage: canManage, isSubmitting: isSubmitting),
                  if (errorKey != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: SelectableText(
                        messageForErrorKey(l10n, errorKey),
                        style: const TextStyle(
                          color: AppColors.danger,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  if (resolutions.isEmpty)
                    _EmptyState(text: l10n.resolutionsEmpty)
                  else
                    ...resolutions.map(
                      (r) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ResolutionCard(
                          resolution: r,
                          canManage: canManage,
                          isSubmitting: isSubmitting,
                        ),
                      ),
                    ),
                ],
              ),
            ),
        };
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.canManage, required this.isSubmitting});

  final bool canManage;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.resolutionsTitle,
                style: const TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                canManage
                    ? l10n.resolutionsSubtitleBoard
                    : l10n.resolutionsSubtitleResident,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
        if (canManage)
          IconButton.filled(
            style: IconButton.styleFrom(
              backgroundColor: AppColors.blueprint,
              foregroundColor: Colors.white,
            ),
            tooltip: l10n.newResolutionTitle,
            onPressed:
                isSubmitting ? null : () => _showCreateDialog(context),
            icon: const Icon(Icons.add),
          ),
      ],
    );
  }

  void _showCreateDialog(BuildContext context) {
    // Capture the cubit — the dialog lives in a separate navigator subtree.
    final cubit = context.read<ResolutionsCubit>();
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const _CreateResolutionDialog(),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.lightCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.mist),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _ResolutionCard extends StatelessWidget {
  const _ResolutionCard({
    required this.resolution,
    required this.canManage,
    required this.isSubmitting,
  });

  final Resolution resolution;
  final bool canManage;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final r = resolution;
    final (stateColor, stateLabel) = switch (r.status) {
      'passed' => (AppColors.mint, l10n.resolutionStatePassed),
      'rejected' => (AppColors.muted, l10n.resolutionStateRejected),
      _ => (AppColors.azure, l10n.resolutionStateOpen),
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightCard,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Pill(color: stateColor, label: stateLabel),
              if (r.deadline != null)
                Text(
                  l10n.resolutionDeadline(_formatDate(r.deadline!)),
                  style: TextStyle(
                    fontFamily: 'IBMPlexMono',
                    fontSize: 11,
                    color: r.isOpen ? const Color(0xFFB37D00) : AppColors.muted,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            r.title,
            style: const TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
              height: 1.3,
            ),
          ),
          if (r.description != null && r.description!.isNotEmpty) ...[
            const SizedBox(height: 5),
            Text(
              r.description!,
              style: const TextStyle(
                fontSize: 12.5,
                color: AppColors.lightTextSecondary,
                height: 1.5,
              ),
            ),
          ],
          if (r.isTallyVisible) _TallyBar(resolution: r),
          if (!r.isTallyVisible && r.isOpen)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                l10n.resolutionResultsHidden,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: AppColors.muted,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          if (r.isOpen && !r.hasVoted && !canManage)
            _VoteButtons(resolution: r, isSubmitting: isSubmitting),
          if (r.hasVoted) _MyVoteChip(resolution: r),
          if (canManage && r.isOpen)
            _CloseActions(resolution: r, isSubmitting: isSubmitting),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'IBMPlexMono',
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _TallyBar extends StatelessWidget {
  const _TallyBar({required this.resolution});

  final Resolution resolution;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final r = resolution;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 13),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: SizedBox(
            height: 8,
            child: r.totalVotes == 0
                ? Container(color: AppColors.mist)
                : Row(
                    children: [
                      Expanded(
                        flex: r.forPercent,
                        child: Container(color: AppColors.mint),
                      ),
                      Expanded(
                        flex: r.againstPercent,
                        child: Container(color: AppColors.danger),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 7),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.resolutionForPercent(r.forPercent),
              style: const TextStyle(
                fontFamily: 'IBMPlexMono',
                fontSize: 11,
                color: AppColors.mint,
              ),
            ),
            Text(
              l10n.resolutionVotesCount(r.totalVotes),
              style: const TextStyle(
                fontFamily: 'IBMPlexMono',
                fontSize: 11,
                color: AppColors.lightTextSecondary,
              ),
            ),
            Text(
              l10n.resolutionAgainstPercent(r.againstPercent),
              style: const TextStyle(
                fontFamily: 'IBMPlexMono',
                fontSize: 11,
                color: AppColors.danger,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _VoteButtons extends StatelessWidget {
  const _VoteButtons({required this.resolution, required this.isSubmitting});

  final Resolution resolution;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Row(
        children: [
          Expanded(
            child: _VoteButton(
              label: l10n.resolutionVoteFor,
              color: AppColors.mint,
              onPressed: isSubmitting
                  ? null
                  : () => _vote(context, 'for', l10n.resolutionVoteFor),
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: _VoteButton(
              label: l10n.resolutionVoteAgainst,
              color: AppColors.danger,
              onPressed: isSubmitting
                  ? null
                  : () =>
                      _vote(context, 'against', l10n.resolutionVoteAgainst),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _vote(
    BuildContext context,
    String choice,
    String label,
  ) async {
    final cubit = context.read<ResolutionsCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final successText = context.l10n.resolutionVoteSuccess(label);
    await cubit.vote(resolution.id, choice);
    final state = cubit.state;
    // Success SnackBar only when no error was emitted (errors show inline).
    if (state is ResolutionsLoaded && state.errorKey == null) {
      messenger.showSnackBar(SnackBar(content: Text(successText)));
    }
  }
}

class _VoteButton extends StatelessWidget {
  const _VoteButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.12),
        foregroundColor: color,
        minimumSize: const Size.fromHeight(AppColors.minTouchHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _MyVoteChip extends StatelessWidget {
  const _MyVoteChip({required this.resolution});

  final Resolution resolution;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final voteLabel = resolution.myVote == 'for'
        ? l10n.resolutionVoteFor
        : l10n.resolutionVoteAgainst;
    return Container(
      margin: const EdgeInsets.only(top: 13),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check, size: 15, color: AppColors.mint),
          const SizedBox(width: 8),
          Text(
            l10n.resolutionYourVote(voteLabel),
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _CloseActions extends StatelessWidget {
  const _CloseActions({required this.resolution, required this.isSubmitting});

  final Resolution resolution;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: isSubmitting
                  ? null
                  : () => context
                      .read<ResolutionsCubit>()
                      .closeResolution(resolution.id, passed: true),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.mint,
                side: BorderSide(
                  color: AppColors.mint.withValues(alpha: 0.5),
                ),
              ),
              child: Text(
                l10n.resolutionCloseAsPassed,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: OutlinedButton(
              onPressed: isSubmitting
                  ? null
                  : () => context
                      .read<ResolutionsCubit>()
                      .closeResolution(resolution.id, passed: false),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.muted,
                side: BorderSide(
                  color: AppColors.muted.withValues(alpha: 0.5),
                ),
              ),
              child: Text(
                l10n.resolutionCloseAsRejected,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CreateResolutionDialog extends StatefulWidget {
  const _CreateResolutionDialog();

  @override
  State<_CreateResolutionDialog> createState() =>
      _CreateResolutionDialogState();
}

class _CreateResolutionDialogState extends State<_CreateResolutionDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _deadline;
  bool _isSaving = false;
  String? _errorKey;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 14)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      // Voting stays open until the end of the chosen day.
      setState(() => _deadline =
          DateTime(picked.year, picked.month, picked.day, 23, 59));
    }
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;
    setState(() {
      _isSaving = true;
      _errorKey = null;
    });
    final cubit = context.read<ResolutionsCubit>();
    final description = _descriptionController.text.trim();
    final ok = await cubit.create(
      title: title,
      description: description.isEmpty ? null : description,
      deadline: _deadline,
    );
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.resolutionCreateSuccess)),
      );
    } else {
      setState(() {
        _isSaving = false;
        _errorKey = 'resolution_create_error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PopScope(
      canPop: !_isSaving,
      child: AlertDialog(
        title: Text(l10n.newResolutionTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                enabled: !_isSaving,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: l10n.resolutionTitleLabel,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                enabled: !_isSaving,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: l10n.resolutionDescriptionLabel,
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _isSaving ? null : _pickDeadline,
                icon: const Icon(Icons.event, size: 18),
                label: Text(
                  _deadline == null
                      ? l10n.resolutionDeadlineLabel
                      : l10n.resolutionDeadline(_formatDate(_deadline!)),
                ),
              ),
              if (_errorKey != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: SelectableText(
                    messageForErrorKey(l10n, _errorKey),
                    style: const TextStyle(
                      color: AppColors.danger,
                      fontSize: 13,
                    ),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed:
                _isSaving ? null : () => Navigator.of(context).pop(),
            child: Text(l10n.resolutionCancelButton),
          ),
          ElevatedButton(
            onPressed: _isSaving ? null : _submit,
            child: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.resolutionPublishButton),
          ),
        ],
      ),
    );
  }
}

String _formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day.$month.${date.year}';
}
