import 'dart:ui';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Initializes global error handling with Crashlytics.
/// Call this in main.dart after Firebase.initializeApp().
void bootstrapWithCrashlytics() {
  // Set up Flutter error handler
  FlutterError.onError = (FlutterErrorDetails details) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(details);
  };

  // Set up platform error handler
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true; // Prevent default error dialog
  };
}

/// Error widget that shows a friendly message instead of red screen.
class ErrorBoundaryWidget extends StatelessWidget {
  const ErrorBoundaryWidget({super.key, required this.child});

  final Widget child;

  static Widget errorBuilder(BuildContext context, Object error, StackTrace? stack) {
    debugPrint('ErrorBoundary caught: $error\n$stack');
    return const _ErrorScreen();
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.orange,
              ),
              const SizedBox(height: 16),
              const Text(
                'Coś poszło nie tak',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Przepraszamy za niedogodności. Spróbuj uruchomić aplikację ponownie.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('Wróć do ekranu głównego'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
