import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Transport-only Supabase access for estate membership.
/// Returns raw rows; the repository maps them to models.
abstract class EstateDataSource {
  /// Returns the estates the current user belongs to (with role).
  Future<List<Map<String, dynamic>>> getMyEstates();

  /// Creates an estate and makes the caller its admin. Returns new estate id.
  Future<String> createEstate(String name);

  /// Returns the latest active invitation code for the given role, or null.
  Future<String?> getActiveInvitationCode(String estateId, {String role = 'resident'});

  /// Creates (or rotates) the invitation code for (estate, role).
  Future<String> createEstateInvitationCode(String estateId, {String role = 'resident'});

  /// Validates a code WITHOUT redeeming it, so the registration wizard can
  /// learn the role + estate before asking role-specific questions.
  /// Throws if the code is invalid/expired.
  Future<Map<String, dynamic>> peekInvitationCode(String code);

  /// Redeems an invitation code. The role comes from the code itself - the
  /// caller never chooses it. Resident-only params are ignored for other
  /// roles; [info] carries e.g. the technician's company name.
  /// Returns {status: joined|pending, estate_id, role}.
  Future<Map<String, dynamic>> redeemInvitationCode(
    String code, {
    String? building,
    String? stairwell,
    String? floor,
    String? apartment,
    String? info,
  });

  /// The caller's own pending join request, if any (waiting for office
  /// approval). Returns null if none.
  Future<Map<String, dynamic>?> getMyPendingJoinRequest();

  /// Office-only: pending join requests for an estate.
  Future<List<Map<String, dynamic>>> getPendingJoinRequests(String estateId);

  Future<void> approveJoinRequest(String requestId);
  Future<void> rejectJoinRequest(String requestId);

  /// The estate's Stripe contract end date, or null if there's no active
  /// subscription. Read via a narrow view (v_fixflow_estate_contract) so
  /// plain members never see Stripe customer/price IDs.
  Future<DateTime?> getContractValidUntil(String estateId);

  /// Estate health index 0-100 (prototype).
  Future<Map<String, dynamic>?> getHealthIndex(String estateId);
}

@LazySingleton(as: EstateDataSource)
class EstateDataSourceImpl implements EstateDataSource {
  EstateDataSourceImpl(this._client);
  final SupabaseClient _client;

  @override
  Future<List<Map<String, dynamic>>> getMyEstates() async {
    try {
      debugPrint('ℹ️ [EstateDataSource] fetching my estates');
      final response = await _client
          .from('fixflow_user_estates')
          .select('role, fixflow_estates(id, name, company_name, admin_name, admin_email, admin_phone, hide_resident_contacts)')
          .timeout(const Duration(seconds: 8));

      debugPrint('ℹ️ [EstateDataSource] fetched ${response.length} memberships');
      return (response as List).cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('❌ [EstateDataSource] getMyEstates failed: $e');
      rethrow;
    }
  }

  @override
  Future<String> createEstate(String name) async {
    try {
      debugPrint('ℹ️ [EstateDataSource] creating estate: $name');
      final id = await _client.rpc(
        'fixflow_create_estate',
        params: {'p_name': name},
      ).timeout(const Duration(seconds: 8));
      debugPrint('✅ [EstateDataSource] estate created: $id');
      return id as String;
    } catch (e) {
      debugPrint('❌ [EstateDataSource] createEstate failed: $e');
      rethrow;
    }
  }

  @override
  Future<String?> getActiveInvitationCode(String estateId, {String role = 'resident'}) async {
    try {
      debugPrint('ℹ️ [EstateDataSource] fetching active invitation code for $estateId role=$role');
      final result = await _client
          .from('fixflow_invitation_codes')
          .select('code')
          .eq('estate_id', estateId)
          .eq('role', role)
          .eq('is_active', true)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle()
          .timeout(const Duration(seconds: 5));
      return result?['code'] as String?;
    } catch (e) {
      debugPrint('⚠️ [EstateDataSource] getActiveInvitationCode failed: $e');
      return null;
    }
  }

