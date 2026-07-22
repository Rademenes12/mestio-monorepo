import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/error_messages.dart';
import '../../data/repositories/app_locale_repository.dart';
import '../../models/app_locale_option_model.dart';

part 'app_locale_cubit.freezed.dart';

@freezed
abstract class AppLocaleState with _$AppLocaleState {
  const AppLocaleState._();

  const factory AppLocaleState({
    required AppLocaleOptionModel selectedOption,
    @Default(false) bool isSaving,
    String? errorKey,
  }) = _AppLocaleState;

  Locale? get localeOrNull => selectedOption.localeOrNull;
}

@LazySingleton()
class AppLocaleCubit extends Cubit<AppLocaleState> {
  AppLocaleCubit(this._appLocaleRepository)
    : super(AppLocaleState(selectedOption: _appLocaleRepository.current)) {
    _subscription = _appLocaleRepository.localeStream.listen(
      _onLocaleChanged,
      onError: (Object error, StackTrace stackTrace) {
        debugPrint('❌ [AppLocaleCubit] Stream error: $error');
        emit(state.copyWith(isSaving: false, errorKey: mapErrorToKey(error)));
      },
    );
  }

  final AppLocaleRepository _appLocaleRepository;
  StreamSubscription<AppLocaleOptionModel>? _subscription;

  Future<void> selectLocale(AppLocaleOptionModel option) async {
    if (state.isSaving || option == state.selectedOption) return;

    emit(state.copyWith(isSaving: true, errorKey: null));

    try {
      await _appLocaleRepository.setLocaleOption(option);
      if (state.isSaving) {
        emit(
          state.copyWith(
            selectedOption: option,
            isSaving: false,
            errorKey: null,
          ),
        );
      }
    } catch (error) {
      debugPrint('❌ [AppLocaleCubit] selectLocale error: $error');
      emit(state.copyWith(isSaving: false, errorKey: mapErrorToKey(error)));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  void _onLocaleChanged(AppLocaleOptionModel option) {
    if (option == state.selectedOption) {
      return;
    }

    emit(
      state.copyWith(selectedOption: option, isSaving: false, errorKey: null),
    );
  }
}
