import 'package:freezed_annotation/freezed_annotation.dart';

part 'maintenance_schedule_model.freezed.dart';
part 'maintenance_schedule_model.g.dart';

/// A recurring preventive maintenance inspection (elevators, chimney sweep,
/// pest control, fire safety, oil separators…) from
/// `fixflow_maintenance_schedules`.
@freezed
abstract class MaintenanceSchedule with _$MaintenanceSchedule {
  const MaintenanceSchedule._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory MaintenanceSchedule({
    required String id,
    required String estateId,
    String? buildingId,
    required String name,
    @Default('') String description,
    required int frequencyDays,
    DateTime? lastPerformed,
    required DateTime nextDueDate,
  }) = _MaintenanceSchedule;

  factory MaintenanceSchedule.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceScheduleFromJson(json);

  bool get isOverdue => DateTime.now().isAfter(nextDueDate);
}
