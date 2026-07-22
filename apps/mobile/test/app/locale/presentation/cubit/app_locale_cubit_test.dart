import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mestio/app/locale/data/repositories/app_locale_repository.dart';
import 'package:mestio/app/locale/models/app_locale_option_model.dart';
import 'package:mestio/app/locale/presentation/cubit/app_locale_cubit.dart';

class _MockAppLocaleRepository extends Mock implements AppLocaleRepository {}

void main() {
  late AppLocaleRepository appLocaleRepository;
  late StreamController<AppLocaleOptionModel> localeController;

  setUp(() {
    appLocaleRepository = _MockAppLocaleRepository();
    localeController = StreamController<AppLocaleOptionModel>.broadcast();
    when(
      () => appLocaleRepository.current,
    ).thenReturn(AppLocaleOptionModel.system);
    when(
      () => appLocaleRepository.localeStream,
    ).thenAnswer((_) => localeController.stream);
  });

  tearDown(() async {
    await localeController.close();
  });

  group('AppLocaleCubit', () {
    blocTest<AppLocaleCubit, AppLocaleState>(
      'emits saving and selected option when locale is changed',
      setUp: () {
        when(
          () =>
              appLocaleRepository.setLocaleOption(AppLocaleOptionModel.polish),
        ).thenAnswer((_) async {});
      },
      build: () => AppLocaleCubit(appLocaleRepository),
      act: (cubit) => cubit.selectLocale(AppLocaleOptionModel.polish),
      expect: () => const [
        AppLocaleState(
          selectedOption: AppLocaleOptionModel.system,
          isSaving: true,
        ),
        AppLocaleState(selectedOption: AppLocaleOptionModel.polish),
      ],
    );

    blocTest<AppLocaleCubit, AppLocaleState>(
      'emits error when locale save fails',
      setUp: () {
        when(
          () =>
              appLocaleRepository.setLocaleOption(AppLocaleOptionModel.english),
        ).thenThrow(Exception('network failed'));
      },
      build: () => AppLocaleCubit(appLocaleRepository),
      act: (cubit) => cubit.selectLocale(AppLocaleOptionModel.english),
      expect: () => const [
        AppLocaleState(
          selectedOption: AppLocaleOptionModel.system,
          isSaving: true,
        ),
        AppLocaleState(
          selectedOption: AppLocaleOptionModel.system,
          errorKey: 'network_error',
        ),
      ],
    );

    blocTest<AppLocaleCubit, AppLocaleState>(
      'does not emit when selected option is selected again',
      build: () => AppLocaleCubit(appLocaleRepository),
      act: (cubit) => cubit.selectLocale(AppLocaleOptionModel.system),
      expect: () => const <AppLocaleState>[],
    );

    blocTest<AppLocaleCubit, AppLocaleState>(
      'emits repository stream changes',
      build: () => AppLocaleCubit(appLocaleRepository),
      act: (_) => localeController.add(AppLocaleOptionModel.english),
      wait: const Duration(milliseconds: 1),
      expect: () => const [
        AppLocaleState(selectedOption: AppLocaleOptionModel.english),
      ],
    );
  });
}
