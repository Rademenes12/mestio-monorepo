import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/feedback/feedback_data_source.dart';
import '../../../../../l10n/l10n.dart';
import '../../../../../app/session/presentation/cubit/session_cubit.dart';
import '../../../../profiles/models/resident_profile_model.dart';

class FeedbackSheet extends StatefulWidget {
  final ResidentProfileModel? profile;

  const FeedbackSheet({super.key, required this.profile});

  @override
  State<FeedbackSheet> createState() => FeedbackSheetState();
}

class FeedbackSheetState extends State<FeedbackSheet> {
  final _controller = TextEditingController();
  // 'blad' | 'pomysl' | 'pytanie'
  String _type = 'pomysl';
  bool _isSending = false;
  bool _hasError = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _typeLabel(String type, AppLocalizations l10n) {
    return switch (type) {
      'blad' => l10n.feedbackTypeBug,
      'pytanie' => l10n.feedbackTypeQuestion,
      _ => l10n.feedbackTypeIdea,
    };
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final l10n = context.l10n;
    setState(() {
      _isSending = true;
      _hasError = false;
    });
    final messenger = ScaffoldMessenger.of(context);
    final successMsg = l10n.feedbackSentSnackbar;
    try {
      final userId = context.read<SessionCubit>().state.userIdOrNull ?? '';
      await getIt<FeedbackDataSource>().submitFeedback(
        userId: userId,
        type: _type,
        message: text,
        userRole: widget.profile?.role,
        userEmail: widget.profile?.email,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      messenger.showSnackBar(SnackBar(content: Text(successMsg)));
    } catch (e) {
      debugPrint('\u274c [FeedbackSheet] submit failed: $e');
      if (mounted) {
        setState(() {
          _isSending = false;
          _hasError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.lightCanvas,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: AppColors.lightBorder,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                Text(
                  l10n.feedbackSheetTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.feedbackSheetSubtitle,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  children: ['blad', 'pomysl', 'pytanie'].map((type) {
                    final selected = _type == type;
                    return ChoiceChip(
                      label: Text(_typeLabel(type, l10n)),
                      selected: selected,
                      onSelected: _isSending
                          ? null
                          : (_) => setState(() => _type = type),
                      selectedColor: AppColors.electricIndigo,
                      labelStyle: TextStyle(
                        color: selected
                            ? Colors.white
                            : AppColors.lightTextPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _controller,
                  enabled: !_isSending,
                  maxLines: 4,
                  minLines: 3,
                  decoration: InputDecoration(
                    hintText: l10n.feedbackMessageHint,
                    border: const OutlineInputBorder(),
                  ),
                ),
                if (_hasError) ...[
                  const SizedBox(height: 10),
                  SelectableText(
                    l10n.feedbackSendError,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.danger,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSending ? null : _send,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.electricIndigo,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(
                        AppColors.minTouchHeight,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isSending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(l10n.feedbackSendButton),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
