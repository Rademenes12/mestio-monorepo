import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../features/profiles/models/shared_user_model.dart';
import '../../../../shared/error_messages.dart';
import '../../models/session_status_model.dart';
import '../../data/repositories/session_repository.dart';
import '../../models/user_session_model.dart';
import '../../models/user_tier.dart';

part 'session_cubit.freezed.dart';

@freezed
sealed class SessionState with _$SessionState {
  const SessionState._();

  const factory SessionState.initial() = SessionInitial;

  const factory SessionState.unauthenticated() = SessionUnauthenticated;

  const factory SessionState.authenticated({
    required UserSessionModel session,
  }) = SessionAuthenticated;

  const factory SessionState.error({required String errorKey}) = SessionError;

  bool get isInitial => this is SessionInitial;

  bool get isUnauthenticated => this is SessionUnauthenticated;

  bool get isAuthenticated => this is SessionAuthenticated;

  UserSessionModel? get sessionOrNull => switch (this) {
    SessionAuthenticated(:final session) => session,
    SessionInitial() || SessionUnauthenticated() || SessionError() => null,
  };

  String? get userIdOrNull => sessionOrNull?.userId;

  String? get emailOrNull => sessionOrNull?.email;

  SharedUserModel? get sharedUserOrNull => sessionOrNull?.sharedUser;

  bool get isAnonymousUser => sessionOrNull?.isAnonymous ?? false;

  bool get isProUser => sessionOrNull?.isPro ?? false;

  AccountKind get accountKind =>
      sessionOrNull?.accountKind ?? AccountKind.guest;

  LimitAccessState get limitAccessState =>
      sessionOrNull?.limitAccessState ?? LimitAccessState.guest;

  String? get displayNameOrNull => sessionOrNull?.displayNameOrNull;

  bool get shouldShowRegisterCTA =>
      sessionOrNull?.shouldShowRegisterCTA ?? false;

  bool get shouldShowProtectProBanner =>
      sessionOrNull?.shouldShowProtectProBanner ?? false;

  String? get errorKeyOrNull => switch (this) {
    SessionError(:final errorKey) => errorKey,
    SessionInitial() ||
    SessionUnauthenticated() ||
    SessionAuthenticated() => null,
  };
}

@LazySingleton()
class SessionCubit extends Cubit<SessionState> {
  SessionCubit(this._sessionRepository) : super(const SessionState.initial()) {
    debugPrint('ℹ️ [SessionCubit] initializing, subscribing to sessionStream');
    _subscription = _sessionRepository.sessionStream.listen(
      _onSessionChanged,
      onError: (Object error, StackTrace stackTrace) {
        debugPrint('❌ [SessionCubit] Stream error: $error');
        emit(SessionState.error(errorKey: mapErrorToKey(error)));
      },
    );
  }

  final SessionRepository _sessionRepository;
  StreamSubscription<SessionStatusModel>? _subscription;

  Future<void> refresh() => _sessionRepository.refresh();

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  void _onSessionChanged(SessionStatusModel status) {
    debugPrint('ℹ️ [SessionCubit] _onSessionChanged status=${status.runtimeType}');
    if (status.isLoading) {
      emit(const SessionState.initial());
      return;
    }

    if (status.isUnauthenticated) {
      debugPrint('ℹ️ [SessionCubit] emitting unauthenticated');
      emit(const SessionState.unauthenticated());
      return;
    }

    emit(SessionState.authenticated(session: status.sessionOrNull!));
  }
}
