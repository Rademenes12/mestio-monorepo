import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/error_messages.dart';
import '../../models/maintenance_schedule_model.dart';
import '../cubit/maintenance_cubit.dart';

/// "Konserwacja prewencyjna" section on the estate structure screen — board/
/// admin manage recurring inspections (elevators, chimney sweep, pest
/// control, fire safety, oil separators…) with a one-tap "Wykonano" button
/// that pushes the next due date forward.
class MaintenanceSection extends StatelessWidget {
  const MaintenanceSection({super.key, required this.estateId});

  final String estateId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MaintenanceCubit>(
      create: (_) => getIt<MaintenanceCubit>()..load(estateId),
      child: const _MaintenanceSectionBody(),
    );
  }
}

class _MaintenanceSectionBody extends StatelessWidget {
  const _MaintenanceSectionBody();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<MaintenanceCubit, MaintenanceState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.maintenanceSectionTitle,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.lightTextSecondary,
                    letterSpacing: 1.1,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.add_circle_outline,
                    color: AppColors.azure,
                  ),
                  tooltip: l10n.maintenanceAddTooltip,
                  onPressed: () => _showCreateDialog(context),
                ),
              ],
            ),
            switch (state) {
              MaintenanceInitial() || MaintenanceLoading() => const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              ),
              MaintenanceError(:final errorKey) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SelectableText(
                  messageForErrorKey(l10n, errorKey),
                  style: const TextStyle(color: AppColors.danger, fontSize: 13),
                ),
              ),
              MaintenanceLoaded(
                :final schedules,
                :final isSubmitting,
                :final errorKey,
              ) =>
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (errorKey != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: SelectableText(
                          messageForErrorKey(l10n, errorKey),
                          style: const TextStyle(
                            color: AppColors.danger,
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                    if (schedules.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          l10n.maintenanceEmpty,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: AppColors.lightTextSecondary,
                          ),
                        ),
                      )
                    else
                      ...schedules.map(
                        (m) => Padding(
                          padding: const EdgeInsets.only(top: 9),
                          child: _MaintenanceTile(
                            schedule: m,
                            isSubmitting: isSubmitting,
                          ),
                        ),
                      ),
                  ],
                ),
            },
          ],
        );
      },
    );
  }

  void _showCreateDialog(BuildContext context) {
    final cubit = context.read<MaintenanceCubit>();
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const _CreateMaintenanceDialog(),
      ),
    );
  }
}

/// Preset inspection frequencies matching the redesign prototype
/// (co miesiąc / co kwartał / co pół roku / co rok).
const List<int> _frequencyPresets = [30, 90, 182, 365];

String _frequencyLabel(int days, AppLocalizations l10n) {
  return switch (days) {
    30 => l10n.maintenanceFrequencyMonthly,
    90 => l10n.maintenanceFrequencyQuarterly,
    182 => l10n.maintenanceFrequencySemiAnnual,
    365 => l10n.maintenanceFrequencyAnnual,
    _ => l10n.maintenanceFrequencyDays(days),
  };
}

String _formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day.$month.${date.year}';
}

class _MaintenanceTile extends StatelessWidget {
  const _MaintenanceTile({required this.schedule, required this.isSubmitting});

  final MaintenanceSchedule schedule;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final m = schedule;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.lightCard,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.mint.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.autorenew, size: 17, color: AppColors.mint),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  m.name,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.maintenanceNextDue(
                    _frequencyLabel(m.frequencyDays, l10n),
                    _formatDate(m.nextDueDate),
                  ),
                  style: TextStyle(
                    fontFamily: 'IBMPlexMono',
                    fontSize: 10.5,
                    color: m.isOverdue
                        ? AppColors.danger
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: isSubmitting
                ? null
                : () => context.read<MaintenanceCubit>().markPerformed(
                    m.id,
                    m.frequencyDays,
                  ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.blueprint,
              side: const BorderSide(color: AppColors.cardBorder),
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            child: Text(
              l10n.maintenanceMarkDoneButton,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CreateMaintenanceDialog extends StatefulWidget {
  const _CreateMaintenanceDialog();

  @override
  State<_CreateMaintenanceDialog> createState() =>
      _CreateMaintenanceDialogState();
}

class _CreateMaintenanceDialogState extends State<_CreateMaintenanceDialog> {
  final _nameController = TextEditingController();
  int _frequencyDays = _frequencyPresets.first;
  DateTime? _nextDueDate;
  bool _isSaving = false;
  String? _errorKey;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 30)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 3)),
    );
    if (picked != null) setState(() => _nextDueDate = picked);
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final nextDue = _nextDueDate;
    if (name.isEmpty || nextDue == null) return;
    setState(() {
      _isSaving = true;
      _errorKey = null;
    });
    final cubit = context.read<MaintenanceCubit>();
    final ok = await cubit.create(
      name: name,
      frequencyDays: _frequencyDays,
      nextDueDate: nextDue,
    );
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _isSaving = false;
        _errorKey = 'maintenance_create_error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PopScope(
      canPop: !_isSaving,
      child: AlertDialog(
        title: Text(l10n.maintenanceNewTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                enabled: !_isSaving,
                decoration: InputDecoration(
                  labelText: l10n.maintenanceNameLabel,
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: _frequencyDays,
                decoration: InputDecoration(
                  labelText: l10n.maintenanceFrequencyLabel,
                ),
                items: _frequencyPresets
                    .map(
                      (d) => DropdownMenuItem(
                        value: d,
                        child: Text(_frequencyLabel(d, l10n)),
                      ),
                    )
                    .toList(),
                onChanged: _isSaving
                    ? null
                    : (v) {
                        if (v != null) setState(() => _frequencyDays = v);
                      },
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _isSaving ? null : _pickDate,
                icon: const Icon(Icons.event, size: 18),
                label: Text(
                  _nextDueDate == null
                      ? l10n.maintenanceNextDueDateLabel
                      : _formatDate(_nextDueDate!),
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
            onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
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
                : Text(l10n.maintenanceSaveButton),
          ),
        ],
      ),
    );
  }
}
