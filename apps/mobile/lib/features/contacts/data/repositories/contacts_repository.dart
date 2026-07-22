import 'package:injectable/injectable.dart';
import '../../models/contact_model.dart';
import '../datasources/contacts_data_source.dart';

abstract class ContactsRepository {
  /// Returns active contacts for the given estate. When [estateId] is null,
  /// only legacy global contacts (estate_id IS NULL) are returned.
  Future<List<EmergencyContact>> getContacts({String? estateId});
  Future<EmergencyContact> createContact(EmergencyContact contact);
  Future<void> deleteContact(String id);
}

@LazySingleton(as: ContactsRepository)
class ContactsRepositoryImpl implements ContactsRepository {
  ContactsRepositoryImpl(this._dataSource);

  final ContactsDataSource _dataSource;

  @override
  Future<List<EmergencyContact>> getContacts({String? estateId}) =>
      _dataSource.getContacts(estateId: estateId);

  @override
  Future<EmergencyContact> createContact(EmergencyContact contact) =>
      _dataSource.createContact(contact);

  @override
  Future<void> deleteContact(String id) => _dataSource.deleteContact(id);
}
