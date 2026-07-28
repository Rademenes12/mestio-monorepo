// Conditionally exports the correct Firebase/Crashlytics bootstrap based on
// the target platform. On web all calls are no-ops (Crashlytics unsupported),
// while native builds wire up the real integration.
export 'firebase_setup_stub.dart'
    if (dart.library.io) 'firebase_setup_real.dart';
