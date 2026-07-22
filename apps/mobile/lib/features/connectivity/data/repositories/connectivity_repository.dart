import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:rxdart/rxdart.dart';

import '../datasources/connectivity_data_source.dart';

enum ConnectivityProbeResult { connected, disconnected, inconclusive }

/// Maps raw [InternetStatus] events into a simple `bool` stream that the rest
/// of the app can depend on without knowing anything about the connectivity
/// package.
///
/// Stream behaviour:
///   - Uses `distinct()` so consumers only see actual *changes*.
///   - Uses `BehaviorSubject` so late subscribers immediately get the latest
///     known value instead of waiting for the next network event.
///
/// Usage from a Cubit:
/// ```dart
/// _subscription = connectivityRepository.isConnectedStream.listen((online) {
///   emit(online ? Connected() : Disconnected());
/// });
/// ```
abstract class ConnectivityRepository {
  /// Continuous stream of connectivity state. Emits `true` when the device has
  /// real internet access, `false` otherwise.
  ///
  /// The stream is seeded with the result of an initial probe so the first
  /// value is available almost immediately (no "unknown" gap).
  Stream<bool> get isConnectedStream;

  /// Synchronous snapshot — returns the last known value, or `null` if the
  /// initial probe hasn't finished yet (should be very brief).
  bool? get isConnected;

  /// Trigger a manual re-check. Useful for retry buttons or when the app
  /// returns from the background.
  Future<ConnectivityProbeResult> recheckNow();

  /// Release internal resources (stream subscriptions, subjects).
  /// Called by the DI container on singleton disposal.
  void dispose();
}

@LazySingleton(as: ConnectivityRepository)
class ConnectivityRepositoryImpl implements ConnectivityRepository {
  ConnectivityRepositoryImpl(this._dataSource) {
    _init();
  }

  final ConnectivityDataSource _dataSource;

  /// BehaviorSubject keeps the latest value and replays it to new listeners.
  final _subject = BehaviorSubject<bool>();

  StreamSubscription<InternetStatus>? _statusSubscription;

  void _init() {
    // Seed with a one-shot probe so the UI gets a value on cold start
    // before the stream emits its first event.
    _dataSource
        .hasConnection()
        .then((connected) {
          debugPrint(
            'ℹ️ [ConnectivityRepository] initial probe: connected=$connected',
          );
          if (!_subject.isClosed) _subject.add(connected);
        })
        .catchError((Object error) {
          debugPrint('❌ [ConnectivityRepository] initial probe error: $error');
        });

    // Forward ongoing changes from the data source.
    _statusSubscription = _dataSource.watchStatus().listen(
      (status) {
        final connected = status == InternetStatus.connected;
        debugPrint(
          'ℹ️ [ConnectivityRepository] status changed: connected=$connected',
        );
        if (!_subject.isClosed) _subject.add(connected);
      },
      onError: (Object error) {
        debugPrint('❌ [ConnectivityRepository] stream error: $error');
      },
    );
  }

  @override
  Stream<bool> get isConnectedStream => _subject.stream.distinct();

  @override
  bool? get isConnected => _subject.valueOrNull;

  @override
  Future<ConnectivityProbeResult> recheckNow() async {
    try {
      final connected = await _dataSource.hasConnection();
      debugPrint(
        'ℹ️ [ConnectivityRepository] manual recheck: connected=$connected',
      );
      if (!_subject.isClosed) _subject.add(connected);
      return connected
          ? ConnectivityProbeResult.connected
          : ConnectivityProbeResult.disconnected;
    } catch (error) {
      debugPrint('❌ [ConnectivityRepository] recheck error: $error');
      return ConnectivityProbeResult.inconclusive;
    }
  }

  @override
  @disposeMethod
  void dispose() {
    _statusSubscription?.cancel();
    _subject.close();
  }
}
