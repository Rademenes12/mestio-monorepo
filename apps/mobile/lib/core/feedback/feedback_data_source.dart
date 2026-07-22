import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class FeedbackDataSource {
  Future<void> submitFeedback({
    required String userId,
    required String type,
    required String message,
    String? userRole,
    String? userEmail,
  });
}

@LazySingleton(as: FeedbackDataSource)
class FeedbackDataSourceImpl implements FeedbackDataSource {
  FeedbackDataSourceImpl(this._supabase);

  final SupabaseClient _supabase;

  @override
  Future<void> submitFeedback({
    required String userId,
    required String type,
    required String message,
    String? userRole,
    String? userEmail,
  }) async {
    try {
      await _supabase.from('fixflow_feedback').insert({
        'user_id': userId,
        'type': type,
        'message': message,
        'user_role': userRole,
        'user_email': userEmail,
      });
    } catch (error) {
      debugPrint('\u274c [FeedbackDataSource] submitFeedback error: $error');
      rethrow;
    }
  }
}
