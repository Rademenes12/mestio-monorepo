import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mestio/features/contacts/data/repositories/contacts_repository.dart';
import 'package:mestio/features/contacts/models/contact_model.dart';
import 'package:mestio/features/contacts/presentation/cubit/contacts_cubit.dart';
import 'package:mestio/features/estate/data/repositories/estate_repository.dart';
import 'package:mestio/features/estate/models/estate_model.dart';

class MockContactsRepository extends Mock implements ContactsRepository {}

class MockEstateRepository extends Mock implements EstateRepository {}

void main() {
  late MockContactsRepository mockRepository;
  late MockEstateRepository mockEstateRepo;

  setUpAll(() {
    registerFallbackValue(const EmergencyContact(
      id: '',
      name: '',
      role: '',
      phone: '',
      category: '',
      displayOrder: 0,
    ));
  });

  setUp(() {
    mockRepository = MockContactsRepository();
    mockEstateRepo = MockEstateRepository();
    // The cubit subscribes to the active estate; emit a single estate so it
    // triggers one load. Tests stub getContacts() behaviour as needed.
    when(() => mockEstateRepo.watchActiveEstate()).thenAnswer(
      (_) => Stream.value(const Estate(id: 'estate-1', name: 'Test', role: 'admin')),
    );
  });

  ContactsCubit buildCubit() => ContactsCubit(mockRepository, mockEstateRepo);

  group('ContactsCubit', () {
    final testContacts = [
      const EmergencyContact(
        id: '1',
        name: 'Zarządca',
        role: 'Administracja',
        phone: '+48 600 123 456',
        email: 'zarzadca@example.com',
        category: 'administration',
        displayOrder: 0,
      ),
      const EmergencyContact(
        id: '2',
        name: 'Pogotowie',
        role: 'Służby ratunkowe',
        phone: '999',
        category: 'emergency',
        displayOrder: 1,
      ),
    ];

    blocTest<ContactsCubit, ContactsState>(
      'loads empty contacts list successfully',
      build: () {
        when(() => mockRepository.getContacts(estateId: any(named: 'estateId')))
            .thenAnswer((_) async => []);
        return buildCubit();
      },
      wait: const Duration(milliseconds: 100),
      verify: (cubit) {
        final state = cubit.state;
        expect(state, isA<ContactsLoaded>());
        final loaded = state as ContactsLoaded;
        expect(loaded.contacts, isEmpty);
      },
    );

    blocTest<ContactsCubit, ContactsState>(
      'loads contacts successfully',
      build: () {
        when(() => mockRepository.getContacts(estateId: any(named: 'estateId')))
            .thenAnswer((_) async => testContacts);
        return buildCubit();
      },
      wait: const Duration(milliseconds: 100),
      verify: (cubit) {
        final state = cubit.state;
        expect(state, isA<ContactsLoaded>());
        final loaded = state as ContactsLoaded;
        expect(loaded.contacts, testContacts);
      },
    );

    blocTest<ContactsCubit, ContactsState>(
      'uses fallback data when Supabase unavailable (PGRST002)',
      build: () {
        when(() => mockRepository.getContacts(estateId: any(named: 'estateId')))
            .thenThrow(Exception('PGRST002: Service Unavailable'));
        return buildCubit();
      },
      wait: const Duration(milliseconds: 100),
      verify: (cubit) {
        final state = cubit.state;
        expect(state, isA<ContactsLoaded>());
        final loaded = state as ContactsLoaded;
        expect(loaded.contacts.length, 5);
        expect(loaded.contacts.first.name, 'Administrator');
      },
    );

    blocTest<ContactsCubit, ContactsState>(
      'addContact in offline mode adds to local list',
      build: () {
        when(() => mockRepository.getContacts(estateId: any(named: 'estateId')))
            .thenThrow(Exception('PGRST002: Service Unavailable'));
        return buildCubit();
      },
      wait: const Duration(milliseconds: 200),
      act: (cubit) async {
        await Future.delayed(const Duration(milliseconds: 100));
        await cubit.addContact(
          name: 'Test Contact',
          role: 'Test Role',
          phone: '+48 600 000 000',
          category: 'administration',
        );
      },
      verify: (cubit) {
        final state = cubit.state;
        expect(state, isA<ContactsLoaded>());
        final loaded = state as ContactsLoaded;
        expect(loaded.contacts.length, 6);
        expect(loaded.contacts.last.name, 'Test Contact');
        expect(loaded.contacts.last.phone, '+48 600 000 000');
      },
    );

    blocTest<ContactsCubit, ContactsState>(
      'deleteContact in offline mode removes from local list',
      build: () {
        when(() => mockRepository.getContacts(estateId: any(named: 'estateId')))
            .thenThrow(Exception('PGRST002: Service Unavailable'));
        return buildCubit();
      },
      wait: const Duration(milliseconds: 200),
      act: (cubit) async {
        await Future.delayed(const Duration(milliseconds: 100));
        final state = cubit.state as ContactsLoaded;
        final contactToDelete = state.contacts.first;
        await cubit.deleteContact(contactToDelete.id);
      },
      verify: (cubit) {
        final state = cubit.state;
        expect(state, isA<ContactsLoaded>());
        final loaded = state as ContactsLoaded;
        expect(loaded.contacts.length, 4);
      },
    );

    blocTest<ContactsCubit, ContactsState>(
      'refresh reloads data',
      build: () {
        when(() => mockRepository.getContacts(estateId: any(named: 'estateId')))
            .thenAnswer((_) async => testContacts);
        return buildCubit();
      },
      wait: const Duration(milliseconds: 200),
      act: (cubit) async {
        await Future.delayed(const Duration(milliseconds: 100));
        await cubit.refresh();
      },
      verify: (cubit) {
        // Once for the initial estate-triggered load, once for refresh.
        verify(() => mockRepository.getContacts(estateId: any(named: 'estateId')))
            .called(2);
        final state = cubit.state;
        expect(state, isA<ContactsLoaded>());
        final loaded = state as ContactsLoaded;
        expect(loaded.contacts, testContacts);
      },
    );

    blocTest<ContactsCubit, ContactsState>(
      'addContact passes active estate id to createContact',
      build: () {
        when(() => mockRepository.getContacts(estateId: any(named: 'estateId')))
            .thenAnswer((_) async => testContacts);
        when(() => mockRepository.createContact(any()))
            .thenAnswer((inv) async => inv.positionalArguments.first as EmergencyContact);
        return buildCubit();
      },
      wait: const Duration(milliseconds: 200),
      act: (cubit) async {
        await Future.delayed(const Duration(milliseconds: 100));
        await cubit.addContact(
          name: 'New',
          role: 'Test',
          phone: '+48 600 111 222',
          category: 'administration',
        );
      },
      verify: (cubit) {
        final captured = verify(() => mockRepository.createContact(captureAny()))
            .captured
            .single as EmergencyContact;
        expect(captured.estateId, 'estate-1');
      },
    );

    blocTest<ContactsCubit, ContactsState>(
      'addContact falls back to local when createContact fails with PGRST002',
      build: () {
        when(() => mockRepository.getContacts(estateId: any(named: 'estateId')))
            .thenAnswer((_) async => testContacts);
        when(() => mockRepository.createContact(any()))
            .thenThrow(Exception('PGRST002: Service Unavailable'));
        return buildCubit();
      },
      wait: const Duration(milliseconds: 200),
      act: (cubit) async {
        await Future.delayed(const Duration(milliseconds: 100));
        await cubit.addContact(
          name: 'Offline Fallback',
          role: 'Test',
          phone: '+48 600 111 222',
          category: 'administration',
        );
      },
      verify: (cubit) {
        final state = cubit.state;
        expect(state, isA<ContactsLoaded>());
        final loaded = state as ContactsLoaded;
        expect(loaded.contacts.length, 3);
        expect(loaded.contacts.last.name, 'Offline Fallback');
      },
    );
  });
}
