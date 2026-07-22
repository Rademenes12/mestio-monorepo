import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/review_config.dart';

enum ReviewPresentationResult {
  nativeRequestSent,
  debugPlaceholderShown,
  skipped,
  unavailable,
  contextUnmounted,
  error,
}

enum ReviewStoreListingResult { opened, missingAppStoreId, error }

/// Single UI entry point for review flows.
///
/// Do not call InAppReview.instance, requestReview(), or openStoreListing()
/// directly from screens. Use this presenter so debug/release behavior and
/// policy checks stay consistent across the app.
abstract class ReviewPresenter {
  Future<ReviewPresentationResult> maybeRequestReview({
    required BuildContext context,
    required String triggerName,
    bool isUserBusy = false,
  });

  Future<void> markCriticalErrorOccurred();

  Future<ReviewStoreListingResult> openStoreListing();
}

@LazySingleton(as: ReviewPresenter)
class AppReviewPresenter implements ReviewPresenter {
  AppReviewPresenter(this._sharedPreferences)
    : _inAppReview = InAppReview.instance;

  final SharedPreferences _sharedPreferences;
  final InAppReview _inAppReview;

  static const int _minPositiveActionsBeforePrompt = 3;
  static const int _minDaysBetweenAttempts = 60;
  static const int _criticalErrorCooldownHours = 24;

  String get _positiveActionsKey =>
      '${ReviewConfig.storageKeyPrefix}positive_actions';
  String get _lastAttemptDateKey =>
      '${ReviewConfig.storageKeyPrefix}last_attempt_date';
  String get _lastCriticalErrorDateKey =>
      '${ReviewConfig.storageKeyPrefix}last_critical_error_date';

  @override
  Future<ReviewPresentationResult> maybeRequestReview({
    required BuildContext context,
    required String triggerName,
    bool isUserBusy = false,
  }) async {
    try {
      await _incrementPositiveActionCount();

      final skipReason = _reviewSkipReason(isUserBusy: isUserBusy);
      if (skipReason != null) {
        debugPrint(
          '[ReviewPresenter] Review skipped: $skipReason trigger=$triggerName',
        );
        return ReviewPresentationResult.skipped;
      }

      if (kDebugMode) {
        // Debug must exercise our own policy and UI even when the native
        // platform review API is unavailable in the current test environment.
        if (!context.mounted) return ReviewPresentationResult.contextUnmounted;
        await _recordAttempt();
        if (!context.mounted) return ReviewPresentationResult.contextUnmounted;
        await _showReviewDebugPlaceholderDialog(context);
        return ReviewPresentationResult.debugPlaceholderShown;
      }

      if (!await _inAppReview.isAvailable()) {
        debugPrint(
          '[ReviewPresenter] Native review unavailable trigger=$triggerName',
        );
        return ReviewPresentationResult.unavailable;
      }

      await _recordAttempt();
      await _inAppReview.requestReview();
      return ReviewPresentationResult.nativeRequestSent;
    } catch (error) {
      debugPrint('[ReviewPresenter] Review request failed: $error');
      return ReviewPresentationResult.error;
    }
  }

  @override
  Future<void> markCriticalErrorOccurred() async {
    await _sharedPreferences.setInt(
      _lastCriticalErrorDateKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  @override
  Future<ReviewStoreListingResult> openStoreListing() async {
    try {
      final appStoreId = ReviewConfig.appStoreId.trim();
      if (defaultTargetPlatform == TargetPlatform.iOS && appStoreId.isEmpty) {
        debugPrint('[ReviewPresenter] Missing ReviewConfig.appStoreId for iOS');
        return ReviewStoreListingResult.missingAppStoreId;
      }

      await _inAppReview.openStoreListing(
        appStoreId: defaultTargetPlatform == TargetPlatform.iOS
            ? appStoreId
            : null,
      );
      return ReviewStoreListingResult.opened;
    } catch (error) {
      debugPrint('[ReviewPresenter] Store listing open failed: $error');
      return ReviewStoreListingResult.error;
    }
  }

  Future<void> _incrementPositiveActionCount() async {
    final actions = (_sharedPreferences.getInt(_positiveActionsKey) ?? 0) + 1;
    await _sharedPreferences.setInt(_positiveActionsKey, actions);
  }

  Future<void> _recordAttempt() async {
    await _sharedPreferences.setInt(
      _lastAttemptDateKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  String? _reviewSkipReason({required bool isUserBusy}) {
    if (isUserBusy) return 'user_busy';

    final hoursSinceLastCriticalError = _hoursSince(
      _sharedPreferences.getInt(_lastCriticalErrorDateKey),
    );
    if (hoursSinceLastCriticalError != null &&
        hoursSinceLastCriticalError < _criticalErrorCooldownHours) {
      return 'recent_critical_error';
    }

    final positiveActions = _sharedPreferences.getInt(_positiveActionsKey) ?? 0;
    if (positiveActions < _minPositiveActionsBeforePrompt) {
      return 'not_enough_positive_actions';
    }

    final daysSinceLastAttempt = _daysSince(
      _sharedPreferences.getInt(_lastAttemptDateKey),
    );
    if (daysSinceLastAttempt != null &&
        daysSinceLastAttempt < _minDaysBetweenAttempts) {
      return 'cooldown';
    }

    return null;
  }

  int? _daysSince(int? millis) {
    final now = DateTime.now();
    final date = _dateFromMillis(millis);
    if (date == null) return null;
    return now.difference(date).inDays;
  }

  int? _hoursSince(int? millis) {
    final now = DateTime.now();
    final date = _dateFromMillis(millis);
    if (date == null) return null;
    return now.difference(date).inHours;
  }

  DateTime? _dateFromMillis(int? millis) {
    if (millis == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }

  Future<void> _showReviewDebugPlaceholderDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Debug: prośba o ocenę'),
        content: const Text(
          'Build produkcyjny spróbowałby teraz pokazać natywną prośbę o ocenę aplikacji.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
