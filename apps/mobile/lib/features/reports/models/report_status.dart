import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Report status enum matching PostgreSQL enum `fixflow_report_status`.
/// Database values: 'new', 'in_progress', 'closed', 'rejected'
enum ReportStatus {
  /// Nowe - just created, waiting for assignment
  newReport('new'),

  /// W realizacji - assigned and being worked on
  inProgress('in_progress'),

  /// Zamknięte - completed successfully
  closed('closed'),

  /// Odrzucone - rejected/cancelled
  rejected('rejected');

  const ReportStatus(this.dbValue);

  /// Database value (English, snake_case)
  final String dbValue;

  /// Parse from database value or legacy Polish string
  static ReportStatus fromString(String value) {
    final lower = value.toLowerCase();

    // Match by db value
    for (final status in ReportStatus.values) {
      if (status.dbValue == lower) return status;
    }

    // Legacy Polish values support
    if (lower.contains('now') || lower == 'new') {
      return ReportStatus.newReport;
    }
    if (lower.contains('trakt') ||
        lower.contains('toku') ||
        lower.contains('realizac') ||
        lower.contains('in_progress')) {
      return ReportStatus.inProgress;
    }
    if (lower.contains('zrealiz') ||
        lower.contains('zakoń') ||
        lower.contains('zamkni') ||
        lower.contains('closed')) {
      return ReportStatus.closed;
    }
    if (lower.contains('odrzuc') || lower.contains('rejected')) {
      return ReportStatus.rejected;
    }

    // Default to new
    return ReportStatus.newReport;
  }

  /// Get color for status indicator (design system tokens)
  Color get color {
    switch (this) {
      case ReportStatus.newReport:
        return AppColors.azure;
      case ReportStatus.inProgress:
        return AppColors.amber;
      case ReportStatus.closed:
        return AppColors.mint;
      case ReportStatus.rejected:
        return AppColors.muted;
    }
  }

  /// Get icon for status
  IconData get icon {
    switch (this) {
      case ReportStatus.newReport:
        return Icons.fiber_new;
      case ReportStatus.inProgress:
        return Icons.engineering;
      case ReportStatus.closed:
        return Icons.check_circle;
      case ReportStatus.rejected:
        return Icons.cancel;
    }
  }

  /// Check if this is a terminal status (no further changes expected)
  bool get isTerminal => this == ReportStatus.closed || this == ReportStatus.rejected;
}
