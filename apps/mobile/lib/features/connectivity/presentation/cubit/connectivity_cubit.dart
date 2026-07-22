import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../data/repositories/connectivity_repository.dart';

part 'connectivity_cubit.freezed.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

/// Three possible states:
///   - [unknown]       — app just started, initial probe is in flight.
///   - [connected]     — device has real internet access.
///   - [disconnected]  — device is offline (or behind a captive portal that
///                        the checker couldn't reach through).
///
/// The UI should treat [unknown] the same as [connected] — don't show a
/// banner until we're *sure* the user is offline. This avoids a brief flash
/// of "no internet" on every cold start.
@freezed
sealed class ConnectivityState with _$ConnectivityState {
  const factory ConnectivityState.unknown() = ConnectivityUnknown;
  const factory ConnectivityState.connected() = ConnectivityConnected;
  const factory ConnectivityState.disconnected() = ConnectivityDisconnected;
}

// ---------------------------------------------------------------------------
// Cubit
// ---------------------------------------------------------------------------

/// Global cubit that tracks internet reachability.
///
/// ## How to use
///
/// This cubit is registered as a `@LazySingleton` and provided via
/// `BlocProvider.value` at the top of the widget tree (in `app.dart`).
///
/// ### Show/hide an offline banner (recommended)
///
/// Place a single `BlocListener<ConnectivityCubit, ConnectivityState>` high
/// in the tree (e.g. inside `MaterialApp.builder`) and show/hide a persistent
/// `MaterialBanner` or a custom overlay:
///
/// ```dart
/// BlocListener<ConnectivityCubit, ConnectivityState>(
///   listenWhen: (prev, curr) => prev != curr,
///   listener: (context, state) {
///     if (state is ConnectivityDisconnected) {
///       // show banner
///     } else {
///       // hide banner
///     }
///   },
///   child: child,
/// )
/// ```
///
/// ### Guard an action (optional, per-screen)
///
/// If you want to skip a network call when you *know* the device is offline
/// (to give the user faster feedback instead of waiting for a timeout):
///
/// ```dart
/// final isOffline =
///     context.read<ConnectivityCubit>().state is ConnectivityDisconnected;
/// if (isOffline) {
///   emit(state.copyWith(errorKey: 'network_error'));
///   return;
/// }
/// ```
///
/// ### Retry / recheck
///
/// Call `retry()` to trigger a manual probe — e.g. after the app returns
/// from the background or the user taps a "check connection" button.
@LazySingleton()
class ConnectivityCubit extends Cubit<ConnectivityState> {
  ConnectivityCubit(this._repository)
    : super(const ConnectivityState.unknown()) {
    _subscription = _repository.isConnectedStream.listen(
      _onStatusChanged,
      onError: (Object error, StackTrace stackTrace) {
        debugPrint('❌ [ConnectivityCubit] stream error: $error');
      },
    );
    _appLifecycleListener = AppLifecycleListener(
      onStateChange: _onAppLifecycleStateChanged,
    );
  }

  final ConnectivityRepository _repository;
  StreamSubscription<bool>? _subscription;
  late final AppLifecycleListener _appLifecycleListener;
  bool _isRechecking = false;
  int _revision = 0;

  /// Trigger a manual connectivity probe.
  ///
  /// Safe to call multiple times — the repository handles deduplication
  /// via `distinct()`.
  Future<void> retry() => _refreshConnectivity();

  @override
  Future<void> close() {
    _subscription?.cancel();
    _appLifecycleListener.dispose();
    return super.close();
  }

  void _onStatusChanged(bool isConnected) {
    if (isConnected) {
      _revision++;
      _emitConnected();
      return;
    }

    if (_isRechecking) return;

    final expectedRevision = ++_revision;
    unawaited(_confirmDisconnected(expectedRevision));
  }

  void _onAppLifecycleStateChanged(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_refreshConnectivity());
    }
  }

  Future<void> _confirmDisconnected(int expectedRevision) async {
    if (_isRechecking) return;

    _isRechecking = true;

    try {
      final result = await _repository.recheckNow();
      if (expectedRevision != _revision) return;

      switch (result) {
        case ConnectivityProbeResult.connected:
          _emitConnected();
        case ConnectivityProbeResult.disconnected:
          _emitDisconnected();
        case ConnectivityProbeResult.inconclusive:
          debugPrint(
            'ℹ️ [ConnectivityCubit] disconnect confirmation inconclusive',
          );
      }
    } finally {
      _isRechecking = false;
    }
  }

  Future<void> _refreshConnectivity() async {
    if (_isRechecking) return;

    final expectedRevision = ++_revision;
    _isRechecking = true;

    try {
      final result = await _repository.recheckNow();
      if (expectedRevision != _revision) return;

      switch (result) {
        case ConnectivityProbeResult.connected:
          _emitConnected();
        case ConnectivityProbeResult.disconnected:
          _emitDisconnected();
        case ConnectivityProbeResult.inconclusive:
          debugPrint('ℹ️ [ConnectivityCubit] recheck inconclusive');
      }
    } finally {
      _isRechecking = false;
    }
  }

  void _emitConnected() {
    debugPrint('ℹ️ [ConnectivityCubit] state → connected');
    emit(const ConnectivityState.connected());
  }

  void _emitDisconnected() {
    debugPrint('ℹ️ [ConnectivityCubit] state → disconnected');
    emit(const ConnectivityState.disconnected());
  }
}
