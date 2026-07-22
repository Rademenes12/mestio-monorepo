import 'package:freezed_annotation/freezed_annotation.dart';
import 'report_status.dart';

part 'report_model.freezed.dart';
part 'report_model.g.dart';

@freezed
abstract class ReportModel with _$ReportModel {
  const ReportModel._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ReportModel({
    required String id,
    /// User-friendly display ID in format FX-####
    String? displayId,
    required String title,
    required String description,
    required String category,
    @Default('') String reporterName,
    @Default('') String reporterEmail,
    @Default('') String reporterBuilding,
    @Default('') String reporterFootbridge,
    @Default('') String reporterFloor,
    @Default('') String reporterApartment,
    /// Legacy text status field - use [resolvedStatus] for type-safe access
    @Default('Nowe') String status,
    /// New enum status from database (status_enum column)
    String? statusEnum,
    required int timestamp,
    required String estateId,
    String? photoPath,
    double? latitude,
    double? longitude,
    /// Additional info for management (e.g., "police will arrive")
    String? additionalInfo,
    String? assignedTo,
    String? assignedToUserId,
    String? assignedToName,
    String? assignedToRole,
    String? boardNotes,
    String? techNotes,
    String? attachmentsJson,
    @Default(false) bool revealBoardNotesToTech,
    /// Priority level: 'low', 'normal', 'high', 'critical'
    @Default('normal') String? priority,
    /// SLA deadline timestamp (ISO 8601)
    String? slaDeadline,
    /// Customer satisfaction rating 1-5 (set by resident after closure)
    int? csatRating,
    /// Audit trail JSON array of {action, user_id, timestamp, details}
    @JsonKey(name: 'audit_trail')
    List<Map<String, dynamic>>? auditTrail,
    // Client-side only flag. Excluded from JSON to avoid breaking Supabase insert
    // (no `is_synced` column on fixflow_reports) and SQLite insert (no column either).
    // Local cache persists it via an explicit `is_synced` INTEGER column, not via toJson.
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(false) bool isSynced,
  }) = _ReportModel;

  /// Get resolved status as enum - prefers statusEnum, falls back to parsing status text
  ReportStatus get resolvedStatus {
    if (statusEnum != null) {
      return ReportStatus.fromString(statusEnum!);
    }
    return ReportStatus.fromString(status);
  }

  /// Check if report is past its SLA deadline
  bool get isSlaOverdue {
    if (slaDeadline == null) return false;
    final deadline = DateTime.tryParse(slaDeadline!);
    if (deadline == null) return false;
    return DateTime.now().isAfter(deadline) && !resolvedStatus.isTerminal;
  }

  factory ReportModel.fromJson(Map<String, dynamic> json) =>
      _$ReportModelFromJson(json);
}
