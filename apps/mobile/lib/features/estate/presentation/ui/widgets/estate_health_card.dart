import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../l10n/l10n.dart';

/// Prototype estate health index card. Shows composite score 0-100
/// calculated server-side by fixflow_estate_health_index RPC.
class EstateHealthCard extends StatelessWidget {
  final int score;
  final String label;
  final Color color;
  final int openReports;
  final int overdueReports;
  final int totalReports;

  const EstateHealthCard({
    super.key,
    required this.score,
    required this.label,
    required this.color,
    required this.openReports,
    required this.overdueReports,
    required this.totalReports,
  });

  factory EstateHealthCard.placeholder() {
    return EstateHealthCard(
      score: 0,
      label: '—',
      color: AppColors.muted,
      openReports: 0,
      overdueReports: 0,
      totalReports: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Card(
      color: AppColors.lightCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusCard),
        side: const BorderSide(color: AppColors.lightBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.favorite, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  l10n.estateHealthTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.lightTextPrimary,
                  ),
                ),
                const Spacer(),
                if (score > 0) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$score · $label',
                      style: TextStyle(
                        color: color,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            if (score > 0) ...[
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: score / 100,
                backgroundColor: AppColors.mist,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _Stat(label: l10n.estateHealthOpenReports, value: '$openReports'),
                  const SizedBox(width: 16),
                  _Stat(label: l10n.estateHealthOverdue, value: '$overdueReports'),
                  const SizedBox(width: 16),
                  _Stat(label: l10n.estateHealthTotal, value: '$totalReports'),
                ],
              ),
            ] else ...[
              const SizedBox(height: 8),
              Text(
                l10n.estateHealthNoData,
                style: const TextStyle(
                  color: AppColors.lightTextSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.lightTextPrimary,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
