import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// Provides a stream of online/offline status.
@LazySingleton()
class ConnectivityService {
  ConnectivityService() : _connectivity = Connectivity() {
    _init();
  }

  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  final _controller = StreamController<bool>.broadcast();

  bool _isOnline = true;

  bool get isOnline => _isOnline;

  Stream<bool> get onConnectivityChanged => _controller.stream;

  Future<void> _init() async {
    final results = await _connectivity.checkConnectivity();
    _isOnline = _hasInternet(results);

    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      final online = _hasInternet(results);
      if (online != _isOnline) {
        _isOnline = online;
        debugPrint('Connectivity changed: ${online ? "online" : "offline"}');
        _controller.add(online);
      }
    });
  }

  bool _hasInternet(List<ConnectivityResult> results) {
    return results.any((r) =>
        r == ConnectivityResult.mobile ||
        r == ConnectivityResult.wifi ||
        r == ConnectivityResult.ethernet);
  }

  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
