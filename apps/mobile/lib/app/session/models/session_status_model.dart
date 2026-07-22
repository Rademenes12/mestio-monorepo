import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_session_model.dart';

part 'session_status_model.freezed.dart';

@freezed
sealed class SessionStatusModel with _$SessionStatusModel {
  const factory SessionStatusModel.loading() = SessionStatusLoading;

  const factory SessionStatusModel.unauthenticated() =
      SessionStatusUnauthenticated;

  const factory SessionStatusModel.authenticated({
    required UserSessionModel session,
  }) = SessionStatusAuthenticated;
}

extension SessionStatusModelX on SessionStatusModel {
  bool get isLoading => this is SessionStatusLoading;

  bool get isUnauthenticated => this is SessionStatusUnauthenticated;

  bool get isAuthenticated => this is SessionStatusAuthenticated;

  UserSessionModel? get sessionOrNull => switch (this) {
    SessionStatusAuthenticated(:final session) => session,
    SessionStatusLoading() || SessionStatusUnauthenticated() => null,
  };
}