  @override
  Future<String> createEstateInvitationCode(String estateId, {String role = 'resident'}) async {
    try {
      debugPrint('ℹ️ [EstateDataSource] creating invitation code for $estateId role=$role');
      final code = await _client.rpc(
        'fixflow_create_estate_invitation_code',
        params: {'p_estate_id': estateId, 'p_role': role},
      ).timeout(const Duration(seconds: 8));
      debugPrint('✅ [EstateDataSource] invitation code created');
      return code as String;
    } catch (e) {
      debugPrint('❌ [EstateDataSource] createEstateInvitationCode failed: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> peekInvitationCode(String code) async {
    try {
      debugPrint('ℹ️ [EstateDataSource] peeking invitation code: $code');
      final result = await _client.rpc(
        'fixflow_peek_invitation_code',
        params: {'p_code': code.toUpperCase()},
      ).timeout(const Duration(seconds: 8));
      debugPrint('✅ [EstateDataSource] code peek succeeded: $result');
      return Map<String, dynamic>.from(result as Map);
    } catch (e) {
      debugPrint('❌ [EstateDataSource] peekInvitationCode failed: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> redeemInvitationCode(
    String code, {
    String? building,
    String? stairwell,
    String? floor,
    String? apartment,
    String? info,
  }) async {
    try {
      debugPrint('ℹ️ [EstateDataSource] redeeming code: $code');
      final result = await _client.rpc(
        'fixflow_redeem_invitation_code',
        params: {
          'p_code': code.toUpperCase(),
          'p_building': building,
          'p_stairwell': stairwell,
          'p_floor': floor,
          'p_apartment': apartment,
          'p_info': info,
        },
      ).timeout(const Duration(seconds: 8));
      debugPrint('✅ [EstateDataSource] code redeemed: $result');
      return Map<String, dynamic>.from(result as Map);
    } catch (e) {
      debugPrint('❌ [EstateDataSource] redeemInvitationCode failed: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>?> getMyPendingJoinRequest() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return null;
      debugPrint('ℹ️ [EstateDataSource] fetching my pending join request');
      final result = await _client
          .from('fixflow_join_requests')
          .select('id, estate_id, role, info, fixflow_estates(name)')
          .eq('user_id', userId)
          .eq('status', 'pending')
          .maybeSingle()
          .timeout(const Duration(seconds: 8));
      return result == null ? null : Map<String, dynamic>.from(result);
    } catch (e) {
      debugPrint('⚠️ [EstateDataSource] getMyPendingJoinRequest failed: $e');
      return null;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getPendingJoinRequests(String estateId) async {
    try {
      debugPrint('ℹ️ [EstateDataSource] fetching pending join requests for $estateId');
      final result = await _client
          .from('fixflow_join_requests')
          .select('id, user_id, role, info, created_at')
          .eq('estate_id', estateId)
          .eq('status', 'pending')
          .order('created_at')
          .timeout(const Duration(seconds: 8));
      return (result as List).cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('❌ [EstateDataSource] getPendingJoinRequests failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> approveJoinRequest(String requestId) async {
    try {
      debugPrint('ℹ️ [EstateDataSource] approving join request $requestId');
      await _client.rpc(
        'fixflow_approve_join_request',
        params: {'p_request_id': requestId},
      ).timeout(const Duration(seconds: 8));
      debugPrint('✅ [EstateDataSource] join request approved');
    } catch (e) {
      debugPrint('❌ [EstateDataSource] approveJoinRequest failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> rejectJoinRequest(String requestId) async {
    try {
      debugPrint('ℹ️ [EstateDataSource] rejecting join request $requestId');
      await _client.rpc(
        'fixflow_reject_join_request',
        params: {'p_request_id': requestId},
      ).timeout(const Duration(seconds: 8));
      debugPrint('✅ [EstateDataSource] join request rejected');
    } catch (e) {
      debugPrint('❌ [EstateDataSource] rejectJoinRequest failed: $e');
      rethrow;
    }
  }

  @override
  Future<DateTime?> getContractValidUntil(String estateId) async {
    try {
      debugPrint('ℹ️ [EstateDataSource] fetching contract end date for $estateId');
      final result = await _client
          .from('v_fixflow_estate_contract')
          .select('current_period_end')
          .eq('estate_id', estateId)
          .maybeSingle();
      if (result == null) return null;
      final dateStr = result['current_period_end'] as String?;
      return dateStr != null ? DateTime.parse(dateStr) : null;
    } catch (e) {
      debugPrint('⚠️ [EstateDataSource] getContractValidUntil failed: $e');
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>?> getHealthIndex(String estateId) async {
    try {
      final result = await _client
          .rpc('fixflow_estate_health_index', params: {'p_estate_id': estateId})
          .timeout(const Duration(seconds: 8));
      if (result == null) return null;
      return Map<String, dynamic>.from(result as Map);
    } catch (e) {
      debugPrint('⚠️ [EstateDataSource] getHealthIndex failed (RPC may not exist yet): $e');
      return null;
    }
  }
}
