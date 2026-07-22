// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get localizationBootstrap => 'Локалізація додатку налаштована.';

  @override
  String get errorInvalidCredentials => 'Невірний email або пароль.';

  @override
  String get errorEmailNotConfirmed =>
      'Будь ласка, підтвердіть email, натиснувши на посилання у скриньці.';

  @override
  String get errorAnonymousAuthDisabled => 'Вхід як гість наразі вимкнено.';

  @override
  String get errorEmailAlreadyRegistered =>
      'Ця email адреса вже зареєстрована. Увійдіть.';

  @override
  String get errorEmail => 'Перевірте адресу email і спробуйте ще раз.';

  @override
  String get errorPassword => 'Перевірте пароль і спробуйте ще раз.';

  @override
  String get errorPasswordResetCodeRequired => 'Введіть код скидання з листа.';

  @override
  String get errorPasswordResetCodeInvalid =>
      'Код скидання недійсний. Перевірте його і спробуйте ще раз.';

  @override
  String get errorPasswordResetCodeExpired =>
      'Код скидання застарів. Запросіть новий і спробуйте ще раз.';

  @override
  String get errorPasswordTooShort =>
      'Використовуйте пароль довжиною не менше 6 символів.';

  @override
  String get errorPasswordsDoNotMatch => 'Паролі не збігаються.';

  @override
  String get errorNetwork => 'Проблема з підключенням. Спробуйте ще раз.';

  @override
  String get errorPurchase => 'Не вдалося завершити покупку. Спробуйте ще раз.';

  @override
  String get errorDeleteAccountSetupRequired =>
      'Видалення акаунту потребує додаткового налаштування Supabase.';

  @override
  String get errorDeleteAccountFailed =>
      'Не вдалося видалити акаунт. Спробуйте ще раз.';

  @override
  String get errorSharedUsersSetupRequired =>
      'Таблиця shared_users відсутня або її схема не відповідає шаблону.';

  @override
  String get errorDeleteAccountNotImplemented =>
      'Видалення акаунту ще не готове.';

  @override
  String get errorNoEstate =>
      'Спочатку потрібно приєднатися до житлового комплексу.';

  @override
  String get errorCodeNotFoundOrExpired =>
      'Недійсний або прострочений код запрошення.';

  @override
  String get errorInvalidCodeFormat => 'Невірний формат коду (XXXX-XXXX-XXXX).';

  @override
  String get errorRateLimitExceeded =>
      'Забагато спроб. Спробуйте ще раз через 15 хвилин.';

  @override
  String get errorEstateInactive => 'Цей житловий комплекс наразі неактивний.';

  @override
  String get errorRoleLimitReached =>
      'Досягнуто ліміту користувачів для цієї ролі.';

  @override
  String get errorApartmentLimitReached =>
      'Під одним помешканням може бути зареєстровано максимум 4 особи.';

  @override
  String get errorUnknown => 'Сталася несподівана помилка.';

  @override
  String errorWithKey(Object errorKey) {
    return 'Сталася помилка: $errorKey';
  }

  @override
  String get guestDisplayName => 'Гість';

  @override
  String get registeredUserDisplayName => 'Користувач';

  @override
  String get loadingLabel => 'Завантаження...';

  @override
  String get sessionErrorTitle => 'Помилка сесії';

  @override
  String get accountTypeGuest => 'гість';

  @override
  String get accountTypeRegistered => 'авторизований';

  @override
  String get commonYes => 'так';

  @override
  String get commonNo => 'ні';

  @override
  String get limitAccessGuest => 'гість';

  @override
  String get limitAccessRegistered => 'зареєстрований';

  @override
  String get limitAccessPro => 'Pro';

  @override
  String get homeTitle => 'Головна';

  @override
  String get currentSessionTitle => 'Поточна сесія';

  @override
  String sessionUserId(Object value) {
    return 'ID користувача: $value';
  }

  @override
  String sessionAccountType(Object value) {
    return 'Тип акаунту: $value';
  }

  @override
  String sessionPro(Object value) {
    return 'Pro: $value';
  }

  @override
  String sessionEmail(Object value) {
    return 'E-mail: $value';
  }

  @override
  String sessionDisplayNameValue(Object value) {
    return 'Відображуване ім\'я: $value';
  }

  @override
  String sessionFirstName(Object value) {
    return 'Ім\'я: $value';
  }

  @override
  String get developerToolsTitle => 'Інструменти розробника';

  @override
  String get retryButtonLabel => 'Спробувати ще раз';

  @override
  String get welcomeTitle => 'Ласкаво просимо до Mestio';

  @override
  String get welcomeBody =>
      'Продовжте як гість або увійдіть до існуючого акаунту.';

  @override
  String get welcomeSubtitle => 'Управління заявками у вашій громаді';

  @override
  String get continueAsGuestButton => 'Продовжити як гість';

  @override
  String get continueAsGuestButtonLabel => 'Розпочати';

  @override
  String get loginButtonLabel => 'Увійти';

  @override
  String get loginScreenTitle => 'Вхід';

  @override
  String get loginExistingAccountTitle => 'Увійдіть до існуючого акаунту';

  @override
  String get loginExistingAccountBody =>
      'Використовуйте свою адресу email та пароль для входу.';

  @override
  String get emailFieldLabel => 'E-mail';

  @override
  String get passwordFieldLabel => 'Пароль';

  @override
  String get forgotPasswordButtonLabel => 'Забули пароль?';

  @override
  String get forgotPasswordScreenTitle => 'Скидання пароля';

  @override
  String get forgotPasswordTitle => 'Скиньте пароль';

  @override
  String get forgotPasswordBody =>
      'Введіть свою адресу email, і ми надішлемо вам код скидання.';

  @override
  String get sendResetCodeButtonLabel => 'Надіслати код';

  @override
  String get resetPasswordScreenTitle => 'Встановити новий пароль';

  @override
  String get resetPasswordTitle => 'Введіть код скидання';

  @override
  String resetPasswordBody(Object email) {
    return 'Ми надіслали код скидання на адресу $email. Введіть його нижче і встановіть новий пароль.';
  }

  @override
  String get resetCodeFieldLabel => 'Код скидання';

  @override
  String get confirmPasswordFieldLabel => 'Підтвердіть новий пароль';

  @override
  String get resetPasswordButtonLabel => 'Змінити пароль';

  @override
  String get passwordResetSuccessSnackbar => 'Пароль змінено';

  @override
  String get switchAccountWarningTitle => 'Ви переключаєте акаунт';

  @override
  String get switchAccountWarningBody =>
      'Вхід тут переключить вас з поточного гостьового акаунту на інший. Дані гостя та Pro не об\'єднуються автоматично.';

  @override
  String get registerScreenTitle => 'Реєстрація';

  @override
  String get secureGuestAccountTitle => 'Захистіть цей гостьовий акаунт';

  @override
  String get secureGuestAccountBody =>
      'Це збереже ваші поточні дані і прив\'яже цей гостьовий акаунт до адреси email та паролю.';

  @override
  String get registerButtonLabel => 'Зареєструватися';

  @override
  String get profileSavedSnackbar => 'Профіль збережено';

  @override
  String get proEnabledSnackbar => 'Pro активовано';

  @override
  String get profileTitle => 'Профіль';

  @override
  String get profileLanguageSectionTitle => 'Мова додатку';

  @override
  String get profileLanguageSectionDescription =>
      'Виберіть, чи додаток має використовувати мову пристрою, польську, українську або англійську.';

  @override
  String get firstNameFieldLabel => 'Ім\'я';

  @override
  String get languageOptionSystem => 'Автоматично';

  @override
  String get languageOptionSystemDescription =>
      'Використовує мову пристрою. Для непідтримуваних мов додаток повертається до англійської.';

  @override
  String get languageOptionPolish => 'Polski';

  @override
  String get languageOptionEnglish => 'English';

  @override
  String get languageOptionUkrainian => 'Українська';

  @override
  String get saveFirstNameButtonLabel => 'Зберегти ім\'я';

  @override
  String get accountSecuredSnackbar => 'Акаунт захищено';

  @override
  String get logoutButtonLabel => 'Вийти';

  @override
  String get buyProButtonLabel => 'Купити Pro';

  @override
  String get proPlaceholderTitle => 'Покупки Pro ще не підключені';

  @override
  String get proPlaceholderBodyProfile =>
      'Шаблон вже має підготовлений flow оновлення до Pro в UI, але справжній paywall RevenueCat ще потрібно підключити на етапі налаштування RevenueCat.';

  @override
  String get deleteAccountButtonLabel => 'Видалити акаунт';

  @override
  String get discardChangesTitle => 'Відхилити зміни?';

  @override
  String get discardChangesBody =>
      'У вас є незбережені зміни. Якщо ви вийдете зараз, вони будуть втрачені.';

  @override
  String get stayButtonLabel => 'Залишитися';

  @override
  String get discardButtonLabel => 'Відхилити';

  @override
  String get closeButtonLabel => 'Закрити';

  @override
  String get protectProBannerTitle => 'Захистіть доступ до Pro';

  @override
  String get protectProBannerBody =>
      'Цей гостьовий акаунт вже має Pro. Зареєструйте цей акаунт, щоб не втратити доступ у майбутньому.';

  @override
  String get developerDiagnosticsTitle => 'Діагностика лише для debug';

  @override
  String get developerDiagnosticsBody =>
      'Використовуйте цей екран для перевірки локальної конфігурації додатку та статусу інтеграції.';

  @override
  String get revenueCatDisconnectedTitle => 'RevenueCat не підключено';

  @override
  String get revenueCatDisconnectedBody =>
      'Додайте ключі RevenueCat до config/api-keys.json, коли будете готові тестувати підписки.';

  @override
  String get revenueCatDebugMissingTestStoreTitle =>
      'Відсутній ключ Test Store';

  @override
  String get revenueCatDebugMissingTestStoreBody =>
      'Debug збірки використовують ключ RevenueCat Test Store. Додайте REVENUECAT_TEST_STORE_API_KEY до config/api-keys.json і перезапустіть додаток.';

  @override
  String get sessionSectionTitle => 'Сесія';

  @override
  String get loggedInLabel => 'Авторизований';

  @override
  String loggedInAsNamedLabel(Object name) {
    return 'Авторизований: $name';
  }

  @override
  String get managerDashboardTitle => 'Панель правління';

  @override
  String get adminDashboardTitle => 'Панель адміністратора';

  @override
  String get anonymousLabel => 'Анонімний';

  @override
  String get limitAccessLabel => 'Доступ до лімітів';

  @override
  String get proLabel => 'Pro';

  @override
  String get userIdLabel => 'ID користувача';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get displayNameLabel => 'Відображуване ім\'я';

  @override
  String get supabaseSectionTitle => 'Supabase';

  @override
  String get keysConfiguredLabel => 'Ключі налаштовано';

  @override
  String get supabaseUrlLabel => 'Supabase URL';

  @override
  String get revenueCatSectionTitle => 'RevenueCat';

  @override
  String get supportedPlatformLabel => 'Підтримувана платформа';

  @override
  String get platformKeyConfiguredLabel => 'Ключ платформи налаштовано';

  @override
  String get testStoreKeyConfiguredLabel => 'Ключ Test Store налаштовано';

  @override
  String get sdkActiveLabel => 'SDK активний';

  @override
  String get activeKeyTypeLabel => 'Тип активного ключа';

  @override
  String get activeSdkKeyLabel => 'Активний ключ SDK';

  @override
  String get activeKeyTypeMissing => 'Відсутній';

  @override
  String get activeKeyTypeTestStore => 'Test Store';

  @override
  String get activeKeyTypeAppStore => 'App Store';

  @override
  String get activeKeyTypeGooglePlay => 'Google Play';

  @override
  String get proSourceLabel => 'Джерело Pro';

  @override
  String get proSourceRevenueCat => 'RevenueCat';

  @override
  String get proSourceDeveloperOverride => 'Developer override';

  @override
  String get missingValueLabel => 'відсутній';

  @override
  String get debugForceProTitle => 'Debug: примусовий статус Pro';

  @override
  String get debugForceProSubtitle =>
      'Працює лише без активного RevenueCat і лише в debug-інструменті.';

  @override
  String get storeScreenshotsSectionTitle => 'Store screenshots';

  @override
  String get storeScreenshot1ButtonLabel => 'Screenshot 1';

  @override
  String get storeScreenshot2ButtonLabel => 'Screenshot 2';

  @override
  String get storeScreenshot3ButtonLabel => 'Screenshot 3';

  @override
  String get storeScreenshot4ButtonLabel => 'Screenshot 4';

  @override
  String get storeScreenshot5ButtonLabel => 'Screenshot 5';

  @override
  String get missingSupabaseAgentPrompt =>
      'Підключіть `Supabase MCP` до мого проекту Supabase і заповніть `config/api-keys.json` значеннями `SUPABASE_URL` та `SUPABASE_ANON_KEY`.';

  @override
  String get missingSupabaseTitle => 'Відсутні ключі Supabase';

  @override
  String get missingSupabaseBody =>
      'Додайте ключі Supabase до конфігураційного файлу і перезапустіть додаток.';

  @override
  String get missingSupabaseFileLabel => 'Заповніть цей файл';

  @override
  String get missingSupabaseFilePath => 'config/api-keys.json';

  @override
  String get missingSupabaseStep1Title => 'Крок 1: встановіть `Supabase MCP`';

  @override
  String get missingSupabaseStep1Body =>
      'Спочатку додайте `Supabase MCP` до свого AI агента.';

  @override
  String get missingSupabaseStep2Title => 'Крок 2: вставте цей prompt агенту';

  @override
  String get copyPromptButtonLabel => 'Копіювати prompt';

  @override
  String get promptCopiedSnackbar => 'Prompt скопійовано';

  @override
  String get missingSupabaseStep3Title =>
      'Крок 3: закрийте і відкрийте додаток знову';

  @override
  String get missingSupabaseStep3Body =>
      'Коли агент заповнить файл з ключами, закрийте додаток і запустіть його знову.';

  @override
  String get sharedUsersAgentPrompt =>
      'Запустіть задачу `docs/tasks/02_SUPABASE_SHARED_USERS_SETUP.md` і приведіть таблицю `shared_users` до мінімальної сумісності з цим проектом, використовуючи `Supabase MCP`.';

  @override
  String get sharedUsersSetupTitle =>
      'Таблиця `shared_users` відсутня в Supabase';

  @override
  String get sharedUsersSetupBody =>
      'Додаток не може завантажити додаткові дані користувачів (наприклад, ім\'я), оскільки таблиця `shared_users` не існує або її структура не відповідає мінімальним вимогам.';

  @override
  String get sharedUsersGuideLabel => 'Скористайтеся готовою інструкцією:';

  @override
  String get sharedUsersGuideFile => '02_SUPABASE_SHARED_USERS_SETUP.md';

  @override
  String get sharedUsersAiPromptTitle => 'Вставте цей prompt AI агенту';

  @override
  String get sharedUsersAiHelpBody =>
      'Якщо ваш AI агент має доступ до Supabase MCP, він налаштує все автоматично за підготовленою інструкцією.';

  @override
  String get deleteAccountConfirmationTitle => 'Видалити акаунт';

  @override
  String get deleteAccountPermanentWarning =>
      'Ваш акаунт буде видалено назавжди разом з усіма даними. Цю дію неможливо скасувати.';

  @override
  String get deleteAccountOtherAppsWarning =>
      'Ви також втратите доступ до таких додатків:';

  @override
  String get deleteAccountAppsCheckFailed =>
      'Не вдалося перевірити, які інші додатки використовують цей акаунт. Видалення все одно видалить спільний акаунт Supabase і може вплинути на інші додатки цього розробника.';

  @override
  String get deleteAccountCheckboxLabel =>
      'Я розумію, що дані в усіх додатках буде видалено';

  @override
  String get deleteAccountCheckboxLabelSimple =>
      'Я розумію, що ця дія є незворотною';

  @override
  String get deleteAccountSuccessSnackbar => 'Акаунт видалено';

  @override
  String get deleteAccountConfirmButton => 'Видалити мій акаунт';

  @override
  String get connectivityLabel => 'Інтернет';

  @override
  String get connectivityStatusConnected => 'підключено';

  @override
  String get connectivityStatusDisconnected => 'немає підключення';

  @override
  String get connectivityStatusChecking => 'перевірка...';

  @override
  String get connectivityOfflineBanner => 'Немає підключення до інтернету';

  @override
  String get proLockFinanceTitle => 'Модуль Фінансів (PRO)';

  @override
  String get proLockFinanceDesc =>
      'Отримайте доступ до повного перегляду розрахунків орендної плати, ремонтного фонду та історії платежів.';

  @override
  String get proLockCommunicatorTitle => 'Месенджер Кооперативу (PRO)';

  @override
  String get proLockCommunicatorDesc =>
      'Спілкуйтеся безпосередньо з адміністрацією та отримуйте персоналізовані сповіщення про технічні роботи.';

  @override
  String get proLockPhoneTitle => 'Екстрені контакти (PRO)';

  @override
  String get proLockPhoneDesc =>
      'Доступ до бази контактів та прямий набір номерів адміністрації, ліфтового сервісу та технічної служби.';

  @override
  String get proLockUnlockButton => 'Розблокувати версію PRO';

  @override
  String get estateOnboardingTitle => 'Приєднайтеся до житлового комплексу';

  @override
  String get estateOnboardingSubtitle =>
      'Щоб користуватися застосунком, приєднайтеся за кодом запрошення або створіть новий комплекс як адміністратор.';

  @override
  String get estateJoinSectionTitle => 'У мене є код запрошення';

  @override
  String get estateCodeFieldLabel => 'Код запрошення';

  @override
  String get estateJoinButton => 'Приєднатися';

  @override
  String get estateCreateSectionTitle => 'Я адміністратор комплексу';

  @override
  String get estateNameFieldLabel => 'Назва комплексу';

  @override
  String get estateCreateButton => 'Створити комплекс';

  @override
  String get estateInvitationCodeTitle => 'Код запрошення комплексу';

  @override
  String get addAnotherEstateMenuLabel => '+ Додати інший комплекс';

  @override
  String get estateInvitationCodeHint =>
      'Поділіться цим кодом з мешканцями, щоб вони могли приєднатися.';

  @override
  String get estateGenerateCodeButton => 'Згенерувати код запрошення';

  @override
  String get estateCopyCodeButton => 'Копіювати код';

  @override
  String get estateCodeCopiedSnackbar => 'Код скопійовано.';

  @override
  String get estateJoinedSnackbar => 'Ви приєдналися до комплексу.';

  @override
  String get estateCreatedSnackbar => 'Комплекс створено.';

  @override
  String get estateCodeRolesSectionTitle => 'Коди запрошень за ролями';

  @override
  String get estateRegenerateCodeButton => 'Згенерувати новий';

  @override
  String get estateRegenerateCodeTitle => 'Згенерувати новий код?';

  @override
  String get estateRegenerateCodeBody =>
      'Попередній код буде деактивовано. Продовжити?';

  @override
  String get estateJoinRequestsTitle => 'Запити на приєднання';

  @override
  String get estateJoinRequestsEmpty => 'Немає запитів на розгляді';

  @override
  String get estateApproveButton => 'Схвалити';

  @override
  String get estateRejectButton => 'Відхилити';

  @override
  String get estateJoinRequestApprovedSnackbar => 'Запит схвалено';

  @override
  String get estateJoinRequestRejectedSnackbar => 'Запит відхилено';

  @override
  String get estateAutoJoinBadge => 'авто';

  @override
  String get estateApprovalRequiredBadge => 'схвалення';

  @override
  String get supportSectionTitle => 'Контакт і підтримка';

  @override
  String get supportSectionDescription =>
      'Маєте питання, пропозицію або щось не працює? Напишіть нам.';

  @override
  String get supportContactButton => 'Написати нам';

  @override
  String get supportEmailSubject => 'Mestio – відгук / проблема';

  @override
  String get legalSectionTitle => 'Правові документи';

  @override
  String get legalSectionDescription =>
      'Ознайомтеся з нашою політикою конфіденційності та умовами використання.';

  @override
  String get privacyPolicyButton => 'Політика конфіденційності';

  @override
  String get termsOfServiceButton => 'Умови використання';

  @override
  String get securityPatrolTitle => 'Обхід: Охорона';

  @override
  String get securityReportToBoardButton => '⚠️ ПОВІДОМИТИ ПРАВЛІННЯ';

  @override
  String get securityEmergencyAlarmButton => '🚨 ТРИВОГА ДЛЯ ВСІХ';

  @override
  String get securityPatrolHistoryTitle => 'ОСТАННІ ЗВІТИ ОБХОДІВ';

  @override
  String get securityPatrolHistoryEmpty => 'Сьогодні ще немає записів.';

  @override
  String get navHome => 'Головна';

  @override
  String get navReports => 'Заявки';

  @override
  String get navAddReport => 'Подати';

  @override
  String get navPhones => 'Телефони';

  @override
  String get navContacts => 'Контакти';

  @override
  String get navProfile => 'Профіль';

  @override
  String get navAnnouncements => 'Оголошення';

  @override
  String get navEstate => 'Комплекс';

  @override
  String get navResidents => 'Мешканці';

  @override
  String get navResolutions => 'Ухвали';

  @override
  String get residentsVisibleToBoardBadge => 'Видимо для правління';

  @override
  String get residentsHideFromBoardTooltip => 'Приховати від правління';

  @override
  String get residentsShareWithBoardTooltip => 'Показати правлінню';

  @override
  String get residentsEmptyState => 'Немає зареєстрованих мешканців';

  @override
  String get resolutionsTitle => 'Ухвали';

  @override
  String get resolutionsSubtitleBoard =>
      'Створюйте ухвали та рахуйте голоси мешканців';

  @override
  String get resolutionsSubtitleResident => 'Голосуйте за ухвали спільноти';

  @override
  String get resolutionsEmpty => 'Ще немає ухвал.';

  @override
  String get resolutionStateOpen => 'Голосування триває';

  @override
  String get resolutionStatePassed => 'Ухвалено';

  @override
  String get resolutionStateRejected => 'Відхилено';

  @override
  String resolutionDeadline(Object date) {
    return 'до $date';
  }

  @override
  String get resolutionVoteFor => 'За';

  @override
  String get resolutionVoteAgainst => 'Проти';

  @override
  String resolutionYourVote(Object vote) {
    return 'Ваш голос: $vote';
  }

  @override
  String get resolutionResultsHidden =>
      'Результати будуть видимі після голосування.';

  @override
  String resolutionForPercent(Object pct) {
    return 'За $pct%';
  }

  @override
  String resolutionAgainstPercent(Object pct) {
    return 'Проти $pct%';
  }

  @override
  String resolutionVotesCount(Object count) {
    return 'Голоси: $count';
  }

  @override
  String resolutionVoteSuccess(Object vote) {
    return 'Ваш голос: $vote';
  }

  @override
  String get newResolutionTitle => 'Нова ухвала';

  @override
  String get resolutionTitleLabel => 'Назва';

  @override
  String get resolutionDescriptionLabel => 'Опис';

  @override
  String get resolutionDeadlineLabel => 'Термін голосування (необовʼязково)';

  @override
  String get resolutionPublishButton => 'Опублікувати';

  @override
  String get resolutionCancelButton => 'Скасувати';

  @override
  String get resolutionCloseAsPassed => 'Завершити: ухвалено';

  @override
  String get resolutionCloseAsRejected => 'Завершити: відхилено';

  @override
  String get resolutionCreateSuccess => 'Ухвалу опубліковано';

  @override
  String get errorResolutionsLoad => 'Не вдалося завантажити ухвали.';

  @override
  String get errorResolutionVote => 'Не вдалося проголосувати.';

  @override
  String get errorResolutionCreate => 'Не вдалося опублікувати ухвалу.';

  @override
  String get errorResolutionClose => 'Не вдалося завершити ухвалу.';

  @override
  String get reportCloseRequiresMessageHint =>
      'Перш ніж закрити або відхилити заявку, напишіть повідомлення мешканцю в нотатках нижче.';

  @override
  String get reportCloseRequiresMessageWarning =>
      'Спершу напишіть повідомлення мешканцю в нотатках нижче ↓';

  @override
  String get attachmentsLabel => 'Додатки';

  @override
  String get attachmentOpenLabel => 'відкрити';

  @override
  String get attachmentOpenError => 'Не вдалося відкрити додаток.';

  @override
  String get additionalInfoLabel => 'Інше — інформація для правління';

  @override
  String get additionalInfoHint =>
      'напр. приїде поліція / пожежна служба, доступ від 8:00';

  @override
  String get markAsUrgentLabel => 'Позначити як термінове';

  @override
  String get notificationsPanelTitle => 'Сповіщення';

  @override
  String get notificationsEmpty => 'Немає сповіщень.';

  @override
  String notificationYourReport(Object id) {
    return 'Ваша заявка $id';
  }

  @override
  String notificationCurrentStatus(Object status) {
    return 'Поточний статус: $status';
  }

  @override
  String notificationUrgentPrefix(Object title) {
    return 'Термінове: $title';
  }

  @override
  String notificationReportPrefix(Object id) {
    return 'Заявка $id';
  }

  @override
  String get feedbackSheetTitle => 'Повідомити розробнику';

  @override
  String get feedbackSheetSubtitle =>
      'Щось не працює, не вистачає функції, чи є ідея? Напишіть — це допомагає розвивати застосунок.';

  @override
  String get feedbackTypeBug => 'Помилка';

  @override
  String get feedbackTypeIdea => 'Ідея';

  @override
  String get feedbackTypeQuestion => 'Питання';

  @override
  String get feedbackMessageHint => 'Ваше зауваження або ідея…';

  @override
  String get feedbackSendButton => 'Надіслати';

  @override
  String get feedbackSendError => 'Не вдалося відкрити поштовий клієнт.';

  @override
  String get feedbackSentSnackbar =>
      'Дякуємо! Ми відкрили ваш поштовий клієнт.';

  @override
  String get maintenanceSectionTitle => 'Профілактичне обслуговування';

  @override
  String get maintenanceAddTooltip => 'Додати графік';

  @override
  String get maintenanceEmpty => 'Немає запланованого обслуговування.';

  @override
  String maintenanceNextDue(Object freq, Object date) {
    return '$freq · наступний: $date';
  }

  @override
  String get maintenanceMarkDoneButton => 'Виконано';

  @override
  String get maintenanceFrequencyMonthly => 'щомісяця';

  @override
  String get maintenanceFrequencyQuarterly => 'щоквартально';

  @override
  String get maintenanceFrequencySemiAnnual => 'кожні 6 місяців';

  @override
  String get maintenanceFrequencyAnnual => 'щороку';

  @override
  String maintenanceFrequencyDays(Object days) {
    return 'кожні $days днів';
  }

  @override
  String get maintenanceNewTitle => 'Новий графік обслуговування';

  @override
  String get maintenanceNameLabel => 'Назва';

  @override
  String get maintenanceFrequencyLabel => 'Періодичність';

  @override
  String get maintenanceNextDueDateLabel => 'Дата наступного терміну';

  @override
  String get maintenanceSaveButton => 'Зберегти';

  @override
  String get errorMaintenanceLoad =>
      'Не вдалося завантажити графік обслуговування.';

  @override
  String get errorMaintenanceCreate => 'Не вдалося додати графік.';

  @override
  String get errorMaintenanceMark => 'Не вдалося зберегти виконання.';

  @override
  String get correspondenceTitle => 'Повідомлення';

  @override
  String get correspondenceEmpty =>
      'Ще немає повідомлень. Напишіть перше нижче.';

  @override
  String get correspondenceHintResident => 'Напишіть правлінню/адміністрації…';

  @override
  String get correspondenceHintStaff => 'Напишіть мешканцю…';

  @override
  String get teamNotesTitle => 'Нотатки команди';

  @override
  String get teamNotesHiddenBadge => 'внутрішнє — не видно мешканцю';

  @override
  String get teamNotesEmpty => 'Ще немає нотаток. Додайте першу.';

  @override
  String get teamNotesInputHint => 'Додати нотатку команди…';

  @override
  String photosSelectedCount(Object count) {
    return 'Фото: $count — додати ще';
  }

  @override
  String galleryLabel(Object count) {
    return 'Фото ($count)';
  }

  @override
  String get sendAnnouncementFormTitle => 'НАДІСЛАТИ ОГОЛОШЕННЯ МЕШКАНЦЯМ';

  @override
  String get announcementTitleLabel => 'Заголовок оголошення';

  @override
  String get announcementTitleHint => 'напр. Обслуговування ліфта';

  @override
  String get announcementContentLabel => 'Текст оголошення';

  @override
  String get announcementContentHint => 'Введіть детальний текст оголошення...';

  @override
  String get announcementExpiryLabel => 'Термін дії до (необов\'язково):';

  @override
  String get dayLabel => 'День';

  @override
  String get monthLabel => 'Місяць';

  @override
  String get yearLabel => 'Рік';

  @override
  String get sendAnnouncementButton => 'НАДІСЛАТИ ОГОЛОШЕННЯ';

  @override
  String get sentAnnouncementsTitle => 'НАДІСЛАНІ ОГОЛОШЕННЯ';

  @override
  String announcementExpiresOnLabel(Object date) {
    return 'Термін дії: $date';
  }

  @override
  String announcementExpiredSuffix(Object date) {
    return '$date (закінчився)';
  }

  @override
  String get deleteAnnouncementTooltip => 'Видалити оголошення';

  @override
  String get announcementSentSnackbar => 'Оголошення надіслано!';

  @override
  String announcementPushNotificationPrefix(Object title) {
    return 'ОГОЛОШЕННЯ: $title';
  }

  @override
  String get announcementScopeLabel => 'Область — оберіть аудиторію';

  @override
  String get announcementScopeEstate => 'Усі мешканці';

  @override
  String announcementScopeBuilding(Object name) {
    return 'Будинок $name';
  }

  @override
  String announcementScopeStairwell(Object stairwell, Object building) {
    return 'Клітка $stairwell ($building)';
  }

  @override
  String get residentGreetingMorning => 'Доброго ранку,';

  @override
  String get residentGreetingFallback => 'Мешканцю';

  @override
  String get residentSystemsOK => 'Усі системи в нормі';

  @override
  String get residentAddressUnknown => 'Адресу не підтверджено';

  @override
  String get latestAnnouncementHeader => 'Останнє оголошення';

  @override
  String get activeReportsHeader => 'Активні заявки';

  @override
  String get noActiveReports => 'У вас немає активних заявок.';

  @override
  String get seeAllReports => 'Переглянути всі заявки';

  @override
  String get residentReportsTitle => 'Ваші заявки';

  @override
  String get residentReportsListHeader => 'ВАШІ ЗАЯВКИ';

  @override
  String get noReportsYet => 'Заявок ще немає.';

  @override
  String get syncOfflineButton => 'Синхронізувати офлайн-кеш';

  @override
  String get profileUserTitle => 'Профіль користувача';

  @override
  String get addressLabel => 'Адреса проживання:';

  @override
  String roleLabel(Object role) {
    return 'Роль: $role';
  }

  @override
  String get estateJoinIntro =>
      'Ви ще не належите до жодного комплексу. Введіть код запрошення від адміністратора.';

  @override
  String get estateJoinedInfo =>
      'Ви учасник комплексу. Ваші заявки й оголошення прив\'язані до нього.';

  @override
  String estateJoinedNamedSnackbar(Object name) {
    return 'Ви приєдналися до комплексу «$name».';
  }

  @override
  String get estateInvalidCode => 'Код недійсний або вже неактивний.';

  @override
  String get joinEstateButton => 'Приєднатися';

  @override
  String get joiningEstate => 'Підключення…';

  @override
  String get supportContactTitle => 'Контакт / Підтримка';

  @override
  String get reportAddedSnackbar => 'Заявку успішно надіслано!';

  @override
  String get submitReportButton => 'Надіслати заявку';

  @override
  String get reportTitleRequiredSnackbar => 'Вкажіть назву заявки.';

  @override
  String get lockScreenTitle => 'Реєстрація мешканця';

  @override
  String get lockScreenResidentSubtitle =>
      'Вкажіть свій під\'їзд та номер квартири, щоб отримувати релевантні сповіщення про події у вашій зоні.';

  @override
  String get lockScreenStaffSubtitle =>
      'Введіть свої дані та код запрошення від адміністратора.';

  @override
  String get fullNameFieldLabel => 'Ім\'я та прізвище';

  @override
  String get fullNameRequired => 'Введіть ім\'я та прізвище';

  @override
  String get emailRequired => 'Введіть e-mail';

  @override
  String get emailInvalid => 'Невірний e-mail';

  @override
  String get phoneFieldLabel => 'Номер телефону';

  @override
  String get phoneFieldLabelRequired => 'Номер телефону (обов\'язково)';

  @override
  String get phoneRequired => 'Номер телефону обов\'язковий';

  @override
  String get phoneInvalid => 'Номер телефону закороткий';

  @override
  String get codeInvalid => 'Невірний код запрошення';

  @override
  String get locationSectionLabel => 'Деталі розташування квартири:';

  @override
  String get buildingFieldLabel => 'Будинок';

  @override
  String get footbridgeFieldLabel => 'Під\'їзд / Секція';

  @override
  String get floorFieldLabel => 'Поверх';

  @override
  String get apartmentFieldLabel => 'Квартира';

  @override
  String get requiredFieldShort => 'Обов\'язково';

  @override
  String technicianLoggedInNamed(Object name) {
    return 'Сервіс: $name';
  }

  @override
  String get technicianLoggedInFallback => 'Авторизовано як Сервіс';

  @override
  String get showClosedToggleLabel => 'Показати закриті';

  @override
  String reporterInfoLabel(Object name, Object email) {
    return 'Заявник: $name ($email)';
  }

  @override
  String reportLocationInfoLabel(Object location) {
    return 'Розташування: $location';
  }

  @override
  String reportDescriptionInfoLabel(Object description) {
    return 'Опис: $description';
  }

  @override
  String reportTileSubtitle(
    Object displayId,
    Object footbridge,
    Object building,
    Object floor,
  ) {
    return '#$displayId, Під\'їзд $footbridge\nБудинок $building, Поверх $floor';
  }

  @override
  String get syncedToServerLabel => 'Синхронізовано з сервером';

  @override
  String get savedOfflineLabel => 'Збережено локально (офлайн)';

  @override
  String get technicianNoteTitle => '🛠️ Сервісна примітка:';

  @override
  String stairwellAbbreviationLabel(Object name) {
    return 'під. $name';
  }

  @override
  String apartmentAbbreviationLabel(Object number) {
    return 'кв. $number';
  }

  @override
  String get detailsButtonLabel => 'Деталі';

  @override
  String get technicianDeleteAccountWarning =>
      'Ця дія незворотна — всі ваші дані будуть остаточно видалені.';

  @override
  String technicianPhoneLabel(Object phone) {
    return 'Тел: $phone';
  }

  @override
  String get deleteAccountSectionTitle => 'Видалення облікового запису';

  @override
  String get codeFieldLabelRequired => 'Код запрошення';

  @override
  String get codeRequired => 'Введіть код запрошення';

  @override
  String get codeExplanation =>
      'Ви отримаєте код від правління або адміністратора комплексу. Код визначає вашу роль — вона не обирається вручну.';

  @override
  String get stepBasicDataTitle => 'Основні дані';

  @override
  String get stepLocationTitle => 'Розташування';

  @override
  String get stepSummaryTitle => 'Підсумок';

  @override
  String get technicianCompanyTitle => 'Дані компанії / сервісу';

  @override
  String get technicianCompanyLabel => 'Назва сервісу / компанії';

  @override
  String get technicianCompanyRequired => 'Назва компанії/сервісу обов\'язкова';

  @override
  String get backButtonLabel => 'Назад';

  @override
  String get nextButtonLabel => 'Далі';

  @override
  String get confirmAndOpenButton => 'Підтвердити та відкрити додаток';

  @override
  String get regSummaryRoleLabel => 'Роль';

  @override
  String get regSummaryEstateLabel => 'Комплекс';

  @override
  String get regSummaryNameLabel => 'Ім\'я та прізвище';

  @override
  String get regSummaryLocationLabel => 'Помешкання';

  @override
  String get regSummaryCompanyLabel => 'Компанія / технік';

  @override
  String get regResidentJoinNote =>
      'Ви одразу приєднаєтесь до комплексу після реєстрації.';

  @override
  String get regPendingApprovalNote =>
      'Після реєстрації ваш запит буде надіслано адміністратору. Ви отримаєте сповіщення після схвалення.';

  @override
  String get pendingApprovalTitle => 'Очікує на схвалення';

  @override
  String pendingApprovalBody(Object estateName, Object role) {
    return 'Ваш запит на приєднання до \"$estateName\" як $role надіслано. Адміністратор незабаром його схвалить.';
  }

  @override
  String get pendingApprovalRefreshButton => 'Перевірити статус';

  @override
  String get addContactDialogTitle => 'Додати контакт';

  @override
  String get addContactNameLabel => 'Назва контакту';

  @override
  String get addContactNameHelper =>
      'Напр. Офіс управителя, Аварійна сантехніка';

  @override
  String get addContactRoleLabel => 'Посада / роль';

  @override
  String get addContactRoleHelper =>
      'Напр. Адміністратор комплексу, Електрик. Відображається під назвою.';

  @override
  String get addContactPhoneLabel => 'Телефон';

  @override
  String get addContactEmailLabel => 'E-mail (необов\'язково)';

  @override
  String get addContactCategoryLabel => 'Категорія';

  @override
  String get addContactCancelButton => 'Скасувати';

  @override
  String get addContactAddButton => 'Додати';

  @override
  String get buildingAddRlsError =>
      'У вас немає дозволу додавати будинок. Переконайтеся, що ваша роль — Адміністратор або Правління в цьому комплексі.';

  @override
  String get buildingAddNetworkError =>
      'Не вдається підключитися до сервера. Перевірте підключення до інтернету та спробуйте ще раз.';

  @override
  String get buildingAddError => 'Не вдалося додати будинок. Спробуйте ще раз.';

  @override
  String get reportCategoryLabel => 'Категорія';

  @override
  String get reportCategoryHydraulika => 'Гідравліка';

  @override
  String get reportCategoryElektryka => 'Електрика';

  @override
  String get reportCategoryWinda => 'Ліфт';

  @override
  String get reportCategoryOgrzewanie => 'Опалення';

  @override
  String get reportCategoryDomofon => 'Домофон';

  @override
  String get reportCategoryOswietlenie => 'Освітлення';

  @override
  String get reportCategoryParking => 'Парковка';

  @override
  String get reportCategoryGaraz => 'Гараж';

  @override
  String get reportCategoryDachElewacja => 'Дах/Фасад';

  @override
  String get reportCategorySprzatanie => 'Прибирання';

  @override
  String get reportCategoryZielen => 'Озеленення';

  @override
  String get reportCategoryZarzadAdministrator => 'Правління / Адміністратор';

  @override
  String get reportRecipientBoardAdminService => 'Правління / Admin + Сервіс';

  @override
  String get reportRecipientBoardAdminSecurity => 'Правління / Admin + Охорона';

  @override
  String get qrScanTitle => 'Сканувати QR-код';

  @override
  String get fabReportIssue => 'Повідомити проблему';

  @override
  String get fabScanQr => 'Сканувати QR-код';

  @override
  String get fabMessageToBoard => 'Повідомлення до правління';

  @override
  String get fabClose => 'Закрити';

  @override
  String get buildingLabel => 'Будинок';

  @override
  String get stairwellLabel => 'Під\'їзд';

  @override
  String get floorLabel => 'Поверх';

  @override
  String get apartmentLabel => 'Квартира';

  @override
  String get qrLocationPrefix => 'Місце, відскановане з QR-коду:';

  @override
  String get residentSpacesTitle => 'Мої приміщення';

  @override
  String get residentSpacesAddButton => 'Додати приміщення';

  @override
  String get residentSpacesEmpty =>
      'Ви ще не додали жодного приміщення.\nДодайте комірку, підвал або місце для паркування.';

  @override
  String get residentSpacesTypeLabel => 'Тип';

  @override
  String get residentSpacesNameLabel => 'Позначка';

  @override
  String get residentSpacesNameHint => 'напр. К-14, рівень -1';

  @override
  String get residentSpacesTypeStorage => 'Комора';

  @override
  String get residentSpacesTypeBasement => 'Підвал';

  @override
  String get residentSpacesTypeParking => 'Місце для паркування';

  @override
  String get residentSpacesTypeGarage => 'Гараж';

  @override
  String get residentSpacesTypeOther => 'Інше';

  @override
  String get residentSpacesDeleteConfirmTitle => 'Видалити приміщення';

  @override
  String get residentSpacesDeleteConfirmMessage =>
      'Ви впевнені, що хочете видалити це приміщення?';

  @override
  String get residentSpacesDelete => 'Видалити';

  @override
  String get residentSpacesSave => 'Зберегти';

  @override
  String get emptyReportsTitle => 'Немає заявок';

  @override
  String get emptyReportsBody =>
      'Все працює справно? Ви ще не подали жодної заявки про несправність.';

  @override
  String get emptyReportsAction => 'Повідомити про першу проблему';

  @override
  String get emptyContactsTitle => 'Немає контактів';

  @override
  String get emptyContactsBody =>
      'Адміністратор будинку ще не додав аварійних або сервісних контактів.';

  @override
  String get contactsTabTitle => 'Аварійні контакти';

  @override
  String get addContactTooltip => 'Додати контакт';

  @override
  String get contactsCategoryAdministration => 'Адміністрація';

  @override
  String get contactsCategoryEmergency => 'Аварійні служби';

  @override
  String get contactsCategoryMaintenance => 'Сервіс';

  @override
  String get contactsCategorySecurity => 'Охорона';

  @override
  String get callButtonTooltip => 'Подзвонити';

  @override
  String get deleteContactDialogTitle => 'Видалити контакт';

  @override
  String deleteContactConfirmMessage(Object name) {
    return 'Ви впевнені, що хочете видалити контакт \"$name\"?';
  }

  @override
  String get emptyAnnouncementsTitle => 'Немає оголошень';

  @override
  String get emptyAnnouncementsBody =>
      'Правління будинку ще не опублікувало жодних оголошень.';

  @override
  String get emptyBuildingsTitle => 'Немає будівель';

  @override
  String get emptyBuildingsBody =>
      'Почніть із додавання першої будівлі, щоб створити структуру маєтку.';

  @override
  String get emptyBuildingsAction => 'Додати першу будівлю';

  @override
  String get emptyTechReportsTitle => 'Немає заявок';

  @override
  String get emptyTechReportsBody =>
      'Черга сервісного обслуговування порожня — у вас немає призначених або очікуваних заявок.';

  @override
  String get residentNewLabel => 'нові';

  @override
  String get residentInProgressLabel => 'в роботі';

  @override
  String get residentCriticalLabel => 'термінових';

  @override
  String get residentMyReportsCardTitle => 'Мої заявки';

  @override
  String get residentAnnouncementsCardTitle => 'Оголошення';

  @override
  String get residentCommunityTitle => 'Спільнота';

  @override
  String get residentCommunitySubtitle =>
      'Календар зборів, голосування по ухвалах та сусідська комунікація.';

  @override
  String get estateHealthTitle => 'Здоров\'я маєтку';

  @override
  String get estateHealthOpenReports => 'Відкриті';

  @override
  String get estateHealthOverdue => 'Прострочені';

  @override
  String get estateHealthTotal => 'Всього';

  @override
  String get estateHealthNoData =>
      'Немає даних — показник буде розраховано після появи перших заявок.';

  @override
  String get estateHealthPrototypeLabel => '[ПРОТОТИП]';

  @override
  String get buildingUpdateError =>
      'Не вдалося оновити будинок. Спробуйте ще раз.';

  @override
  String get buildingDeleteError =>
      'Не вдалося видалити будинок. Спробуйте ще раз.';

  @override
  String get stairwellAddRlsError =>
      'У вас немає дозволу додавати під\'їзд. Переконайтеся, що ваша роль — Адміністратор або Правління в цьому комплексі.';

  @override
  String get stairwellAddError =>
      'Не вдалося додати під\'їзд. Спробуйте ще раз.';

  @override
  String get stairwellUpdateError =>
      'Не вдалося оновити під\'їзд. Спробуйте ще раз.';

  @override
  String get stairwellDeleteError =>
      'Не вдалося видалити під\'їзд. Спробуйте ще раз.';

  @override
  String get estateStructureTitle => 'Структура комплексу';

  @override
  String get addBuildingTooltip => 'Додати будинок';

  @override
  String get addGarageMenuLabel => 'Додати гараж';

  @override
  String get testConnectionButton => 'Перевірити з\'єднання';

  @override
  String get offlineModeBanner =>
      'Офлайн-режим: використовуємо локальні дані. Supabase тимчасово недоступний.';

  @override
  String get noBuildingsMessage =>
      'Будинки не визначені.\nДодайте перший будинок.';

  @override
  String get garageBadgeLabel => 'ГАРАЖ';

  @override
  String get stairwellsSectionLabel => 'ПІД\'ЇЗДИ';

  @override
  String get addStairwellButton => 'Додати під\'їзд';

  @override
  String get noStairwellsMessage =>
      'Під\'їздів немає. Додайте перший під\'їзд.';

  @override
  String get addBuildingDialogTitle => 'Додати будинок';

  @override
  String get editBuildingDialogTitle => 'Редагувати будинок';

  @override
  String get buildingNameLabel => 'Назва будинку';

  @override
  String get buildingNameHint => 'напр. Будинок 1';

  @override
  String get buildingAddressLabel => 'Адреса (необов\'язково)';

  @override
  String get buildingAddressHint => 'напр. вул. Сонячна 5';

  @override
  String get cancelButton => 'Скасувати';

  @override
  String get addButton => 'Додати';

  @override
  String get saveButton => 'Зберегти';

  @override
  String get deleteButton => 'Видалити';

  @override
  String get deleteBuildingDialogTitle => 'Видалити будинок';

  @override
  String deleteBuildingDialogContent(Object name) {
    return 'Ви впевнені, що хочете видалити \"$name\"?\n\nУсі під\'їзди цього будинку також будуть видалені.';
  }

  @override
  String get addStairwellDialogTitle => 'Додати під\'їзд';

  @override
  String get editStairwellDialogTitle => 'Редагувати під\'їзд';

  @override
  String get stairwellNameLabel => 'Під\'їзд';

  @override
  String stairwellNameValue(Object name) {
    return 'Під\'їзд $name';
  }

  @override
  String get floorMinLabel => 'Найнижчий поверх';

  @override
  String get floorMaxLabel => 'Найвищий поверх';

  @override
  String get garageEntranceLabel => 'Вхід до гаража';

  @override
  String garageEntranceValue(Object label) {
    return 'Вхід $label';
  }

  @override
  String get notApplicableLabel => '—';

  @override
  String get validationFloorRangeInvalid =>
      'Найвищий поверх має бути більшим або рівним найнижчому.';

  @override
  String get deleteStairwellDialogTitle => 'Видалити під\'їзд';

  @override
  String deleteStairwellDialogContent(Object name) {
    return 'Ви впевнені, що хочете видалити \"$name\"?';
  }

  @override
  String stairwellFloorRange(Object min, Object max) {
    return 'Поверхи $min–$max';
  }

  @override
  String get createAccountTitle => 'Створіть акаунт';

  @override
  String get createAccountBody =>
      'Крок 1 з 2: введіть e-mail і пароль. У кроці 2 ви додасте ім\'я, телефон, адресу квартири та опціональний код запрошення.';

  @override
  String get passwordConfirmFieldLabel => 'Підтвердіть пароль';

  @override
  String get passwordsDoNotMatch => 'Паролі не співпадають.';

  @override
  String get registerSubmitButton => 'Створити акаунт';

  @override
  String get registerConsentLabel =>
      'Я приймаю Умови використання та Політику конфіденційності та надаю згоду на обробку моїх персональних даних.';

  @override
  String get errorTermsNotAccepted =>
      'Ви повинні прийняти Умови використання та Політику конфіденційності, щоб продовжити.';

  @override
  String get blockUserButton => 'Заблокувати користувача';

  @override
  String get userBlockedSnackbar => 'Користувача заблоковано.';

  @override
  String get dangerZoneSectionTitle => 'Небезпечна зона';

  @override
  String get deleteAccountRequiresPassword => 'Підтвердьте пароль';

  @override
  String get deleteAccountPasswordLabel => 'Пароль';

  @override
  String get deleteAccountPasswordHint =>
      'Введіть пароль, щоб підтвердити видалення акаунту';

  @override
  String get statusNowe => 'Нове';

  @override
  String get statusWRealizacji => 'В реалізації';

  @override
  String get statusZamkniete => 'Закриті';

  @override
  String get statusOdrzucone => 'Відхилені';

  @override
  String get allFilterLabel => 'Усі';

  @override
  String get noReportsMatchingFilter =>
      'Немає звернень, що відповідають вибраним фільтрам.';

  @override
  String get assignTo => 'Призначити';

  @override
  String get unassigned => 'Не призначено';

  @override
  String assignedToLabel(Object name, Object role) {
    return 'Призначено: $name ($role)';
  }

  @override
  String get logoutFeedbackTitle => 'Що ви думаєте про додаток?';

  @override
  String get logoutFeedbackDescription =>
      'Ваш відгук допоможе нам зробити його кращим.';

  @override
  String get logoutFeedbackRateButton => 'Залишити відгук';

  @override
  String get logoutFeedbackLogoutButton => 'Вийти';

  @override
  String get reportDetailScreenTitle => 'Деталі заявки';

  @override
  String reportDetailIdLabel(Object id) {
    return 'FX-$id';
  }

  @override
  String get priorityLow => 'Низький';

  @override
  String get priorityNormal => 'Нормальний';

  @override
  String get priorityHigh => 'Високий';

  @override
  String get priorityCritical => 'Критичний';

  @override
  String get priorityLabel => 'Пріоритет';

  @override
  String get slaDeadlineLabel => 'Термін SLA';

  @override
  String get slaOverdueLabel => 'Прострочено';

  @override
  String get csatTitle => 'Оцініть виконання заявки';

  @override
  String get csatSubmitButton => 'Оцінити';

  @override
  String get csatSubmittedSnackbar => 'Дякуємо за оцінку!';

  @override
  String get auditTrailTitle => 'Історія змін';

  @override
  String auditTrailActionStatusChange(Object user, Object status) {
    return '$user змінив статус на: $status';
  }

  @override
  String auditTrailActionPriorityChange(Object user, Object priority) {
    return '$user змінив пріоритет на: $priority';
  }

  @override
  String auditTrailActionAssign(Object user, Object assignee) {
    return '$user призначив на: $assignee';
  }

  @override
  String auditTrailActionCreate(Object user) {
    return '$user створив заявку';
  }

  @override
  String get serviceNotesLabel => 'Сервісна записка';

  @override
  String get teamNotesLabel => 'Нотатки команди';

  @override
  String get noTeamNotes => 'Немає нотаток команди.';

  @override
  String get photoGalleryLabel => 'Фотографії';

  @override
  String get reportContentButton => 'Поскаржитись';

  @override
  String get reportContentDialogTitle => 'Поскаржитись на вміст';

  @override
  String get reportContentReasonLabel => 'Причина скарги';

  @override
  String get reportContentReasonSpam => 'Спам';

  @override
  String get reportContentReasonHarassment => 'Переслідування';

  @override
  String get reportContentReasonInappropriate => 'Недоречний вміст';

  @override
  String get reportContentReasonMisinformation => 'Дезінформація';

  @override
  String get reportContentReasonPrivacy => 'Порушення приватності';

  @override
  String get reportContentReasonOther => 'Інше';

  @override
  String get reportContentDescriptionLabel =>
      'Додатковий опис (необов\'язково)';

  @override
  String get reportContentDescriptionHint => 'Опишіть проблему...';

  @override
  String get reportContentSubmitButton => 'Надіслати скаргу';

  @override
  String get reportContentCancelButton => 'Скасувати';

  @override
  String get reportContentSuccessSnackbar => 'Скаргу надіслано';

  @override
  String get errorModerationRateLimit =>
      'Досягнуто ліміту звітів. Спробуйте пізніше.';

  @override
  String get errorModerationAlreadyReported =>
      'Ви вже повідомили про цей вміст.';

  @override
  String get errorModerationContentNotFound => 'Вміст не знайдено.';

  @override
  String get errorModerationUnauthenticated => 'Необхідно увійти.';

  @override
  String get errorModerationUnknown => 'Не вдалося надіслати звіт.';

  @override
  String get errorLoadingData => 'Помилка завантаження даних';

  @override
  String get retryButton => 'Спробувати ще раз';

  @override
  String get errorLocationServiceDisabled =>
      'Служба GPS/Локації вимкнена на пристрої.';

  @override
  String get errorLocationPermissionDenied => 'Немає дозволу на доступ до GPS.';

  @override
  String get errorLocationPermissionDeniedForever =>
      'Дозволи GPS назавжди заблоковано в налаштуваннях системи.';

  @override
  String get errorLocationUnknown => 'Не вдалося отримати місцезнаходження.';

  @override
  String get selectEstateTitle => 'Виберіть комплекс';

  @override
  String get estateCompanySectionTitle => 'Керуюча компанія';

  @override
  String get estateCompanyNone => 'Не налаштовано';

  @override
  String get estateAdminContact => 'Контакт адміністратора';

  @override
  String get estateInvitationCodeLabel => 'Код запрошення';

  @override
  String get estateNoInvitationCode => 'Немає активного коду';

  @override
  String get estateContractValidUntilLabel => 'Договір дійсний до';

  @override
  String estateContractDaysLeft(Object days) {
    return 'Залишилось $days днів';
  }

  @override
  String get estateContractExpired => 'Договір закінчився';

  @override
  String get estateContractNone => 'Немає активного договору';

  @override
  String get dataExportButtonLabel => 'Експортувати мої дані';

  @override
  String get dataExportDescription =>
      'Завантажте копію всіх своїх даних у форматі JSON (GDPR ст. 20 — право на перенесення даних).';

  @override
  String get dataExportedSnackbar =>
      'Ваші дані було скопійовано в буфер обміну. Вставте їх у текстовий файл, щоб зберегти.';

  @override
  String get reportSearchHint => 'Шукати заявки...';

  @override
  String get reportComposerTitle => 'Повідомити про нову несправність';

  @override
  String get reportTitleHint => 'Назва несправності (короткий опис)';

  @override
  String get reportDescriptionHint =>
      'Опишіть пошкодження, додаткові деталі та місцезнаходження\nНапр. Відкрите вікно. Будинок 1, під\'їзд A, 3 поверх. Прошу швидко відремонтувати.';

  @override
  String get photoTakePhotoButton => 'Зробити фото';

  @override
  String get photoAddMoreButton => 'Додати ще';

  @override
  String get photoGalleryButton => 'Галерея';

  @override
  String get pdfAttachButton => 'Прикріпити PDF';

  @override
  String get pdfSelectedLabel => 'PDF вибрано';

  @override
  String get buildingTypeLabel => 'Тип будівлі';

  @override
  String get buildingTypeResidential => 'Житловий будинок';

  @override
  String get buildingTypeGarage => 'Гараж';

  @override
  String get addGarageDialogTitle => 'Додати гараж';

  @override
  String get garageNameLabel => 'Назва гаража';

  @override
  String get garageNameHint => 'напр. Підземний гараж';

  @override
  String get garageFloorInfo =>
      'Підвали/рівні гаража будуть додані як під\'їзди з діапазоном від -4 до 0.';

  @override
  String get gpsDevicePositionLabel => 'Позиція GPS (Пристрій):';

  @override
  String gpsLatitudeLabel(Object lat) {
    return 'Широта: $lat';
  }

  @override
  String gpsLongitudeLabel(Object lng) {
    return 'Довгота: $lng';
  }

  @override
  String gpsSourceLabel(Object source) {
    return 'Джерело: $source';
  }

  @override
  String gpsLabelLabel(Object label) {
    return 'Мітка: $label';
  }

  @override
  String get contactBookCardTitle => 'Книга контактів';

  @override
  String get contactBookCardSubtitle =>
      'Керування аварійними та сервісними контактами комплексу';

  @override
  String get contactBookTitle => 'Книга контактів';

  @override
  String get boardNotesTitle => 'Нотатки правління';

  @override
  String get actionsSectionTitle => 'Дії';

  @override
  String get unknownUserFallback => 'Невідомий';

  @override
  String reporterLabel(Object name) {
    return 'Повідомив: $name';
  }

  @override
  String get collapseButton => 'Згорнути';

  @override
  String get expandButton => 'Розгорнути';

  @override
  String get sortNewest => 'Найновіші';

  @override
  String get sortOldest => 'Найстаріші';
}
