import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../models/shared_user_app_model.dart';
import '../datasources/shared_user_apps_data_source.dart';

abstract class SharedUserAppsRepository {
  Future<List<SharedUserAppModel>> getOtherApps();
}

@LazySingleton(as: SharedUserAppsRepository)
class SharedUserAppsRepositoryImpl implements SharedUserAppsRepository {
  SharedUserAppsRepositoryImpl(this._dataSource);

  final SharedUserAppsDataSource _dataSource;

  @override
  Future<List<SharedUserAppModel>> getOtherApps() async {
    try {
      final rawApps = await _dataSource.getOtherApps();
      return rawApps.map(SharedUserAppModel.fromJson).toList();
    } catch (error) {
      debugPrint('❌ [SharedUserAppsRepository] getOtherApps error: $error');
      rethrow;
    }
  }
}
