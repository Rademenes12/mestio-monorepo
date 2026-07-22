import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_comment_model.freezed.dart';
part 'report_comment_model.g.dart';

@freezed
abstract class ReportComment with _$ReportComment {
  const ReportComment._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ReportComment({
    required String id,
    required String reportId,
    String? userId,
    String? authorName,
    String? authorRole,
    required String comment,
    @Default(false) bool isInternal,
    DateTime? createdAt,
  }) = _ReportComment;

  factory ReportComment.fromJson(Map<String, dynamic> json) =>
      _$ReportCommentFromJson(json);
}
