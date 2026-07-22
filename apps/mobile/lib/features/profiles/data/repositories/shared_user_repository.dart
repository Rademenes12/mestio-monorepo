import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../models/shared_user_model.dart';
import '../datasources/shared_user_data_source.dart';

abstract class SharedUserRepository {
  Stream<SharedUserModel?> watchSharedUser(String userId);

  Future<SharedUserModel?> getSharedUser(String userId);

  Future<SharedUserModel> ensureSharedUser(String userId);

  Future<void> updateFirstName({
    required String userId,
    required String firstName,
  });
}

@LazySingleton(as: SharedUserRepository)
class SharedUserRepositoryImpl implements SharedUserRepository {
  SharedUserRepositoryImpl(this._sharedUserDataSource);

  final SharedUserDataSource _sharedUserDataSource;

  @override
  Stream<SharedUserModel?> watchSharedUser(String userId) {
    return _sharedUserDataSource.watchSharedUser(userId).map(_mapSharedUser);
  }

  @override
  Future<SharedUserModel?> getSharedUser(String userId) async {
    final rawSharedUser = await _sharedUserDataSource.getSharedUser(userId);
    return _mapSharedUser(rawSharedUser);
  }

  @override
  Future<SharedUserModel> ensureSharedUser(String userId) async {
    try {
      final rawSharedUser = await _sharedUserDataSource.ensureSharedUser(
        userId,
      );
      return _mapSharedUser(rawSharedUser)!;
    } catch (error) {
      debugPrint('❌ [SharedUserRepository] ensureSharedUser error: $error');
      rethrow;
    }
  }

  @override
  Future<void> updateFirstName({
    required String userId,
    required String firstName,
  }) async {
    try {
      final currentSharedUser = await ensureSharedUser(userId);
      final updatedSharedUser = currentSharedUser.copyWith(
        firstName: firstName.trim().isEmpty ? null : firstName.trim(),
      );

      await _sharedUserDataSource.upsertSharedUser(updatedSharedUser.toJson());
    } catch (error) {
      debugPrint('❌ [SharedUserRepository] updateFirstName error: $error');
      rethrow;
    }
  }

  SharedUserModel? _mapSharedUser(Map<String, dynamic>? raw) {
    if (raw == null) return null;

    return SharedUserModel.fromJson(raw);
  }
}
