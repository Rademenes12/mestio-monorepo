// Copyright © 2026 Adam Smaka. All rights reserved.
// This source code is proprietary software.
// Unauthorized copying, sharing, redistribution, or use outside the licensed course is prohibited.
// See LICENSE.md for full terms.

import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';
import 'core/config/api_keys.dart';
import 'core/config/app_config.dart';
import 'core/config/revenuecat_config.dart';
import 'core/di/injection.dart';
import 'core/reliability/app_bootstrap.dart';
import 'core/reliability/report_outbox.dart';
import 'firebase_options.dart';

void main() {
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();

      // Initialize Firebase
      Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ).then((_) {
        // Setup global error handling with Crashlytics
        bootstrapWithCrashlytics();

        // FCM is handled by FcmService (lazySingleton, inits on first access)
        (() async {
          if (AppConfig.hasSupabaseKeys) {
            await Supabase.initialize(
              url: ApiKeys.supabaseUrl,
              // ignore: deprecated_member_use
              anonKey: ApiKeys.supabaseAnonKey,
            );
            await _refreshExpiredSupabaseSessionIfNeeded();
          }

          await configureRevenueCat();
          await configureDependencies();

          // Initialize offline report queue
          await getIt<ReportOutbox>().init();

          runApp(
            ErrorBoundaryWidget(
              child: App(hasSupabaseKeys: AppConfig.hasSupabaseKeys),
            ),
          );
        })();
      });
    },
    (error, stack) {
      debugPrint('❌ [main] unhandled async error: $error');
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    },
  );
}

Future<void> _refreshExpiredSupabaseSessionIfNeeded() async {
  final session = Supabase.instance.client.auth.currentSession;
  if (session == null || !session.isExpired) return;

  try {
    debugPrint('ℹ️ [main] refreshing expired persisted Supabase session');
    await Supabase.instance.client.auth.refreshSession();
    debugPrint('✅ [main] expired persisted Supabase session refreshed');
  } catch (error) {
    // Non-blocking. SessionRepository still has a retry safety net for startup
    // races where Realtime subscribes before Supabase finishes token refresh.
    debugPrint('⚠️ [main] expired Supabase session refresh failed: $error');
  }
}
