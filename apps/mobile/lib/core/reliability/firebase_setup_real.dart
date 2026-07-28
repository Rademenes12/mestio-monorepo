// Firebase / Crashlytics bootstrap for non-web platforms.
// This file is compiled only for dart:io targets (iOS, Android, desktop).
import 'dart:async';
import 'dart:ui' as ui;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show FlutterError, FlutterErrorDetails;
import '../../firebase_options.dart';

Future<void> firebaseInitialize() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = (FlutterErrorDetails details) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(details);
  };

  ui.PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
}

void firebaseRecordError(Object error, StackTrace stack) {
  FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
}
