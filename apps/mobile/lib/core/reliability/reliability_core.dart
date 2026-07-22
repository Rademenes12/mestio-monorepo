import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Result type for operations that can fail with user-friendly messages.
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;
}

class Failure<T> extends Result<T> {
  const Failure(this.message, [this.cause]);
  final String message;
  final Object? cause;
}

/// Wraps Supabase calls, converting exceptions to user-friendly Polish messages.
Future<Result<T>> guardSupabase<T>(Future<T> Function() operation) async {
  try {
    final result = await operation();
    return Success(result);
  } on PostgrestException catch (e) {
    return Failure(_mapPostgrestError(e), e);
  } on AuthException catch (e) {
    return Failure(_mapAuthError(e), e);
  } on StorageException catch (e) {
    return Failure(_mapStorageError(e), e);
  } on SocketException catch (e) {
    return Failure('Brak połączenia z internetem. Sprawdź sieć i spróbuj ponownie.', e);
  } on TimeoutException catch (_) {
    return Failure('Operacja trwała zbyt długo. Spróbuj ponownie.');
  } catch (e) {
    debugPrint('Unexpected error in guardSupabase: $e');
    return Failure('Wystąpił nieoczekiwany błąd. Spróbuj ponownie.', e);
  }
}

/// Retries operation with exponential backoff for transient errors.
/// Does NOT retry permission errors (403) or validation errors (400).
Future<T> retry<T>(
  Future<T> Function() operation, {
  int maxAttempts = 3,
  Duration initialDelay = const Duration(milliseconds: 500),
}) async {
  var attempt = 0;
  var delay = initialDelay;

  while (true) {
    try {
      return await operation();
    } catch (e) {
      attempt++;
      if (attempt >= maxAttempts || !_isRetryable(e)) {
        rethrow;
      }
      debugPrint('Retry attempt $attempt/$maxAttempts after ${delay.inMilliseconds}ms: $e');
      await Future.delayed(delay);
      delay *= 2; // Exponential backoff
    }
  }
}

bool _isRetryable(Object error) {
  if (error is SocketException) return true;
  if (error is TimeoutException) return true;
  if (error is PostgrestException) {
    final code = error.code;
    if (code == null) return false;
    // Retry on: connection failures, 5xx errors, rate limits
    return code == 'PGRST000' || // Connection error
        code == 'PGRST116' || // Connection refused
        (code.startsWith('5') && code.length == 3); // 5xx errors
  }
  return false;
}

String _mapPostgrestError(PostgrestException e) {
  final code = e.code;
  return switch (code) {
    '23505' => 'Ten rekord już istnieje.',
    '23503' => 'Nie można usunąć - powiązane dane istnieją w systemie.',
    '42501' => 'Brak uprawnień do tej operacji.',
    'PGRST116' || 'PGRST000' => 'Brak połączenia z serwerem. Sprawdź internet.',
    '22P02' => 'Nieprawidłowy format danych.',
    _ => 'Błąd bazy danych: ${e.message}',
  };
}

String _mapAuthError(AuthException e) {
  final msg = e.message.toLowerCase();
  if (msg.contains('invalid login credentials')) {
    return 'Nieprawidłowy email lub hasło.';
  }
  if (msg.contains('email not confirmed')) {
    return 'Potwierdź adres email przed zalogowaniem.';
  }
  if (msg.contains('too many')) {
    return 'Zbyt wiele prób. Spróbuj ponownie za kilka minut.';
  }
  if (msg.contains('user not found')) {
    return 'Konto nie istnieje.';
  }
  return 'Błąd logowania: ${e.message}';
}

String _mapStorageError(StorageException e) {
  if (e.message.contains('not found')) {
    return 'Plik nie został znaleziony.';
  }
  if (e.message.contains('permission')) {
    return 'Brak uprawnień do pliku.';
  }
  return 'Błąd przesyłania pliku: ${e.message}';
}
