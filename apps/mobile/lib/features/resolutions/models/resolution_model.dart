import 'package:freezed_annotation/freezed_annotation.dart';

part 'resolution_model.freezed.dart';
part 'resolution_model.g.dart';

/// Community resolution (uchwała) row returned by the
/// `fixflow_list_resolutions` RPC.
///
/// [votesFor]/[votesAgainst] are `null` when the tally is hidden from the
/// caller (a resident who has not voted on an open resolution yet) — the
/// server enforces this, the client only renders the placeholder note.
@freezed
abstract class Resolution with _$Resolution {
  const Resolution._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Resolution({
    required String id,
    required String title,
    String? description,
    /// 'open' | 'passed' | 'rejected'
    @Default('open') String status,
    DateTime? deadline,
    DateTime? createdAt,
    DateTime? closedAt,
    int? votesFor,
    int? votesAgainst,
    /// Caller's own vote: 'for' | 'against' | null (not voted).
    String? myVote,
  }) = _Resolution;

  factory Resolution.fromJson(Map<String, dynamic> json) =>
      _$ResolutionFromJson(json);

  bool get isOpen => status == 'open';
  bool get hasVoted => myVote != null;
  bool get isTallyVisible => votesFor != null && votesAgainst != null;

  int get totalVotes => (votesFor ?? 0) + (votesAgainst ?? 0);

  /// Percentage of "for" votes (0-100). 0 when nobody voted yet.
  int get forPercent =>
      totalVotes == 0 ? 0 : ((votesFor ?? 0) * 100 / totalVotes).round();

  int get againstPercent => totalVotes == 0 ? 0 : 100 - forPercent;
}
