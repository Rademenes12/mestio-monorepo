import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../profiles/data/datasources/shared_user_apps_data_source.dart';
import '../../../profiles/data/repositories/shared_user_repository.dart';

abstract class AccountBootstrapRepository {
  Future<void> bootstrapCurrentUser({required String userId});
}

@LazySingleton(as: AccountBootstrapRepository)
class AccountBootstrapRepositoryImpl implements AccountBootstrapRepository {
  AccountBootstrapRepositoryImpl(
    this._sharedUserRepository,
    this._sharedUserAppsDataSource,
  );

  final SharedUserRepository _sharedUserRepository;
  final SharedUserAppsDataSource _sharedUserAppsDataSource;

  @override
  Future<void> bootstrapCurrentUser({required String userId}) {
    // Auth has already succeeded when this runs. Keep the app responsive and
    // let the session stream surface any real setup problem if the row cannot
    // be read later.
    unawaited(_ensureSharedUser(userId));

    if (!_sharedUserAppsDataSource.isConfigured) {
      return Future<void>.value();
    }

    // shared_user_apps is auxiliary cross-app metadata. A failure here should
    // not block entering the app or upgrading a guest account.
    unawaited(
      _sharedUserAppsDataSource.upsertCurrentApp(userId: userId).catchError((
        Object error,
      ) {
        debugPrint(
          '⚠️ [AccountBootstrapRepository] register current app error '
          '(non-blocking): $error',
        );
      }),
    );

    return Future<void>.value();
  }

  Future<void> _ensureSharedUser(String userId) async {
    try {
      await _sharedUserRepository.ensureSharedUser(userId);
    } catch (error) {
      debugPrint(
        '⚠️ [AccountBootstrapRepository] shared user error '
        '(non-blocking): $error',
      );
    }
  }
}
