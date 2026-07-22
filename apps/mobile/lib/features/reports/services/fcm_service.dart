import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/api_keys.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
  } catch (_) {
    // Ignore initialization errors in background isolates
  }
  debugPrint("Otrzymano powiadomienie FCM w tle: ${message.messageId}");
}

class FcmNotificationEvent {
  final String title;
  final String body;
  final String reportId;
  final String status;
  final DateTime timestamp;

  FcmNotificationEvent({
    required this.title,
    required this.body,
    required this.reportId,
    required this.status,
    required this.timestamp,
  });
}

@lazySingleton
class FcmService {
  final _notificationStreamController = StreamController<FcmNotificationEvent>.broadcast();
  Stream<FcmNotificationEvent> get notificationStream => _notificationStreamController.stream;

  bool _isInitialized = false;
  bool isFirebaseMessagingCapable = false;
  String? _fcmToken;

  String? get fcmToken => _fcmToken;

  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;

    try {
      if (Firebase.apps.isNotEmpty) {
        FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

        final messaging = FirebaseMessaging.instance;
        final settings = await messaging.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );

        debugPrint('Uprawnienia powiadomień FCM: ${settings.authorizationStatus}');

        try {
          _fcmToken = await messaging.getToken();
          debugPrint('Pobrany FCM Token: $_fcmToken');
        } catch (e) {
          debugPrint('Błąd pobierania FCM Token: $e');
        }

        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          debugPrint('Otrzymano powiadomienie FCM w pierwszym planie: ${message.messageId}');
          _processIncomingMessage(message);
        });

        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          debugPrint('Aplikacja została otwarta przez kliknięcie FCM: ${message.messageId}');
          _processIncomingMessage(message);
        });

        final initialMessage = await messaging.getInitialMessage();
        if (initialMessage != null) {
          debugPrint('Aplikacja uruchomiona z powiadomienia (Terminated): ${initialMessage.messageId}');
          _processIncomingMessage(initialMessage);
        }

        isFirebaseMessagingCapable = true;
      } else {
        isFirebaseMessagingCapable = false;
        debugPrint('Firebase Core nie zainicjalizowane - włączono tryb symulacji FCM.');
      }
    } catch (e) {
      isFirebaseMessagingCapable = false;
      debugPrint('Błąd inicjalizacji Firebase Messaging: $e. Tryb symulacji włączony.');
    }
  }

  void _processIncomingMessage(RemoteMessage message) {
    final title = message.notification?.title ?? message.data['title'] ?? 'Aktualizacja Zgłoszenia';
    final body = message.notification?.body ?? message.data['body'] ?? 'Status Twojego zgłoszenia uległ zmianie.';
    final reportId = message.data['reportId'] ?? '';
    final status = message.data['status'] ?? '';

    final event = FcmNotificationEvent(
      title: title,
      body: body,
      reportId: reportId,
      status: status,
      timestamp: DateTime.now(),
    );

    _notificationStreamController.add(event);
  }

  final Set<String> _subscribedTopics = {};
  List<String> get subscribedTopics => _subscribedTopics.toList();

  String sanitizeTopicName(String input) {
    return input.replaceAll(RegExp(r'[^a-zA-Z0-9-_.~%]'), '_').toLowerCase();
  }

  Future<void> subscribeToTopic(String topic) async {
    final sanitized = sanitizeTopicName(topic);
    if (_subscribedTopics.contains(sanitized)) return;
    _subscribedTopics.add(sanitized);
    debugPrint("FCM Subscribed locally/remotely to topic: $sanitized");
    if (isFirebaseMessagingCapable) {
      try {
        await FirebaseMessaging.instance.subscribeToTopic(sanitized);
      } catch (e) {
        debugPrint("Error subscribing to real FCM topic '$sanitized': $e");
      }
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    final sanitized = sanitizeTopicName(topic);
    if (!_subscribedTopics.contains(sanitized)) return;
    _subscribedTopics.remove(sanitized);
    debugPrint("FCM Unsubscribed locally/remotely from topic: $sanitized");
    if (isFirebaseMessagingCapable) {
      try {
        await FirebaseMessaging.instance.unsubscribeFromTopic(sanitized);
      } catch (e) {
        debugPrint("Error unsubscribing from real FCM topic '$sanitized': $e");
      }
    }
  }

  Future<void> clearSubscriptions() async {
    final topicsCopy = List<String>.from(_subscribedTopics);
    for (final topic in topicsCopy) {
      await unsubscribeFromTopic(topic);
    }
    _subscribedTopics.clear();
  }

  Future<void> updateUserSubscriptions({
    required String role,
    required String email,
    String? specialty,
  }) async {
    await clearSubscriptions();

    if (role == 'Mieszkaniec') {
      final residentTopic = "resident_${sanitizeTopicName(email)}";
      await subscribeToTopic(residentTopic);
      debugPrint("Logged in as Resident (Email: $email). Configured topic subscription: $residentTopic");
    } else if (role == 'Serwisant' && specialty != null && specialty.isNotEmpty) {
      final techTopic = "tech_${sanitizeTopicName(specialty)}";
      await subscribeToTopic(techTopic);
      debugPrint("Logged in as Technician (Specialty: $specialty). Configured topic subscription: $techTopic");
    } else if (role == 'Zarząd' || role == 'Administrator') {
      await subscribeToTopic("admin_reports");
      await subscribeToTopic("all_broadcasts");
      debugPrint("Logged in as Admin/Board. Subscribed to general admin/broadcast topics.");
    }
  }

  void simulateIncomingNotification({
    required String title,
    required String body,
    required String reportId,
    required String status,
    String? topic,
  }) {
    if (topic != null) {
      final sanitized = sanitizeTopicName(topic);
      final isSubscribed = _subscribedTopics.contains(sanitized);
      debugPrint("Simulated FCM received on topic '$sanitized'. Subscribed? $isSubscribed");
      if (!isSubscribed) {
        debugPrint("FCM notification blocked! Reason: Not subscribed to topic '$sanitized'.");
        return;
      }
    }

    final event = FcmNotificationEvent(
      title: title,
      body: body,
      reportId: reportId,
      status: status,
      timestamp: DateTime.now(),
    );

    _notificationStreamController.add(event);
  }

  void triggerStatusChangeNotification({
    required String reportTitle,
    required String reporterEmail,
    required String reportId,
    required String newStatus,
  }) {
    if (newStatus == 'W trakcie realizacji' || newStatus == 'Zrealizowane' ||
        newStatus == 'Zamknięte' || newStatus == 'Odrzucone') {
      final statusLabel = switch (newStatus) {
        'W trakcie realizacji' => 'W trakcie realizacji 🛠',
        'Zrealizowane' => 'Zrealizowane ✅',
        'Zamknięte' => 'Zamknięte ✔️',
        'Odrzucone' => 'Odrzucone ❌',
        _ => newStatus,
      };
      
      final title = 'Zmiana statusu: $reportTitle';
      final body = 'Szanowny Mieszkańcu, Twoje zgłoszenie zmieniło status na: $statusLabel.';
      
      final targetTopic = "resident_${sanitizeTopicName(reporterEmail)}";
      debugPrint('Wysyłanie powiadomienia FCM do tematu: $targetTopic (Mieszkaniec: $reporterEmail)');
      
      _sendNotification(
        topic: targetTopic,
        title: title,
        body: body,
        data: {
          'reportId': reportId,
          'status': newStatus,
        },
      );
      
      // Also simulate locally for immediate UI feedback
      simulateIncomingNotification(
        title: title,
        body: body,
        reportId: reportId,
        status: newStatus,
        topic: targetTopic,
      );
    }
  }

  void triggerAssignmentNotification({
    required String reportTitle,
    required String assignedRole,
    required String reportId,
  }) {
    final title = 'Nowe zlecenie: $reportTitle';
    final body = 'Zgłoszenie zostało przypisane do Twojej specjalizacji: $assignedRole. Kliknij aby podjąć działania.';
    
    final targetTopic = "tech_${sanitizeTopicName(assignedRole)}";
    debugPrint('Wysyłanie powiadomienia FCM do tematu: $targetTopic (Specjalizacja: $assignedRole)');

    _sendNotification(
      topic: targetTopic,
      title: title,
      body: body,
      data: {
        'reportId': reportId,
        'status': 'W trakcie realizacji',
      },
    );
    
    // Also simulate locally for immediate UI feedback
    simulateIncomingNotification(
      title: title,
      body: body,
      reportId: reportId,
      status: 'W trakcie realizacji',
      topic: targetTopic,
    );
  }

  /// Sends notification via Supabase Edge Function
  Future<void> _sendNotification({
    required String topic,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    try {
      // Use the current user's session JWT so the Edge Function's
      // supabase.auth.getUser(token) succeeds. The anon key is NOT a user JWT
      // and would be rejected with invalid_token (401).
      final accessToken =
          Supabase.instance.client.auth.currentSession?.accessToken;
      if (accessToken == null) {
        debugPrint('⚠️ No active session; skipping push notification');
        return;
      }
      final url = Uri.parse('${ApiKeys.supabaseUrl}/functions/v1/send-notification');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'topic': topic,
          'title': title,
          'body': body,
          'data': data,
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('✅ Push notification sent to topic: $topic');
      } else {
        debugPrint('⚠️ Push notification failed (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      debugPrint('⚠️ Failed to send push notification: $e');
    }
  }

  void dispose() {
    _notificationStreamController.close();
  }
}
