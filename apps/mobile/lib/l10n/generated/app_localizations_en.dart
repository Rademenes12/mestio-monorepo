// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get localizationBootstrap => 'App localization is configured.';

  @override
  String get errorInvalidCredentials => 'Invalid email or password.';

  @override
  String get errorEmailNotConfirmed =>
      'Please confirm your email by clicking the link sent to your inbox.';

  @override
  String get errorAnonymousAuthDisabled =>
      'Guest sign-in is currently disabled.';

  @override
  String get errorEmailAlreadyRegistered =>
      'This email is already registered. Log in instead.';

  @override
  String get errorEmail => 'Check the email address and try again.';

  @override
  String get errorPassword => 'Check the password and try again.';

  @override
  String get errorPasswordResetCodeRequired =>
      'Enter the reset code from the email.';

  @override
  String get errorPasswordResetCodeInvalid =>
      'The reset code is invalid. Check it and try again.';

  @override
  String get errorPasswordResetCodeExpired =>
      'The reset code has expired. Request a new one and try again.';

  @override
  String get errorPasswordTooShort =>
      'Use a password with at least 6 characters.';

  @override
  String get errorPasswordsDoNotMatch => 'The passwords do not match.';

  @override
  String get errorNetwork => 'Connection problem. Try again.';

  @override
  String get errorPurchase => 'Could not complete the purchase. Try again.';

  @override
  String get errorDeleteAccountSetupRequired =>
      'Delete account still requires additional Supabase setup.';

  @override
  String get errorDeleteAccountFailed =>
      'Could not delete the account. Try again.';

  @override
  String get errorSharedUsersSetupRequired =>
      'The shared_users table is missing or its schema does not match the template.';

  @override
  String get errorDeleteAccountNotImplemented =>
      'Delete account is not ready yet.';

  @override
  String get errorNoEstate => 'You need to join an estate first.';

  @override
  String get errorCodeNotFoundOrExpired =>
      'Invalid or expired invitation code.';

  @override
  String get errorInvalidCodeFormat => 'Invalid code format (XXXX-XXXX-XXXX).';

  @override
  String get errorRateLimitExceeded =>
      'Too many attempts. Try again in 15 minutes.';

  @override
  String get errorEstateInactive => 'This estate is currently inactive.';

  @override
  String get errorRoleLimitReached =>
      'The user limit for this role has been reached.';

  @override
  String get errorApartmentLimitReached =>
      'A maximum of 4 people can be registered under the same apartment.';

  @override
  String get errorUnknown => 'An unexpected error occurred.';

  @override
  String errorWithKey(Object errorKey) {
    return 'An error occurred: $errorKey';
  }

  @override
  String get guestDisplayName => 'Guest';

  @override
  String get registeredUserDisplayName => 'User';

  @override
  String get loadingLabel => 'Loading...';

  @override
  String get sessionErrorTitle => 'Session error';

  @override
  String get accountTypeGuest => 'guest';

  @override
  String get accountTypeRegistered => 'signed in';

  @override
  String get commonYes => 'yes';

  @override
  String get commonNo => 'no';

  @override
  String get limitAccessGuest => 'guest';

  @override
  String get limitAccessRegistered => 'registered';

  @override
  String get limitAccessPro => 'Pro';

  @override
  String get homeTitle => 'Home';

  @override
  String get currentSessionTitle => 'Current session';

  @override
  String sessionUserId(Object value) {
    return 'User ID: $value';
  }

  @override
  String sessionAccountType(Object value) {
    return 'Account type: $value';
  }

  @override
  String sessionPro(Object value) {
    return 'Pro: $value';
  }

  @override
  String sessionEmail(Object value) {
    return 'Email: $value';
  }

  @override
  String sessionDisplayNameValue(Object value) {
    return 'Display name: $value';
  }

  @override
  String sessionFirstName(Object value) {
    return 'First name: $value';
  }

  @override
  String get developerToolsTitle => 'Developer tools';

  @override
  String get retryButtonLabel => 'Try again';

  @override
  String get welcomeTitle => 'Welcome to Mestio';

  @override
  String get welcomeBody =>
      'Continue as a guest or sign in to an existing account.';

  @override
  String get welcomeSubtitle =>
      'Maintenance issue management for your community';

  @override
  String get continueAsGuestButton => 'Continue as guest';

  @override
  String get continueAsGuestButtonLabel => 'Get Started';

  @override
  String get loginButtonLabel => 'Log in';

  @override
  String get loginScreenTitle => 'Log in';

  @override
  String get loginExistingAccountTitle => 'Log in to an existing account';

  @override
  String get loginExistingAccountBody =>
      'Use your email address and password to switch to an existing account.';

  @override
  String get emailFieldLabel => 'Email';

  @override
  String get passwordFieldLabel => 'Password';

  @override
  String get forgotPasswordButtonLabel => 'Forgot password?';

  @override
  String get forgotPasswordScreenTitle => 'Forgot password';

  @override
  String get forgotPasswordTitle => 'Reset your password';

  @override
  String get forgotPasswordBody =>
      'Enter your email address and we\'ll send you a reset code.';

  @override
  String get sendResetCodeButtonLabel => 'Send code';

  @override
  String get resetPasswordScreenTitle => 'Reset password';

  @override
  String get resetPasswordTitle => 'Enter the reset code';

  @override
  String resetPasswordBody(Object email) {
    return 'We sent a reset code to $email. Enter it below and choose a new password.';
  }

  @override
  String get resetCodeFieldLabel => 'Reset code';

  @override
  String get confirmPasswordFieldLabel => 'Confirm new password';

  @override
  String get resetPasswordButtonLabel => 'Change password';

  @override
  String get passwordResetSuccessSnackbar => 'Password changed';

  @override
  String get switchAccountWarningTitle => 'You\'re switching accounts';

  @override
  String get switchAccountWarningBody =>
      'Logging in here will switch you from the current guest account to another account. Guest data and Pro access are not merged automatically.';

  @override
  String get registerScreenTitle => 'Sign up';

  @override
  String get secureGuestAccountTitle => 'Secure this guest account';

  @override
  String get secureGuestAccountBody =>
      'This will keep your current data and connect this guest account to an email address and password.';

  @override
  String get registerButtonLabel => 'Sign up';

  @override
  String get profileSavedSnackbar => 'Profile saved';

  @override
  String get proEnabledSnackbar => 'Pro enabled';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileLanguageSectionTitle => 'App language';

  @override
  String get profileLanguageSectionDescription =>
      'Choose whether the app should use the device language, Polish, Ukrainian, or English.';

  @override
  String get firstNameFieldLabel => 'First name';

  @override
  String get languageOptionSystem => 'Automatic';

  @override
  String get languageOptionSystemDescription =>
      'Uses the device language. For unsupported languages, the app falls back to English.';

  @override
  String get languageOptionPolish => 'Polski';

  @override
  String get languageOptionEnglish => 'English';

  @override
  String get languageOptionUkrainian => 'Українська';

  @override
  String get saveFirstNameButtonLabel => 'Save first name';

  @override
  String get accountSecuredSnackbar => 'Account secured';

  @override
  String get logoutButtonLabel => 'Log out';

  @override
  String get buyProButtonLabel => 'Buy Pro';

  @override
  String get proPlaceholderTitle => 'Pro purchases are not connected yet';

  @override
  String get proPlaceholderBodyProfile =>
      'This template already supports the Pro upgrade flow in the UI, but the real RevenueCat paywall still needs to be connected in the RevenueCat setup step.';

  @override
  String get deleteAccountButtonLabel => 'Delete account';

  @override
  String get discardChangesTitle => 'Discard changes?';

  @override
  String get discardChangesBody =>
      'You have unsaved changes. If you leave now, they will be lost.';

  @override
  String get stayButtonLabel => 'Stay';

  @override
  String get discardButtonLabel => 'Discard';

  @override
  String get closeButtonLabel => 'Close';

  @override
  String get protectProBannerTitle => 'Protect access to Pro';

  @override
  String get protectProBannerBody =>
      'This guest account already has Pro. Register this account so you do not lose access in the future.';

  @override
  String get developerDiagnosticsTitle => 'Debug-only diagnostics';

  @override
  String get developerDiagnosticsBody =>
      'Use this screen to inspect the local app configuration and integration status.';

  @override
  String get revenueCatDisconnectedTitle => 'RevenueCat is not connected';

  @override
  String get revenueCatDisconnectedBody =>
      'Add RevenueCat keys to config/api-keys.json when you\'re ready to test subscriptions.';

  @override
  String get revenueCatDebugMissingTestStoreTitle =>
      'Test Store key is missing';

  @override
  String get revenueCatDebugMissingTestStoreBody =>
      'Debug builds use the RevenueCat Test Store key. Add REVENUECAT_TEST_STORE_API_KEY to config/api-keys.json and restart the app.';

  @override
  String get sessionSectionTitle => 'Session';

  @override
  String get loggedInLabel => 'Signed in';

  @override
  String loggedInAsNamedLabel(Object name) {
    return 'Signed in: $name';
  }

  @override
  String get managerDashboardTitle => 'Board Dashboard';

  @override
  String get adminDashboardTitle => 'Administrator Dashboard';

  @override
  String get anonymousLabel => 'Anonymous';

  @override
  String get limitAccessLabel => 'Limit access';

  @override
  String get proLabel => 'Pro';

  @override
  String get userIdLabel => 'User ID';

  @override
  String get emailLabel => 'Email';

  @override
  String get displayNameLabel => 'Display name';

  @override
  String get supabaseSectionTitle => 'Supabase';

  @override
  String get keysConfiguredLabel => 'Keys configured';

  @override
  String get supabaseUrlLabel => 'Supabase URL';

  @override
  String get revenueCatSectionTitle => 'RevenueCat';

  @override
  String get supportedPlatformLabel => 'Supported platform';

  @override
  String get platformKeyConfiguredLabel => 'Platform key configured';

  @override
  String get testStoreKeyConfiguredLabel => 'Test Store key configured';

  @override
  String get sdkActiveLabel => 'SDK active';

  @override
  String get activeKeyTypeLabel => 'Active key type';

  @override
  String get activeSdkKeyLabel => 'Active SDK key';

  @override
  String get activeKeyTypeMissing => 'Missing';

  @override
  String get activeKeyTypeTestStore => 'Test Store';

  @override
  String get activeKeyTypeAppStore => 'App Store';

  @override
  String get activeKeyTypeGooglePlay => 'Google Play';

  @override
  String get proSourceLabel => 'Pro source';

  @override
  String get proSourceRevenueCat => 'RevenueCat';

  @override
  String get proSourceDeveloperOverride => 'Developer override';

  @override
  String get missingValueLabel => 'missing';

  @override
  String get debugForceProTitle => 'Debug: force Pro status';

  @override
  String get debugForceProSubtitle =>
      'Works only without active RevenueCat and only in the debug tool.';

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
      'Connect `Supabase MCP` to my Supabase project and fill `config/api-keys.json` with `SUPABASE_URL` and `SUPABASE_ANON_KEY`.';

  @override
  String get missingSupabaseTitle => 'Supabase keys are missing';

  @override
  String get missingSupabaseBody =>
      'Add Supabase keys to the config file and restart the app.';

  @override
  String get missingSupabaseFileLabel => 'Fill in this file';

  @override
  String get missingSupabaseFilePath => 'config/api-keys.json';

  @override
  String get missingSupabaseStep1Title => 'Step 1: install `Supabase MCP`';

  @override
  String get missingSupabaseStep1Body =>
      'First add `Supabase MCP` to your AI agent.';

  @override
  String get missingSupabaseStep2Title =>
      'Step 2: paste this prompt into the agent';

  @override
  String get copyPromptButtonLabel => 'Copy prompt';

  @override
  String get promptCopiedSnackbar => 'Prompt copied';

  @override
  String get missingSupabaseStep3Title => 'Step 3: close and reopen the app';

  @override
  String get missingSupabaseStep3Body =>
      'When the agent fills in the keys file, close the app and launch it again.';

  @override
  String get sharedUsersAgentPrompt =>
      'Run task `docs/tasks/02_SUPABASE_SHARED_USERS_SETUP.md` and bring the `shared_users` table to minimal compatibility with this project using `Supabase MCP`.';

  @override
  String get sharedUsersSetupTitle =>
      'The `shared_users` table is missing in Supabase';

  @override
  String get sharedUsersSetupBody =>
      'The app cannot load additional user data, such as the first name, because the `shared_users` table does not exist or its structure does not match the minimal assumptions.';

  @override
  String get sharedUsersGuideLabel => 'Use the prepared guide:';

  @override
  String get sharedUsersGuideFile => '02_SUPABASE_SHARED_USERS_SETUP.md';

  @override
  String get sharedUsersAiPromptTitle => 'Paste this prompt into your AI agent';

  @override
  String get sharedUsersAiHelpBody =>
      'If your AI agent has access to Supabase MCP, it can configure everything for you automatically using the prepared guide.';

  @override
  String get deleteAccountConfirmationTitle => 'Delete account';

  @override
  String get deleteAccountPermanentWarning =>
      'Your account will be permanently deleted along with all your data. This action cannot be undone.';

  @override
  String get deleteAccountOtherAppsWarning =>
      'You will also lose access to the following apps:';

  @override
  String get deleteAccountAppsCheckFailed =>
      'We could not check which other apps use this account. Deleting it will still remove the shared Supabase account and may affect other apps from this developer.';

  @override
  String get deleteAccountCheckboxLabel =>
      'I understand that my data in all apps will be deleted';

  @override
  String get deleteAccountCheckboxLabelSimple =>
      'I understand that this action is irreversible';

  @override
  String get deleteAccountSuccessSnackbar => 'Account deleted';

  @override
  String get deleteAccountConfirmButton => 'Delete my account';

  @override
  String get connectivityLabel => 'Internet';

  @override
  String get connectivityStatusConnected => 'connected';

  @override
  String get connectivityStatusDisconnected => 'disconnected';

  @override
  String get connectivityStatusChecking => 'checking...';

  @override
  String get connectivityOfflineBanner => 'No internet connection';

  @override
  String get proLockFinanceTitle => 'Finance Module (PRO)';

  @override
  String get proLockFinanceDesc =>
      'Access full rent statements, renovation funds, and payment histories.';

  @override
  String get proLockCommunicatorTitle => 'Community Messenger (PRO)';

  @override
  String get proLockCommunicatorDesc =>
      'Communicate directly with management and receive custom alerts about maintenance.';

  @override
  String get proLockPhoneTitle => 'Emergency Contacts (PRO)';

  @override
  String get proLockPhoneDesc =>
      'Quick directory of emergency services, administration, elevator services, and technicians.';

  @override
  String get proLockUnlockButton => 'Unlock PRO Version';

  @override
  String get estateOnboardingTitle => 'Join your estate';

  @override
  String get estateOnboardingSubtitle =>
      'To use the app, join an estate with an invitation code, or create a new estate as an administrator.';

  @override
  String get estateJoinSectionTitle => 'I have an invitation code';

  @override
  String get estateCodeFieldLabel => 'Invitation code';

  @override
  String get estateJoinButton => 'Join estate';

  @override
  String get estateCreateSectionTitle => 'I am an estate administrator';

  @override
  String get estateNameFieldLabel => 'Estate name';

  @override
  String get estateCreateButton => 'Create estate';

  @override
  String get estateInvitationCodeTitle => 'Estate invitation code';

  @override
  String get addAnotherEstateMenuLabel => '+ Add another estate';

  @override
  String get estateInvitationCodeHint =>
      'Share this code with residents so they can join the estate.';

  @override
  String get estateGenerateCodeButton => 'Generate invitation code';

  @override
  String get estateCopyCodeButton => 'Copy code';

  @override
  String get estateCodeCopiedSnackbar => 'Code copied to clipboard.';

  @override
  String get estateJoinedSnackbar => 'You joined the estate.';

  @override
  String get estateCreatedSnackbar => 'Estate created.';

  @override
  String get estateCodeRolesSectionTitle => 'Invitation codes per role';

  @override
  String get estateRegenerateCodeButton => 'Generate new';

  @override
  String get estateRegenerateCodeTitle => 'Generate a new code?';

  @override
  String get estateRegenerateCodeBody =>
      'The previous code will be deactivated. Continue?';

  @override
  String get estateJoinRequestsTitle => 'Join requests';

  @override
  String get estateJoinRequestsEmpty => 'No pending requests';

  @override
  String get estateApproveButton => 'Approve';

  @override
  String get estateRejectButton => 'Reject';

  @override
  String get estateJoinRequestApprovedSnackbar => 'Request approved';

  @override
  String get estateJoinRequestRejectedSnackbar => 'Request rejected';

  @override
  String get estateAutoJoinBadge => 'auto';

  @override
  String get estateApprovalRequiredBadge => 'approval';

  @override
  String get supportSectionTitle => 'Contact & support';

  @override
  String get supportSectionDescription =>
      'Have a question, suggestion, or something not working? Write to us.';

  @override
  String get supportContactButton => 'Contact us';

  @override
  String get supportEmailSubject => 'Mestio – feedback / issue';

  @override
  String get legalSectionTitle => 'Legal documents';

  @override
  String get legalSectionDescription =>
      'Review our privacy policy and terms of service.';

  @override
  String get privacyPolicyButton => 'Privacy Policy';

  @override
  String get termsOfServiceButton => 'Terms of Service';

  @override
  String get securityPatrolTitle => 'Patrol: Security';

  @override
  String get securityReportToBoardButton => '⚠️ REPORT TO BOARD';

  @override
  String get securityEmergencyAlarmButton => '🚨 ALARM FOR EVERYONE';

  @override
  String get securityPatrolHistoryTitle => 'RECENT PATROL REPORTS';

  @override
  String get securityPatrolHistoryEmpty => 'No entries today.';

  @override
  String get navHome => 'Home';

  @override
  String get navReports => 'Reports';

  @override
  String get navAddReport => 'Report';

  @override
  String get navPhones => 'Phones';

  @override
  String get navContacts => 'Contacts';

  @override
  String get navProfile => 'Profile';

  @override
  String get navAnnouncements => 'Announcements';

  @override
  String get navEstate => 'Estate';

  @override
  String get navResidents => 'Residents';

  @override
  String get navResolutions => 'Resolutions';

  @override
  String get residentsVisibleToBoardBadge => 'Visible to board';

  @override
  String get residentsHideFromBoardTooltip => 'Hide from board';

  @override
  String get residentsShareWithBoardTooltip => 'Share with board';

  @override
  String get residentsEmptyState => 'No registered residents';

  @override
  String get resolutionsTitle => 'Resolutions';

  @override
  String get resolutionsSubtitleBoard =>
      'Create resolutions and count residents\' votes';

  @override
  String get resolutionsSubtitleResident => 'Vote on community resolutions';

  @override
  String get resolutionsEmpty => 'No resolutions yet.';

  @override
  String get resolutionStateOpen => 'Voting open';

  @override
  String get resolutionStatePassed => 'Passed';

  @override
  String get resolutionStateRejected => 'Rejected';

  @override
  String resolutionDeadline(Object date) {
    return 'until $date';
  }

  @override
  String get resolutionVoteFor => 'For';

  @override
  String get resolutionVoteAgainst => 'Against';

  @override
  String resolutionYourVote(Object vote) {
    return 'Your vote: $vote';
  }

  @override
  String get resolutionResultsHidden =>
      'Results will be visible after you vote.';

  @override
  String resolutionForPercent(Object pct) {
    return 'For $pct%';
  }

  @override
  String resolutionAgainstPercent(Object pct) {
    return 'Against $pct%';
  }

  @override
  String resolutionVotesCount(Object count) {
    return 'Votes: $count';
  }

  @override
  String resolutionVoteSuccess(Object vote) {
    return 'Your vote: $vote';
  }

  @override
  String get newResolutionTitle => 'New resolution';

  @override
  String get resolutionTitleLabel => 'Title';

  @override
  String get resolutionDescriptionLabel => 'Description';

  @override
  String get resolutionDeadlineLabel => 'Voting deadline (optional)';

  @override
  String get resolutionPublishButton => 'Publish';

  @override
  String get resolutionCancelButton => 'Cancel';

  @override
  String get resolutionCloseAsPassed => 'Close: passed';

  @override
  String get resolutionCloseAsRejected => 'Close: rejected';

  @override
  String get resolutionCreateSuccess => 'Resolution published';

  @override
  String get errorResolutionsLoad => 'Failed to load resolutions.';

  @override
  String get errorResolutionVote => 'Failed to cast your vote.';

  @override
  String get errorResolutionCreate => 'Failed to publish the resolution.';

  @override
  String get errorResolutionClose => 'Failed to close the resolution.';

  @override
  String get reportCloseRequiresMessageHint =>
      'Write a message to the resident in the notes below before closing or rejecting this report.';

  @override
  String get reportCloseRequiresMessageWarning =>
      'Write a message to the resident in the notes below first ↓';

  @override
  String get attachmentsLabel => 'Attachments';

  @override
  String get attachmentOpenLabel => 'open';

  @override
  String get attachmentOpenError => 'Failed to open the attachment.';

  @override
  String get additionalInfoLabel => 'Other — info for the board';

  @override
  String get additionalInfoHint =>
      'e.g. police/fire department is coming, access from 8:00';

  @override
  String get markAsUrgentLabel => 'Mark as urgent';

  @override
  String get notificationsPanelTitle => 'Notifications';

  @override
  String get notificationsEmpty => 'No notifications.';

  @override
  String notificationYourReport(Object id) {
    return 'Your report $id';
  }

  @override
  String notificationCurrentStatus(Object status) {
    return 'Current status: $status';
  }

  @override
  String notificationUrgentPrefix(Object title) {
    return 'Urgent: $title';
  }

  @override
  String notificationReportPrefix(Object id) {
    return 'Report $id';
  }

  @override
  String get feedbackSheetTitle => 'Send feedback to the developer';

  @override
  String get feedbackSheetSubtitle =>
      'Something broken, missing a feature, or have an idea? Let us know — it helps improve the app.';

  @override
  String get feedbackTypeBug => 'Bug';

  @override
  String get feedbackTypeIdea => 'Idea';

  @override
  String get feedbackTypeQuestion => 'Question';

  @override
  String get feedbackMessageHint => 'Your feedback or idea…';

  @override
  String get feedbackSendButton => 'Send feedback';

  @override
  String get feedbackSendError => 'Failed to open your mail client.';

  @override
  String get feedbackSentSnackbar => 'Thanks! We opened your mail client.';

  @override
  String get maintenanceSectionTitle => 'Preventive maintenance';

  @override
  String get maintenanceAddTooltip => 'Add schedule';

  @override
  String get maintenanceEmpty => 'No maintenance scheduled.';

  @override
  String maintenanceNextDue(Object freq, Object date) {
    return '$freq · next: $date';
  }

  @override
  String get maintenanceMarkDoneButton => 'Done';

  @override
  String get maintenanceFrequencyMonthly => 'monthly';

  @override
  String get maintenanceFrequencyQuarterly => 'quarterly';

  @override
  String get maintenanceFrequencySemiAnnual => 'every 6 months';

  @override
  String get maintenanceFrequencyAnnual => 'yearly';

  @override
  String maintenanceFrequencyDays(Object days) {
    return 'every $days days';
  }

  @override
  String get maintenanceNewTitle => 'New maintenance schedule';

  @override
  String get maintenanceNameLabel => 'Name';

  @override
  String get maintenanceFrequencyLabel => 'Frequency';

  @override
  String get maintenanceNextDueDateLabel => 'Next due date';

  @override
  String get maintenanceSaveButton => 'Save';

  @override
  String get errorMaintenanceLoad => 'Failed to load the maintenance schedule.';

  @override
  String get errorMaintenanceCreate => 'Failed to add the schedule.';

  @override
  String get errorMaintenanceMark => 'Failed to save completion.';

  @override
  String get correspondenceTitle => 'Messages';

  @override
  String get correspondenceEmpty =>
      'No messages yet. Write the first one below.';

  @override
  String get correspondenceHintResident => 'Message the board/office…';

  @override
  String get correspondenceHintStaff => 'Message the resident…';

  @override
  String get teamNotesTitle => 'Team notes';

  @override
  String get teamNotesHiddenBadge => 'internal — hidden from the resident';

  @override
  String get teamNotesEmpty => 'No notes yet. Add the first one.';

  @override
  String get teamNotesInputHint => 'Add a team note…';

  @override
  String photosSelectedCount(Object count) {
    return 'Photos: $count — add another';
  }

  @override
  String galleryLabel(Object count) {
    return 'Photos ($count)';
  }

  @override
  String get sendAnnouncementFormTitle => 'SEND ANNOUNCEMENT TO RESIDENTS';

  @override
  String get announcementTitleLabel => 'Announcement title';

  @override
  String get announcementTitleHint => 'e.g. Elevator maintenance';

  @override
  String get announcementContentLabel => 'Announcement content';

  @override
  String get announcementContentHint =>
      'Type the detailed announcement content...';

  @override
  String get announcementExpiryLabel => 'Expires on (optional):';

  @override
  String get dayLabel => 'Day';

  @override
  String get monthLabel => 'Month';

  @override
  String get yearLabel => 'Year';

  @override
  String get sendAnnouncementButton => 'SEND ANNOUNCEMENT';

  @override
  String get sentAnnouncementsTitle => 'SENT ANNOUNCEMENTS';

  @override
  String announcementExpiresOnLabel(Object date) {
    return 'Expires: $date';
  }

  @override
  String announcementExpiredSuffix(Object date) {
    return '$date (expired)';
  }

  @override
  String get deleteAnnouncementTooltip => 'Delete announcement';

  @override
  String get announcementSentSnackbar => 'Announcement sent!';

  @override
  String announcementPushNotificationPrefix(Object title) {
    return 'ANNOUNCEMENT: $title';
  }

  @override
  String get announcementScopeLabel => 'Scope — pick the audience';

  @override
  String get announcementScopeEstate => 'All residents';

  @override
  String announcementScopeBuilding(Object name) {
    return 'Building $name';
  }

  @override
  String announcementScopeStairwell(Object stairwell, Object building) {
    return 'Stairwell $stairwell ($building)';
  }

  @override
  String get residentGreetingMorning => 'Good morning,';

  @override
  String get residentGreetingFallback => 'Resident';

  @override
  String get residentSystemsOK => 'All systems OK';

  @override
  String get residentAddressUnknown => 'Address not verified';

  @override
  String get latestAnnouncementHeader => 'Latest announcement';

  @override
  String get activeReportsHeader => 'Active reports';

  @override
  String get noActiveReports => 'You have no active reports.';

  @override
  String get seeAllReports => 'See all reports';

  @override
  String get residentReportsTitle => 'Your reports';

  @override
  String get residentReportsListHeader => 'YOUR REPORTS';

  @override
  String get noReportsYet => 'No reports submitted yet.';

  @override
  String get syncOfflineButton => 'Sync offline cache';

  @override
  String get profileUserTitle => 'User profile';

  @override
  String get addressLabel => 'Address:';

  @override
  String roleLabel(Object role) {
    return 'Role: $role';
  }

  @override
  String get estateJoinIntro =>
      'You don\'t belong to any estate yet. Enter the invitation code provided by your administrator.';

  @override
  String get estateJoinedInfo =>
      'You are a member of this estate. Your reports and announcements are linked to it.';

  @override
  String estateJoinedNamedSnackbar(Object name) {
    return 'You joined the estate \"$name\".';
  }

  @override
  String get estateInvalidCode => 'The code is invalid or no longer active.';

  @override
  String get joinEstateButton => 'Join estate';

  @override
  String get joiningEstate => 'Joining…';

  @override
  String get supportContactTitle => 'Contact / Support';

  @override
  String get reportAddedSnackbar => 'Report submitted successfully!';

  @override
  String get submitReportButton => 'Submit report';

  @override
  String get reportTitleRequiredSnackbar =>
      'Please provide a title for the report.';

  @override
  String get lockScreenTitle => 'Resident registration';

  @override
  String get lockScreenResidentSubtitle =>
      'Tell us your stairwell and apartment number so we can send you targeted notifications about incidents in your area.';

  @override
  String get lockScreenStaffSubtitle =>
      'Enter your details and the invitation code provided by the administrator.';

  @override
  String get fullNameFieldLabel => 'Full name';

  @override
  String get fullNameRequired => 'Enter your full name';

  @override
  String get emailRequired => 'Enter your e-mail address';

  @override
  String get emailInvalid => 'Invalid e-mail address';

  @override
  String get phoneFieldLabel => 'Phone number';

  @override
  String get phoneFieldLabelRequired => 'Phone number (required)';

  @override
  String get phoneRequired => 'Phone number is required';

  @override
  String get phoneInvalid => 'Phone number is too short';

  @override
  String get codeInvalid => 'Invalid invitation code';

  @override
  String get locationSectionLabel => 'Apartment location details:';

  @override
  String get buildingFieldLabel => 'Building';

  @override
  String get footbridgeFieldLabel => 'Stairwell / Wing';

  @override
  String get floorFieldLabel => 'Floor';

  @override
  String get apartmentFieldLabel => 'Apartment';

  @override
  String get requiredFieldShort => 'Required';

  @override
  String technicianLoggedInNamed(Object name) {
    return 'Service: $name';
  }

  @override
  String get technicianLoggedInFallback => 'Signed in as Service';

  @override
  String get showClosedToggleLabel => 'Show closed';

  @override
  String reporterInfoLabel(Object name, Object email) {
    return 'Reported by: $name ($email)';
  }

  @override
  String reportLocationInfoLabel(Object location) {
    return 'Location: $location';
  }

  @override
  String reportDescriptionInfoLabel(Object description) {
    return 'Description: $description';
  }

  @override
  String reportTileSubtitle(
    Object displayId,
    Object footbridge,
    Object building,
    Object floor,
  ) {
    return '#$displayId, Stairwell $footbridge\nBuilding $building, Floor $floor';
  }

  @override
  String get syncedToServerLabel => 'Synced with server';

  @override
  String get savedOfflineLabel => 'Saved locally (offline)';

  @override
  String get technicianNoteTitle => '🛠️ Service Note:';

  @override
  String stairwellAbbreviationLabel(Object name) {
    return 'stw. $name';
  }

  @override
  String apartmentAbbreviationLabel(Object number) {
    return 'apt. $number';
  }

  @override
  String get detailsButtonLabel => 'Details';

  @override
  String get technicianDeleteAccountWarning =>
      'This action is irreversible — all your data will be permanently deleted.';

  @override
  String technicianPhoneLabel(Object phone) {
    return 'Phone: $phone';
  }

  @override
  String get deleteAccountSectionTitle => 'Delete account';

  @override
  String get codeFieldLabelRequired => 'Invitation code';

  @override
  String get codeRequired => 'Enter the invitation code';

  @override
  String get codeExplanation =>
      'You\'ll get the code from the board or estate administrator. The code determines your role — it\'s not chosen manually.';

  @override
  String get stepBasicDataTitle => 'Basic info';

  @override
  String get stepLocationTitle => 'Location';

  @override
  String get stepSummaryTitle => 'Summary';

  @override
  String get technicianCompanyTitle => 'Company / Service Provider';

  @override
  String get technicianCompanyLabel => 'Service provider / company name';

  @override
  String get technicianCompanyRequired =>
      'Company/service provider name is required';

  @override
  String get backButtonLabel => 'Back';

  @override
  String get nextButtonLabel => 'Next';

  @override
  String get confirmAndOpenButton => 'Confirm & Open App';

  @override
  String get regSummaryRoleLabel => 'Role';

  @override
  String get regSummaryEstateLabel => 'Estate';

  @override
  String get regSummaryNameLabel => 'Full name';

  @override
  String get regSummaryLocationLabel => 'Unit';

  @override
  String get regSummaryCompanyLabel => 'Company / technician';

  @override
  String get regResidentJoinNote =>
      'You\'ll join the estate immediately after registering.';

  @override
  String get regPendingApprovalNote =>
      'After registering, your request goes to the administrator. You\'ll be notified once approved.';

  @override
  String get pendingApprovalTitle => 'Awaiting approval';

  @override
  String pendingApprovalBody(Object estateName, Object role) {
    return 'Your request to join \"$estateName\" as $role has been sent. The administrator will approve it soon.';
  }

  @override
  String get pendingApprovalRefreshButton => 'Check status';

  @override
  String get addContactDialogTitle => 'Add contact';

  @override
  String get addContactNameLabel => 'Contact name';

  @override
  String get addContactNameHelper =>
      'E.g. Management Office, Emergency Plumber';

  @override
  String get addContactRoleLabel => 'Position / role';

  @override
  String get addContactRoleHelper =>
      'E.g. Estate administrator, Electrician. Shown under the name.';

  @override
  String get addContactPhoneLabel => 'Phone';

  @override
  String get addContactEmailLabel => 'Email (optional)';

  @override
  String get addContactCategoryLabel => 'Category';

  @override
  String get addContactCancelButton => 'Cancel';

  @override
  String get addContactAddButton => 'Add';

  @override
  String get buildingAddRlsError =>
      'You don\'t have permission to add a building. Make sure your role is Administrator or Board in this estate.';

  @override
  String get buildingAddNetworkError =>
      'Cannot reach the server. Check your internet connection and try again.';

  @override
  String get buildingAddError =>
      'Failed to add the building. Please try again.';

  @override
  String get reportCategoryLabel => 'Category';

  @override
  String get reportCategoryHydraulika => 'Plumbing';

  @override
  String get reportCategoryElektryka => 'Electrical';

  @override
  String get reportCategoryWinda => 'Elevator';

  @override
  String get reportCategoryOgrzewanie => 'Heating';

  @override
  String get reportCategoryDomofon => 'Intercom';

  @override
  String get reportCategoryOswietlenie => 'Lighting';

  @override
  String get reportCategoryParking => 'Parking';

  @override
  String get reportCategoryGaraz => 'Garage';

  @override
  String get reportCategoryDachElewacja => 'Roof/Facade';

  @override
  String get reportCategorySprzatanie => 'Cleaning';

  @override
  String get reportCategoryZielen => 'Greenery';

  @override
  String get reportCategoryZarzadAdministrator => 'Management / Administrator';

  @override
  String get reportRecipientBoardAdminService => 'Board / Admin + Service';

  @override
  String get reportRecipientBoardAdminSecurity => 'Board / Admin + Security';

  @override
  String get qrScanTitle => 'Scan QR code';

  @override
  String get fabReportIssue => 'Report issue';

  @override
  String get fabScanQr => 'Scan QR code';

  @override
  String get fabMessageToBoard => 'Message to board';

  @override
  String get fabClose => 'Close';

  @override
  String get buildingLabel => 'Building';

  @override
  String get stairwellLabel => 'Stairwell';

  @override
  String get floorLabel => 'Floor';

  @override
  String get apartmentLabel => 'Apartment';

  @override
  String get qrLocationPrefix => 'Location scanned from QR code:';

  @override
  String get residentSpacesTitle => 'My spaces';

  @override
  String get residentSpacesAddButton => 'Add space';

  @override
  String get residentSpacesEmpty =>
      'You haven\'t added any spaces yet.\nAdd a storage unit, basement or parking spot.';

  @override
  String get residentSpacesTypeLabel => 'Type';

  @override
  String get residentSpacesNameLabel => 'Label';

  @override
  String get residentSpacesNameHint => 'e.g. K-14, level -1';

  @override
  String get residentSpacesTypeStorage => 'Storage unit';

  @override
  String get residentSpacesTypeBasement => 'Basement';

  @override
  String get residentSpacesTypeParking => 'Parking spot';

  @override
  String get residentSpacesTypeGarage => 'Garage';

  @override
  String get residentSpacesTypeOther => 'Other';

  @override
  String get residentSpacesDeleteConfirmTitle => 'Remove space';

  @override
  String get residentSpacesDeleteConfirmMessage =>
      'Are you sure you want to remove this space?';

  @override
  String get residentSpacesDelete => 'Delete';

  @override
  String get residentSpacesSave => 'Save';

  @override
  String get emptyReportsTitle => 'No reports';

  @override
  String get emptyReportsBody =>
      'Everything running smoothly? You haven\'t submitted any issue reports yet.';

  @override
  String get emptyReportsAction => 'Report first issue';

  @override
  String get emptyContactsTitle => 'No contacts';

  @override
  String get emptyContactsBody =>
      'The estate administrator hasn\'t added any emergency or service contacts yet.';

  @override
  String get contactsTabTitle => 'Emergency Contacts';

  @override
  String get addContactTooltip => 'Add contact';

  @override
  String get contactsCategoryAdministration => 'Administration';

  @override
  String get contactsCategoryEmergency => 'Emergency Services';

  @override
  String get contactsCategoryMaintenance => 'Maintenance';

  @override
  String get contactsCategorySecurity => 'Security';

  @override
  String get callButtonTooltip => 'Call';

  @override
  String get deleteContactDialogTitle => 'Delete contact';

  @override
  String deleteContactConfirmMessage(Object name) {
    return 'Are you sure you want to delete the contact \"$name\"?';
  }

  @override
  String get emptyAnnouncementsTitle => 'No announcements';

  @override
  String get emptyAnnouncementsBody =>
      'The estate board hasn\'t published any announcements yet.';

  @override
  String get emptyBuildingsTitle => 'No buildings';

  @override
  String get emptyBuildingsBody =>
      'Start by adding your first building to set up the estate structure.';

  @override
  String get emptyBuildingsAction => 'Add first building';

  @override
  String get emptyTechReportsTitle => 'No reports';

  @override
  String get emptyTechReportsBody =>
      'Your service queue is empty — you have no assigned or pending reports.';

  @override
  String get residentNewLabel => 'new';

  @override
  String get residentInProgressLabel => 'in progress';

  @override
  String get residentCriticalLabel => 'urgent';

  @override
  String get residentMyReportsCardTitle => 'My reports';

  @override
  String get residentAnnouncementsCardTitle => 'Announcements';

  @override
  String get residentCommunityTitle => 'Community';

  @override
  String get residentCommunitySubtitle =>
      'Meeting calendar, voting on resolutions and neighbour communication.';

  @override
  String get estateHealthTitle => 'Estate health';

  @override
  String get estateHealthOpenReports => 'Open';

  @override
  String get estateHealthOverdue => 'Overdue';

  @override
  String get estateHealthTotal => 'Total';

  @override
  String get estateHealthNoData =>
      'No data — the index will be calculated once the first reports appear.';

  @override
  String get estateHealthPrototypeLabel => '[PROTOTYPE]';

  @override
  String get buildingUpdateError =>
      'Failed to update the building. Please try again.';

  @override
  String get buildingDeleteError =>
      'Failed to delete the building. Please try again.';

  @override
  String get stairwellAddRlsError =>
      'You don\'t have permission to add a stairwell. Make sure your role is Administrator or Board in this estate.';

  @override
  String get stairwellAddError =>
      'Failed to add the stairwell. Please try again.';

  @override
  String get stairwellUpdateError =>
      'Failed to update the stairwell. Please try again.';

  @override
  String get stairwellDeleteError =>
      'Failed to delete the stairwell. Please try again.';

  @override
  String get estateStructureTitle => 'Estate Structure';

  @override
  String get addBuildingTooltip => 'Add building';

  @override
  String get addGarageMenuLabel => 'Add garage';

  @override
  String get testConnectionButton => 'Test connection';

  @override
  String get offlineModeBanner =>
      'Offline mode: using local data. Supabase is temporarily unavailable.';

  @override
  String get noBuildingsMessage =>
      'No buildings defined.\nAdd the first building.';

  @override
  String get garageBadgeLabel => 'GARAGE';

  @override
  String get stairwellsSectionLabel => 'STAIRWELLS';

  @override
  String get addStairwellButton => 'Add stairwell';

  @override
  String get noStairwellsMessage => 'No stairwells. Add the first stairwell.';

  @override
  String get addBuildingDialogTitle => 'Add building';

  @override
  String get editBuildingDialogTitle => 'Edit building';

  @override
  String get buildingNameLabel => 'Building name';

  @override
  String get buildingNameHint => 'e.g. Building 1';

  @override
  String get buildingAddressLabel => 'Address (optional)';

  @override
  String get buildingAddressHint => 'e.g. 5 Słoneczna St';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get addButton => 'Add';

  @override
  String get saveButton => 'Save';

  @override
  String get deleteButton => 'Delete';

  @override
  String get deleteBuildingDialogTitle => 'Delete building';

  @override
  String deleteBuildingDialogContent(Object name) {
    return 'Are you sure you want to delete \"$name\"?\n\nAll stairwells in this building will also be deleted.';
  }

  @override
  String get addStairwellDialogTitle => 'Add stairwell';

  @override
  String get editStairwellDialogTitle => 'Edit stairwell';

  @override
  String get stairwellNameLabel => 'Stairwell';

  @override
  String stairwellNameValue(Object name) {
    return 'Stairwell $name';
  }

  @override
  String get floorMinLabel => 'Lowest floor';

  @override
  String get floorMaxLabel => 'Highest floor';

  @override
  String get garageEntranceLabel => 'Garage entrance';

  @override
  String garageEntranceValue(Object label) {
    return 'Entrance $label';
  }

  @override
  String get notApplicableLabel => '—';

  @override
  String get validationFloorRangeInvalid =>
      'Highest floor must be greater than or equal to lowest floor.';

  @override
  String get deleteStairwellDialogTitle => 'Delete stairwell';

  @override
  String deleteStairwellDialogContent(Object name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String stairwellFloorRange(Object min, Object max) {
    return 'Floors $min–$max';
  }

  @override
  String get createAccountTitle => 'Create your account';

  @override
  String get createAccountBody =>
      'Step 1 of 2: enter your e-mail and password. After saving, step 2 will ask for your name, phone, apartment address and optional invitation code.';

  @override
  String get passwordConfirmFieldLabel => 'Confirm password';

  @override
  String get passwordsDoNotMatch => 'Passwords don\'t match.';

  @override
  String get registerSubmitButton => 'Create account';

  @override
  String get registerConsentLabel =>
      'I accept the Terms of Service and Privacy Policy and consent to the processing of my personal data.';

  @override
  String get errorTermsNotAccepted =>
      'You must accept the Terms of Service and Privacy Policy to continue.';

  @override
  String get blockUserButton => 'Block user';

  @override
  String get userBlockedSnackbar => 'User has been blocked.';

  @override
  String get dangerZoneSectionTitle => 'Danger zone';

  @override
  String get deleteAccountRequiresPassword => 'Confirm your password';

  @override
  String get deleteAccountPasswordLabel => 'Password';

  @override
  String get deleteAccountPasswordHint =>
      'Enter your password to confirm account deletion';

  @override
  String get statusNowe => 'New';

  @override
  String get statusWRealizacji => 'In progress';

  @override
  String get statusZamkniete => 'Closed';

  @override
  String get statusOdrzucone => 'Rejected';

  @override
  String get allFilterLabel => 'All';

  @override
  String get noReportsMatchingFilter =>
      'No reports matching the selected filters.';

  @override
  String get assignTo => 'Assign to';

  @override
  String get unassigned => 'Unassigned';

  @override
  String assignedToLabel(Object name, Object role) {
    return 'Assigned to: $name ($role)';
  }

  @override
  String get logoutFeedbackTitle => 'What do you think of the app?';

  @override
  String get logoutFeedbackDescription =>
      'Your feedback helps us make it better.';

  @override
  String get logoutFeedbackRateButton => 'Leave a review';

  @override
  String get logoutFeedbackLogoutButton => 'Log out';

  @override
  String get reportDetailScreenTitle => 'Report details';

  @override
  String reportDetailIdLabel(Object id) {
    return 'FX-$id';
  }

  @override
  String get priorityLow => 'Low';

  @override
  String get priorityNormal => 'Normal';

  @override
  String get priorityHigh => 'High';

  @override
  String get priorityCritical => 'Critical';

  @override
  String get priorityLabel => 'Priority';

  @override
  String get slaDeadlineLabel => 'SLA deadline';

  @override
  String get slaOverdueLabel => 'Overdue';

  @override
  String get csatTitle => 'Rate this report';

  @override
  String get csatSubmitButton => 'Submit';

  @override
  String get csatSubmittedSnackbar => 'Thank you for your rating!';

  @override
  String get auditTrailTitle => 'Audit trail';

  @override
  String auditTrailActionStatusChange(Object user, Object status) {
    return '$user changed status to: $status';
  }

  @override
  String auditTrailActionPriorityChange(Object user, Object priority) {
    return '$user changed priority to: $priority';
  }

  @override
  String auditTrailActionAssign(Object user, Object assignee) {
    return '$user assigned to: $assignee';
  }

  @override
  String auditTrailActionCreate(Object user) {
    return '$user created the report';
  }

  @override
  String get serviceNotesLabel => 'Service notes';

  @override
  String get teamNotesLabel => 'Team notes';

  @override
  String get noTeamNotes => 'No team notes.';

  @override
  String get photoGalleryLabel => 'Photos';

  @override
  String get reportContentButton => 'Report';

  @override
  String get reportContentDialogTitle => 'Report content';

  @override
  String get reportContentReasonLabel => 'Reason';

  @override
  String get reportContentReasonSpam => 'Spam';

  @override
  String get reportContentReasonHarassment => 'Harassment';

  @override
  String get reportContentReasonInappropriate => 'Inappropriate content';

  @override
  String get reportContentReasonMisinformation => 'Misinformation';

  @override
  String get reportContentReasonPrivacy => 'Privacy violation';

  @override
  String get reportContentReasonOther => 'Other';

  @override
  String get reportContentDescriptionLabel => 'Additional details (optional)';

  @override
  String get reportContentDescriptionHint => 'Describe the issue...';

  @override
  String get reportContentSubmitButton => 'Submit report';

  @override
  String get reportContentCancelButton => 'Cancel';

  @override
  String get reportContentSuccessSnackbar => 'Report submitted successfully';

  @override
  String get errorModerationRateLimit =>
      'You\'ve reached the report limit. Try again later.';

  @override
  String get errorModerationAlreadyReported =>
      'You\'ve already reported this content.';

  @override
  String get errorModerationContentNotFound => 'Content not found.';

  @override
  String get errorModerationUnauthenticated => 'You must be logged in.';

  @override
  String get errorModerationUnknown => 'Failed to submit report.';

  @override
  String get errorLoadingData => 'Error loading data';

  @override
  String get retryButton => 'Try again';

  @override
  String get errorLocationServiceDisabled =>
      'GPS/Location service is disabled on the device.';

  @override
  String get errorLocationPermissionDenied => 'Location permission denied.';

  @override
  String get errorLocationPermissionDeniedForever =>
      'Location permission is permanently blocked in system settings.';

  @override
  String get errorLocationUnknown => 'Failed to get location.';

  @override
  String get selectEstateTitle => 'Select estate';

  @override
  String get estateCompanySectionTitle => 'Management company';

  @override
  String get estateCompanyNone => 'Not configured';

  @override
  String get estateAdminContact => 'Administrator contact';

  @override
  String get estateInvitationCodeLabel => 'Invitation code';

  @override
  String get estateNoInvitationCode => 'No active code';

  @override
  String get estateContractValidUntilLabel => 'Contract valid until';

  @override
  String estateContractDaysLeft(Object days) {
    return '$days days left';
  }

  @override
  String get estateContractExpired => 'Contract expired';

  @override
  String get estateContractNone => 'No active contract';

  @override
  String get dataExportButtonLabel => 'Export my data';

  @override
  String get dataExportDescription =>
      'Download a copy of all your data in JSON format (GDPR Art. 20 — right to data portability).';

  @override
  String get dataExportedSnackbar =>
      'Your data has been copied to the clipboard. Paste it into a text file to save it.';

  @override
  String get reportSearchHint => 'Search reports...';

  @override
  String get reportComposerTitle => 'Report New Fault';

  @override
  String get reportTitleHint => 'Fault title (short description)';

  @override
  String get reportDescriptionHint =>
      'Describe the damage, additional details and location\nE.g. Open window. Building 1, stairwell A, 3rd floor. Please repair quickly.';

  @override
  String get photoTakePhotoButton => 'Take Photo';

  @override
  String get photoAddMoreButton => 'Add More';

  @override
  String get photoGalleryButton => 'Gallery';

  @override
  String get pdfAttachButton => 'Attach PDF';

  @override
  String get pdfSelectedLabel => 'PDF selected';

  @override
  String get buildingTypeLabel => 'Building type';

  @override
  String get buildingTypeResidential => 'Residential building';

  @override
  String get buildingTypeGarage => 'Garage';

  @override
  String get addGarageDialogTitle => 'Add garage';

  @override
  String get garageNameLabel => 'Garage name';

  @override
  String get garageNameHint => 'e.g. Underground garage';

  @override
  String get garageFloorInfo =>
      'Basements/garage levels will be added as stairwells ranging from -4 to 0.';

  @override
  String get gpsDevicePositionLabel => 'GPS Position (Device):';

  @override
  String gpsLatitudeLabel(Object lat) {
    return 'Latitude: $lat';
  }

  @override
  String gpsLongitudeLabel(Object lng) {
    return 'Longitude: $lng';
  }

  @override
  String gpsSourceLabel(Object source) {
    return 'Source: $source';
  }

  @override
  String gpsLabelLabel(Object label) {
    return 'Label: $label';
  }

  @override
  String get contactBookCardTitle => 'Contact book';

  @override
  String get contactBookCardSubtitle =>
      'Manage emergency and service contacts for the estate';

  @override
  String get contactBookTitle => 'Contact book';

  @override
  String get boardNotesTitle => 'Board notes';

  @override
  String get actionsSectionTitle => 'Actions';

  @override
  String get unknownUserFallback => 'Unknown';

  @override
  String reporterLabel(Object name) {
    return 'Reported by: $name';
  }

  @override
  String get collapseButton => 'Collapse';

  @override
  String get expandButton => 'Expand';

  @override
  String get sortNewest => 'Newest';

  @override
  String get sortOldest => 'Oldest';
}
