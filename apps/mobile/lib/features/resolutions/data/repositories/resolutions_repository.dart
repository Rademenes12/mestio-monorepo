import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/resolution_model.dart';
import '../datasources/resolutions_data_source.dart';

abstract class ResolutionsRepository {
  /// Stream of currently loaded resolutions (last refresh).
  Stream<List<Resolution>> watchResolutions();

  /// Re-fetches resolutions for the given estate. Safe to call from retry().
  Future<void> refresh({required String estateId});

  Future<void> castVote({required String resolutionId, required String choice});

  Future<void> create({
    required String estateId,
    required String title,
    String? description,
    DateTime? deadline,
  });

  Future<void> close({required String id, required String status});
}

@LazySingleton(as: ResolutionsRepository)
class ResolutionsRepositoryImpl implements ResolutionsRepository {
  ResolutionsRepositoryImpl(this._dataSource);

  final ResolutionsDataSource _dataSource;
  final BehaviorSubject<List<Resolution>> _subject =
      BehaviorSubject<List<Resolution>>.seeded(const []);

  String? _lastEstateId;

  @override
  Stream<List<Resolution>> watchResolutions() => _subject.stream;

  @override
  Future<void> refresh({required String estateId}) async {
    _lastEstateId = estateId;
    try {
      final items = await _dataSource.getResolutions(estateId: estateId);
      _subject.add(items);
    } catch (e) {
      debugPrint('❌ [ResolutionsRepository] refresh failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> castVote({
    required String resolutionId,
    required String choice,
  }) async {
    await _dataSource.castVote(resolutionId: resolutionId, choice: choice);
    // Reload so the tally (now unlocked for the voter) comes from the server.
    await _refreshLast();
  }

  @override
  Future<void> create({
    required String estateId,
    required String title,
    String? description,
    DateTime? deadline,
  }) async {
    await _dataSource.createResolution(
      estateId: estateId,
      title: title,
      description: description,
      deadline: deadline,
    );
    await refresh(estateId: estateId);
  }

  @override
  Future<void> close({required String id, required String status}) async {
    await _dataSource.closeResolution(id: id, status: status);
    await _refreshLast();
  }

  Future<void> _refreshLast() async {
    final estateId = _lastEstateId;
    if (estateId != null) {
      await refresh(estateId: estateId);
    }
  }
}
