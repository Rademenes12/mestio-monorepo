import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../l10n/l10n.dart';
import '../../../../../shared/error_messages.dart';
import '../../../models/building_model.dart';
import '../../cubit/reports_cubit.dart';
import '../../cubit/estate_cubit.dart';
import '../test_estate_connection.dart';
import 'estate_content.dart';

/// Manager "Osiedle" tab: provisions its own [EstateCubit] scoped to the
/// current estate and renders loading/error/loaded states.
class ManagerEstateTab extends StatelessWidget {
  const ManagerEstateTab({
    super.key,
    required this.onAddResidentialBuilding,
    required this.onAddGarageBuilding,
    required this.onEditBuilding,
    required this.onDeleteBuilding,
    required this.onAddStairwell,
    required this.onEditStairwell,
    required this.onDeleteStairwell,
  });

  final void Function(BuildContext context) onAddResidentialBuilding;
  final void Function(BuildContext context) onAddGarageBuilding;
  final void Function(BuildContext context, BuildingModel building) onEditBuilding;
  final void Function(BuildContext context, BuildingModel building) onDeleteBuilding;
  final void Function(BuildContext context, String buildingId) onAddStairwell;
  final void Function(BuildContext context, StairwellModel stairwell) onEditStairwell;
  final void Function(BuildContext context, StairwellModel stairwell) onDeleteStairwell;

  @override
  Widget build(BuildContext context) {
    final estateId = context.read<ReportsCubit>().currentEstateId;
    debugPrint('\u2139\ufe0f [Dashboard] ManagerEstateTab estateId=$estateId');

    return BlocProvider(
      create: (_) {
        final cubit = getIt<EstateCubit>();
        if (estateId != null) {
          debugPrint('\u2139\ufe0f [Dashboard] calling setEstateId($estateId)');
          cubit.setEstateId(estateId);
        } else {
          debugPrint(
            '\u26a0\ufe0f [Dashboard] estateId is null, cannot load estate structure',
          );
        }
        return cubit;
      },
      child: BlocBuilder<EstateCubit, EstateState>(
        builder: (context, state) {
          final l10n = context.l10n;
          return switch (state) {
            EstateInitial() ||
            EstateLoading() => const Center(child: CircularProgressIndicator()),
            EstateError(:final errorKey) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SelectableText(messageForErrorKey(l10n, errorKey)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<EstateCubit>().retry(),
                    child: Text(l10n.retryButtonLabel),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const TestEstateConnection(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: Text(l10n.testConnectionButton),
                  ),
                ],
              ),
            ),
            EstateLoaded(
              :final buildings,
              :final isSubmitting,
              :final errorKey,
            ) =>
              EstateContent(
                buildings: buildings,
                isSubmitting: isSubmitting,
                errorKey: errorKey,
                onAddResidentialBuilding: onAddResidentialBuilding,
                onAddGarageBuilding: onAddGarageBuilding,
                onEditBuilding: onEditBuilding,
                onDeleteBuilding: onDeleteBuilding,
                onAddStairwell: onAddStairwell,
                onEditStairwell: onEditStairwell,
                onDeleteStairwell: onDeleteStairwell,
              ),
          };
        },
      ),
    );
  }
}
