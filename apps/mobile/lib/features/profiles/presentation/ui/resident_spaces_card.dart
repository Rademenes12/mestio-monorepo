import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../l10n/l10n.dart';
import '../cubit/resident_spaces_cubit.dart';
import '../../data/datasources/resident_spaces_data_source.dart';

class ResidentSpacesCard extends StatefulWidget {
  const ResidentSpacesCard({required this.userId, required this.estateId, super.key});

  final String userId;
  final String estateId;

  @override
  State<ResidentSpacesCard> createState() => _ResidentSpacesCardState();
}

class _ResidentSpacesCardState extends State<ResidentSpacesCard> {
  late final ResidentSpacesCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ResidentSpacesCubit(getIt<ResidentSpacesDataSource>());
    _cubit.loadSpaces(userId: widget.userId, estateId: widget.estateId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  List<DropdownMenuItem<String>> _typeItems(AppLocalizations l10n) => [
        DropdownMenuItem(value: 'storage', child: Text(l10n.residentSpacesTypeStorage)),
        DropdownMenuItem(value: 'basement', child: Text(l10n.residentSpacesTypeBasement)),
        DropdownMenuItem(value: 'parking', child: Text(l10n.residentSpacesTypeParking)),
        DropdownMenuItem(value: 'garage', child: Text(l10n.residentSpacesTypeGarage)),
        DropdownMenuItem(value: 'other', child: Text(l10n.residentSpacesTypeOther)),
      ];

  IconData _icon(String type) {
    return switch (type) {
      'storage' => Icons.inventory_2_outlined,
      'basement' => Icons.domain_outlined,
      'parking' => Icons.local_parking,
      'garage' => Icons.garage,
      _ => Icons.place_outlined,
    };
  }

  String _typeLabel(String type) {
    final l10n = context.l10n;
    return switch (type) {
      'storage' => l10n.residentSpacesTypeStorage,
      'basement' => l10n.residentSpacesTypeBasement,
      'parking' => l10n.residentSpacesTypeParking,
      'garage' => l10n.residentSpacesTypeGarage,
      _ => l10n.residentSpacesTypeOther,
    };
  }

  void _confirmDelete(String spaceId) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(l10n.residentSpacesDeleteConfirmTitle),
          content: Text(l10n.residentSpacesDeleteConfirmMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancelButton),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
              onPressed: () {
                _cubit.deleteSpace(spaceId);
                Navigator.pop(ctx);
              },
              child: Text(l10n.residentSpacesDelete),
            ),
          ],
        );
      },
    );
  }

  void _showAddDialog() {
    final l10n = context.l10n;
    String selectedType = 'storage';
    final labelController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              title: Text(l10n.residentSpacesAddButton),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: selectedType,
                    decoration: InputDecoration(labelText: l10n.residentSpacesTypeLabel),
                    items: _typeItems(l10n),
                    onChanged: (v) {
                      if (v != null) setDialogState(() => selectedType = v);
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: labelController,
                    decoration: InputDecoration(
                      labelText: l10n.residentSpacesNameLabel,
                      hintText: l10n.residentSpacesNameHint,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(l10n.cancelButton),
                ),
                ElevatedButton(
                  onPressed: () {
                    final label = labelController.text.trim();
                    if (label.isEmpty) return;
                    _cubit.addSpace(
                      userId: widget.userId,
                      estateId: widget.estateId,
                      type: selectedType,
                      label: label,
                    );
                    Navigator.pop(ctx);
                  },
                  child: Text(l10n.residentSpacesSave),
                ),
              ],
            );
          },
        );
      },
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
            Text(
              l10n.residentSpacesTitle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 12),
            BlocBuilder<ResidentSpacesCubit, ResidentSpacesState>(
              bloc: _cubit,
              builder: (context, state) {
                return switch (state) {
                  Initial() || Loading() => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    ),
                  Loaded(spaces: final spaces) => spaces.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            children: [
                              Text(
                                l10n.residentSpacesEmpty,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: AppColors.lightTextSecondary,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _OutlinedAddButton(onTap: _showAddDialog),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            for (final s in spaces)
                              ListTile(
                                leading: Icon(_icon(s.type), color: AppColors.azure, size: 22),
                                title: Text(s.label, style: const TextStyle(fontSize: 14)),
                                subtitle: Text(_typeLabel(s.type), style: const TextStyle(fontSize: 12)),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.lightTextSecondary),
                                  onPressed: () => _confirmDelete(s.id),
                                ),
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: _OutlinedAddButton(onTap: _showAddDialog),
                            ),
                          ],
                        ),
                  Error() => const SizedBox.shrink(),
                };
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _OutlinedAddButton extends StatelessWidget {
  const _OutlinedAddButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.add, size: 18),
      label: Text(context.l10n.residentSpacesAddButton),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.azure,
        side: const BorderSide(color: AppColors.azure),
      ),
    );
  }
}
