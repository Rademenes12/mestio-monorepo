import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../l10n/l10n.dart';
import '../../../models/building_model.dart';
import '../../cubit/reports_cubit.dart';
import '../../../../maintenance/presentation/ui/maintenance_section.dart';

String estateErrorMessage(AppLocalizations l10n, String errorKey) {
  return switch (errorKey) {
    'building_add_rls_error' => l10n.buildingAddRlsError,
    'building_update_error' => l10n.buildingUpdateError,
    'building_delete_error' => l10n.buildingDeleteError,
    'stairwell_add_rls_error' => l10n.stairwellAddRlsError,
    'stairwell_add_error' => l10n.stairwellAddError,
    'stairwell_update_error' => l10n.stairwellUpdateError,
    'stairwell_delete_error' => l10n.stairwellDeleteError,
    'network_error' => l10n.buildingAddNetworkError,
    'building_add_error' => l10n.buildingAddError,
    _ => l10n.errorWithKey(errorKey),
  };
}

/// Estate structure tab content: buildings/stairwells list, add-building
/// menu, offline/error banners, and the maintenance schedule section.
class EstateContent extends StatelessWidget {
  const EstateContent({
    super.key,
    required this.buildings,
    required this.isSubmitting,
    required this.errorKey,
    required this.onAddResidentialBuilding,
    required this.onAddGarageBuilding,
    required this.onEditBuilding,
    required this.onDeleteBuilding,
    required this.onAddStairwell,
    required this.onEditStairwell,
    required this.onDeleteStairwell,
  });

  final List<BuildingWithStairwells> buildings;
  final bool isSubmitting;
  final String? errorKey;
  final void Function(BuildContext context) onAddResidentialBuilding;
  final void Function(BuildContext context) onAddGarageBuilding;
  final void Function(BuildContext context, BuildingModel building) onEditBuilding;
  final void Function(BuildContext context, BuildingModel building) onDeleteBuilding;
  final void Function(BuildContext context, String buildingId) onAddStairwell;
  final void Function(BuildContext context, StairwellModel stairwell) onEditStairwell;
  final void Function(BuildContext context, StairwellModel stairwell) onDeleteStairwell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.all(AppColors.spacingSm),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.estateStructureTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.add_circle_outline, color: AppColors.azure),
                  tooltip: l10n.addBuildingTooltip,
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'residential',
                      child: Row(
                        children: [
                          const Icon(Icons.apartment, size: 20),
                          const SizedBox(width: 8),
                          Text(l10n.addBuildingDialogTitle),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'garage',
                      child: Row(
                        children: [
                          const Icon(Icons.local_parking, size: 20),
                          const SizedBox(width: 8),
                          Text(l10n.addGarageMenuLabel),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (type) {
                    if (type == 'garage') {
                      onAddGarageBuilding(context);
                    } else {
                      onAddResidentialBuilding(context);
                    }
                  },
                ),
              ],
            ),
            if (errorKey == 'using_local_data')
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Colors.orange,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.offlineModeBanner,
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else if (errorKey != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SelectableText(
                  estateErrorMessage(l10n, errorKey!),
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 12),
            if (buildings.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text(
                    l10n.noBuildingsMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.lightTextSecondary),
                  ),
                ),
              )
            else
              ...buildings.map((b) => BuildingCard(
                    data: b,
                    onEditBuilding: onEditBuilding,
                    onDeleteBuilding: onDeleteBuilding,
                    onAddStairwell: onAddStairwell,
                    onEditStairwell: onEditStairwell,
                    onDeleteStairwell: onDeleteStairwell,
                  )),
            if (context.read<ReportsCubit>().currentEstateId != null)
              MaintenanceSection(
                estateId: context.read<ReportsCubit>().currentEstateId!,
              ),
          ],
        ),
        if (isSubmitting)
          Container(
            color: Colors.black26,
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}

/// A building card (with its stairwells) inside the estate structure tab.
class BuildingCard extends StatelessWidget {
  const BuildingCard({
    super.key,
    required this.data,
    required this.onEditBuilding,
    required this.onDeleteBuilding,
    required this.onAddStairwell,
    required this.onEditStairwell,
    required this.onDeleteStairwell,
  });

  final BuildingWithStairwells data;
  final void Function(BuildContext context, BuildingModel building) onEditBuilding;
  final void Function(BuildContext context, BuildingModel building) onDeleteBuilding;
  final void Function(BuildContext context, String buildingId) onAddStairwell;
  final void Function(BuildContext context, StairwellModel stairwell) onEditStairwell;
  final void Function(BuildContext context, StairwellModel stairwell) onDeleteStairwell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isGarage = data.building.isGarage;
    return Card(
      color: AppColors.lightCard,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusCard),
        side: const BorderSide(color: AppColors.lightBorder),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(
            isGarage ? Icons.local_parking : Icons.apartment,
            color: isGarage ? AppColors.amber : AppColors.electricIndigo,
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  data.building.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              if (isGarage)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.amber.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    l10n.garageBadgeLabel,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: AppColors.amber,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
            ],
          ),
          subtitle: data.building.address != null
              ? Text(
                  data.building.address!,
                  style: const TextStyle(fontSize: 12),
                )
              : null,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: () => onEditBuilding(context, data.building),
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                onPressed: () => onDeleteBuilding(context, data.building),
              ),
              const Icon(Icons.expand_more),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.stairwellsSectionLabel,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.add, size: 18),
                        label: Text(l10n.addStairwellButton),
                        onPressed: () =>
                            onAddStairwell(context, data.building.id),
                      ),
                    ],
                  ),
                  if (data.stairwells.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        l10n.noStairwellsMessage,
                        style: const TextStyle(
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                    )
                  else
                    ...data.stairwells.map(
                      (s) => StairwellTile(
                            stairwell: s,
                            onEdit: onEditStairwell,
                            onDelete: onDeleteStairwell,
                          ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A single stairwell row inside a building card (estate structure tab).
class StairwellTile extends StatelessWidget {
  const StairwellTile({
    super.key,
    required this.stairwell,
    required this.onEdit,
    required this.onDelete,
  });

  final StairwellModel stairwell;
  final void Function(BuildContext context, StairwellModel stairwell) onEdit;
  final void Function(BuildContext context, StairwellModel stairwell) onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightCanvas,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.stairs,
            size: 20,
            color: AppColors.lightTextSecondary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.stairwellNameValue(stairwell.name),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  l10n.stairwellFloorRange(
                    stairwell.floorMin,
                    stairwell.floorMax,
                  ),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
                if (stairwell.hasGarageFloors &&
                    stairwell.garageEntranceLabel != null)
                  Text(
                    l10n.garageEntranceValue(stairwell.garageEntranceLabel!),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.electricIndigo,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, size: 18),
            onPressed: () => onEdit(context, stairwell),
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 18, color: Colors.red),
            onPressed: () => onDelete(context, stairwell),
          ),
        ],
      ),
    );
  }
}
