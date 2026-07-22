import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/app_locale_option_model.dart';
import '../datasources/app_locale_data_source.dart';

abstract class AppLocaleRepository {
  Stream<AppLocaleOptionModel> get localeStream;

  AppLocaleOptionModel get current;

  Future<void> setLocaleOption(AppLocaleOptionModel option);
}

@LazySingleton(as: AppLocaleRepository)
class AppLocaleRepositoryImpl implements AppLocaleRepository {
  AppLocaleRepositoryImpl(this._dataSource)
    : _controller = BehaviorSubject<AppLocaleOptionModel>.seeded(
        AppLocaleOptionModel.fromStorageValue(_dataSource.readSelectedLocale()),
      );

  final AppLocaleDataSource _dataSource;
  final BehaviorSubject<AppLocaleOptionModel> _controller;

  @override
  Stream<AppLocaleOptionModel> get localeStream =>
      _controller.stream.distinct();

  @override
  AppLocaleOptionModel get current => _controller.value;

  @override
  Future<void> setLocaleOption(AppLocaleOptionModel option) async {
    if (option == current) return;

    try {
      await _dataSource.saveSelectedLocale(option.storageValue);
      _controller.add(option);
    } catch (error) {
      debugPrint('❌ [AppLocaleRepository] setLocaleOption error: $error');
      rethrow;
    }
  }
}
