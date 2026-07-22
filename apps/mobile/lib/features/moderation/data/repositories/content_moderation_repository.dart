import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../datasources/content_moderation_data_source.dart';

enum ContentReportType {
  announcement,
  reportComment,
  emergencyContact,
}

enum ContentReportReason {
  spam,
  harassment,
  inappropriate,
  misinformation,
  privacyViolation,
  other,
}

abstract class ContentModerationRepository {
  /// Report content for moderation.
  /// Returns report ID on success.
  /// Throws specific error codes for UI handling.
  Future<String> reportContent({
    required ContentReportType contentType,
    required String contentId,
    required ContentReportReason reason,
    String? description,
  });

  /// Block a user so their content is hidden from the current user.
  Future<void> blockUser({required String blockedUserId, String? reason});

  /// Returns the set of user IDs the current user has blocked.
  Future<Set<String>> getBlockedUserIds();
}

@LazySingleton(as: ContentModerationRepository)
class ContentModerationRepositoryImpl implements ContentModerationRepository {
  ContentModerationRepositoryImpl(this._dataSource);

  final ContentModerationDataSource _dataSource;

  @override
  Future<String> reportContent({
    required ContentReportType contentType,
    required String contentId,
    required ContentReportReason reason,
    String? description,
  }) async {
    try {
      debugPrint(
        'ℹ️ [ContentModerationRepository] reportContent: '
        'type=$contentType id=$contentId reason=$reason',
      );

      final reportId = await _dataSource.reportContent(
        contentType: _mapContentType(contentType),
        contentId: contentId,
        reason: _mapReason(reason),
        description: description,
      );

      debugPrint('✅ [ContentModerationRepository] reportId=$reportId');
      return reportId;
    } catch (error) {
      debugPrint('❌ [ContentModerationRepository] error: $error');

      // Map backend errors to repository error codes
      final errorString = error.toString();

      if (errorString.contains('rate_limit_exceeded')) {
        throw Exception('error_moderation_rate_limit');
      } else if (errorString.contains('already_reported')) {
        throw Exception('error_moderation_already_reported');
      } else if (errorString.contains('content_not_found')) {
        throw Exception('error_moderation_content_not_found');
      } else if (errorString.contains('unauthenticated')) {
        throw Exception('error_moderation_unauthenticated');
      }

      throw Exception('error_moderation_unknown');
    }
  }

  @override
  Future<void> blockUser({
    required String blockedUserId,
    String? reason,
  }) async {
    try {
      await _dataSource.blockUser(blockedUserId: blockedUserId, reason: reason);
    } catch (error) {
      debugPrint('❌ [ContentModerationRepository] blockUser error: $error');
      if (error.toString().contains('unauthenticated')) {
        throw Exception('error_moderation_unauthenticated');
      }
      throw Exception('error_moderation_unknown');
    }
  }

  @override
  Future<Set<String>> getBlockedUserIds() {
    return _dataSource.getBlockedUserIds();
  }

  String _mapContentType(ContentReportType type) {
    switch (type) {
      case ContentReportType.announcement:
        return 'announcement';
      case ContentReportType.reportComment:
        return 'report_comment';
      case ContentReportType.emergencyContact:
        return 'emergency_contact';
    }
  }

  String _mapReason(ContentReportReason reason) {
    switch (reason) {
      case ContentReportReason.spam:
        return 'spam';
      case ContentReportReason.harassment:
        return 'harassment';
      case ContentReportReason.inappropriate:
        return 'inappropriate';
      case ContentReportReason.misinformation:
        return 'misinformation';
      case ContentReportReason.privacyViolation:
        return 'privacy_violation';
      case ContentReportReason.other:
        return 'other';
    }
  }
}
