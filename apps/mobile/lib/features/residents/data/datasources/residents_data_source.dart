import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/resident_model.dart';
import '../../models/staff_member_model.dart';

abstract class ResidentsDataSource {
  Future<List<ResidentModel>> getResidents(String estateId);
  Future<List<StaffMemberModel>> getEstateStaff(String estateId);
  Future<void> saveFcmToken(String userId, String token);
}

@LazySingleton(as: ResidentsDataSource)
class ResidentsDataSourceImpl implements ResidentsDataSource {
  ResidentsDataSourceImpl(this._client);
  final SupabaseClient _client;

  @override
  Future<List<ResidentModel>> getResidents(String estateId) async {
    try {
      // Use view that joins resident_profiles with user_estates
      // to filter by estate. RLS on underlying tables enforces access control.
      debugPrint('️ [ResidentsDataSource] fetching residents for estate=$estateId');

      final response = await _client
          .from('v_fixflow_residents_by_estate')
          .select()
          .eq('estate_id', estateId)
          .eq('role', 'Mieszkaniec')
          .order('name')
          .limit(1000);

      debugPrint(
        'ℹ️ [ResidentsDataSource] fetched ${response.length} resident profiles',
      );

      return (response as List).map((json) {
        final map = Map<String, dynamic>.from(json as Map);
        // Split full name into first/last name parts (UI displays them
        // separately, e.g. for avatar initials). Falls back gracefully when
        // the user entered only one word.
        final fullName = ((map['name'] as String?) ?? '').trim();
        final firstSpace = fullName.indexOf(' ');
        final firstName = firstSpace < 0
            ? fullName
            : fullName.substring(0, firstSpace);
        final lastName = firstSpace < 0
            ? ''
            : fullName.substring(firstSpace + 1).trim();

        // Apartment is stored as "Mieszkanie 14"; strip the prefix so the
        // UI doesn't render "Mieszkanie: Mieszkanie 14".
        final apartmentRaw = (map['apartment'] as String?) ?? '';
        final apartmentNumber = apartmentRaw.startsWith('Mieszkanie ')
            ? apartmentRaw.substring('Mieszkanie '.length)
            : apartmentRaw.isEmpty
                ? null
                : apartmentRaw;

        final id = (map['id'] as String?) ?? '';
        return ResidentModel(
          id: id,
          userId: id,
          firstName: firstName.isEmpty ? '?' : firstName,
          lastName: lastName,
          email: (map['email'] as String?) ?? '',
          phone: (map['phone'] as String?)?.trim().isNotEmpty == true
              ? (map['phone'] as String).trim()
              : null,
          apartmentNumber: apartmentNumber,
          building: (map['building'] as String?),
          footbridge: (map['footbridge'] as String?),
          floor: (map['floor'] as String?),
        );
      }).toList();
    } catch (e) {
      debugPrint('❌ [ResidentsDataSource] getResidents failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> saveFcmToken(String userId, String token) async {
    try {
      debugPrint('ℹ️ [ResidentsDataSource] saving FCM token for user: $userId');

      // Save to fixflow_resident_profiles (main profile table, has RLS)
      await _client
          .from('fixflow_resident_profiles')
          .update({'fcm_token': token})
          .eq('id', userId);

      debugPrint('✅ [ResidentsDataSource] FCM token saved');
    } catch (e) {
      debugPrint('❌ [ResidentsDataSource] saveFcmToken failed: $e');
      // Don't rethrow - FCM token failure shouldn't break the app
    }
  }

  @override
  Future<List<StaffMemberModel>> getEstateStaff(String estateId) async {
    try {
      debugPrint('ℹ️ [ResidentsDataSource] fetching staff for estate=$estateId');

      final response = await _client
          .from('v_fixflow_residents_by_estate')
          .select()
          .eq('estate_id', estateId)
          .neq('role', 'Mieszkaniec')
          .order('name');

      debugPrint(
        '✅ [ResidentsDataSource] fetched ${response.length} staff profiles',
      );

      return (response as List).map((json) {
        final map = Map<String, dynamic>.from(json as Map);
        return StaffMemberModel(
          id: (map['id'] as String?) ?? '',
          name: (map['name'] as String?) ?? '',
          email: (map['email'] as String?) ?? '',
          role: (map['role'] as String?) ?? 'Serwisant',
        );
      }).toList();
    } catch (e) {
      debugPrint('❌ [ResidentsDataSource] getEstateStaff failed: $e');
      rethrow;
    }
  }
}