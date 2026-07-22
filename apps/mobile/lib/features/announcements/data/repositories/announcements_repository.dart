import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/announcement_model.dart';
import '../datasources/announcements_data_source.dart';

abstract class AnnouncementsRepository {
  /// Stream of currently loaded announcements (last refresh).
  Stream<List<Announcement>> watchAnnouncements();

  /// Re-fetches announcements for the given estate and emits them on the
  /// stream. Safe to call from `retry()`.
  Future<void> refresh({String? estateId});

  Future<Announcement> create({
    required String title,
    required String content,
    required String authorName,
    required String authorRole,
    String? targetLabel,
    String? estateId,
    DateTime? expiresAt,
    String scopeType = 'estate',
    String? scopeBuildingId,
    String? scopeStairwellId,
  });

  Future<void> softDelete(String id);
}

@LazySingleton(as: AnnouncementsRepository)
class AnnouncementsRepositoryImpl implements AnnouncementsRepository {
  AnnouncementsRepositoryImpl(this._dataSource);

  final AnnouncementsDataSource _dataSource;
  final BehaviorSubject<List<Announcement>> _subject =
      BehaviorSubject<List<Announcement>>.seeded(const []);

  String? _lastEstateId;

  @override
  Stream<List<Announcement>> watchAnnouncements() => _subject.stream;

  @override
  Future<void> refresh({String? estateId}) async {
    _lastEstateId = estateId;
    try {
      final items = await _dataSource.getAnnouncements(estateId: estateId);
      _subject.add(items);
    } catch (e) {
      debugPrint('❌ [AnnouncementsRepository] refresh failed: $e');
      rethrow;
    }
  }

  @override
  Future<Announcement> create({
    required String title,
    required String content,
    required String authorName,
    required String authorRole,
    String? targetLabel,
    String? estateId,
    DateTime? expiresAt,
    String scopeType = 'estate',
    String? scopeBuildingId,
    String? scopeStairwellId,
  }) async {
    final created = await _dataSource.createAnnouncement(
      title: title,
      content: content,
      authorName: authorName,
      authorRole: authorRole,
      targetLabel: targetLabel,
      estateId: estateId,
      expiresAt: expiresAt,
      scopeType: scopeType,
      scopeBuildingId: scopeBuildingId,
      scopeStairwellId: scopeStairwellId,
    );
    // Optimistic: prepend locally so the UI reacts immediately.
    _subject.add([created, ..._subject.value]);
    // Reconcile with server state in the background.
    unawaited(refresh(estateId: _lastEstateId));
    return created;
  }

  @override
  Future<void> softDelete(String id) async {
    await _dataSource.softDeleteAnnouncement(id);
    _subject.add(_subject.value.where((a) => a.id != id).toList());
  }
}
