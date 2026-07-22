import 'package:flutter/widgets.dart';

enum AppLocaleOptionModel {
  system(storageValue: 'system', localeOrNull: null),
  english(storageValue: 'en', localeOrNull: Locale('en')),
  polish(storageValue: 'pl', localeOrNull: Locale('pl')),
  ukrainian(storageValue: 'uk', localeOrNull: Locale('uk'));


  const AppLocaleOptionModel({
    required this.storageValue,
    required this.localeOrNull,
  });

  final String storageValue;
  final Locale? localeOrNull;

  static AppLocaleOptionModel fromStorageValue(String? value) {
    return values.firstWhere(
      (option) => option.storageValue == value,
      orElse: () => AppLocaleOptionModel.system,
    );
  }
}
