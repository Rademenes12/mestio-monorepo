import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/session/data/repositories/session_repository.dart';
import '../../../../app/session/models/session_status_model.dart';
import '../../../../core/reliability/report_outbox.dart';
import '../../../../shared/error_messages.dart';
import '../../../residents/data/repositories/residents_repository.dart';
import '../../../residents/models/staff_member_model.dart';
import '../../data/repositories/reports_repository.dart';
import '../../models/report_model.dart';
import '../../models/report_status.dart';
import '../../models/report_priority.dart';
import '../../../profiles/models/resident_profile_model.dart';
import '../../../estate/data/repositories/estate_repository.dart';
import '../../../estate/models/estate_model.dart';
import '../../services/fcm_service.dart';

part 'reports_cubit.freezed.dart';

@freezed
sealed class ReportsState with _$ReportsState {
  const factory ReportsState.initial() = ReportsInitial;
  const factory ReportsState.loading() = ReportsLoading;
  const factory ReportsState.loaded({
    required List<ReportModel> reports,
    ResidentProfileModel? profile,
    String? userId,
    String? estateId,
    @Default([]) List<StaffMemberModel> staff,
    @Default(false) bool isSubmitting,
    String? errorKey,
  }) = ReportsLoaded;
  const factory ReportsState.error({required String errorKey}) = ReportsError;
}

