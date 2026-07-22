import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mestio/app/session/data/repositories/session_repository.dart';
import 'package:mestio/app/session/models/session_status_model.dart';
import 'package:mestio/app/session/models/user_session_model.dart';
import 'package:mestio/app/session/presentation/cubit/session_cubit.dart';

class _FakeSessionRepository implements SessionRepository {
  final _controller = StreamController<SessionStatusModel>.broadcast();
  var _current = const SessionStatusModel.loading();
  var refreshCount = 0;

  @override
  Stream<SessionStatusModel> get sessionStream => _controller.stream;

  @override
  SessionStatusModel get current => _current;

  @override
  Future<void> refresh() async {
    refreshCount++;
  }

  @override
  void dispose() {
    _controller.close();
  }

  void emitStatus(SessionStatusModel status) {
    _current = status;
    _controller.add(status);
  }

  void emitError(Object error) {
    _controller.addError(error, StackTrace.current);
  }
}

void main() {
  group('SessionCubit', () {
    late _FakeSessionRepository sessionRepository;

    setUp(() {
      sessionRepository = _FakeSessionRepository();
    });

    blocTest<SessionCubit, SessionState>(
      'emits unauthenticated when repository reports no session',
      build: () => SessionCubit(sessionRepository),
      act: (_) => sessionRepository.emitStatus(
        const SessionStatusModel.unauthenticated(),
      ),
      expect: () => const [SessionState.unauthenticated()],
    );

    blocTest<SessionCubit, SessionState>(
      'emits authenticated when repository reports a session',
      build: () => SessionCubit(sessionRepository),
      act: (_) => sessionRepository.emitStatus(
        const SessionStatusModel.authenticated(
          session: UserSessionModel(
            userId: 'user-1',
            email: null,
            isAnonymous: true,
            sharedUser: null,
          ),
        ),
      ),
      expect: () => const [
        SessionState.authenticated(
          session: UserSessionModel(
            userId: 'user-1',
            email: null,
            isAnonymous: true,
            sharedUser: null,
          ),
        ),
      ],
    );

    blocTest<SessionCubit, SessionState>(
      'emits error when repository stream fails',
      build: () => SessionCubit(sessionRepository),
      act: (_) => sessionRepository.emitError(Exception('network failed')),
      expect: () => const [SessionState.error(errorKey: 'network_error')],
    );

    test('refresh delegates to repository', () async {
      final cubit = SessionCubit(sessionRepository);

      await cubit.refresh();

      expect(sessionRepository.refreshCount, 1);
      await cubit.close();
      sessionRepository.dispose();
    });
  });
}
