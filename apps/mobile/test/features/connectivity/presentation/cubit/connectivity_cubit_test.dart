import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:mestio/features/connectivity/data/repositories/connectivity_repository.dart';
import 'package:mestio/features/connectivity/presentation/cubit/connectivity_cubit.dart';

class MockConnectivityRepository extends Mock implements ConnectivityRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockConnectivityRepository repo;
  late BehaviorSubject<bool> statusSubject;

  setUp(() {
    repo = MockConnectivityRepository();
    statusSubject = BehaviorSubject<bool>();
    when(() => repo.isConnectedStream).thenAnswer((_) => statusSubject.stream);
  });

  tearDown(() {
    statusSubject.close();
  });

  group('ConnectivityCubit', () {
    blocTest<ConnectivityCubit, ConnectivityState>(
      'starts as unknown',
      build: () => ConnectivityCubit(repo),
      verify: (cubit) {
        expect(cubit.state, isA<ConnectivityUnknown>());
      },
    );

    blocTest<ConnectivityCubit, ConnectivityState>(
      'emits connected when the stream reports true',
      build: () => ConnectivityCubit(repo),
      act: (_) => statusSubject.add(true),
      expect: () => [const ConnectivityState.connected()],
    );

    blocTest<ConnectivityCubit, ConnectivityState>(
      'confirms disconnected via recheckNow before emitting disconnected',
      build: () {
        when(() => repo.recheckNow())
            .thenAnswer((_) async => ConnectivityProbeResult.disconnected);
        return ConnectivityCubit(repo);
      },
      act: (_) => statusSubject.add(false),
      expect: () => [const ConnectivityState.disconnected()],
      verify: (_) {
        verify(() => repo.recheckNow()).called(1);
      },
    );

    blocTest<ConnectivityCubit, ConnectivityState>(
      'does not emit disconnected when recheckNow is inconclusive',
      build: () {
        when(() => repo.recheckNow())
            .thenAnswer((_) async => ConnectivityProbeResult.inconclusive);
        return ConnectivityCubit(repo);
      },
      act: (_) => statusSubject.add(false),
      expect: () => <ConnectivityState>[],
    );

    blocTest<ConnectivityCubit, ConnectivityState>(
      'retry is safe to call multiple times and reflects recheckNow result',
      build: () {
        when(() => repo.recheckNow())
            .thenAnswer((_) async => ConnectivityProbeResult.connected);
        return ConnectivityCubit(repo);
      },
      act: (cubit) async {
        await cubit.retry();
        await cubit.retry();
      },
      expect: () => [
        const ConnectivityState.connected(),
      ],
      verify: (_) {
        verify(() => repo.recheckNow()).called(2);
      },
    );
  });
}
