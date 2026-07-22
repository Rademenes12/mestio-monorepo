import 'package:flutter/widgets.dart';

import '../../../l10n/l10n.dart';
import '../models/user_session_model.dart';
import '../models/user_tier.dart';
import 'cubit/session_cubit.dart';

extension SessionLocalizationBuildContextX on BuildContext {
  String sessionDisplayName(SessionState session) {
    final l10n = this.l10n;

    return switch (session) {
      SessionAuthenticated(:final session) => _userDisplayName(l10n, session),
      SessionInitial() => l10n.loadingLabel,
      SessionUnauthenticated() => l10n.registeredUserDisplayName,
      SessionError() => l10n.sessionErrorTitle,
    };
  }

  String accountTypeLabel(SessionState session) {
    return accountKindLabel(session.accountKind);
  }

  String booleanLabel(bool value) {
    return value ? l10n.commonYes : l10n.commonNo;
  }

  String accountKindLabel(AccountKind accountKind) {
    return switch (accountKind) {
      AccountKind.guest => l10n.accountTypeGuest,
      AccountKind.registered => l10n.accountTypeRegistered,
    };
  }

  String limitAccessLabel(LimitAccessState limitAccessState) {
    return switch (limitAccessState) {
      LimitAccessState.guest => l10n.limitAccessGuest,
      LimitAccessState.registered => l10n.limitAccessRegistered,
      LimitAccessState.pro => l10n.limitAccessPro,
    };
  }

  String _userDisplayName(AppLocalizations l10n, UserSessionModel session) {
    final displayName = session.displayNameOrNull;
    if (displayName != null) {
      return displayName;
    }

    return session.isAnonymous
        ? l10n.guestDisplayName
        : l10n.registeredUserDisplayName;
  }
}
