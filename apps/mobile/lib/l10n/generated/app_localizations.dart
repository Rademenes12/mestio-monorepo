import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('pl'),
    Locale('en'),
    Locale('uk'),
  ];

  /// Technical placeholder used to bootstrap Flutter localization before migrating existing UI strings.
  ///
  /// In pl, this message translates to:
  /// **'Lokalizacja aplikacji jest skonfigurowana.'**
  String get localizationBootstrap;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In pl, this message translates to:
  /// **'Nieprawidłowy email lub hasło.'**
  String get errorInvalidCredentials;

  /// No description provided for @errorEmailNotConfirmed.
  ///
  /// In pl, this message translates to:
  /// **'Potwierdź adres email klikając w link wysłany na Twoją skrzynkę pocztową.'**
  String get errorEmailNotConfirmed;

  /// No description provided for @errorAnonymousAuthDisabled.
  ///
  /// In pl, this message translates to:
  /// **'Logowanie jako gość jest obecnie wyłączone.'**
  String get errorAnonymousAuthDisabled;

  /// No description provided for @errorEmailAlreadyRegistered.
  ///
  /// In pl, this message translates to:
  /// **'Ten adres email jest już zarejestrowany. Zaloguj się.'**
  String get errorEmailAlreadyRegistered;

  /// No description provided for @errorEmail.
  ///
  /// In pl, this message translates to:
  /// **'Sprawdź adres email i spróbuj ponownie.'**
  String get errorEmail;

  /// No description provided for @errorPassword.
  ///
  /// In pl, this message translates to:
  /// **'Sprawdź hasło i spróbuj ponownie.'**
  String get errorPassword;

  /// No description provided for @errorPasswordResetCodeRequired.
  ///
  /// In pl, this message translates to:
  /// **'Wpisz kod resetu z wiadomości email.'**
  String get errorPasswordResetCodeRequired;

  /// No description provided for @errorPasswordResetCodeInvalid.
  ///
  /// In pl, this message translates to:
  /// **'Kod resetu jest nieprawidłowy. Sprawdź go i spróbuj ponownie.'**
  String get errorPasswordResetCodeInvalid;

  /// No description provided for @errorPasswordResetCodeExpired.
  ///
  /// In pl, this message translates to:
  /// **'Kod resetu wygasł. Poproś o nowy i spróbuj ponownie.'**
  String get errorPasswordResetCodeExpired;

  /// No description provided for @errorPasswordTooShort.
  ///
  /// In pl, this message translates to:
  /// **'Użyj hasła o długości co najmniej 6 znaków.'**
  String get errorPasswordTooShort;

  /// No description provided for @errorPasswordsDoNotMatch.
  ///
  /// In pl, this message translates to:
  /// **'Hasła nie są takie same.'**
  String get errorPasswordsDoNotMatch;

  /// No description provided for @errorNetwork.
  ///
  /// In pl, this message translates to:
  /// **'Problem z połączeniem. Spróbuj ponownie.'**
  String get errorNetwork;

  /// No description provided for @errorPurchase.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się dokończyć zakupu. Spróbuj ponownie.'**
  String get errorPurchase;

  /// No description provided for @errorDeleteAccountSetupRequired.
  ///
  /// In pl, this message translates to:
  /// **'Funkcja usuwania konta nie jest wdrożona. Wdróż funkcję delete-account w Supabase Edge Functions.'**
  String get errorDeleteAccountSetupRequired;

  /// No description provided for @errorDeleteAccountFailed.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się usunąć konta. Sprawdź połączenie z internetem i spróbuj ponownie. Jeśli problem persistuje, skontaktuj się z pomocą techniczną.'**
  String get errorDeleteAccountFailed;

  /// No description provided for @errorSharedUsersSetupRequired.
  ///
  /// In pl, this message translates to:
  /// **'Brakuje tabeli shared_users albo jej schema nie zgadza się z template.'**
  String get errorSharedUsersSetupRequired;

  /// No description provided for @errorDeleteAccountNotImplemented.
  ///
  /// In pl, this message translates to:
  /// **'Usuwanie konta nie jest jeszcze gotowe.'**
  String get errorDeleteAccountNotImplemented;

  /// No description provided for @errorNoEstate.
  ///
  /// In pl, this message translates to:
  /// **'Najpierw musisz dołączyć do osiedla.'**
  String get errorNoEstate;

  /// No description provided for @errorCodeNotFoundOrExpired.
  ///
  /// In pl, this message translates to:
  /// **'Nieprawidłowy lub wygasły kod zaproszenia.'**
  String get errorCodeNotFoundOrExpired;

  /// No description provided for @errorInvalidCodeFormat.
  ///
  /// In pl, this message translates to:
  /// **'Nieprawidłowy format kodu (XXXX-XXXX-XXXX).'**
  String get errorInvalidCodeFormat;

  /// No description provided for @errorRateLimitExceeded.
  ///
  /// In pl, this message translates to:
  /// **'Zbyt wiele prób. Spróbuj ponownie za 15 minut.'**
  String get errorRateLimitExceeded;

  /// No description provided for @errorEstateInactive.
  ///
  /// In pl, this message translates to:
  /// **'To osiedle jest obecnie nieaktywne.'**
  String get errorEstateInactive;

  /// No description provided for @errorRoleLimitReached.
  ///
  /// In pl, this message translates to:
  /// **'Osiągnięto limit użytkowników dla tej roli.'**
  String get errorRoleLimitReached;

  /// No description provided for @errorApartmentLimitReached.
  ///
  /// In pl, this message translates to:
  /// **'Maksymalnie 4 osoby mogą być zarejestrowane pod tym samym lokalem.'**
  String get errorApartmentLimitReached;

  /// No description provided for @errorUnknown.
  ///
  /// In pl, this message translates to:
  /// **'Wystąpił nieoczekiwany błąd.'**
  String get errorUnknown;

  /// Fallback error message for unknown error keys.
  ///
  /// In pl, this message translates to:
  /// **'Wystąpił błąd: {errorKey}'**
  String errorWithKey(Object errorKey);

  /// No description provided for @guestDisplayName.
  ///
  /// In pl, this message translates to:
  /// **'Gość'**
  String get guestDisplayName;

  /// No description provided for @registeredUserDisplayName.
  ///
  /// In pl, this message translates to:
  /// **'Użytkownik'**
  String get registeredUserDisplayName;

  /// No description provided for @loadingLabel.
  ///
  /// In pl, this message translates to:
  /// **'Ładowanie...'**
  String get loadingLabel;

  /// No description provided for @sessionErrorTitle.
  ///
  /// In pl, this message translates to:
  /// **'Błąd sesji'**
  String get sessionErrorTitle;

  /// No description provided for @accountTypeGuest.
  ///
  /// In pl, this message translates to:
  /// **'gość'**
  String get accountTypeGuest;

  /// No description provided for @accountTypeRegistered.
  ///
  /// In pl, this message translates to:
  /// **'zalogowany'**
  String get accountTypeRegistered;

  /// No description provided for @commonYes.
  ///
  /// In pl, this message translates to:
  /// **'tak'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In pl, this message translates to:
  /// **'nie'**
  String get commonNo;

  /// No description provided for @limitAccessGuest.
  ///
  /// In pl, this message translates to:
  /// **'gość'**
  String get limitAccessGuest;

  /// No description provided for @limitAccessRegistered.
  ///
  /// In pl, this message translates to:
  /// **'zarejestrowany'**
  String get limitAccessRegistered;

  /// No description provided for @limitAccessPro.
  ///
  /// In pl, this message translates to:
  /// **'Pro'**
  String get limitAccessPro;

  /// No description provided for @homeTitle.
  ///
  /// In pl, this message translates to:
  /// **'Start'**
  String get homeTitle;

  /// No description provided for @currentSessionTitle.
  ///
  /// In pl, this message translates to:
  /// **'Aktualna sesja'**
  String get currentSessionTitle;

  /// No description provided for @sessionUserId.
  ///
  /// In pl, this message translates to:
  /// **'ID użytkownika: {value}'**
  String sessionUserId(Object value);

  /// No description provided for @sessionAccountType.
  ///
  /// In pl, this message translates to:
  /// **'Typ konta: {value}'**
  String sessionAccountType(Object value);

  /// No description provided for @sessionPro.
  ///
  /// In pl, this message translates to:
  /// **'Pro: {value}'**
  String sessionPro(Object value);

  /// No description provided for @sessionEmail.
  ///
  /// In pl, this message translates to:
  /// **'E-mail: {value}'**
  String sessionEmail(Object value);

  /// No description provided for @sessionDisplayNameValue.
  ///
  /// In pl, this message translates to:
  /// **'Nazwa wyświetlana: {value}'**
  String sessionDisplayNameValue(Object value);

  /// No description provided for @sessionFirstName.
  ///
  /// In pl, this message translates to:
  /// **'Imię: {value}'**
  String sessionFirstName(Object value);

  /// No description provided for @developerToolsTitle.
  ///
  /// In pl, this message translates to:
  /// **'Narzędzia deweloperskie'**
  String get developerToolsTitle;

  /// No description provided for @retryButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Spróbuj ponownie'**
  String get retryButtonLabel;

  /// No description provided for @welcomeTitle.
  ///
  /// In pl, this message translates to:
  /// **'Witaj w Mestio'**
  String get welcomeTitle;

  /// No description provided for @welcomeBody.
  ///
  /// In pl, this message translates to:
  /// **'Kontynuuj jako gość albo zaloguj się na istniejące konto.'**
  String get welcomeBody;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Zarządzanie zgłoszeniami w Twojej wspólnocie'**
  String get welcomeSubtitle;

  /// No description provided for @continueAsGuestButton.
  ///
  /// In pl, this message translates to:
  /// **'Kontynuuj jako gość'**
  String get continueAsGuestButton;

  /// No description provided for @continueAsGuestButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Rozpoczynamy'**
  String get continueAsGuestButtonLabel;

  /// No description provided for @loginButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Zaloguj się'**
  String get loginButtonLabel;

  /// No description provided for @loginScreenTitle.
  ///
  /// In pl, this message translates to:
  /// **'Logowanie'**
  String get loginScreenTitle;

  /// No description provided for @loginExistingAccountTitle.
  ///
  /// In pl, this message translates to:
  /// **'Zaloguj się na istniejące konto'**
  String get loginExistingAccountTitle;

  /// No description provided for @loginExistingAccountBody.
  ///
  /// In pl, this message translates to:
  /// **'Użyj adresu e-mail i hasła, aby przełączyć się na istniejące konto.'**
  String get loginExistingAccountBody;

  /// No description provided for @emailFieldLabel.
  ///
  /// In pl, this message translates to:
  /// **'E-mail'**
  String get emailFieldLabel;

  /// No description provided for @passwordFieldLabel.
  ///
  /// In pl, this message translates to:
  /// **'Hasło'**
  String get passwordFieldLabel;

  /// No description provided for @forgotPasswordButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Nie pamiętasz hasła?'**
  String get forgotPasswordButtonLabel;

  /// No description provided for @forgotPasswordScreenTitle.
  ///
  /// In pl, this message translates to:
  /// **'Reset hasła'**
  String get forgotPasswordScreenTitle;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In pl, this message translates to:
  /// **'Zresetuj hasło'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordBody.
  ///
  /// In pl, this message translates to:
  /// **'Wpisz adres e-mail, a wyślemy Ci kod resetu hasła.'**
  String get forgotPasswordBody;

  /// No description provided for @sendResetCodeButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Wyślij kod'**
  String get sendResetCodeButtonLabel;

  /// No description provided for @resetPasswordScreenTitle.
  ///
  /// In pl, this message translates to:
  /// **'Ustaw nowe hasło'**
  String get resetPasswordScreenTitle;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In pl, this message translates to:
  /// **'Wpisz kod resetu'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordBody.
  ///
  /// In pl, this message translates to:
  /// **'Wysłaliśmy kod resetu na adres {email}. Wpisz go poniżej i ustaw nowe hasło.'**
  String resetPasswordBody(Object email);

  /// No description provided for @resetCodeFieldLabel.
  ///
  /// In pl, this message translates to:
  /// **'Kod resetu'**
  String get resetCodeFieldLabel;

  /// No description provided for @confirmPasswordFieldLabel.
  ///
  /// In pl, this message translates to:
  /// **'Potwierdź nowe hasło'**
  String get confirmPasswordFieldLabel;

  /// No description provided for @resetPasswordButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Zmień hasło'**
  String get resetPasswordButtonLabel;

  /// No description provided for @passwordResetSuccessSnackbar.
  ///
  /// In pl, this message translates to:
  /// **'Hasło zostało zmienione'**
  String get passwordResetSuccessSnackbar;

  /// No description provided for @switchAccountWarningTitle.
  ///
  /// In pl, this message translates to:
  /// **'Przełączasz konto'**
  String get switchAccountWarningTitle;

  /// No description provided for @switchAccountWarningBody.
  ///
  /// In pl, this message translates to:
  /// **'Logowanie w tym miejscu przełączy Cię z obecnego konta gościa na inne konto. Dane gościa i Pro nie łączą się automatycznie.'**
  String get switchAccountWarningBody;

  /// No description provided for @registerScreenTitle.
  ///
  /// In pl, this message translates to:
  /// **'Rejestracja'**
  String get registerScreenTitle;

  /// No description provided for @secureGuestAccountTitle.
  ///
  /// In pl, this message translates to:
  /// **'Zabezpiecz to konto gościa'**
  String get secureGuestAccountTitle;

  /// No description provided for @secureGuestAccountBody.
  ///
  /// In pl, this message translates to:
  /// **'To zachowa Twoje obecne dane i połączy to konto gościa z adresem e-mail oraz hasłem.'**
  String get secureGuestAccountBody;

  /// No description provided for @registerButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Zarejestruj'**
  String get registerButtonLabel;

  /// No description provided for @profileSavedSnackbar.
  ///
  /// In pl, this message translates to:
  /// **'Profil zapisany'**
  String get profileSavedSnackbar;

  /// No description provided for @profileTitle.
  ///
  /// In pl, this message translates to:
  /// **'Profil'**
  String get profileTitle;

  /// No description provided for @profileLanguageSectionTitle.
  ///
  /// In pl, this message translates to:
  /// **'Język aplikacji'**
  String get profileLanguageSectionTitle;

  /// No description provided for @profileLanguageSectionDescription.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz, czy aplikacja ma używać języka urządzenia, polskiego, ukraińskiego czy angielskiego.'**
  String get profileLanguageSectionDescription;

  /// No description provided for @firstNameFieldLabel.
  ///
  /// In pl, this message translates to:
  /// **'Imię'**
  String get firstNameFieldLabel;

  /// No description provided for @languageOptionSystem.
  ///
  /// In pl, this message translates to:
  /// **'Automatyczny'**
  String get languageOptionSystem;

  /// No description provided for @languageOptionSystemDescription.
  ///
  /// In pl, this message translates to:
  /// **'Używa języka urządzenia. Dla nieobsługiwanych języków aplikacja wraca do English.'**
  String get languageOptionSystemDescription;

  /// No description provided for @languageOptionPolish.
  ///
  /// In pl, this message translates to:
  /// **'Polski'**
  String get languageOptionPolish;

  /// No description provided for @languageOptionEnglish.
  ///
  /// In pl, this message translates to:
  /// **'English'**
  String get languageOptionEnglish;

  /// No description provided for @languageOptionUkrainian.
  ///
  /// In pl, this message translates to:
  /// **'Українська'**
  String get languageOptionUkrainian;

  /// No description provided for @saveFirstNameButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Zapisz imię'**
  String get saveFirstNameButtonLabel;

  /// No description provided for @accountSecuredSnackbar.
  ///
  /// In pl, this message translates to:
  /// **'Konto zabezpieczone'**
  String get accountSecuredSnackbar;

  /// No description provided for @logoutButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Wyloguj się'**
  String get logoutButtonLabel;

  /// No description provided for @deleteAccountButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Usuń konto'**
  String get deleteAccountButtonLabel;

  /// No description provided for @discardChangesTitle.
  ///
  /// In pl, this message translates to:
  /// **'Odrzucić zmiany?'**
  String get discardChangesTitle;

  /// No description provided for @discardChangesBody.
  ///
  /// In pl, this message translates to:
  /// **'Masz niezapisane zmiany. Jeśli wyjdziesz teraz, zostaną utracone.'**
  String get discardChangesBody;

  /// No description provided for @stayButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Zostań'**
  String get stayButtonLabel;

  /// No description provided for @discardButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Odrzuć'**
  String get discardButtonLabel;

  /// No description provided for @closeButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Zamknij'**
  String get closeButtonLabel;

  /// No description provided for @developerDiagnosticsTitle.
  ///
  /// In pl, this message translates to:
  /// **'Diagnostyka tylko dla debug'**
  String get developerDiagnosticsTitle;

  /// No description provided for @developerDiagnosticsBody.
  ///
  /// In pl, this message translates to:
  /// **'Użyj tego ekranu, aby sprawdzić lokalną konfigurację aplikacji i status integracji.'**
  String get developerDiagnosticsBody;

  /// No description provided for @sessionSectionTitle.
  ///
  /// In pl, this message translates to:
  /// **'Sesja'**
  String get sessionSectionTitle;

  /// No description provided for @loggedInLabel.
  ///
  /// In pl, this message translates to:
  /// **'Zalogowany'**
  String get loggedInLabel;

  /// No description provided for @loggedInAsNamedLabel.
  ///
  /// In pl, this message translates to:
  /// **'Zalogowany: {name}'**
  String loggedInAsNamedLabel(Object name);

  /// No description provided for @managerDashboardTitle.
  ///
  /// In pl, this message translates to:
  /// **'Pulpit Zarządu'**
  String get managerDashboardTitle;

  /// No description provided for @adminDashboardTitle.
  ///
  /// In pl, this message translates to:
  /// **'Pulpit Administratora'**
  String get adminDashboardTitle;

  /// No description provided for @anonymousLabel.
  ///
  /// In pl, this message translates to:
  /// **'Anonimowy'**
  String get anonymousLabel;

  /// No description provided for @limitAccessLabel.
  ///
  /// In pl, this message translates to:
  /// **'Dostęp do limitów'**
  String get limitAccessLabel;

  /// No description provided for @proLabel.
  ///
  /// In pl, this message translates to:
  /// **'Pro'**
  String get proLabel;

  /// No description provided for @userIdLabel.
  ///
  /// In pl, this message translates to:
  /// **'ID użytkownika'**
  String get userIdLabel;

  /// No description provided for @emailLabel.
  ///
  /// In pl, this message translates to:
  /// **'E-mail'**
  String get emailLabel;

  /// No description provided for @displayNameLabel.
  ///
  /// In pl, this message translates to:
  /// **'Nazwa wyświetlana'**
  String get displayNameLabel;

  /// No description provided for @supabaseSectionTitle.
  ///
  /// In pl, this message translates to:
  /// **'Supabase'**
  String get supabaseSectionTitle;

  /// No description provided for @keysConfiguredLabel.
  ///
  /// In pl, this message translates to:
  /// **'Klucze skonfigurowane'**
  String get keysConfiguredLabel;

  /// No description provided for @supabaseUrlLabel.
  ///
  /// In pl, this message translates to:
  /// **'Supabase URL'**
  String get supabaseUrlLabel;

  /// No description provided for @missingValueLabel.
  ///
  /// In pl, this message translates to:
  /// **'brak'**
  String get missingValueLabel;

  /// No description provided for @storeScreenshotsSectionTitle.
  ///
  /// In pl, this message translates to:
  /// **'Store screenshots'**
  String get storeScreenshotsSectionTitle;

  /// No description provided for @storeScreenshot1ButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Screenshot 1'**
  String get storeScreenshot1ButtonLabel;

  /// No description provided for @storeScreenshot2ButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Screenshot 2'**
  String get storeScreenshot2ButtonLabel;

  /// No description provided for @storeScreenshot3ButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Screenshot 3'**
  String get storeScreenshot3ButtonLabel;

  /// No description provided for @storeScreenshot4ButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Screenshot 4'**
  String get storeScreenshot4ButtonLabel;

  /// No description provided for @storeScreenshot5ButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Screenshot 5'**
  String get storeScreenshot5ButtonLabel;

  /// No description provided for @missingSupabaseAgentPrompt.
  ///
  /// In pl, this message translates to:
  /// **'Połącz `Supabase MCP` z moim projektem Supabase i uzupełnij `config/api-keys.json` wartościami `SUPABASE_URL` oraz `SUPABASE_ANON_KEY`.'**
  String get missingSupabaseAgentPrompt;

  /// No description provided for @missingSupabaseTitle.
  ///
  /// In pl, this message translates to:
  /// **'Brakuje kluczy Supabase'**
  String get missingSupabaseTitle;

  /// No description provided for @missingSupabaseBody.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj klucze Supabase do pliku konfiguracyjnego i uruchom aplikację ponownie.'**
  String get missingSupabaseBody;

  /// No description provided for @missingSupabaseFileLabel.
  ///
  /// In pl, this message translates to:
  /// **'Uzupełnij ten plik'**
  String get missingSupabaseFileLabel;

  /// No description provided for @missingSupabaseFilePath.
  ///
  /// In pl, this message translates to:
  /// **'config/api-keys.json'**
  String get missingSupabaseFilePath;

  /// No description provided for @missingSupabaseStep1Title.
  ///
  /// In pl, this message translates to:
  /// **'Krok 1: zainstaluj `Supabase MCP`'**
  String get missingSupabaseStep1Title;

  /// No description provided for @missingSupabaseStep1Body.
  ///
  /// In pl, this message translates to:
  /// **'Najpierw dodaj `Supabase MCP` do swojego agenta AI.'**
  String get missingSupabaseStep1Body;

  /// No description provided for @missingSupabaseStep2Title.
  ///
  /// In pl, this message translates to:
  /// **'Krok 2: wklej ten prompt agentowi'**
  String get missingSupabaseStep2Title;

  /// No description provided for @copyPromptButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Kopiuj prompt'**
  String get copyPromptButtonLabel;

  /// No description provided for @promptCopiedSnackbar.
  ///
  /// In pl, this message translates to:
  /// **'Prompt skopiowany'**
  String get promptCopiedSnackbar;

  /// No description provided for @missingSupabaseStep3Title.
  ///
  /// In pl, this message translates to:
  /// **'Krok 3: zamknij i otwórz aplikację ponownie'**
  String get missingSupabaseStep3Title;

  /// No description provided for @missingSupabaseStep3Body.
  ///
  /// In pl, this message translates to:
  /// **'Gdy agent uzupełni plik z kluczami, zamknij aplikację i uruchom ją jeszcze raz.'**
  String get missingSupabaseStep3Body;

  /// No description provided for @sharedUsersAgentPrompt.
  ///
  /// In pl, this message translates to:
  /// **'Uruchom task `docs/tasks/02_SUPABASE_SHARED_USERS_SETUP.md` i doprowadź tabelę `shared_users` do minimalnej zgodności z tym projektem używając `Supabase MCP`.'**
  String get sharedUsersAgentPrompt;

  /// No description provided for @sharedUsersSetupTitle.
  ///
  /// In pl, this message translates to:
  /// **'Brakuje tabeli `shared_users` w Supabase'**
  String get sharedUsersSetupTitle;

  /// No description provided for @sharedUsersSetupBody.
  ///
  /// In pl, this message translates to:
  /// **'Aplikacja nie może wczytać dodatkowych danych użytkowników (takich jak np. imię), bo tabela `shared_users` nie istnieje albo jej struktura nie zgadza się z założeniami minimalnymi.'**
  String get sharedUsersSetupBody;

  /// No description provided for @sharedUsersGuideLabel.
  ///
  /// In pl, this message translates to:
  /// **'Skorzystaj z gotowej instrukcji:'**
  String get sharedUsersGuideLabel;

  /// No description provided for @sharedUsersGuideFile.
  ///
  /// In pl, this message translates to:
  /// **'02_SUPABASE_SHARED_USERS_SETUP.md'**
  String get sharedUsersGuideFile;

  /// No description provided for @sharedUsersAiPromptTitle.
  ///
  /// In pl, this message translates to:
  /// **'Wklej ten prompt agentowi AI'**
  String get sharedUsersAiPromptTitle;

  /// No description provided for @sharedUsersAiHelpBody.
  ///
  /// In pl, this message translates to:
  /// **'Jeżeli Twój agent AI ma dostęp do Supabase MCP, ustawi wszystko wg. przygotowanej instrukcji za Ciebie autmatycznie.'**
  String get sharedUsersAiHelpBody;

  /// No description provided for @deleteAccountConfirmationTitle.
  ///
  /// In pl, this message translates to:
  /// **'Usuń konto'**
  String get deleteAccountConfirmationTitle;

  /// No description provided for @deleteAccountPermanentWarning.
  ///
  /// In pl, this message translates to:
  /// **'Twoje konto zostanie trwale usunięte wraz ze wszystkimi danymi. Tej operacji nie można cofnąć.'**
  String get deleteAccountPermanentWarning;

  /// No description provided for @deleteAccountOtherAppsWarning.
  ///
  /// In pl, this message translates to:
  /// **'Stracisz również dostęp do następujących aplikacji:'**
  String get deleteAccountOtherAppsWarning;

  /// No description provided for @deleteAccountAppsCheckFailed.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się sprawdzić, które inne aplikacje używają tego konta. Usunięcie nadal skasuje wspólne konto Supabase i może wpłynąć na inne aplikacje tego developera.'**
  String get deleteAccountAppsCheckFailed;

  /// No description provided for @deleteAccountCheckboxLabel.
  ///
  /// In pl, this message translates to:
  /// **'Rozumiem, że dane we wszystkich aplikacjach zostaną usunięte'**
  String get deleteAccountCheckboxLabel;

  /// No description provided for @deleteAccountCheckboxLabelSimple.
  ///
  /// In pl, this message translates to:
  /// **'Rozumiem, że ta operacja jest nieodwracalna'**
  String get deleteAccountCheckboxLabelSimple;

  /// No description provided for @deleteAccountSuccessSnackbar.
  ///
  /// In pl, this message translates to:
  /// **'Konto usunięte'**
  String get deleteAccountSuccessSnackbar;

  /// No description provided for @deleteAccountConfirmButton.
  ///
  /// In pl, this message translates to:
  /// **'Usuń moje konto'**
  String get deleteAccountConfirmButton;

  /// No description provided for @connectivityLabel.
  ///
  /// In pl, this message translates to:
  /// **'Internet'**
  String get connectivityLabel;

  /// No description provided for @connectivityStatusConnected.
  ///
  /// In pl, this message translates to:
  /// **'połączony'**
  String get connectivityStatusConnected;

  /// No description provided for @connectivityStatusDisconnected.
  ///
  /// In pl, this message translates to:
  /// **'brak połączenia'**
  String get connectivityStatusDisconnected;

  /// No description provided for @connectivityStatusChecking.
  ///
  /// In pl, this message translates to:
  /// **'sprawdzanie...'**
  String get connectivityStatusChecking;

  /// Persistent banner shown at the top of the screen when the device has no internet access.
  ///
  /// In pl, this message translates to:
  /// **'Brak połączenia z internetem'**
  String get connectivityOfflineBanner;

  /// No description provided for @proLockFinanceTitle.
  ///
  /// In pl, this message translates to:
  /// **'Moduł Finansów (PRO)'**
  String get proLockFinanceTitle;

  /// No description provided for @proLockFinanceDesc.
  ///
  /// In pl, this message translates to:
  /// **'Uzyskaj dostęp do pełnego podglądu rozliczeń czynszowych, funduszu remontowego oraz historii wpłat wspólnoty.'**
  String get proLockFinanceDesc;

  /// No description provided for @proLockCommunicatorTitle.
  ///
  /// In pl, this message translates to:
  /// **'Komunikator Spółdzielni (PRO)'**
  String get proLockCommunicatorTitle;

  /// No description provided for @proLockCommunicatorDesc.
  ///
  /// In pl, this message translates to:
  /// **'Komunikuj się bezpośrednio z administracją i odbieraj spersonalizowane alerty o pracach technicznych.'**
  String get proLockCommunicatorDesc;

  /// No description provided for @proLockPhoneTitle.
  ///
  /// In pl, this message translates to:
  /// **'Telefony Alarmowe (PRO)'**
  String get proLockPhoneTitle;

  /// No description provided for @proLockPhoneDesc.
  ///
  /// In pl, this message translates to:
  /// **'Dostęp do bazy kontaktów i bezpośredniego wybierania numerów do administracji, serwisu wind oraz pogotowia technicznego.'**
  String get proLockPhoneDesc;

  /// No description provided for @proLockUnlockButton.
  ///
  /// In pl, this message translates to:
  /// **'Odblokuj wersję PRO'**
  String get proLockUnlockButton;

  /// No description provided for @estateOnboardingTitle.
  ///
  /// In pl, this message translates to:
  /// **'Dołącz do osiedla'**
  String get estateOnboardingTitle;

  /// No description provided for @estateOnboardingSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Aby korzystać z aplikacji, dołącz do osiedla kodem zaproszenia lub załóż nowe osiedle jako administrator.'**
  String get estateOnboardingSubtitle;

  /// No description provided for @estateJoinSectionTitle.
  ///
  /// In pl, this message translates to:
  /// **'Mam kod zaproszenia'**
  String get estateJoinSectionTitle;

  /// No description provided for @estateCodeFieldLabel.
  ///
  /// In pl, this message translates to:
  /// **'Kod zaproszenia'**
  String get estateCodeFieldLabel;

  /// No description provided for @estateJoinButton.
  ///
  /// In pl, this message translates to:
  /// **'Dołącz do osiedla'**
  String get estateJoinButton;

  /// No description provided for @estateCreateSectionTitle.
  ///
  /// In pl, this message translates to:
  /// **'Jestem administratorem osiedla'**
  String get estateCreateSectionTitle;

  /// No description provided for @estateNameFieldLabel.
  ///
  /// In pl, this message translates to:
  /// **'Nazwa osiedla'**
  String get estateNameFieldLabel;

  /// No description provided for @estateCreateButton.
  ///
  /// In pl, this message translates to:
  /// **'Załóż osiedle'**
  String get estateCreateButton;

  /// No description provided for @estateInvitationCodeTitle.
  ///
  /// In pl, this message translates to:
  /// **'Kod zaproszenia osiedla'**
  String get estateInvitationCodeTitle;

  /// No description provided for @addAnotherEstateMenuLabel.
  ///
  /// In pl, this message translates to:
  /// **'+ Dodaj kolejne osiedle'**
  String get addAnotherEstateMenuLabel;

  /// No description provided for @estateInvitationCodeHint.
  ///
  /// In pl, this message translates to:
  /// **'Przekaż ten kod mieszkańcom, aby mogli dołączyć do osiedla.'**
  String get estateInvitationCodeHint;

  /// No description provided for @estateGenerateCodeButton.
  ///
  /// In pl, this message translates to:
  /// **'Wygeneruj kod zaproszenia'**
  String get estateGenerateCodeButton;

  /// No description provided for @estateCopyCodeButton.
  ///
  /// In pl, this message translates to:
  /// **'Kopiuj kod'**
  String get estateCopyCodeButton;

  /// No description provided for @estateCodeCopiedSnackbar.
  ///
  /// In pl, this message translates to:
  /// **'Skopiowano kod do schowka.'**
  String get estateCodeCopiedSnackbar;

  /// No description provided for @estateJoinedSnackbar.
  ///
  /// In pl, this message translates to:
  /// **'Dołączono do osiedla.'**
  String get estateJoinedSnackbar;

  /// No description provided for @estateCreatedSnackbar.
  ///
  /// In pl, this message translates to:
  /// **'Osiedle zostało założone.'**
  String get estateCreatedSnackbar;

  /// No description provided for @estateCodeRolesSectionTitle.
  ///
  /// In pl, this message translates to:
  /// **'Kody zaproszeń per rola'**
  String get estateCodeRolesSectionTitle;

  /// No description provided for @estateRegenerateCodeButton.
  ///
  /// In pl, this message translates to:
  /// **'Wygeneruj nowy'**
  String get estateRegenerateCodeButton;

  /// No description provided for @estateRegenerateCodeTitle.
  ///
  /// In pl, this message translates to:
  /// **'Wygenerować nowy kod?'**
  String get estateRegenerateCodeTitle;

  /// No description provided for @estateRegenerateCodeBody.
  ///
  /// In pl, this message translates to:
  /// **'Poprzedni kod zostanie dezaktywowany. Kontynuować?'**
  String get estateRegenerateCodeBody;

  /// No description provided for @estateJoinRequestsTitle.
  ///
  /// In pl, this message translates to:
  /// **'Prośby o dołączenie'**
  String get estateJoinRequestsTitle;

  /// No description provided for @estateJoinRequestsEmpty.
  ///
  /// In pl, this message translates to:
  /// **'Brak oczekujących próśb'**
  String get estateJoinRequestsEmpty;

  /// No description provided for @estateApproveButton.
  ///
  /// In pl, this message translates to:
  /// **'Akceptuj'**
  String get estateApproveButton;

  /// No description provided for @estateRejectButton.
  ///
  /// In pl, this message translates to:
  /// **'Odrzuć'**
  String get estateRejectButton;

  /// No description provided for @estateJoinRequestApprovedSnackbar.
  ///
  /// In pl, this message translates to:
  /// **'Prośba zaakceptowana'**
  String get estateJoinRequestApprovedSnackbar;

  /// No description provided for @estateJoinRequestRejectedSnackbar.
  ///
  /// In pl, this message translates to:
  /// **'Prośba odrzucona'**
  String get estateJoinRequestRejectedSnackbar;

  /// No description provided for @estateAutoJoinBadge.
  ///
  /// In pl, this message translates to:
  /// **'auto'**
  String get estateAutoJoinBadge;

  /// No description provided for @estateApprovalRequiredBadge.
  ///
  /// In pl, this message translates to:
  /// **'akceptacja'**
  String get estateApprovalRequiredBadge;

  /// No description provided for @supportSectionTitle.
  ///
  /// In pl, this message translates to:
  /// **'Kontakt i wsparcie'**
  String get supportSectionTitle;

  /// No description provided for @supportSectionDescription.
  ///
  /// In pl, this message translates to:
  /// **'Masz pytanie, sugestię lub coś nie działa? Napisz do nas.'**
  String get supportSectionDescription;

  /// No description provided for @supportContactButton.
  ///
  /// In pl, this message translates to:
  /// **'Napisz do nas'**
  String get supportContactButton;

  /// No description provided for @supportEmailSubject.
  ///
  /// In pl, this message translates to:
  /// **'Mestio – zgłoszenie / sugestia'**
  String get supportEmailSubject;

  /// No description provided for @legalSectionTitle.
  ///
  /// In pl, this message translates to:
  /// **'Dokumenty prawne'**
  String get legalSectionTitle;

  /// No description provided for @legalSectionDescription.
  ///
  /// In pl, this message translates to:
  /// **'Zapoznaj się z naszą polityką prywatności i regulaminem korzystania z aplikacji.'**
  String get legalSectionDescription;

  /// No description provided for @privacyPolicyButton.
  ///
  /// In pl, this message translates to:
  /// **'Polityka prywatności'**
  String get privacyPolicyButton;

  /// No description provided for @termsOfServiceButton.
  ///
  /// In pl, this message translates to:
  /// **'Regulamin'**
  String get termsOfServiceButton;

  /// No description provided for @securityPatrolTitle.
  ///
  /// In pl, this message translates to:
  /// **'Obchód: Ochrona'**
  String get securityPatrolTitle;

  /// No description provided for @securityReportToBoardButton.
  ///
  /// In pl, this message translates to:
  /// **'⚠️ ZGŁOŚ DLA ZARZĄDU'**
  String get securityReportToBoardButton;

  /// No description provided for @securityEmergencyAlarmButton.
  ///
  /// In pl, this message translates to:
  /// **'🚨 ALARM DLA WSZYSTKICH'**
  String get securityEmergencyAlarmButton;

  /// No description provided for @securityPatrolHistoryTitle.
  ///
  /// In pl, this message translates to:
  /// **'OSTATNIE RAPORTY Z OBCHODÓW'**
  String get securityPatrolHistoryTitle;

  /// No description provided for @securityPatrolHistoryEmpty.
  ///
  /// In pl, this message translates to:
  /// **'Brak dzisiejszych wpisów.'**
  String get securityPatrolHistoryEmpty;

  /// No description provided for @navHome.
  ///
  /// In pl, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navReports.
  ///
  /// In pl, this message translates to:
  /// **'Zgłoszenia'**
  String get navReports;

  /// No description provided for @navAddReport.
  ///
  /// In pl, this message translates to:
  /// **'Zgłoś'**
  String get navAddReport;

  /// No description provided for @navPhones.
  ///
  /// In pl, this message translates to:
  /// **'Telefon'**
  String get navPhones;

  /// No description provided for @navContacts.
  ///
  /// In pl, this message translates to:
  /// **'Kontakty'**
  String get navContacts;

  /// No description provided for @navProfile.
  ///
  /// In pl, this message translates to:
  /// **'Profil'**
  String get navProfile;

  /// No description provided for @navAnnouncements.
  ///
  /// In pl, this message translates to:
  /// **'Komunikator'**
  String get navAnnouncements;

  /// No description provided for @navEstate.
  ///
  /// In pl, this message translates to:
  /// **'Osiedle'**
  String get navEstate;

  /// No description provided for @navResidents.
  ///
  /// In pl, this message translates to:
  /// **'Mieszkańcy'**
  String get navResidents;

  /// No description provided for @navResolutions.
  ///
  /// In pl, this message translates to:
  /// **'Uchwały'**
  String get navResolutions;

  /// No description provided for @residentsVisibleToBoardBadge.
  ///
  /// In pl, this message translates to:
  /// **'Widoczne dla zarządu'**
  String get residentsVisibleToBoardBadge;

  /// No description provided for @residentsHideFromBoardTooltip.
  ///
  /// In pl, this message translates to:
  /// **'Ukryj przed zarządem'**
  String get residentsHideFromBoardTooltip;

  /// No description provided for @residentsShareWithBoardTooltip.
  ///
  /// In pl, this message translates to:
  /// **'Udostępnij zarządowi'**
  String get residentsShareWithBoardTooltip;

  /// No description provided for @residentsEmptyState.
  ///
  /// In pl, this message translates to:
  /// **'Brak zarejestrowanych mieszkańców'**
  String get residentsEmptyState;

  /// No description provided for @resolutionsTitle.
  ///
  /// In pl, this message translates to:
  /// **'Uchwały'**
  String get resolutionsTitle;

  /// No description provided for @resolutionsSubtitleBoard.
  ///
  /// In pl, this message translates to:
  /// **'Twórz i zliczaj głosy mieszkańców'**
  String get resolutionsSubtitleBoard;

  /// No description provided for @resolutionsSubtitleResident.
  ///
  /// In pl, this message translates to:
  /// **'Głosuj nad uchwałami wspólnoty'**
  String get resolutionsSubtitleResident;

  /// No description provided for @resolutionsEmpty.
  ///
  /// In pl, this message translates to:
  /// **'Brak uchwał.'**
  String get resolutionsEmpty;

  /// No description provided for @resolutionStateOpen.
  ///
  /// In pl, this message translates to:
  /// **'Głosowanie trwa'**
  String get resolutionStateOpen;

  /// No description provided for @resolutionStatePassed.
  ///
  /// In pl, this message translates to:
  /// **'Przegłosowana'**
  String get resolutionStatePassed;

  /// No description provided for @resolutionStateRejected.
  ///
  /// In pl, this message translates to:
  /// **'Odrzucona'**
  String get resolutionStateRejected;

  /// No description provided for @resolutionDeadline.
  ///
  /// In pl, this message translates to:
  /// **'do {date}'**
  String resolutionDeadline(Object date);

  /// No description provided for @resolutionVoteFor.
  ///
  /// In pl, this message translates to:
  /// **'Za'**
  String get resolutionVoteFor;

  /// No description provided for @resolutionVoteAgainst.
  ///
  /// In pl, this message translates to:
  /// **'Przeciw'**
  String get resolutionVoteAgainst;

  /// No description provided for @resolutionYourVote.
  ///
  /// In pl, this message translates to:
  /// **'Twój głos: {vote}'**
  String resolutionYourVote(Object vote);

  /// No description provided for @resolutionResultsHidden.
  ///
  /// In pl, this message translates to:
  /// **'Wyniki będą widoczne po oddaniu głosu.'**
  String get resolutionResultsHidden;

  /// No description provided for @resolutionForPercent.
  ///
  /// In pl, this message translates to:
  /// **'Za {pct}%'**
  String resolutionForPercent(Object pct);

  /// No description provided for @resolutionAgainstPercent.
  ///
  /// In pl, this message translates to:
  /// **'Przeciw {pct}%'**
  String resolutionAgainstPercent(Object pct);

  /// No description provided for @resolutionVotesCount.
  ///
  /// In pl, this message translates to:
  /// **'Głosy: {count}'**
  String resolutionVotesCount(Object count);

  /// No description provided for @resolutionVoteSuccess.
  ///
  /// In pl, this message translates to:
  /// **'Twój głos: {vote}'**
  String resolutionVoteSuccess(Object vote);

  /// No description provided for @newResolutionTitle.
  ///
  /// In pl, this message translates to:
  /// **'Nowa uchwała'**
  String get newResolutionTitle;

  /// No description provided for @resolutionTitleLabel.
  ///
  /// In pl, this message translates to:
  /// **'Tytuł'**
  String get resolutionTitleLabel;

  /// No description provided for @resolutionDescriptionLabel.
  ///
  /// In pl, this message translates to:
  /// **'Opis'**
  String get resolutionDescriptionLabel;

  /// No description provided for @resolutionDeadlineLabel.
  ///
  /// In pl, this message translates to:
  /// **'Termin głosowania (opcjonalnie)'**
  String get resolutionDeadlineLabel;

  /// No description provided for @resolutionPublishButton.
  ///
  /// In pl, this message translates to:
  /// **'Opublikuj'**
  String get resolutionPublishButton;

  /// No description provided for @resolutionCancelButton.
  ///
  /// In pl, this message translates to:
  /// **'Anuluj'**
  String get resolutionCancelButton;

  /// No description provided for @resolutionCloseAsPassed.
  ///
  /// In pl, this message translates to:
  /// **'Zakończ: przegłosowana'**
  String get resolutionCloseAsPassed;

  /// No description provided for @resolutionCloseAsRejected.
  ///
  /// In pl, this message translates to:
  /// **'Zakończ: odrzucona'**
  String get resolutionCloseAsRejected;

  /// No description provided for @resolutionCreateSuccess.
  ///
  /// In pl, this message translates to:
  /// **'Uchwała opublikowana'**
  String get resolutionCreateSuccess;

  /// No description provided for @errorResolutionsLoad.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się załadować uchwał.'**
  String get errorResolutionsLoad;

  /// No description provided for @errorResolutionVote.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się oddać głosu.'**
  String get errorResolutionVote;

  /// No description provided for @errorResolutionCreate.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się opublikować uchwały.'**
  String get errorResolutionCreate;

  /// No description provided for @errorResolutionClose.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się zakończyć uchwały.'**
  String get errorResolutionClose;

  /// No description provided for @reportCloseRequiresMessageHint.
  ///
  /// In pl, this message translates to:
  /// **'Aby zamknąć lub odrzucić zgłoszenie, napisz najpierw wiadomość do mieszkańca w notatkach poniżej.'**
  String get reportCloseRequiresMessageHint;

  /// No description provided for @reportCloseRequiresMessageWarning.
  ///
  /// In pl, this message translates to:
  /// **'Najpierw napisz wiadomość do mieszkańca w notatkach poniżej ↓'**
  String get reportCloseRequiresMessageWarning;

  /// No description provided for @attachmentsLabel.
  ///
  /// In pl, this message translates to:
  /// **'Załączniki'**
  String get attachmentsLabel;

  /// No description provided for @attachmentOpenLabel.
  ///
  /// In pl, this message translates to:
  /// **'otwórz'**
  String get attachmentOpenLabel;

  /// No description provided for @attachmentOpenError.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się otworzyć załącznika.'**
  String get attachmentOpenError;

  /// No description provided for @additionalInfoLabel.
  ///
  /// In pl, this message translates to:
  /// **'Inne — informacja dla zarządu'**
  String get additionalInfoLabel;

  /// No description provided for @additionalInfoHint.
  ///
  /// In pl, this message translates to:
  /// **'np. przyjedzie policja / straż, dostęp od 8:00'**
  String get additionalInfoHint;

  /// No description provided for @markAsUrgentLabel.
  ///
  /// In pl, this message translates to:
  /// **'Oznacz jako pilne'**
  String get markAsUrgentLabel;

  /// No description provided for @notificationsPanelTitle.
  ///
  /// In pl, this message translates to:
  /// **'Powiadomienia'**
  String get notificationsPanelTitle;

  /// No description provided for @notificationsEmpty.
  ///
  /// In pl, this message translates to:
  /// **'Brak powiadomień.'**
  String get notificationsEmpty;

  /// No description provided for @notificationYourReport.
  ///
  /// In pl, this message translates to:
  /// **'Twoje zgłoszenie {id}'**
  String notificationYourReport(Object id);

  /// No description provided for @notificationCurrentStatus.
  ///
  /// In pl, this message translates to:
  /// **'Aktualny status: {status}'**
  String notificationCurrentStatus(Object status);

  /// No description provided for @notificationUrgentPrefix.
  ///
  /// In pl, this message translates to:
  /// **'Pilne: {title}'**
  String notificationUrgentPrefix(Object title);

  /// No description provided for @notificationReportPrefix.
  ///
  /// In pl, this message translates to:
  /// **'Zgłoszenie {id}'**
  String notificationReportPrefix(Object id);

  /// No description provided for @feedbackSheetTitle.
  ///
  /// In pl, this message translates to:
  /// **'Zgłoś uwagę do twórcy'**
  String get feedbackSheetTitle;

  /// No description provided for @feedbackSheetSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Coś nie działa, brakuje funkcji albo masz pomysł? Napisz — pomaga rozwijać aplikację.'**
  String get feedbackSheetSubtitle;

  /// No description provided for @feedbackTypeBug.
  ///
  /// In pl, this message translates to:
  /// **'Błąd'**
  String get feedbackTypeBug;

  /// No description provided for @feedbackTypeIdea.
  ///
  /// In pl, this message translates to:
  /// **'Pomysł'**
  String get feedbackTypeIdea;

  /// No description provided for @feedbackTypeQuestion.
  ///
  /// In pl, this message translates to:
  /// **'Pytanie'**
  String get feedbackTypeQuestion;

  /// No description provided for @feedbackMessageHint.
  ///
  /// In pl, this message translates to:
  /// **'Twoja uwaga lub pomysł…'**
  String get feedbackMessageHint;

  /// No description provided for @feedbackSendButton.
  ///
  /// In pl, this message translates to:
  /// **'Wyślij uwagę'**
  String get feedbackSendButton;

  /// No description provided for @feedbackSendError.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się otworzyć klienta pocztowego.'**
  String get feedbackSendError;

  /// No description provided for @feedbackSentSnackbar.
  ///
  /// In pl, this message translates to:
  /// **'Dziękujemy! Otworzyliśmy Twojego klienta pocztowego.'**
  String get feedbackSentSnackbar;

  /// No description provided for @maintenanceSectionTitle.
  ///
  /// In pl, this message translates to:
  /// **'Konserwacja prewencyjna'**
  String get maintenanceSectionTitle;

  /// No description provided for @maintenanceAddTooltip.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj harmonogram'**
  String get maintenanceAddTooltip;

  /// No description provided for @maintenanceEmpty.
  ///
  /// In pl, this message translates to:
  /// **'Brak zaplanowanej konserwacji.'**
  String get maintenanceEmpty;

  /// No description provided for @maintenanceNextDue.
  ///
  /// In pl, this message translates to:
  /// **'{freq} · następny: {date}'**
  String maintenanceNextDue(Object freq, Object date);

  /// No description provided for @maintenanceMarkDoneButton.
  ///
  /// In pl, this message translates to:
  /// **'Wykonano'**
  String get maintenanceMarkDoneButton;

  /// No description provided for @maintenanceFrequencyMonthly.
  ///
  /// In pl, this message translates to:
  /// **'co miesiąc'**
  String get maintenanceFrequencyMonthly;

  /// No description provided for @maintenanceFrequencyQuarterly.
  ///
  /// In pl, this message translates to:
  /// **'co kwartał'**
  String get maintenanceFrequencyQuarterly;

  /// No description provided for @maintenanceFrequencySemiAnnual.
  ///
  /// In pl, this message translates to:
  /// **'co pół roku'**
  String get maintenanceFrequencySemiAnnual;

  /// No description provided for @maintenanceFrequencyAnnual.
  ///
  /// In pl, this message translates to:
  /// **'co rok'**
  String get maintenanceFrequencyAnnual;

  /// No description provided for @maintenanceFrequencyDays.
  ///
  /// In pl, this message translates to:
  /// **'co {days} dni'**
  String maintenanceFrequencyDays(Object days);

  /// No description provided for @maintenanceNewTitle.
  ///
  /// In pl, this message translates to:
  /// **'Nowy harmonogram konserwacji'**
  String get maintenanceNewTitle;

  /// No description provided for @maintenanceNameLabel.
  ///
  /// In pl, this message translates to:
  /// **'Nazwa'**
  String get maintenanceNameLabel;

  /// No description provided for @maintenanceFrequencyLabel.
  ///
  /// In pl, this message translates to:
  /// **'Częstotliwość'**
  String get maintenanceFrequencyLabel;

  /// No description provided for @maintenanceNextDueDateLabel.
  ///
  /// In pl, this message translates to:
  /// **'Data następnego terminu'**
  String get maintenanceNextDueDateLabel;

  /// No description provided for @maintenanceSaveButton.
  ///
  /// In pl, this message translates to:
  /// **'Zapisz'**
  String get maintenanceSaveButton;

  /// No description provided for @errorMaintenanceLoad.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się załadować harmonogramu konserwacji.'**
  String get errorMaintenanceLoad;

  /// No description provided for @errorMaintenanceCreate.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się dodać harmonogramu.'**
  String get errorMaintenanceCreate;

  /// No description provided for @errorMaintenanceMark.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się zapisać wykonania.'**
  String get errorMaintenanceMark;

  /// No description provided for @correspondenceTitle.
  ///
  /// In pl, this message translates to:
  /// **'Wiadomości'**
  String get correspondenceTitle;

  /// No description provided for @correspondenceEmpty.
  ///
  /// In pl, this message translates to:
  /// **'Brak wiadomości. Napisz pierwszą wiadomość poniżej.'**
  String get correspondenceEmpty;

  /// No description provided for @correspondenceHintResident.
  ///
  /// In pl, this message translates to:
  /// **'Napisz do zarządu/administracji…'**
  String get correspondenceHintResident;

  /// No description provided for @correspondenceHintStaff.
  ///
  /// In pl, this message translates to:
  /// **'Napisz do mieszkańca…'**
  String get correspondenceHintStaff;

  /// No description provided for @teamNotesTitle.
  ///
  /// In pl, this message translates to:
  /// **'Notatki zespołu'**
  String get teamNotesTitle;

  /// No description provided for @teamNotesHiddenBadge.
  ///
  /// In pl, this message translates to:
  /// **'wewnętrzne — niewidoczne dla mieszkańca'**
  String get teamNotesHiddenBadge;

  /// No description provided for @teamNotesEmpty.
  ///
  /// In pl, this message translates to:
  /// **'Brak notatek. Dodaj pierwszą.'**
  String get teamNotesEmpty;

  /// No description provided for @teamNotesInputHint.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj notatkę zespołu…'**
  String get teamNotesInputHint;

  /// No description provided for @photosSelectedCount.
  ///
  /// In pl, this message translates to:
  /// **'Zdjęcia: {count} — dodaj kolejne'**
  String photosSelectedCount(Object count);

  /// No description provided for @galleryLabel.
  ///
  /// In pl, this message translates to:
  /// **'Zdjęcia ({count})'**
  String galleryLabel(Object count);

  /// No description provided for @sendAnnouncementFormTitle.
  ///
  /// In pl, this message translates to:
  /// **'WYŚLIJ KOMUNIKAT DO MIESZKAŃCÓW'**
  String get sendAnnouncementFormTitle;

  /// No description provided for @announcementTitleLabel.
  ///
  /// In pl, this message translates to:
  /// **'Tytuł ogłoszenia'**
  String get announcementTitleLabel;

  /// No description provided for @announcementTitleHint.
  ///
  /// In pl, this message translates to:
  /// **'np. Konserwacja windy'**
  String get announcementTitleHint;

  /// No description provided for @announcementContentLabel.
  ///
  /// In pl, this message translates to:
  /// **'Treść komunikatu'**
  String get announcementContentLabel;

  /// No description provided for @announcementContentHint.
  ///
  /// In pl, this message translates to:
  /// **'Wpisz szczegółową treść komunikatu...'**
  String get announcementContentHint;

  /// No description provided for @announcementExpiryLabel.
  ///
  /// In pl, this message translates to:
  /// **'Wygasa dnia (opcjonalnie):'**
  String get announcementExpiryLabel;

  /// No description provided for @dayLabel.
  ///
  /// In pl, this message translates to:
  /// **'Dzień'**
  String get dayLabel;

  /// No description provided for @monthLabel.
  ///
  /// In pl, this message translates to:
  /// **'Miesiąc'**
  String get monthLabel;

  /// No description provided for @yearLabel.
  ///
  /// In pl, this message translates to:
  /// **'Rok'**
  String get yearLabel;

  /// No description provided for @sendAnnouncementButton.
  ///
  /// In pl, this message translates to:
  /// **'WYŚLIJ KOMUNIKAT'**
  String get sendAnnouncementButton;

  /// No description provided for @sentAnnouncementsTitle.
  ///
  /// In pl, this message translates to:
  /// **'WYSŁANE OGŁOSZENIA'**
  String get sentAnnouncementsTitle;

  /// No description provided for @announcementExpiresOnLabel.
  ///
  /// In pl, this message translates to:
  /// **'Wygasa: {date}'**
  String announcementExpiresOnLabel(Object date);

  /// No description provided for @announcementExpiredSuffix.
  ///
  /// In pl, this message translates to:
  /// **'{date} (wygasł)'**
  String announcementExpiredSuffix(Object date);

  /// No description provided for @deleteAnnouncementTooltip.
  ///
  /// In pl, this message translates to:
  /// **'Usuń komunikat'**
  String get deleteAnnouncementTooltip;

  /// No description provided for @announcementSentSnackbar.
  ///
  /// In pl, this message translates to:
  /// **'Komunikat został wysłany!'**
  String get announcementSentSnackbar;

  /// No description provided for @announcementPushNotificationPrefix.
  ///
  /// In pl, this message translates to:
  /// **'KOMUNIKAT: {title}'**
  String announcementPushNotificationPrefix(Object title);

  /// No description provided for @announcementScopeLabel.
  ///
  /// In pl, this message translates to:
  /// **'Zakres — wybierz odbiorców'**
  String get announcementScopeLabel;

  /// No description provided for @announcementScopeEstate.
  ///
  /// In pl, this message translates to:
  /// **'Wszyscy mieszkańcy'**
  String get announcementScopeEstate;

  /// No description provided for @announcementScopeBuilding.
  ///
  /// In pl, this message translates to:
  /// **'Budynek {name}'**
  String announcementScopeBuilding(Object name);

  /// No description provided for @announcementScopeStairwell.
  ///
  /// In pl, this message translates to:
  /// **'Klatka {stairwell} ({building})'**
  String announcementScopeStairwell(Object stairwell, Object building);

  /// No description provided for @residentGreetingMorning.
  ///
  /// In pl, this message translates to:
  /// **'Dzień dobry,'**
  String get residentGreetingMorning;

  /// No description provided for @residentGreetingFallback.
  ///
  /// In pl, this message translates to:
  /// **'Mieszkańcu'**
  String get residentGreetingFallback;

  /// No description provided for @residentSystemsOK.
  ///
  /// In pl, this message translates to:
  /// **'Wszystkie systemy OK'**
  String get residentSystemsOK;

  /// No description provided for @residentAddressUnknown.
  ///
  /// In pl, this message translates to:
  /// **'Lokalizacja niezweryfikowana'**
  String get residentAddressUnknown;

  /// No description provided for @latestAnnouncementHeader.
  ///
  /// In pl, this message translates to:
  /// **'Najnowsze ogłoszenie'**
  String get latestAnnouncementHeader;

  /// No description provided for @activeReportsHeader.
  ///
  /// In pl, this message translates to:
  /// **'Aktywne zgłoszenia'**
  String get activeReportsHeader;

  /// No description provided for @noActiveReports.
  ///
  /// In pl, this message translates to:
  /// **'Nie masz żadnych aktywnych zgłoszeń.'**
  String get noActiveReports;

  /// No description provided for @seeAllReports.
  ///
  /// In pl, this message translates to:
  /// **'Zobacz wszystkie zgłoszenia'**
  String get seeAllReports;

  /// No description provided for @residentReportsTitle.
  ///
  /// In pl, this message translates to:
  /// **'Twoje Zgłoszenia'**
  String get residentReportsTitle;

  /// No description provided for @residentReportsListHeader.
  ///
  /// In pl, this message translates to:
  /// **'TWOJE ZGŁOSZENIA'**
  String get residentReportsListHeader;

  /// No description provided for @noReportsYet.
  ///
  /// In pl, this message translates to:
  /// **'Brak zgłoszonych awarii.'**
  String get noReportsYet;

  /// No description provided for @syncOfflineButton.
  ///
  /// In pl, this message translates to:
  /// **'Synchronizuj Offline Cache'**
  String get syncOfflineButton;

  /// No description provided for @profileUserTitle.
  ///
  /// In pl, this message translates to:
  /// **'Profil Użytkownika'**
  String get profileUserTitle;

  /// No description provided for @addressLabel.
  ///
  /// In pl, this message translates to:
  /// **'Adres zamieszkania:'**
  String get addressLabel;

  /// No description provided for @roleLabel.
  ///
  /// In pl, this message translates to:
  /// **'Rola: {role}'**
  String roleLabel(Object role);

  /// No description provided for @estateJoinIntro.
  ///
  /// In pl, this message translates to:
  /// **'Nie należysz jeszcze do żadnego osiedla. Wpisz kod zaproszenia otrzymany od administratora.'**
  String get estateJoinIntro;

  /// No description provided for @estateJoinedInfo.
  ///
  /// In pl, this message translates to:
  /// **'Jesteś członkiem osiedla. Twoje zgłoszenia i komunikaty są powiązane z tym osiedlem.'**
  String get estateJoinedInfo;

  /// No description provided for @estateJoinedNamedSnackbar.
  ///
  /// In pl, this message translates to:
  /// **'Dołączono do osiedla „{name}\".'**
  String estateJoinedNamedSnackbar(Object name);

  /// No description provided for @estateInvalidCode.
  ///
  /// In pl, this message translates to:
  /// **'Kod jest nieprawidłowy lub nieaktywny.'**
  String get estateInvalidCode;

  /// No description provided for @joinEstateButton.
  ///
  /// In pl, this message translates to:
  /// **'Dołącz do osiedla'**
  String get joinEstateButton;

  /// No description provided for @joiningEstate.
  ///
  /// In pl, this message translates to:
  /// **'Łączenie…'**
  String get joiningEstate;

  /// No description provided for @supportContactTitle.
  ///
  /// In pl, this message translates to:
  /// **'Kontakt / Wsparcie'**
  String get supportContactTitle;

  /// No description provided for @reportAddedSnackbar.
  ///
  /// In pl, this message translates to:
  /// **'Zgłoszenie dodane pomyślnie!'**
  String get reportAddedSnackbar;

  /// No description provided for @submitReportButton.
  ///
  /// In pl, this message translates to:
  /// **'Wyślij Zgłoszenie'**
  String get submitReportButton;

  /// No description provided for @reportTitleRequiredSnackbar.
  ///
  /// In pl, this message translates to:
  /// **'Podaj tytuł zgłoszenia!'**
  String get reportTitleRequiredSnackbar;

  /// No description provided for @lockScreenTitle.
  ///
  /// In pl, this message translates to:
  /// **'Rejestracja Lokatora'**
  String get lockScreenTitle;

  /// No description provided for @lockScreenResidentSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Wskaż swoją klatkę i numer mieszkania. Dzięki temu będziesz otrzymywać dedykowane powiadomienia o awariach w Twojej okolicy.'**
  String get lockScreenResidentSubtitle;

  /// No description provided for @lockScreenStaffSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Wprowadź swoje dane i kod zaproszenia otrzymany od administratora.'**
  String get lockScreenStaffSubtitle;

  /// No description provided for @fullNameFieldLabel.
  ///
  /// In pl, this message translates to:
  /// **'Imię i Nazwisko'**
  String get fullNameFieldLabel;

  /// No description provided for @fullNameRequired.
  ///
  /// In pl, this message translates to:
  /// **'Wpisz imię i nazwisko'**
  String get fullNameRequired;

  /// No description provided for @emailRequired.
  ///
  /// In pl, this message translates to:
  /// **'Wpisz adres e-mail'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In pl, this message translates to:
  /// **'Niepoprawny adres e-mail'**
  String get emailInvalid;

  /// No description provided for @phoneFieldLabel.
  ///
  /// In pl, this message translates to:
  /// **'Numer telefonu'**
  String get phoneFieldLabel;

  /// No description provided for @phoneFieldLabelRequired.
  ///
  /// In pl, this message translates to:
  /// **'Numer telefonu (wymagany)'**
  String get phoneFieldLabelRequired;

  /// No description provided for @phoneRequired.
  ///
  /// In pl, this message translates to:
  /// **'Numer telefonu jest wymagany'**
  String get phoneRequired;

  /// No description provided for @phoneInvalid.
  ///
  /// In pl, this message translates to:
  /// **'Numer telefonu jest za krótki'**
  String get phoneInvalid;

  /// No description provided for @codeInvalid.
  ///
  /// In pl, this message translates to:
  /// **'Nieprawidłowy kod zaproszenia'**
  String get codeInvalid;

  /// No description provided for @locationSectionLabel.
  ///
  /// In pl, this message translates to:
  /// **'Szczegóły Lokalizacji Mieszkania:'**
  String get locationSectionLabel;

  /// No description provided for @buildingFieldLabel.
  ///
  /// In pl, this message translates to:
  /// **'Budynek'**
  String get buildingFieldLabel;

  /// No description provided for @footbridgeFieldLabel.
  ///
  /// In pl, this message translates to:
  /// **'Klatka / Pion'**
  String get footbridgeFieldLabel;

  /// No description provided for @floorFieldLabel.
  ///
  /// In pl, this message translates to:
  /// **'Piętro'**
  String get floorFieldLabel;

  /// No description provided for @apartmentFieldLabel.
  ///
  /// In pl, this message translates to:
  /// **'Mieszkanie'**
  String get apartmentFieldLabel;

  /// No description provided for @requiredFieldShort.
  ///
  /// In pl, this message translates to:
  /// **'Wymagane'**
  String get requiredFieldShort;

  /// No description provided for @technicianLoggedInNamed.
  ///
  /// In pl, this message translates to:
  /// **'Serwis: {name}'**
  String technicianLoggedInNamed(Object name);

  /// No description provided for @technicianLoggedInFallback.
  ///
  /// In pl, this message translates to:
  /// **'Zalogowany Serwis'**
  String get technicianLoggedInFallback;

  /// No description provided for @showClosedToggleLabel.
  ///
  /// In pl, this message translates to:
  /// **'Pokaż zamknięte'**
  String get showClosedToggleLabel;

  /// No description provided for @reporterInfoLabel.
  ///
  /// In pl, this message translates to:
  /// **'Zgłaszający: {name} ({email})'**
  String reporterInfoLabel(Object name, Object email);

  /// No description provided for @reportLocationInfoLabel.
  ///
  /// In pl, this message translates to:
  /// **'Lokalizacja: {location}'**
  String reportLocationInfoLabel(Object location);

  /// No description provided for @reportDescriptionInfoLabel.
  ///
  /// In pl, this message translates to:
  /// **'Opis: {description}'**
  String reportDescriptionInfoLabel(Object description);

  /// No description provided for @reportTileSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'#{displayId}, Klatka {footbridge}\nBudynek {building}, Piętro {floor}'**
  String reportTileSubtitle(
    Object displayId,
    Object footbridge,
    Object building,
    Object floor,
  );

  /// No description provided for @syncedToServerLabel.
  ///
  /// In pl, this message translates to:
  /// **'Zsynchronizowano z bazą'**
  String get syncedToServerLabel;

  /// No description provided for @savedOfflineLabel.
  ///
  /// In pl, this message translates to:
  /// **'Zapisano lokalnie (offline)'**
  String get savedOfflineLabel;

  /// No description provided for @technicianNoteTitle.
  ///
  /// In pl, this message translates to:
  /// **'🛠️ Notatka Serwisowa:'**
  String get technicianNoteTitle;

  /// No description provided for @stairwellAbbreviationLabel.
  ///
  /// In pl, this message translates to:
  /// **'kl. {name}'**
  String stairwellAbbreviationLabel(Object name);

  /// No description provided for @apartmentAbbreviationLabel.
  ///
  /// In pl, this message translates to:
  /// **'m. {number}'**
  String apartmentAbbreviationLabel(Object number);

  /// No description provided for @detailsButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Szczegóły'**
  String get detailsButtonLabel;

  /// No description provided for @technicianDeleteAccountWarning.
  ///
  /// In pl, this message translates to:
  /// **'Ta operacja jest nieodwracalna — wszystkie Twoje dane zostaną trwale usunięte.'**
  String get technicianDeleteAccountWarning;

  /// No description provided for @technicianPhoneLabel.
  ///
  /// In pl, this message translates to:
  /// **'Tel: {phone}'**
  String technicianPhoneLabel(Object phone);

  /// No description provided for @deleteAccountSectionTitle.
  ///
  /// In pl, this message translates to:
  /// **'Usuwanie konta'**
  String get deleteAccountSectionTitle;

  /// No description provided for @codeFieldLabelRequired.
  ///
  /// In pl, this message translates to:
  /// **'Kod zaproszenia'**
  String get codeFieldLabelRequired;

  /// No description provided for @codeRequired.
  ///
  /// In pl, this message translates to:
  /// **'Wprowadź kod zaproszenia'**
  String get codeRequired;

  /// No description provided for @codeExplanation.
  ///
  /// In pl, this message translates to:
  /// **'Kod otrzymasz od zarządu lub administratora osiedla. Kod określa Twoją rolę — nie wybiera się jej ręcznie.'**
  String get codeExplanation;

  /// No description provided for @stepBasicDataTitle.
  ///
  /// In pl, this message translates to:
  /// **'Dane podstawowe'**
  String get stepBasicDataTitle;

  /// No description provided for @stepLocationTitle.
  ///
  /// In pl, this message translates to:
  /// **'Lokalizacja'**
  String get stepLocationTitle;

  /// No description provided for @stepSummaryTitle.
  ///
  /// In pl, this message translates to:
  /// **'Podsumowanie'**
  String get stepSummaryTitle;

  /// No description provided for @technicianCompanyTitle.
  ///
  /// In pl, this message translates to:
  /// **'Dane firmy / serwisanta'**
  String get technicianCompanyTitle;

  /// No description provided for @technicianCompanyLabel.
  ///
  /// In pl, this message translates to:
  /// **'Nazwa serwisanta / firmy'**
  String get technicianCompanyLabel;

  /// No description provided for @technicianCompanyRequired.
  ///
  /// In pl, this message translates to:
  /// **'Nazwa firmy/serwisanta jest wymagana'**
  String get technicianCompanyRequired;

  /// No description provided for @backButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Wstecz'**
  String get backButtonLabel;

  /// No description provided for @nextButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Dalej'**
  String get nextButtonLabel;

  /// No description provided for @confirmAndOpenButton.
  ///
  /// In pl, this message translates to:
  /// **'Potwierdź i Otwórz Aplikację'**
  String get confirmAndOpenButton;

  /// No description provided for @regSummaryRoleLabel.
  ///
  /// In pl, this message translates to:
  /// **'Rola'**
  String get regSummaryRoleLabel;

  /// No description provided for @regSummaryEstateLabel.
  ///
  /// In pl, this message translates to:
  /// **'Osiedle'**
  String get regSummaryEstateLabel;

  /// No description provided for @regSummaryNameLabel.
  ///
  /// In pl, this message translates to:
  /// **'Imię i nazwisko'**
  String get regSummaryNameLabel;

  /// No description provided for @regSummaryLocationLabel.
  ///
  /// In pl, this message translates to:
  /// **'Lokal'**
  String get regSummaryLocationLabel;

  /// No description provided for @regSummaryCompanyLabel.
  ///
  /// In pl, this message translates to:
  /// **'Firma / serwisant'**
  String get regSummaryCompanyLabel;

  /// No description provided for @regResidentJoinNote.
  ///
  /// In pl, this message translates to:
  /// **'Po rejestracji od razu dołączysz do osiedla.'**
  String get regResidentJoinNote;

  /// No description provided for @regPendingApprovalNote.
  ///
  /// In pl, this message translates to:
  /// **'Po rejestracji Twoja prośba trafi do administratora. Otrzymasz powiadomienie po akceptacji.'**
  String get regPendingApprovalNote;

  /// No description provided for @pendingApprovalTitle.
  ///
  /// In pl, this message translates to:
  /// **'Oczekuje na akceptację'**
  String get pendingApprovalTitle;

  /// No description provided for @pendingApprovalBody.
  ///
  /// In pl, this message translates to:
  /// **'Twoja prośba o dołączenie do osiedla „{estateName}” jako {role} została wysłana. Administrator zaakceptuje ją wkrótce.'**
  String pendingApprovalBody(Object estateName, Object role);

  /// No description provided for @pendingApprovalRefreshButton.
  ///
  /// In pl, this message translates to:
  /// **'Sprawdź status'**
  String get pendingApprovalRefreshButton;

  /// No description provided for @addContactDialogTitle.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj kontakt'**
  String get addContactDialogTitle;

  /// No description provided for @addContactNameLabel.
  ///
  /// In pl, this message translates to:
  /// **'Nazwa kontaktu'**
  String get addContactNameLabel;

  /// No description provided for @addContactNameHelper.
  ///
  /// In pl, this message translates to:
  /// **'Np. Biuro Zarządcy, Pogotowie Hydrauliczne'**
  String get addContactNameHelper;

  /// No description provided for @addContactRoleLabel.
  ///
  /// In pl, this message translates to:
  /// **'Stanowisko / rola'**
  String get addContactRoleLabel;

  /// No description provided for @addContactRoleHelper.
  ///
  /// In pl, this message translates to:
  /// **'Np. Administrator osiedla, Elektryk. Wyświetli się pod nazwą.'**
  String get addContactRoleHelper;

  /// No description provided for @addContactPhoneLabel.
  ///
  /// In pl, this message translates to:
  /// **'Telefon'**
  String get addContactPhoneLabel;

  /// No description provided for @addContactEmailLabel.
  ///
  /// In pl, this message translates to:
  /// **'E-mail (opcjonalny)'**
  String get addContactEmailLabel;

  /// No description provided for @addContactCategoryLabel.
  ///
  /// In pl, this message translates to:
  /// **'Kategoria'**
  String get addContactCategoryLabel;

  /// No description provided for @addContactCancelButton.
  ///
  /// In pl, this message translates to:
  /// **'Anuluj'**
  String get addContactCancelButton;

  /// No description provided for @addContactAddButton.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj'**
  String get addContactAddButton;

  /// No description provided for @buildingAddRlsError.
  ///
  /// In pl, this message translates to:
  /// **'Brak uprawnień do dodania budynku. Upewnij się, że Twoja rola to Administrator lub Zarząd w tym osiedlu.'**
  String get buildingAddRlsError;

  /// No description provided for @buildingAddNetworkError.
  ///
  /// In pl, this message translates to:
  /// **'Brak połączenia z serwerem. Sprawdź internet i spróbuj ponownie.'**
  String get buildingAddNetworkError;

  /// No description provided for @buildingAddError.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się dodać budynku. Spróbuj ponownie.'**
  String get buildingAddError;

  /// No description provided for @reportCategoryLabel.
  ///
  /// In pl, this message translates to:
  /// **'Kategoria'**
  String get reportCategoryLabel;

  /// No description provided for @reportCategoryHydraulika.
  ///
  /// In pl, this message translates to:
  /// **'Hydraulika'**
  String get reportCategoryHydraulika;

  /// No description provided for @reportCategoryElektryka.
  ///
  /// In pl, this message translates to:
  /// **'Elektryka'**
  String get reportCategoryElektryka;

  /// No description provided for @reportCategoryWinda.
  ///
  /// In pl, this message translates to:
  /// **'Winda'**
  String get reportCategoryWinda;

  /// No description provided for @reportCategoryOgrzewanie.
  ///
  /// In pl, this message translates to:
  /// **'Ogrzewanie'**
  String get reportCategoryOgrzewanie;

  /// No description provided for @reportCategoryDomofon.
  ///
  /// In pl, this message translates to:
  /// **'Domofon'**
  String get reportCategoryDomofon;

  /// No description provided for @reportCategoryOswietlenie.
  ///
  /// In pl, this message translates to:
  /// **'Oświetlenie'**
  String get reportCategoryOswietlenie;

  /// No description provided for @reportCategoryParking.
  ///
  /// In pl, this message translates to:
  /// **'Parking'**
  String get reportCategoryParking;

  /// No description provided for @reportCategoryGaraz.
  ///
  /// In pl, this message translates to:
  /// **'Garaż'**
  String get reportCategoryGaraz;

  /// No description provided for @reportCategoryDachElewacja.
  ///
  /// In pl, this message translates to:
  /// **'Dach/Elewacja'**
  String get reportCategoryDachElewacja;

  /// No description provided for @reportCategorySprzatanie.
  ///
  /// In pl, this message translates to:
  /// **'Sprzątanie'**
  String get reportCategorySprzatanie;

  /// No description provided for @reportCategoryZielen.
  ///
  /// In pl, this message translates to:
  /// **'Zieleń'**
  String get reportCategoryZielen;

  /// No description provided for @reportCategoryZarzadAdministrator.
  ///
  /// In pl, this message translates to:
  /// **'Zarząd / Administrator'**
  String get reportCategoryZarzadAdministrator;

  /// No description provided for @reportRecipientBoardAdminService.
  ///
  /// In pl, this message translates to:
  /// **'Zarząd / Admin + Serwis'**
  String get reportRecipientBoardAdminService;

  /// No description provided for @reportRecipientBoardAdminSecurity.
  ///
  /// In pl, this message translates to:
  /// **'Zarząd / Admin + Ochrona'**
  String get reportRecipientBoardAdminSecurity;

  /// No description provided for @qrScanTitle.
  ///
  /// In pl, this message translates to:
  /// **'Skanuj kod QR'**
  String get qrScanTitle;

  /// No description provided for @fabReportIssue.
  ///
  /// In pl, this message translates to:
  /// **'Zgłoś usterkę'**
  String get fabReportIssue;

  /// No description provided for @fabScanQr.
  ///
  /// In pl, this message translates to:
  /// **'Skanuj kod QR'**
  String get fabScanQr;

  /// No description provided for @fabMessageToBoard.
  ///
  /// In pl, this message translates to:
  /// **'Wiadomość do zarządu'**
  String get fabMessageToBoard;

  /// No description provided for @fabClose.
  ///
  /// In pl, this message translates to:
  /// **'Zamknij'**
  String get fabClose;

  /// No description provided for @buildingLabel.
  ///
  /// In pl, this message translates to:
  /// **'Budynek'**
  String get buildingLabel;

  /// No description provided for @stairwellLabel.
  ///
  /// In pl, this message translates to:
  /// **'Klatka'**
  String get stairwellLabel;

  /// No description provided for @floorLabel.
  ///
  /// In pl, this message translates to:
  /// **'Piętro'**
  String get floorLabel;

  /// No description provided for @apartmentLabel.
  ///
  /// In pl, this message translates to:
  /// **'Lokal'**
  String get apartmentLabel;

  /// No description provided for @qrLocationPrefix.
  ///
  /// In pl, this message translates to:
  /// **'Lokalizacja zeskanowana z kodu QR:'**
  String get qrLocationPrefix;

  /// No description provided for @residentSpacesTitle.
  ///
  /// In pl, this message translates to:
  /// **'Moje pomieszczenia'**
  String get residentSpacesTitle;

  /// No description provided for @residentSpacesAddButton.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj pomieszczenie'**
  String get residentSpacesAddButton;

  /// No description provided for @residentSpacesEmpty.
  ///
  /// In pl, this message translates to:
  /// **'Nie masz jeszcze dodanych pomieszczeń.\nDodaj komórkę, piwnicę lub miejsce postojowe.'**
  String get residentSpacesEmpty;

  /// No description provided for @residentSpacesTypeLabel.
  ///
  /// In pl, this message translates to:
  /// **'Typ'**
  String get residentSpacesTypeLabel;

  /// No description provided for @residentSpacesNameLabel.
  ///
  /// In pl, this message translates to:
  /// **'Oznaczenie'**
  String get residentSpacesNameLabel;

  /// No description provided for @residentSpacesNameHint.
  ///
  /// In pl, this message translates to:
  /// **'np. K-14, poziom -1'**
  String get residentSpacesNameHint;

  /// No description provided for @residentSpacesTypeStorage.
  ///
  /// In pl, this message translates to:
  /// **'Komórka lokatorska'**
  String get residentSpacesTypeStorage;

  /// No description provided for @residentSpacesTypeBasement.
  ///
  /// In pl, this message translates to:
  /// **'Piwnica'**
  String get residentSpacesTypeBasement;

  /// No description provided for @residentSpacesTypeParking.
  ///
  /// In pl, this message translates to:
  /// **'Miejsce postojowe'**
  String get residentSpacesTypeParking;

  /// No description provided for @residentSpacesTypeGarage.
  ///
  /// In pl, this message translates to:
  /// **'Garaż'**
  String get residentSpacesTypeGarage;

  /// No description provided for @residentSpacesTypeOther.
  ///
  /// In pl, this message translates to:
  /// **'Inne'**
  String get residentSpacesTypeOther;

  /// No description provided for @residentSpacesDeleteConfirmTitle.
  ///
  /// In pl, this message translates to:
  /// **'Usuń pomieszczenie'**
  String get residentSpacesDeleteConfirmTitle;

  /// No description provided for @residentSpacesDeleteConfirmMessage.
  ///
  /// In pl, this message translates to:
  /// **'Czy na pewno usunąć to pomieszczenie?'**
  String get residentSpacesDeleteConfirmMessage;

  /// No description provided for @residentSpacesDelete.
  ///
  /// In pl, this message translates to:
  /// **'Usuń'**
  String get residentSpacesDelete;

  /// No description provided for @residentSpacesSave.
  ///
  /// In pl, this message translates to:
  /// **'Zapisz'**
  String get residentSpacesSave;

  /// No description provided for @emptyReportsTitle.
  ///
  /// In pl, this message translates to:
  /// **'Brak zgłoszeń'**
  String get emptyReportsTitle;

  /// No description provided for @emptyReportsBody.
  ///
  /// In pl, this message translates to:
  /// **'Wszystko działa jak należy? Nie masz jeszcze żadnych zgłoszeń awarii.'**
  String get emptyReportsBody;

  /// No description provided for @emptyReportsAction.
  ///
  /// In pl, this message translates to:
  /// **'Zgłoś pierwszą usterkę'**
  String get emptyReportsAction;

  /// No description provided for @emptyContactsTitle.
  ///
  /// In pl, this message translates to:
  /// **'Brak kontaktów'**
  String get emptyContactsTitle;

  /// No description provided for @emptyContactsBody.
  ///
  /// In pl, this message translates to:
  /// **'Administrator osiedla nie dodał jeszcze kontaktów alarmowych i serwisowych.'**
  String get emptyContactsBody;

  /// No description provided for @contactsTabTitle.
  ///
  /// In pl, this message translates to:
  /// **'Kontakty Awaryjne'**
  String get contactsTabTitle;

  /// No description provided for @addContactTooltip.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj kontakt'**
  String get addContactTooltip;

  /// No description provided for @contactsCategoryAdministration.
  ///
  /// In pl, this message translates to:
  /// **'Administracja'**
  String get contactsCategoryAdministration;

  /// No description provided for @contactsCategoryEmergency.
  ///
  /// In pl, this message translates to:
  /// **'Służby Awaryjne'**
  String get contactsCategoryEmergency;

  /// No description provided for @contactsCategoryMaintenance.
  ///
  /// In pl, this message translates to:
  /// **'Serwis'**
  String get contactsCategoryMaintenance;

  /// No description provided for @contactsCategorySecurity.
  ///
  /// In pl, this message translates to:
  /// **'Ochrona'**
  String get contactsCategorySecurity;

  /// No description provided for @callButtonTooltip.
  ///
  /// In pl, this message translates to:
  /// **'Zadzwoń'**
  String get callButtonTooltip;

  /// No description provided for @deleteContactDialogTitle.
  ///
  /// In pl, this message translates to:
  /// **'Usuń kontakt'**
  String get deleteContactDialogTitle;

  /// No description provided for @deleteContactConfirmMessage.
  ///
  /// In pl, this message translates to:
  /// **'Czy na pewno chcesz usunąć kontakt \"{name}\"?'**
  String deleteContactConfirmMessage(Object name);

  /// No description provided for @emptyAnnouncementsTitle.
  ///
  /// In pl, this message translates to:
  /// **'Brak ogłoszeń'**
  String get emptyAnnouncementsTitle;

  /// No description provided for @emptyAnnouncementsBody.
  ///
  /// In pl, this message translates to:
  /// **'Zarząd osiedla nie opublikował jeszcze żadnych ogłoszeń.'**
  String get emptyAnnouncementsBody;

  /// No description provided for @emptyBuildingsTitle.
  ///
  /// In pl, this message translates to:
  /// **'Brak budynków'**
  String get emptyBuildingsTitle;

  /// No description provided for @emptyBuildingsBody.
  ///
  /// In pl, this message translates to:
  /// **'Zacznij od dodania pierwszego budynku, aby zbudować strukturę osiedla.'**
  String get emptyBuildingsBody;

  /// No description provided for @emptyBuildingsAction.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj pierwszy budynek'**
  String get emptyBuildingsAction;

  /// No description provided for @emptyTechReportsTitle.
  ///
  /// In pl, this message translates to:
  /// **'Brak zgłoszeń'**
  String get emptyTechReportsTitle;

  /// No description provided for @emptyTechReportsBody.
  ///
  /// In pl, this message translates to:
  /// **'Kolejka serwisowa jest pusta — nie masz przypisanych ani oczekujących zgłoszeń.'**
  String get emptyTechReportsBody;

  /// No description provided for @residentNewLabel.
  ///
  /// In pl, this message translates to:
  /// **'nowe'**
  String get residentNewLabel;

  /// No description provided for @residentInProgressLabel.
  ///
  /// In pl, this message translates to:
  /// **'w realizacji'**
  String get residentInProgressLabel;

  /// No description provided for @residentCriticalLabel.
  ///
  /// In pl, this message translates to:
  /// **'pilnych'**
  String get residentCriticalLabel;

  /// No description provided for @residentMyReportsCardTitle.
  ///
  /// In pl, this message translates to:
  /// **'Moje zgłoszenia'**
  String get residentMyReportsCardTitle;

  /// No description provided for @residentAnnouncementsCardTitle.
  ///
  /// In pl, this message translates to:
  /// **'Ogłoszenia'**
  String get residentAnnouncementsCardTitle;

  /// No description provided for @residentCommunityTitle.
  ///
  /// In pl, this message translates to:
  /// **'Wspólnota'**
  String get residentCommunityTitle;

  /// No description provided for @residentCommunitySubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Kalendarz zebrań, głosowania uchwał i komunikacja sąsiedzka.'**
  String get residentCommunitySubtitle;

  /// No description provided for @estateHealthTitle.
  ///
  /// In pl, this message translates to:
  /// **'Zdrowie osiedla'**
  String get estateHealthTitle;

  /// No description provided for @estateHealthOpenReports.
  ///
  /// In pl, this message translates to:
  /// **'Otwarte'**
  String get estateHealthOpenReports;

  /// No description provided for @estateHealthOverdue.
  ///
  /// In pl, this message translates to:
  /// **'Po terminie'**
  String get estateHealthOverdue;

  /// No description provided for @estateHealthTotal.
  ///
  /// In pl, this message translates to:
  /// **'Wszystkie'**
  String get estateHealthTotal;

  /// No description provided for @estateHealthNoData.
  ///
  /// In pl, this message translates to:
  /// **'Brak danych — wskaźnik zostanie obliczony po pojawieniu się pierwszych zgłoszeń.'**
  String get estateHealthNoData;

  /// No description provided for @estateHealthPrototypeLabel.
  ///
  /// In pl, this message translates to:
  /// **'[PROTOTYP]'**
  String get estateHealthPrototypeLabel;

  /// No description provided for @buildingUpdateError.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się zaktualizować budynku. Spróbuj ponownie.'**
  String get buildingUpdateError;

  /// No description provided for @buildingDeleteError.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się usunąć budynku. Spróbuj ponownie.'**
  String get buildingDeleteError;

  /// No description provided for @stairwellAddRlsError.
  ///
  /// In pl, this message translates to:
  /// **'Brak uprawnień do dodania klatki. Upewnij się, że Twoja rola to Administrator lub Zarząd w tym osiedlu.'**
  String get stairwellAddRlsError;

  /// No description provided for @stairwellAddError.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się dodać klatki. Spróbuj ponownie.'**
  String get stairwellAddError;

  /// No description provided for @stairwellUpdateError.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się zaktualizować klatki. Spróbuj ponownie.'**
  String get stairwellUpdateError;

  /// No description provided for @stairwellDeleteError.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się usunąć klatki. Spróbuj ponownie.'**
  String get stairwellDeleteError;

  /// No description provided for @estateStructureTitle.
  ///
  /// In pl, this message translates to:
  /// **'Struktura Osiedla'**
  String get estateStructureTitle;

  /// No description provided for @addBuildingTooltip.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj budynek'**
  String get addBuildingTooltip;

  /// No description provided for @addGarageMenuLabel.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj garaż'**
  String get addGarageMenuLabel;

  /// No description provided for @testConnectionButton.
  ///
  /// In pl, this message translates to:
  /// **'Test połączenia'**
  String get testConnectionButton;

  /// No description provided for @offlineModeBanner.
  ///
  /// In pl, this message translates to:
  /// **'Tryb offline: używamy lokalnych danych. Supabase tymczasowo niedostępny.'**
  String get offlineModeBanner;

  /// No description provided for @noBuildingsMessage.
  ///
  /// In pl, this message translates to:
  /// **'Brak zdefiniowanych budynków.\nDodaj pierwszy budynek.'**
  String get noBuildingsMessage;

  /// No description provided for @garageBadgeLabel.
  ///
  /// In pl, this message translates to:
  /// **'GARAŻ'**
  String get garageBadgeLabel;

  /// No description provided for @stairwellsSectionLabel.
  ///
  /// In pl, this message translates to:
  /// **'KLATKI'**
  String get stairwellsSectionLabel;

  /// No description provided for @addStairwellButton.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj klatkę'**
  String get addStairwellButton;

  /// No description provided for @noStairwellsMessage.
  ///
  /// In pl, this message translates to:
  /// **'Brak klatek. Dodaj pierwszą klatkę.'**
  String get noStairwellsMessage;

  /// No description provided for @addBuildingDialogTitle.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj budynek'**
  String get addBuildingDialogTitle;

  /// No description provided for @editBuildingDialogTitle.
  ///
  /// In pl, this message translates to:
  /// **'Edytuj budynek'**
  String get editBuildingDialogTitle;

  /// No description provided for @buildingNameLabel.
  ///
  /// In pl, this message translates to:
  /// **'Nazwa budynku'**
  String get buildingNameLabel;

  /// No description provided for @buildingNameHint.
  ///
  /// In pl, this message translates to:
  /// **'np. Budynek 1'**
  String get buildingNameHint;

  /// No description provided for @buildingAddressLabel.
  ///
  /// In pl, this message translates to:
  /// **'Adres (opcjonalnie)'**
  String get buildingAddressLabel;

  /// No description provided for @buildingAddressHint.
  ///
  /// In pl, this message translates to:
  /// **'np. ul. Słoneczna 5'**
  String get buildingAddressHint;

  /// No description provided for @cancelButton.
  ///
  /// In pl, this message translates to:
  /// **'Anuluj'**
  String get cancelButton;

  /// No description provided for @addButton.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj'**
  String get addButton;

  /// No description provided for @saveButton.
  ///
  /// In pl, this message translates to:
  /// **'Zapisz'**
  String get saveButton;

  /// No description provided for @deleteButton.
  ///
  /// In pl, this message translates to:
  /// **'Usuń'**
  String get deleteButton;

  /// No description provided for @deleteBuildingDialogTitle.
  ///
  /// In pl, this message translates to:
  /// **'Usuń budynek'**
  String get deleteBuildingDialogTitle;

  /// No description provided for @deleteBuildingDialogContent.
  ///
  /// In pl, this message translates to:
  /// **'Czy na pewno chcesz usunąć \"{name}\"?\n\nWszystkie klatki w tym budynku również zostaną usunięte.'**
  String deleteBuildingDialogContent(Object name);

  /// No description provided for @addStairwellDialogTitle.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj klatkę'**
  String get addStairwellDialogTitle;

  /// No description provided for @editStairwellDialogTitle.
  ///
  /// In pl, this message translates to:
  /// **'Edytuj klatkę'**
  String get editStairwellDialogTitle;

  /// No description provided for @stairwellNameLabel.
  ///
  /// In pl, this message translates to:
  /// **'Klatka'**
  String get stairwellNameLabel;

  /// No description provided for @stairwellNameValue.
  ///
  /// In pl, this message translates to:
  /// **'Klatka {name}'**
  String stairwellNameValue(Object name);

  /// No description provided for @floorMinLabel.
  ///
  /// In pl, this message translates to:
  /// **'Najniższe piętro'**
  String get floorMinLabel;

  /// No description provided for @floorMaxLabel.
  ///
  /// In pl, this message translates to:
  /// **'Najwyższe piętro'**
  String get floorMaxLabel;

  /// No description provided for @garageEntranceLabel.
  ///
  /// In pl, this message translates to:
  /// **'Wejście do garażu'**
  String get garageEntranceLabel;

  /// No description provided for @garageEntranceValue.
  ///
  /// In pl, this message translates to:
  /// **'Wejście {label}'**
  String garageEntranceValue(Object label);

  /// No description provided for @notApplicableLabel.
  ///
  /// In pl, this message translates to:
  /// **'—'**
  String get notApplicableLabel;

  /// No description provided for @validationFloorRangeInvalid.
  ///
  /// In pl, this message translates to:
  /// **'Najwyższe piętro musi być większe lub równe najniższemu.'**
  String get validationFloorRangeInvalid;

  /// No description provided for @deleteStairwellDialogTitle.
  ///
  /// In pl, this message translates to:
  /// **'Usuń klatkę'**
  String get deleteStairwellDialogTitle;

  /// No description provided for @deleteStairwellDialogContent.
  ///
  /// In pl, this message translates to:
  /// **'Czy na pewno chcesz usunąć \"{name}\"?'**
  String deleteStairwellDialogContent(Object name);

  /// No description provided for @stairwellFloorRange.
  ///
  /// In pl, this message translates to:
  /// **'Piętra {min}–{max}'**
  String stairwellFloorRange(Object min, Object max);

  /// No description provided for @createAccountTitle.
  ///
  /// In pl, this message translates to:
  /// **'Stwórz nowe konto'**
  String get createAccountTitle;

  /// No description provided for @createAccountBody.
  ///
  /// In pl, this message translates to:
  /// **'Krok 1 z 2: podaj e-mail i hasło. Po zapisaniu w kroku 2 uzupełnisz imię, telefon, adres mieszkania i ewentualny kod zaproszenia.'**
  String get createAccountBody;

  /// No description provided for @passwordConfirmFieldLabel.
  ///
  /// In pl, this message translates to:
  /// **'Potwierdź hasło'**
  String get passwordConfirmFieldLabel;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In pl, this message translates to:
  /// **'Hasła nie są takie same.'**
  String get passwordsDoNotMatch;

  /// No description provided for @registerSubmitButton.
  ///
  /// In pl, this message translates to:
  /// **'Stwórz konto'**
  String get registerSubmitButton;

  /// No description provided for @registerConsentLabel.
  ///
  /// In pl, this message translates to:
  /// **'Akceptuję Regulamin i Politykę Prywatności oraz wyrażam zgodę na przetwarzanie moich danych osobowych.'**
  String get registerConsentLabel;

  /// No description provided for @errorTermsNotAccepted.
  ///
  /// In pl, this message translates to:
  /// **'Musisz zaakceptować Regulamin i Politykę Prywatności, aby kontynuować.'**
  String get errorTermsNotAccepted;

  /// No description provided for @blockUserButton.
  ///
  /// In pl, this message translates to:
  /// **'Zablokuj użytkownika'**
  String get blockUserButton;

  /// No description provided for @userBlockedSnackbar.
  ///
  /// In pl, this message translates to:
  /// **'Użytkownik został zablokowany.'**
  String get userBlockedSnackbar;

  /// No description provided for @dangerZoneSectionTitle.
  ///
  /// In pl, this message translates to:
  /// **'Strefa niebezpieczna'**
  String get dangerZoneSectionTitle;

  /// No description provided for @deleteAccountRequiresPassword.
  ///
  /// In pl, this message translates to:
  /// **'Potwierdź hasło'**
  String get deleteAccountRequiresPassword;

  /// No description provided for @deleteAccountPasswordLabel.
  ///
  /// In pl, this message translates to:
  /// **'Hasło'**
  String get deleteAccountPasswordLabel;

  /// No description provided for @deleteAccountPasswordHint.
  ///
  /// In pl, this message translates to:
  /// **'Wprowadź hasło, aby potwierdzić usunięcie konta'**
  String get deleteAccountPasswordHint;

  /// No description provided for @statusNowe.
  ///
  /// In pl, this message translates to:
  /// **'Nowe'**
  String get statusNowe;

  /// No description provided for @statusWRealizacji.
  ///
  /// In pl, this message translates to:
  /// **'W realizacji'**
  String get statusWRealizacji;

  /// No description provided for @statusZamkniete.
  ///
  /// In pl, this message translates to:
  /// **'Zamknięte'**
  String get statusZamkniete;

  /// No description provided for @statusOdrzucone.
  ///
  /// In pl, this message translates to:
  /// **'Odrzucone'**
  String get statusOdrzucone;

  /// No description provided for @allFilterLabel.
  ///
  /// In pl, this message translates to:
  /// **'Wszystkie'**
  String get allFilterLabel;

  /// No description provided for @noReportsMatchingFilter.
  ///
  /// In pl, this message translates to:
  /// **'Brak zgłoszeń pasujących do wybranych filtrów.'**
  String get noReportsMatchingFilter;

  /// No description provided for @assignTo.
  ///
  /// In pl, this message translates to:
  /// **'Przypisz do'**
  String get assignTo;

  /// No description provided for @unassigned.
  ///
  /// In pl, this message translates to:
  /// **'Brak przypisania'**
  String get unassigned;

  /// No description provided for @assignedToLabel.
  ///
  /// In pl, this message translates to:
  /// **'Przypisane do: {name} ({role})'**
  String assignedToLabel(Object name, Object role);

  /// No description provided for @logoutFeedbackTitle.
  ///
  /// In pl, this message translates to:
  /// **'Co sądzisz o aplikacji?'**
  String get logoutFeedbackTitle;

  /// No description provided for @logoutFeedbackDescription.
  ///
  /// In pl, this message translates to:
  /// **'Twoja opinia pomoże nam ją ulepszać.'**
  String get logoutFeedbackDescription;

  /// No description provided for @logoutFeedbackRateButton.
  ///
  /// In pl, this message translates to:
  /// **'Zostaw opinię'**
  String get logoutFeedbackRateButton;

  /// No description provided for @logoutFeedbackLogoutButton.
  ///
  /// In pl, this message translates to:
  /// **'Wyloguj'**
  String get logoutFeedbackLogoutButton;

  /// No description provided for @reportDetailScreenTitle.
  ///
  /// In pl, this message translates to:
  /// **'Szczegóły zgłoszenia'**
  String get reportDetailScreenTitle;

  /// No description provided for @reportDetailIdLabel.
  ///
  /// In pl, this message translates to:
  /// **'FX-{id}'**
  String reportDetailIdLabel(Object id);

  /// No description provided for @priorityLow.
  ///
  /// In pl, this message translates to:
  /// **'Niski'**
  String get priorityLow;

  /// No description provided for @priorityNormal.
  ///
  /// In pl, this message translates to:
  /// **'Normalny'**
  String get priorityNormal;

  /// No description provided for @priorityHigh.
  ///
  /// In pl, this message translates to:
  /// **'Wysoki'**
  String get priorityHigh;

  /// No description provided for @priorityCritical.
  ///
  /// In pl, this message translates to:
  /// **'Krytyczny'**
  String get priorityCritical;

  /// No description provided for @priorityLabel.
  ///
  /// In pl, this message translates to:
  /// **'Priorytet'**
  String get priorityLabel;

  /// No description provided for @slaDeadlineLabel.
  ///
  /// In pl, this message translates to:
  /// **'Termin SLA'**
  String get slaDeadlineLabel;

  /// No description provided for @slaOverdueLabel.
  ///
  /// In pl, this message translates to:
  /// **'Po terminie'**
  String get slaOverdueLabel;

  /// No description provided for @csatTitle.
  ///
  /// In pl, this message translates to:
  /// **'Oceń realizację zgłoszenia'**
  String get csatTitle;

  /// No description provided for @csatSubmitButton.
  ///
  /// In pl, this message translates to:
  /// **'Oceń'**
  String get csatSubmitButton;

  /// No description provided for @csatSubmittedSnackbar.
  ///
  /// In pl, this message translates to:
  /// **'Dziękujemy za ocenę!'**
  String get csatSubmittedSnackbar;

  /// No description provided for @auditTrailTitle.
  ///
  /// In pl, this message translates to:
  /// **'Ślad audytowy'**
  String get auditTrailTitle;

  /// No description provided for @auditTrailActionStatusChange.
  ///
  /// In pl, this message translates to:
  /// **'{user} zmienił status na: {status}'**
  String auditTrailActionStatusChange(Object user, Object status);

  /// No description provided for @auditTrailActionPriorityChange.
  ///
  /// In pl, this message translates to:
  /// **'{user} zmienił priorytet na: {priority}'**
  String auditTrailActionPriorityChange(Object user, Object priority);

  /// No description provided for @auditTrailActionAssign.
  ///
  /// In pl, this message translates to:
  /// **'{user} przypisał zgłoszenie do: {assignee}'**
  String auditTrailActionAssign(Object user, Object assignee);

  /// No description provided for @auditTrailActionCreate.
  ///
  /// In pl, this message translates to:
  /// **'{user} utworzył zgłoszenie'**
  String auditTrailActionCreate(Object user);

  /// No description provided for @serviceNotesLabel.
  ///
  /// In pl, this message translates to:
  /// **'Notatka serwisowa'**
  String get serviceNotesLabel;

  /// No description provided for @teamNotesLabel.
  ///
  /// In pl, this message translates to:
  /// **'Notatki zespołu'**
  String get teamNotesLabel;

  /// No description provided for @noTeamNotes.
  ///
  /// In pl, this message translates to:
  /// **'Brak notatek zespołu.'**
  String get noTeamNotes;

  /// No description provided for @photoGalleryLabel.
  ///
  /// In pl, this message translates to:
  /// **'Zdjęcia'**
  String get photoGalleryLabel;

  /// No description provided for @reportContentButton.
  ///
  /// In pl, this message translates to:
  /// **'Zgłoś'**
  String get reportContentButton;

  /// No description provided for @reportContentDialogTitle.
  ///
  /// In pl, this message translates to:
  /// **'Zgłoś treść'**
  String get reportContentDialogTitle;

  /// No description provided for @reportContentReasonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Powód zgłoszenia'**
  String get reportContentReasonLabel;

  /// No description provided for @reportContentReasonSpam.
  ///
  /// In pl, this message translates to:
  /// **'Spam'**
  String get reportContentReasonSpam;

  /// No description provided for @reportContentReasonHarassment.
  ///
  /// In pl, this message translates to:
  /// **'Molestowanie'**
  String get reportContentReasonHarassment;

  /// No description provided for @reportContentReasonInappropriate.
  ///
  /// In pl, this message translates to:
  /// **'Nieodpowiednia treść'**
  String get reportContentReasonInappropriate;

  /// No description provided for @reportContentReasonMisinformation.
  ///
  /// In pl, this message translates to:
  /// **'Dezinformacja'**
  String get reportContentReasonMisinformation;

  /// No description provided for @reportContentReasonPrivacy.
  ///
  /// In pl, this message translates to:
  /// **'Naruszenie prywatności'**
  String get reportContentReasonPrivacy;

  /// No description provided for @reportContentReasonOther.
  ///
  /// In pl, this message translates to:
  /// **'Inny'**
  String get reportContentReasonOther;

  /// No description provided for @reportContentDescriptionLabel.
  ///
  /// In pl, this message translates to:
  /// **'Dodatkowy opis (opcjonalnie)'**
  String get reportContentDescriptionLabel;

  /// No description provided for @reportContentDescriptionHint.
  ///
  /// In pl, this message translates to:
  /// **'Opisz problem...'**
  String get reportContentDescriptionHint;

  /// No description provided for @reportContentSubmitButton.
  ///
  /// In pl, this message translates to:
  /// **'Wyślij zgłoszenie'**
  String get reportContentSubmitButton;

  /// No description provided for @reportContentCancelButton.
  ///
  /// In pl, this message translates to:
  /// **'Anuluj'**
  String get reportContentCancelButton;

  /// No description provided for @reportContentSuccessSnackbar.
  ///
  /// In pl, this message translates to:
  /// **'Zgłoszenie zostało wysłane'**
  String get reportContentSuccessSnackbar;

  /// No description provided for @errorModerationRateLimit.
  ///
  /// In pl, this message translates to:
  /// **'Osiągnąłeś limit zgłoszeń. Spróbuj później.'**
  String get errorModerationRateLimit;

  /// No description provided for @errorModerationAlreadyReported.
  ///
  /// In pl, this message translates to:
  /// **'Ta treść została już przez Ciebie zgłoszona.'**
  String get errorModerationAlreadyReported;

  /// No description provided for @errorModerationContentNotFound.
  ///
  /// In pl, this message translates to:
  /// **'Treść nie została znaleziona.'**
  String get errorModerationContentNotFound;

  /// No description provided for @errorModerationUnauthenticated.
  ///
  /// In pl, this message translates to:
  /// **'Musisz być zalogowany.'**
  String get errorModerationUnauthenticated;

  /// No description provided for @errorModerationUnknown.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się wysłać zgłoszenia.'**
  String get errorModerationUnknown;

  /// No description provided for @errorLoadingData.
  ///
  /// In pl, this message translates to:
  /// **'Błąd ładowania danych'**
  String get errorLoadingData;

  /// No description provided for @retryButton.
  ///
  /// In pl, this message translates to:
  /// **'Spróbuj ponownie'**
  String get retryButton;

  /// No description provided for @errorLocationServiceDisabled.
  ///
  /// In pl, this message translates to:
  /// **'Usługa GPS/Lokalizacji jest wyłączona w urządzeniu.'**
  String get errorLocationServiceDisabled;

  /// No description provided for @errorLocationPermissionDenied.
  ///
  /// In pl, this message translates to:
  /// **'Brak uprawnień do odczytu lokalizacji GPS.'**
  String get errorLocationPermissionDenied;

  /// No description provided for @errorLocationPermissionDeniedForever.
  ///
  /// In pl, this message translates to:
  /// **'Uprawnienia GPS są trwale zablokowane w ustawieniach systemowych.'**
  String get errorLocationPermissionDeniedForever;

  /// No description provided for @errorLocationUnknown.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się pobrać lokalizacji.'**
  String get errorLocationUnknown;

  /// No description provided for @selectEstateTitle.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz osiedle'**
  String get selectEstateTitle;

  /// No description provided for @estateCompanySectionTitle.
  ///
  /// In pl, this message translates to:
  /// **'Firma zarządzająca'**
  String get estateCompanySectionTitle;

  /// No description provided for @estateCompanyNone.
  ///
  /// In pl, this message translates to:
  /// **'Nie skonfigurowano'**
  String get estateCompanyNone;

  /// No description provided for @estateAdminContact.
  ///
  /// In pl, this message translates to:
  /// **'Kontakt do administratora'**
  String get estateAdminContact;

  /// No description provided for @estateInvitationCodeLabel.
  ///
  /// In pl, this message translates to:
  /// **'Kod zaproszenia'**
  String get estateInvitationCodeLabel;

  /// No description provided for @estateNoInvitationCode.
  ///
  /// In pl, this message translates to:
  /// **'Brak aktywnego kodu'**
  String get estateNoInvitationCode;

  /// No description provided for @estateContractValidUntilLabel.
  ///
  /// In pl, this message translates to:
  /// **'Umowa aktywna do'**
  String get estateContractValidUntilLabel;

  /// No description provided for @estateContractDaysLeft.
  ///
  /// In pl, this message translates to:
  /// **'Pozostało {days} dni'**
  String estateContractDaysLeft(Object days);

  /// No description provided for @estateContractExpired.
  ///
  /// In pl, this message translates to:
  /// **'Umowa wygasła'**
  String get estateContractExpired;

  /// No description provided for @estateContractNone.
  ///
  /// In pl, this message translates to:
  /// **'Brak aktywnej umowy'**
  String get estateContractNone;

  /// No description provided for @dataExportButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Eksportuj moje dane'**
  String get dataExportButtonLabel;

  /// No description provided for @dataExportDescription.
  ///
  /// In pl, this message translates to:
  /// **'Pobierz kopię wszystkich swoich danych w formacie JSON (RODO art. 20 — prawo do przenoszenia danych).'**
  String get dataExportDescription;

  /// No description provided for @dataExportedSnackbar.
  ///
  /// In pl, this message translates to:
  /// **'Twoje dane zostały skopiowane do schowka. Wklej je do pliku tekstowego, aby je zapisać.'**
  String get dataExportedSnackbar;

  /// No description provided for @reportSearchHint.
  ///
  /// In pl, this message translates to:
  /// **'Szukaj zgłoszeń...'**
  String get reportSearchHint;

  /// No description provided for @reportComposerTitle.
  ///
  /// In pl, this message translates to:
  /// **'Zgłoś Nową Awarię'**
  String get reportComposerTitle;

  /// No description provided for @reportTitleHint.
  ///
  /// In pl, this message translates to:
  /// **'Tytuł usterki (krótki opis)'**
  String get reportTitleHint;

  /// No description provided for @reportDescriptionHint.
  ///
  /// In pl, this message translates to:
  /// **'Opisz uszkodzenie, dodatkowe wskazówki i lokalizację\nNp. Otwarte okno. Budynek 1, klatka A, 3 piętro. Proszę o szybką naprawę.'**
  String get reportDescriptionHint;

  /// No description provided for @photoTakePhotoButton.
  ///
  /// In pl, this message translates to:
  /// **'Zrób Zdjęcie'**
  String get photoTakePhotoButton;

  /// No description provided for @photoAddMoreButton.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj kolejne'**
  String get photoAddMoreButton;

  /// No description provided for @photoGalleryButton.
  ///
  /// In pl, this message translates to:
  /// **'Galeria'**
  String get photoGalleryButton;

  /// No description provided for @pdfAttachButton.
  ///
  /// In pl, this message translates to:
  /// **'Załącz PDF'**
  String get pdfAttachButton;

  /// No description provided for @pdfSelectedLabel.
  ///
  /// In pl, this message translates to:
  /// **'PDF wybrany'**
  String get pdfSelectedLabel;

  /// No description provided for @buildingTypeLabel.
  ///
  /// In pl, this message translates to:
  /// **'Typ budynku'**
  String get buildingTypeLabel;

  /// No description provided for @buildingTypeResidential.
  ///
  /// In pl, this message translates to:
  /// **'Budynek mieszkalny'**
  String get buildingTypeResidential;

  /// No description provided for @buildingTypeGarage.
  ///
  /// In pl, this message translates to:
  /// **'Garaż'**
  String get buildingTypeGarage;

  /// No description provided for @addGarageDialogTitle.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj garaż'**
  String get addGarageDialogTitle;

  /// No description provided for @garageNameLabel.
  ///
  /// In pl, this message translates to:
  /// **'Nazwa garażu'**
  String get garageNameLabel;

  /// No description provided for @garageNameHint.
  ///
  /// In pl, this message translates to:
  /// **'np. Garaż podziemny'**
  String get garageNameHint;

  /// No description provided for @garageFloorInfo.
  ///
  /// In pl, this message translates to:
  /// **'Piwnice/poziomy garażu zostaną dodane jako klatki z zakresem od -4 do 0.'**
  String get garageFloorInfo;

  /// No description provided for @gpsDevicePositionLabel.
  ///
  /// In pl, this message translates to:
  /// **'Pozycja GPS (Urządzenie):'**
  String get gpsDevicePositionLabel;

  /// No description provided for @gpsLatitudeLabel.
  ///
  /// In pl, this message translates to:
  /// **'Szerokość (Lat): {lat}'**
  String gpsLatitudeLabel(Object lat);

  /// No description provided for @gpsLongitudeLabel.
  ///
  /// In pl, this message translates to:
  /// **'Długość (Lng): {lng}'**
  String gpsLongitudeLabel(Object lng);

  /// No description provided for @gpsSourceLabel.
  ///
  /// In pl, this message translates to:
  /// **'Źródło: {source}'**
  String gpsSourceLabel(Object source);

  /// No description provided for @gpsLabelLabel.
  ///
  /// In pl, this message translates to:
  /// **'Etykieta: {label}'**
  String gpsLabelLabel(Object label);

  /// No description provided for @contactBookCardTitle.
  ///
  /// In pl, this message translates to:
  /// **'Książka kontaktów'**
  String get contactBookCardTitle;

  /// No description provided for @contactBookCardSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Zarządzanie kontaktami alarmowymi i serwisowymi osiedla'**
  String get contactBookCardSubtitle;

  /// No description provided for @contactBookTitle.
  ///
  /// In pl, this message translates to:
  /// **'Książka kontaktów'**
  String get contactBookTitle;

  /// No description provided for @boardNotesTitle.
  ///
  /// In pl, this message translates to:
  /// **'Notatki zarządu'**
  String get boardNotesTitle;

  /// No description provided for @actionsSectionTitle.
  ///
  /// In pl, this message translates to:
  /// **'Akcje'**
  String get actionsSectionTitle;

  /// No description provided for @unknownUserFallback.
  ///
  /// In pl, this message translates to:
  /// **'Nieznany'**
  String get unknownUserFallback;

  /// No description provided for @reporterLabel.
  ///
  /// In pl, this message translates to:
  /// **'Zgłasza: {name}'**
  String reporterLabel(Object name);

  /// No description provided for @collapseButton.
  ///
  /// In pl, this message translates to:
  /// **'Zwiń'**
  String get collapseButton;

  /// No description provided for @expandButton.
  ///
  /// In pl, this message translates to:
  /// **'Rozwiń'**
  String get expandButton;

  /// No description provided for @sortNewest.
  ///
  /// In pl, this message translates to:
  /// **'Najnowsze'**
  String get sortNewest;

  /// No description provided for @sortOldest.
  ///
  /// In pl, this message translates to:
  /// **'Najstarsze'**
  String get sortOldest;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pl', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pl':
      return AppLocalizationsPl();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
