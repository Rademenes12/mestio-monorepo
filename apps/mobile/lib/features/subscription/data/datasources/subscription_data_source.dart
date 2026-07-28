import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

abstract class SubscriptionDataSource {
  Stream<bool> watchIsPro(String userId);

  Future<bool> getIsPro(String userId);

  Future<void> setDeveloperProOverride({
    required String userId,
    required bool isPro,
  });
}

/// Always returns Pro=true — RevenueCat has been removed and all users
/// get unlimited free access.
class FakeSubscriptionDataSource implements SubscriptionDataSource {
  final _controllers = <String, BehaviorSubject<bool>>{};

  @override
  Stream<bool> watchIsPro(String userId) {
    debugPrint(
      'ℹ️ [SubscriptionDataSource] watchIsPro subscribed userId=$userId',
    );
    return _controllerFor(userId).stream.distinct();
  }

  @override
  Future<bool> getIsPro(String userId) async {
    final isPro = _controllerFor(userId).value;
    debugPrint(
      'ℹ️ [SubscriptionDataSource] getIsPro userId=$userId isPro=$isPro',
    );
    return isPro;
  }

  @override
  Future<void> setDeveloperProOverride({
    required String userId,
    required bool isPro,
  }) async {
    debugPrint(
      'ℹ️ [SubscriptionDataSource] setDeveloperProOverride started userId=$userId isPro=$isPro',
    );
    _controllerFor(userId).add(isPro);
    debugPrint(
      '✅ [SubscriptionDataSource] setDeveloperProOverride succeeded userId=$userId isPro=$isPro',
    );
  }

  BehaviorSubject<bool> _controllerFor(String userId) {
    return _controllers.putIfAbsent(userId, () {
      for (final entry in _controllers.entries.toList()) {
        if (entry.key != userId) {
          entry.value.close();
          _controllers.remove(entry.key);
        }
      }
      debugPrint(
        'ℹ️ [SubscriptionDataSource] Creating controller userId=$userId initialIsPro=true (FREE MODE)',
      );
      return BehaviorSubject<bool>.seeded(true);
    });
  }
}
