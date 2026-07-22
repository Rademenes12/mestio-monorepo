import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Report priority enum matching PostgreSQL enum `fixflow_report_priority`.
/// Database values: 'low', 'normal', 'high', 'critical'
enum ReportPriority {
  low('low'),
  normal('normal'),
  high('high'),
  critical('critical');

  const ReportPriority(this.dbValue);

  /// Database value (English, snake_case)
  final String dbValue;

  /// Default SLA duration in hours per priority level.
  int get slaHours {
    switch (this) {
      case ReportPriority.low:
        return 168; // 7 days
      case ReportPriority.normal:
        return 72; // 3 days
      case ReportPriority.high:
        return 24; // 1 day
      case ReportPriority.critical:
        return 4; // 4 hours
    }
  }

  /// Parse from database value string.
  static ReportPriority fromString(String? value) {
    if (value == null) return ReportPriority.normal;
    final lower = value.toLowerCase();
    for (final priority in ReportPriority.values) {
      if (priority.dbValue == lower) return priority;
    }
    return ReportPriority.normal;
  }

  /// Color for priority badge (design system tokens).
  Color get color {
    switch (this) {
      case ReportPriority.low:
        return AppColors.muted;
      case ReportPriority.normal:
        return AppColors.azure;
      case ReportPriority.high:
        return AppColors.amber;
      case ReportPriority.critical:
        return AppColors.danger;
    }
  }

  /// Icon for priority indicator.
  IconData get icon {
    switch (this) {
      case ReportPriority.low:
        return Icons.arrow_downward;
      case ReportPriority.normal:
        return Icons.remove;
      case ReportPriority.high:
        return Icons.arrow_upward;
      case ReportPriority.critical:
        return Icons.priority_high;
    }
  }
}
