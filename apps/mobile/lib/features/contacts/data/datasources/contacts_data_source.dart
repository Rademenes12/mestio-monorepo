import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/contact_model.dart';

abstract class ContactsDataSource {
  /// Returns active contacts for the given estate. When [estateId] is null,
  /// only legacy global contacts (estate_id IS NULL) are returned.
  Future<List<EmergencyContact>> getContacts({String? estateId});
  Future<EmergencyContact> createContact(EmergencyContact contact);
  Future<void> deleteContact(String id);
}

@LazySingleton(as: ContactsDataSource)
class ContactsDataSourceImpl implements ContactsDataSource {
  ContactsDataSourceImpl(this._client);
  final SupabaseClient _client;

  @override
  Future<List<EmergencyContact>> getContacts({String? estateId}) async {
    try {
      debugPrint('ℹ️ [ContactsDataSource] fetching contacts estate=$estateId');

      final query = _client
          .from('fixflow_emergency_contacts')
          .select()
          .eq('is_active', true);

      // Scope to the estate; legacy contacts have NULL estate_id.
      final filtered = estateId != null
          ? query.eq('estate_id', estateId)
          : query.isFilter('estate_id', null);

      final response = await filtered
          .order('display_order')
          .order('name')
          .timeout(const Duration(seconds: 8));

      debugPrint('ℹ️ [ContactsDataSource] fetched ${response.length} contacts');

      return (response as List)
          .map((json) => EmergencyContact.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('❌ [ContactsDataSource] getContacts failed: $e');
      rethrow;
    }
  }

  @override
  Future<EmergencyContact> createContact(EmergencyContact contact) async {
    try {
      debugPrint('ℹ️ [ContactsDataSource] creating contact');
      
      final data = contact.toJson()
        ..remove('id'); // Let DB generate ID
      
      final response = await _client
          .from('fixflow_emergency_contacts')
          .insert(data)
          .select()
          .single()
          .timeout(const Duration(seconds: 8));
      
      debugPrint('✅ [ContactsDataSource] contact created');
      return EmergencyContact.fromJson(response);
    } catch (e) {
      debugPrint('❌ [ContactsDataSource] createContact failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteContact(String id) async {
    try {
      debugPrint('ℹ️ [ContactsDataSource] deleting contact: $id');
      
      await _client
          .from('fixflow_emergency_contacts')
          .update({'is_active': false})
          .eq('id', id)
          .timeout(const Duration(seconds: 8));
      
      debugPrint('✅ [ContactsDataSource] contact deleted');
    } catch (e) {
      debugPrint('❌ [ContactsDataSource] deleteContact failed: $e');
      rethrow;
    }
  }
}