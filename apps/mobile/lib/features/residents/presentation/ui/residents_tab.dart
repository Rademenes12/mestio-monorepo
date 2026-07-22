import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/error_messages.dart';
import '../cubit/residents_cubit.dart';

String _initials(String first, String last) {
  final f = first.trim();
  final l = last.trim();
  final a = f.isNotEmpty ? f[0] : '';
  final b = l.isNotEmpty ? l[0] : '';
  final result = (a + b).toUpperCase();
  return result.isEmpty ? '?' : result;
}

class ResidentsTab extends StatelessWidget {
  const ResidentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResidentsCubit, ResidentsState>(
      builder: (context, state) {
        return switch (state) {
          ResidentsInitial() || ResidentsLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
          ResidentsError(:final errorKey) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  SelectableText(messageForErrorKey(context.l10n, errorKey)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<ResidentsCubit>().refresh(),
                    child: Text(context.l10n.retryButtonLabel),
                  ),
                ],
              ),
            ),
          ResidentsLoaded(:final residents, :final visibleToBoard) => ListView(
              padding: const EdgeInsets.all(AppColors.spacingSm),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.l10n.navResidents,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        if (visibleToBoard)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.visibility, size: 16, color: Colors.green),
                                const SizedBox(width: 4),
                                Text(
                                  context.l10n.residentsVisibleToBoardBadge,
                                  style: const TextStyle(fontSize: 12, color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: Icon(
                            visibleToBoard ? Icons.visibility : Icons.visibility_off,
                            color: AppColors.electricIndigo,
                          ),
                          tooltip: visibleToBoard
                              ? context.l10n.residentsHideFromBoardTooltip
                              : context.l10n.residentsShareWithBoardTooltip,
                          onPressed: () {
                            context.read<ResidentsCubit>().toggleBoardVisibility();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (residents.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Center(
                        child: Text(
                          context.l10n.residentsEmptyState,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  )
                else
                  ...residents.map((resident) => Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.electricIndigo.withValues(alpha: 0.1),
                            child: Text(
                              // Safe initials: profile may have empty first/last name
                              // (RPC splits name on first space; missing surname => empty string).
                              _initials(resident.firstName, resident.lastName),
                              style: const TextStyle(
                                color: AppColors.electricIndigo,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            '${resident.firstName} ${resident.lastName}'.trim(),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Address line composed from the profile fields
                              // (building / footbridge / floor / apartment).
                              // Each segment is skipped when missing.
                              Builder(
                                builder: (_) {
                                  final parts = <String>[
                                    if (resident.building != null &&
                                        resident.building!.isNotEmpty)
                                      resident.building!,
                                    if (resident.footbridge != null &&
                                        resident.footbridge!.isNotEmpty)
                                      resident.footbridge!,
                                    if (resident.floor != null &&
                                        resident.floor!.isNotEmpty)
                                      resident.floor!,
                                    if (resident.apartmentNumber != null &&
                                        resident.apartmentNumber!.isNotEmpty)
                                      context.l10n.apartmentAbbreviationLabel(resident.apartmentNumber!),
                                  ];
                                  if (parts.isEmpty) {
                                    return const SizedBox.shrink();
                                  }
                                  return Text(
                                    parts.join(' · '),
                                    style: const TextStyle(fontSize: 12),
                                  );
                                },
                              ),
                              if (resident.phone != null)
                                Row(
                                  children: [
                                    const Icon(Icons.phone, size: 12, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(
                                      resident.phone!,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              Row(
                                children: [
                                  const Icon(Icons.email, size: 12, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    resident.email,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          isThreeLine: true,
                        ),
                      )),
              ],
            ),
        };
      },
    );
  }
}