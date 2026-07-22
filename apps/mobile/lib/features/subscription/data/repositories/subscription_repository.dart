import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../datasources/subscription_data_source.dart';

abstract class SubscriptionRepository {
  Stream<bool> watchIsPro(String userId);

  Future<bool> getIsPro(String userId);

  Future<void> setDeveloperProOverride({
    required String userId,
    required bool isPro,
  });
}

@LazySingleton(as: SubscriptionRepository)
class SubscriptionRepositoryImpl implements SubscriptionRepository {
  SubscriptionRepositoryImpl(this._subscriptionDataSource);

  final SubscriptionDataSource _subscriptionDataSource;

  @override
  Stream<bool> watchIsPro(String userId) {
    return _subscriptionDataSource.watchIsPro(userId);
  }

  @override
  Future<bool> getIsPro(String userId) async {
    return _subscriptionDataSource.getIsPro(userId);
  }

  @override
  Future<void> setDeveloperProOverride({
    required String userId,
    required bool isPro,
  }) async {
    try {
      await _subscriptionDataSource.setDeveloperProOverride(
        userId: userId,
        isPro: isPro,
      );
    } catch (error) {
      debugPrint(
        '❌ [SubscriptionRepository] setDeveloperProOverride error: $error',
      );
      rethrow;
    }
  }
}
