import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// Thin wrapper around [InternetConnection] from the
/// `internet_connection_checker_plus` package.
///
/// Responsibilities (Data Source layer):
///   - Expose the raw connectivity stream so upper layers can react to changes.
///   - Provide a one-shot probe for the initial state on cold start.
///
/// This is the **only** place in the app that knows about the
/// `internet_connection_checker_plus` package. Everything above works with
/// a simple `bool` provided by [ConnectivityRepository].
abstract class ConnectivityDataSource {
  /// Continuous stream of connectivity changes.
  ///
  /// Emits [InternetStatus.connected] or [InternetStatus.disconnected]
  /// whenever the real internet reachability changes (not just WiFi on/off).
  Stream<InternetStatus> watchStatus();

  /// One-shot check — useful for seeding the initial state so the UI doesn't
  /// stay in "unknown" while waiting for the first stream event.
  Future<bool> hasConnection();
}

@LazySingleton(as: ConnectivityDataSource)
class InternetConnectionDataSource implements ConnectivityDataSource {
  InternetConnectionDataSource(this._checker);

  final InternetConnection _checker;

  @override
  Stream<InternetStatus> watchStatus() => _checker.onStatusChange;

  @override
  Future<bool> hasConnection() => _checker.hasInternetAccess;
}
