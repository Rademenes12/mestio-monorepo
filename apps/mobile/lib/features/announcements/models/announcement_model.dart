import 'package:freezed_annotation/freezed_annotation.dart';

part 'announcement_model.freezed.dart';
part 'announcement_model.g.dart';

/// Admin/Zarząd broadcast message stored in `fixflow_announcements`.
///
/// The composer picks a scope from the estate's real structure
/// (building/stairwell), which sets [scopeType]/[scopeBuildingId]/
/// [scopeStairwellId] and mirrors a human-readable copy into [targetLabel]
/// for display. Resident-side filtering by scope is not implemented yet —
/// residents' locations are still free-text on their profile, not linked to
/// building/stairwell IDs — so [targetLabel] remains the only thing shown.
@freezed
abstract class Announcement with _$Announcement {
  const Announcement._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Announcement({
    required String id,
    required String title,
    required String content,
    String? authorId,
    String? authorName,
    String? authorRole,
    /// Legacy target label (free text)
    String? targetLabel,
    String? estateId,
    DateTime? expiresAt,
    @Default(true) bool isActive,
    DateTime? createdAt,
    /// Structured scope: 'estate', 'building', 'stairwell'
    @Default('estate') String scopeType,
    String? scopeBuildingId,
    String? scopeStairwellId,
  }) = _Announcement;

  factory Announcement.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementFromJson(json);

  /// True when the announcement has an expiry that already passed.
  bool get isExpired {
    final e = expiresAt;
    return e != null && DateTime.now().isAfter(e);
  }
}