@injectable
class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit(
    this._reportsRepository,
    this._sessionRepository,
    this._estateRepository,
    this._fcmService,
    this._reportOutbox,
    this._residentsRepository,
  ) : super(const ReportsState.initial()) {
    _sessionSubscription = _sessionRepository.sessionStream.listen((status) {
      switch (status) {
        case SessionStatusLoading():
          emit(const ReportsState.initial());
        case SessionStatusUnauthenticated():
          _reportsSubscription?.cancel();
          _estateSubscription?.cancel();
          _currentUserId = null;
          _currentUserEmail = null;
          emit(const ReportsState.initial());
        case SessionStatusAuthenticated(:final session):
          final userId = session.userId;
          final email = session.email;
          _startEstateSubscription(userId, email ?? '');
      }
    });
  }

  final ReportsRepository _reportsRepository;
  final SessionRepository _sessionRepository;
  final EstateRepository _estateRepository;
  final FcmService _fcmService;
  final ReportOutbox _reportOutbox;
  final ResidentsRepository _residentsRepository;

  StreamSubscription<Object?>? _sessionSubscription;
  StreamSubscription<List<ReportModel>>? _reportsSubscription;
  StreamSubscription<Estate?>? _estateSubscription;

  String? _currentUserId;
  String? _currentUserEmail;
  String? _currentEstateId;

  /// Returns the current active estate ID.
  String? get currentEstateId => _currentEstateId;

  /// Returns the current user email (from session).
  String? get currentUserEmail => _currentUserEmail;

  @override
  Future<void> close() {
    _sessionSubscription?.cancel();
    _reportsSubscription?.cancel();
    _estateSubscription?.cancel();
    return super.close();
  }

  void _startEstateSubscription(String userId, String email) {
    _currentUserId = userId;
    _currentUserEmail = email;

    _estateSubscription?.cancel();
    var isFirstEmission = true;
    _estateSubscription = _estateRepository.watchActiveEstate().listen((
      estate,
    ) {
      final newEstateId = estate?.id;
      // Always load on first emission, then reload if estate changes.
      if (isFirstEmission || newEstateId != _currentEstateId) {
        final wasFirst = isFirstEmission;
        isFirstEmission = false;
        _currentEstateId = newEstateId;
        _reportsRepository.setActiveEstateId(newEstateId);

        final currentState = state;
        final isVerified =
            currentState is ReportsLoaded &&
            currentState.profile?.isVerified == true;
        if (wasFirst || isVerified) {
          _loadDataForUser(userId, email);
        }
      }
    });
  }

  void _loadDataForUser(String userId, String email) async {
    _reportsSubscription?.cancel();
    emit(const ReportsState.loading());

    try {
      final profile = await _reportsRepository.getResidentProfile(userId);

      final role = profile?.role ?? _detectRoleFromEmail(email);
      await _fcmService.updateUserSubscriptions(
        role: role,
        email: email,
        specialty: role == 'Serwisant' ? (profile?.role ?? 'Serwisant') : null,
      );

      // Persist FCM device token so server-side push targeting works.
      unawaited(_fcmService.initialize());
      final token = _fcmService.fcmToken;
      if (token != null && token.isNotEmpty) {
        unawaited(_residentsRepository.saveFcmToken(userId, token));
      }

      List<StaffMemberModel> staff = [];
      if (_currentEstateId != null) {
        try {
          staff = await _residentsRepository.getEstateStaff(_currentEstateId!);
        } catch (e) {
          debugPrint('⚠️ [ReportsCubit] failed to load staff list: $e');
        }
      }

      _reportsSubscription = _reportsRepository.watchReports().listen(
        (reports) {
          emit(
            ReportsState.loaded(
              reports: reports,
              profile: profile,
              userId: userId,
              estateId: _currentEstateId,
              staff: staff,
            ),
          );
        },
        onError: (err) {
          debugPrint('❌ [ReportsCubit] reports stream error: $err');
          emit(ReportsState.error(errorKey: mapErrorToKey(err)));
        },
      );

      await _reportsRepository.refreshReports();
    } catch (e) {
      debugPrint('❌ [ReportsCubit] _loadDataForUser failed: $e');
      // Don't emit error state for non-critical failures
      // Keep the loading state or emit empty loaded state
      final profile = await _reportsRepository
          .getResidentProfile(userId)
          .catchError((_) => null);
      emit(
        ReportsState.loaded(
          reports: const [],
          profile: profile,
          userId: userId,
          estateId: _currentEstateId,
          staff: const [],
          errorKey: mapErrorToKey(e),
        ),
      );
    }
  }

  Future<void> retry() async {
    if (_currentUserId == null) return;
    emit(const ReportsState.loading());
    _loadDataForUser(_currentUserId!, _currentUserEmail ?? '');
  }

  Future<void> addReport({
    required String title,
    required String description,
    required String category,
    String? photoPath,
    String? pdfPath,
    double? latitude,
    double? longitude,
    String? additionalInfo,
    // Board/security can flag a report as urgent at creation time; maps to
    // ReportPriority.high (24h SLA) rather than the per-category logic the
    // redesign prototype uses, to keep the composer a single toggle.
    bool isPriority = false,
    // Local file paths of gallery photos beyond the single cover [photoPath].
    // Uploaded to Storage and recorded in fixflow_report_images; a failed
    // photo is skipped (logged) rather than failing the whole report.
    List<String>? extraPhotoPaths,
  }) async {
    final currentState = state;
    if (currentState is! ReportsLoaded) return;

    emit(currentState.copyWith(isSubmitting: true, errorKey: null));

    try {
      final profile = currentState.profile ?? ResidentProfileModel.empty();
      final estateId = _currentEstateId;
      if (estateId == null) {
        debugPrint('❌ [ReportsCubit] addReport failed: no active estate');
        emit(
          currentState.copyWith(
            isSubmitting: false,
            errorKey: 'error_no_estate',
          ),
        );
        return;
      }

      final reportId = const Uuid().v4();

      // Upload photo to Storage if provided (local file path)
      String? finalPhotoPath = photoPath;
      if (photoPath != null && !photoPath.startsWith('http')) {
        try {
          final storagePath = await _reportsRepository.uploadReportPhoto(
            localPath: photoPath,
            estateId: estateId,
            reportId: reportId,
          );
          // Store the storage path (not signed URL) - we'll generate signed URLs on read
          finalPhotoPath = storagePath;
          debugPrint(
            '✅ [ReportsCubit] photo uploaded to Storage: $storagePath',
          );
        } catch (e) {
          debugPrint(
            '⚠️ [ReportsCubit] photo upload failed, continuing without photo: $e',
          );
          finalPhotoPath = null;
        }
      }

      // Upload the PDF to Storage too — a local file path is useless once
      // the report is viewed from a different device (manager/technician).
      String? attachmentsJson;
      if (pdfPath != null) {
        final pdfName = pdfPath.split('/').last;
        String? pdfStoragePath = pdfPath;
        if (!pdfPath.startsWith('http')) {
          try {
            pdfStoragePath = await _reportsRepository.uploadReportPdf(
              localPath: pdfPath,
              estateId: estateId,
              reportId: reportId,
            );
            debugPrint(
              '✅ [ReportsCubit] PDF uploaded to Storage: $pdfStoragePath',
            );
          } catch (e) {
            debugPrint(
              '⚠️ [ReportsCubit] PDF upload failed, continuing without it: $e',
            );
            pdfStoragePath = null;
          }
        }
        if (pdfStoragePath != null) {
          attachmentsJson = jsonEncode([
            {'name': pdfName, 'type': 'application/pdf', 'url': pdfStoragePath},
          ]);
        }
      }

      final report = ReportModel(
        id: reportId,
        title: title,
        description: description,
        category: category,
        reporterName: profile.name,
        reporterEmail: profile.email.isNotEmpty
            ? profile.email
            : (_currentUserEmail ?? ''),
        reporterBuilding: profile.building,
        reporterFootbridge: profile.footbridge,
        reporterFloor: profile.floor,
        reporterApartment: profile.apartment,
        status: 'Nowe', // Legacy field
        statusEnum: ReportStatus.newReport.dbValue,
        timestamp: DateTime.now().millisecondsSinceEpoch,
        estateId: estateId,
        photoPath: finalPhotoPath,
        attachmentsJson: attachmentsJson,
        latitude: latitude,
        longitude: longitude,
        additionalInfo: additionalInfo?.isNotEmpty == true
            ? additionalInfo
            : null,
        priority: isPriority
            ? ReportPriority.high.dbValue
            : ReportPriority.normal.dbValue,
        slaDeadline: isPriority
            ? DateTime.now()
                  .add(Duration(hours: ReportPriority.high.slaHours))
                  .toIso8601String()
            : null,
      );

      // If online, send immediately; if offline, enqueue for later
      if (_reportOutbox.isOnline) {
        await _reportsRepository.addReport(report);
        // Gallery photos need the report row to exist first (FK on
        // fixflow_report_images) — skip entirely when queued offline rather
        // than risk an orphaned upload with no way to attach it later.
        for (final path in extraPhotoPaths ?? const <String>[]) {
          try {
            final storagePath = await _reportsRepository.uploadReportPhoto(
              localPath: path,
              estateId: estateId,
              reportId: reportId,
            );
            await _reportsRepository.addReportImage(
              reportId: reportId,
              storagePath: storagePath,
            );
          } catch (e) {
            debugPrint(
              '⚠️ [ReportsCubit] gallery photo upload failed, skipping: $e',
            );
          }
        }
      } else {
        await _reportOutbox.enqueue(report);
        debugPrint(
          '📤 [ReportsCubit] report queued offline (id: ${report.id})',
        );
      }

      _fcmService.triggerAssignmentNotification(
        reportTitle: title,
        assignedRole: category,
        reportId: report.id,
      );

      final updatedState = state;
      if (updatedState is ReportsLoaded) {
        emit(updatedState.copyWith(isSubmitting: false));
      }
    } catch (e) {
      debugPrint('❌ [ReportsCubit] addReport failed: $e');
      final updatedState = state;
      if (updatedState is ReportsLoaded) {
        emit(
          updatedState.copyWith(
            isSubmitting: false,
            errorKey: mapErrorToKey(e),
          ),
        );
      }
    }
  }

  Future<void> updateReport(ReportModel report) async {
    final currentState = state;
    if (currentState is! ReportsLoaded) return;

    emit(currentState.copyWith(isSubmitting: true, errorKey: null));

    try {
      await _reportsRepository.updateReport(report);

      final original = currentState.reports.firstWhere(
        (r) => r.id == report.id,
      );
      if (original.status != report.status) {
        _fcmService.triggerStatusChangeNotification(
          reportTitle: report.title,
          reporterEmail: report.reporterEmail,
          reportId: report.id,
          newStatus: report.status,
        );
      }

      final updatedState = state;
      if (updatedState is ReportsLoaded) {
        emit(updatedState.copyWith(isSubmitting: false));
      }
    } catch (e) {
      debugPrint('❌ [ReportsCubit] updateReport failed: $e');
      final updatedState = state;
      if (updatedState is ReportsLoaded) {
        emit(
          updatedState.copyWith(
            isSubmitting: false,
            errorKey: mapErrorToKey(e),
          ),
        );
      }
    }
  }

  Future<void> saveProfile(ResidentProfileModel profile) async {
    if (_currentUserId == null) return;
    final currentState = state;

    if (currentState is ReportsLoaded) {
      emit(currentState.copyWith(isSubmitting: true, errorKey: null));
    } else {
      emit(const ReportsState.loading());
    }

    try {
      // Role now always comes from the invitation code (fixflow_redeem_invitation_code
      // / fixflow_approve_join_request), never guessed or self-selected here.
      final finalProfile = profile.copyWith(
        isVerified: true,
        email: profile.email.isNotEmpty
            ? profile.email
            : (_currentUserEmail ?? ''),
      );

      await _reportsRepository.saveResidentProfile(
        _currentUserId!,
        finalProfile,
      );

      await _fcmService.updateUserSubscriptions(
        role: finalProfile.role,
        email: finalProfile.email.isNotEmpty
            ? finalProfile.email
            : (_currentUserEmail ?? ''),
      );

      // Emit the saved profile immediately so the lock screen is dismissed
      // without waiting for a round-trip read that may race with the remote
      // write. The existing reports stream will refresh in the background.
      final updatedState = state;
      if (updatedState is ReportsLoaded) {
        emit(
          updatedState.copyWith(
            isSubmitting: false,
            errorKey: null,
            profile: finalProfile,
          ),
        );
      } else {
        _loadDataForUser(_currentUserId!, _currentUserEmail ?? '');
      }

      // Refresh reports in the background so the stream catches up.
      unawaited(_reportsRepository.refreshReports());
    } catch (e) {
      debugPrint('❌ [ReportsCubit] saveProfile failed: $e');
      final currentState = state;
      if (currentState is ReportsLoaded) {
        emit(
          currentState.copyWith(
            isSubmitting: false,
            errorKey: mapErrorToKey(e),
          ),
        );
      } else {
        emit(ReportsState.error(errorKey: mapErrorToKey(e)));
      }
    }
  }

  Future<void> syncOffline() async {
    final currentState = state;
    if (currentState is! ReportsLoaded) return;

    emit(currentState.copyWith(isSubmitting: true, errorKey: null));
    try {
      await _reportsRepository.syncOfflineReports();
      final updatedState = state;
      if (updatedState is ReportsLoaded) {
        emit(updatedState.copyWith(isSubmitting: false));
      }
    } catch (e) {
      debugPrint('❌ [ReportsCubit] syncOffline failed: $e');
      final updatedState = state;
      if (updatedState is ReportsLoaded) {
        emit(
          updatedState.copyWith(
            isSubmitting: false,
            errorKey: mapErrorToKey(e),
          ),
        );
      }
    }
  }

  Future<void> updateStatus(
    String reportId,
    String newStatus, {
    String? techName,
  }) async {
    final currentState = state;
    if (currentState is! ReportsLoaded) return;

    emit(currentState.copyWith(isSubmitting: true, errorKey: null));

    try {
      final original = currentState.reports.firstWhere((r) => r.id == reportId);
      // Keep both legacy text status and the canonical db enum in sync so that
      // resolvedStatus and UI filters react immediately.
      final statusEnum = ReportStatus.fromString(newStatus).dbValue;
      var updated = original.copyWith(
        status: newStatus,
        statusEnum: statusEnum,
      );

      // Auto-assign to current technician if unassigned and they are updating status
      if (original.assignedToUserId == null && _currentUserId != null) {
        final name = currentState.profile?.name ?? 'Serwisant';
        final role = currentState.profile?.role ?? 'Serwisant';
        updated = updated.copyWith(
          assignedToUserId: _currentUserId,
          assignedToName: name,
          assignedToRole: role,
          assignedTo: role,
        );
        debugPrint(
          'ℹ️ [ReportsCubit] Auto-assigning report $reportId to $_currentUserId during status update',
        );
      }

      // Audit trail entry
      final newTrail = List<Map<String, dynamic>>.from(
        original.auditTrail ?? [],
      );
      newTrail.add({
        'action': 'Zmień status na: $newStatus',
        'user_id': _currentUserId,
        'user_name': currentState.profile?.name ?? 'Użytkownik',
        'timestamp': DateTime.now().toIso8601String(),
      });
      updated = updated.copyWith(auditTrail: newTrail);

      await _reportsRepository.updateReport(updated);

      _fcmService.triggerStatusChangeNotification(
        reportTitle: original.title,
        reporterEmail: original.reporterEmail,
        reportId: reportId,
        newStatus: newStatus,
      );

      final updatedState = state;
      if (updatedState is ReportsLoaded) {
        emit(updatedState.copyWith(isSubmitting: false));
      }
    } catch (e) {
      debugPrint('❌ [ReportsCubit] updateStatus failed: $e');
      final updatedState = state;
      if (updatedState is ReportsLoaded) {
        emit(
          updatedState.copyWith(
            isSubmitting: false,
            errorKey: mapErrorToKey(e),
          ),
        );
      }
    }
  }

  /// Assigns the report to the currently signed-in user (e.g. a technician
  /// taking ownership of an unassigned service report).
  Future<void> assignReportToCurrentUser(String reportId) async {
    final currentState = state;
    if (currentState is! ReportsLoaded) return;
    if (_currentUserId == null) return;

    emit(currentState.copyWith(isSubmitting: true, errorKey: null));

    try {
      final original = currentState.reports.firstWhere((r) => r.id == reportId);
      final name = currentState.profile?.name ?? 'Serwisant';
      final role = currentState.profile?.role ?? 'Serwisant';

      final updated = original.copyWith(
        assignedToUserId: _currentUserId,
        assignedToName: name,
        assignedToRole: role,
        assignedTo: role,
      );
      await _reportsRepository.updateReport(updated);

      final updatedState = state;
      if (updatedState is ReportsLoaded) {
        emit(updatedState.copyWith(isSubmitting: false));
      }
      debugPrint(
        '✅ [ReportsCubit] assigned report $reportId to $_currentUserId',
      );
    } catch (e) {
      debugPrint('❌ [ReportsCubit] assignReportToCurrentUser failed: $e');
      final updatedState = state;
      if (updatedState is ReportsLoaded) {
        emit(
          updatedState.copyWith(
            isSubmitting: false,
            errorKey: mapErrorToKey(e),
          ),
        );
      }
    }
  }

  /// Assigns the report to a specific user (manager assignment).
  Future<void> assignReportToUser(
    String reportId,
    String? userId,
    String? name,
    String? role,
  ) async {
    final currentState = state;
    if (currentState is! ReportsLoaded) return;

    emit(currentState.copyWith(isSubmitting: true, errorKey: null));

    try {
      final original = currentState.reports.firstWhere((r) => r.id == reportId);
      final newTrail = List<Map<String, dynamic>>.from(
        original.auditTrail ?? [],
      );
      newTrail.add({
        'action': name != null
            ? 'Przypisano do: $name ($role)'
            : 'Usunięto przypisanie',
        'user_id': _currentUserId,
        'user_name': currentState.profile?.name ?? 'Użytkownik',
        'timestamp': DateTime.now().toIso8601String(),
      });
      final updated = original.copyWith(
        assignedToUserId: userId,
        assignedToName: name,
        assignedToRole: role,
        assignedTo: role ?? '',
        auditTrail: newTrail,
      );
      await _reportsRepository.updateReport(updated);

      if (role != null && role.isNotEmpty) {
        _fcmService.triggerAssignmentNotification(
          reportTitle: original.title,
          assignedRole: role,
          reportId: reportId,
        );
      }

      final updatedState = state;
      if (updatedState is ReportsLoaded) {
        emit(updatedState.copyWith(isSubmitting: false));
      }
      debugPrint(
        '✅ [ReportsCubit] assigned report $reportId to $userId ($name - $role)',
      );
    } catch (e) {
      debugPrint('❌ [ReportsCubit] assignReportToUser failed: $e');
      final updatedState = state;
      if (updatedState is ReportsLoaded) {
        emit(
          updatedState.copyWith(
            isSubmitting: false,
            errorKey: mapErrorToKey(e),
          ),
        );
      }
    }
  }

  Future<void> updateAssignment(
    String reportId,
    String? assignedRole, {
    String? techName,
  }) async {
    final currentState = state;
    if (currentState is! ReportsLoaded) return;
    try {
      final original = currentState.reports.firstWhere((r) => r.id == reportId);
      final newStatus = assignedRole != null && assignedRole.isNotEmpty
          ? 'W trakcie realizacji'
          : original.status;
      final statusEnum = ReportStatus.fromString(newStatus).dbValue;

      final updated = original.copyWith(
        assignedTo: assignedRole,
        status: newStatus,
        statusEnum: statusEnum,
      );
      await _reportsRepository.updateReport(updated);

      if (assignedRole != null && assignedRole.isNotEmpty) {
        _fcmService.triggerAssignmentNotification(
          reportTitle: original.title,
          assignedRole: assignedRole,
          reportId: reportId,
        );
      }
      if (newStatus != original.status) {
        _fcmService.triggerStatusChangeNotification(
          reportTitle: original.title,
          reporterEmail: original.reporterEmail,
          reportId: reportId,
          newStatus: newStatus,
        );
      }
    } catch (e) {
      debugPrint('❌ [ReportsCubit] updateAssignment failed: $e');
      final s = state;
      if (s is ReportsLoaded) emit(s.copyWith(errorKey: mapErrorToKey(e)));
    }
  }

  Future<void> updateBoardNotes(String reportId, String? boardNotes) async {
    final currentState = state;
    if (currentState is! ReportsLoaded) return;
    try {
      final original = currentState.reports.firstWhere((r) => r.id == reportId);
      final updated = original.copyWith(boardNotes: boardNotes);
      await _reportsRepository.updateReport(updated);
    } catch (e) {
      debugPrint('❌ [ReportsCubit] updateBoardNotes failed: $e');
      final s = state;
      if (s is ReportsLoaded) emit(s.copyWith(errorKey: mapErrorToKey(e)));
    }
  }

  Future<void> updateRevealBoardNotesToTech(
    String reportId,
    bool reveal,
  ) async {
    final currentState = state;
    if (currentState is! ReportsLoaded) return;
    try {
      final original = currentState.reports.firstWhere((r) => r.id == reportId);
      final updated = original.copyWith(revealBoardNotesToTech: reveal);
      await _reportsRepository.updateReport(updated);
    } catch (e) {
      debugPrint('❌ [ReportsCubit] updateRevealBoardNotesToTech failed: $e');
      final s = state;
      if (s is ReportsLoaded) emit(s.copyWith(errorKey: mapErrorToKey(e)));
    }
  }

  Future<void> addAttachmentToReport(
    String reportId,
    String name,
    String type,
    String url,
  ) async {
    final currentState = state;
    if (currentState is! ReportsLoaded) return;
    try {
      final original = currentState.reports.firstWhere((r) => r.id == reportId);
      List<dynamic> currentList = [];
      if (original.attachmentsJson != null &&
          original.attachmentsJson!.isNotEmpty) {
        try {
          currentList = jsonDecode(original.attachmentsJson!);
        } catch (_) {}
      }
      currentList.add({'name': name, 'type': type, 'url': url});
      final newJson = jsonEncode(currentList);
      final updated = original.copyWith(attachmentsJson: newJson);
      await _reportsRepository.updateReport(updated);
    } catch (e) {
      debugPrint('❌ [ReportsCubit] addAttachmentToReport failed: $e');
      final s = state;
      if (s is ReportsLoaded) emit(s.copyWith(errorKey: mapErrorToKey(e)));
    }
  }

  Future<void> updateTechNotes(
    String reportId,
    String? techNotes,
    String status, {
    String? techName,
  }) async {
    final currentState = state;
    if (currentState is! ReportsLoaded) return;
    try {
      final original = currentState.reports.firstWhere((r) => r.id == reportId);
      final statusEnum = ReportStatus.fromString(status).dbValue;
      final updated = original.copyWith(
        techNotes: techNotes,
        status: status,
        statusEnum: statusEnum,
      );
      await _reportsRepository.updateReport(updated);

      if (status != original.status) {
        _fcmService.triggerStatusChangeNotification(
          reportTitle: original.title,
          reporterEmail: original.reporterEmail,
          reportId: reportId,
          newStatus: status,
        );
      }
    } catch (e) {
      debugPrint('❌ [ReportsCubit] updateTechNotes failed: $e');
      final s = state;
      if (s is ReportsLoaded) emit(s.copyWith(errorKey: mapErrorToKey(e)));
    }
  }

  /// Sets the priority on a report and recalculates the SLA deadline.
  Future<void> setReportPriority(
    String reportId,
    ReportPriority priority,
  ) async {
    final currentState = state;
    if (currentState is! ReportsLoaded) return;
    final role = currentState.profile?.role ?? '';
    if (role != 'Zarząd' && role != 'Administrator' && role != 'Ochrona') return;

    try {
      final original = currentState.reports.firstWhere((r) => r.id == reportId);
      final slaDeadline = DateTime.now().add(
        Duration(hours: priority.slaHours),
      );

      final newTrail = List<Map<String, dynamic>>.from(
        original.auditTrail ?? [],
      );
      newTrail.add({
        'action': 'Zmień priorytet na: ${priority.dbValue}',
        'user_id': _currentUserId,
        'user_name': currentState.profile?.name ?? 'Użytkownik',
        'timestamp': DateTime.now().toIso8601String(),
      });

      final updated = original.copyWith(
        priority: priority.dbValue,
        slaDeadline: slaDeadline.toIso8601String(),
        auditTrail: newTrail,
      );
      await _reportsRepository.updateReport(updated);
      debugPrint(
        '✅ [ReportsCubit] priority updated: ${priority.dbValue}, SLA: $slaDeadline',
      );
    } catch (e) {
      debugPrint('❌ [ReportsCubit] setReportPriority failed: $e');
      final updatedState = state;
      if (updatedState is ReportsLoaded) {
        emit(updatedState.copyWith(errorKey: mapErrorToKey(e)));
      }
    }
  }

  Future<void> setReportCategory(String reportId, String category) async {
    final currentState = state;
    if (currentState is! ReportsLoaded) return;
    final role = currentState.profile?.role ?? '';
    if (role != 'Zarząd' && role != 'Administrator') return;

    try {
      final original = currentState.reports.firstWhere((r) => r.id == reportId);
      if (original.category == category) return;

      final newTrail = List<Map<String, dynamic>>.from(
        original.auditTrail ?? [],
      );
      newTrail.add({
        'action': 'Zmień kategorię na: $category',
        'user_id': _currentUserId,
        'user_name': currentState.profile?.name ?? 'Użytkownik',
        'timestamp': DateTime.now().toIso8601String(),
      });

      final updated = original.copyWith(
        category: category,
        auditTrail: newTrail,
      );
      await _reportsRepository.updateReport(updated);
      debugPrint('✅ [ReportsCubit] category updated: $category');
    } catch (e) {
      debugPrint('❌ [ReportsCubit] setReportCategory failed: $e');
      final updatedState = state;
      if (updatedState is ReportsLoaded) {
        emit(updatedState.copyWith(errorKey: mapErrorToKey(e)));
      }
    }
  }

  Future<void> submitCsatRating(String reportId, int rating) async {
    final currentState = state;
    if (currentState is! ReportsLoaded) return;
    final role = currentState.profile?.role ?? '';
    if (role != 'Mieszkaniec') return;

    try {
      final original = currentState.reports.firstWhere((r) => r.id == reportId);

      final newTrail = List<Map<String, dynamic>>.from(
        original.auditTrail ?? [],
      );
      newTrail.add({
        'action': 'Ocena CSAT: $rating/5',
        'user_id': _currentUserId,
        'user_name': currentState.profile?.name ?? 'Użytkownik',
        'timestamp': DateTime.now().toIso8601String(),
      });

      final updated = original.copyWith(
        csatRating: rating,
        auditTrail: newTrail,
      );
      await _reportsRepository.updateReport(updated);
      debugPrint('✅ [ReportsCubit] CSAT rating submitted: $rating');
    } catch (e) {
      debugPrint('❌ [ReportsCubit] submitCsatRating failed: $e');
      final updatedState = state;
      if (updatedState is ReportsLoaded) {
        emit(updatedState.copyWith(errorKey: mapErrorToKey(e)));
      }
    }
  }

  Future<void> removeReport(String id) async {
    final currentState = state;
    if (currentState is! ReportsLoaded) return;
    final profile = currentState.profile;
    final role = profile?.role ?? '';
    if (role != 'Zarząd' && role != 'Administrator') {
      final report = currentState.reports.where((r) => r.id == id).firstOrNull;
      if (report == null || report.reporterEmail != profile?.email) return;
    }
    try {
      await _reportsRepository.deleteReport(id);
    } catch (e) {
      debugPrint('❌ [ReportsCubit] removeReport failed: $e');
      final s = state;
      if (s is ReportsLoaded) emit(s.copyWith(errorKey: mapErrorToKey(e)));
    }
  }

  String _detectRoleFromEmail(String email) {
    final lower = email.toLowerCase();
    if (lower.contains('admin')) return 'Administrator';
    if (lower.contains('board') || lower.contains('zarzad')) return 'Zarząd';
    if (lower.contains('tech') ||
        lower.contains('serwis') ||
        lower.contains('elektryk') ||
        lower.contains('konserwator') ||
        lower.contains('hydraulik')) {
      return 'Serwisant';
    }
    if (lower.contains('ochrona') || lower.contains('security')) {
      return 'Ochrona';
    }
    return 'Mieszkaniec';
  }
}
