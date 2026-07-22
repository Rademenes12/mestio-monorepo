import '../l10n/l10n.dart';

String mapErrorToKey(Object error) {
  final message = error.toString().toLowerCase();

  // Supabase Realtime JWT errors
  if (message.contains('realtimesubscribeexception') &&
      message.contains('invalidjwttoken')) {
    return 'unknown_error';
  }

  // Supabase PostgREST errors
  if (message.contains('pgrst')) {
    if (message.contains('pgrst000') || message.contains('pgrst116')) {
      return 'network_error';
    }
    if (message.contains('42501')) {
      return 'unknown_error'; // Permission denied
    }
  }

  // Supabase relation/table not found
  if (message.contains('relation') && message.contains('does not exist')) {
    return 'shared_users_setup_required';
  }

  // Supabase column errors
  if (message.contains('column') && (message.contains('does not exist') || message.contains('null value'))) {
    return 'shared_users_setup_required';
  }

  // OTP/Password reset errors
  if (message.contains('otp has expired')) {
    return 'password_reset_code_expired';
  }

  if (message.contains('otp provided is invalid or has expired') ||
      message.contains('token verification') ||
      ((message.contains('otp') || message.contains('token')) &&
          message.contains('invalid'))) {
    return 'password_reset_code_invalid';
  }

  // Password errors
  if (message.contains('weak password') ||
      message.contains('password too weak') ||
      message.contains('password is too weak') ||
      message.contains('password should be at least') ||
      message.contains('at least 6 characters')) {
    return 'password_too_short';
  }

  // Auth errors
  if (message.contains('invalid login credentials')) {
    return 'invalid_credentials';
  }

  if (message.contains('email not confirmed') || message.contains('email confirmation')) {
    return 'email_not_confirmed';
  }

  if (message.contains('anonymous sign-ins are disabled')) {
    return 'anonymous_auth_disabled';
  }

  if (message.contains('user_already_exists') ||
      message.contains('user already registered')) {
    return 'email_already_registered';
  }

  if (message.contains('email')) {
    return 'email_error';
  }

  if (message.contains('password')) {
    return 'password_error';
  }

  if (message.contains('network') || message.contains('socket') || message.contains('timeout')) {
    return 'network_error';
  }

  if (message.contains('purchase')) {
    return 'purchase_error';
  }

  if (message.contains('delete_account_setup_required')) {
    return 'delete_account_setup_required';
  }

  if (message.contains('delete_account_failed')) {
    return 'delete_account_failed';
  }

  // Invitation code / join request errors (fixflow_redeem_invitation_code,
  // fixflow_peek_invitation_code — migration 0045)
  if (message.contains('code_not_found_or_expired')) {
    return 'code_not_found_or_expired';
  }

  if (message.contains('invalid_code_format')) {
    return 'invalid_code_format';
  }

  if (message.contains('rate_limit_exceeded')) {
    return 'rate_limit_exceeded';
  }

  if (message.contains('estate_inactive')) {
    return 'estate_inactive';
  }

  if (message.contains('role_limit_reached')) {
    return 'role_limit_reached';
  }

  if (message.contains('apartment_limit_reached')) {
    return 'apartment_limit_reached';
  }

  // Content moderation errors
  if (message.contains('error_moderation_rate_limit')) {
    return 'error_moderation_rate_limit';
  }

  if (message.contains('error_moderation_already_reported')) {
    return 'error_moderation_already_reported';
  }

  if (message.contains('error_moderation_content_not_found')) {
    return 'error_moderation_content_not_found';
  }

  if (message.contains('error_moderation_unauthenticated')) {
    return 'error_moderation_unauthenticated';
  }

  if (message.contains('error_moderation_unknown')) {
    return 'error_moderation_unknown';
  }

  // Location errors
  if (message.contains('error_location_service_disabled')) {
    return 'error_location_service_disabled';
  }

  if (message.contains('error_location_permission_denied_forever')) {
    return 'error_location_permission_denied_forever';
  }

  if (message.contains('error_location_permission_denied')) {
    return 'error_location_permission_denied';
  }

  if ((message.contains('shared_users') || message.contains('profiles')) &&
      (message.contains('schema cache') ||
          message.contains('column') ||
          message.contains('relation'))) {
    return 'shared_users_setup_required';
  }

  return 'unknown_error';
}

String messageForErrorKey(AppLocalizations l10n, String? errorKey) {
  return switch (errorKey) {
    'invalid_credentials' => l10n.errorInvalidCredentials,
    'email_not_confirmed' => l10n.errorEmailNotConfirmed,
    'anonymous_auth_disabled' => l10n.errorAnonymousAuthDisabled,
    'email_already_registered' => l10n.errorEmailAlreadyRegistered,
    'email_error' => l10n.errorEmail,
    'password_error' => l10n.errorPassword,
    'password_reset_code_required' => l10n.errorPasswordResetCodeRequired,
    'password_reset_code_invalid' => l10n.errorPasswordResetCodeInvalid,
    'password_reset_code_expired' => l10n.errorPasswordResetCodeExpired,
    'password_too_short' => l10n.errorPasswordTooShort,
    'passwords_do_not_match' => l10n.errorPasswordsDoNotMatch,
    'terms_not_accepted' => l10n.errorTermsNotAccepted,
    'network_error' => l10n.errorNetwork,
    'purchase_error' => l10n.errorPurchase,
    'delete_account_setup_required' => l10n.errorDeleteAccountSetupRequired,
    'delete_account_failed' => l10n.errorDeleteAccountFailed,
    'shared_users_setup_required' => l10n.errorSharedUsersSetupRequired,
    'delete_account_not_implemented' => l10n.errorDeleteAccountNotImplemented,
    'error_no_estate' => l10n.errorNoEstate,
    'code_not_found_or_expired' => l10n.errorCodeNotFoundOrExpired,
    'invalid_code_format' => l10n.errorInvalidCodeFormat,
    'rate_limit_exceeded' => l10n.errorRateLimitExceeded,
    'estate_inactive' => l10n.errorEstateInactive,
    'role_limit_reached' => l10n.errorRoleLimitReached,
    'apartment_limit_reached' => l10n.errorApartmentLimitReached,
    'error_moderation_rate_limit' => l10n.errorModerationRateLimit,
    'error_moderation_already_reported' => l10n.errorModerationAlreadyReported,
    'error_moderation_content_not_found' => l10n.errorModerationContentNotFound,
    'error_moderation_unauthenticated' => l10n.errorModerationUnauthenticated,
    'error_moderation_unknown' => l10n.errorModerationUnknown,
    'error_location_service_disabled' => l10n.errorLocationServiceDisabled,
    'error_location_permission_denied' => l10n.errorLocationPermissionDenied,
    'error_location_permission_denied_forever' => l10n.errorLocationPermissionDeniedForever,
    'error_location_unknown' => l10n.errorLocationUnknown,
    'resolutions_load_error' => l10n.errorResolutionsLoad,
    'resolution_vote_error' => l10n.errorResolutionVote,
    'resolution_create_error' => l10n.errorResolutionCreate,
    'resolution_close_error' => l10n.errorResolutionClose,
    'maintenance_load_error' => l10n.errorMaintenanceLoad,
    'maintenance_create_error' => l10n.errorMaintenanceCreate,
    'maintenance_mark_error' => l10n.errorMaintenanceMark,
    'unknown_error' || null => l10n.errorUnknown,
    _ => l10n.errorWithKey(errorKey),
  };
}
