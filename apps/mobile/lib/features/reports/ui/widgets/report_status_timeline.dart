import 'package:flutter/material.dart';

import '../../../../l10n/l10n.dart';
import '../../models/report_status.dart';
import '../../../../core/theme/app_colors.dart';

/// Timeline widget showing report status progression.
/// 
/// Signature UI component: horizontal stepper with 3 steps:
/// Nowe → W realizacji → Zamknięte
class ReportStatusTimeline extends StatelessWidget {
  final ReportStatus currentStatus;

  const ReportStatusTimeline({
    super.key,
    required this.currentStatus,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final steps = [
      _TimelineStep(
        status: ReportStatus.newReport,
        label: l10n.statusNowe,
        isActive: currentStatus == ReportStatus.newReport,
        isCompleted: _isCompletedStep(ReportStatus.newReport),
      ),
      _TimelineStep(
        status: ReportStatus.inProgress,
        label: l10n.statusWRealizacji,
        isActive: currentStatus == ReportStatus.inProgress,
        isCompleted: _isCompletedStep(ReportStatus.inProgress),
      ),
      _TimelineStep(
        status: ReportStatus.closed,
        label: l10n.statusZamkniete,
        isActive: currentStatus == ReportStatus.closed,
        isCompleted: _isCompletedStep(ReportStatus.closed),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAF0F7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          for (int i = 0; i < steps.length; i++) ...[
            Expanded(
              child: _StepIndicator(
                step: steps[i],
              ),
            ),
            if (i < steps.length - 1)
              _Connector(
                isCompleted: steps[i].isCompleted,
              ),
          ],
        ],
      ),
    );
  }

  bool _isCompletedStep(ReportStatus step) {
    // Rejected status shows all steps as incomplete
    if (currentStatus == ReportStatus.rejected) return false;

    final statusIndex = _getStatusIndex(currentStatus);
    final stepIndex = _getStatusIndex(step);
    return statusIndex > stepIndex;
  }

  int _getStatusIndex(ReportStatus status) {
    switch (status) {
      case ReportStatus.newReport:
        return 0;
      case ReportStatus.inProgress:
        return 1;
      case ReportStatus.closed:
        return 2;
      case ReportStatus.rejected:
        return -1; // Terminal, not in progression
    }
  }
}

class _TimelineStep {
  final ReportStatus status;
  final String label;
  final bool isActive;
  final bool isCompleted;

  _TimelineStep({
    required this.status,
    required this.label,
    required this.isActive,
    required this.isCompleted,
  });
}

class _StepIndicator extends StatelessWidget {
  final _TimelineStep step;

  const _StepIndicator({
    required this.step,
  });

  @override
  Widget build(BuildContext context) {
    final color = step.status.color;
    final isActiveOrCompleted = step.isActive || step.isCompleted;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActiveOrCompleted ? color : Colors.transparent,
            border: Border.all(
              color: isActiveOrCompleted ? color : AppColors.muted,
              width: 2,
            ),
            boxShadow: step.isActive
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: step.isCompleted
              ? Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 18,
                )
              : step.isActive
                  ? Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    )
                  : null,
        ),
        const SizedBox(height: 8),
        Text(
          step.label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: step.isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActiveOrCompleted ? color : AppColors.muted,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _Connector extends StatelessWidget {
  final bool isCompleted;

  const _Connector({
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      width: 24,
      margin: const EdgeInsets.only(bottom: 32),
      decoration: BoxDecoration(
        color: isCompleted ? AppColors.azure : AppColors.muted.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}
