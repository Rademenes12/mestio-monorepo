// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get localizationBootstrap =>
      'Lokalizacja aplikacji jest skonfigurowana.';

  @override
  String get errorInvalidCredentials => 'Nieprawidłowy email lub hasło.';

  @override
  String get errorEmailNotConfirmed =>
      'Potwierdź adres email klikając w link wysłany na Twoją skrzynkę pocztową.';

  @override
  String get errorAnonymousAuthDisabled =>
      'Logowanie jako gość jest obecnie wyłączone.';

  @override
  String get errorEmailAlreadyRegistered =>
      'Ten adres email jest już zarejestrowany. Zaloguj się.';

  @override
  String get errorEmail => 'Sprawdź adres email i spróbuj ponownie.';

  @override
  String get errorPassword => 'Sprawdź hasło i spróbuj ponownie.';

  @override
  String get errorPasswordResetCodeRequired =>
      'Wpisz kod resetu z wiadomości email.';

  @override
  String get errorPasswordResetCodeInvalid =>
      'Kod resetu jest nieprawidłowy. Sprawdź go i spróbuj ponownie.';

  @override
  String get errorPasswordResetCodeExpired =>
      'Kod resetu wygasł. Poproś o nowy i spróbuj ponownie.';

  @override
  String get errorPasswordTooShort =>
      'Użyj hasła o długości co najmniej 6 znaków.';

  @override
  String get errorPasswordsDoNotMatch => 'Hasła nie są takie same.';

  @override
  String get errorNetwork => 'Problem z połączeniem. Spróbuj ponownie.';

  @override
  String get errorPurchase =>
      'Nie udało się dokończyć zakupu. Spróbuj ponownie.';

  @override
  String get errorDeleteAccountSetupRequired =>
      'Funkcja usuwania konta nie jest wdrożona. Wdróż funkcję delete-account w Supabase Edge Functions.';

  @override
  String get errorDeleteAccountFailed =>
      'Nie udało się usunąć konta. Sprawdź połączenie z internetem i spróbuj ponownie. Jeśli problem persistuje, skontaktuj się z pomocą techniczną.';

  @override
  String get errorSharedUsersSetupRequired =>
      'Brakuje tabeli shared_users albo jej schema nie zgadza się z template.';

  @override
  String get errorDeleteAccountNotImplemented =>
      'Usuwanie konta nie jest jeszcze gotowe.';

  @override
  String get errorNoEstate => 'Najpierw musisz dołączyć do osiedla.';

  @override
  String get errorCodeNotFoundOrExpired =>
      'Nieprawidłowy lub wygasły kod zaproszenia.';

  @override
  String get errorInvalidCodeFormat =>
      'Nieprawidłowy format kodu (XXXX-XXXX-XXXX).';

  @override
  String get errorRateLimitExceeded =>
      'Zbyt wiele prób. Spróbuj ponownie za 15 minut.';

  @override
  String get errorEstateInactive => 'To osiedle jest obecnie nieaktywne.';

  @override
  String get errorRoleLimitReached =>
      'Osiągnięto limit użytkowników dla tej roli.';

  @override
  String get errorApartmentLimitReached =>
      'Maksymalnie 4 osoby mogą być zarejestrowane pod tym samym lokalem.';

  @override
  String get errorUnknown => 'Wystąpił nieoczekiwany błąd.';

  @override
  String errorWithKey(Object errorKey) {
    return 'Wystąpił błąd: $errorKey';
  }

  @override
  String get guestDisplayName => 'Gość';

  @override
  String get registeredUserDisplayName => 'Użytkownik';

  @override
  String get loadingLabel => 'Ładowanie...';

  @override
  String get sessionErrorTitle => 'Błąd sesji';

  @override
  String get accountTypeGuest => 'gość';

  @override
  String get accountTypeRegistered => 'zalogowany';

  @override
  String get commonYes => 'tak';

  @override
  String get commonNo => 'nie';

  @override
  String get limitAccessGuest => 'gość';

  @override
  String get limitAccessRegistered => 'zarejestrowany';

  @override
  String get limitAccessPro => 'Pro';

  @override
  String get homeTitle => 'Start';

  @override
  String get currentSessionTitle => 'Aktualna sesja';

  @override
  String sessionUserId(Object value) {
    return 'ID użytkownika: $value';
  }

  @override
  String sessionAccountType(Object value) {
    return 'Typ konta: $value';
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
    return 'Nazwa wyświetlana: $value';
  }

  @override
  String sessionFirstName(Object value) {
    return 'Imię: $value';
  }

  @override
  String get developerToolsTitle => 'Narzędzia deweloperskie';

  @override
  String get retryButtonLabel => 'Spróbuj ponownie';

  @override
  String get welcomeTitle => 'Witaj w Mestio';

  @override
  String get welcomeBody =>
      'Kontynuuj jako gość albo zaloguj się na istniejące konto.';

  @override
  String get welcomeSubtitle => 'Zarządzanie zgłoszeniami w Twojej wspólnocie';

  @override
  String get continueAsGuestButton => 'Kontynuuj jako gość';

  @override
  String get continueAsGuestButtonLabel => 'Rozpoczynamy';

  @override
  String get loginButtonLabel => 'Zaloguj się';

  @override
  String get loginScreenTitle => 'Logowanie';

  @override
  String get loginExistingAccountTitle => 'Zaloguj się na istniejące konto';

  @override
  String get loginExistingAccountBody =>
      'Użyj adresu e-mail i hasła, aby przełączyć się na istniejące konto.';

  @override
  String get emailFieldLabel => 'E-mail';

  @override
  String get passwordFieldLabel => 'Hasło';

  @override
  String get forgotPasswordButtonLabel => 'Nie pamiętasz hasła?';

  @override
  String get forgotPasswordScreenTitle => 'Reset hasła';

  @override
  String get forgotPasswordTitle => 'Zresetuj hasło';

  @override
  String get forgotPasswordBody =>
      'Wpisz adres e-mail, a wyślemy Ci kod resetu hasła.';

  @override
  String get sendResetCodeButtonLabel => 'Wyślij kod';

  @override
  String get resetPasswordScreenTitle => 'Ustaw nowe hasło';

  @override
  String get resetPasswordTitle => 'Wpisz kod resetu';

  @override
  String resetPasswordBody(Object email) {
    return 'Wysłaliśmy kod resetu na adres $email. Wpisz go poniżej i ustaw nowe hasło.';
  }

  @override
  String get resetCodeFieldLabel => 'Kod resetu';

  @override
  String get confirmPasswordFieldLabel => 'Potwierdź nowe hasło';

  @override
  String get resetPasswordButtonLabel => 'Zmień hasło';

  @override
  String get passwordResetSuccessSnackbar => 'Hasło zostało zmienione';

  @override
  String get switchAccountWarningTitle => 'Przełączasz konto';

  @override
  String get switchAccountWarningBody =>
      'Logowanie w tym miejscu przełączy Cię z obecnego konta gościa na inne konto. Dane gościa i Pro nie łączą się automatycznie.';

  @override
  String get registerScreenTitle => 'Rejestracja';

  @override
  String get secureGuestAccountTitle => 'Zabezpiecz to konto gościa';

  @override
  String get secureGuestAccountBody =>
      'To zachowa Twoje obecne dane i połączy to konto gościa z adresem e-mail oraz hasłem.';

  @override
  String get registerButtonLabel => 'Zarejestruj';

  @override
  String get profileSavedSnackbar => 'Profil zapisany';

  @override
  String get proEnabledSnackbar => 'Pro aktywowane';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileLanguageSectionTitle => 'Język aplikacji';

  @override
  String get profileLanguageSectionDescription =>
      'Wybierz, czy aplikacja ma używać języka urządzenia, polskiego, ukraińskiego czy angielskiego.';

  @override
  String get firstNameFieldLabel => 'Imię';

  @override
  String get languageOptionSystem => 'Automatyczny';

  @override
  String get languageOptionSystemDescription =>
      'Używa języka urządzenia. Dla nieobsługiwanych języków aplikacja wraca do English.';

  @override
  String get languageOptionPolish => 'Polski';

  @override
  String get languageOptionEnglish => 'English';

  @override
  String get languageOptionUkrainian => 'Українська';

  @override
  String get saveFirstNameButtonLabel => 'Zapisz imię';

  @override
  String get accountSecuredSnackbar => 'Konto zabezpieczone';

  @override
  String get logoutButtonLabel => 'Wyloguj się';

  @override
  String get buyProButtonLabel => 'Kup Pro';

  @override
  String get proPlaceholderTitle => 'Zakupy Pro nie są jeszcze podłączone';

  @override
  String get proPlaceholderBodyProfile =>
      'Template ma już przygotowany flow upgrade do Pro w UI, ale prawdziwy paywall RevenueCat trzeba jeszcze podłączyć w etapie konfiguracji RevenueCat.';

  @override
  String get deleteAccountButtonLabel => 'Usuń konto';

  @override
  String get discardChangesTitle => 'Odrzucić zmiany?';

  @override
  String get discardChangesBody =>
      'Masz niezapisane zmiany. Jeśli wyjdziesz teraz, zostaną utracone.';

  @override
  String get stayButtonLabel => 'Zostań';

  @override
  String get discardButtonLabel => 'Odrzuć';

  @override
  String get closeButtonLabel => 'Zamknij';

  @override
  String get protectProBannerTitle => 'Zabezpiecz dostęp do Pro';

  @override
  String get protectProBannerBody =>
      'To konto gościa ma już Pro. Zarejestruj to konto, aby nie stracić dostępu w przyszłości.';

  @override
  String get developerDiagnosticsTitle => 'Diagnostyka tylko dla debug';

  @override
  String get developerDiagnosticsBody =>
      'Użyj tego ekranu, aby sprawdzić lokalną konfigurację aplikacji i status integracji.';

  @override
  String get revenueCatDisconnectedTitle => 'RevenueCat nie jest podłączony';

  @override
  String get revenueCatDisconnectedBody =>
      'Dodaj klucze RevenueCat do config/api-keys.json, gdy będziesz gotowy testować subskrypcje.';

  @override
  String get revenueCatDebugMissingTestStoreTitle =>
      'Brakuje klucza Test Store';

  @override
  String get revenueCatDebugMissingTestStoreBody =>
      'Buildy debug używają klucza RevenueCat Test Store. Dodaj REVENUECAT_TEST_STORE_API_KEY do config/api-keys.json i uruchom aplikację ponownie.';

  @override
  String get sessionSectionTitle => 'Sesja';

  @override
  String get loggedInLabel => 'Zalogowany';

  @override
  String loggedInAsNamedLabel(Object name) {
    return 'Zalogowany: $name';
  }

  @override
  String get managerDashboardTitle => 'Pulpit Zarządu';

  @override
  String get adminDashboardTitle => 'Pulpit Administratora';

  @override
  String get anonymousLabel => 'Anonimowy';

  @override
  String get limitAccessLabel => 'Dostęp do limitów';

  @override
  String get proLabel => 'Pro';

  @override
  String get userIdLabel => 'ID użytkownika';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get displayNameLabel => 'Nazwa wyświetlana';

  @override
  String get supabaseSectionTitle => 'Supabase';

  @override
  String get keysConfiguredLabel => 'Klucze skonfigurowane';

  @override
  String get supabaseUrlLabel => 'Supabase URL';

  @override
  String get revenueCatSectionTitle => 'RevenueCat';

  @override
  String get supportedPlatformLabel => 'Wspierana platforma';

  @override
  String get platformKeyConfiguredLabel => 'Klucz platformy skonfigurowany';

  @override
  String get testStoreKeyConfiguredLabel => 'Klucz Test Store skonfigurowany';

  @override
  String get sdkActiveLabel => 'SDK aktywne';

  @override
  String get activeKeyTypeLabel => 'Typ aktywnego klucza';

  @override
  String get activeSdkKeyLabel => 'Aktywny klucz SDK';

  @override
  String get activeKeyTypeMissing => 'Brak';

  @override
  String get activeKeyTypeTestStore => 'Test Store';

  @override
  String get activeKeyTypeAppStore => 'App Store';

  @override
  String get activeKeyTypeGooglePlay => 'Google Play';

  @override
  String get proSourceLabel => 'Źródło Pro';

  @override
  String get proSourceRevenueCat => 'RevenueCat';

  @override
  String get proSourceDeveloperOverride => 'Developer override';

  @override
  String get missingValueLabel => 'brak';

  @override
  String get debugForceProTitle => 'Debug: wymuś status Pro';

  @override
  String get debugForceProSubtitle =>
      'Działa tylko bez aktywnego RevenueCat i tylko w debugowym narzędziu.';

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
      'Połącz `Supabase MCP` z moim projektem Supabase i uzupełnij `config/api-keys.json` wartościami `SUPABASE_URL` oraz `SUPABASE_ANON_KEY`.';

  @override
  String get missingSupabaseTitle => 'Brakuje kluczy Supabase';

  @override
  String get missingSupabaseBody =>
      'Dodaj klucze Supabase do pliku konfiguracyjnego i uruchom aplikację ponownie.';

  @override
  String get missingSupabaseFileLabel => 'Uzupełnij ten plik';

  @override
  String get missingSupabaseFilePath => 'config/api-keys.json';

  @override
  String get missingSupabaseStep1Title => 'Krok 1: zainstaluj `Supabase MCP`';

  @override
  String get missingSupabaseStep1Body =>
      'Najpierw dodaj `Supabase MCP` do swojego agenta AI.';

  @override
  String get missingSupabaseStep2Title => 'Krok 2: wklej ten prompt agentowi';

  @override
  String get copyPromptButtonLabel => 'Kopiuj prompt';

  @override
  String get promptCopiedSnackbar => 'Prompt skopiowany';

  @override
  String get missingSupabaseStep3Title =>
      'Krok 3: zamknij i otwórz aplikację ponownie';

  @override
  String get missingSupabaseStep3Body =>
      'Gdy agent uzupełni plik z kluczami, zamknij aplikację i uruchom ją jeszcze raz.';

  @override
  String get sharedUsersAgentPrompt =>
      'Uruchom task `docs/tasks/02_SUPABASE_SHARED_USERS_SETUP.md` i doprowadź tabelę `shared_users` do minimalnej zgodności z tym projektem używając `Supabase MCP`.';

  @override
  String get sharedUsersSetupTitle =>
      'Brakuje tabeli `shared_users` w Supabase';

  @override
  String get sharedUsersSetupBody =>
      'Aplikacja nie może wczytać dodatkowych danych użytkowników (takich jak np. imię), bo tabela `shared_users` nie istnieje albo jej struktura nie zgadza się z założeniami minimalnymi.';

  @override
  String get sharedUsersGuideLabel => 'Skorzystaj z gotowej instrukcji:';

  @override
  String get sharedUsersGuideFile => '02_SUPABASE_SHARED_USERS_SETUP.md';

  @override
  String get sharedUsersAiPromptTitle => 'Wklej ten prompt agentowi AI';

  @override
  String get sharedUsersAiHelpBody =>
      'Jeżeli Twój agent AI ma dostęp do Supabase MCP, ustawi wszystko wg. przygotowanej instrukcji za Ciebie autmatycznie.';

  @override
  String get deleteAccountConfirmationTitle => 'Usuń konto';

  @override
  String get deleteAccountPermanentWarning =>
      'Twoje konto zostanie trwale usunięte wraz ze wszystkimi danymi. Tej operacji nie można cofnąć.';

  @override
  String get deleteAccountOtherAppsWarning =>
      'Stracisz również dostęp do następujących aplikacji:';

  @override
  String get deleteAccountAppsCheckFailed =>
      'Nie udało się sprawdzić, które inne aplikacje używają tego konta. Usunięcie nadal skasuje wspólne konto Supabase i może wpłynąć na inne aplikacje tego developera.';

  @override
  String get deleteAccountCheckboxLabel =>
      'Rozumiem, że dane we wszystkich aplikacjach zostaną usunięte';

  @override
  String get deleteAccountCheckboxLabelSimple =>
      'Rozumiem, że ta operacja jest nieodwracalna';

  @override
  String get deleteAccountSuccessSnackbar => 'Konto usunięte';

  @override
  String get deleteAccountConfirmButton => 'Usuń moje konto';

  @override
  String get connectivityLabel => 'Internet';

  @override
  String get connectivityStatusConnected => 'połączony';

  @override
  String get connectivityStatusDisconnected => 'brak połączenia';

  @override
  String get connectivityStatusChecking => 'sprawdzanie...';

  @override
  String get connectivityOfflineBanner => 'Brak połączenia z internetem';

  @override
  String get proLockFinanceTitle => 'Moduł Finansów (PRO)';

  @override
  String get proLockFinanceDesc =>
      'Uzyskaj dostęp do pełnego podglądu rozliczeń czynszowych, funduszu remontowego oraz historii wpłat wspólnoty.';

  @override
  String get proLockCommunicatorTitle => 'Komunikator Spółdzielni (PRO)';

  @override
  String get proLockCommunicatorDesc =>
      'Komunikuj się bezpośrednio z administracją i odbieraj spersonalizowane alerty o pracach technicznych.';

  @override
  String get proLockPhoneTitle => 'Telefony Alarmowe (PRO)';

  @override
  String get proLockPhoneDesc =>
      'Dostęp do bazy kontaktów i bezpośredniego wybierania numerów do administracji, serwisu wind oraz pogotowia technicznego.';

  @override
  String get proLockUnlockButton => 'Odblokuj wersję PRO';

  @override
  String get estateOnboardingTitle => 'Dołącz do osiedla';

  @override
  String get estateOnboardingSubtitle =>
      'Aby korzystać z aplikacji, dołącz do osiedla kodem zaproszenia lub załóż nowe osiedle jako administrator.';

  @override
  String get estateJoinSectionTitle => 'Mam kod zaproszenia';

  @override
  String get estateCodeFieldLabel => 'Kod zaproszenia';

  @override
  String get estateJoinButton => 'Dołącz do osiedla';

  @override
  String get estateCreateSectionTitle => 'Jestem administratorem osiedla';

  @override
  String get estateNameFieldLabel => 'Nazwa osiedla';

  @override
  String get estateCreateButton => 'Załóż osiedle';

  @override
  String get estateInvitationCodeTitle => 'Kod zaproszenia osiedla';

  @override
  String get addAnotherEstateMenuLabel => '+ Dodaj kolejne osiedle';

  @override
  String get estateInvitationCodeHint =>
      'Przekaż ten kod mieszkańcom, aby mogli dołączyć do osiedla.';

  @override
  String get estateGenerateCodeButton => 'Wygeneruj kod zaproszenia';

  @override
  String get estateCopyCodeButton => 'Kopiuj kod';

  @override
  String get estateCodeCopiedSnackbar => 'Skopiowano kod do schowka.';

  @override
  String get estateJoinedSnackbar => 'Dołączono do osiedla.';

  @override
  String get estateCreatedSnackbar => 'Osiedle zostało założone.';

  @override
  String get estateCodeRolesSectionTitle => 'Kody zaproszeń per rola';

  @override
  String get estateRegenerateCodeButton => 'Wygeneruj nowy';

  @override
  String get estateRegenerateCodeTitle => 'Wygenerować nowy kod?';

  @override
  String get estateRegenerateCodeBody =>
      'Poprzedni kod zostanie dezaktywowany. Kontynuować?';

  @override
  String get estateJoinRequestsTitle => 'Prośby o dołączenie';

  @override
  String get estateJoinRequestsEmpty => 'Brak oczekujących próśb';

  @override
  String get estateApproveButton => 'Akceptuj';

  @override
  String get estateRejectButton => 'Odrzuć';

  @override
  String get estateJoinRequestApprovedSnackbar => 'Prośba zaakceptowana';

  @override
  String get estateJoinRequestRejectedSnackbar => 'Prośba odrzucona';

  @override
  String get estateAutoJoinBadge => 'auto';

  @override
  String get estateApprovalRequiredBadge => 'akceptacja';

  @override
  String get supportSectionTitle => 'Kontakt i wsparcie';

  @override
  String get supportSectionDescription =>
      'Masz pytanie, sugestię lub coś nie działa? Napisz do nas.';

  @override
  String get supportContactButton => 'Napisz do nas';

  @override
  String get supportEmailSubject => 'Mestio – zgłoszenie / sugestia';

  @override
  String get legalSectionTitle => 'Dokumenty prawne';

  @override
  String get legalSectionDescription =>
      'Zapoznaj się z naszą polityką prywatności i regulaminem korzystania z aplikacji.';

  @override
  String get privacyPolicyButton => 'Polityka prywatności';

  @override
  String get termsOfServiceButton => 'Regulamin';

  @override
  String get securityPatrolTitle => 'Obchód: Ochrona';

  @override
  String get securityReportToBoardButton => '⚠️ ZGŁOŚ DLA ZARZĄDU';

  @override
  String get securityEmergencyAlarmButton => '🚨 ALARM DLA WSZYSTKICH';

  @override
  String get securityPatrolHistoryTitle => 'OSTATNIE RAPORTY Z OBCHODÓW';

  @override
  String get securityPatrolHistoryEmpty => 'Brak dzisiejszych wpisów.';

  @override
  String get navHome => 'Home';

  @override
  String get navReports => 'Zgłoszenia';

  @override
  String get navAddReport => 'Zgłoś';

  @override
  String get navPhones => 'Telefon';

  @override
  String get navContacts => 'Kontakty';

  @override
  String get navProfile => 'Profil';

  @override
  String get navAnnouncements => 'Komunikator';

  @override
  String get navEstate => 'Osiedle';

  @override
  String get navResidents => 'Mieszkańcy';

  @override
  String get navResolutions => 'Uchwały';

  @override
  String get residentsVisibleToBoardBadge => 'Widoczne dla zarządu';

  @override
  String get residentsHideFromBoardTooltip => 'Ukryj przed zarządem';

  @override
  String get residentsShareWithBoardTooltip => 'Udostępnij zarządowi';

  @override
  String get residentsEmptyState => 'Brak zarejestrowanych mieszkańców';

  @override
  String get resolutionsTitle => 'Uchwały';

  @override
  String get resolutionsSubtitleBoard => 'Twórz i zliczaj głosy mieszkańców';

  @override
  String get resolutionsSubtitleResident => 'Głosuj nad uchwałami wspólnoty';

  @override
  String get resolutionsEmpty => 'Brak uchwał.';

  @override
  String get resolutionStateOpen => 'Głosowanie trwa';

  @override
  String get resolutionStatePassed => 'Przegłosowana';

  @override
  String get resolutionStateRejected => 'Odrzucona';

  @override
  String resolutionDeadline(Object date) {
    return 'do $date';
  }

  @override
  String get resolutionVoteFor => 'Za';

  @override
  String get resolutionVoteAgainst => 'Przeciw';

  @override
  String resolutionYourVote(Object vote) {
    return 'Twój głos: $vote';
  }

  @override
  String get resolutionResultsHidden =>
      'Wyniki będą widoczne po oddaniu głosu.';

  @override
  String resolutionForPercent(Object pct) {
    return 'Za $pct%';
  }

  @override
  String resolutionAgainstPercent(Object pct) {
    return 'Przeciw $pct%';
  }

  @override
  String resolutionVotesCount(Object count) {
    return 'Głosy: $count';
  }

  @override
  String resolutionVoteSuccess(Object vote) {
    return 'Twój głos: $vote';
  }

  @override
  String get newResolutionTitle => 'Nowa uchwała';

  @override
  String get resolutionTitleLabel => 'Tytuł';

  @override
  String get resolutionDescriptionLabel => 'Opis';

  @override
  String get resolutionDeadlineLabel => 'Termin głosowania (opcjonalnie)';

  @override
  String get resolutionPublishButton => 'Opublikuj';

  @override
  String get resolutionCancelButton => 'Anuluj';

  @override
  String get resolutionCloseAsPassed => 'Zakończ: przegłosowana';

  @override
  String get resolutionCloseAsRejected => 'Zakończ: odrzucona';

  @override
  String get resolutionCreateSuccess => 'Uchwała opublikowana';

  @override
  String get errorResolutionsLoad => 'Nie udało się załadować uchwał.';

  @override
  String get errorResolutionVote => 'Nie udało się oddać głosu.';

  @override
  String get errorResolutionCreate => 'Nie udało się opublikować uchwały.';

  @override
  String get errorResolutionClose => 'Nie udało się zakończyć uchwały.';

  @override
  String get reportCloseRequiresMessageHint =>
      'Aby zamknąć lub odrzucić zgłoszenie, napisz najpierw wiadomość do mieszkańca w notatkach poniżej.';

  @override
  String get reportCloseRequiresMessageWarning =>
      'Najpierw napisz wiadomość do mieszkańca w notatkach poniżej ↓';

  @override
  String get attachmentsLabel => 'Załączniki';

  @override
  String get attachmentOpenLabel => 'otwórz';

  @override
  String get attachmentOpenError => 'Nie udało się otworzyć załącznika.';

  @override
  String get additionalInfoLabel => 'Inne — informacja dla zarządu';

  @override
  String get additionalInfoHint =>
      'np. przyjedzie policja / straż, dostęp od 8:00';

  @override
  String get markAsUrgentLabel => 'Oznacz jako pilne';

  @override
  String get notificationsPanelTitle => 'Powiadomienia';

  @override
  String get notificationsEmpty => 'Brak powiadomień.';

  @override
  String notificationYourReport(Object id) {
    return 'Twoje zgłoszenie $id';
  }

  @override
  String notificationCurrentStatus(Object status) {
    return 'Aktualny status: $status';
  }

  @override
  String notificationUrgentPrefix(Object title) {
    return 'Pilne: $title';
  }

  @override
  String notificationReportPrefix(Object id) {
    return 'Zgłoszenie $id';
  }

  @override
  String get feedbackSheetTitle => 'Zgłoś uwagę do twórcy';

  @override
  String get feedbackSheetSubtitle =>
      'Coś nie działa, brakuje funkcji albo masz pomysł? Napisz — pomaga rozwijać aplikację.';

  @override
  String get feedbackTypeBug => 'Błąd';

  @override
  String get feedbackTypeIdea => 'Pomysł';

  @override
  String get feedbackTypeQuestion => 'Pytanie';

  @override
  String get feedbackMessageHint => 'Twoja uwaga lub pomysł…';

  @override
  String get feedbackSendButton => 'Wyślij uwagę';

  @override
  String get feedbackSendError => 'Nie udało się otworzyć klienta pocztowego.';

  @override
  String get feedbackSentSnackbar =>
      'Dziękujemy! Otworzyliśmy Twojego klienta pocztowego.';

  @override
  String get maintenanceSectionTitle => 'Konserwacja prewencyjna';

  @override
  String get maintenanceAddTooltip => 'Dodaj harmonogram';

  @override
  String get maintenanceEmpty => 'Brak zaplanowanej konserwacji.';

  @override
  String maintenanceNextDue(Object freq, Object date) {
    return '$freq · następny: $date';
  }

  @override
  String get maintenanceMarkDoneButton => 'Wykonano';

  @override
  String get maintenanceFrequencyMonthly => 'co miesiąc';

  @override
  String get maintenanceFrequencyQuarterly => 'co kwartał';

  @override
  String get maintenanceFrequencySemiAnnual => 'co pół roku';

  @override
  String get maintenanceFrequencyAnnual => 'co rok';

  @override
  String maintenanceFrequencyDays(Object days) {
    return 'co $days dni';
  }

  @override
  String get maintenanceNewTitle => 'Nowy harmonogram konserwacji';

  @override
  String get maintenanceNameLabel => 'Nazwa';

  @override
  String get maintenanceFrequencyLabel => 'Częstotliwość';

  @override
  String get maintenanceNextDueDateLabel => 'Data następnego terminu';

  @override
  String get maintenanceSaveButton => 'Zapisz';

  @override
  String get errorMaintenanceLoad =>
      'Nie udało się załadować harmonogramu konserwacji.';

  @override
  String get errorMaintenanceCreate => 'Nie udało się dodać harmonogramu.';

  @override
  String get errorMaintenanceMark => 'Nie udało się zapisać wykonania.';

  @override
  String get correspondenceTitle => 'Wiadomości';

  @override
  String get correspondenceEmpty =>
      'Brak wiadomości. Napisz pierwszą wiadomość poniżej.';

  @override
  String get correspondenceHintResident => 'Napisz do zarządu/administracji…';

  @override
  String get correspondenceHintStaff => 'Napisz do mieszkańca…';

  @override
  String get teamNotesTitle => 'Notatki zespołu';

  @override
  String get teamNotesHiddenBadge => 'wewnętrzne — niewidoczne dla mieszkańca';

  @override
  String get teamNotesEmpty => 'Brak notatek. Dodaj pierwszą.';

  @override
  String get teamNotesInputHint => 'Dodaj notatkę zespołu…';

  @override
  String photosSelectedCount(Object count) {
    return 'Zdjęcia: $count — dodaj kolejne';
  }

  @override
  String galleryLabel(Object count) {
    return 'Zdjęcia ($count)';
  }

  @override
  String get sendAnnouncementFormTitle => 'WYŚLIJ KOMUNIKAT DO MIESZKAŃCÓW';

  @override
  String get announcementTitleLabel => 'Tytuł ogłoszenia';

  @override
  String get announcementTitleHint => 'np. Konserwacja windy';

  @override
  String get announcementContentLabel => 'Treść komunikatu';

  @override
  String get announcementContentHint => 'Wpisz szczegółową treść komunikatu...';

  @override
  String get announcementExpiryLabel => 'Wygasa dnia (opcjonalnie):';

  @override
  String get dayLabel => 'Dzień';

  @override
  String get monthLabel => 'Miesiąc';

  @override
  String get yearLabel => 'Rok';

  @override
  String get sendAnnouncementButton => 'WYŚLIJ KOMUNIKAT';

  @override
  String get sentAnnouncementsTitle => 'WYSŁANE OGŁOSZENIA';

  @override
  String announcementExpiresOnLabel(Object date) {
    return 'Wygasa: $date';
  }

  @override
  String announcementExpiredSuffix(Object date) {
    return '$date (wygasł)';
  }

  @override
  String get deleteAnnouncementTooltip => 'Usuń komunikat';

  @override
  String get announcementSentSnackbar => 'Komunikat został wysłany!';

  @override
  String announcementPushNotificationPrefix(Object title) {
    return 'KOMUNIKAT: $title';
  }

  @override
  String get announcementScopeLabel => 'Zakres — wybierz odbiorców';

  @override
  String get announcementScopeEstate => 'Wszyscy mieszkańcy';

  @override
  String announcementScopeBuilding(Object name) {
    return 'Budynek $name';
  }

  @override
  String announcementScopeStairwell(Object stairwell, Object building) {
    return 'Klatka $stairwell ($building)';
  }

  @override
  String get residentGreetingMorning => 'Dzień dobry,';

  @override
  String get residentGreetingFallback => 'Mieszkańcu';

  @override
  String get residentSystemsOK => 'Wszystkie systemy OK';

  @override
  String get residentAddressUnknown => 'Lokalizacja niezweryfikowana';

  @override
  String get latestAnnouncementHeader => 'Najnowsze ogłoszenie';

  @override
  String get activeReportsHeader => 'Aktywne zgłoszenia';

  @override
  String get noActiveReports => 'Nie masz żadnych aktywnych zgłoszeń.';

  @override
  String get seeAllReports => 'Zobacz wszystkie zgłoszenia';

  @override
  String get residentReportsTitle => 'Twoje Zgłoszenia';

  @override
  String get residentReportsListHeader => 'TWOJE ZGŁOSZENIA';

  @override
  String get noReportsYet => 'Brak zgłoszonych awarii.';

  @override
  String get syncOfflineButton => 'Synchronizuj Offline Cache';

  @override
  String get profileUserTitle => 'Profil Użytkownika';

  @override
  String get addressLabel => 'Adres zamieszkania:';

  @override
  String roleLabel(Object role) {
    return 'Rola: $role';
  }

  @override
  String get estateJoinIntro =>
      'Nie należysz jeszcze do żadnego osiedla. Wpisz kod zaproszenia otrzymany od administratora.';

  @override
  String get estateJoinedInfo =>
      'Jesteś członkiem osiedla. Twoje zgłoszenia i komunikaty są powiązane z tym osiedlem.';

  @override
  String estateJoinedNamedSnackbar(Object name) {
    return 'Dołączono do osiedla „$name\".';
  }

  @override
  String get estateInvalidCode => 'Kod jest nieprawidłowy lub nieaktywny.';

  @override
  String get joinEstateButton => 'Dołącz do osiedla';

  @override
  String get joiningEstate => 'Łączenie…';

  @override
  String get supportContactTitle => 'Kontakt / Wsparcie';

  @override
  String get reportAddedSnackbar => 'Zgłoszenie dodane pomyślnie!';

  @override
  String get submitReportButton => 'Wyślij Zgłoszenie';

  @override
  String get reportTitleRequiredSnackbar => 'Podaj tytuł zgłoszenia!';

  @override
  String get lockScreenTitle => 'Rejestracja Lokatora';

  @override
  String get lockScreenResidentSubtitle =>
      'Wskaż swoją klatkę i numer mieszkania. Dzięki temu będziesz otrzymywać dedykowane powiadomienia o awariach w Twojej okolicy.';

  @override
  String get lockScreenStaffSubtitle =>
      'Wprowadź swoje dane i kod zaproszenia otrzymany od administratora.';

  @override
  String get fullNameFieldLabel => 'Imię i Nazwisko';

  @override
  String get fullNameRequired => 'Wpisz imię i nazwisko';

  @override
  String get emailRequired => 'Wpisz adres e-mail';

  @override
  String get emailInvalid => 'Niepoprawny adres e-mail';

  @override
  String get phoneFieldLabel => 'Numer telefonu';

  @override
  String get phoneFieldLabelRequired => 'Numer telefonu (wymagany)';

  @override
  String get phoneRequired => 'Numer telefonu jest wymagany';

  @override
  String get phoneInvalid => 'Numer telefonu jest za krótki';

  @override
  String get codeInvalid => 'Nieprawidłowy kod zaproszenia';

  @override
  String get locationSectionLabel => 'Szczegóły Lokalizacji Mieszkania:';

  @override
  String get buildingFieldLabel => 'Budynek';

  @override
  String get footbridgeFieldLabel => 'Klatka / Pion';

  @override
  String get floorFieldLabel => 'Piętro';

  @override
  String get apartmentFieldLabel => 'Mieszkanie';

  @override
  String get requiredFieldShort => 'Wymagane';

  @override
  String technicianLoggedInNamed(Object name) {
    return 'Serwis: $name';
  }

  @override
  String get technicianLoggedInFallback => 'Zalogowany Serwis';

  @override
  String get showClosedToggleLabel => 'Pokaż zamknięte';

  @override
  String reporterInfoLabel(Object name, Object email) {
    return 'Zgłaszający: $name ($email)';
  }

  @override
  String reportLocationInfoLabel(Object location) {
    return 'Lokalizacja: $location';
  }

  @override
  String reportDescriptionInfoLabel(Object description) {
    return 'Opis: $description';
  }

  @override
  String reportTileSubtitle(
    Object displayId,
    Object footbridge,
    Object building,
    Object floor,
  ) {
    return '#$displayId, Klatka $footbridge\nBudynek $building, Piętro $floor';
  }

  @override
  String get syncedToServerLabel => 'Zsynchronizowano z bazą';

  @override
  String get savedOfflineLabel => 'Zapisano lokalnie (offline)';

  @override
  String get technicianNoteTitle => '🛠️ Notatka Serwisowa:';

  @override
  String stairwellAbbreviationLabel(Object name) {
    return 'kl. $name';
  }

  @override
  String apartmentAbbreviationLabel(Object number) {
    return 'm. $number';
  }

  @override
  String get detailsButtonLabel => 'Szczegóły';

  @override
  String get technicianDeleteAccountWarning =>
      'Ta operacja jest nieodwracalna — wszystkie Twoje dane zostaną trwale usunięte.';

  @override
  String technicianPhoneLabel(Object phone) {
    return 'Tel: $phone';
  }

  @override
  String get deleteAccountSectionTitle => 'Usuwanie konta';

  @override
  String get codeFieldLabelRequired => 'Kod zaproszenia';

  @override
  String get codeRequired => 'Wprowadź kod zaproszenia';

  @override
  String get codeExplanation =>
      'Kod otrzymasz od zarządu lub administratora osiedla. Kod określa Twoją rolę — nie wybiera się jej ręcznie.';

  @override
  String get stepBasicDataTitle => 'Dane podstawowe';

  @override
  String get stepLocationTitle => 'Lokalizacja';

  @override
  String get stepSummaryTitle => 'Podsumowanie';

  @override
  String get technicianCompanyTitle => 'Dane firmy / serwisanta';

  @override
  String get technicianCompanyLabel => 'Nazwa serwisanta / firmy';

  @override
  String get technicianCompanyRequired =>
      'Nazwa firmy/serwisanta jest wymagana';

  @override
  String get backButtonLabel => 'Wstecz';

  @override
  String get nextButtonLabel => 'Dalej';

  @override
  String get confirmAndOpenButton => 'Potwierdź i Otwórz Aplikację';

  @override
  String get regSummaryRoleLabel => 'Rola';

  @override
  String get regSummaryEstateLabel => 'Osiedle';

  @override
  String get regSummaryNameLabel => 'Imię i nazwisko';

  @override
  String get regSummaryLocationLabel => 'Lokal';

  @override
  String get regSummaryCompanyLabel => 'Firma / serwisant';

  @override
  String get regResidentJoinNote =>
      'Po rejestracji od razu dołączysz do osiedla.';

  @override
  String get regPendingApprovalNote =>
      'Po rejestracji Twoja prośba trafi do administratora. Otrzymasz powiadomienie po akceptacji.';

  @override
  String get pendingApprovalTitle => 'Oczekuje na akceptację';

  @override
  String pendingApprovalBody(Object estateName, Object role) {
    return 'Twoja prośba o dołączenie do osiedla „$estateName” jako $role została wysłana. Administrator zaakceptuje ją wkrótce.';
  }

  @override
  String get pendingApprovalRefreshButton => 'Sprawdź status';

  @override
  String get addContactDialogTitle => 'Dodaj kontakt';

  @override
  String get addContactNameLabel => 'Nazwa kontaktu';

  @override
  String get addContactNameHelper =>
      'Np. Biuro Zarządcy, Pogotowie Hydrauliczne';

  @override
  String get addContactRoleLabel => 'Stanowisko / rola';

  @override
  String get addContactRoleHelper =>
      'Np. Administrator osiedla, Elektryk. Wyświetli się pod nazwą.';

  @override
  String get addContactPhoneLabel => 'Telefon';

  @override
  String get addContactEmailLabel => 'E-mail (opcjonalny)';

  @override
  String get addContactCategoryLabel => 'Kategoria';

  @override
  String get addContactCancelButton => 'Anuluj';

  @override
  String get addContactAddButton => 'Dodaj';

  @override
  String get buildingAddRlsError =>
      'Brak uprawnień do dodania budynku. Upewnij się, że Twoja rola to Administrator lub Zarząd w tym osiedlu.';

  @override
  String get buildingAddNetworkError =>
      'Brak połączenia z serwerem. Sprawdź internet i spróbuj ponownie.';

  @override
  String get buildingAddError =>
      'Nie udało się dodać budynku. Spróbuj ponownie.';

  @override
  String get reportCategoryLabel => 'Kategoria';

  @override
  String get reportCategoryHydraulika => 'Hydraulika';

  @override
  String get reportCategoryElektryka => 'Elektryka';

  @override
  String get reportCategoryWinda => 'Winda';

  @override
  String get reportCategoryOgrzewanie => 'Ogrzewanie';

  @override
  String get reportCategoryDomofon => 'Domofon';

  @override
  String get reportCategoryOswietlenie => 'Oświetlenie';

  @override
  String get reportCategoryParking => 'Parking';

  @override
  String get reportCategoryGaraz => 'Garaż';

  @override
  String get reportCategoryDachElewacja => 'Dach/Elewacja';

  @override
  String get reportCategorySprzatanie => 'Sprzątanie';

  @override
  String get reportCategoryZielen => 'Zieleń';

  @override
  String get reportCategoryZarzadAdministrator => 'Zarząd / Administrator';

  @override
  String get reportRecipientBoardAdminService => 'Zarząd / Admin + Serwis';

  @override
  String get reportRecipientBoardAdminSecurity => 'Zarząd / Admin + Ochrona';

  @override
  String get qrScanTitle => 'Skanuj kod QR';

  @override
  String get fabReportIssue => 'Zgłoś usterkę';

  @override
  String get fabScanQr => 'Skanuj kod QR';

  @override
  String get fabMessageToBoard => 'Wiadomość do zarządu';

  @override
  String get fabClose => 'Zamknij';

  @override
  String get buildingLabel => 'Budynek';

  @override
  String get stairwellLabel => 'Klatka';

  @override
  String get floorLabel => 'Piętro';

  @override
  String get apartmentLabel => 'Lokal';

  @override
  String get qrLocationPrefix => 'Lokalizacja zeskanowana z kodu QR:';

  @override
  String get residentSpacesTitle => 'Moje pomieszczenia';

  @override
  String get residentSpacesAddButton => 'Dodaj pomieszczenie';

  @override
  String get residentSpacesEmpty =>
      'Nie masz jeszcze dodanych pomieszczeń.\nDodaj komórkę, piwnicę lub miejsce postojowe.';

  @override
  String get residentSpacesTypeLabel => 'Typ';

  @override
  String get residentSpacesNameLabel => 'Oznaczenie';

  @override
  String get residentSpacesNameHint => 'np. K-14, poziom -1';

  @override
  String get residentSpacesTypeStorage => 'Komórka lokatorska';

  @override
  String get residentSpacesTypeBasement => 'Piwnica';

  @override
  String get residentSpacesTypeParking => 'Miejsce postojowe';

  @override
  String get residentSpacesTypeGarage => 'Garaż';

  @override
  String get residentSpacesTypeOther => 'Inne';

  @override
  String get residentSpacesDeleteConfirmTitle => 'Usuń pomieszczenie';

  @override
  String get residentSpacesDeleteConfirmMessage =>
      'Czy na pewno usunąć to pomieszczenie?';

  @override
  String get residentSpacesDelete => 'Usuń';

  @override
  String get residentSpacesSave => 'Zapisz';

  @override
  String get emptyReportsTitle => 'Brak zgłoszeń';

  @override
  String get emptyReportsBody =>
      'Wszystko działa jak należy? Nie masz jeszcze żadnych zgłoszeń awarii.';

  @override
  String get emptyReportsAction => 'Zgłoś pierwszą usterkę';

  @override
  String get emptyContactsTitle => 'Brak kontaktów';

  @override
  String get emptyContactsBody =>
      'Administrator osiedla nie dodał jeszcze kontaktów alarmowych i serwisowych.';

  @override
  String get contactsTabTitle => 'Kontakty Awaryjne';

  @override
  String get addContactTooltip => 'Dodaj kontakt';

  @override
  String get contactsCategoryAdministration => 'Administracja';

  @override
  String get contactsCategoryEmergency => 'Służby Awaryjne';

  @override
  String get contactsCategoryMaintenance => 'Serwis';

  @override
  String get contactsCategorySecurity => 'Ochrona';

  @override
  String get callButtonTooltip => 'Zadzwoń';

  @override
  String get deleteContactDialogTitle => 'Usuń kontakt';

  @override
  String deleteContactConfirmMessage(Object name) {
    return 'Czy na pewno chcesz usunąć kontakt \"$name\"?';
  }

  @override
  String get emptyAnnouncementsTitle => 'Brak ogłoszeń';

  @override
  String get emptyAnnouncementsBody =>
      'Zarząd osiedla nie opublikował jeszcze żadnych ogłoszeń.';

  @override
  String get emptyBuildingsTitle => 'Brak budynków';

  @override
  String get emptyBuildingsBody =>
      'Zacznij od dodania pierwszego budynku, aby zbudować strukturę osiedla.';

  @override
  String get emptyBuildingsAction => 'Dodaj pierwszy budynek';

  @override
  String get emptyTechReportsTitle => 'Brak zgłoszeń';

  @override
  String get emptyTechReportsBody =>
      'Kolejka serwisowa jest pusta — nie masz przypisanych ani oczekujących zgłoszeń.';

  @override
  String get residentNewLabel => 'nowe';

  @override
  String get residentInProgressLabel => 'w realizacji';

  @override
  String get residentCriticalLabel => 'pilnych';

  @override
  String get residentMyReportsCardTitle => 'Moje zgłoszenia';

  @override
  String get residentAnnouncementsCardTitle => 'Ogłoszenia';

  @override
  String get residentCommunityTitle => 'Wspólnota';

  @override
  String get residentCommunitySubtitle =>
      'Kalendarz zebrań, głosowania uchwał i komunikacja sąsiedzka.';

  @override
  String get estateHealthTitle => 'Zdrowie osiedla';

  @override
  String get estateHealthOpenReports => 'Otwarte';

  @override
  String get estateHealthOverdue => 'Po terminie';

  @override
  String get estateHealthTotal => 'Wszystkie';

  @override
  String get estateHealthNoData =>
      'Brak danych — wskaźnik zostanie obliczony po pojawieniu się pierwszych zgłoszeń.';

  @override
  String get estateHealthPrototypeLabel => '[PROTOTYP]';

  @override
  String get buildingUpdateError =>
      'Nie udało się zaktualizować budynku. Spróbuj ponownie.';

  @override
  String get buildingDeleteError =>
      'Nie udało się usunąć budynku. Spróbuj ponownie.';

  @override
  String get stairwellAddRlsError =>
      'Brak uprawnień do dodania klatki. Upewnij się, że Twoja rola to Administrator lub Zarząd w tym osiedlu.';

  @override
  String get stairwellAddError =>
      'Nie udało się dodać klatki. Spróbuj ponownie.';

  @override
  String get stairwellUpdateError =>
      'Nie udało się zaktualizować klatki. Spróbuj ponownie.';

  @override
  String get stairwellDeleteError =>
      'Nie udało się usunąć klatki. Spróbuj ponownie.';

  @override
  String get estateStructureTitle => 'Struktura Osiedla';

  @override
  String get addBuildingTooltip => 'Dodaj budynek';

  @override
  String get addGarageMenuLabel => 'Dodaj garaż';

  @override
  String get testConnectionButton => 'Test połączenia';

  @override
  String get offlineModeBanner =>
      'Tryb offline: używamy lokalnych danych. Supabase tymczasowo niedostępny.';

  @override
  String get noBuildingsMessage =>
      'Brak zdefiniowanych budynków.\nDodaj pierwszy budynek.';

  @override
  String get garageBadgeLabel => 'GARAŻ';

  @override
  String get stairwellsSectionLabel => 'KLATKI';

  @override
  String get addStairwellButton => 'Dodaj klatkę';

  @override
  String get noStairwellsMessage => 'Brak klatek. Dodaj pierwszą klatkę.';

  @override
  String get addBuildingDialogTitle => 'Dodaj budynek';

  @override
  String get editBuildingDialogTitle => 'Edytuj budynek';

  @override
  String get buildingNameLabel => 'Nazwa budynku';

  @override
  String get buildingNameHint => 'np. Budynek 1';

  @override
  String get buildingAddressLabel => 'Adres (opcjonalnie)';

  @override
  String get buildingAddressHint => 'np. ul. Słoneczna 5';

  @override
  String get cancelButton => 'Anuluj';

  @override
  String get addButton => 'Dodaj';

  @override
  String get saveButton => 'Zapisz';

  @override
  String get deleteButton => 'Usuń';

  @override
  String get deleteBuildingDialogTitle => 'Usuń budynek';

  @override
  String deleteBuildingDialogContent(Object name) {
    return 'Czy na pewno chcesz usunąć \"$name\"?\n\nWszystkie klatki w tym budynku również zostaną usunięte.';
  }

  @override
  String get addStairwellDialogTitle => 'Dodaj klatkę';

  @override
  String get editStairwellDialogTitle => 'Edytuj klatkę';

  @override
  String get stairwellNameLabel => 'Klatka';

  @override
  String stairwellNameValue(Object name) {
    return 'Klatka $name';
  }

  @override
  String get floorMinLabel => 'Najniższe piętro';

  @override
  String get floorMaxLabel => 'Najwyższe piętro';

  @override
  String get garageEntranceLabel => 'Wejście do garażu';

  @override
  String garageEntranceValue(Object label) {
    return 'Wejście $label';
  }

  @override
  String get notApplicableLabel => '—';

  @override
  String get validationFloorRangeInvalid =>
      'Najwyższe piętro musi być większe lub równe najniższemu.';

  @override
  String get deleteStairwellDialogTitle => 'Usuń klatkę';

  @override
  String deleteStairwellDialogContent(Object name) {
    return 'Czy na pewno chcesz usunąć \"$name\"?';
  }

  @override
  String stairwellFloorRange(Object min, Object max) {
    return 'Piętra $min–$max';
  }

  @override
  String get createAccountTitle => 'Stwórz nowe konto';

  @override
  String get createAccountBody =>
      'Krok 1 z 2: podaj e-mail i hasło. Po zapisaniu w kroku 2 uzupełnisz imię, telefon, adres mieszkania i ewentualny kod zaproszenia.';

  @override
  String get passwordConfirmFieldLabel => 'Potwierdź hasło';

  @override
  String get passwordsDoNotMatch => 'Hasła nie są takie same.';

  @override
  String get registerSubmitButton => 'Stwórz konto';

  @override
  String get registerConsentLabel =>
      'Akceptuję Regulamin i Politykę Prywatności oraz wyrażam zgodę na przetwarzanie moich danych osobowych.';

  @override
  String get errorTermsNotAccepted =>
      'Musisz zaakceptować Regulamin i Politykę Prywatności, aby kontynuować.';

  @override
  String get blockUserButton => 'Zablokuj użytkownika';

  @override
  String get userBlockedSnackbar => 'Użytkownik został zablokowany.';

  @override
  String get dangerZoneSectionTitle => 'Strefa niebezpieczna';

  @override
  String get deleteAccountRequiresPassword => 'Potwierdź hasło';

  @override
  String get deleteAccountPasswordLabel => 'Hasło';

  @override
  String get deleteAccountPasswordHint =>
      'Wprowadź hasło, aby potwierdzić usunięcie konta';

  @override
  String get statusNowe => 'Nowe';

  @override
  String get statusWRealizacji => 'W realizacji';

  @override
  String get statusZamkniete => 'Zamknięte';

  @override
  String get statusOdrzucone => 'Odrzucone';

  @override
  String get allFilterLabel => 'Wszystkie';

  @override
  String get noReportsMatchingFilter =>
      'Brak zgłoszeń pasujących do wybranych filtrów.';

  @override
  String get assignTo => 'Przypisz do';

  @override
  String get unassigned => 'Brak przypisania';

  @override
  String assignedToLabel(Object name, Object role) {
    return 'Przypisane do: $name ($role)';
  }

  @override
  String get logoutFeedbackTitle => 'Co sądzisz o aplikacji?';

  @override
  String get logoutFeedbackDescription =>
      'Twoja opinia pomoże nam ją ulepszać.';

  @override
  String get logoutFeedbackRateButton => 'Zostaw opinię';

  @override
  String get logoutFeedbackLogoutButton => 'Wyloguj';

  @override
  String get reportDetailScreenTitle => 'Szczegóły zgłoszenia';

  @override
  String reportDetailIdLabel(Object id) {
    return 'FX-$id';
  }

  @override
  String get priorityLow => 'Niski';

  @override
  String get priorityNormal => 'Normalny';

  @override
  String get priorityHigh => 'Wysoki';

  @override
  String get priorityCritical => 'Krytyczny';

  @override
  String get priorityLabel => 'Priorytet';

  @override
  String get slaDeadlineLabel => 'Termin SLA';

  @override
  String get slaOverdueLabel => 'Po terminie';

  @override
  String get csatTitle => 'Oceń realizację zgłoszenia';

  @override
  String get csatSubmitButton => 'Oceń';

  @override
  String get csatSubmittedSnackbar => 'Dziękujemy za ocenę!';

  @override
  String get auditTrailTitle => 'Ślad audytowy';

  @override
  String auditTrailActionStatusChange(Object user, Object status) {
    return '$user zmienił status na: $status';
  }

  @override
  String auditTrailActionPriorityChange(Object user, Object priority) {
    return '$user zmienił priorytet na: $priority';
  }

  @override
  String auditTrailActionAssign(Object user, Object assignee) {
    return '$user przypisał zgłoszenie do: $assignee';
  }

  @override
  String auditTrailActionCreate(Object user) {
    return '$user utworzył zgłoszenie';
  }

  @override
  String get serviceNotesLabel => 'Notatka serwisowa';

  @override
  String get teamNotesLabel => 'Notatki zespołu';

  @override
  String get noTeamNotes => 'Brak notatek zespołu.';

  @override
  String get photoGalleryLabel => 'Zdjęcia';

  @override
  String get reportContentButton => 'Zgłoś';

  @override
  String get reportContentDialogTitle => 'Zgłoś treść';

  @override
  String get reportContentReasonLabel => 'Powód zgłoszenia';

  @override
  String get reportContentReasonSpam => 'Spam';

  @override
  String get reportContentReasonHarassment => 'Molestowanie';

  @override
  String get reportContentReasonInappropriate => 'Nieodpowiednia treść';

  @override
  String get reportContentReasonMisinformation => 'Dezinformacja';

  @override
  String get reportContentReasonPrivacy => 'Naruszenie prywatności';

  @override
  String get reportContentReasonOther => 'Inny';

  @override
  String get reportContentDescriptionLabel => 'Dodatkowy opis (opcjonalnie)';

  @override
  String get reportContentDescriptionHint => 'Opisz problem...';

  @override
  String get reportContentSubmitButton => 'Wyślij zgłoszenie';

  @override
  String get reportContentCancelButton => 'Anuluj';

  @override
  String get reportContentSuccessSnackbar => 'Zgłoszenie zostało wysłane';

  @override
  String get errorModerationRateLimit =>
      'Osiągnąłeś limit zgłoszeń. Spróbuj później.';

  @override
  String get errorModerationAlreadyReported =>
      'Ta treść została już przez Ciebie zgłoszona.';

  @override
  String get errorModerationContentNotFound => 'Treść nie została znaleziona.';

  @override
  String get errorModerationUnauthenticated => 'Musisz być zalogowany.';

  @override
  String get errorModerationUnknown => 'Nie udało się wysłać zgłoszenia.';

  @override
  String get errorLoadingData => 'Błąd ładowania danych';

  @override
  String get retryButton => 'Spróbuj ponownie';

  @override
  String get errorLocationServiceDisabled =>
      'Usługa GPS/Lokalizacji jest wyłączona w urządzeniu.';

  @override
  String get errorLocationPermissionDenied =>
      'Brak uprawnień do odczytu lokalizacji GPS.';

  @override
  String get errorLocationPermissionDeniedForever =>
      'Uprawnienia GPS są trwale zablokowane w ustawieniach systemowych.';

  @override
  String get errorLocationUnknown => 'Nie udało się pobrać lokalizacji.';

  @override
  String get selectEstateTitle => 'Wybierz osiedle';

  @override
  String get estateCompanySectionTitle => 'Firma zarządzająca';

  @override
  String get estateCompanyNone => 'Nie skonfigurowano';

  @override
  String get estateAdminContact => 'Kontakt do administratora';

  @override
  String get estateInvitationCodeLabel => 'Kod zaproszenia';

  @override
  String get estateNoInvitationCode => 'Brak aktywnego kodu';

  @override
  String get estateContractValidUntilLabel => 'Umowa aktywna do';

  @override
  String estateContractDaysLeft(Object days) {
    return 'Pozostało $days dni';
  }

  @override
  String get estateContractExpired => 'Umowa wygasła';

  @override
  String get estateContractNone => 'Brak aktywnej umowy';

  @override
  String get dataExportButtonLabel => 'Eksportuj moje dane';

  @override
  String get dataExportDescription =>
      'Pobierz kopię wszystkich swoich danych w formacie JSON (RODO art. 20 — prawo do przenoszenia danych).';

  @override
  String get dataExportedSnackbar =>
      'Twoje dane zostały skopiowane do schowka. Wklej je do pliku tekstowego, aby je zapisać.';

  @override
  String get reportSearchHint => 'Szukaj zgłoszeń...';

  @override
  String get reportComposerTitle => 'Zgłoś Nową Awarię';

  @override
  String get reportTitleHint => 'Tytuł usterki (krótki opis)';

  @override
  String get reportDescriptionHint =>
      'Opisz uszkodzenie, dodatkowe wskazówki i lokalizację\nNp. Otwarte okno. Budynek 1, klatka A, 3 piętro. Proszę o szybką naprawę.';

  @override
  String get photoTakePhotoButton => 'Zrób Zdjęcie';

  @override
  String get photoAddMoreButton => 'Dodaj kolejne';

  @override
  String get photoGalleryButton => 'Galeria';

  @override
  String get pdfAttachButton => 'Załącz PDF';

  @override
  String get pdfSelectedLabel => 'PDF wybrany';

  @override
  String get buildingTypeLabel => 'Typ budynku';

  @override
  String get buildingTypeResidential => 'Budynek mieszkalny';

  @override
  String get buildingTypeGarage => 'Garaż';

  @override
  String get addGarageDialogTitle => 'Dodaj garaż';

  @override
  String get garageNameLabel => 'Nazwa garażu';

  @override
  String get garageNameHint => 'np. Garaż podziemny';

  @override
  String get garageFloorInfo =>
      'Piwnice/poziomy garażu zostaną dodane jako klatki z zakresem od -4 do 0.';

  @override
  String get gpsDevicePositionLabel => 'Pozycja GPS (Urządzenie):';

  @override
  String gpsLatitudeLabel(Object lat) {
    return 'Szerokość (Lat): $lat';
  }

  @override
  String gpsLongitudeLabel(Object lng) {
    return 'Długość (Lng): $lng';
  }

  @override
  String gpsSourceLabel(Object source) {
    return 'Źródło: $source';
  }

  @override
  String gpsLabelLabel(Object label) {
    return 'Etykieta: $label';
  }

  @override
  String get contactBookCardTitle => 'Książka kontaktów';

  @override
  String get contactBookCardSubtitle =>
      'Zarządzanie kontaktami alarmowymi i serwisowymi osiedla';

  @override
  String get contactBookTitle => 'Książka kontaktów';

  @override
  String get boardNotesTitle => 'Notatki zarządu';

  @override
  String get actionsSectionTitle => 'Akcje';

  @override
  String get unknownUserFallback => 'Nieznany';

  @override
  String reporterLabel(Object name) {
    return 'Zgłasza: $name';
  }

  @override
  String get collapseButton => 'Zwiń';

  @override
  String get expandButton => 'Rozwiń';

  @override
  String get sortNewest => 'Najnowsze';

  @override
  String get sortOldest => 'Najstarsze';
}
