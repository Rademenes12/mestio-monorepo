import 'package:injectable/injectable.dart';
import '../datasources/residents_data_source.dart';
import '../../models/resident_model.dart';
import '../../models/staff_member_model.dart';

abstract class ResidentsRepository {
  Future<List<ResidentModel>> getResidents(String estateId);
  Future<List<StaffMemberModel>> getEstateStaff(String estateId);
  Future<void> saveFcmToken(String userId, String token);
}

@LazySingleton(as: ResidentsRepository)
class ResidentsRepositoryImpl implements ResidentsRepository {
  ResidentsRepositoryImpl(this._dataSource);

  final ResidentsDataSource _dataSource;

  @override
  Future<List<ResidentModel>> getResidents(String estateId) =>
      _dataSource.getResidents(estateId);

  @override
  Future<List<StaffMemberModel>> getEstateStaff(String estateId) =>
      _dataSource.getEstateStaff(estateId);

  @override
  Future<void> saveFcmToken(String userId, String token) =>
      _dataSource.saveFcmToken(userId, token);
}
